Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964869AbaLKOFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 09:05:31 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:50068 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934026AbaLKOF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 09:05:26 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, George Spelvin <linux@horizon.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 1/8] kernel: Provide READ_ONCE and ASSIGN_ONCE
Date: Thu, 11 Dec 2014 15:05:04 +0100
Message-Id: <1418306712-17245-2-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418306712-17245-1-git-send-email-borntraeger@de.ibm.com>
References: <1418306712-17245-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121114-0021-0000-0000-0000021A74E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACCESS_ONCE does not work reliably on non-scalar types. For
example gcc 4.6 and 4.7 might remove the volatile tag for such
accesses during the SRA (scalar replacement of aggregates) step
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)

Let's provide READ_ONCE/ASSIGN_ONCE that will do all accesses via
scalar types as suggested by Linus Torvalds. Accesses larger than
the machines word size cannot be guaranteed to be atomic. These
macros will use memcpy and emit a build warning.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 include/linux/compiler.h | 70 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/Makefile             |  2 +-
 lib/access.c             |  8 ++++++
 3 files changed, 79 insertions(+), 1 deletion(-)
 create mode 100644 lib/access.c

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index d5ad7b1..1437f02 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -186,6 +186,76 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 # define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __LINE__)
 #endif
 
+#include <uapi/linux/types.h>
+
+void data_access_exceeds_word_size(void)
+#ifdef __compiletime_warning
+__compiletime_warning("data access exceeds word size and won't be atomic")
+#endif
+;
+
+static __always_inline void __read_once_size(volatile void *p, void *res, int size)
+{
+	switch (size) {
+	case 1: *(__u8 *)res = *(volatile __u8 *)p; break;
+	case 2: *(__u16 *)res = *(volatile __u16 *)p; break;
+	case 4: *(__u32 *)res = *(volatile __u32 *)p; break;
+#ifdef CONFIG_64BIT
+	case 8: *(__u64 *)res = *(volatile __u64 *)p; break;
+#endif
+	default:
+		barrier();
+		__builtin_memcpy((void *)res, (const void *)p, size);
+		data_access_exceeds_word_size();
+		barrier();
+	}
+}
+
+static __always_inline void __assign_once_size(volatile void *p, void *res, int size)
+{
+	switch (size) {
+	case 1: *(volatile __u8 *)p = *(__u8 *)res; break;
+	case 2: *(volatile __u16 *)p = *(__u16 *)res; break;
+	case 4: *(volatile __u32 *)p = *(__u32 *)res; break;
+#ifdef CONFIG_64BIT
+	case 8: *(volatile __u64 *)p = *(__u64 *)res; break;
+#endif
+	default:
+		barrier();
+		__builtin_memcpy((void *)p, (const void *)res, size);
+		data_access_exceeds_word_size();
+		barrier();
+	}
+}
+
+/*
+ * Prevent the compiler from merging or refetching reads or writes. The
+ * compiler is also forbidden from reordering successive instances of
+ * READ_ONCE, ASSIGN_ONCE and ACCESS_ONCE (see below), but only when the
+ * compiler is aware of some particular ordering.  One way to make the
+ * compiler aware of ordering is to put the two invocations of READ_ONCE,
+ * ASSIGN_ONCE or ACCESS_ONCE() in different C statements.
+ *
+ * In contrast to ACCESS_ONCE these two macros will also work on aggregate
+ * data types like structs or unions. If the size of the accessed data
+ * type exceeds the word size of the machine (e.g., 32 bits or 64 bits)
+ * READ_ONCE() and ASSIGN_ONCE()  will fall back to memcpy and print a
+ * compile-time warning.
+ *
+ * Their two major use cases are: (1) Mediating communication between
+ * process-level code and irq/NMI handlers, all running on the same CPU,
+ * and (2) Ensuring that the compiler does not  fold, spindle, or otherwise
+ * mutilate accesses that either do not require ordering or that interact
+ * with an explicit memory barrier or atomic instruction that provides the
+ * required ordering.
+ */
+
+#define READ_ONCE(x) \
+	({ typeof(x) __val; __read_once_size(&x, &__val, sizeof(__val)); __val; })
+
+#define ASSIGN_ONCE(val, x) \
+	({ typeof(x) __val; __val = val; __assign_once_size(&x, &__val, sizeof(__val)); __val; })
+
 #endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */
diff --git a/lib/Makefile b/lib/Makefile
index 7512dc9..264e2d8 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -7,7 +7,7 @@ ORIG_CFLAGS := $(KBUILD_CFLAGS)
 KBUILD_CFLAGS = $(subst -pg,,$(ORIG_CFLAGS))
 endif
 
-lib-y := ctype.o string.o vsprintf.o cmdline.o \
+lib-y := access.o ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o timerqueue.o\
 	 idr.o int_sqrt.o extable.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
diff --git a/lib/access.c b/lib/access.c
new file mode 100644
index 0000000..d56307e
--- /dev/null
+++ b/lib/access.c
@@ -0,0 +1,8 @@
+#include <linux/compiler.h>
+#include <linux/export.h>
+
+void data_access_exceeds_word_size(void)
+{
+}
+EXPORT_SYMBOL(data_access_exceeds_word_size);
+
-- 
1.9.3

