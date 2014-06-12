Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbaFLQXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:23:49 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:35160 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285AbaFLQXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:23:46 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/12] percpu: reorder macros in percpu header files
Date: Thu, 12 Jun 2014 12:23:26 -0400
Message-Id: <1402590209-31610-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402590209-31610-1-git-send-email-tj@kernel.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* In include/asm-generic/percpu.h, collect {raw|_this}_cpu_generic*()
  macros into one place.  They were dispersed through
  {raw|this}_cpu_*_N() definitions and the visiual inconsistency was
  making following the code unnecessarily difficult.

* In include/linux/percpu-defs.h, move __verify_pcpu_ptr() later in
  the file so that it's right above accessor definitions where it's
  actually used.

This is pure reorganization.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 include/asm-generic/percpu.h | 198 +++++++++++++++++++++----------------------
 include/linux/percpu-defs.h  |  40 ++++-----
 2 files changed, 119 insertions(+), 119 deletions(-)

diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index 932ce60..2300d98 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -65,6 +65,105 @@ extern void setup_per_cpu_areas(void);
 #define PER_CPU_DEF_ATTRIBUTES
 #endif
 
+#define raw_cpu_generic_to_op(pcp, val, op)				\
+do {									\
+	*raw_cpu_ptr(&(pcp)) op val;					\
+} while (0)
+
+#define raw_cpu_generic_add_return(pcp, val)				\
+({									\
+	raw_cpu_add(pcp, val);						\
+	raw_cpu_read(pcp);						\
+})
+
+#define raw_cpu_generic_xchg(pcp, nval)					\
+({	typeof(pcp) ret__;						\
+	ret__ = raw_cpu_read(pcp);					\
+	raw_cpu_write(pcp, nval);					\
+	ret__;								\
+})
+
+#define raw_cpu_generic_cmpxchg(pcp, oval, nval)			\
+({									\
+	typeof(pcp) ret__;						\
+	ret__ = raw_cpu_read(pcp);					\
+	if (ret__ == (oval))						\
+		raw_cpu_write(pcp, nval);				\
+	ret__;								\
+})
+
+#define raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+({									\
+	int __ret = 0;							\
+	if (raw_cpu_read(pcp1) == (oval1) &&				\
+			 raw_cpu_read(pcp2)  == (oval2)) {		\
+		raw_cpu_write(pcp1, (nval1));				\
+		raw_cpu_write(pcp2, (nval2));				\
+		__ret = 1;						\
+	}								\
+	(__ret);							\
+})
+
+#define _this_cpu_generic_read(pcp)					\
+({	typeof(pcp) ret__;						\
+	preempt_disable();						\
+	ret__ = *this_cpu_ptr(&(pcp));					\
+	preempt_enable();						\
+	ret__;								\
+})
+
+#define _this_cpu_generic_to_op(pcp, val, op)				\
+do {									\
+	unsigned long flags;						\
+	raw_local_irq_save(flags);					\
+	*raw_cpu_ptr(&(pcp)) op val;					\
+	raw_local_irq_restore(flags);					\
+} while (0)
+
+#define _this_cpu_generic_add_return(pcp, val)				\
+({									\
+	typeof(pcp) ret__;						\
+	unsigned long flags;						\
+	raw_local_irq_save(flags);					\
+	raw_cpu_add(pcp, val);					\
+	ret__ = raw_cpu_read(pcp);					\
+	raw_local_irq_restore(flags);					\
+	ret__;								\
+})
+
+#define _this_cpu_generic_xchg(pcp, nval)				\
+({	typeof(pcp) ret__;						\
+	unsigned long flags;						\
+	raw_local_irq_save(flags);					\
+	ret__ = raw_cpu_read(pcp);					\
+	raw_cpu_write(pcp, nval);					\
+	raw_local_irq_restore(flags);					\
+	ret__;								\
+})
+
+#define _this_cpu_generic_cmpxchg(pcp, oval, nval)			\
+({									\
+	typeof(pcp) ret__;						\
+	unsigned long flags;						\
+	raw_local_irq_save(flags);					\
+	ret__ = raw_cpu_read(pcp);					\
+	if (ret__ == (oval))						\
+		raw_cpu_write(pcp, nval);				\
+	raw_local_irq_restore(flags);					\
+	ret__;								\
+})
+
+#define _this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+({									\
+	int ret__;							\
+	unsigned long flags;						\
+	raw_local_irq_save(flags);					\
+	ret__ = raw_cpu_generic_cmpxchg_double(pcp1, pcp2,		\
+			oval1, oval2, nval1, nval2);			\
+	raw_local_irq_restore(flags);					\
+	ret__;								\
+})
+
 # ifndef raw_cpu_read_1
 #  define raw_cpu_read_1(pcp)	(*raw_cpu_ptr(&(pcp)))
 # endif
