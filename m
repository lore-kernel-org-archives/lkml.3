Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaCAIjv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 03:39:51 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:44657 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaCAIjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 03:39:49 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] ARM: mvebu: move DT Dove to MVEBU
Date: Sat,  1 Mar 2014 09:39:38 +0100
Message-Id: <1393663178-22120-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1393538613-28293-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1393538613-28293-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With all the DT support preparation done, we are able to move Dove
to MVEBU easily. Legacy non-DT mach-dove is left untouched to rot
for a while before removal.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- just rename CONFIG_ARCH_DOVE to CONFIG_MACH_DOVE in dts/Makefile
  (Suggested by Jason Cooper)
v2->v3:
- dropped drivers/phy/Kconfig change, which is now an individual
  patch sent to Kishon.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/Makefile    |  2 +-
 arch/arm/mach-dove/Kconfig    | 12 ------------
 arch/arm/mach-dove/Makefile   |  1 -
 arch/arm/mach-dove/board-dt.c | 43 -------------------------------------------
 arch/arm/mach-mvebu/Kconfig   | 12 ++++++++++++
 arch/arm/mach-mvebu/Makefile  |  1 +
 arch/arm/mach-mvebu/dove.c    | 39 +++++++++++++++++++++++++++++++++++++++
 7 files changed, 53 insertions(+), 57 deletions(-)
 delete mode 100644 arch/arm/mach-dove/board-dt.c
 create mode 100644 arch/arm/mach-mvebu/dove.c

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 032030361bef..21317af7fe48 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -55,7 +55,7 @@ dtb-$(CONFIG_ARCH_BERLIN) += \
 	berlin2cd-google-chromecast.dtb
 dtb-$(CONFIG_ARCH_DAVINCI) += da850-enbw-cmc.dtb \
 	da850-evm.dtb
-dtb-$(CONFIG_ARCH_DOVE) += dove-cm-a510.dtb \
+dtb-$(CONFIG_MACH_DOVE) += dove-cm-a510.dtb \
 	dove-cubox.dtb \
 	dove-d2plug.dtb \
 	dove-d3plug.dtb \
diff --git a/arch/arm/mach-dove/Kconfig b/arch/arm/mach-dove/Kconfig
index 0bc7cdf8cf46..d8c439c89ea9 100644
--- a/arch/arm/mach-dove/Kconfig
+++ b/arch/arm/mach-dove/Kconfig
@@ -20,18 +20,6 @@ config MACH_CM_A510
 	  Say 'Y' here if you want your kernel to support the
 	  CompuLab CM-A510 Board.
 
-config MACH_DOVE_DT
-	bool "Marvell Dove Flattened Device Tree"
-	select DOVE_CLK
-	select ORION_IRQCHIP
-	select ORION_TIMER
-	select REGULATOR
-	select REGULATOR_FIXED_VOLTAGE
-	select USE_OF
-	help
-	  Say 'Y' here if you want your kernel to support the
-	  Marvell Dove using flattened device tree.
-
 endmenu
 
 endif
diff --git a/arch/arm/mach-dove/Makefile b/arch/arm/mach-dove/Makefile
index cbc5c0618788..b608a21919fb 100644
--- a/arch/arm/mach-dove/Makefile
+++ b/arch/arm/mach-dove/Makefile
@@ -2,5 +2,4 @@ obj-y				+= common.o
 obj-$(CONFIG_DOVE_LEGACY)	+= irq.o mpp.o
 obj-$(CONFIG_PCI)		+= pcie.o
 obj-$(CONFIG_MACH_DOVE_DB)	+= dove-db-setup.o
-obj-$(CONFIG_MACH_DOVE_DT)	+= board-dt.o
 obj-$(CONFIG_MACH_CM_A510)	+= cm-a510.o
