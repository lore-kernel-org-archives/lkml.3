Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab3IXPlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:41:44 -0400
Received: from a9-74.smtp-out.amazonses.com ([54.240.9.74]:33376 "EHLO
	a9-74.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559Ab3IXPlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:41:42 -0400
Message-ID: <0000014150a2131e-b4520b78-01e6-4a4b-b2ac-db17d4bd0d93-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Tue, 24 Sep 2013 15:41:41 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [pchecks v2 1/2] Subject; percpu: Add raw_cpu_ops
References: <20130924154159.855373283@linux.com>
X-SES-Outgoing: 2013.09.24-54.240.9.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches will add preemption checks to __this_cpu ops so we
need to have an alternative way to use this cpu operations without
preemption checks.

raw_cpu ops rely on the __this_cpu_xxx_1/2/4/8 operations having no
preemption checks. We therefore do not have to duplicate these functions
but can affort to only duplicate the higher level macros.

Also add raw_cpu_ptr for symmetries sake.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/percpu.h
===================================================================
--- linux.orig/include/linux/percpu.h	2013-09-23 10:20:05.050535801 -0500
+++ linux/include/linux/percpu.h	2013-09-23 10:20:05.050535801 -0500
@@ -139,6 +139,9 @@ extern int __init pcpu_page_first_chunk(
 				pcpu_fc_populate_pte_fn_t populate_pte_fn);
 #endif
 
+/* For symmetries sake. */
+#define raw_cpu_ptr __this_cpu_ptr
+
 /*
  * Use this to get to a cpu's version of the per-cpu object
  * dynamically allocated. Non-atomic access to the current CPU's
@@ -520,17 +523,7 @@ do {									\
 
 /*
  * Generic percpu operations for context that are safe from preemption/interrupts.
- * Either we do not care about races or the caller has the
- * responsibility of handling preemption/interrupt issues. Arch code can still
- * override these instructions since the arch per cpu code may be more
- * efficient and may actually get race freeness for free (that is the
- * case for x86 for example).
- *
- * If there is no other protection through preempt disable and/or
- * disabling interupts then one of these RMW operations can show unexpected
- * behavior because the execution thread was rescheduled on another processor
- * or an interrupt occurred and the same percpu variable was modified from
- * the interrupt context.
+ * These functions verify that preemption has been disabled.
  */
 #ifndef __this_cpu_read
 # ifndef __this_cpu_read_1
@@ -755,4 +748,74 @@ do {									\
 	__pcpu_double_call_return_bool(__this_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
 #endif
 
+/*
+ * Generic percpu operations for context where we do not want to do
+ * any checks for preemptiosn.
+ *
+ * If there is no other protection through preempt disable and/or
+ * disabling interupts then one of these RMW operations can show unexpected
+ * behavior because the execution thread was rescheduled on another processor
+ * or an interrupt occurred and the same percpu variable was modified from
+ * the interrupt context.
+ */
+#ifndef raw_cpu_read
+# define raw_cpu_read(pcp)	__pcpu_size_call_return(__this_cpu_read_, (pcp))
+#endif
+
+#ifndef raw_cpu_write
+# define raw_cpu_write(pcp, val)	__pcpu_size_call(__this_cpu_write_, (pcp), (val))
+#endif
+
+#ifndef raw_cpu_add
+# define raw_cpu_add(pcp, val)	__pcpu_size_call(__this_cpu_add_, (pcp), (val))
+#endif
+
+#ifndef raw_cpu_sub
+# define raw_cpu_sub(pcp, val)	raw_cpu_add((pcp), -(val))
+#endif
+
+#ifndef raw_cpu_inc
+# define raw_cpu_inc(pcp)		raw_cpu_add((pcp), 1)
+#endif
+
+#ifndef raw_cpu_dec
+# define raw_cpu_dec(pcp)		raw_cpu_sub((pcp), 1)
+#endif
+
+#ifndef raw_cpu_and
+# define raw_cpu_and(pcp, val)	__pcpu_size_call(__this_cpu_and_, (pcp), (val))
+#endif
+
+#ifndef raw_cpu_or
+# define raw_cpu_or(pcp, val)	__pcpu_size_call(__this_cpu_or_, (pcp), (val))
+#endif
+
+#ifndef raw_cpu_xor
+# define raw_cpu_xor(pcp, val)	__pcpu_size_call(__this_cpu_xor_, (pcp), (val))
+#endif
+
+#ifndef raw_cpu_add_return
+# define raw_cpu_add_return(pcp, val)	\
+	__pcpu_size_call_return2(__this_cpu_add_return_, pcp, val)
+#endif
+
+#define raw_cpu_sub_return(pcp, val)	raw_cpu_add_return(pcp, -(val))
+#define raw_cpu_inc_return(pcp)	raw_cpu_add_return(pcp, 1)
+#define raw_cpu_dec_return(pcp)	raw_cpu_add_return(pcp, -1)
+
+#ifndef raw_cpu_xchg
+# define raw_cpu_xchg(pcp, nval)	\
+	__pcpu_size_call_return2(__this_cpu_xchg_, (pcp), nval)
+#endif
+
+#ifndef raw_cpu_cmpxchg
+# define raw_cpu_cmpxchg(pcp, oval, nval)	\
+	__pcpu_size_call_return2(__this_cpu_cmpxchg_, pcp, oval, nval)
+#endif
+
+#ifndef raw_cpu_cmpxchg_double
+# define raw_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	__pcpu_double_call_return_bool(__this_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
+#endif
+
 #endif /* __LINUX_PERCPU_H */

