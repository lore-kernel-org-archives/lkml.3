Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbaAOWNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:13:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41275 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaAOV7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:59:30 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Sunil K. Pandey" <sunil.k.pandey@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. J. Lu" <hjl.tools@gmail.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 030/166] x86, build: Pass in additional -mno-mmx, -mno-sse options
Date: Wed, 15 Jan 2014 13:50:44 -0800
Message-Id: <1389822780-4729-31-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 8b3b005d675726e38bc504d2e35a991e55819155 upstream.

In checkin

    5551a34e5aea x86-64, build: Always pass in -mno-sse

we unconditionally added -mno-sse to the main build, to keep newer
compilers from generating SSE instructions from autovectorization.
However, this did not extend to the special environments
(arch/x86/boot, arch/x86/boot/compressed, and arch/x86/realmode/rm).
Add -mno-sse to the compiler command line for these environments, and
add -mno-mmx to all the environments as well, as we don't want a
compiler to generate MMX code either.

This patch also removes a $(cc-option) call for -m32, since we have
long since stopped supporting compilers too old for the -m32 option,
and in fact hardcode it in other places in the Makefiles.

Reported-by: Kevin B. Smith <kevin.b.smith@intel.com>
Cc: Sunil K. Pandey <sunil.k.pandey@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: H. J. Lu <hjl.tools@gmail.com>
Link: http://lkml.kernel.org/n/tip-j21wzqv790q834n7yc6g80j1@git.kernel.org
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/Makefile                 | 8 ++++----
 arch/x86/boot/Makefile            | 6 +++---
 arch/x86/boot/compressed/Makefile | 1 +
 arch/x86/realmode/rm/Makefile     | 3 ++-
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 8c2ad4e..48e80e0 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -27,8 +27,8 @@ ifeq ($(CONFIG_X86_32),y)
 
         KBUILD_CFLAGS += -msoft-float -mregparm=3 -freg-struct-return
 
-        # Don't autogenerate SSE instructions
-	KBUILD_CFLAGS += -mno-sse
+        # Don't autogenerate MMX or SSE instructions
+        KBUILD_CFLAGS += -mno-mmx -mno-sse
 
         # Never want PIC in a 32-bit kernel, prevent breakage with GCC built
         # with nonstandard options
@@ -56,8 +56,8 @@ else
         KBUILD_AFLAGS += -m64
         KBUILD_CFLAGS += -m64
 
-        # Don't autogenerate SSE instructions
-	KBUILD_CFLAGS += -mno-sse
+        # Don't autogenerate MMX or SSE instructions
+        KBUILD_CFLAGS += -mno-mmx -mno-sse
 
 	# Use -mpreferred-stack-boundary=3 if supported.
 	KBUILD_CFLAGS += $(call cc-option,-mpreferred-stack-boundary=3)
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 379814b..6cf0111 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -53,18 +53,18 @@ $(obj)/cpustr.h: $(obj)/mkcpustr FORCE
 
 # How to compile the 16-bit code.  Note we always compile for -march=i386,
 # that way we can complain to the user if the CPU is insufficient.
-KBUILD_CFLAGS	:= $(USERINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
+KBUILD_CFLAGS	:= $(USERINCLUDE) -m32 -g -Os -D_SETUP -D__KERNEL__ \
 		   -DDISABLE_BRANCH_PROFILING \
 		   -Wall -Wstrict-prototypes \
 		   -march=i386 -mregparm=3 \
 		   -include $(srctree)/$(src)/code16gcc.h \
 		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
+		   -mno-mmx -mno-sse \
 		   $(call cc-option, -ffreestanding) \
 		   $(call cc-option, -fno-toplevel-reorder,\
-			$(call cc-option, -fno-unit-at-a-time)) \
+		   $(call cc-option, -fno-unit-at-a-time)) \
 		   $(call cc-option, -fno-stack-protector) \
 		   $(call cc-option, -mpreferred-stack-boundary=2)
-KBUILD_CFLAGS	+= $(call cc-option, -m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n
 
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 5ef205c..7194d9f 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -12,6 +12,7 @@ KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
 cflags-$(CONFIG_X86_32) := -march=i386
 cflags-$(CONFIG_X86_64) := -mcmodel=small
 KBUILD_CFLAGS += $(cflags-y)
+KBUILD_CFLAGS += -mno-mmx -mno-sse
 KBUILD_CFLAGS += $(call cc-option,-ffreestanding)
 KBUILD_CFLAGS += $(call cc-option,-fno-stack-protector)
 
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 8869287..9cac825 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -73,9 +73,10 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -m32 -g -Os -D_SETUP -D__KERNEL__ -D_WAKEUP \
 		   -march=i386 -mregparm=3 \
 		   -include $(srctree)/$(src)/../../boot/code16gcc.h \
 		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
+		   -mno-mmx -mno-sse \
 		   $(call cc-option, -ffreestanding) \
 		   $(call cc-option, -fno-toplevel-reorder,\
-			$(call cc-option, -fno-unit-at-a-time)) \
+		   $(call cc-option, -fno-unit-at-a-time)) \
 		   $(call cc-option, -fno-stack-protector) \
 		   $(call cc-option, -mpreferred-stack-boundary=2)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
-- 
1.8.3.2

