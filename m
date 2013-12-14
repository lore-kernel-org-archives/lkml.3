Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab3LMXKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 18:10:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:26757 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492Ab3LMXKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 18:10:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,482,1384329600"; 
   d="scan'208";a="452093146"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH 1/2] x86: add user_atomic_cmpxchg_inatomic at uaccess.h
Date: Sat, 14 Dec 2013 14:25:02 +0800
Message-Id: <1387002303-6620-1-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds user_atomic_cmpxchg_inatomic() to use CMPXCHG
instruction against a user space address.

This generalizes the already existing futex_atomic_cmpxchg_inatomic()
so it can be used in other contexts.  This will be used in the
upcoming support for Intel MPX (Memory Protection Extensions.)

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 arch/x86/include/asm/uaccess.h |   91 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 91 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 5838fa9..894d8bf 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -525,6 +525,97 @@ extern __must_check long strnlen_user(const char __user *str, long n);
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
+#ifdef CONFIG_X86_64							\
+	case 8:								\
+	{								\
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
+#endif									\
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
-- 
1.7.1

