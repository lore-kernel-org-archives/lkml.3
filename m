Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934007Ab3JPLgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:36:11 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41861 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933654Ab3JPLgK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 16 Oct 2013 07:36:10 -0400
Message-Id: <525E964402000078000FB70C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 16 Oct 2013 12:36:04 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <arjan@linux.intel.com>, <linux@roeck-us.net>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: unify copy_from_user() checking
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

It also puzzles me that similar checking isn't done for copy_to_user():
While not resulting in (kernel) buffer overflows, size mistakes there
would still lead to information leaks.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
---
 arch/x86/include/asm/uaccess.h    |   25 +++++++++++++++++++++++++
 arch/x86/include/asm/uaccess_32.h |   23 -----------------------
 arch/x86/include/asm/uaccess_64.h |   16 ----------------
 3 files changed, 25 insertions(+), 39 deletions(-)

--- 3.12-rc5/arch/x86/include/asm/uaccess.h
+++ 3.12-rc5-x86-copy_from_user-overflow/arch/x86/include/asm/uaccess.h
@@ -542,5 +542,30 @@ extern struct movsl_mask {
 # include <asm/uaccess_64.h>
 #endif
 
+extern void copy_from_user_overflow(void)
+#ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
+	__compiletime_error("copy_from_user() buffer size is not provably correct")
+#else
+	__compiletime_warning("copy_from_user() buffer size is not provably correct")
+#endif
+;
+
+static inline unsigned long __must_check copy_from_user(void *to,
+					  const void __user *from,
+					  unsigned long n)
+{
+	int sz = __compiletime_object_size(to);
+
+	might_fault();
+	if (likely(sz == -1 || sz >= n))
+		n = _copy_from_user(to, from, n);
+	else if(__builtin_constant_p(n))
+		copy_from_user_overflow();
+	else
+		WARN(1, "Buffer overflow detected (%d < %lu)!\n", sz, n);
+
+	return n;
+}
+
 #endif /* _ASM_X86_UACCESS_H */
 
--- 3.12-rc5/arch/x86/include/asm/uaccess_32.h
+++ 3.12-rc5-x86-copy_from_user-overflow/arch/x86/include/asm/uaccess_32.h
@@ -190,27 +190,4 @@ unsigned long __must_check _copy_from_us
 					  const void __user *from,
 					  unsigned long n);
 
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
--- 3.12-rc5/arch/x86/include/asm/uaccess_64.h
+++ 3.12-rc5-x86-copy_from_user-overflow/arch/x86/include/asm/uaccess_64.h
@@ -52,22 +52,6 @@ _copy_from_user(void *to, const void __u
 __must_check unsigned long
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


