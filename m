Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196Ab3JDKR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:17:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41641 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3JDKRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:17:55 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v3] ARM: kirkwood: retain MAC address for DT ethernet
Date: Fri,  4 Oct 2013 12:17:22 +0200
Message-Id: <1380881842-24605-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1380826568-18587-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1380826568-18587-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ethernet IP on Kirkwood SoCs loose their MAC address register content
if clock gated. To allow modular ethernet driver setups and gated clocks
also on non-DT capable bootloaders, we fixup port device nodes with no
valid MAC address property. This patch copies MAC address register
contents set up by bootloaders early, notably before ethernet clocks
are gated. While at it, also reorder call sequence in _dt_init.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v2->v3:
- make use of new public clk_is_enabled (adds dependency [1])
- add warning about gated clock && missing MAC property
  (Suggested by Jason Gunthorpe)
v1->v2:
- check for gated clock before accessing eth registers
  (Suggested by Andrew Lunn)

[1] http://www.spinics.net/lists/arm-kernel/msg277392.html

Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-kirkwood/board-dt.c |   85 +++++++++++++++++++++++++++++++++++--
 1 file changed, 82 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-kirkwood/board-dt.c b/arch/arm/mach-kirkwood/board-dt.c
index 82d3ad8..28e952b 100644
--- a/arch/arm/mach-kirkwood/board-dt.c
+++ b/arch/arm/mach-kirkwood/board-dt.c
@@ -13,6 +13,8 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_net.h>
 #include <linux/of_platform.h>
 #include <linux/clk-provider.h>
 #include <linux/clocksource.h>
@@ -66,6 +68,84 @@ static void __init kirkwood_legacy_clk_init(void)
 	clk_prepare_enable(clk);
 }
 
+#define MV643XX_ETH_MAC_ADDR_LOW	0x0414
+#define MV643XX_ETH_MAC_ADDR_HIGH	0x0418
+
+static void __init kirkwood_dt_eth_fixup(void)
+{
+	struct device_node *np;
+
+	/*
+	 * The ethernet interfaces forget the MAC address assigned by u-boot
+	 * if the clocks are turned off. Usually, u-boot on kirkwood boards
+	 * has no DT support to properly set local-mac-address property.
+	 * As a workaround, we get the MAC address from mv643xx_eth registers
+	 * and update the port device node if no valid MAC address is set.
+	 */
+	for_each_compatible_node(np, NULL, "marvell,kirkwood-eth-port") {
+		struct device_node *pnp = of_get_parent(np);
+		struct clk *clk;
+		struct property *pmac;
+		void __iomem *io;
+		u8 *macaddr;
+		u32 reg;
+
+		if (!pnp)
+			continue;
+
+		/* skip disabled nodes or nodes with valid MAC address*/
+		if (!of_device_is_available(pnp) || of_get_mac_address(np))
+			continue;
+
+		/* skip already gated ports, spill warning about missing MAC */
+		clk = of_clk_get(pnp, 0);
+		if (!clk_is_enabled(clk)) {
+			pr_err(FW_BUG "%s: gated port has no local-mac-address set\n",
+			       np->full_name);
+			clk_put(clk);
+			continue;
+		}
+		clk_put(clk);
+
+		/* store MAC address register contents in local-mac-address */
+		pr_err(FW_BUG "%s: local-mac-address is not set\n",
+		       np->full_name);
+
+		io = of_iomap(pnp, 0);
+		if (!io)
+			continue;
+
+		pmac = kzalloc(sizeof(*pmac) + 6, GFP_KERNEL);
+		if (!pmac) {
+			iounmap(io);
+			continue;
+		}
+
+		pmac->value = pmac + 1;
+		pmac->length = 6;
+		pmac->name = kstrdup("local-mac-address", GFP_KERNEL);
+		if (!pmac->name) {
+			kfree(pmac);
+			iounmap(io);
+			continue;
+		}
+
+		macaddr = pmac->value;
+		reg = readl(io + MV643XX_ETH_MAC_ADDR_HIGH);
+		macaddr[0] = (reg >> 24) & 0xff;
+		macaddr[1] = (reg >> 16) & 0xff;
+		macaddr[2] = (reg >> 8) & 0xff;
+		macaddr[3] = reg & 0xff;
+
+		reg = readl(io + MV643XX_ETH_MAC_ADDR_LOW);
+		macaddr[4] = (reg >> 8) & 0xff;
+		macaddr[5] = reg & 0xff;
+
+		of_update_property(np, pmac);
+		iounmap(io);
+	}
+}
+
 static void __init kirkwood_dt_time_init(void)
 {
 	of_clk_init(NULL);
@@ -97,11 +177,10 @@ static void __init kirkwood_dt_init(void)
 	kirkwood_l2_init();
 
 	kirkwood_cpufreq_init();
-
+	kirkwood_cpuidle_init();
 	/* Setup clocks for legacy devices */
 	kirkwood_legacy_clk_init();
-
-	kirkwood_cpuidle_init();
+	kirkwood_dt_eth_fixup();
 
 #ifdef CONFIG_KEXEC
 	kexec_reinit = kirkwood_enable_pcie;
-- 
1.7.10.4

