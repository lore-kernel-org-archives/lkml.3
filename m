Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab3JUIoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:44:44 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:42427 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab3JUIon convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 21 Oct 2013 04:44:43 -0400
Message-Id: <5265059502000078000FC4F6@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 21 Oct 2013 09:44:37 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <arjan@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] x86: unify copy_to_user() and add size checking to
 it
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similarly to copy_from_user(), where the range check is to protect
against kernel memory corruption, copy_to_user() can benefit from such
checking too: Here it protects against kernel information leaks.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/include/asm/uaccess.h    |   30 ++++++++++++++++++++++++++++++
 arch/x86/include/asm/uaccess_32.h |    3 ---
 arch/x86/include/asm/uaccess_64.h |   10 ----------
 arch/x86/lib/usercopy_32.c        |    5 ++---
 4 files changed, 32 insertions(+), 16 deletions(-)

--- 3.12-rc6-x86.orig/arch/x86/include/asm/uaccess.h
+++ 3.12-rc6-x86/arch/x86/include/asm/uaccess.h
@@ -544,6 +544,8 @@ extern struct movsl_mask {
 
 unsigned long __must_check _copy_from_user(void *to, const void __user *from,
 					   unsigned n);
+unsigned long __must_check _copy_to_user(void __user *to, const void *from,
+					 unsigned n);
 
 #ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
 # define copy_user_diag __compiletime_error
@@ -553,6 +555,8 @@ unsigned long __must_check _copy_from_us
 
 extern void copy_user_diag("copy_from_user() buffer size is too small")
 copy_from_user_overflow(void);
+extern void copy_user_diag("copy_to_user() buffer size is too small")
+copy_to_user_overflow(void) __asm__("copy_from_user_overflow");
 
 #undef copy_user_diag
 
@@ -563,6 +567,11 @@ __compiletime_warning("copy_from_user() 
 __copy_from_user_overflow(void) __asm__("copy_from_user_overflow");
 #define __copy_from_user_overflow(size, count) __copy_from_user_overflow()
 
+extern void
+__compiletime_warning("copy_to_user() buffer size is not provably correct")
+__copy_to_user_overflow(void) __asm__("copy_from_user_overflow");
+#define __copy_to_user_overflow(size, count) __copy_to_user_overflow()
+
 #else
 
 static inline void
@@ -571,6 +580,8 @@ __copy_from_user_overflow(int size, unsi
 	WARN(1, "Buffer overflow detected (%d < %lu)!\n", size, count);
 }
 
+#define __copy_to_user_overflow __copy_from_user_overflow
+
 #endif
 
 static inline unsigned long __must_check
@@ -608,7 +619,26 @@ copy_from_user(void *to, const void __us
 	return n;
 }
 
+static inline unsigned long __must_check
+copy_to_user(void __user *to, const void *from, unsigned long n)
+{
+	int sz = __compiletime_object_size(from);
+
+	might_fault();
+
+	/* See the comment in copy_from_user() above. */
+	if (likely(sz < 0 || sz >= n))
+		n = _copy_to_user(to, from, n);
+	else if(__builtin_constant_p(n))
+		copy_to_user_overflow();
+	else
+		__copy_to_user_overflow(sz, n);
+
+	return n;
+}
+
 #undef __copy_from_user_overflow
+#undef __copy_to_user_overflow
 
 #endif /* _ASM_X86_UACCESS_H */
 
--- 3.12-rc6-x86.orig/arch/x86/include/asm/uaccess_32.h
+++ 3.12-rc6-x86/arch/x86/include/asm/uaccess_32.h
@@ -184,7 +184,4 @@ __copy_from_user_inatomic_nocache(void *
        return __copy_from_user_ll_nocache_nozero(to, from, n);
 }
 
-unsigned long __must_check copy_to_user(void __user *to,
-					const void *from, unsigned long n);
-
 #endif /* _ASM_X86_UACCESS_32_H */
--- 3.12-rc6-x86.orig/arch/x86/include/asm/uaccess_64.h
+++ 3.12-rc6-x86/arch/x86/include/asm/uaccess_64.h
@@ -46,19 +46,9 @@ copy_user_generic(void *to, const void *
 }
 
 __must_check unsigned long
-_copy_to_user(void __user *to, const void *from, unsigned len);
-__must_check unsigned long
 copy_in_user(void __user *to, const void __user *from, unsigned len);
 
 static __always_inline __must_check
-int copy_to_user(void __user *dst, const void *src, unsigned size)
-{
-	might_fault();
-
-	return _copy_to_user(dst, src, size);
-}
-
-static __always_inline __must_check
 int __copy_from_user(void *dst, const void __user *src, unsigned size)
 {
 	int ret = 0;
--- 3.12-rc6-x86.orig/arch/x86/lib/usercopy_32.c
+++ 3.12-rc6-x86/arch/x86/lib/usercopy_32.c
@@ -654,14 +654,13 @@ EXPORT_SYMBOL(__copy_from_user_ll_nocach
  * Returns number of bytes that could not be copied.
  * On success, this will be zero.
  */
-unsigned long
-copy_to_user(void __user *to, const void *from, unsigned long n)
+unsigned long _copy_to_user(void __user *to, const void *from, unsigned n)
 {
 	if (access_ok(VERIFY_WRITE, to, n))
 		n = __copy_to_user(to, from, n);
 	return n;
 }
-EXPORT_SYMBOL(copy_to_user);
+EXPORT_SYMBOL(_copy_to_user);
 
 /**
  * copy_from_user: - Copy a block of data from user space.


