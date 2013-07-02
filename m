Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab3GBLFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:05:23 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:53089 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab3GBLDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:03:55 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/7] ARM: dove: convert to DT irqchip and clocksource
Date: Tue,  2 Jul 2013 13:03:40 +0200
Message-Id: <1372763023-12374-5-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1372763023-12374-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1372763023-12374-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With recent support for true irqchip and clocksource drivers for Orion
SoCs, now make use of it on DT enabled Dove boards.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
--- 
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-dove/Kconfig    |    2 ++
 arch/arm/mach-dove/Makefile   |    4 ++--
 arch/arm/mach-dove/board-dt.c |   23 ++++++++++++++++-------
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-dove/Kconfig b/arch/arm/mach-dove/Kconfig
index dff7b2f..0bc7cdf 100644
--- a/arch/arm/mach-dove/Kconfig
+++ b/arch/arm/mach-dove/Kconfig
@@ -23,6 +23,8 @@ config MACH_CM_A510
 config MACH_DOVE_DT
 	bool "Marvell Dove Flattened Device Tree"
 	select DOVE_CLK
+	select ORION_IRQCHIP
+	select ORION_TIMER
 	select REGULATOR
 	select REGULATOR_FIXED_VOLTAGE
 	select USE_OF
diff --git a/arch/arm/mach-dove/Makefile b/arch/arm/mach-dove/Makefile
index 4d9d2ff..cbc5c06 100644
--- a/arch/arm/mach-dove/Makefile
+++ b/arch/arm/mach-dove/Makefile
@@ -1,5 +1,5 @@
-obj-y				+= common.o irq.o
-obj-$(CONFIG_DOVE_LEGACY)	+= mpp.o
+obj-y				+= common.o
+obj-$(CONFIG_DOVE_LEGACY)	+= irq.o mpp.o
 obj-$(CONFIG_PCI)		+= pcie.o
 obj-$(CONFIG_MACH_DOVE_DB)	+= dove-db-setup.o
 obj-$(CONFIG_MACH_DOVE_DT)	+= board-dt.o
diff --git a/arch/arm/mach-dove/board-dt.c b/arch/arm/mach-dove/board-dt.c
index b5ccc1c..49f72a8 100644
--- a/arch/arm/mach-dove/board-dt.c
+++ b/arch/arm/mach-dove/board-dt.c
@@ -10,11 +10,14 @@
 
 #include <linux/init.h>
 #include <linux/clk-provider.h>
+#include <linux/clocksource.h>
+#include <linux/irqchip.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/platform_data/usb-ehci-orion.h>
 #include <asm/hardware/cache-tauros2.h>
 #include <asm/mach/arch.h>
+#include <mach/dove.h>
 #include <mach/pm.h>
 #include <plat/common.h>
 #include <plat/irq.h>
@@ -42,10 +45,17 @@ static void __init dove_legacy_clk_init(void)
 			 of_clk_get_from_provider(&clkspec));
 }
 
-static void __init dove_of_clk_init(void)
+static void __init dove_dt_time_init(void)
 {
 	of_clk_init(NULL);
-	dove_legacy_clk_init();
+	clocksource_of_init();
+}
+
+static void __init dove_dt_init_early(void)
+{
+	mvebu_mbus_init("marvell,dove-mbus",
+			BRIDGE_WINS_BASE, BRIDGE_WINS_SZ,
+			DOVE_MC_WINS_BASE, DOVE_MC_WINS_SZ);
 }
 
 static void __init dove_dt_init(void)
@@ -57,8 +67,8 @@ static void __init dove_dt_init(void)
 #endif
 	dove_setup_cpu_wins();
 
-	/* Setup root of clk tree */
-	dove_of_clk_init();
+	/* Setup clocks for legacy devices */
+	dove_legacy_clk_init();
 
 	/* Internal devices not ported to DT yet */
 	dove_pcie_init(1, 1);
@@ -73,9 +83,8 @@ static const char * const dove_dt_board_compat[] = {
 
 DT_MACHINE_START(DOVE_DT, "Marvell Dove (Flattened Device Tree)")
 	.map_io		= dove_map_io,
-	.init_early	= dove_init_early,
-	.init_irq	= orion_dt_init_irq,
-	.init_time	= dove_timer_init,
+	.init_early	= dove_dt_init_early,
+	.init_time	= dove_dt_time_init,
 	.init_machine	= dove_dt_init,
 	.restart	= dove_restart,
 	.dt_compat	= dove_dt_board_compat,
-- 
1.7.2.5

