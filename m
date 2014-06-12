Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbaFLQ2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:28:09 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:51958 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264AbaFLQXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:23:43 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/12] percpu: move generic {raw|this}_cpu_*_N() definitions to include/asm-generic/percpu.h
Date: Thu, 12 Jun 2014 12:23:24 -0400
Message-Id: <1402590209-31610-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402590209-31610-1-git-send-email-tj@kernel.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

{raw|this}_cpu_*_N() operations are expected to be provided by archs
and the generic definitions are provided as fallbacks.  As such, these
firmly belong to include/asm-generic/percpu.h.

Move the generic definitions to include/asm-generic/percpu.h.  The
code is moved mostly verbatim; however, raw_cpu_*_N() are placed above
this_cpu_*_N() which is more conventional as the raw operations may be
used to defined other variants.

This is pure reorganization.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 include/asm-generic/percpu.h | 341 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/percpu.h       | 344 -------------------------------------------
 2 files changed, 341 insertions(+), 344 deletions(-)

diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index e5ace4d..932ce60 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -65,4 +65,345 @@ extern void setup_per_cpu_areas(void);
 #define PER_CPU_DEF_ATTRIBUTES
 #endif
 
+# ifndef raw_cpu_read_1
+#  define raw_cpu_read_1(pcp)	(*raw_cpu_ptr(&(pcp)))
+# endif
+# ifndef raw_cpu_read_2
+#  define raw_cpu_read_2(pcp)	(*raw_cpu_ptr(&(pcp)))
+# endif
+# ifndef raw_cpu_read_4
+#  define raw_cpu_read_4(pcp)	(*raw_cpu_ptr(&(pcp)))
+# endif
+# ifndef raw_cpu_read_8
+#  define raw_cpu_read_8(pcp)	(*raw_cpu_ptr(&(pcp)))
+# endif
+
+#define raw_cpu_generic_to_op(pcp, val, op)				\
+do {									\
+	*raw_cpu_ptr(&(pcp)) op val;					\
+} while (0)
+
+# ifndef raw_cpu_write_1
+#  define raw_cpu_write_1(pcp, val)	raw_cpu_generic_to_op((pcp), (val), =)
+# endif
+# ifndef raw_cpu_write_2
+#  define raw_cpu_write_2(pcp, val)	raw_cpu_generic_to_op((pcp), (val), =)
+# endif
+# ifndef raw_cpu_write_4
+#  define raw_cpu_write_4(pcp, val)	raw_cpu_generic_to_op((pcp), (val), =)
+# endif
+# ifndef raw_cpu_write_8
+#  define raw_cpu_write_8(pcp, val)	raw_cpu_generic_to_op((pcp), (val), =)
+# endif
+
+# ifndef raw_cpu_add_1
+#  define raw_cpu_add_1(pcp, val)	raw_cpu_generic_to_op((pcp), (val), +=)
+# endif
+# ifndef raw_cpu_add_2
+#  define raw_cpu_add_2(pcp, val)	raw_cpu_generic_to_op((pcp), (val), +=)
+# endif
+# ifndef raw_cpu_add_4
+#  define raw_cpu_add_4(pcp, val)	raw_cpu_generic_to_op((pcp), (val), +=)
+# endif
+# ifndef raw_cpu_add_8
+#  define raw_cpu_add_8(pcp, val)	raw_cpu_generic_to_op((pcp), (val), +=)
+# endif
+
+# ifndef raw_cpu_and_1
+#  define raw_cpu_and_1(pcp, val)	raw_cpu_generic_to_op((pcp), (val), &=)
+# endif
+# ifndef raw_cpu_and_2
+#  define raw_cpu_and_2(pcp, val)	raw_cpu_generic_to_op((pcp), (val), &=)
+# endif
+# ifndef raw_cpu_and_4
+#  define raw_cpu_and_4(pcp, val)	raw_cpu_generic_to_op((pcp), (val), &=)
+# endif
+# ifndef raw_cpu_and_8
+#  define raw_cpu_and_8(pcp, val)	raw_cpu_generic_to_op((pcp), (val), &=)
+# endif
+
+# ifndef raw_cpu_or_1
+#  define raw_cpu_or_1(pcp, val)	raw_cpu_generic_to_op((pcp), (val), |=)
+# endif
+# ifndef raw_cpu_or_2
+#  define raw_cpu_or_2(pcp, val)	raw_cpu_generic_to_op((pcp), (val), |=)
+# endif
+# ifndef raw_cpu_or_4
+#  define raw_cpu_or_4(pcp, val)	raw_cpu_generic_to_op((pcp), (val), |=)
+# endif
+# ifndef raw_cpu_or_8
+#  define raw_cpu_or_8(pcp, val)	raw_cpu_generic_to_op((pcp), (val), |=)
+# endif
+
+#define raw_cpu_generic_add_return(pcp, val)				\
+({									\
+	raw_cpu_add(pcp, val);						\
+	raw_cpu_read(pcp);						\
+})
+
+# ifndef raw_cpu_add_return_1
+#  define raw_cpu_add_return_1(pcp, val)	raw_cpu_generic_add_return(pcp, val)
+# endif
+# ifndef raw_cpu_add_return_2
+#  define raw_cpu_add_return_2(pcp, val)	raw_cpu_generic_add_return(pcp, val)
+# endif
+# ifndef raw_cpu_add_return_4
+#  define raw_cpu_add_return_4(pcp, val)	raw_cpu_generic_add_return(pcp, val)
+# endif
+# ifndef raw_cpu_add_return_8
+#  define raw_cpu_add_return_8(pcp, val)	raw_cpu_generic_add_return(pcp, val)
+# endif
+
+#define raw_cpu_generic_xchg(pcp, nval)					\
+({	typeof(pcp) ret__;						\
+	ret__ = raw_cpu_read(pcp);					\
+	raw_cpu_write(pcp, nval);					\
+	ret__;								\
+})
+
+# ifndef raw_cpu_xchg_1
+#  define raw_cpu_xchg_1(pcp, nval)	raw_cpu_generic_xchg(pcp, nval)
+# endif
+# ifndef raw_cpu_xchg_2
+#  define raw_cpu_xchg_2(pcp, nval)	raw_cpu_generic_xchg(pcp, nval)
+# endif
+# ifndef raw_cpu_xchg_4
+#  define raw_cpu_xchg_4(pcp, nval)	raw_cpu_generic_xchg(pcp, nval)
+# endif
+# ifndef raw_cpu_xchg_8
+#  define raw_cpu_xchg_8(pcp, nval)	raw_cpu_generic_xchg(pcp, nval)
+# endif
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
+# ifndef raw_cpu_cmpxchg_1
+#  define raw_cpu_cmpxchg_1(pcp, oval, nval)	raw_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
+# ifndef raw_cpu_cmpxchg_2
+#  define raw_cpu_cmpxchg_2(pcp, oval, nval)	raw_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
+# ifndef raw_cpu_cmpxchg_4
+#  define raw_cpu_cmpxchg_4(pcp, oval, nval)	raw_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
+# ifndef raw_cpu_cmpxchg_8
+#  define raw_cpu_cmpxchg_8(pcp, oval, nval)	raw_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
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
+# ifndef raw_cpu_cmpxchg_double_1
+#  define raw_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# ifndef raw_cpu_cmpxchg_double_2
+#  define raw_cpu_cmpxchg_double_2(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# ifndef raw_cpu_cmpxchg_double_4
+#  define raw_cpu_cmpxchg_double_4(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# ifndef raw_cpu_cmpxchg_double_8
+#  define raw_cpu_cmpxchg_double_8(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+
+#define _this_cpu_generic_read(pcp)					\
+({	typeof(pcp) ret__;						\
+	preempt_disable();						\
+	ret__ = *this_cpu_ptr(&(pcp));					\
+	preempt_enable();						\
+	ret__;								\
+})
+
+# ifndef this_cpu_read_1
+#  define this_cpu_read_1(pcp)	_this_cpu_generic_read(pcp)
+# endif
+# ifndef this_cpu_read_2
+#  define this_cpu_read_2(pcp)	_this_cpu_generic_read(pcp)
+# endif
+# ifndef this_cpu_read_4
+#  define this_cpu_read_4(pcp)	_this_cpu_generic_read(pcp)
+# endif
+# ifndef this_cpu_read_8
+#  define this_cpu_read_8(pcp)	_this_cpu_generic_read(pcp)
+# endif
+
+#define _this_cpu_generic_to_op(pcp, val, op)				\
+do {									\
+	unsigned long flags;						\
+	raw_local_irq_save(flags);					\
+	*raw_cpu_ptr(&(pcp)) op val;					\
+	raw_local_irq_restore(flags);					\
+} while (0)
+
+# ifndef this_cpu_write_1
+#  define this_cpu_write_1(pcp, val)	_this_cpu_generic_to_op((pcp), (val), =)
+# endif
+# ifndef this_cpu_write_2
+#  define this_cpu_write_2(pcp, val)	_this_cpu_generic_to_op((pcp), (val), =)
+# endif
+# ifndef this_cpu_write_4
+#  define this_cpu_write_4(pcp, val)	_this_cpu_generic_to_op((pcp), (val), =)
+# endif
+# ifndef this_cpu_write_8
+#  define this_cpu_write_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), =)
+# endif
+
+# ifndef this_cpu_add_1
+#  define this_cpu_add_1(pcp, val)	_this_cpu_generic_to_op((pcp), (val), +=)
+# endif
+# ifndef this_cpu_add_2
+#  define this_cpu_add_2(pcp, val)	_this_cpu_generic_to_op((pcp), (val), +=)
+# endif
+# ifndef this_cpu_add_4
+#  define this_cpu_add_4(pcp, val)	_this_cpu_generic_to_op((pcp), (val), +=)
+# endif
+# ifndef this_cpu_add_8
+#  define this_cpu_add_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), +=)
+# endif
+
+# ifndef this_cpu_and_1
+#  define this_cpu_and_1(pcp, val)	_this_cpu_generic_to_op((pcp), (val), &=)
+# endif
+# ifndef this_cpu_and_2
+#  define this_cpu_and_2(pcp, val)	_this_cpu_generic_to_op((pcp), (val), &=)
+# endif
+# ifndef this_cpu_and_4
+#  define this_cpu_and_4(pcp, val)	_this_cpu_generic_to_op((pcp), (val), &=)
+# endif
+# ifndef this_cpu_and_8
+#  define this_cpu_and_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), &=)
+# endif
+
+# ifndef this_cpu_or_1
+#  define this_cpu_or_1(pcp, val)	_this_cpu_generic_to_op((pcp), (val), |=)
+# endif
+# ifndef this_cpu_or_2
+#  define this_cpu_or_2(pcp, val)	_this_cpu_generic_to_op((pcp), (val), |=)
+# endif
+# ifndef this_cpu_or_4
+#  define this_cpu_or_4(pcp, val)	_this_cpu_generic_to_op((pcp), (val), |=)
+# endif
+# ifndef this_cpu_or_8
+#  define this_cpu_or_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), |=)
+# endif
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
+# ifndef this_cpu_add_return_1
+#  define this_cpu_add_return_1(pcp, val)	_this_cpu_generic_add_return(pcp, val)
+# endif
+# ifndef this_cpu_add_return_2
+#  define this_cpu_add_return_2(pcp, val)	_this_cpu_generic_add_return(pcp, val)
+# endif
+# ifndef this_cpu_add_return_4
+#  define this_cpu_add_return_4(pcp, val)	_this_cpu_generic_add_return(pcp, val)
+# endif
+# ifndef this_cpu_add_return_8
+#  define this_cpu_add_return_8(pcp, val)	_this_cpu_generic_add_return(pcp, val)
+# endif
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
+# ifndef this_cpu_xchg_1
+#  define this_cpu_xchg_1(pcp, nval)	_this_cpu_generic_xchg(pcp, nval)
+# endif
+# ifndef this_cpu_xchg_2
+#  define this_cpu_xchg_2(pcp, nval)	_this_cpu_generic_xchg(pcp, nval)
+# endif
+# ifndef this_cpu_xchg_4
+#  define this_cpu_xchg_4(pcp, nval)	_this_cpu_generic_xchg(pcp, nval)
+# endif
+# ifndef this_cpu_xchg_8
+#  define this_cpu_xchg_8(pcp, nval)	_this_cpu_generic_xchg(pcp, nval)
+# endif
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
+# ifndef this_cpu_cmpxchg_1
+#  define this_cpu_cmpxchg_1(pcp, oval, nval)	_this_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
+# ifndef this_cpu_cmpxchg_2
+#  define this_cpu_cmpxchg_2(pcp, oval, nval)	_this_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
+# ifndef this_cpu_cmpxchg_4
+#  define this_cpu_cmpxchg_4(pcp, oval, nval)	_this_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
+# ifndef this_cpu_cmpxchg_8
+#  define this_cpu_cmpxchg_8(pcp, oval, nval)	_this_cpu_generic_cmpxchg(pcp, oval, nval)
+# endif
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
+# ifndef this_cpu_cmpxchg_double_1
+#  define this_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	_this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# ifndef this_cpu_cmpxchg_double_2
+#  define this_cpu_cmpxchg_double_2(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	_this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# ifndef this_cpu_cmpxchg_double_4
+#  define this_cpu_cmpxchg_double_4(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	_this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+# ifndef this_cpu_cmpxchg_double_8
+#  define this_cpu_cmpxchg_double_8(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+	_this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+# endif
+
 #endif /* _ASM_GENERIC_PERCPU_H_ */
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 95d380e..20b9535 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -233,174 +233,20 @@ do {									\
  * generic code will be used.
  */
 
-#define _this_cpu_generic_read(pcp)					\
-({	typeof(pcp) ret__;						\
-	preempt_disable();						\
-	ret__ = *this_cpu_ptr(&(pcp));					\
-	preempt_enable();						\
-	ret__;								\
-})
-
-# ifndef this_cpu_read_1
-#  define this_cpu_read_1(pcp)	_this_cpu_generic_read(pcp)
-# endif
-# ifndef this_cpu_read_2
-#  define this_cpu_read_2(pcp)	_this_cpu_generic_read(pcp)
-# endif
-# ifndef this_cpu_read_4
-#  define this_cpu_read_4(pcp)	_this_cpu_generic_read(pcp)
-# endif
-# ifndef this_cpu_read_8
-#  define this_cpu_read_8(pcp)	_this_cpu_generic_read(pcp)
-# endif
 # define this_cpu_read(pcp)	__pcpu_size_call_return(this_cpu_read_, (pcp))
-
-#define _this_cpu_generic_to_op(pcp, val, op)				\
-do {									\
-	unsigned long flags;						\
-	raw_local_irq_save(flags);					\
-	*raw_cpu_ptr(&(pcp)) op val;					\
-	raw_local_irq_restore(flags);					\
-} while (0)
-
-# ifndef this_cpu_write_1
-#  define this_cpu_write_1(pcp, val)	_this_cpu_generic_to_op((pcp), (val), =)
-# endif
-# ifndef this_cpu_write_2
-#  define this_cpu_write_2(pcp, val)	_this_cpu_generic_to_op((pcp), (val), =)
-# endif
-# ifndef this_cpu_write_4
-#  define this_cpu_write_4(pcp, val)	_this_cpu_generic_to_op((pcp), (val), =)
-# endif
-# ifndef this_cpu_write_8
-#  define this_cpu_write_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), =)
-# endif
 # define this_cpu_write(pcp, val)	__pcpu_size_call(this_cpu_write_, (pcp), (val))
-
-# ifndef this_cpu_add_1
-#  define this_cpu_add_1(pcp, val)	_this_cpu_generic_to_op((pcp), (val), +=)
-# endif
-# ifndef this_cpu_add_2
-#  define this_cpu_add_2(pcp, val)	_this_cpu_generic_to_op((pcp), (val), +=)
-# endif
-# ifndef this_cpu_add_4
-#  define this_cpu_add_4(pcp, val)	_this_cpu_generic_to_op((pcp), (val), +=)
-# endif
-# ifndef this_cpu_add_8
-#  define this_cpu_add_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), +=)
-# endif
 # define this_cpu_add(pcp, val)		__pcpu_size_call(this_cpu_add_, (pcp), (val))
-
 # define this_cpu_sub(pcp, val)		this_cpu_add((pcp), -(typeof(pcp))(val))
 # define this_cpu_inc(pcp)		this_cpu_add((pcp), 1)
 # define this_cpu_dec(pcp)		this_cpu_sub((pcp), 1)
-
-# ifndef this_cpu_and_1
-#  define this_cpu_and_1(pcp, val)	_this_cpu_generic_to_op((pcp), (val), &=)
-# endif
-# ifndef this_cpu_and_2
-#  define this_cpu_and_2(pcp, val)	_this_cpu_generic_to_op((pcp), (val), &=)
-# endif
-# ifndef this_cpu_and_4
-#  define this_cpu_and_4(pcp, val)	_this_cpu_generic_to_op((pcp), (val), &=)
-# endif
-# ifndef this_cpu_and_8
-#  define this_cpu_and_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), &=)
-# endif
 # define this_cpu_and(pcp, val)		__pcpu_size_call(this_cpu_and_, (pcp), (val))
-
-# ifndef this_cpu_or_1
-#  define this_cpu_or_1(pcp, val)	_this_cpu_generic_to_op((pcp), (val), |=)
-# endif
-# ifndef this_cpu_or_2
-#  define this_cpu_or_2(pcp, val)	_this_cpu_generic_to_op((pcp), (val), |=)
-# endif
-# ifndef this_cpu_or_4
-#  define this_cpu_or_4(pcp, val)	_this_cpu_generic_to_op((pcp), (val), |=)
-# endif
-# ifndef this_cpu_or_8
-#  define this_cpu_or_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), |=)
-# endif
 # define this_cpu_or(pcp, val)		__pcpu_size_call(this_cpu_or_, (pcp), (val))
-
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
-# ifndef this_cpu_add_return_1
-#  define this_cpu_add_return_1(pcp, val)	_this_cpu_generic_add_return(pcp, val)
-# endif
-# ifndef this_cpu_add_return_2
-#  define this_cpu_add_return_2(pcp, val)	_this_cpu_generic_add_return(pcp, val)
-# endif
-# ifndef this_cpu_add_return_4
-#  define this_cpu_add_return_4(pcp, val)	_this_cpu_generic_add_return(pcp, val)
-# endif
-# ifndef this_cpu_add_return_8
-#  define this_cpu_add_return_8(pcp, val)	_this_cpu_generic_add_return(pcp, val)
-# endif
 # define this_cpu_add_return(pcp, val)	__pcpu_size_call_return2(this_cpu_add_return_, pcp, val)
-
 #define this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(typeof(pcp))(val))
 #define this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
 #define this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
-
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
-# ifndef this_cpu_xchg_1
-#  define this_cpu_xchg_1(pcp, nval)	_this_cpu_generic_xchg(pcp, nval)
-# endif
-# ifndef this_cpu_xchg_2
-#  define this_cpu_xchg_2(pcp, nval)	_this_cpu_generic_xchg(pcp, nval)
-# endif
-# ifndef this_cpu_xchg_4
-#  define this_cpu_xchg_4(pcp, nval)	_this_cpu_generic_xchg(pcp, nval)
-# endif
-# ifndef this_cpu_xchg_8
-#  define this_cpu_xchg_8(pcp, nval)	_this_cpu_generic_xchg(pcp, nval)
-# endif
 # define this_cpu_xchg(pcp, nval)	\
 	__pcpu_size_call_return2(this_cpu_xchg_, (pcp), nval)
-
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
-# ifndef this_cpu_cmpxchg_1
-#  define this_cpu_cmpxchg_1(pcp, oval, nval)	_this_cpu_generic_cmpxchg(pcp, oval, nval)
-# endif
-# ifndef this_cpu_cmpxchg_2
-#  define this_cpu_cmpxchg_2(pcp, oval, nval)	_this_cpu_generic_cmpxchg(pcp, oval, nval)
-# endif
-# ifndef this_cpu_cmpxchg_4
-#  define this_cpu_cmpxchg_4(pcp, oval, nval)	_this_cpu_generic_cmpxchg(pcp, oval, nval)
-# endif
-# ifndef this_cpu_cmpxchg_8
-#  define this_cpu_cmpxchg_8(pcp, oval, nval)	_this_cpu_generic_cmpxchg(pcp, oval, nval)
-# endif
 # define this_cpu_cmpxchg(pcp, oval, nval)	\
 	__pcpu_size_call_return2(this_cpu_cmpxchg_, pcp, oval, nval)
 
@@ -412,33 +258,6 @@ do {									\
  * very limited hardware support for these operations, so only certain
  * sizes may work.
  */
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
-# ifndef this_cpu_cmpxchg_double_1
-#  define this_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	_this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
-# endif
-# ifndef this_cpu_cmpxchg_double_2
-#  define this_cpu_cmpxchg_double_2(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	_this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
-# endif
-# ifndef this_cpu_cmpxchg_double_4
-#  define this_cpu_cmpxchg_double_4(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	_this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
-# endif
-# ifndef this_cpu_cmpxchg_double_8
-#  define this_cpu_cmpxchg_double_8(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	_this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
-# endif
 # define this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
 	__pcpu_double_call_return_bool(this_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
 
@@ -452,186 +271,23 @@ do {									\
  * or an interrupt occurred and the same percpu variable was modified from
  * the interrupt context.
  */
-# ifndef raw_cpu_read_1
-#  define raw_cpu_read_1(pcp)	(*raw_cpu_ptr(&(pcp)))
-# endif
-# ifndef raw_cpu_read_2
-#  define raw_cpu_read_2(pcp)	(*raw_cpu_ptr(&(pcp)))
-# endif
-# ifndef raw_cpu_read_4
-#  define raw_cpu_read_4(pcp)	(*raw_cpu_ptr(&(pcp)))
-# endif
-# ifndef raw_cpu_read_8
-#  define raw_cpu_read_8(pcp)	(*raw_cpu_ptr(&(pcp)))
-# endif
 # define raw_cpu_read(pcp)	__pcpu_size_call_return(raw_cpu_read_, (pcp))
-
-#define raw_cpu_generic_to_op(pcp, val, op)				\
-do {									\
-	*raw_cpu_ptr(&(pcp)) op val;					\
-} while (0)
-
-# ifndef raw_cpu_write_1
-#  define raw_cpu_write_1(pcp, val)	raw_cpu_generic_to_op((pcp), (val), =)
-# endif
-# ifndef raw_cpu_write_2
-#  define raw_cpu_write_2(pcp, val)	raw_cpu_generic_to_op((pcp), (val), =)
-# endif
-# ifndef raw_cpu_write_4
-#  define raw_cpu_write_4(pcp, val)	raw_cpu_generic_to_op((pcp), (val), =)
-# endif
-# ifndef raw_cpu_write_8
-#  define raw_cpu_write_8(pcp, val)	raw_cpu_generic_to_op((pcp), (val), =)
-# endif
 # define raw_cpu_write(pcp, val)	__pcpu_size_call(raw_cpu_write_, (pcp), (val))
-
-# ifndef raw_cpu_add_1
-#  define raw_cpu_add_1(pcp, val)	raw_cpu_generic_to_op((pcp), (val), +=)
-# endif
-# ifndef raw_cpu_add_2
-#  define raw_cpu_add_2(pcp, val)	raw_cpu_generic_to_op((pcp), (val), +=)
-# endif
-# ifndef raw_cpu_add_4
-#  define raw_cpu_add_4(pcp, val)	raw_cpu_generic_to_op((pcp), (val), +=)
-# endif
-# ifndef raw_cpu_add_8
-#  define raw_cpu_add_8(pcp, val)	raw_cpu_generic_to_op((pcp), (val), +=)
-# endif
 # define raw_cpu_add(pcp, val)	__pcpu_size_call(raw_cpu_add_, (pcp), (val))
-
 # define raw_cpu_sub(pcp, val)	raw_cpu_add((pcp), -(val))
-
 # define raw_cpu_inc(pcp)		raw_cpu_add((pcp), 1)
-
 # define raw_cpu_dec(pcp)		raw_cpu_sub((pcp), 1)
-
-# ifndef raw_cpu_and_1
-#  define raw_cpu_and_1(pcp, val)	raw_cpu_generic_to_op((pcp), (val), &=)
-# endif
-# ifndef raw_cpu_and_2
-#  define raw_cpu_and_2(pcp, val)	raw_cpu_generic_to_op((pcp), (val), &=)
-# endif
-# ifndef raw_cpu_and_4
-#  define raw_cpu_and_4(pcp, val)	raw_cpu_generic_to_op((pcp), (val), &=)
-# endif
-# ifndef raw_cpu_and_8
-#  define raw_cpu_and_8(pcp, val)	raw_cpu_generic_to_op((pcp), (val), &=)
-# endif
 # define raw_cpu_and(pcp, val)	__pcpu_size_call(raw_cpu_and_, (pcp), (val))
-
-# ifndef raw_cpu_or_1
-#  define raw_cpu_or_1(pcp, val)	raw_cpu_generic_to_op((pcp), (val), |=)
-# endif
-# ifndef raw_cpu_or_2
-#  define raw_cpu_or_2(pcp, val)	raw_cpu_generic_to_op((pcp), (val), |=)
-# endif
-# ifndef raw_cpu_or_4
-#  define raw_cpu_or_4(pcp, val)	raw_cpu_generic_to_op((pcp), (val), |=)
-# endif
-# ifndef raw_cpu_or_8
-#  define raw_cpu_or_8(pcp, val)	raw_cpu_generic_to_op((pcp), (val), |=)
-# endif
 # define raw_cpu_or(pcp, val)	__pcpu_size_call(raw_cpu_or_, (pcp), (val))
-
-#define raw_cpu_generic_add_return(pcp, val)				\
-({									\
-	raw_cpu_add(pcp, val);						\
-	raw_cpu_read(pcp);						\
-})
-
-# ifndef raw_cpu_add_return_1
-#  define raw_cpu_add_return_1(pcp, val)	raw_cpu_generic_add_return(pcp, val)
-# endif
-# ifndef raw_cpu_add_return_2
-#  define raw_cpu_add_return_2(pcp, val)	raw_cpu_generic_add_return(pcp, val)
-# endif
-# ifndef raw_cpu_add_return_4
-#  define raw_cpu_add_return_4(pcp, val)	raw_cpu_generic_add_return(pcp, val)
-# endif
-# ifndef raw_cpu_add_return_8
-#  define raw_cpu_add_return_8(pcp, val)	raw_cpu_generic_add_return(pcp, val)
-# endif
 # define raw_cpu_add_return(pcp, val)	\
 	__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val)
-
 #define raw_cpu_sub_return(pcp, val)	raw_cpu_add_return(pcp, -(typeof(pcp))(val))
 #define raw_cpu_inc_return(pcp)	raw_cpu_add_return(pcp, 1)
 #define raw_cpu_dec_return(pcp)	raw_cpu_add_return(pcp, -1)
-
-#define raw_cpu_generic_xchg(pcp, nval)					\
-({	typeof(pcp) ret__;						\
-	ret__ = raw_cpu_read(pcp);					\
-	raw_cpu_write(pcp, nval);					\
-	ret__;								\
-})
-
-# ifndef raw_cpu_xchg_1
-#  define raw_cpu_xchg_1(pcp, nval)	raw_cpu_generic_xchg(pcp, nval)
-# endif
-# ifndef raw_cpu_xchg_2
-#  define raw_cpu_xchg_2(pcp, nval)	raw_cpu_generic_xchg(pcp, nval)
-# endif
-# ifndef raw_cpu_xchg_4
-#  define raw_cpu_xchg_4(pcp, nval)	raw_cpu_generic_xchg(pcp, nval)
-# endif
-# ifndef raw_cpu_xchg_8
-#  define raw_cpu_xchg_8(pcp, nval)	raw_cpu_generic_xchg(pcp, nval)
-# endif
 # define raw_cpu_xchg(pcp, nval)	\
 	__pcpu_size_call_return2(raw_cpu_xchg_, (pcp), nval)
-
-#define raw_cpu_generic_cmpxchg(pcp, oval, nval)			\
-({									\
-	typeof(pcp) ret__;						\
-	ret__ = raw_cpu_read(pcp);					\
-	if (ret__ == (oval))						\
-		raw_cpu_write(pcp, nval);				\
-	ret__;								\
-})
-
-# ifndef raw_cpu_cmpxchg_1
-#  define raw_cpu_cmpxchg_1(pcp, oval, nval)	raw_cpu_generic_cmpxchg(pcp, oval, nval)
-# endif
-# ifndef raw_cpu_cmpxchg_2
-#  define raw_cpu_cmpxchg_2(pcp, oval, nval)	raw_cpu_generic_cmpxchg(pcp, oval, nval)
-# endif
-# ifndef raw_cpu_cmpxchg_4
-#  define raw_cpu_cmpxchg_4(pcp, oval, nval)	raw_cpu_generic_cmpxchg(pcp, oval, nval)
-# endif
-# ifndef raw_cpu_cmpxchg_8
-#  define raw_cpu_cmpxchg_8(pcp, oval, nval)	raw_cpu_generic_cmpxchg(pcp, oval, nval)
-# endif
 # define raw_cpu_cmpxchg(pcp, oval, nval)	\
 	__pcpu_size_call_return2(raw_cpu_cmpxchg_, pcp, oval, nval)
-
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
-# ifndef raw_cpu_cmpxchg_double_1
-#  define raw_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
-# endif
-# ifndef raw_cpu_cmpxchg_double_2
-#  define raw_cpu_cmpxchg_double_2(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
-# endif
-# ifndef raw_cpu_cmpxchg_double_4
-#  define raw_cpu_cmpxchg_double_4(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
-# endif
-# ifndef raw_cpu_cmpxchg_double_8
-#  define raw_cpu_cmpxchg_double_8(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
-# endif
 # define raw_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
 	__pcpu_double_call_return_bool(raw_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
 
-- 
1.9.3

