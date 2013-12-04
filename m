Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268Ab3LDTjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 14:39:32 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52127 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933131Ab3LDTjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:39:18 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/5] ARM: msm: Move MSM's DT based hardware to multi-platform support
Date: Wed,  4 Dec 2013 11:39:12 -0800
Message-Id: <1386185952-27259-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.19.gdaad3aa
In-Reply-To: <1386185952-27259-1-git-send-email-sboyd@codeaurora.org>
References: <1386185952-27259-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DT based MSM platforms can join the multi-platform builds, so
introduce a DT based ARCH_MSM option. This option allows DT based
MSM platforms to be built into the multi-platform kernel. Also
introduce a hidden ARCH_MSM config that both the DT and non-DT
platform support code select to avoid churn in places that depend
on CONFIG_ARCH_MSM.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/Kconfig          |  4 ++--
 arch/arm/mach-msm/Kconfig | 61 +++++++++++++++++++++++++----------------------
 2 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 603d661..d056118 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -630,10 +630,10 @@ config ARCH_PXA
 	help
 	  Support for Intel/Marvell's PXA2xx/PXA3xx processor line.
 
-config ARCH_MSM
+config ARCH_MSM_NODT
 	bool "Qualcomm MSM"
+	select ARCH_MSM
 	select ARCH_REQUIRE_GPIOLIB
-	select CLKSRC_OF if OF
 	select COMMON_CLK
 	select GENERIC_CLOCKEVENTS
 	help
diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 47cd2df..73c7ff3 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -1,12 +1,42 @@
+config ARCH_MSM
+	bool
+
+config ARCH_MSM_DT
+	bool "Qualcomm MSM DT support" if ARCH_MULTI_V7
+	select ARCH_MSM
+	select ARCH_REQUIRE_GPIOLIB
+	select CLKSRC_OF
+	select GENERIC_CLOCKEVENTS
+	help
+	  Support for Qualcomm's DT-based MSM systems.
+
 if ARCH_MSM
 
-comment "Qualcomm MSM SoC Type"
+menu "Qualcomm MSM SoC selection"
 	depends on ARCH_MSM_DT
 
+config ARCH_MSM8X60
+	bool "Enable support for MSM8X60"
+	select ARM_GIC
+	select CPU_V7
+	select HAVE_SMP
+	select MSM_SCM if SMP
+	select MSM_TIMER
+
+config ARCH_MSM8960
+	bool "Enable support for MSM8960"
+	select ARM_GIC
+	select CPU_V7
+	select HAVE_SMP
+	select MSM_SCM if SMP
+	select MSM_TIMER
+
+endmenu
+
 choice
 	prompt "Qualcomm MSM SoC Type"
 	default ARCH_MSM7X00A
-	depends on !ARCH_MSM_DT
+	depends on ARCH_MSM_NODT
 
 config ARCH_MSM7X00A
 	bool "MSM7x00A / MSM7x01A"
@@ -45,30 +75,6 @@ config ARCH_QSD8X50
 
 endchoice
 
-config ARCH_MSM8X60
-	bool "MSM8X60"
-	select ARM_GIC
-	select CPU_V7
-	select GPIO_MSM_V2
-	select HAVE_SMP
-	select MSM_SCM if SMP
-	select MSM_TIMER
-
-config ARCH_MSM8960
-	bool "MSM8960"
-	select ARM_GIC
-	select CPU_V7
-	select HAVE_SMP
-	select GPIO_MSM_V2
-	select MSM_SCM if SMP
-	select MSM_TIMER
-
-config ARCH_MSM_DT
-	def_bool y
-	depends on (ARCH_MSM8X60 || ARCH_MSM8960)
-	select SPARSE_IRQ
-	select USE_OF
-
 config MSM_HAS_DEBUG_UART_HS
 	bool
 
@@ -85,7 +91,7 @@ config  MSM_VIC
 	bool
 
 menu "Qualcomm MSM Board Type"
-	depends on !ARCH_MSM_DT
+	depends on ARCH_MSM_NODT
 
 config MACH_HALIBUT
 	depends on ARCH_MSM
@@ -133,7 +139,6 @@ config MSM_SMD
 
 config MSM_GPIOMUX
 	bool
-	depends on !ARCH_MSM_DT
 	help
 	  Support for MSM V1 TLMM GPIOMUX architecture.
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

