Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3JUIoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:44:05 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:42393 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab3JUIoD convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Mon, 21 Oct 2013 04:44:03 -0400
Message-Id: <5265056D02000078000FC4F3@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 21 Oct 2013 09:43:57 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <arjan@linux.intel.com>, <linux@roeck-us.net>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] x86: unify copy_from_user() size checking
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commits 4a3127693001c61a21d1ce680db6340623f52e93 ("x86: Turn the
copy_from_user check into an (optional) compile time warning") and
63312b6a6faae3f2e5577f2b001e3b504f10a2aa ("x86: Add a Kconfig option to
turn the copy_from_user warnings into errors") touched only the 32-bit
variant of copy_from_user(), whereas the original commit
9f0cf4adb6aa0bfccf675c938124e68f7f06349d ("x86: Use
__builtin_object_size() to validate the buffer size for
copy_from_user()") also added the same code to the 64-bit one.

Further the earlier conversion from an inline WARN() to the call to
copy_from_user_overflow() went a little too far: When the number of
bytes to be copied is not a constant (e.g. [looking at 3.11] in
drivers/net/tun.c:__tun_chr_ioctl() or
drivers/pci/pcie/aer/aer_inject.c:aer_inject_write()), the compiler
will always have to keep the funtion call, and hence there will always
be a warning. By using __builtin_constant_p() we can avoid this.

And then this slightly extends the effect of
CONFIG_DEBUG_STRICT_USER_COPY_CHECKS in that apart from converting
warnings to errors in the constant size case, it retains the (possibly
wrong) warnings in the non-constant size case, such that if someone is
prepared to get a few false positives, (s)he'll be able to recover the
current behavior (except that these diagnostics now will never be
converted to errors).

Since the 32-bit variant (intentionally) didn't call might_fault(), the
unification results in this being called twice now. Adding a suitable
#ifdef would be the alternative if that's a problem.

I'd like to point out though that with __compiletime_object_size()
being restricted to gcc before 4.6, the whole construct is going to
become more and more pointless going forward. I would question
however that commit 2fb0815c9ee6b9ac50e15dd8360ec76d9fa46a2 ("gcc4:
disable __compiletime_object_size for GCC 4.6+") was really necessary,
and instead this should have been dealt with as is done here from the
beginning.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 arch/x86/include/asm/uaccess.h    |   68 ++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/uaccess_32.h |   26 --------------
 arch/x86/include/asm/uaccess_64.h |   18 ----------
 arch/x86/lib/usercopy_32.c        |    3 -
 4 files changed, 69 insertions(+), 46 deletions(-)

--- 3.12-rc6-x86.orig/arch/x86/include/asm/uaccess.h
+++ 3.12-rc6-x86/arch/x86/include/asm/uaccess.h
@@ -542,5 +542,73 @@ extern struct movsl_mask {
 # include <asm/uaccess_64.h>
 #endif
 
+unsigned long __must_check _copy_from_user(void *to, const void __user *from,
+					   unsigned n);
+
+#ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
+# define copy_user_diag __compiletime_error
+#else
+# define copy_user_diag __compiletime_warning
+#endif
+
+extern void copy_user_diag("copy_from_user() buffer size is too small")
+copy_from_user_overflow(void);
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
+#else
+
+static inline void
+__copy_from_user_overflow(int size, unsigned long count)
+{
+	WARN(1, "Buffer overflow detected (%d < %lu)!\n", size, count);
+}
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
+#undef __copy_from_user_overflow
+
 #endif /* _ASM_X86_UACCESS_H */
 
--- 3.12-rc6-x86.orig/arch/x86/include/asm/uaccess_32.h
+++ 3.12-rc6-x86/arch/x86/include/asm/uaccess_32.h
@@ -186,31 +186,5 @@ __copy_from_user_inatomic_nocache(void *
 
 unsigned long __must_check copy_to_user(void __user *to,
 					const void *from, unsigned long n);
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
 
 #endif /* _ASM_X86_UACCESS_32_H */
--- 3.12-rc6-x86.orig/arch/x86/include/asm/uaccess_64.h
+++ 3.12-rc6-x86/arch/x86/include/asm/uaccess_64.h
@@ -48,26 +48,8 @@ copy_user_generic(void *to, const void *
 __must_check unsigned long
 _copy_to_user(void __user *to, const void *from, unsigned len);
 __must_check unsigned long
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
 static __always_inline __must_check
 int copy_to_user(void __user *dst, const void *src, unsigned size)
 {
--- 3.12-rc6-x86.orig/arch/x86/lib/usercopy_32.c
+++ 3.12-rc6-x86/arch/x86/lib/usercopy_32.c
@@ -679,8 +679,7 @@ EXPORT_SYMBOL(copy_to_user);
  * If some data could not be copied, this function will pad the copied
  * data to the requested size using zero bytes.
  */
-unsigned long
-_copy_from_user(void *to, const void __user *from, unsigned long n)
+unsigned long _copy_from_user(void *to, const void __user *from, unsigned n)
 {
 	if (access_ok(VERIFY_READ, from, n))
 		n = __copy_from_user(to, from, n);


