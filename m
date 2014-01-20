Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbaATOAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 09:00:52 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:49385 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaATOAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:00:50 -0500
Date: Mon, 20 Jan 2014 15:00:47 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/build changes for v3.14
Message-ID: <20140120140046.GA12622@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-build-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-build-for-linus

   # HEAD: 6f34152f54bcf63a49ea701643c81f5b2168fec8 x86, boot: Move intcall() to the .inittext section

Misc smaller improvements.

 Thanks,

	Ingo

------------------>
David Woodhouse (1):
      x86, boot: Use .code16 instead of .code16gcc

H. Peter Anvin (1):
      x86, boot: Move intcall() to the .inittext section

Steven Rostedt (1):
      x86, sparse: Do not force removal of __user when calling copy_to/from_user_nocheck()


 arch/x86/boot/bioscall.S          |  6 +++---
 arch/x86/boot/copy.S              | 22 +++++++++++-----------
 arch/x86/include/asm/uaccess_64.h |  4 ++--
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/boot/bioscall.S b/arch/x86/boot/bioscall.S
index 1dfbf64..d401b4a 100644
--- a/arch/x86/boot/bioscall.S
+++ b/arch/x86/boot/bioscall.S
@@ -1,6 +1,6 @@
 /* -----------------------------------------------------------------------
  *
- *   Copyright 2009 Intel Corporation; author H. Peter Anvin
+ *   Copyright 2009-2014 Intel Corporation; author H. Peter Anvin
  *
  *   This file is part of the Linux kernel, and is made available under
  *   the terms of the GNU General Public License version 2 or (at your
@@ -13,8 +13,8 @@
  * touching registers they shouldn't be.
  */
 
-	.code16gcc
-	.text
+	.code16
+	.section ".inittext","ax"
 	.globl	intcall
 	.type	intcall, @function
 intcall:
diff --git a/arch/x86/boot/copy.S b/arch/x86/boot/copy.S
index 11f272c..1eb7d29 100644
--- a/arch/x86/boot/copy.S
+++ b/arch/x86/boot/copy.S
@@ -14,7 +14,7 @@
  * Memory copy routines
  */
 
-	.code16gcc
+	.code16
 	.text
 
 GLOBAL(memcpy)
@@ -30,7 +30,7 @@ GLOBAL(memcpy)
 	rep; movsb
 	popw	%di
 	popw	%si
-	ret
+	retl
 ENDPROC(memcpy)
 
 GLOBAL(memset)
@@ -45,25 +45,25 @@ GLOBAL(memset)
 	andw	$3, %cx
 	rep; stosb
 	popw	%di
-	ret
+	retl
 ENDPROC(memset)
 
 GLOBAL(copy_from_fs)
 	pushw	%ds
 	pushw	%fs
 	popw	%ds
-	call	memcpy
+	calll	memcpy
 	popw	%ds
-	ret
+	retl
 ENDPROC(copy_from_fs)
 
 GLOBAL(copy_to_fs)
 	pushw	%es
 	pushw	%fs
 	popw	%es
-	call	memcpy
+	calll	memcpy
 	popw	%es
-	ret
+	retl
 ENDPROC(copy_to_fs)
 
 #if 0 /* Not currently used, but can be enabled as needed */
@@ -71,17 +71,17 @@ GLOBAL(copy_from_gs)
 	pushw	%ds
 	pushw	%gs
 	popw	%ds
-	call	memcpy
+	calll	memcpy
 	popw	%ds
-	ret
+	retl
 ENDPROC(copy_from_gs)
 
 GLOBAL(copy_to_gs)
 	pushw	%es
 	pushw	%gs
 	popw	%es
-	call	memcpy
+	calll	memcpy
 	popw	%es
-	ret
+	retl
 ENDPROC(copy_to_gs)
 #endif
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 190413d..12a26b9 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -204,13 +204,13 @@ int __copy_in_user(void __user *dst, const void __user *src, unsigned size)
 static __must_check __always_inline int
 __copy_from_user_inatomic(void *dst, const void __user *src, unsigned size)
 {
-	return __copy_from_user_nocheck(dst, (__force const void *)src, size);
+	return __copy_from_user_nocheck(dst, src, size);
 }
 
 static __must_check __always_inline int
 __copy_to_user_inatomic(void __user *dst, const void *src, unsigned size)
 {
-	return __copy_to_user_nocheck((__force void *)dst, src, size);
+	return __copy_to_user_nocheck(dst, src, size);
 }
 
 extern long __copy_user_nocache(void *dst, const void __user *src,