diff --git a/arch/arm/mach-dove/board-dt.c b/arch/arm/mach-dove/board-dt.c
deleted file mode 100644
index 49fa9abd09da..000000000000
--- a/arch/arm/mach-dove/board-dt.c
+++ /dev/null
@@ -1,43 +0,0 @@
-/*
- * arch/arm/mach-dove/board-dt.c
- *
- * Marvell Dove 88AP510 System On Chip FDT Board
- *
- * This file is licensed under the terms of the GNU General Public
- * License version 2.  This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
- */
-
-#include <linux/init.h>
-#include <linux/clk-provider.h>
-#include <linux/of.h>
-#include <linux/of_platform.h>
-#include <asm/hardware/cache-tauros2.h>
-#include <asm/mach/arch.h>
-#include <mach/dove.h>
-#include <mach/pm.h>
-#include <plat/common.h>
-#include "common.h"
-
-static void __init dove_dt_init(void)
-{
-	pr_info("Dove 88AP510 SoC\n");
-
-#ifdef CONFIG_CACHE_TAUROS2
-	tauros2_init(0);
-#endif
-	BUG_ON(mvebu_mbus_dt_init());
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-}
-
-static const char * const dove_dt_board_compat[] = {
-	"marvell,dove",
-	NULL
-};
-
-DT_MACHINE_START(DOVE_DT, "Marvell Dove (Flattened Device Tree)")
-	.map_io		= dove_map_io,
-	.init_machine	= dove_dt_init,
-	.restart	= dove_restart,
-	.dt_compat	= dove_dt_board_compat,
-MACHINE_END
diff --git a/arch/arm/mach-mvebu/Kconfig b/arch/arm/mach-mvebu/Kconfig
index 5e269d7263ce..966e5c6b9944 100644
--- a/arch/arm/mach-mvebu/Kconfig
+++ b/arch/arm/mach-mvebu/Kconfig
@@ -46,6 +46,18 @@ config MACH_ARMADA_XP
 	  Say 'Y' here if you want your kernel to support boards based
 	  on the Marvell Armada XP SoC with device tree.
 
+config MACH_DOVE
+	bool "Marvell Dove boards" if ARCH_MULTI_V7
+	select CACHE_L2X0
+	select CPU_PJ4
+	select DOVE_CLK
+	select ORION_IRQCHIP
+	select ORION_TIMER
+	select PINCTRL_DOVE
+	help
+	  Say 'Y' here if you want your kernel to support the
+	  Marvell Dove using flattened device tree.
+
 endmenu
 
 endif
diff --git a/arch/arm/mach-mvebu/Makefile b/arch/arm/mach-mvebu/Makefile
index 878aebe98dcc..dd3e7188f75d 100644
--- a/arch/arm/mach-mvebu/Makefile
+++ b/arch/arm/mach-mvebu/Makefile
@@ -5,6 +5,7 @@ AFLAGS_coherency_ll.o		:= -Wa,-march=armv7-a
 
 obj-y				 += system-controller.o mvebu-soc-id.o
 obj-$(CONFIG_MACH_ARMADA_370_XP) += armada-370-xp.o
+obj-$(CONFIG_MACH_DOVE)		 += dove.o
 obj-$(CONFIG_ARCH_MVEBU)	 += coherency.o coherency_ll.o pmsu.o
 obj-$(CONFIG_SMP)                += platsmp.o headsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)        += hotplug.o
diff --git a/arch/arm/mach-mvebu/dove.c b/arch/arm/mach-mvebu/dove.c
new file mode 100644
index 000000000000..5e5a43624237
--- /dev/null
+++ b/arch/arm/mach-mvebu/dove.c
@@ -0,0 +1,39 @@
+/*
+ * arch/arm/mach-mvebu/dove.c
+ *
+ * Marvell Dove 88AP510 System On Chip FDT Board
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/init.h>
+#include <linux/mbus.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <asm/hardware/cache-tauros2.h>
+#include <asm/mach/arch.h>
+#include "common.h"
+
+static void __init dove_init(void)
+{
+	pr_info("Dove 88AP510 SoC\n");
+
+#ifdef CONFIG_CACHE_TAUROS2
+	tauros2_init(0);
+#endif
+	BUG_ON(mvebu_mbus_dt_init());
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+static const char * const dove_dt_compat[] = {
+	"marvell,dove",
+	NULL
+};
+
+DT_MACHINE_START(DOVE_DT, "Marvell Dove")
+	.init_machine	= dove_init,
+	.restart	= mvebu_restart,
+	.dt_compat	= dove_dt_compat,
+MACHINE_END
-- 
1.8.5.3

