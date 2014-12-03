Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaLCWcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:32:11 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:33957 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaLCWa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:30:27 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 1/9] kernel: Provide READ_ONCE and ASSIGN_ONCE
Date: Wed,  3 Dec 2014 23:30:13 +0100
Message-Id: <1417645821-54731-2-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417645821-54731-1-git-send-email-borntraeger@de.ibm.com>
References: <1417645821-54731-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120322-0029-0000-0000-000002028C36
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
 include/linux/compiler.h | 64 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index d5ad7b1..947710e 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -186,6 +186,70 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 # define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __LINE__)
 #endif
 
+#include <linux/types.h>
+
+void data_access_exceeds_word_size(void)
+__compiletime_warning("data access exceeds word size and won't be atomic");
+
+static __always_inline void __read_once_size(volatile void *p, void *res, int size)
+{
+	switch (size) {
+	case 1: *(u8 *)res = *(volatile u8 *)p; break;
+	case 2: *(u16 *)res = *(volatile u16 *)p; break;
+	case 4: *(u32 *)res = *(volatile u32 *)p; break;
+#ifdef CONFIG_64BIT
+	case 8: *(u64 *)res = *(volatile u64 *)p; break;
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
+	case 1: *(volatile u8 *)p = *(u8 *)res; break;
+	case 2: *(volatile u16 *)p = *(u16 *)res; break;
+	case 4: *(volatile u32 *)p = *(u32 *)res; break;
+#ifdef CONFIG_64BIT
+	case 8: *(volatile u64 *)p = *(u64 *)res; break;
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
+ * Prevent the compiler from merging or refetching reads or writes. The compiler
+ * is also forbidden from reordering successive instances of READ_ONCE,
+ * ASSIGN_ONCE and ACCESS_ONCE (see below), but only when the compiler is aware
+ * of some particular ordering.  One way to make the compiler aware of ordering
+ * is to put the two invocations of READ_ONCE, ASSIGN_ONCE or ACCESS_ONCE() in
+ * different C statements.
+ *
+ * In contrast to ACCESS_ONCE these two macros will also work on aggregate data
+ * types like structs or unions. If the size of the accessed data type exceeds
+ * the word size of the machine (e.g. 32bit or 64bit), the access might happen
+ * in multiple chunks, though.
+ *
+ * These macros do absolutely -nothing- to prevent the CPU from reordering,
+ * merging, or refetching absolutely anything at any time.  Their main intended
+ * use is to mediate communication between process-level code and irq/NMI
+ * handlers, all running on the same CPU.
+ */
+
+#define READ_ONCE(p) \
+      ({ typeof(p) __val; __read_once_size(&p, &__val, sizeof(__val)); __val; })
+
+#define ASSIGN_ONCE(val, p) \
+      ({ typeof(p) __val; __val = val; __assign_once_size(&p, &__val, sizeof(__val)); __val; })
+
 #endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */
-- 
1.9.3

