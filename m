Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaHDLgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:36:47 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:37805 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaHDLgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:36:46 -0400
Date: Mon, 4 Aug 2014 13:36:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/build change for v3.17
Message-ID: <20140804113636.GA25578@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-build-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-build-for-linus

   # HEAD: a9cfccee6604854aebc70215610b9788667f4fec x86, build: Change code16gcc.h from a C header to an assembly header

Robustify the build process with a quirk to avoid GCC reordering 
related bugs.

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86, build: Change code16gcc.h from a C header to an assembly header


 arch/x86/Makefile         |  9 +++------
 arch/x86/boot/code16gcc.h | 24 ++++++++++--------------
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 602f57e..a98cc90 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -15,12 +15,9 @@ endif
 # that way we can complain to the user if the CPU is insufficient.
 #
 # The -m16 option is supported by GCC >= 4.9 and clang >= 3.5. For
-# older versions of GCC, we need to play evil and unreliable tricks to
-# attempt to ensure that our asm(".code16gcc") is first in the asm
-# output.
-CODE16GCC_CFLAGS := -m32 -include $(srctree)/arch/x86/boot/code16gcc.h \
-		    $(call cc-option, -fno-toplevel-reorder,\
-		      $(call cc-option, -fno-unit-at-a-time))
+# older versions of GCC, include an *assembly* header to make sure that
+# gcc doesn't play any games behind our back.
+CODE16GCC_CFLAGS := -m32 -Wa,$(srctree)/arch/x86/boot/code16gcc.h
 M16_CFLAGS	 := $(call cc-option, -m16, $(CODE16GCC_CFLAGS))
 
 REALMODE_CFLAGS	:= $(M16_CFLAGS) -g -Os -D__KERNEL__ \
diff --git a/arch/x86/boot/code16gcc.h b/arch/x86/boot/code16gcc.h
index d93e480..5ff4265 100644
--- a/arch/x86/boot/code16gcc.h
+++ b/arch/x86/boot/code16gcc.h
@@ -1,15 +1,11 @@
-/*
- * code16gcc.h
- *
- * This file is -include'd when compiling 16-bit C code.
- * Note: this asm() needs to be emitted before gcc emits any code.
- * Depending on gcc version, this requires -fno-unit-at-a-time or
- * -fno-toplevel-reorder.
- *
- * Hopefully gcc will eventually have a real -m16 option so we can
- * drop this hack long term.
- */
+#
+# code16gcc.h
+#
+# This file is added to the assembler via -Wa when compiling 16-bit C code.
+# This is done this way instead via asm() to make sure gcc does not reorder
+# things around us.
+#
+# gcc 4.9+ has a real -m16 option so we can drop this hack long term.
+#
 
-#ifndef __ASSEMBLY__
-asm(".code16gcc");
-#endif
+	.code16gcc
