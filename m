Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbaKZX6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:58:18 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24368 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaKZX6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:58:17 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [RFC v2 1/2] compiler: use compiler to detect integer overflows
Date: Wed, 26 Nov 2014 18:58:01 -0500
Message-Id: <1417046282-31825-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've used to detect integer overflows by causing an overflow and testing the
result. For example, to test for addition overflow we would:

	if (a + b < a)
		/* Overflow detected */

While it works, this is actually an undefined behaviour and we're not
guaranteed to have integers overflowing this way. GCC5 has introduced
built in macros (which existed in Clang/LLVM for a while) to test for
addition, subtraction and multiplication overflows.

Rather than keep relying on the current behaviour of GCC, let's take
it's olive branch and test for overflows by using the builtin
functions.

Changing existing code is simple and can be done using Coccinelle:

@@ expression X; expression Y; constant C; @@
(
- X + Y < Y
+ check_add_overflow(X, Y)
|
- X - Y > X
+ check_sub_overflow(X, Y)
|
- X != 0 && Y > C / X
+ check_mul_overflow(X, Y, C)
)

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---

Changes in V2:

 - Comments from Vegard Nossum
 - Comments from Andrey Ryabinin
 - Use a relevant example commit

 include/linux/compiler-gcc5.h |   17 +++++++++++++++++
 include/linux/compiler.h      |   23 +++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/include/linux/compiler-gcc5.h b/include/linux/compiler-gcc5.h
index c8c5659..0429519 100644
--- a/include/linux/compiler-gcc5.h
+++ b/include/linux/compiler-gcc5.h
@@ -63,3 +63,20 @@
 #define __HAVE_BUILTIN_BSWAP64__
 #define __HAVE_BUILTIN_BSWAP16__
 #endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
+
+#define check_add_overflow(A, B)					\
+({									\
+	typeof((A) + (B)) __gcc_overflow_dummy;				\
+	__builtin_add_overflow((A), (B), &__gcc_overflow_dummy);	\
+})
+
+#define check_sub_overflow(A, B)					\
+({									\
+	typeof((A) - (B)) __gcc_overflow_dummy;				\
+	__builtin_sub_overflow((A), (B), &__gcc_overflow_dummy);	\
+})
+
+#define check_mul_overflow(A, B, C)					\
+	typeof((A) * (B)) __gcc_overflow_dummy;				\
+	__builtin_mul_overflow((A), (B), &__gcc_overflow_dummy);	\
+})
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 934a834..bbe85ab 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -388,4 +388,27 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 # define __kprobes
 # define nokprobe_inline	inline
 #endif
+
+#ifndef check_add_overflow
+#define check_add_overflow(A, B)			\
+({							\
+	typeof(A) __tmp_A = (A);			\
+	 (((__tmp_A) + (B)) < (__tmp_A));		\
+})
+#endif
+#ifndef check_sub_overflow
+#define check_sub_overflow(A, B)			\
+({							\
+	typeof(A) __tmp_A = (A);			\
+	(((__tmp_A) - (B)) > (__tmp_A));		\
+})
+#endif
+#ifndef check_mul_overflow
+#define check_mul_overflow(A, B, C)			\
+({							\
+	typeof(A) __tmp_A = (A);			\
+	((__tmp_A) != 0 && (B) > (C) / (__tmp_A));	\
+})
+#endif
+
 #endif /* __LINUX_COMPILER_H */
-- 
1.7.10.4

