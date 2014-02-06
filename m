Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559AbaBFW0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 17:26:34 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37191 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185AbaBFWYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 17:24:52 -0500
From: Kumar Gala <galak@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: Kumar Gala <galak@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/5] ARM: qcom: Split Qualcomm support into legacy and multiplatform
Date: Thu,  6 Feb 2014 16:24:42 -0600
Message-Id: <1391725484-6673-4-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1391725484-6673-1-git-send-email-galak@codeaurora.org>
References: <1391725484-6673-1-git-send-email-galak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new mach-qcom that will support SoCs that intend to be
multiplatform compatible while keeping mach-msm to legacy SoC/board
support that will not transition over to multiplatform.

As part of this, we move support for MSM8X60, MSM8960 and MSM8974 over
to mach-qcom.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 MAINTAINERS                                        |  8 ++++
 arch/arm/Kconfig                                   |  7 ++--
 arch/arm/Kconfig.debug                             |  2 +-
 arch/arm/Makefile                                  |  1 +
 arch/arm/boot/dts/Makefile                         |  6 +--
 arch/arm/mach-msm/Kconfig                          | 45 +---------------------
 arch/arm/mach-msm/Makefile                         |  6 ---
 arch/arm/mach-qcom/Kconfig                         | 33 ++++++++++++++++
 arch/arm/mach-qcom/Makefile                        |  5 +++
 .../arm/{mach-msm/board-dt.c => mach-qcom/board.c} | 13 +++----
 arch/arm/{mach-msm => mach-qcom}/platsmp.c         |  2 +-
 arch/arm/{mach-msm => mach-qcom}/scm-boot.c        |  0
 arch/arm/{mach-msm => mach-qcom}/scm-boot.h        |  0
 arch/arm/{mach-msm => mach-qcom}/scm.c             |  0
 arch/arm/{mach-msm => mach-qcom}/scm.h             |  0
 15 files changed, 64 insertions(+), 64 deletions(-)
 create mode 100644 arch/arm/mach-qcom/Kconfig
 create mode 100644 arch/arm/mach-qcom/Makefile
 rename arch/arm/{mach-msm/board-dt.c => mach-qcom/board.c} (71%)
 rename arch/arm/{mach-msm => mach-qcom}/platsmp.c (98%)
 rename arch/arm/{mach-msm => mach-qcom}/scm-boot.c (100%)
 rename arch/arm/{mach-msm => mach-qcom}/scm-boot.h (100%)
 rename arch/arm/{mach-msm => mach-qcom}/scm.c (100%)
 rename arch/arm/{mach-msm => mach-qcom}/scm.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index b2cf5cf..402be60 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1167,6 +1167,14 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.arm.linux.org.uk/
 S:	Maintained
 
+ARM/QUALCOMM SUPPORT
+M:	Kumar Gala <galak@codeaurora.org>
+M:	David Brown <davidb@codeaurora.org>
+L:	linux-arm-msm@vger.kernel.org
+S:	Maintained
+F:	arch/arm/mach-qcom/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git
+
 ARM/RADISYS ENP2611 MACHINE SUPPORT
 M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e254198..f093f20 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -657,9 +657,8 @@ config ARCH_PXA
 	help
 	  Support for Intel/Marvell's PXA2xx/PXA3xx processor line.
 
-config ARCH_MSM_NODT
-	bool "Qualcomm MSM"
-	select ARCH_MSM
+config ARCH_MSM
+	bool "Qualcomm MSM (non-multiplatform)"
 	select ARCH_REQUIRE_GPIOLIB
 	select COMMON_CLK
 	select GENERIC_CLOCKEVENTS
@@ -1005,6 +1004,8 @@ source "arch/arm/plat-pxa/Kconfig"
 
 source "arch/arm/mach-mmp/Kconfig"
 
+source "arch/arm/mach-qcom/Kconfig"
+
 source "arch/arm/mach-realview/Kconfig"
 
 source "arch/arm/mach-rockchip/Kconfig"
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 0531da8..4491c7b 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -956,7 +956,7 @@ config DEBUG_STI_UART
 
 config DEBUG_MSM_UART
 	bool
-	depends on ARCH_MSM
+	depends on ARCH_MSM || ARCH_QCOM
 
 config DEBUG_LL_INCLUDE
 	string
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 08a9ef5..51e5bed 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -180,6 +180,7 @@ machine-$(CONFIG_ARCH_OMAP2PLUS)	+= omap2
 machine-$(CONFIG_ARCH_ORION5X)		+= orion5x
 machine-$(CONFIG_ARCH_PICOXCELL)	+= picoxcell
 machine-$(CONFIG_ARCH_PXA)		+= pxa
