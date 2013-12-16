Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab3LPRYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:24:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48983 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3LPRYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:24:45 -0500
Date: Mon, 16 Dec 2013 09:24:24 -0800
From: tip-bot for Qiaowei Ren <tipbot@zytor.com>
Message-ID: <tip-f09174c501f8bb259788cc36d5a7aa5b2831fb5e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, qiaowei.ren@intel.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, qiaowei.ren@intel.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1387002303-6620-1-git-send-email-qiaowei.ren@intel.com>
References: <1387002303-6620-1-git-send-email-qiaowei.ren@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] x86: add user_atomic_cmpxchg_inatomic at uaccess.h
Git-Commit-ID: f09174c501f8bb259788cc36d5a7aa5b2831fb5e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 09:24:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f09174c501f8bb259788cc36d5a7aa5b2831fb5e
Gitweb:     http://git.kernel.org/tip/f09174c501f8bb259788cc36d5a7aa5b2831fb5e
Author:     Qiaowei Ren <qiaowei.ren@intel.com>
AuthorDate: Sat, 14 Dec 2013 14:25:02 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 16 Dec 2013 09:07:57 -0800

x86: add user_atomic_cmpxchg_inatomic at uaccess.h

This patch adds user_atomic_cmpxchg_inatomic() to use CMPXCHG
instruction against a user space address.

This generalizes the already existing futex_atomic_cmpxchg_inatomic()
so it can be used in other contexts.  This will be used in the
upcoming support for Intel MPX (Memory Protection Extensions.)

[ hpa: replaced #ifdef inside a macro with IS_ENABLED() ]

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Link: http://lkml.kernel.org/r/1387002303-6620-1-git-send-email-qiaowei.ren@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/include/asm/uaccess.h | 92 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 8ec57c0..48ff838 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -525,6 +525,98 @@ extern __must_check long strnlen_user(const char __user *str, long n);
 unsigned long __must_check clear_user(void __user *mem, unsigned long len);
 unsigned long __must_check __clear_user(void __user *mem, unsigned long len);
 
+extern void __cmpxchg_wrong_size(void)
+	__compiletime_error("Bad argument size for cmpxchg");
+
+#define __user_atomic_cmpxchg_inatomic(uval, ptr, old, new, size)	\
+({									\
+	int __ret = 0;							\
+	__typeof__(ptr) __uval = (uval);				\
+	__typeof__(*(ptr)) __old = (old);				\
+	__typeof__(*(ptr)) __new = (new);				\
+	switch (size) {							\
+	case 1:								\
+	{								\
+		asm volatile("\t" ASM_STAC "\n"				\
+			"1:\t" LOCK_PREFIX "cmpxchgb %4, %2\n"		\
+			"2:\t" ASM_CLAC "\n"				\
+			"\t.section .fixup, \"ax\"\n"			\
+			"3:\tmov     %3, %0\n"				\
+			"\tjmp     2b\n"				\
+			"\t.previous\n"					\
+			_ASM_EXTABLE(1b, 3b)				\
+			: "+r" (__ret), "=a" (__old), "+m" (*(ptr))	\
+			: "i" (-EFAULT), "q" (__new), "1" (__old)	\
+			: "memory"					\
+		);							\
+		break;							\
+	}								\
+	case 2:								\
+	{								\
+		asm volatile("\t" ASM_STAC "\n"				\
+			"1:\t" LOCK_PREFIX "cmpxchgw %4, %2\n"		\
+			"2:\t" ASM_CLAC "\n"				\
+			"\t.section .fixup, \"ax\"\n"			\
+			"3:\tmov     %3, %0\n"				\
+			"\tjmp     2b\n"				\
+			"\t.previous\n"					\
+			_ASM_EXTABLE(1b, 3b)				\
+			: "+r" (__ret), "=a" (__old), "+m" (*(ptr))	\
+			: "i" (-EFAULT), "r" (__new), "1" (__old)	\
+			: "memory"					\
+		);							\
+		break;							\
+	}								\
+	case 4:								\
+	{								\
+		asm volatile("\t" ASM_STAC "\n"				\
+			"1:\t" LOCK_PREFIX "cmpxchgl %4, %2\n"		\
+			"2:\t" ASM_CLAC "\n"				\
+			"\t.section .fixup, \"ax\"\n"			\
+			"3:\tmov     %3, %0\n"				\
+			"\tjmp     2b\n"				\
+			"\t.previous\n"					\
+			_ASM_EXTABLE(1b, 3b)				\
+			: "+r" (__ret), "=a" (__old), "+m" (*(ptr))	\
+			: "i" (-EFAULT), "r" (__new), "1" (__old)	\
+			: "memory"					\
+		);							\
+		break;							\
+	}								\
+	case 8:								\
+	{								\
+		if (!IS_ENABLED(CONFIG_X86_64))				\
+			__cmpxchg_wrong_size();				\
+									\
+		asm volatile("\t" ASM_STAC "\n"				\
+			"1:\t" LOCK_PREFIX "cmpxchgq %4, %2\n"		\
+			"2:\t" ASM_CLAC "\n"				\
+			"\t.section .fixup, \"ax\"\n"			\
+			"3:\tmov     %3, %0\n"				\
+			"\tjmp     2b\n"				\
+			"\t.previous\n"					\
+			_ASM_EXTABLE(1b, 3b)				\
+			: "+r" (__ret), "=a" (__old), "+m" (*(ptr))	\
+			: "i" (-EFAULT), "r" (__new), "1" (__old)	\
+			: "memory"					\
+		);							\
+		break;							\
+	}								\
+	default:							\
+		__cmpxchg_wrong_size();					\
+	}								\
+	*__uval = __old;						\
+	__ret;								\
+})
+
+#define user_atomic_cmpxchg_inatomic(uval, ptr, old, new)		\
+({									\
+	access_ok(VERIFY_WRITE, (ptr), sizeof(*(ptr))) ?		\
+		__user_atomic_cmpxchg_inatomic((uval), (ptr),		\
+				(old), (new), sizeof(*(ptr))) :		\
+		-EFAULT;						\
+})
+
 /*
  * movsl can be slow when source and dest are not both 8-byte aligned
  */
