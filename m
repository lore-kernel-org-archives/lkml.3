Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab3FYQLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:11:48 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:36378 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab3FYQLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:11:47 -0400
From: Doug Anderson <dianders@chromium.org>
To: Russell King <rmk+kernel@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>
Cc: Mike Frysinger <vapier@gentoo.org>, Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: Avoid extra calls to the C compiler
Date: Tue, 25 Jun 2013 09:11:36 -0700
Message-Id: <1372176696-5104-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting up the C compiler can be a slow operation on some systems.
Though these calls don't individually take a lot of time, they add up.
Rearrange the ARM Makefile a bit to avoid extra calls to the compiler
when they can be easily avoided.

When running with the Chrome OS ARM cross compiler
"armv7a-cros-linux-gnueabi-", this shaved .55 seconds (from 5.31
seconds to 4.76 seconds) off an incremental build of the kernel:
  time make -j32 ARCH=arm CROSS_COMPILE=armv7a-cros-linux-gnueabi-

Thanks to Mike Frysinger for the clean trick to make this work.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/Makefile | 56 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 1ba358b..49f0c7e 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -59,37 +59,43 @@ comma = ,
 # Note that GCC does not numerically define an architecture version
 # macro, but instead defines a whole series of macros which makes
 # testing for a specific architecture or later rather impossible.
-arch-$(CONFIG_CPU_32v7)		:=-D__LINUX_ARM_ARCH__=7 $(call cc-option,-march=armv7-a,-march=armv5t -Wa$(comma)-march=armv7-a)
-arch-$(CONFIG_CPU_32v6)		:=-D__LINUX_ARM_ARCH__=6 $(call cc-option,-march=armv6,-march=armv5t -Wa$(comma)-march=armv6)
+arch-$(CONFIG_CPU_32v7)		=-D__LINUX_ARM_ARCH__=7 $(call cc-option,-march=armv7-a,-march=armv5t -Wa$(comma)-march=armv7-a)
+arch-$(CONFIG_CPU_32v6)		=-D__LINUX_ARM_ARCH__=6 $(call cc-option,-march=armv6,-march=armv5t -Wa$(comma)-march=armv6)
 # Only override the compiler option if ARMv6. The ARMv6K extensions are
 # always available in ARMv7
 ifeq ($(CONFIG_CPU_32v6),y)
-arch-$(CONFIG_CPU_32v6K)	:=-D__LINUX_ARM_ARCH__=6 $(call cc-option,-march=armv6k,-march=armv5t -Wa$(comma)-march=armv6k)
+arch-$(CONFIG_CPU_32v6K)	=-D__LINUX_ARM_ARCH__=6 $(call cc-option,-march=armv6k,-march=armv5t -Wa$(comma)-march=armv6k)
 endif
-arch-$(CONFIG_CPU_32v5)		:=-D__LINUX_ARM_ARCH__=5 $(call cc-option,-march=armv5te,-march=armv4t)
-arch-$(CONFIG_CPU_32v4T)	:=-D__LINUX_ARM_ARCH__=4 -march=armv4t
-arch-$(CONFIG_CPU_32v4)		:=-D__LINUX_ARM_ARCH__=4 -march=armv4
-arch-$(CONFIG_CPU_32v3)		:=-D__LINUX_ARM_ARCH__=3 -march=armv3
+arch-$(CONFIG_CPU_32v5)		=-D__LINUX_ARM_ARCH__=5 $(call cc-option,-march=armv5te,-march=armv4t)
+arch-$(CONFIG_CPU_32v4T)	=-D__LINUX_ARM_ARCH__=4 -march=armv4t
+arch-$(CONFIG_CPU_32v4)		=-D__LINUX_ARM_ARCH__=4 -march=armv4
+arch-$(CONFIG_CPU_32v3)		=-D__LINUX_ARM_ARCH__=3 -march=armv3
+
+# Evaluate arch cc-option calls now
+arch-y := $(arch-y)
 
 # This selects how we optimise for the processor.
