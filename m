Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaDVGIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:08:52 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60375 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaDVGIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:08:49 -0400
From: behanw@converseincode.com
To: linux@arm.linux.org.uk, damm@opensource.se, kim.phillips@freescale.com,
        laurent.pinchart+renesas@ideasonboard.com, kyungsik.lee@lge.com,
        linus.walleij@linaro.org
Cc: horms+renesas@verge.net.au, akpm@linux-foundation.org,
        geert@linux-m68k.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <charlebm@gmail.com>
Subject: [PATCH] Kbuild arm: LLVMLinux: Add Kbuild support for building arch arm with Clang
Date: Mon, 21 Apr 2014 23:08:18 -0700
Message-Id: <1398146898-15009-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

Protect more options for arm with cc-option so that we don't get errors when
using clang instead of gcc.  Add more or different options when using clang as
well.

Author: Behan Webster <behanw@converseincode.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 arch/arm/Makefile                 | 16 ++++++++++++----
 arch/arm/boot/compressed/Makefile |  2 +-
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 41c1931..60412ce 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -23,6 +23,14 @@ OBJCOPYFLAGS	:=-O binary -R .comment -S
 GZFLAGS		:=-9
 #KBUILD_CFLAGS	+=-pipe
 
+ifeq ($(COMPILER),clang)
+# Clang options
+ifneq ($(CROSS_COMPILE),)
+KBUILD_CPPFLAGS	+= -target $(CROSS_COMPILE:-=)
+endif
+KBUILD_CFLAGS   += -fno-builtin -Wno-asm-operand-widths -Xassembler -mno-warn-deprecated
+endif
+
 # Never generate .eh_frame
 KBUILD_CFLAGS	+= $(call cc-option,-fno-dwarf2-cfi-asm)
 
@@ -41,11 +49,11 @@ KBUILD_CFLAGS	+=-fno-omit-frame-pointer -mapcs -mno-sched-prolog
 endif
 
 ifeq ($(CONFIG_CPU_BIG_ENDIAN),y)
-KBUILD_CPPFLAGS	+= -mbig-endian
+KBUILD_CPPFLAGS	+= $(call cc-option,-mbig-endian,)
 AS		+= -EB
 LD		+= -EB
 else
-KBUILD_CPPFLAGS	+= -mlittle-endian
+KBUILD_CPPFLAGS	+= $(call cc-option,-mlittle-endian,)
 AS		+= -EL
 LD		+= -EL
 endif
@@ -96,7 +104,7 @@ tune-$(CONFIG_CPU_V6K)		=$(call cc-option,-mtune=arm1136j-s,-mtune=strongarm)
 tune-y := $(tune-y)
 
 ifeq ($(CONFIG_AEABI),y)
-CFLAGS_ABI	:=-mabi=aapcs-linux -mno-thumb-interwork -mfpu=vfp
+CFLAGS_ABI	:=-mabi=aapcs-linux $(call cc-option,-mno-thumb-interwork,) -mfpu=vfp
 else
 CFLAGS_ABI	:=$(call cc-option,-mapcs-32,-mabi=apcs-gnu) $(call cc-option,-mno-thumb-interwork,)
 endif
@@ -120,7 +128,7 @@ AFLAGS_ISA	:=$(CFLAGS_ISA)
 endif
 
 # Need -Uarm for gcc < 3.x
-KBUILD_CFLAGS	+=$(CFLAGS_ABI) $(CFLAGS_ISA) $(arch-y) $(tune-y) $(call cc-option,-mshort-load-bytes,$(call cc-option,-malignment-traps,)) -msoft-float -Uarm
+KBUILD_CFLAGS	+=$(CFLAGS_ABI) $(CFLAGS_ISA) $(arch-y) $(tune-y) $(call cc-option,-mshort-load-bytes,$(call cc-option,-malignment-traps,)) -msoft-float $(call cc-option, -Uarm,)
 KBUILD_AFLAGS	+=$(CFLAGS_ABI) $(AFLAGS_ISA) $(arch-y) $(tune-y) -include asm/unified.h -msoft-float
 
 CHECKFLAGS	+= -D__arm__
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 68c9183..9aee36e 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -121,7 +121,7 @@ ORIG_CFLAGS := $(KBUILD_CFLAGS)
 KBUILD_CFLAGS = $(subst -pg, , $(ORIG_CFLAGS))
 endif
 
-ccflags-y := -fpic -mno-single-pic-base -fno-builtin -I$(obj)
+ccflags-y := -fpic $(call cc-option,-mno-single-pic-base,) -fno-builtin -I$(obj)
 asflags-y := -DZIMAGE
 
 # Supply kernel BSS size to the decompressor via a linker symbol.
-- 
1.8.3.2