+machine-$(CONFIG_ARCH_QCOM)		+= qcom
 machine-$(CONFIG_ARCH_REALVIEW)		+= realview
 machine-$(CONFIG_ARCH_ROCKCHIP)		+= rockchip
 machine-$(CONFIG_ARCH_RPC)		+= rpc
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index b9d6a8b..c9eaf1f 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -118,9 +118,6 @@ dtb-$(CONFIG_ARCH_KIRKWOOD) += kirkwood-cloudbox.dtb \
 	kirkwood-ts219-6282.dtb
 dtb-$(CONFIG_ARCH_MARCO) += marco-evb.dtb
 dtb-$(CONFIG_ARCH_MOXART) += moxart-uc7112lx.dtb
-dtb-$(CONFIG_ARCH_MSM) += qcom-msm8660-surf.dtb \
-	qcom-msm8960-cdp.dtb \
-	qcom-apq8074-dragonboard.dtb
 dtb-$(CONFIG_ARCH_MVEBU) += armada-370-db.dtb \
 	armada-370-mirabox.dtb \
 	armada-370-netgear-rn102.dtb \
@@ -232,6 +229,9 @@ dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
 	dra7-evm.dtb
 dtb-$(CONFIG_ARCH_ORION5X) += orion5x-lacie-ethernet-disk-mini-v2.dtb
 dtb-$(CONFIG_ARCH_PRIMA2) += prima2-evb.dtb
+dtb-$(CONFIG_ARCH_QCOM) += qcom-msm8660-surf.dtb \
+	qcom-msm8960-cdp.dtb \
+	qcom-apq8074-dragonboard.dtb
 dtb-$(CONFIG_ARCH_U8500) += ste-snowball.dtb \
 	ste-hrefprev60-stuib.dtb \
 	ste-hrefprev60-tvk.dtb \
diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 3c4eca7..a7f959e 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -1,50 +1,9 @@
-config ARCH_MSM
-	bool
-
-config ARCH_MSM_DT
-	bool "Qualcomm MSM DT Support" if ARCH_MULTI_V7
-	select ARCH_MSM
-	select ARCH_REQUIRE_GPIOLIB
-	select CLKSRC_OF
-	select GENERIC_CLOCKEVENTS
-	help
-	  Support for Qualcomm's devicetree based MSM systems.
-
 if ARCH_MSM
 
-menu "Qualcomm MSM SoC Selection"
-	depends on ARCH_MSM_DT
-
-config ARCH_MSM8X60
-	bool "Enable support for MSM8X60"
-	select ARM_GIC
-	select CPU_V7
-	select HAVE_SMP
-	select MSM_SCM if SMP
-	select CLKSRC_QCOM
-
-config ARCH_MSM8960
-	bool "Enable support for MSM8960"
-	select ARM_GIC
-	select CPU_V7
-	select HAVE_SMP
-	select MSM_SCM if SMP
-	select CLKSRC_QCOM
-
-config ARCH_MSM8974
-	bool "Enable support for MSM8974"
-	select ARM_GIC
-	select CPU_V7
-	select HAVE_ARM_ARCH_TIMER
-	select HAVE_SMP
-	select MSM_SCM if SMP
-
-endmenu
-
 choice
 	prompt "Qualcomm MSM SoC Type"
 	default ARCH_MSM7X00A
-	depends on ARCH_MSM_NODT
+	depends on ARCH_MSM
 
 config ARCH_MSM7X00A
 	bool "MSM7x00A / MSM7x01A"
@@ -99,7 +58,7 @@ config  MSM_VIC
 	bool
 
 menu "Qualcomm MSM Board Type"
-	depends on ARCH_MSM_NODT
+	depends on ARCH_MSM
 
 config MACH_HALIBUT
 	depends on ARCH_MSM
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 04b1bee..27c078a 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -13,17 +13,11 @@ obj-$(CONFIG_ARCH_QSD8X50) += dma.o io.o
 
 obj-$(CONFIG_MSM_SMD) += smd.o smd_debug.o
 obj-$(CONFIG_MSM_SMD) += last_radio_log.o
-obj-$(CONFIG_MSM_SCM) += scm.o scm-boot.o
-
-CFLAGS_scm.o :=$(call as-instr,.arch_extension sec,-DREQUIRES_SEC=1)
-
-obj-$(CONFIG_SMP) += platsmp.o
 
 obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o devices-msm7x00.o
 obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o board-trout-panel.o devices-msm7x00.o
 obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
 obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
 obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
-obj-$(CONFIG_ARCH_MSM_DT) += board-dt.o
 obj-$(CONFIG_MSM_GPIOMUX) += gpiomux.o
 obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o
