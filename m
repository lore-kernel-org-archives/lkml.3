Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbaFLQ1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:27:49 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46447 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270AbaFLQXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:23:45 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/12] percpu: move {raw|this}_cpu_*() definitions to include/linux/percpu-defs.h
Date: Thu, 12 Jun 2014 12:23:25 -0400
Message-Id: <1402590209-31610-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402590209-31610-1-git-send-email-tj@kernel.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're in the process of moving all percpu accessors and operations to
include/linux/percpu-defs.h so that they're available to arch headers
without having to include full include/linux/percpu.h which may cause
cyclic inclusion dependency.

This patch moves {raw|this}_cpu_*() definitions from
include/linux/percpu.h to include/linux/percpu-defs.h.  The code is
moved mostly verbatim; however, raw_cpu_*() are placed above
this_cpu_*() which is more conventional as the raw operations may be
used to defined other variants.

This is pure reorganization.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 include/linux/percpu-defs.h | 209 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/percpu.h      | 208 -------------------------------------------
 2 files changed, 209 insertions(+), 208 deletions(-)

diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index bd86f46..8e66e76 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -279,5 +279,214 @@
 	preempt_enable();				\
 } while (0)
 
+/*
+ * Branching function to split up a function into a set of functions that
+ * are called for different scalar sizes of the objects handled.
+ */
+
+extern void __bad_size_call_parameter(void);
+
+#ifdef CONFIG_DEBUG_PREEMPT
+extern void __this_cpu_preempt_check(const char *op);
+#else
+static inline void __this_cpu_preempt_check(const char *op) { }
+#endif
+
+#define __pcpu_size_call_return(stem, variable)				\
+({	typeof(variable) pscr_ret__;					\
+	__verify_pcpu_ptr(&(variable));					\
+	switch(sizeof(variable)) {					\
+	case 1: pscr_ret__ = stem##1(variable);break;			\
+	case 2: pscr_ret__ = stem##2(variable);break;			\
+	case 4: pscr_ret__ = stem##4(variable);break;			\
+	case 8: pscr_ret__ = stem##8(variable);break;			\
+	default:							\
+		__bad_size_call_parameter();break;			\
+	}								\
+	pscr_ret__;							\
+})
+
+#define __pcpu_size_call_return2(stem, variable, ...)			\
+({									\
+	typeof(variable) pscr2_ret__;					\
+	__verify_pcpu_ptr(&(variable));					\
+	switch(sizeof(variable)) {					\
+	case 1: pscr2_ret__ = stem##1(variable, __VA_ARGS__); break;	\
+	case 2: pscr2_ret__ = stem##2(variable, __VA_ARGS__); break;	\
+	case 4: pscr2_ret__ = stem##4(variable, __VA_ARGS__); break;	\
+	case 8: pscr2_ret__ = stem##8(variable, __VA_ARGS__); break;	\
+	default:							\
+		__bad_size_call_parameter(); break;			\
+	}								\
+	pscr2_ret__;							\
+})
+
+/*
+ * Special handling for cmpxchg_double.  cmpxchg_double is passed two
+ * percpu variables.  The first has to be aligned to a double word
+ * boundary and the second has to follow directly thereafter.
+ * We enforce this on all architectures even if they don't support
+ * a double cmpxchg instruction, since it's a cheap requirement, and it
+ * avoids breaking the requirement for architectures with the instruction.
+ */
+#define __pcpu_double_call_return_bool(stem, pcp1, pcp2, ...)		\
+({									\
+	bool pdcrb_ret__;						\
+	__verify_pcpu_ptr(&pcp1);					\
+	BUILD_BUG_ON(sizeof(pcp1) != sizeof(pcp2));			\
+	VM_BUG_ON((unsigned long)(&pcp1) % (2 * sizeof(pcp1)));		\
+	VM_BUG_ON((unsigned long)(&pcp2) !=				\
+		  (unsigned long)(&pcp1) + sizeof(pcp1));		\
+	switch(sizeof(pcp1)) {						\
+	case 1: pdcrb_ret__ = stem##1(pcp1, pcp2, __VA_ARGS__); break;	\
+	case 2: pdcrb_ret__ = stem##2(pcp1, pcp2, __VA_ARGS__); break;	\
+	case 4: pdcrb_ret__ = stem##4(pcp1, pcp2, __VA_ARGS__); break;	\
+	case 8: pdcrb_ret__ = stem##8(pcp1, pcp2, __VA_ARGS__); break;	\
+	default:							\
+		__bad_size_call_parameter(); break;			\
+	}								\
+	pdcrb_ret__;							\
+})
+
+#define __pcpu_size_call(stem, variable, ...)				\
+do {									\
+	__verify_pcpu_ptr(&(variable));					\
+	switch(sizeof(variable)) {					\
+		case 1: stem##1(variable, __VA_ARGS__);break;		\
+		case 2: stem##2(variable, __VA_ARGS__);break;		\
+		case 4: stem##4(variable, __VA_ARGS__);break;		\
+		case 8: stem##8(variable, __VA_ARGS__);break;		\
+		default: 						\
+			__bad_size_call_parameter();break;		\
+	}								\
+} while (0)
+
+/*
+ * this_cpu operations (C) 2008-2013 Christoph Lameter <cl@linux.com>
+ *
+ * Optimized manipulation for memory allocated through the per cpu
+ * allocator or for addresses of per cpu variables.
+ *
+ * These operation guarantee exclusivity of access for other operations
+ * on the *same* processor. The assumption is that per cpu data is only
+ * accessed by a single processor instance (the current one).
+ *
+ * The arch code can provide optimized implementation by defining macros
+ * for certain scalar sizes. F.e. provide this_cpu_add_2() to provide per
+ * cpu atomic operations for 2 byte sized RMW actions. If arch code does
+ * not provide operations for a scalar size then the fallback in the
+ * generic code will be used.
+ */
+
+/*
+ * Generic percpu operations for contexts where we do not want to do
+ * any checks for preemptiosn.
+ *
+ * If there is no other protection through preempt disable and/or
+ * disabling interupts then one of these RMW operations can show unexpected
+ * behavior because the execution thread was rescheduled on another processor
+ * or an interrupt occurred and the same percpu variable was modified from
+ * the interrupt context.
+ */
+# define raw_cpu_read(pcp)	__pcpu_size_call_return(raw_cpu_read_, (pcp))
+# define raw_cpu_write(pcp, val)	__pcpu_size_call(raw_cpu_write_, (pcp), (val))
+# define raw_cpu_add(pcp, val)	__pcpu_size_call(raw_cpu_add_, (pcp), (val))
+# define raw_cpu_sub(pcp, val)	raw_cpu_add((pcp), -(val))
+# define raw_cpu_inc(pcp)		raw_cpu_add((pcp), 1)
+# define raw_cpu_dec(pcp)		raw_cpu_sub((pcp), 1)
+# define raw_cpu_and(pcp, val)	__pcpu_size_call(raw_cpu_and_, (pcp), (val))
+# define raw_cpu_or(pcp, val)	__pcpu_size_call(raw_cpu_or_, (pcp), (val))
+# define raw_cpu_add_return(pcp, val)	\
+	__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val)
+#define raw_cpu_sub_return(pcp, val)	raw_cpu_add_return(pcp, -(typeof(pcp))(val))
+#define raw_cpu_inc_return(pcp)	raw_cpu_add_return(pcp, 1)
+#define raw_cpu_dec_return(pcp)	raw_cpu_add_return(pcp, -1)
+# define raw_cpu_xchg(pcp, nval)	\
+	__pcpu_size_call_return2(raw_cpu_xchg_, (pcp), nval)
+# define raw_cpu_cmpxchg(pcp, oval, nval)	\
+	__pcpu_size_call_return2(raw_cpu_cmpxchg_, pcp, oval, nval)
+# define raw_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	__pcpu_double_call_return_bool(raw_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
+
+/*
+ * Generic percpu operations for context that are safe from preemption/interrupts.
+ */
+# define __this_cpu_read(pcp) \
+	(__this_cpu_preempt_check("read"),__pcpu_size_call_return(raw_cpu_read_, (pcp)))
+
+# define __this_cpu_write(pcp, val)					\
+do { __this_cpu_preempt_check("write");					\
+     __pcpu_size_call(raw_cpu_write_, (pcp), (val));			\
+} while (0)
+
+# define __this_cpu_add(pcp, val)					 \
+do { __this_cpu_preempt_check("add");					\
+	__pcpu_size_call(raw_cpu_add_, (pcp), (val));			\
+} while (0)
+
+# define __this_cpu_sub(pcp, val)	__this_cpu_add((pcp), -(typeof(pcp))(val))
+# define __this_cpu_inc(pcp)		__this_cpu_add((pcp), 1)
+# define __this_cpu_dec(pcp)		__this_cpu_sub((pcp), 1)
+
+# define __this_cpu_and(pcp, val)					\
+do { __this_cpu_preempt_check("and");					\
+	__pcpu_size_call(raw_cpu_and_, (pcp), (val));			\
+} while (0)
+
+# define __this_cpu_or(pcp, val)					\
+do { __this_cpu_preempt_check("or");					\
+	__pcpu_size_call(raw_cpu_or_, (pcp), (val));			\
+} while (0)
+
+# define __this_cpu_add_return(pcp, val)	\
+	(__this_cpu_preempt_check("add_return"),__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val))
+
+#define __this_cpu_sub_return(pcp, val)	__this_cpu_add_return(pcp, -(typeof(pcp))(val))
+#define __this_cpu_inc_return(pcp)	__this_cpu_add_return(pcp, 1)
+#define __this_cpu_dec_return(pcp)	__this_cpu_add_return(pcp, -1)
+
+# define __this_cpu_xchg(pcp, nval)	\
+	(__this_cpu_preempt_check("xchg"),__pcpu_size_call_return2(raw_cpu_xchg_, (pcp), nval))
+
+# define __this_cpu_cmpxchg(pcp, oval, nval)	\
+	(__this_cpu_preempt_check("cmpxchg"),__pcpu_size_call_return2(raw_cpu_cmpxchg_, pcp, oval, nval))
+
+# define __this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	(__this_cpu_preempt_check("cmpxchg_double"),__pcpu_double_call_return_bool(raw_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2)))
+
+/*
+ * this_cpu_*() operations are used for accesses that must be done in a
+ * preemption safe way since we know that the context is not preempt
+ * safe. Interrupts may occur. If the interrupt modifies the variable too
+ * then RMW actions will not be reliable.
+ */
+# define this_cpu_read(pcp)	__pcpu_size_call_return(this_cpu_read_, (pcp))
+# define this_cpu_write(pcp, val)	__pcpu_size_call(this_cpu_write_, (pcp), (val))
+# define this_cpu_add(pcp, val)		__pcpu_size_call(this_cpu_add_, (pcp), (val))
+# define this_cpu_sub(pcp, val)		this_cpu_add((pcp), -(typeof(pcp))(val))
+# define this_cpu_inc(pcp)		this_cpu_add((pcp), 1)
+# define this_cpu_dec(pcp)		this_cpu_sub((pcp), 1)
+# define this_cpu_and(pcp, val)		__pcpu_size_call(this_cpu_and_, (pcp), (val))
+# define this_cpu_or(pcp, val)		__pcpu_size_call(this_cpu_or_, (pcp), (val))
+# define this_cpu_add_return(pcp, val)	__pcpu_size_call_return2(this_cpu_add_return_, pcp, val)
+#define this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(typeof(pcp))(val))
+#define this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
+#define this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
+# define this_cpu_xchg(pcp, nval)	\
+	__pcpu_size_call_return2(this_cpu_xchg_, (pcp), nval)
+# define this_cpu_cmpxchg(pcp, oval, nval)	\
+	__pcpu_size_call_return2(this_cpu_cmpxchg_, pcp, oval, nval)
+
+/*
+ * cmpxchg_double replaces two adjacent scalars at once.  The first
+ * two parameters are per cpu variables which have to be of the same
+ * size.  A truth value is returned to indicate success or failure
+ * (since a double register result is difficult to handle).  There is
+ * very limited hardware support for these operations, so only certain
+ * sizes may work.
+ */
+# define this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	__pcpu_double_call_return_bool(this_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
+
 #endif /* __ASSEMBLY__ */
 #endif /* _LINUX_PERCPU_DEFS_H */
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 20b9535..6f61b61 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -129,212 +129,4 @@ extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
 #define alloc_percpu(type)	\
 	(typeof(type) __percpu *)__alloc_percpu(sizeof(type), __alignof__(type))
 
