Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab3JZNvp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 09:51:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37252 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3JZNvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 09:51:43 -0400
Date: Sat, 26 Oct 2013 06:51:25 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-7a3d9b0f3abbea957b829cdfff8169872c575642@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        arjan@linux.intel.com, jbeulich@suse.com, akpm@linux-foundation.org,
        JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, jbeulich@suse.com, akpm@linux-foundation.org,
        JBeulich@suse.com, tglx@linutronix.de
In-Reply-To: <5265059502000078000FC4F6@nat28.tlf.novell.com>
References: <5265059502000078000FC4F6@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Unify copy_to_user()
  and add size checking to it
Git-Commit-ID: 7a3d9b0f3abbea957b829cdfff8169872c575642
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 26 Oct 2013 06:51:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a3d9b0f3abbea957b829cdfff8169872c575642
Gitweb:     http://git.kernel.org/tip/7a3d9b0f3abbea957b829cdfff8169872c575642
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Mon, 21 Oct 2013 09:44:37 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 26 Oct 2013 12:27:37 +0200

x86: Unify copy_to_user() and add size checking to it

Similarly to copy_from_user(), where the range check is to
protect against kernel memory corruption, copy_to_user() can
benefit from such checking too: Here it protects against kernel
information leaks.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/5265059502000078000FC4F6@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/include/asm/uaccess.h    | 30 ++++++++++++++++++++++++++++++
 arch/x86/include/asm/uaccess_32.h |  3 ---
 arch/x86/include/asm/uaccess_64.h | 10 ----------
 arch/x86/lib/usercopy_32.c        |  5 ++---
 4 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index c9799ed..8ec57c0 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -544,6 +544,8 @@ extern struct movsl_mask {
 
 unsigned long __must_check _copy_from_user(void *to, const void __user *from,
 					   unsigned n);
+unsigned long __must_check _copy_to_user(void __user *to, const void *from,
+					 unsigned n);
 
 #ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
 # define copy_user_diag __compiletime_error
@@ -553,6 +555,8 @@ unsigned long __must_check _copy_from_user(void *to, const void __user *from,
 
 extern void copy_user_diag("copy_from_user() buffer size is too small")
 copy_from_user_overflow(void);
+extern void copy_user_diag("copy_to_user() buffer size is too small")
+copy_to_user_overflow(void) __asm__("copy_from_user_overflow");
 
 #undef copy_user_diag
 
@@ -563,6 +567,11 @@ __compiletime_warning("copy_from_user() buffer size is not provably correct")
 __copy_from_user_overflow(void) __asm__("copy_from_user_overflow");
 #define __copy_from_user_overflow(size, count) __copy_from_user_overflow()
 
+extern void
+__compiletime_warning("copy_to_user() buffer size is not provably correct")
+__copy_to_user_overflow(void) __asm__("copy_from_user_overflow");
+#define __copy_to_user_overflow(size, count) __copy_to_user_overflow()
+
 #else
 
 static inline void
@@ -571,6 +580,8 @@ __copy_from_user_overflow(int size, unsigned long count)
 	WARN(1, "Buffer overflow detected (%d < %lu)!\n", size, count);
 }
 
+#define __copy_to_user_overflow __copy_from_user_overflow
+
 #endif
 
 static inline unsigned long __must_check
@@ -608,7 +619,26 @@ copy_from_user(void *to, const void __user *from, unsigned long n)
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
 
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index c348c87..3c03a5d 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -184,7 +184,4 @@ __copy_from_user_inatomic_nocache(void *to, const void __user *from,
        return __copy_from_user_ll_nocache_nozero(to, from, n);
 }
 
-unsigned long __must_check copy_to_user(void __user *to,
-					const void *from, unsigned long n);
-
 #endif /* _ASM_X86_UACCESS_32_H */
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 4df93c4..0acae71 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -46,19 +46,9 @@ copy_user_generic(void *to, const void *from, unsigned len)
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
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index c408d02..e2f5e21 100644
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
