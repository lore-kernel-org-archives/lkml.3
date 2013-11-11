Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab3KKSty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:49:54 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:40262 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab3KKStr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:49:47 -0500
Date: Mon, 11 Nov 2013 19:49:44 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/uaccess change for v3.13
Message-ID: <20131111184944.GA16606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-uaccess-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-uaccess-for-linus

   # HEAD: ff47ab4ff3cddfa7bc1b25b990e24abe2ae474ff x86: Add 1/2/4/8 byte optimization to 64bit __copy_{from,to}_user_inatomic

It includes a single change that micro-optimizes __copy_*_user_inatomic(), 
used by the futx code.

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      x86: Add 1/2/4/8 byte optimization to 64bit __copy_{from,to}_user_inatomic


 arch/x86/include/asm/uaccess_64.h | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 4f7923d..64476bb 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -77,11 +77,10 @@ int copy_to_user(void __user *dst, const void *src, unsigned size)
 }
 
 static __always_inline __must_check
-int __copy_from_user(void *dst, const void __user *src, unsigned size)
+int __copy_from_user_nocheck(void *dst, const void __user *src, unsigned size)
 {
 	int ret = 0;
 
-	might_fault();
 	if (!__builtin_constant_p(size))
 		return copy_user_generic(dst, (__force void *)src, size);
 	switch (size) {
@@ -121,11 +120,17 @@ int __copy_from_user(void *dst, const void __user *src, unsigned size)
 }
 
 static __always_inline __must_check
-int __copy_to_user(void __user *dst, const void *src, unsigned size)
+int __copy_from_user(void *dst, const void __user *src, unsigned size)
+{
+	might_fault();
+	return __copy_from_user_nocheck(dst, src, size);
+}
+
+static __always_inline __must_check
+int __copy_to_user_nocheck(void __user *dst, const void *src, unsigned size)
 {
 	int ret = 0;
 
-	might_fault();
 	if (!__builtin_constant_p(size))
 		return copy_user_generic((__force void *)dst, src, size);
 	switch (size) {
@@ -165,6 +170,13 @@ int __copy_to_user(void __user *dst, const void *src, unsigned size)
 }
 
 static __always_inline __must_check
+int __copy_to_user(void __user *dst, const void *src, unsigned size)
+{
+	might_fault();
+	return __copy_to_user_nocheck(dst, src, size);
+}
+
+static __always_inline __must_check
 int __copy_in_user(void __user *dst, const void __user *src, unsigned size)
 {
 	int ret = 0;
@@ -220,13 +232,13 @@ int __copy_in_user(void __user *dst, const void __user *src, unsigned size)
 static __must_check __always_inline int
 __copy_from_user_inatomic(void *dst, const void __user *src, unsigned size)
 {
-	return copy_user_generic(dst, (__force const void *)src, size);
+	return __copy_from_user_nocheck(dst, (__force const void *)src, size);
 }
 
 static __must_check __always_inline int
 __copy_to_user_inatomic(void __user *dst, const void *src, unsigned size)
 {
-	return copy_user_generic((__force void *)dst, src, size);
+	return __copy_to_user_nocheck((__force void *)dst, src, size);
 }
 
 extern long __copy_user_nocache(void *dst, const void __user *src,
