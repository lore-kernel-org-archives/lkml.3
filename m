Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab3JZNvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 09:51:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37245 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3JZNvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 09:51:36 -0400
Date: Sat, 26 Oct 2013 06:51:16 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-3df7b41aa5e7797f391d0a41f8b0dce1fe366a09@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        arjan@linux.intel.com, jbeulich@suse.com, linux@roeck-us.net,
        akpm@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, jbeulich@suse.com, linux@roeck-us.net,
        akpm@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de
In-Reply-To: <5265056D02000078000FC4F3@nat28.tlf.novell.com>
References: <5265056D02000078000FC4F3@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Unify copy_from_user() size checking
Git-Commit-ID: 3df7b41aa5e7797f391d0a41f8b0dce1fe366a09
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 26 Oct 2013 06:51:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3df7b41aa5e7797f391d0a41f8b0dce1fe366a09
Gitweb:     http://git.kernel.org/tip/3df7b41aa5e7797f391d0a41f8b0dce1fe366a09
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Mon, 21 Oct 2013 09:43:57 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 26 Oct 2013 12:27:36 +0200

x86: Unify copy_from_user() size checking

Commits 4a3127693001c61a21d1ce680db6340623f52e93 ("x86: Turn the
copy_from_user check into an (optional) compile time warning")
and 63312b6a6faae3f2e5577f2b001e3b504f10a2aa ("x86: Add a
Kconfig option to turn the copy_from_user warnings into errors")
touched only the 32-bit variant of copy_from_user(), whereas the
original commit 9f0cf4adb6aa0bfccf675c938124e68f7f06349d ("x86:
Use __builtin_object_size() to validate the buffer size for
copy_from_user()") also added the same code to the 64-bit one.

Further the earlier conversion from an inline WARN() to the call
to copy_from_user_overflow() went a little too far: When the
number of bytes to be copied is not a constant (e.g. [looking at
3.11] in drivers/net/tun.c:__tun_chr_ioctl() or
drivers/pci/pcie/aer/aer_inject.c:aer_inject_write()), the
compiler will always have to keep the funtion call, and hence
there will always be a warning. By using __builtin_constant_p()
we can avoid this.

And then this slightly extends the effect of
CONFIG_DEBUG_STRICT_USER_COPY_CHECKS in that apart from
converting warnings to errors in the constant size case, it
retains the (possibly wrong) warnings in the non-constant size
case, such that if someone is prepared to get a few false
positives, (s)he'll be able to recover the current behavior
(except that these diagnostics now will never be converted to
errors).

Since the 32-bit variant (intentionally) didn't call
might_fault(), the unification results in this being called
twice now. Adding a suitable #ifdef would be the alternative if
that's a problem.

I'd like to point out though that with
__compiletime_object_size() being restricted to gcc before 4.6,
the whole construct is going to become more and more pointless
going forward. I would question however that commit
2fb0815c9ee6b9ac50e15dd8360ec76d9fa46a2 ("gcc4: disable
__compiletime_object_size for GCC 4.6+") was really necessary,
and instead this should have been dealt with as is done here
from the beginning.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/5265056D02000078000FC4F3@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/uaccess.h    | 68 +++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/uaccess_32.h | 26 ---------------
 arch/x86/include/asm/uaccess_64.h | 18 -----------
 arch/x86/lib/usercopy_32.c        |  3 +-
 4 files changed, 69 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 5838fa9..c9799ed 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
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
 
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 7f760a9..c348c87 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -186,31 +186,5 @@ __copy_from_user_inatomic_nocache(void *to, const void __user *from,
 
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
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 4f7923d..4df93c4 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -48,26 +48,8 @@ copy_user_generic(void *to, const void *from, unsigned len)
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
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 3eb18ac..c408d02 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
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
