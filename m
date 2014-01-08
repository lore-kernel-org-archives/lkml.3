Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbaAHLV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:21:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55327 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbaAHLV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:21:26 -0500
From: David Woodhouse <David.Woodhouse@intel.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, llvmlinux@lists.linuxfoundation.org
Subject: [PATCH 1/4] x86: Remove duplication of 16-bit CFLAGS
Date: Wed,  8 Jan 2014 11:21:20 +0000
Message-Id: <1389180083-23249-1-git-send-email-David.Woodhouse@intel.com>
X-Mailer: git-send-email 1.8.4.2
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define them once in arch/x86/Makefile instead of twice

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 arch/x86/Makefile             | 14 ++++++++++++++
 arch/x86/boot/Makefile        | 15 +--------------
 arch/x86/realmode/rm/Makefile | 17 ++---------------
 3 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 3c54657..ef19271 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -11,6 +11,20 @@ else
         KBUILD_DEFCONFIG := $(ARCH)_defconfig
 endif
 
+# How to compile the 16-bit code.  Note we always compile for -march=i386;
+# that way we can complain to the user if the CPU is insufficient.
+REALMODE_CFLAGS	:= -m32 -g -Os -D__KERNEL__ -DDISABLE_BRANCH_PROFILING \
+		   -Wall -Wstrict-prototypes -march=i386 -mregparm=3 \
+		   -include $(srctree)/arch/x86/boot/code16gcc.h \
+		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
+		   -mno-mmx -mno-sse \
+		   $(call cc-option, -ffreestanding) \
+		   $(call cc-option, -fno-toplevel-reorder,\
+		   $(call cc-option, -fno-unit-at-a-time)) \
+		   $(call cc-option, -fno-stack-protector) \
+		   $(call cc-option, -mpreferred-stack-boundary=2)
+export REALMODE_CFLAGS
+
 # BITS is used as extension for files which are available in a 32 bit
 # and a 64 bit version to simplify shared Makefiles.
 # e.g.: obj-y += foo_$(BITS).o
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index d9c1195..7c2b0a1 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -51,20 +51,7 @@ $(obj)/cpustr.h: $(obj)/mkcpustr FORCE
 
 # ---------------------------------------------------------------------------
 
-# How to compile the 16-bit code.  Note we always compile for -march=i386,
-# that way we can complain to the user if the CPU is insufficient.
-KBUILD_CFLAGS	:= $(USERINCLUDE) -m32 -g -Os -D_SETUP -D__KERNEL__ \
-		   -DDISABLE_BRANCH_PROFILING \
-		   -Wall -Wstrict-prototypes \
-		   -march=i386 -mregparm=3 \
-		   -include $(srctree)/$(src)/code16gcc.h \
-		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
-		   -mno-mmx -mno-sse \
-		   $(call cc-option, -ffreestanding) \
-		   $(call cc-option, -fno-toplevel-reorder,\
-		   $(call cc-option, -fno-unit-at-a-time)) \
-		   $(call cc-option, -fno-stack-protector) \
-		   $(call cc-option, -mpreferred-stack-boundary=2)
+KBUILD_CFLAGS	:= $(USERINCLUDE) $(REALMODE_CFLAGS) -D_SETUP
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n
 
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 9cac825..3497f14 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -64,20 +64,7 @@ $(obj)/realmode.relocs: $(obj)/realmode.elf FORCE
 
 # ---------------------------------------------------------------------------
 
-# How to compile the 16-bit code.  Note we always compile for -march=i386,
-# that way we can complain to the user if the CPU is insufficient.
-KBUILD_CFLAGS	:= $(LINUXINCLUDE) -m32 -g -Os -D_SETUP -D__KERNEL__ -D_WAKEUP \
-		   -I$(srctree)/arch/x86/boot \
-		   -DDISABLE_BRANCH_PROFILING \
-		   -Wall -Wstrict-prototypes \
-		   -march=i386 -mregparm=3 \
-		   -include $(srctree)/$(src)/../../boot/code16gcc.h \
-		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
-		   -mno-mmx -mno-sse \
-		   $(call cc-option, -ffreestanding) \
-		   $(call cc-option, -fno-toplevel-reorder,\
-		   $(call cc-option, -fno-unit-at-a-time)) \
-		   $(call cc-option, -fno-stack-protector) \
-		   $(call cc-option, -mpreferred-stack-boundary=2)
+KBUILD_CFLAGS	:= $(LINUXINCLUDE) $(REALMODE_CFLAGS) -D_SETUP -D_WAKEUP \
+		   -I$(srctree)/arch/x86/boot
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n
-- 
1.8.4.2