-/*
- * Branching function to split up a function into a set of functions that
- * are called for different scalar sizes of the objects handled.
- */
-
-extern void __bad_size_call_parameter(void);
-
-#ifdef CONFIG_DEBUG_PREEMPT
-extern void __this_cpu_preempt_check(const char *op);
-#else
-static inline void __this_cpu_preempt_check(const char *op) { }
-#endif
-
-#define __pcpu_size_call_return(stem, variable)				\
-({	typeof(variable) pscr_ret__;					\
-	__verify_pcpu_ptr(&(variable));					\
-	switch(sizeof(variable)) {					\
-	case 1: pscr_ret__ = stem##1(variable);break;			\
-	case 2: pscr_ret__ = stem##2(variable);break;			\
-	case 4: pscr_ret__ = stem##4(variable);break;			\
-	case 8: pscr_ret__ = stem##8(variable);break;			\
-	default:							\
-		__bad_size_call_parameter();break;			\
-	}								\
-	pscr_ret__;							\
-})
-
-#define __pcpu_size_call_return2(stem, variable, ...)			\
-({									\
-	typeof(variable) pscr2_ret__;					\
-	__verify_pcpu_ptr(&(variable));					\
-	switch(sizeof(variable)) {					\
-	case 1: pscr2_ret__ = stem##1(variable, __VA_ARGS__); break;	\
-	case 2: pscr2_ret__ = stem##2(variable, __VA_ARGS__); break;	\
-	case 4: pscr2_ret__ = stem##4(variable, __VA_ARGS__); break;	\
-	case 8: pscr2_ret__ = stem##8(variable, __VA_ARGS__); break;	\
-	default:							\
-		__bad_size_call_parameter(); break;			\
-	}								\
-	pscr2_ret__;							\
-})
-
-/*
- * Special handling for cmpxchg_double.  cmpxchg_double is passed two
- * percpu variables.  The first has to be aligned to a double word
- * boundary and the second has to follow directly thereafter.
- * We enforce this on all architectures even if they don't support
- * a double cmpxchg instruction, since it's a cheap requirement, and it
- * avoids breaking the requirement for architectures with the instruction.
- */
-#define __pcpu_double_call_return_bool(stem, pcp1, pcp2, ...)		\
-({									\
-	bool pdcrb_ret__;						\
-	__verify_pcpu_ptr(&pcp1);					\
-	BUILD_BUG_ON(sizeof(pcp1) != sizeof(pcp2));			\
-	VM_BUG_ON((unsigned long)(&pcp1) % (2 * sizeof(pcp1)));		\
-	VM_BUG_ON((unsigned long)(&pcp2) !=				\
-		  (unsigned long)(&pcp1) + sizeof(pcp1));		\
-	switch(sizeof(pcp1)) {						\
-	case 1: pdcrb_ret__ = stem##1(pcp1, pcp2, __VA_ARGS__); break;	\
-	case 2: pdcrb_ret__ = stem##2(pcp1, pcp2, __VA_ARGS__); break;	\
-	case 4: pdcrb_ret__ = stem##4(pcp1, pcp2, __VA_ARGS__); break;	\
-	case 8: pdcrb_ret__ = stem##8(pcp1, pcp2, __VA_ARGS__); break;	\
-	default:							\
-		__bad_size_call_parameter(); break;			\
-	}								\
-	pdcrb_ret__;							\
-})
-
-#define __pcpu_size_call(stem, variable, ...)				\
-do {									\
-	__verify_pcpu_ptr(&(variable));					\
-	switch(sizeof(variable)) {					\
-		case 1: stem##1(variable, __VA_ARGS__);break;		\
-		case 2: stem##2(variable, __VA_ARGS__);break;		\
-		case 4: stem##4(variable, __VA_ARGS__);break;		\
-		case 8: stem##8(variable, __VA_ARGS__);break;		\
-		default: 						\
-			__bad_size_call_parameter();break;		\
-	}								\
-} while (0)
-
-/*
- * this_cpu operations (C) 2008-2013 Christoph Lameter <cl@linux.com>
- *
- * Optimized manipulation for memory allocated through the per cpu
- * allocator or for addresses of per cpu variables.
- *
- * These operation guarantee exclusivity of access for other operations
- * on the *same* processor. The assumption is that per cpu data is only
- * accessed by a single processor instance (the current one).
- *
- * The first group is used for accesses that must be done in a
- * preemption safe way since we know that the context is not preempt
- * safe. Interrupts may occur. If the interrupt modifies the variable
- * too then RMW actions will not be reliable.
- *
- * The arch code can provide optimized implementation by defining macros
- * for certain scalar sizes. F.e. provide this_cpu_add_2() to provide per
- * cpu atomic operations for 2 byte sized RMW actions. If arch code does
- * not provide operations for a scalar size then the fallback in the
- * generic code will be used.
- */
-
-# define this_cpu_read(pcp)	__pcpu_size_call_return(this_cpu_read_, (pcp))
-# define this_cpu_write(pcp, val)	__pcpu_size_call(this_cpu_write_, (pcp), (val))
-# define this_cpu_add(pcp, val)		__pcpu_size_call(this_cpu_add_, (pcp), (val))
-# define this_cpu_sub(pcp, val)		this_cpu_add((pcp), -(typeof(pcp))(val))
-# define this_cpu_inc(pcp)		this_cpu_add((pcp), 1)
-# define this_cpu_dec(pcp)		this_cpu_sub((pcp), 1)
-# define this_cpu_and(pcp, val)		__pcpu_size_call(this_cpu_and_, (pcp), (val))
-# define this_cpu_or(pcp, val)		__pcpu_size_call(this_cpu_or_, (pcp), (val))
-# define this_cpu_add_return(pcp, val)	__pcpu_size_call_return2(this_cpu_add_return_, pcp, val)
-#define this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(typeof(pcp))(val))
-#define this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
-#define this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
-# define this_cpu_xchg(pcp, nval)	\
-	__pcpu_size_call_return2(this_cpu_xchg_, (pcp), nval)
-# define this_cpu_cmpxchg(pcp, oval, nval)	\
-	__pcpu_size_call_return2(this_cpu_cmpxchg_, pcp, oval, nval)
-
-/*
- * cmpxchg_double replaces two adjacent scalars at once.  The first
- * two parameters are per cpu variables which have to be of the same
- * size.  A truth value is returned to indicate success or failure
- * (since a double register result is difficult to handle).  There is
- * very limited hardware support for these operations, so only certain
- * sizes may work.
- */
-# define this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__pcpu_double_call_return_bool(this_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
-
-/*
- * Generic percpu operations for contexts where we do not want to do
- * any checks for preemptiosn.
- *
- * If there is no other protection through preempt disable and/or
- * disabling interupts then one of these RMW operations can show unexpected
- * behavior because the execution thread was rescheduled on another processor
- * or an interrupt occurred and the same percpu variable was modified from
- * the interrupt context.
- */
-# define raw_cpu_read(pcp)	__pcpu_size_call_return(raw_cpu_read_, (pcp))
-# define raw_cpu_write(pcp, val)	__pcpu_size_call(raw_cpu_write_, (pcp), (val))
-# define raw_cpu_add(pcp, val)	__pcpu_size_call(raw_cpu_add_, (pcp), (val))
-# define raw_cpu_sub(pcp, val)	raw_cpu_add((pcp), -(val))
-# define raw_cpu_inc(pcp)		raw_cpu_add((pcp), 1)
-# define raw_cpu_dec(pcp)		raw_cpu_sub((pcp), 1)
-# define raw_cpu_and(pcp, val)	__pcpu_size_call(raw_cpu_and_, (pcp), (val))
-# define raw_cpu_or(pcp, val)	__pcpu_size_call(raw_cpu_or_, (pcp), (val))
-# define raw_cpu_add_return(pcp, val)	\
-	__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val)
-#define raw_cpu_sub_return(pcp, val)	raw_cpu_add_return(pcp, -(typeof(pcp))(val))
-#define raw_cpu_inc_return(pcp)	raw_cpu_add_return(pcp, 1)
-#define raw_cpu_dec_return(pcp)	raw_cpu_add_return(pcp, -1)
-# define raw_cpu_xchg(pcp, nval)	\
-	__pcpu_size_call_return2(raw_cpu_xchg_, (pcp), nval)
-# define raw_cpu_cmpxchg(pcp, oval, nval)	\
-	__pcpu_size_call_return2(raw_cpu_cmpxchg_, pcp, oval, nval)
-# define raw_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__pcpu_double_call_return_bool(raw_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
-
-/*
- * Generic percpu operations for context that are safe from preemption/interrupts.
- */
-# define __this_cpu_read(pcp) \
-	(__this_cpu_preempt_check("read"),__pcpu_size_call_return(raw_cpu_read_, (pcp)))
-
-# define __this_cpu_write(pcp, val)					\
-do { __this_cpu_preempt_check("write");					\
-     __pcpu_size_call(raw_cpu_write_, (pcp), (val));			\
-} while (0)
-
-# define __this_cpu_add(pcp, val)					 \
-do { __this_cpu_preempt_check("add");					\
-	__pcpu_size_call(raw_cpu_add_, (pcp), (val));			\
-} while (0)
-
-# define __this_cpu_sub(pcp, val)	__this_cpu_add((pcp), -(typeof(pcp))(val))
-# define __this_cpu_inc(pcp)		__this_cpu_add((pcp), 1)
-# define __this_cpu_dec(pcp)		__this_cpu_sub((pcp), 1)
-
-# define __this_cpu_and(pcp, val)					\
-do { __this_cpu_preempt_check("and");					\
-	__pcpu_size_call(raw_cpu_and_, (pcp), (val));			\
-} while (0)
-
-# define __this_cpu_or(pcp, val)					\
-do { __this_cpu_preempt_check("or");					\
-	__pcpu_size_call(raw_cpu_or_, (pcp), (val));			\
-} while (0)
-
-# define __this_cpu_add_return(pcp, val)	\
-	(__this_cpu_preempt_check("add_return"),__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val))
-
-#define __this_cpu_sub_return(pcp, val)	__this_cpu_add_return(pcp, -(typeof(pcp))(val))
-#define __this_cpu_inc_return(pcp)	__this_cpu_add_return(pcp, 1)
-#define __this_cpu_dec_return(pcp)	__this_cpu_add_return(pcp, -1)
-
-# define __this_cpu_xchg(pcp, nval)	\
-	(__this_cpu_preempt_check("xchg"),__pcpu_size_call_return2(raw_cpu_xchg_, (pcp), nval))
-
-# define __this_cpu_cmpxchg(pcp, oval, nval)	\
-	(__this_cpu_preempt_check("cmpxchg"),__pcpu_size_call_return2(raw_cpu_cmpxchg_, pcp, oval, nval))
-
-# define __this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	(__this_cpu_preempt_check("cmpxchg_double"),__pcpu_double_call_return_bool(raw_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2)))
-
 #endif /* __LINUX_PERCPU_H */
-- 
1.9.3

