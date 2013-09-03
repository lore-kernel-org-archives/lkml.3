Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705Ab3ICUM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 16:12:28 -0400
Received: from a9-99.smtp-out.amazonses.com ([54.240.9.99]:60007 "EHLO
	a9-99.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755623Ab3ICUMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 16:12:25 -0400
Message-ID: <00000140e5745029-f4163dec-02e5-47a1-a36a-9802ebe0e151-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Tue, 3 Sep 2013 20:12:19 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [gcv v4 03/38] Subject; percpu: Add raw_cpu_ops
References: <20130903190014.794420260@linux.com>
X-SES-Outgoing: 2013.09.03-54.240.9.99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches add preemption checks to __this_cpu ops so we need
to have an alternative way to use this cpu operations without all checks.

raw_cpu ops rely on the __this_cpu_xxx_1/2/4/8 operations having no
preemption checks. We therefore do not have to duplicate these functions
but can affort to only duplicate the higher level macros.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/percpu.h
===================================================================
--- linux.orig/include/linux/percpu.h	2013-09-03 13:31:40.519232161 -0500
+++ linux/include/linux/percpu.h	2013-09-03 13:37:30.511691516 -0500
@@ -520,17 +520,7 @@ do {									\
 
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
@@ -755,4 +745,74 @@ do {									\
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

