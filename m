Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336Ab3BLU4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:56:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55358 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab3BLU43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:56:29 -0500
Date: Tue, 12 Feb 2013 12:55:54 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-3578baaed4613a9fc09bab9f79f6ce2ac682e8a3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, jamie@shareable.org,
        ville.syrjala@linux.intel.com, bp@alien8.de, linux@arm.linux.org.uk,
        tglx@linutronix.de, hpa@linux.intel.com, hjl.tools@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jamie@shareable.org, torvalds@linux-foundation.org,
        ville.syrjala@linux.intel.com, bp@alien8.de, linux@arm.linux.org.uk,
        tglx@linutronix.de, hpa@linux.intel.com, hjl.tools@gmail.com
In-Reply-To: <511A8922.6050908@zytor.com>
References: <511A8922.6050908@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm:
  Redesign get_user with a __builtin_choose_expr hack
Git-Commit-ID: 3578baaed4613a9fc09bab9f79f6ce2ac682e8a3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 12 Feb 2013 12:56:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3578baaed4613a9fc09bab9f79f6ce2ac682e8a3
Gitweb:     http://git.kernel.org/tip/3578baaed4613a9fc09bab9f79f6ce2ac682e8a3
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 12 Feb 2013 11:47:31 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 12 Feb 2013 12:46:40 -0800

x86, mm: Redesign get_user with a __builtin_choose_expr hack

Instead of using a bitfield, use an odd little trick using typeof,
__builtin_choose_expr, and sizeof.  __builtin_choose_expr is
explicitly defined to not convert its type (its argument is required
to be a constant expression) so this should be well-defined.

The code is still not 100% preturbation-free versus the baseline
before 64-bit get_user(), but the differences seem to be very small,
mostly related to padding and to gcc deciding when to spill registers.

Cc: Jamie Lokier <jamie@shareable.org>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: H. J. Lu <hjl.tools@gmail.com>
Link: http://lkml.kernel.org/r/511A8922.6050908@zytor.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/uaccess.h | 57 +++++++++++-------------------------------
 1 file changed, 14 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index a8d1265..d710a25 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -125,13 +125,12 @@ extern int __get_user_4(void);
 extern int __get_user_8(void);
 extern int __get_user_bad(void);
 
-#define __get_user_x(size, ret, x, ptr)		      \
-	asm volatile("call __get_user_" #size	      \
-		     : "=a" (ret), "=d" (x)	      \
-		     : "0" (ptr))		      \
-
-/* Careful: we have to cast the result to the type of the pointer
- * for sign reasons */
+/*
+ * This is a type: either unsigned long, if the argument fits into
+ * that type, or otherwise unsigned long long.
+ */
+#define __inttype(x) \
+__typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
 
 /**
  * get_user: - Get a simple variable from user space.
@@ -149,48 +148,20 @@ extern int __get_user_bad(void);
  *
  * Returns zero on success, or -EFAULT on error.
  * On error, the variable @x is set to zero.
+ *
+ * Careful: we have to cast the result to the type of the pointer
+ * for sign reasons.
  */
-#ifdef CONFIG_X86_32
-#define __get_user_8(ret, x, ptr)		      \
-do {						      \
-	register unsigned long long __xx asm("%edx"); \
-	asm volatile("call __get_user_8"	      \
-		     : "=a" (ret), "=r" (__xx)	      \
-		     : "0" (ptr));		      \
-	(x) = __xx;				      \
-} while (0)
-
-#else
-#define __get_user_8(__ret_gu, __val_gu, ptr)				\
-		__get_user_x(8, __ret_gu, __val_gu, ptr)
-#endif
-
 #define get_user(x, ptr)						\
 ({									\
 	int __ret_gu;							\
-	struct {							\
-		unsigned long long __val_n : 8*sizeof(*(ptr));		\
-	} __val_gu;							\
+	register __inttype(*(ptr)) __val_gu asm("%edx");		\
 	__chk_user_ptr(ptr);						\
 	might_fault();							\
-	switch (sizeof(*(ptr))) {					\
-	case 1:								\
-		__get_user_x(1, __ret_gu, __val_gu.__val_n, ptr);	\
-		break;							\
-	case 2:								\
-		__get_user_x(2, __ret_gu, __val_gu.__val_n, ptr);	\
-		break;							\
-	case 4:								\
-		__get_user_x(4, __ret_gu, __val_gu.__val_n, ptr);	\
-		break;							\
-	case 8:								\
-		__get_user_8(__ret_gu, __val_gu.__val_n, ptr);		\
-		break;							\
-	default:							\
-		__get_user_x(X, __ret_gu, __val_gu.__val_n, ptr);	\
-		break;							\
-	}								\
-	(x) = (__typeof__(*(ptr)))__val_gu.__val_n;			\
+	asm volatile("call __get_user_%P3"				\
+		     : "=a" (__ret_gu), "=r" (__val_gu)			\
+		     : "0" (ptr), "i" (sizeof(*(ptr))));		\
+	(x) = (__typeof__(*(ptr))) __val_gu;				\
 	__ret_gu;							\
 })
 
