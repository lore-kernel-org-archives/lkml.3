Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaHOTZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:25:22 -0400
Received: from mail.windriver.com ([147.11.1.11]:49317 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaHOTZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:25:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Ingo Molnar <mingo@kernel.org>, Jakub Jelinek <jakub@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] gcc version 5: add basic definition header for latest gcc version
Date: Fri, 15 Aug 2014 15:23:01 -0400
Message-ID: <1408130581-4806-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The infrastructure for gcc version 5 was under consideration
back in the early days of 2009[1] and now it is finally here.

I've taken the compiler-gcc4.h file, and deleted anything that
was an issue with a closed bound within gcc4.  For any tests
that were looking for things like "#if GCC_VERSION >= 40300"
I've made them unconditional, since statements like the above
will always evaluate to true.

The extra asm("") in our gcc4 implementation of asm_volatile_goto
has been removed, since that should not be necessary for > 4.8.2
according to the comments.

With this in place, what essentially amounts to what will be v3.17-rc1
(in a couple days) builds and boots defconfig on an older Dell dual
core box without any oops or WARN or similar:

$ cat /proc/version
Linux version 3.16.0-11383-gc9d26423e56c (paul@yow-pgortmak-d2) (gcc version
5.0.0 20140815 (experimental) (GCC) ) #3 SMP Fri Aug 15 14:05:10 EDT 2014
$

This was with a fresh build of today's git://gcc.gnu.org/git/gcc.git

While any sane individual would be hesitant to deploy something
this green on anything they cared about, it does give those wishing
to play with experimental stuff a way to do so as it matures.

[1] https://lkml.org/lkml/2009/1/2/209

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/include/linux/compiler-gcc5.h b/include/linux/compiler-gcc5.h
new file mode 100644
index 000000000000..f6680fabb62f
--- /dev/null
+++ b/include/linux/compiler-gcc5.h
@@ -0,0 +1,52 @@
+#ifndef __LINUX_COMPILER_H
+#error "Please don't include <linux/compiler-gcc5.h> directly, include <linux/compiler.h> instead."
+#endif
+
+#define __used			__attribute__((__used__))
+#define __must_check		__attribute__((warn_unused_result))
+#define __compiler_offsetof(a, b) __builtin_offsetof(a, b)
+
+/* Mark functions as cold. gcc will assume any path leading to a call
+   to them will be unlikely.  This means a lot of manual unlikely()s
+   are unnecessary now for any paths leading to the usual suspects
+   like BUG(), printk(), panic() etc. [but let's keep them for now for
+   older compilers]
+
+   Early snapshots of gcc 4.3 don't support this and we can't detect this
+   in the preprocessor, but we can live with this because they're unreleased.
+   Maketime probing would be overkill here.
+
+   gcc also has a __attribute__((__hot__)) to move hot functions into
+   a special section, but I don't see any sense in this right now in
+   the kernel context */
+#define __cold		__attribute__((__cold__))
+
+#define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
+
+#ifndef __CHECKER__
+# define __compiletime_warning(message) __attribute__((warning(message)))
+# define __compiletime_error(message) __attribute__((error(message)))
+#endif /* __CHECKER__ */
+
+/*
+ * Mark a position in code as unreachable.  This can be used to
+ * suppress control flow warnings after asm blocks that transfer
+ * control elsewhere.
+ */
+#define unreachable()	__builtin_unreachable()
+
+/* Mark a function definition as prohibited from being cloned. */
+#define __noclone	__attribute__((__noclone__))
+
+/*
+ * Tell the optimizer that something else uses this function or variable.
+ */
+#define __visible	__attribute__((externally_visible))
+
+#define asm_volatile_goto(x...)	asm goto(x)
+
+#ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
+#define __HAVE_BUILTIN_BSWAP32__
+#define __HAVE_BUILTIN_BSWAP64__
+#define __HAVE_BUILTIN_BSWAP16__
+#endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
-- 
1.9.1