@@ -78,11 +177,6 @@ extern void setup_per_cpu_areas(void);
 #  define raw_cpu_read_8(pcp)	(*raw_cpu_ptr(&(pcp)))
 # endif
 
-#define raw_cpu_generic_to_op(pcp, val, op)				\
-do {									\
-	*raw_cpu_ptr(&(pcp)) op val;					\
-} while (0)
-
 # ifndef raw_cpu_write_1
 #  define raw_cpu_write_1(pcp, val)	raw_cpu_generic_to_op((pcp), (val), =)
 # endif
@@ -135,12 +229,6 @@ do {									\
 #  define raw_cpu_or_8(pcp, val)	raw_cpu_generic_to_op((pcp), (val), |=)
 # endif
 
-#define raw_cpu_generic_add_return(pcp, val)				\
-({									\
-	raw_cpu_add(pcp, val);						\
-	raw_cpu_read(pcp);						\
-})
-
 # ifndef raw_cpu_add_return_1
 #  define raw_cpu_add_return_1(pcp, val)	raw_cpu_generic_add_return(pcp, val)
 # endif
@@ -154,13 +242,6 @@ do {									\
 #  define raw_cpu_add_return_8(pcp, val)	raw_cpu_generic_add_return(pcp, val)
 # endif
 
-#define raw_cpu_generic_xchg(pcp, nval)					\
-({	typeof(pcp) ret__;						\
-	ret__ = raw_cpu_read(pcp);					\
-	raw_cpu_write(pcp, nval);					\
-	ret__;								\
-})
-
 # ifndef raw_cpu_xchg_1
 #  define raw_cpu_xchg_1(pcp, nval)	raw_cpu_generic_xchg(pcp, nval)
 # endif
@@ -174,15 +255,6 @@ do {									\
 #  define raw_cpu_xchg_8(pcp, nval)	raw_cpu_generic_xchg(pcp, nval)
 # endif
 
-#define raw_cpu_generic_cmpxchg(pcp, oval, nval)			\
-({									\
-	typeof(pcp) ret__;						\
-	ret__ = raw_cpu_read(pcp);					\
-	if (ret__ == (oval))						\
-		raw_cpu_write(pcp, nval);				\
-	ret__;								\
-})
-
 # ifndef raw_cpu_cmpxchg_1
 #  define raw_cpu_cmpxchg_1(pcp, oval, nval)	raw_cpu_generic_cmpxchg(pcp, oval, nval)
 # endif
@@ -196,18 +268,6 @@ do {									\
 #  define raw_cpu_cmpxchg_8(pcp, oval, nval)	raw_cpu_generic_cmpxchg(pcp, oval, nval)
 # endif
 
-#define raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-({									\
-	int __ret = 0;							\
-	if (raw_cpu_read(pcp1) == (oval1) &&				\
-			 raw_cpu_read(pcp2)  == (oval2)) {		\
-		raw_cpu_write(pcp1, (nval1));				\
-		raw_cpu_write(pcp2, (nval2));				\
-		__ret = 1;						\
-	}								\
-	(__ret);							\
-})
-
 # ifndef raw_cpu_cmpxchg_double_1
 #  define raw_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
 	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
@@ -225,14 +285,6 @@ do {									\
 	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
 # endif
 
-#define _this_cpu_generic_read(pcp)					\
-({	typeof(pcp) ret__;						\
-	preempt_disable();						\
-	ret__ = *this_cpu_ptr(&(pcp));					\
-	preempt_enable();						\
-	ret__;								\
-})
-
 # ifndef this_cpu_read_1
 #  define this_cpu_read_1(pcp)	_this_cpu_generic_read(pcp)
 # endif
@@ -246,14 +298,6 @@ do {									\
 #  define this_cpu_read_8(pcp)	_this_cpu_generic_read(pcp)
 # endif
 
-#define _this_cpu_generic_to_op(pcp, val, op)				\
-do {									\
-	unsigned long flags;						\
-	raw_local_irq_save(flags);					\
-	*raw_cpu_ptr(&(pcp)) op val;					\
-	raw_local_irq_restore(flags);					\
-} while (0)
-
 # ifndef this_cpu_write_1
 #  define this_cpu_write_1(pcp, val)	_this_cpu_generic_to_op((pcp), (val), =)
 # endif
@@ -306,17 +350,6 @@ do {									\
 #  define this_cpu_or_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), |=)
 # endif
 
-#define _this_cpu_generic_add_return(pcp, val)				\
-({									\
-	typeof(pcp) ret__;						\
-	unsigned long flags;						\
-	raw_local_irq_save(flags);					\
-	raw_cpu_add(pcp, val);					\
-	ret__ = raw_cpu_read(pcp);					\
-	raw_local_irq_restore(flags);					\
-	ret__;								\
-})
-
 # ifndef this_cpu_add_return_1
 #  define this_cpu_add_return_1(pcp, val)	_this_cpu_generic_add_return(pcp, val)
 # endif
@@ -330,16 +363,6 @@ do {									\
 #  define this_cpu_add_return_8(pcp, val)	_this_cpu_generic_add_return(pcp, val)
 # endif
 
-#define _this_cpu_generic_xchg(pcp, nval)				\
-({	typeof(pcp) ret__;						\
-	unsigned long flags;						\
-	raw_local_irq_save(flags);					\
-	ret__ = raw_cpu_read(pcp);					\
-	raw_cpu_write(pcp, nval);					\
-	raw_local_irq_restore(flags);					\
-	ret__;								\
-})
-
 # ifndef this_cpu_xchg_1
 #  define this_cpu_xchg_1(pcp, nval)	_this_cpu_generic_xchg(pcp, nval)
 # endif
@@ -353,18 +376,6 @@ do {									\
 #  define this_cpu_xchg_8(pcp, nval)	_this_cpu_generic_xchg(pcp, nval)
 # endif
 
-#define _this_cpu_generic_cmpxchg(pcp, oval, nval)			\
-({									\
-	typeof(pcp) ret__;						\
-	unsigned long flags;						\
-	raw_local_irq_save(flags);					\
-	ret__ = raw_cpu_read(pcp);					\
-	if (ret__ == (oval))						\
-		raw_cpu_write(pcp, nval);				\
-	raw_local_irq_restore(flags);					\
-	ret__;								\
-})
-
 # ifndef this_cpu_cmpxchg_1
 #  define this_cpu_cmpxchg_1(pcp, oval, nval)	_this_cpu_generic_cmpxchg(pcp, oval, nval)
 # endif
@@ -378,17 +389,6 @@ do {									\
 #  define this_cpu_cmpxchg_8(pcp, oval, nval)	_this_cpu_generic_cmpxchg(pcp, oval, nval)
 # endif
 
-#define _this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-({									\
-	int ret__;							\
-	unsigned long flags;						\
-	raw_local_irq_save(flags);					\
-	ret__ = raw_cpu_generic_cmpxchg_double(pcp1, pcp2,		\
-			oval1, oval2, nval1, nval2);			\
-	raw_local_irq_restore(flags);					\
-	ret__;								\
-})
-
 # ifndef this_cpu_cmpxchg_double_1
 #  define this_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
 	_this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 8e66e76..2dcacc5 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -55,26 +55,6 @@
 	__attribute__((section(".discard"), unused))
 
 /*
- * This macro serves two purposes.  It verifies @ptr is a percpu pointer
- * without evaluating @ptr and provides the data dependency barrier paired
- * with smp_wmb() at the end of the allocation path so that the memory
- * clearing in the allocation path is visible to all percpu accsses.
- *
- * The existence of the data dependency barrier is guaranteed and percpu
- * users can take advantage of it - e.g. percpu area updates followed by
- * smp_wmb() and then a percpu pointer assignment are guaranteed to be
- * visible to accessors which access through the assigned percpu pointer.
- *
- * + 0 is required in order to convert the pointer type from a
- * potential array type to a pointer to a single item of the array.
- */
-#define __verify_pcpu_ptr(ptr)	do {					\
-	const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;	\
-	(void)__vpp_verify;						\
-	smp_read_barrier_depends();					\
-} while (0)
-
-/*
  * s390 and alpha modules require percpu variables to be defined as
  * weak to force the compiler to generate GOT based external
  * references for them.  This is necessary because percpu sections
@@ -212,6 +192,26 @@
  */
 #ifndef __ASSEMBLY__
 
+/*
+ * This macro serves two purposes.  It verifies @ptr is a percpu pointer
+ * without evaluating @ptr and provides the data dependency barrier paired
+ * with smp_wmb() at the end of the allocation path so that the memory
+ * clearing in the allocation path is visible to all percpu accsses.
+ *
+ * The existence of the data dependency barrier is guaranteed and percpu
+ * users can take advantage of it - e.g. percpu area updates followed by
+ * smp_wmb() and then a percpu pointer assignment are guaranteed to be
+ * visible to accessors which access through the assigned percpu pointer.
+ *
+ * + 0 is required in order to convert the pointer type from a
+ * potential array type to a pointer to a single item of the array.
+ */
+#define __verify_pcpu_ptr(ptr)	do {					\
+	const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;	\
+	(void)__vpp_verify;						\
+	smp_read_barrier_depends();					\
+} while (0)
+
 #ifdef CONFIG_SMP
 
 /*
-- 
1.9.3

