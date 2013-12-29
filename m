Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab3L2CKl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:10:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55245 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752389Ab3L2CKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:24 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Kevin B. Smith" <kevin.b.smith@intel.com>,
        "Sunil K. Pandey" <sunil.k.pandey@intel.com>,
        "H. J. Lu" <hjl.tools@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.67481407@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 129/185] x86, build: Pass in additional -mno-mmx,
 -mno-sse options
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Drop changes to arch/x86/Makefile, which sets these flags earlier
 - Adjust context
 - Drop changes to arch/x86/realmode/rm/Makefile which doesn't exist]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -51,18 +51,18 @@ $(obj)/cpustr.h: $(obj)/mkcpustr FORCE
 
 # How to compile the 16-bit code.  Note we always compile for -march=i386,
 # that way we can complain to the user if the CPU is insufficient.
-KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
+KBUILD_CFLAGS	:= $(LINUXINCLUDE) -m32 -g -Os -D_SETUP -D__KERNEL__ \
 		   -DDISABLE_BRANCH_PROFILING \
 		   -Wall -Wstrict-prototypes \
 		   -march=i386 -mregparm=3 \
 		   -include $(srctree)/$(src)/code16gcc.h \
 		   -fno-strict-aliasing -fomit-frame-pointer \
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
 
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -12,6 +12,7 @@ KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFIL
 cflags-$(CONFIG_X86_32) := -march=i386
 cflags-$(CONFIG_X86_64) := -mcmodel=small
 KBUILD_CFLAGS += $(cflags-y)
+KBUILD_CFLAGS += -mno-mmx -mno-sse
 KBUILD_CFLAGS += $(call cc-option,-ffreestanding)
 KBUILD_CFLAGS += $(call cc-option,-fno-stack-protector)
 