-tune-$(CONFIG_CPU_ARM7TDMI)	:=-mtune=arm7tdmi
-tune-$(CONFIG_CPU_ARM720T)	:=-mtune=arm7tdmi
-tune-$(CONFIG_CPU_ARM740T)	:=-mtune=arm7tdmi
-tune-$(CONFIG_CPU_ARM9TDMI)	:=-mtune=arm9tdmi
-tune-$(CONFIG_CPU_ARM940T)	:=-mtune=arm9tdmi
-tune-$(CONFIG_CPU_ARM946E)	:=$(call cc-option,-mtune=arm9e,-mtune=arm9tdmi)
-tune-$(CONFIG_CPU_ARM920T)	:=-mtune=arm9tdmi
-tune-$(CONFIG_CPU_ARM922T)	:=-mtune=arm9tdmi
-tune-$(CONFIG_CPU_ARM925T)	:=-mtune=arm9tdmi
-tune-$(CONFIG_CPU_ARM926T)	:=-mtune=arm9tdmi
-tune-$(CONFIG_CPU_FA526)	:=-mtune=arm9tdmi
-tune-$(CONFIG_CPU_SA110)	:=-mtune=strongarm110
-tune-$(CONFIG_CPU_SA1100)	:=-mtune=strongarm1100
-tune-$(CONFIG_CPU_XSCALE)	:=$(call cc-option,-mtune=xscale,-mtune=strongarm110) -Wa,-mcpu=xscale
-tune-$(CONFIG_CPU_XSC3)		:=$(call cc-option,-mtune=xscale,-mtune=strongarm110) -Wa,-mcpu=xscale
-tune-$(CONFIG_CPU_FEROCEON)	:=$(call cc-option,-mtune=marvell-f,-mtune=xscale)
-tune-$(CONFIG_CPU_V6)		:=$(call cc-option,-mtune=arm1136j-s,-mtune=strongarm)
-tune-$(CONFIG_CPU_V6K)		:=$(call cc-option,-mtune=arm1136j-s,-mtune=strongarm)
+tune-$(CONFIG_CPU_ARM7TDMI)	=-mtune=arm7tdmi
+tune-$(CONFIG_CPU_ARM720T)	=-mtune=arm7tdmi
+tune-$(CONFIG_CPU_ARM740T)	=-mtune=arm7tdmi
+tune-$(CONFIG_CPU_ARM9TDMI)	=-mtune=arm9tdmi
+tune-$(CONFIG_CPU_ARM940T)	=-mtune=arm9tdmi
+tune-$(CONFIG_CPU_ARM946E)	=$(call cc-option,-mtune=arm9e,-mtune=arm9tdmi)
+tune-$(CONFIG_CPU_ARM920T)	=-mtune=arm9tdmi
+tune-$(CONFIG_CPU_ARM922T)	=-mtune=arm9tdmi
+tune-$(CONFIG_CPU_ARM925T)	=-mtune=arm9tdmi
+tune-$(CONFIG_CPU_ARM926T)	=-mtune=arm9tdmi
+tune-$(CONFIG_CPU_FA526)	=-mtune=arm9tdmi
+tune-$(CONFIG_CPU_SA110)	=-mtune=strongarm110
+tune-$(CONFIG_CPU_SA1100)	=-mtune=strongarm1100
+tune-$(CONFIG_CPU_XSCALE)	=$(call cc-option,-mtune=xscale,-mtune=strongarm110) -Wa,-mcpu=xscale
+tune-$(CONFIG_CPU_XSC3)		=$(call cc-option,-mtune=xscale,-mtune=strongarm110) -Wa,-mcpu=xscale
+tune-$(CONFIG_CPU_FEROCEON)	=$(call cc-option,-mtune=marvell-f,-mtune=xscale)
+tune-$(CONFIG_CPU_V6)		=$(call cc-option,-mtune=arm1136j-s,-mtune=strongarm)
+tune-$(CONFIG_CPU_V6K)		=$(call cc-option,-mtune=arm1136j-s,-mtune=strongarm)
+
+# Evaluate tune cc-option calls now
+tune-y := $(tune-y)
 
 ifeq ($(CONFIG_AEABI),y)
 CFLAGS_ABI	:=-mabi=aapcs-linux -mno-thumb-interwork
-- 
1.8.3

