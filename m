Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaDCVyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 17:54:38 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:60725 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaDCVyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 17:54:37 -0400
From: Alex Elder <elder@linaro.org>
To: bcm@fixthebug.org, mporter@linaro.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] mach-bcm: clean up config and build targets
Date: Thu,  3 Apr 2014 16:55:04 -0500
Message-Id: <1396562104-2457-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently CONFIG_ARCH_BCM_MOBILE is used to select all Broadcom
mobile SoCs.  Instead, use that only as a config menu switch, and
define specific symbols like CONFIG_ARCH_BCM_281XX to select
a particular SoC family.  If ARCH_BCM_MOBILE is selected, all
of the SoCs will be selected by default, but this way each can be
disabled individually as well.

This allows more precision in controlling what gets built under
mach-bcm.  Another benefit to doing this is that it makes it obvious
that the code that implements SMC calls to control L2 cache is only
used for BCM281XX (for example).

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2:  No longer uses Kbuild's $(<modulename>-y) variable mechanism.

Note:
This patch is based on the current arm-soc/for-next branch:
    e98cd72 arm-soc: document samsung merges

The patch is available here:
    http://git.linaro.org/landing-teams/working/broadcom/kernel.git
    Branch review/mach-bcm-cleanup-v2

 arch/arm/mach-bcm/Kconfig  |   28 ++++++++++++++++++++++++----
 arch/arm/mach-bcm/Makefile |   15 +++++++++++----
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index 21f97f7..183fdef 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -10,7 +10,7 @@ if ARCH_BCM
 menu "Broadcom SoC Selection"
 
 config ARCH_BCM_MOBILE
-	bool "Broadcom Mobile SoC" if ARCH_MULTI_V7
+	bool "Broadcom Mobile SoC Support" if ARCH_MULTI_V7
 	depends on MMU
 	select ARCH_REQUIRE_GPIOLIB
 	select ARM_ERRATA_754322
@@ -23,9 +23,29 @@ config ARCH_BCM_MOBILE
 	select PINCTRL
 	help
 	  This enables support for systems based on Broadcom mobile SoCs.
-	  It currently supports the 'BCM281XX' family, which includes
-	  BCM11130, BCM11140, BCM11351, BCM28145 and
-	  BCM28155 variants.
+
+if ARCH_BCM_MOBILE
+
+menu "Broadcom Mobile SoC Selection"
+
+config ARCH_BCM_281XX
+	bool "Broadcom BCM281XX SoC family"
+	default y
+	help
+	  Enable support for the the BCM281XX family, which includes
+	  BCM11130, BCM11140, BCM11351, BCM28145 and BCM28155
+	  variants.
+
+config ARCH_BCM_21664
+	bool "Broadcom BCM21664 SoC family"
+	default y
+	help
+	  Enable support for the the BCM21664 family, which includes
+	  BCM21663 and BCM21664 variants.
+
+endmenu
+
+endif
 
 
 config ARCH_BCM2835
diff --git a/arch/arm/mach-bcm/Makefile b/arch/arm/mach-bcm/Makefile
index a326b28..ac1f5cc 100644
--- a/arch/arm/mach-bcm/Makefile
+++ b/arch/arm/mach-bcm/Makefile
@@ -10,10 +10,17 @@
 # of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 
-obj-$(CONFIG_ARCH_BCM_MOBILE)	:= board_bcm281xx.o board_bcm21664.o \
-				bcm_kona_smc.o bcm_kona_smc_asm.o kona.o
-obj-$(CONFIG_ARCH_BCM2835)	+= board_bcm2835.o
-
+# BCM281XX
+obj-$(CONFIG_ARCH_BCM_281XX)	:= board_bcm281xx.o
+obj-$(CONFIG_ARCH_BCM_281XX)	+= bcm_kona_smc.o bcm_kona_smc_asm.o kona.o
 plus_sec := $(call as-instr,.arch_extension sec,+sec)
 AFLAGS_bcm_kona_smc_asm.o	:=-Wa,-march=armv7-a$(plus_sec)
+
+# BCM21664
+obj-$(CONFIG_ARCH_BCM_21664)	+= board_bcm21664.o
+
+# BCM2835
+obj-$(CONFIG_ARCH_BCM2835)	+= board_bcm2835.o
+
+# BCM5301X
 obj-$(CONFIG_ARCH_BCM_5301X)	+= bcm_5301x.o
-- 
1.7.9.5

