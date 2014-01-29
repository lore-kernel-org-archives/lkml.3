Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaA2R6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 12:58:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45695 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaA2R6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 12:58:01 -0500
Date: Wed, 29 Jan 2014 09:57:25 -0800
From: tip-bot for David Woodhouse <tipbot@zytor.com>
Message-ID: <tip-4d468a094a881033e6559ba09ebae0705d8c0f62@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dwmw2@infradead.org, tglx@linutronix.de, hpa@linux.intel.com,
        David.Woodhouse@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, tglx@linutronix.de, hpa@linux.intel.com,
        David.Woodhouse@intel.com
In-Reply-To: <1390997807.20153.133.camel@i7.infradead.org>
References: <1390997807.20153.133.camel@i7.infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86, build:
  Build 16-bit code with -m16 where possible
Git-Commit-ID: 4d468a094a881033e6559ba09ebae0705d8c0f62
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 29 Jan 2014 09:57:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d468a094a881033e6559ba09ebae0705d8c0f62
Gitweb:     http://git.kernel.org/tip/4d468a094a881033e6559ba09ebae0705d8c0f62
Author:     David Woodhouse <dwmw2@infradead.org>
AuthorDate: Wed, 29 Jan 2014 12:16:47 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 29 Jan 2014 09:55:34 -0800

x86, build: Build 16-bit code with -m16 where possible

Both clang 3.5 and GCC 4.9 will support this (as of r199754 and r207196
respectively). Both have been tested to produce booting kernels when the
16-bit code is built with -m16. (Modulo LLVM PR3997, at least.)

[ hpa: folded test for -m16 into M16_CFLAGS ]

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Link: http://lkml.kernel.org/r/1390997807.20153.133.camel@i7.infradead.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Makefile | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 9ecbc1c..eeda43a 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -13,14 +13,22 @@ endif
 
 # How to compile the 16-bit code.  Note we always compile for -march=i386;
 # that way we can complain to the user if the CPU is insufficient.
-REALMODE_CFLAGS	:= -m32 -g -Os -D__KERNEL__ -DDISABLE_BRANCH_PROFILING \
+#
+# The -m16 option is supported by GCC >= 4.9 and clang >= 3.5. For
+# older versions of GCC, we need to play evil and unreliable tricks to
+# attempt to ensure that our asm(".code16gcc") is first in the asm
+# output.
+CODE16GCC_CFLAGS := -m32 -include $(srctree)/arch/x86/boot/code16gcc.h \
+		    $(call cc-option, -fno-toplevel-reorder,\
+		      $(call cc-option, -fno-unit-at-a-time))
+M16_CFLAGS	 := $(call cc-option, -m16, $(CODE16GCC_CFLAGS))
+
+REALMODE_CFLAGS	:= $(M16_CFLAGS) -g -Os -D__KERNEL__ \
+		   -DDISABLE_BRANCH_PROFILING \
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
