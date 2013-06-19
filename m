Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903Ab3FSAFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:05:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35505 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933820Ab3FSAEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:04:48 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC/PATCH 11/11] ARM: msm: Move MSM's DT based hardware to multi-platform support
Date: Tue, 18 Jun 2013 17:04:41 -0700
Message-Id: <1371600281-6118-12-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.448.gfb7dfaa
In-Reply-To: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
References: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
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

RFC because this has problems with msm_sdcc and usb_otg using
mach specific APIs. See the cover letter for more details.

 arch/arm/Kconfig          |  3 ++-
 arch/arm/mach-msm/Kconfig | 55 +++++++++++++++++++++++++++++------------------
 2 files changed, 36 insertions(+), 22 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 430c922..22d4fff 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -618,8 +618,9 @@ config ARCH_PXA
 	help
 	  Support for Intel/Marvell's PXA2xx/PXA3xx processor line.
 
-config ARCH_MSM
+config ARCH_MSM_NODT
 	bool "Qualcomm MSM"
+	select ARCH_MSM
 	select ARCH_REQUIRE_GPIOLIB
 	select CLKDEV_LOOKUP
 	select CLKSRC_OF if OF
diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 614e41e..09f996a 100644
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
+	select CLKSRC_OF if OF
+	select GENERIC_CLOCKEVENTS
+	help
+	  Support for Qualcomm's DT-based MSM systems.
+
 if ARCH_MSM
 
-comment "Qualcomm MSM SoC Type"
-	depends on (ARCH_MSM8X60 || ARCH_MSM8960)
+menu "MSM options"
+	depends on ARCH_MSM_DT
+
+config ARCH_MSM8X60
+	bool "Enable support for MSM8X60"
+	select ARM_GIC
+	select CPU_V7
+	select GPIO_MSM_V2
+	select HAVE_SMP
+	select MSM_SCM if SMP
+
+config ARCH_MSM8960
+	bool "Enable support for MSM8960"
+	select ARM_GIC
+	select CPU_V7
+	select HAVE_SMP
+	select GPIO_MSM_V2
+	select MSM_SCM if SMP
+
+endmenu
 
 choice
 	prompt "Qualcomm MSM SoC Type"
 	default ARCH_MSM7X00A
-	depends on !(ARCH_MSM8X60 || ARCH_MSM8960)
+	depends on ARCH_MSM_NODT
 
 config ARCH_MSM7X00A
 	bool "MSM7x00A / MSM7x01A"
@@ -42,24 +72,6 @@ config ARCH_QSD8X50
 
 endchoice
 
-config ARCH_MSM8X60
-	bool "MSM8X60"
-	select ARM_GIC
-	select CPU_V7
-	select GPIO_MSM_V2
-	select HAVE_SMP
-	select MSM_SCM if SMP
-	select USE_OF
-
-config ARCH_MSM8960
-	bool "MSM8960"
-	select ARM_GIC
-	select CPU_V7
-	select HAVE_SMP
-	select GPIO_MSM_V2
-	select MSM_SCM if SMP
-	select USE_OF
-
 config MSM_HAS_DEBUG_UART_HS
 	bool
 
@@ -75,6 +87,7 @@ config  MSM_VIC
 	bool
 
 menu "Qualcomm MSM Board Type"
+	depends on ARCH_MSM_NODT
 
 config MACH_HALIBUT
 	depends on ARCH_MSM
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

