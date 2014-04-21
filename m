Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbaDUVxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:53:39 -0400
Received: from mail-yk0-f180.google.com ([209.85.160.180]:57554 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258AbaDUVxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:53:34 -0400
From: Alex Elder <elder@linaro.org>
To: bcm@fixthebug.org, mporter@linaro.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/10] ARM: bcm: config option for l2 cache support
Date: Mon, 21 Apr 2014 16:53:07 -0500
Message-Id: <1398117191-2433-7-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398117191-2433-1-git-send-email-elder@linaro.org>
References: <1398117191-2433-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new config option ARCH_BCM_MOBILE_L2_CACHE that allows support
for level-2 cache to be enabled or disabled at build time for
BCM218XX and BCM21664 family SoCs.

Build support for SMC only if it's required (currently it's only
required for to support level 2 cache control).

If arch/arm/mach-bcm/kona.c gets compiled, ARCH_BCM_MOBILE_L2_CACHE
must have been selected, which implies CONFIG_CACHE_L2X0 is set.
There is therefore no need to check CONFIG_CACHE_L2X0 at the top
of kona_l2_cache_init(), so get rid of that check.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <mporter@linaro.org>
---
 arch/arm/mach-bcm/Kconfig  | 12 +++++++++++-
 arch/arm/mach-bcm/Makefile |  5 ++++-
 arch/arm/mach-bcm/kona.c   |  3 ---
 arch/arm/mach-bcm/kona.h   |  5 +++++
 4 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index 5f5740f..28f90a0 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -18,7 +18,6 @@ config ARCH_BCM_MOBILE
 	select ARM_GIC
 	select GPIO_BCM_KONA
 	select TICK_ONESHOT
-	select CACHE_L2X0
 	select HAVE_ARM_ARCH_TIMER
 	select PINCTRL
 	help
@@ -43,6 +42,17 @@ config ARCH_BCM_21664
 	  Enable support for the the BCM21664 family, which includes
 	  BCM21663 and BCM21664 variants.
 
+config ARCH_BCM_MOBILE_L2_CACHE
+	bool "Broadcom mobile SoC level 2 cache support"
+	depends on (ARCH_BCM_281XX || ARCH_BCM_21664)
+	default y
+	select CACHE_L2X0
+	select ARCH_BCM_MOBILE_SMC
+
+config ARCH_BCM_MOBILE_SMC
+	bool
+	depends on ARCH_BCM_281XX || ARCH_BCM_21664
+
 endmenu
 
 endif
diff --git a/arch/arm/mach-bcm/Makefile b/arch/arm/mach-bcm/Makefile
index 7fb9b04..5154981 100644
--- a/arch/arm/mach-bcm/Makefile
+++ b/arch/arm/mach-bcm/Makefile
@@ -17,7 +17,10 @@ obj-$(CONFIG_ARCH_BCM_281XX)	+= board_bcm281xx.o
 obj-$(CONFIG_ARCH_BCM_21664)	+= board_bcm21664.o
 
 # BCM281XX and BCM21664 L2 cache control
-obj-$(CONFIG_ARCH_BCM_MOBILE)	+= bcm_kona_smc.o bcm_kona_smc_asm.o kona.o
+obj-$(CONFIG_ARCH_BCM_MOBILE_L2_CACHE) += kona.o
+
+# Support for secure monitor traps
+obj-$(CONFIG_ARCH_BCM_MOBILE_SMC) += bcm_kona_smc.o bcm_kona_smc_asm.o
 plus_sec := $(call as-instr,.arch_extension sec,+sec)
 AFLAGS_bcm_kona_smc_asm.o	:=-Wa,-march=armv7-a$(plus_sec)
 
diff --git a/arch/arm/mach-bcm/kona.c b/arch/arm/mach-bcm/kona.c
index ecdd713..60b5dd5 100644
--- a/arch/arm/mach-bcm/kona.c
+++ b/arch/arm/mach-bcm/kona.c
@@ -22,9 +22,6 @@ void __init kona_l2_cache_init(void)
 	unsigned int result;
 	int ret;
 
-	if (!IS_ENABLED(CONFIG_CACHE_L2X0))
-		return;
-
 	ret = bcm_kona_smc_init();
 	if (ret) {
 		pr_info("Secure API not available (%d). Skipping L2 init.\n",
diff --git a/arch/arm/mach-bcm/kona.h b/arch/arm/mach-bcm/kona.h
index 3a7a017..110185f 100644
--- a/arch/arm/mach-bcm/kona.h
+++ b/arch/arm/mach-bcm/kona.h
@@ -11,4 +11,9 @@
  * GNU General Public License for more details.
  */
 
+#ifdef CONFIG_ARCH_BCM_MOBILE_L2_CACHE
+
 void __init kona_l2_cache_init(void);
+#else
+#define kona_l2_cache_init() ((void)0)
+#endif
-- 
1.9.1

