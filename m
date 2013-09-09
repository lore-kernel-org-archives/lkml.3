Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab3IIXC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 19:02:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56306 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab3IIXCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 19:02:24 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: msm: Create a common board-dt and config ARCH_MSM_DT
Date: Mon,  9 Sep 2013 16:01:59 -0700
Message-Id: <1378767719-27688-2-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1378767719-27688-1-git-send-email-rvaswani@codeaurora.org>
References: <1378767719-27688-1-git-send-email-rvaswani@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a config ARCH_MSM_DT and common board-dt.c
to encapsulate the MSM DT based targets.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig         | 13 +++++++----
 arch/arm/mach-msm/Makefile        |  3 +--
 arch/arm/mach-msm/board-dt-8660.c | 48 ---------------------------------------
 arch/arm/mach-msm/board-dt-8960.c | 35 ----------------------------
 arch/arm/mach-msm/board-dt.c      | 32 ++++++++++++++++++++++++++
 5 files changed, 42 insertions(+), 89 deletions(-)
 delete mode 100644 arch/arm/mach-msm/board-dt-8660.c
 delete mode 100644 arch/arm/mach-msm/board-dt-8960.c
 create mode 100644 arch/arm/mach-msm/board-dt.c

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 020240c..2586c28 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -1,12 +1,12 @@
 if ARCH_MSM
 
 comment "Qualcomm MSM SoC Type"
-	depends on (ARCH_MSM8X60 || ARCH_MSM8960)
+	depends on ARCH_MSM_DT
 
 choice
 	prompt "Qualcomm MSM SoC Type"
 	default ARCH_MSM7X00A
-	depends on !(ARCH_MSM8X60 || ARCH_MSM8960)
+	depends on !ARCH_MSM_DT
 
 config ARCH_MSM7X00A
 	bool "MSM7x00A / MSM7x01A"
@@ -49,8 +49,6 @@ config ARCH_MSM8X60
 	select GPIO_MSM_V2
 	select HAVE_SMP
 	select MSM_SCM if SMP
-	select SPARSE_IRQ
-	select USE_OF
 
 config ARCH_MSM8960
 	bool "MSM8960"
@@ -59,6 +57,10 @@ config ARCH_MSM8960
 	select HAVE_SMP
 	select GPIO_MSM_V2
 	select MSM_SCM if SMP
+
+config ARCH_MSM_DT
+	def_bool y
+	depends on (ARCH_MSM8X60 || ARCH_MSM8960)
 	select SPARSE_IRQ
 	select USE_OF
 
@@ -70,6 +72,7 @@ config MSM_SOC_REV_A
 
 config  ARCH_MSM_ARM11
 	bool
+
 config  ARCH_MSM_SCORPION
 	bool
 
@@ -77,6 +80,7 @@ config  MSM_VIC
 	bool
 
 menu "Qualcomm MSM Board Type"
+	depends on !ARCH_MSM_DT
 
 config MACH_HALIBUT
 	depends on ARCH_MSM
@@ -124,6 +128,7 @@ config MSM_SMD
 
 config MSM_GPIOMUX
 	bool
+	depends on !ARCH_MSM_DT
 	help
 	  Support for MSM V1 TLMM GPIOMUX architecture.
 
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index d872634..7ed4c1b 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -26,7 +26,6 @@ obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o b
 obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
 obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
 obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
-obj-$(CONFIG_ARCH_MSM8X60) += board-dt-8660.o
-obj-$(CONFIG_ARCH_MSM8960) += board-dt-8960.o
+obj-$(CONFIG_ARCH_MSM_DT) += board-dt.o
 obj-$(CONFIG_MSM_GPIOMUX) += gpiomux.o
 obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o
diff --git a/arch/arm/mach-msm/board-dt-8660.c b/arch/arm/mach-msm/board-dt-8660.c
deleted file mode 100644
index c294689..0000000
--- a/arch/arm/mach-msm/board-dt-8660.c
+++ /dev/null
@@ -1,48 +0,0 @@
-/* Copyright (c) 2010-2012, The Linux Foundation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/init.h>
-#include <linux/of.h>
-#include <linux/of_platform.h>
-
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-
-#include "common.h"
-
-static void __init msm8x60_init_late(void)
-{
-	smd_debugfs_init();
-}
-
-static struct of_dev_auxdata msm_auxdata_lookup[] __initdata = {
-	{}
-};
-
-static void __init msm8x60_dt_init(void)
-{
-	of_platform_populate(NULL, of_default_bus_match_table,
-			msm_auxdata_lookup, NULL);
-}
-
-static const char *msm8x60_fluid_match[] __initdata = {
-	"qcom,msm8660-fluid",
-	"qcom,msm8660-surf",
-	NULL
-};
-
-DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
-	.smp = smp_ops(msm_smp_ops),
-	.init_machine = msm8x60_dt_init,
-	.init_late = msm8x60_init_late,
-	.dt_compat = msm8x60_fluid_match,
-MACHINE_END
diff --git a/arch/arm/mach-msm/board-dt-8960.c b/arch/arm/mach-msm/board-dt-8960.c
deleted file mode 100644
index d4ca52c..0000000
--- a/arch/arm/mach-msm/board-dt-8960.c
+++ /dev/null
@@ -1,35 +0,0 @@
-/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/init.h>
-#include <linux/of_platform.h>
-
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-
-#include "common.h"
-
-static void __init msm_dt_init(void)
-{
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-}
-
-static const char * const msm8960_dt_match[] __initconst = {
-	"qcom,msm8960-cdp",
-	NULL
-};
-
-DT_MACHINE_START(MSM8960_DT, "Qualcomm MSM (Flattened Device Tree)")
-	.smp = smp_ops(msm_smp_ops),
-	.init_machine = msm_dt_init,
-	.dt_compat = msm8960_dt_match,
-MACHINE_END
diff --git a/arch/arm/mach-msm/board-dt.c b/arch/arm/mach-msm/board-dt.c
new file mode 100644
index 0000000..c140c53
--- /dev/null
+++ b/arch/arm/mach-msm/board-dt.c
@@ -0,0 +1,32 @@
+/* Copyright (c) 2010-2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+
+#include "common.h"
+
+static const char *msm_dt_match[] __initdata = {
+	"qcom,msm8660-fluid",
+	"qcom,msm8660-surf",
+	"qcom,msm8960-cdp",
+	NULL
+};
+
+DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
+	.smp = smp_ops(msm_smp_ops),
+	.dt_compat = msm_dt_match,
+MACHINE_END
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

