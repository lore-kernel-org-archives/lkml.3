Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab3L3VQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 16:16:22 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40081 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab3L3VPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 16:15:39 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 7/7] ARM: msm: Move MSM's DT based hardware to multi-platform support
Date: Mon, 30 Dec 2013 13:15:33 -0800
Message-Id: <1388438133-431-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1388438133-431-1-git-send-email-sboyd@codeaurora.org>
References: <1388438133-431-1-git-send-email-sboyd@codeaurora.org>
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

Arnd acked v1 but this is slightly different due to 8974 coming in.

 arch/arm/Kconfig          |  4 +--
 arch/arm/mach-msm/Kconfig | 80 ++++++++++++++++++++++++-----------------------
 2 files changed, 43 insertions(+), 41 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c1f1a7e..7803a13 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -631,10 +631,10 @@ config ARCH_PXA
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
index ff69e1c..9625cf3 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -1,12 +1,50 @@
+config ARCH_MSM
+	bool
+
+config ARCH_MSM_DT
+	bool "Qualcomm MSM DT Support" if ARCH_MULTI_V7
+	select ARCH_MSM
+	select ARCH_REQUIRE_GPIOLIB
+	select CLKSRC_OF
+	select GENERIC_CLOCKEVENTS
+	help
+	  Support for Qualcomm's devicetree based MSM systems.
+
 if ARCH_MSM
 
-comment "Qualcomm MSM SoC Type"
+menu "Qualcomm MSM SoC Selection"
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
+config ARCH_MSM8974
+	bool "Enable support for MSM8974"
+	select ARM_GIC
+	select CPU_V7
+	select HAVE_ARM_ARCH_TIMER
+	select HAVE_SMP
+	select MSM_SCM if SMP
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
@@ -45,41 +83,6 @@ config ARCH_QSD8X50
 
 endchoice
 
-config ARCH_MSM8X60
-	bool "MSM8X60"
-	select ARCH_MSM_DT
-	select ARM_GIC
-	select CPU_V7
-	select GPIO_MSM_V2
-	select HAVE_SMP
-	select MSM_SCM if SMP
-	select MSM_TIMER
-
-config ARCH_MSM8960
-	bool "MSM8960"
-	select ARCH_MSM_DT
-	select ARM_GIC
-	select CPU_V7
-	select HAVE_SMP
-	select GPIO_MSM_V2
-	select MSM_SCM if SMP
-	select MSM_TIMER
-
-config ARCH_MSM8974
-	bool "MSM8974"
-	select ARCH_MSM_DT
-	select ARM_GIC
-	select CPU_V7
-	select HAVE_ARM_ARCH_TIMER
-	select HAVE_SMP
-	select MSM_SCM if SMP
-	select USE_OF
-
-config ARCH_MSM_DT
-	bool
-	select SPARSE_IRQ
-	select USE_OF
-
 config MSM_HAS_DEBUG_UART_HS
 	bool
 
@@ -96,7 +99,7 @@ config  MSM_VIC
 	bool
 
 menu "Qualcomm MSM Board Type"
-	depends on !ARCH_MSM_DT
+	depends on ARCH_MSM_NODT
 
 config MACH_HALIBUT
 	depends on ARCH_MSM
@@ -144,7 +147,6 @@ config MSM_SMD
 
 config MSM_GPIOMUX
 	bool
-	depends on !ARCH_MSM_DT
 	help
 	  Support for MSM V1 TLMM GPIOMUX architecture.
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

