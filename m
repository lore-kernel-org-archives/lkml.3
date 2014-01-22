Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaAVCEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 21:04:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50117 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbaAVCEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 21:04:02 -0500
Date: Tue, 21 Jan 2014 18:03:41 -0800
From: tip-bot for David Woodhouse <tipbot@zytor.com>
Message-ID: <tip-01aa3d17aa39991aa62ccd48b3122417bbca4ef3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, David.Woodhouse@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, David.Woodhouse@intel.com
In-Reply-To: <1389180083-23249-1-git-send-email-David.Woodhouse@intel.com>
References: <1389180083-23249-1-git-send-email-David.Woodhouse@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86: Remove duplication of 16-bit CFLAGS
Git-Commit-ID: 01aa3d17aa39991aa62ccd48b3122417bbca4ef3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 21 Jan 2014 18:03:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01aa3d17aa39991aa62ccd48b3122417bbca4ef3
Gitweb:     http://git.kernel.org/tip/01aa3d17aa39991aa62ccd48b3122417bbca4ef3
Author:     David Woodhouse <David.Woodhouse@intel.com>
AuthorDate: Wed, 8 Jan 2014 11:21:20 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 21 Jan 2014 17:59:27 -0800

x86: Remove duplication of 16-bit CFLAGS

Define them once in arch/x86/Makefile instead of twice.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Link: http://lkml.kernel.org/r/1389180083-23249-1-git-send-email-David.Woodhouse@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Makefile             | 14 ++++++++++++++
 arch/x86/boot/Makefile        | 15 +--------------
 arch/x86/realmode/rm/Makefile | 17 ++---------------
 3 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 13b22e0..9ecbc1c 100644
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
index de70669..878df7e 100644
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