diff --git a/arch/arm/mach-qcom/Kconfig b/arch/arm/mach-qcom/Kconfig
new file mode 100644
index 0000000..a028be2
--- /dev/null
+++ b/arch/arm/mach-qcom/Kconfig
@@ -0,0 +1,33 @@
+config ARCH_QCOM
+	bool "Qualcomm Support" if ARCH_MULTI_V7
+	select ARCH_REQUIRE_GPIOLIB
+	select ARM_GIC
+	select CLKSRC_OF
+	select GENERIC_CLOCKEVENTS
+	select HAVE_SMP
+	select QCOM_SCM if SMP
+	help
+	  Support for Qualcomm's devicetree based systems.
+
+if ARCH_QCOM
+
+menu "Qualcomm SoC Selection"
+
+config ARCH_MSM8X60
+	bool "Enable support for MSM8X60"
+	select CLKSRC_QCOM
+
+config ARCH_MSM8960
+	bool "Enable support for MSM8960"
+	select CLKSRC_QCOM
+
+config ARCH_MSM8974
+	bool "Enable support for MSM8974"
+	select HAVE_ARM_ARCH_TIMER
+
+endmenu
+
+config QCOM_SCM
+	bool
+
+endif
diff --git a/arch/arm/mach-qcom/Makefile b/arch/arm/mach-qcom/Makefile
new file mode 100644
index 0000000..8f756ae
--- /dev/null
+++ b/arch/arm/mach-qcom/Makefile
@@ -0,0 +1,5 @@
+obj-y			:= board.o
+obj-$(CONFIG_SMP)	+= platsmp.o
+obj-$(CONFIG_QCOM_SCM)	+= scm.o scm-boot.o
+
+CFLAGS_scm.o :=$(call as-instr,.arch_extension sec,-DREQUIRES_SEC=1)
diff --git a/arch/arm/mach-msm/board-dt.c b/arch/arm/mach-qcom/board.c
similarity index 71%
rename from arch/arm/mach-msm/board-dt.c
rename to arch/arm/mach-qcom/board.c
index 1f11d93..4529f6b 100644
--- a/arch/arm/mach-msm/board-dt.c
+++ b/arch/arm/mach-qcom/board.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010-2012,2013 The Linux Foundation. All rights reserved.
+/* Copyright (c) 2010-2014 The Linux Foundation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
@@ -17,10 +17,9 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 
-#include "common.h"
+extern struct smp_operations msm_smp_ops;
 
-static const char * const msm_dt_match[] __initconst = {
-	"qcom,msm8660-fluid",
+static const char * const qcom_dt_match[] __initconst = {
 	"qcom,msm8660-surf",
 	"qcom,msm8960-cdp",
 	NULL
@@ -31,11 +30,11 @@ static const char * const apq8074_dt_match[] __initconst = {
 	NULL
 };
 
-DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
+DT_MACHINE_START(QCOM_DT, "Qualcomm (Flattened Device Tree)")
 	.smp = smp_ops(msm_smp_ops),
-	.dt_compat = msm_dt_match,
+	.dt_compat = qcom_dt_match,
 MACHINE_END
 
-DT_MACHINE_START(APQ_DT, "Qualcomm MSM (Flattened Device Tree)")
+DT_MACHINE_START(APQ_DT, "Qualcomm (Flattened Device Tree)")
 	.dt_compat = apq8074_dt_match,
 MACHINE_END
diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-qcom/platsmp.c
similarity index 98%
rename from arch/arm/mach-msm/platsmp.c
rename to arch/arm/mach-qcom/platsmp.c
index 251a91e..67823a7 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-qcom/platsmp.c
@@ -2,6 +2,7 @@
  *  Copyright (C) 2002 ARM Ltd.
  *  All Rights Reserved
  *  Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *  Copyright (c) 2014 The Linux Foundation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -19,7 +20,6 @@
 #include <asm/smp_plat.h>
 
 #include "scm-boot.h"
-#include "common.h"
 
 #define VDD_SC1_ARRAY_CLAMP_GFS_CTL 0x15A0
 #define SCSS_CPU1CORE_RESET 0xD80
diff --git a/arch/arm/mach-msm/scm-boot.c b/arch/arm/mach-qcom/scm-boot.c
similarity index 100%
rename from arch/arm/mach-msm/scm-boot.c
rename to arch/arm/mach-qcom/scm-boot.c
diff --git a/arch/arm/mach-msm/scm-boot.h b/arch/arm/mach-qcom/scm-boot.h
similarity index 100%
rename from arch/arm/mach-msm/scm-boot.h
rename to arch/arm/mach-qcom/scm-boot.h
diff --git a/arch/arm/mach-msm/scm.c b/arch/arm/mach-qcom/scm.c
similarity index 100%
rename from arch/arm/mach-msm/scm.c
rename to arch/arm/mach-qcom/scm.c
diff --git a/arch/arm/mach-msm/scm.h b/arch/arm/mach-qcom/scm.h
similarity index 100%
rename from arch/arm/mach-msm/scm.h
rename to arch/arm/mach-qcom/scm.h
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

