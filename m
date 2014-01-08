Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbaAHLV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:21:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55326 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaAHLV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:21:26 -0500
From: David Woodhouse <David.Woodhouse@intel.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, llvmlinux@lists.linuxfoundation.org
Subject: [PATCH 3/4] x86: Allow building 16-bit code with -m16 with toolchains that support it
Date: Wed,  8 Jan 2014 11:21:22 +0000
Message-Id: <1389180083-23249-3-git-send-email-David.Woodhouse@intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389180083-23249-1-git-send-email-David.Woodhouse@intel.com>
References: <1389180083-23249-1-git-send-email-David.Woodhouse@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have this working with LLVM/Clang, and a PR is filed for GCC because
the current hacks we have to do to *try* to ensure that .code16gcc is
the first thing in the asm output are horrid.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 arch/x86/Makefile | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index ef19271..60fc67d 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -13,14 +13,21 @@ endif
 
 # How to compile the 16-bit code.  Note we always compile for -march=i386;
 # that way we can complain to the user if the CPU is insufficient.
-REALMODE_CFLAGS	:= -m32 -g -Os -D__KERNEL__ -DDISABLE_BRANCH_PROFILING \
+#
+# We really want GCC to have a -m16 option like clang, so that we don't
+# have to play these evil and unreliable tricks to ensure that our
+# asm(".code16gcc") is first in the asm output. http://gcc.gnu.org/PR59672
+CODE16GCC_CFLAGS := -m32 -include $(srctree)/arch/x86/boot/code16gcc.h \
+		    $(call cc-option, -fno-toplevel-reorder,\
+		      $(call cc-option, -fno-unit-at-a-time))
+M16_CFLAGS	 := -m16
+
+REALMODE_CFLAGS	:= -g -Os -D__KERNEL__ -DDISABLE_BRANCH_PROFILING \
+		   $(call cc-option, $(M16_CFLAGS), $(CODE16GCC_CFLAGS)) \
 		   -Wall -Wstrict-prototypes -march=i386 -mregparm=3 \
-		   -include $(srctree)/arch/x86/boot/code16gcc.h \
 		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
 		   -mno-mmx -mno-sse \
 		   $(call cc-option, -ffreestanding) \
-		   $(call cc-option, -fno-toplevel-reorder,\
-		   $(call cc-option, -fno-unit-at-a-time)) \
 		   $(call cc-option, -fno-stack-protector) \
 		   $(call cc-option, -mpreferred-stack-boundary=2)
 export REALMODE_CFLAGS
-- 
1.8.4.2

