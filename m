Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab3JRLy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:54:29 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:36340 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab3JRLyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:54:24 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: kirkwood: remove lagacy clk workarounds
Date: Fri, 18 Oct 2013 13:54:13 +0200
Message-Id: <1382097253-15624-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With legacy devices converted to DT and a proper ethernet MAC
workaround, we can now remove the clk workarounds for legacy
devices. While at it, also cleanup the list of includes.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
As a follow-up patch for latest mvebu PRs, this patch is based on
 git://git.infradead.org/linux-mvebu.git tags/soc-3.13-2

Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-kirkwood/board-dt.c |   42 ++----------------------------------
 1 files changed, 3 insertions(+), 39 deletions(-)

diff --git a/arch/arm/mach-kirkwood/board-dt.c b/arch/arm/mach-kirkwood/board-dt.c
index 27c1877..3f5984e 100644
--- a/arch/arm/mach-kirkwood/board-dt.c
+++ b/arch/arm/mach-kirkwood/board-dt.c
@@ -10,56 +10,22 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <linux/clk.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_net.h>
 #include <linux/of_platform.h>
 #include <linux/clk-provider.h>
 #include <linux/clocksource.h>
-#include <linux/dma-mapping.h>
-#include <linux/irqchip.h>
-#include <linux/kexec.h>
+#include <linux/slab.h>
 #include <asm/mach/arch.h>
-#include <asm/mach/map.h>
 #include <mach/bridge-regs.h>
-#include <linux/platform_data/usb-ehci-orion.h>
-#include <plat/irq.h>
 #include <plat/common.h>
 #include "common.h"
 
-/*
- * There are still devices that doesn't know about DT yet.  Get clock
- * gates here and add a clock lookup alias, so that old platform
- * devices still work.
-*/
-
-static void __init kirkwood_legacy_clk_init(void)
-{
-
-	struct device_node *np = of_find_compatible_node(
-		NULL, NULL, "marvell,kirkwood-gating-clock");
-	struct of_phandle_args clkspec;
-	struct clk *clk;
-
-	clkspec.np = np;
-	clkspec.args_count = 1;
-
-	/*
-	 * The ethernet interfaces forget the MAC address assigned by
-	 * u-boot if the clocks are turned off. Until proper DT support
-	 * is available we always enable them for now.
-	 */
-	clkspec.args[0] = CGC_BIT_GE0;
-	clk = of_clk_get_from_provider(&clkspec);
-	clk_prepare_enable(clk);
-
-	clkspec.args[0] = CGC_BIT_GE1;
-	clk = of_clk_get_from_provider(&clkspec);
-	clk_prepare_enable(clk);
-}
-
 #define MV643XX_ETH_MAC_ADDR_LOW	0x0414
 #define MV643XX_ETH_MAC_ADDR_HIGH	0x0418
 
@@ -164,8 +130,6 @@ static void __init kirkwood_dt_init(void)
 
 	kirkwood_cpufreq_init();
 	kirkwood_cpuidle_init();
-	/* Setup clocks for legacy devices */
-	kirkwood_legacy_clk_init();
 
 	kirkwood_pm_init();
 	kirkwood_dt_eth_fixup();
-- 
1.7.2.5

