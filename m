Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561Ab3EBS0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:26:05 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:63817 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932708Ab3EBS0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:26:01 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ARM: dove: add DT parsing for legacy mv643xx_eth
Date: Thu,  2 May 2013 20:25:38 +0200
Message-Id: <1367519140-19716-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1367519140-19716-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1367519140-19716-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To allow to move to orion irqchip driver, existing legacy devices
have to map their irqs. This patch adds a node for mv643xx_eth and
some init code to map the corresponding irqs. While the device tree
node can stay, the init code will vanish as soon as there is true
device tree support for mv643xx_eth.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/dove.dtsi   |    7 +++++++
 arch/arm/mach-dove/board-dt.c |   31 ++++++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index f7509ca..ea7c5da 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -197,6 +197,13 @@
 			status = "disabled";
 		};
 
+		gbe: ethernet-controller {
+			compatible = "marvell,mv643xx-eth-block";
+			reg = <0x72000 0x4000>;
+			interrupts = <29>, <30>;
+			status = "disabled";
+		};
+
 		rtc@d8500 {
 			compatible = "marvell,orion-rtc";
 			reg = <0xd8500 0x20>;
diff --git a/arch/arm/mach-dove/board-dt.c b/arch/arm/mach-dove/board-dt.c
index fbde1dd..9df6dd7 100644
--- a/arch/arm/mach-dove/board-dt.c
+++ b/arch/arm/mach-dove/board-dt.c
@@ -12,6 +12,7 @@
 #include <linux/clk-provider.h>
 #include <linux/clk/mvebu.h>
 #include <linux/of.h>
+#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/platform_data/usb-ehci-orion.h>
 #include <asm/hardware/cache-tauros2.h>
@@ -57,6 +58,34 @@ static struct mv643xx_eth_platform_data dove_dt_ge00_data = {
 	.phy_addr = MV643XX_ETH_PHY_ADDR_DEFAULT,
 };
 
+#define DOVE_GE00_PHYS_BASE	0xf1070000
+
+static void __init dove_legacy_ge00_init(void)
+{
+	struct device_node *np = of_find_compatible_node(NULL, NULL,
+					 "marvell,mv643xx-eth-block");
+	int irq_sum, irq_err;
+
+	if (!np)
+		return;
+
+	irq_sum = irq_of_parse_and_map(np, 0);
+	if (!irq_sum) {
+		pr_err("%s: missing sum irq\n", np->full_name);
+		return;
+	}
+
+	irq_err = irq_of_parse_and_map(np, 1);
+	if (!irq_err) {
+		pr_err("%s: missing err irq\n", np->full_name);
+		return;
+	}
+
+	/* legacy ge00_init wants phys base */
+	orion_ge00_init(&dove_dt_ge00_data, DOVE_GE00_PHYS_BASE,
+			irq_sum, irq_err, 1600);
+}
+
 static void __init dove_dt_init(void)
 {
 	pr_info("Dove 88AP510 SoC\n");
@@ -70,7 +99,7 @@ static void __init dove_dt_init(void)
 	dove_of_clk_init();
 
 	/* Internal devices not ported to DT yet */
-	dove_ge00_init(&dove_dt_ge00_data);
+	dove_legacy_ge00_init();
 	dove_pcie_init(1, 1);
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-- 
1.7.2.5

