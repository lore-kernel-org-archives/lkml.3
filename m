Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab3KKRAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:00:34 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53857 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3KKRA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:00:28 -0500
Date: Mon, 11 Nov 2013 18:00:24 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jan Beulich <JBeulich@suse.com>
Subject: [GIT PULL] x86/asm changes for v3.13
Message-ID: <20131111170024.GA12091@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-asm-for-linus

   # HEAD: 7a3d9b0f3abbea957b829cdfff8169872c575642 x86: Unify copy_to_user() and add size checking to it

This tree contains two copy_[from/to]_user() build time checking 
changes/enhancements from Jan Beulich.

The desired outcome is to get better compiler warnings with 
CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y, to keep people from introducing 
bugs such as overflows and information leaks.

 Thanks,

	Ingo

------------------>
Jan Beulich (2):
      x86: Unify copy_from_user() size checking
      x86: Unify copy_to_user() and add size checking to it


 arch/x86/include/asm/uaccess.h    | 98 +++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/uaccess_32.h | 29 ------------
 arch/x86/include/asm/uaccess_64.h | 28 -----------
 arch/x86/lib/usercopy_32.c        |  8 ++--
 4 files changed, 101 insertions(+), 62 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 5838fa9..8ec57c0 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -542,5 +542,103 @@ extern struct movsl_mask {
 # include <asm/uaccess_64.h>
 #endif
 
+unsigned long __must_check _copy_from_user(void *to, const void __user *from,
+					   unsigned n);
+unsigned long __must_check _copy_to_user(void __user *to, const void *from,
+					 unsigned n);
+
+#ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
+# define copy_user_diag __compiletime_error
+#else
+# define copy_user_diag __compiletime_warning
+#endif
+
+extern void copy_user_diag("copy_from_user() buffer size is too small")
+copy_from_user_overflow(void);
+extern void copy_user_diag("copy_to_user() buffer size is too small")
+copy_to_user_overflow(void) __asm__("copy_from_user_overflow");
+
+#undef copy_user_diag
+
+#ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
+
+extern void
+__compiletime_warning("copy_from_user() buffer size is not provably correct")
+__copy_from_user_overflow(void) __asm__("copy_from_user_overflow");
+#define __copy_from_user_overflow(size, count) __copy_from_user_overflow()
+
+extern void
+__compiletime_warning("copy_to_user() buffer size is not provably correct")
+__copy_to_user_overflow(void) __asm__("copy_from_user_overflow");
+#define __copy_to_user_overflow(size, count) __copy_to_user_overflow()
+
+#else
+
+static inline void
+__copy_from_user_overflow(int size, unsigned long count)
+{
+	WARN(1, "Buffer overflow detected (%d < %lu)!\n", size, count);
+}
+
+#define __copy_to_user_overflow __copy_from_user_overflow
+
+#endif
+
+static inline unsigned long __must_check
+copy_from_user(void *to, const void __user *from, unsigned long n)
+{
+	int sz = __compiletime_object_size(to);
+
+	might_fault();
+
+	/*
+	 * While we would like to have the compiler do the checking for us
+	 * even in the non-constant size case, any false positives there are
+	 * a problem (especially when DEBUG_STRICT_USER_COPY_CHECKS, but even
+	 * without - the [hopefully] dangerous looking nature of the warning
+	 * would make people go look at the respecitive call sites over and
+	 * over again just to find that there's no problem).
+	 *
+	 * And there are cases where it's just not realistic for the compiler
+	 * to prove the count to be in range. For example when multiple call
+	 * sites of a helper function - perhaps in different source files -
+	 * all doing proper range checking, yet the helper function not doing
+	 * so again.
+	 *
+	 * Therefore limit the compile time checking to the constant size
+	 * case, and do only runtime checking for non-constant sizes.
+	 */
+
+	if (likely(sz < 0 || sz >= n))
+		n = _copy_from_user(to, from, n);
+	else if(__builtin_constant_p(n))
+		copy_from_user_overflow();
+	else
+		__copy_from_user_overflow(sz, n);
+
+	return n;
+}
+
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
+#undef __copy_from_user_overflow
+#undef __copy_to_user_overflow
+
 #endif /* _ASM_X86_UACCESS_H */
 
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 7f760a9..3c03a5d 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -184,33 +184,4 @@ __copy_from_user_inatomic_nocache(void *to, const void __user *from,
        return __copy_from_user_ll_nocache_nozero(to, from, n);
 }
 
-unsigned long __must_check copy_to_user(void __user *to,
-					const void *from, unsigned long n);
-unsigned long __must_check _copy_from_user(void *to,
-					  const void __user *from,
-					  unsigned long n);
-
-
-extern void copy_from_user_overflow(void)
-#ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
-	__compiletime_error("copy_from_user() buffer size is not provably correct")
-#else
-	__compiletime_warning("copy_from_user() buffer size is not provably correct")
-#endif
-;
-
-static inline unsigned long __must_check copy_from_user(void *to,
-					  const void __user *from,
-					  unsigned long n)
-{
-	int sz = __compiletime_object_size(to);
-
-	if (likely(sz == -1 || sz >= n))
-		n = _copy_from_user(to, from, n);
-	else
-		copy_from_user_overflow();
-
-	return n;
-}
-
 #endif /* _ASM_X86_UACCESS_32_H */
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 4f7923d..0acae71 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -46,36 +46,8 @@ copy_user_generic(void *to, const void *from, unsigned len)
 }
 
 __must_check unsigned long
-_copy_to_user(void __user *to, const void *from, unsigned len);
-__must_check unsigned long
-_copy_from_user(void *to, const void __user *from, unsigned len);
-__must_check unsigned long
 copy_in_user(void __user *to, const void __user *from, unsigned len);
 
-static inline unsigned long __must_check copy_from_user(void *to,
-					  const void __user *from,
-					  unsigned long n)
-{
-	int sz = __compiletime_object_size(to);
-
-	might_fault();
-	if (likely(sz == -1 || sz >= n))
-		n = _copy_from_user(to, from, n);
-#ifdef CONFIG_DEBUG_VM
-	else
-		WARN(1, "Buffer overflow detected!\n");
-#endif
-	return n;
-}
-
-static __always_inline __must_check
-int copy_to_user(void __user *dst, const void *src, unsigned size)
-{
-	might_fault();
-
-	return _copy_to_user(dst, src, size);
-}
-
 static __always_inline __must_check
 int __copy_from_user(void *dst, const void __user *src, unsigned size)
 {
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 3eb18ac..e2f5e21 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -654,14 +654,13 @@ EXPORT_SYMBOL(__copy_from_user_ll_nocache_nozero);
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
@@ -679,8 +678,7 @@ EXPORT_SYMBOL(copy_to_user);
  * If some data could not be copied, this function will pad the copied
  * data to the requested size using zero bytes.
  */
-unsigned long
-_copy_from_user(void *to, const void __user *from, unsigned long n)
+unsigned long _copy_from_user(void *to, const void __user *from, unsigned n)
 {
 	if (access_ok(VERIFY_READ, from, n))
 		n = __copy_from_user(to, from, n);
