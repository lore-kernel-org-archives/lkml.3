Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaKZOAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:00:33 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51785 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaKZOAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:00:31 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [RFC 1/2] compiler: use compiler to detect integer overflows
Date: Wed, 26 Nov 2014 09:00:18 -0500
Message-Id: <1417010419-3827-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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

@@ expression X; expression Y; expression Z; constant C; @@
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

Which also makes the code much more clearer, for example:

-       if (addr + len < addr)
+       if (check_add_overflow(addr, len))
                return -EFAULT;

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---

The patch following this one is an example of how changes to existing
code will look like. It's just one patch out of about 40 which are very
simiar - so to avoid lots of useless mails I'll avoid sending them until
this patch looks ok.

 include/linux/compiler-gcc5.h |    8 ++++++++
 include/linux/compiler.h      |   11 +++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/compiler-gcc5.h b/include/linux/compiler-gcc5.h
index c8c5659..9d39f66 100644
--- a/include/linux/compiler-gcc5.h
+++ b/include/linux/compiler-gcc5.h
@@ -63,3 +63,11 @@
 #define __HAVE_BUILTIN_BSWAP64__
 #define __HAVE_BUILTIN_BSWAP16__
 #endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
+
+__maybe_unused static unsigned int gcc_overflow_dummy;
+#define check_add_overflow(A, B) \
+		__builtin_add_overflow((A), (B), &gcc_overflow_dummy)
+#define check_sub_overflow(A, B) \
+		__builtin_sub_overflow((A), (B), &gcc_overflow_dummy)
+#define check_mul_overflow(A, B, C) \
+		__builtin_mul_overflow((A), (B), &gcc_overflow_dummy)
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 934a834..7f15a18 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -388,4 +388,15 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 # define __kprobes
 # define nokprobe_inline	inline
 #endif
+
+#ifndef check_add_overflow
+#define check_add_overflow(A, B) (((A) + (B)) < (A))
+#endif
+#ifndef check_sub_overflow
+#define check_sub_overflow(A, B) (((A) - (B)) > (A))
+#endif
+#ifndef check_mul_overflow
+#define check_mul_overflow(A, B, C) ((A) != 0 && (B) > (C) / (A))
+#endif
+
 #endif /* __LINUX_COMPILER_H */
-- 
1.7.10.4

