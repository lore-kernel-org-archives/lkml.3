Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbaFLQ1C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:27:02 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:45451 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302AbaFLQXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:23:48 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/12] percpu: preffity percpu header files
Date: Thu, 12 Jun 2014 12:23:28 -0400
Message-Id: <1402590209-31610-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402590209-31610-1-git-send-email-tj@kernel.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu macros are difficult to read.  It's partly because they're
fairly complex but also because they simply lack visual and
conventional consistency to an unusual degree.  The preceding patches
tried to organize macro definitions consistently by their roles.  This
patch makes the following cosmetic changes to improve overall
readability.

* Use consistent convention for multi-line macro definitions - "do {"
  or "({" are now put on their own lines and the line continuing '\'
  are all put on the same column.

* Temp variables used inside macro are consistently given "__" prefix.

* When a macro argument is passed to another macro or a function,
  putting extra parenthses around it doesn't help anything.  Don't put
  them.

* _this_cpu_generic_*() are renamed to this_cpu_generic_*() so that
  they're consistent with raw_cpu_generic_*().

* Reorganize raw_cpu_*() and this_cpu_*() definitions so that trivial
  wrappers are collected in one place after actual operation
  definitions.

* Other misc cleanups including reorganizing comments.

All changes in this patch are cosmetic and cause no functional
difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 include/asm-generic/percpu.h | 581 ++++++++++++++++++++++---------------------
 include/linux/percpu-defs.h  | 253 ++++++++++---------
 2 files changed, 435 insertions(+), 399 deletions(-)

diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index 2300d98..4d9f233 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -77,333 +77,344 @@ do {									\
 })
 
 #define raw_cpu_generic_xchg(pcp, nval)					\
-({	typeof(pcp) ret__;						\
-	ret__ = raw_cpu_read(pcp);					\
+({									\
+	typeof(pcp) __ret;						\
+	__ret = raw_cpu_read(pcp);					\
 	raw_cpu_write(pcp, nval);					\
-	ret__;								\
+	__ret;								\
 })
 
 #define raw_cpu_generic_cmpxchg(pcp, oval, nval)			\
 ({									\
-	typeof(pcp) ret__;						\
-	ret__ = raw_cpu_read(pcp);					\
-	if (ret__ == (oval))						\
+	typeof(pcp) __ret;						\
+	__ret = raw_cpu_read(pcp);					\
+	if (__ret == (oval))						\
 		raw_cpu_write(pcp, nval);				\
-	ret__;								\
+	__ret;								\
 })
 
-#define raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+#define raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2) \
 ({									\
 	int __ret = 0;							\
 	if (raw_cpu_read(pcp1) == (oval1) &&				\
 			 raw_cpu_read(pcp2)  == (oval2)) {		\
-		raw_cpu_write(pcp1, (nval1));				\
-		raw_cpu_write(pcp2, (nval2));				\
+		raw_cpu_write(pcp1, nval1);				\
+		raw_cpu_write(pcp2, nval2);				\
 		__ret = 1;						\
 	}								\
 	(__ret);							\
 })
 
-#define _this_cpu_generic_read(pcp)					\
-({	typeof(pcp) ret__;						\
+#define this_cpu_generic_read(pcp)					\
+({									\
+	typeof(pcp) __ret;						\
 	preempt_disable();						\
-	ret__ = *this_cpu_ptr(&(pcp));					\
+	__ret = *this_cpu_ptr(&(pcp));					\
 	preempt_enable();						\
-	ret__;								\
+	__ret;								\
 })
 
-#define _this_cpu_generic_to_op(pcp, val, op)				\
+#define this_cpu_generic_to_op(pcp, val, op)				\
 do {									\
-	unsigned long flags;						\
-	raw_local_irq_save(flags);					\
+	unsigned long __flags;						\
+	raw_local_irq_save(__flags);					\
 	*raw_cpu_ptr(&(pcp)) op val;					\
-	raw_local_irq_restore(flags);					\
+	raw_local_irq_restore(__flags);					\
 } while (0)
 
-#define _this_cpu_generic_add_return(pcp, val)				\
+#define this_cpu_generic_add_return(pcp, val)				\
 ({									\
-	typeof(pcp) ret__;						\
-	unsigned long flags;						\
-	raw_local_irq_save(flags);					\
-	raw_cpu_add(pcp, val);					\
-	ret__ = raw_cpu_read(pcp);					\
-	raw_local_irq_restore(flags);					\
-	ret__;								\
+	typeof(pcp) __ret;						\
+	unsigned long __flags;						\
+	raw_local_irq_save(__flags);					\
+	raw_cpu_add(pcp, val);						\
+	__ret = raw_cpu_read(pcp);					\
+	raw_local_irq_restore(__flags);					\
+	__ret;								\
 })
 
-#define _this_cpu_generic_xchg(pcp, nval)				\
-({	typeof(pcp) ret__;						\
-	unsigned long flags;						\
-	raw_local_irq_save(flags);					\
-	ret__ = raw_cpu_read(pcp);					\
+#define this_cpu_generic_xchg(pcp, nval)				\
+({									\
+	typeof(pcp) __ret;						\
+	unsigned long __flags;						\
+	raw_local_irq_save(__flags);					\
+	__ret = raw_cpu_read(pcp);					\
 	raw_cpu_write(pcp, nval);					\
-	raw_local_irq_restore(flags);					\
-	ret__;								\
+	raw_local_irq_restore(__flags);					\
+	__ret;								\
 })
 
-#define _this_cpu_generic_cmpxchg(pcp, oval, nval)			\
+#define this_cpu_generic_cmpxchg(pcp, oval, nval)			\
 ({									\
-	typeof(pcp) ret__;						\
-	unsigned long flags;						\
-	raw_local_irq_save(flags);					\
-	ret__ = raw_cpu_read(pcp);					\
-	if (ret__ == (oval))						\
+	typeof(pcp) __ret;						\
+	unsigned long __flags;						\
+	raw_local_irq_save(__flags);					\
+	__ret = raw_cpu_read(pcp);					\
+	if (__ret == (oval))						\
 		raw_cpu_write(pcp, nval);				\
-	raw_local_irq_restore(flags);					\
-	ret__;								\
+	raw_local_irq_restore(__flags);					\
+	__ret;								\
 })
 
-#define _this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+#define this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
 ({									\
-	int ret__;							\
-	unsigned long flags;						\
-	raw_local_irq_save(flags);					\
-	ret__ = raw_cpu_generic_cmpxchg_double(pcp1, pcp2,		\
+	int __ret;							\
+	unsigned long __flags;						\
+	raw_local_irq_save(__flags);					\
+	__ret = raw_cpu_generic_cmpxchg_double(pcp1, pcp2,		\
 			oval1, oval2, nval1, nval2);			\
-	raw_local_irq_restore(flags);					\
-	ret__;								\
+	raw_local_irq_restore(__flags);					\
+	__ret;								\
 })
 
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
-
-# ifndef raw_cpu_cmpxchg_double_1
-#  define raw_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+#ifndef raw_cpu_read_1
+#define raw_cpu_read_1(pcp)		(*raw_cpu_ptr(&(pcp)))
+#endif
+#ifndef raw_cpu_read_2
+#define raw_cpu_read_2(pcp)		(*raw_cpu_ptr(&(pcp)))
+#endif
+#ifndef raw_cpu_read_4
+#define raw_cpu_read_4(pcp)		(*raw_cpu_ptr(&(pcp)))
+#endif
+#ifndef raw_cpu_read_8
+#define raw_cpu_read_8(pcp)		(*raw_cpu_ptr(&(pcp)))
+#endif
+
+#ifndef raw_cpu_write_1
+#define raw_cpu_write_1(pcp, val)	raw_cpu_generic_to_op(pcp, val, =)
+#endif
+#ifndef raw_cpu_write_2
+#define raw_cpu_write_2(pcp, val)	raw_cpu_generic_to_op(pcp, val, =)
+#endif
+#ifndef raw_cpu_write_4
+#define raw_cpu_write_4(pcp, val)	raw_cpu_generic_to_op(pcp, val, =)
+#endif
+#ifndef raw_cpu_write_8
+#define raw_cpu_write_8(pcp, val)	raw_cpu_generic_to_op(pcp, val, =)
+#endif
+
+#ifndef raw_cpu_add_1
+#define raw_cpu_add_1(pcp, val)		raw_cpu_generic_to_op(pcp, val, +=)
+#endif
+#ifndef raw_cpu_add_2
+#define raw_cpu_add_2(pcp, val)		raw_cpu_generic_to_op(pcp, val, +=)
+#endif
+#ifndef raw_cpu_add_4
+#define raw_cpu_add_4(pcp, val)		raw_cpu_generic_to_op(pcp, val, +=)
+#endif
+#ifndef raw_cpu_add_8
+#define raw_cpu_add_8(pcp, val)		raw_cpu_generic_to_op(pcp, val, +=)
+#endif
+
+#ifndef raw_cpu_and_1
+#define raw_cpu_and_1(pcp, val)		raw_cpu_generic_to_op(pcp, val, &=)
+#endif
+#ifndef raw_cpu_and_2
+#define raw_cpu_and_2(pcp, val)		raw_cpu_generic_to_op(pcp, val, &=)
+#endif
+#ifndef raw_cpu_and_4
+#define raw_cpu_and_4(pcp, val)		raw_cpu_generic_to_op(pcp, val, &=)
+#endif
+#ifndef raw_cpu_and_8
+#define raw_cpu_and_8(pcp, val)		raw_cpu_generic_to_op(pcp, val, &=)
+#endif
+
+#ifndef raw_cpu_or_1
+#define raw_cpu_or_1(pcp, val)		raw_cpu_generic_to_op(pcp, val, |=)
+#endif
+#ifndef raw_cpu_or_2
+#define raw_cpu_or_2(pcp, val)		raw_cpu_generic_to_op(pcp, val, |=)
+#endif
+#ifndef raw_cpu_or_4
+#define raw_cpu_or_4(pcp, val)		raw_cpu_generic_to_op(pcp, val, |=)
+#endif
+#ifndef raw_cpu_or_8
+#define raw_cpu_or_8(pcp, val)		raw_cpu_generic_to_op(pcp, val, |=)
+#endif
+
+#ifndef raw_cpu_add_return_1
+#define raw_cpu_add_return_1(pcp, val)	raw_cpu_generic_add_return(pcp, val)
+#endif
+#ifndef raw_cpu_add_return_2
+#define raw_cpu_add_return_2(pcp, val)	raw_cpu_generic_add_return(pcp, val)
+#endif
+#ifndef raw_cpu_add_return_4
+#define raw_cpu_add_return_4(pcp, val)	raw_cpu_generic_add_return(pcp, val)
+#endif
+#ifndef raw_cpu_add_return_8
+#define raw_cpu_add_return_8(pcp, val)	raw_cpu_generic_add_return(pcp, val)
+#endif
+
+#ifndef raw_cpu_xchg_1
+#define raw_cpu_xchg_1(pcp, nval)	raw_cpu_generic_xchg(pcp, nval)
+#endif
+#ifndef raw_cpu_xchg_2
+#define raw_cpu_xchg_2(pcp, nval)	raw_cpu_generic_xchg(pcp, nval)
+#endif
+#ifndef raw_cpu_xchg_4
+#define raw_cpu_xchg_4(pcp, nval)	raw_cpu_generic_xchg(pcp, nval)
+#endif
+#ifndef raw_cpu_xchg_8
+#define raw_cpu_xchg_8(pcp, nval)	raw_cpu_generic_xchg(pcp, nval)
+#endif
+
+#ifndef raw_cpu_cmpxchg_1
+#define raw_cpu_cmpxchg_1(pcp, oval, nval) \
+	raw_cpu_generic_cmpxchg(pcp, oval, nval)
+#endif
+#ifndef raw_cpu_cmpxchg_2
+#define raw_cpu_cmpxchg_2(pcp, oval, nval) \
+	raw_cpu_generic_cmpxchg(pcp, oval, nval)
+#endif
+#ifndef raw_cpu_cmpxchg_4
+#define raw_cpu_cmpxchg_4(pcp, oval, nval) \
+	raw_cpu_generic_cmpxchg(pcp, oval, nval)
+#endif
+#ifndef raw_cpu_cmpxchg_8
+#define raw_cpu_cmpxchg_8(pcp, oval, nval) \
+	raw_cpu_generic_cmpxchg(pcp, oval, nval)
+#endif
+
+#ifndef raw_cpu_cmpxchg_double_1
+#define raw_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2) \
 	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
-# endif
-# ifndef raw_cpu_cmpxchg_double_2
-#  define raw_cpu_cmpxchg_double_2(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+#endif
+#ifndef raw_cpu_cmpxchg_double_2
+#define raw_cpu_cmpxchg_double_2(pcp1, pcp2, oval1, oval2, nval1, nval2) \
 	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
-# endif
-# ifndef raw_cpu_cmpxchg_double_4
-#  define raw_cpu_cmpxchg_double_4(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+#endif
+#ifndef raw_cpu_cmpxchg_double_4
+#define raw_cpu_cmpxchg_double_4(pcp1, pcp2, oval1, oval2, nval1, nval2) \
 	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
-# endif
-# ifndef raw_cpu_cmpxchg_double_8
-#  define raw_cpu_cmpxchg_double_8(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
+#endif
+#ifndef raw_cpu_cmpxchg_double_8
+#define raw_cpu_cmpxchg_double_8(pcp1, pcp2, oval1, oval2, nval1, nval2) \
 	raw_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
-# endif
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
+#endif
+
+#ifndef this_cpu_read_1
+#define this_cpu_read_1(pcp)		this_cpu_generic_read(pcp)
+#endif
+#ifndef this_cpu_read_2
+#define this_cpu_read_2(pcp)		this_cpu_generic_read(pcp)
+#endif
+#ifndef this_cpu_read_4
+#define this_cpu_read_4(pcp)		this_cpu_generic_read(pcp)
+#endif
+#ifndef this_cpu_read_8
+#define this_cpu_read_8(pcp)		this_cpu_generic_read(pcp)
+#endif
+
+#ifndef this_cpu_write_1
+#define this_cpu_write_1(pcp, val)	this_cpu_generic_to_op(pcp, val, =)
+#endif
+#ifndef this_cpu_write_2
+#define this_cpu_write_2(pcp, val)	this_cpu_generic_to_op(pcp, val, =)
+#endif
+#ifndef this_cpu_write_4
+#define this_cpu_write_4(pcp, val)	this_cpu_generic_to_op(pcp, val, =)
+#endif
+#ifndef this_cpu_write_8
+#define this_cpu_write_8(pcp, val)	this_cpu_generic_to_op(pcp, val, =)
+#endif
+
+#ifndef this_cpu_add_1
+#define this_cpu_add_1(pcp, val)	this_cpu_generic_to_op(pcp, val, +=)
+#endif
+#ifndef this_cpu_add_2
+#define this_cpu_add_2(pcp, val)	this_cpu_generic_to_op(pcp, val, +=)
+#endif
+#ifndef this_cpu_add_4
+#define this_cpu_add_4(pcp, val)	this_cpu_generic_to_op(pcp, val, +=)
+#endif
+#ifndef this_cpu_add_8
+#define this_cpu_add_8(pcp, val)	this_cpu_generic_to_op(pcp, val, +=)
+#endif
+
+#ifndef this_cpu_and_1
+#define this_cpu_and_1(pcp, val)	this_cpu_generic_to_op(pcp, val, &=)
+#endif
+#ifndef this_cpu_and_2
+#define this_cpu_and_2(pcp, val)	this_cpu_generic_to_op(pcp, val, &=)
+#endif
+#ifndef this_cpu_and_4
+#define this_cpu_and_4(pcp, val)	this_cpu_generic_to_op(pcp, val, &=)
+#endif
+#ifndef this_cpu_and_8
+#define this_cpu_and_8(pcp, val)	this_cpu_generic_to_op(pcp, val, &=)
+#endif
+
+#ifndef this_cpu_or_1
+#define this_cpu_or_1(pcp, val)		this_cpu_generic_to_op(pcp, val, |=)
+#endif
+#ifndef this_cpu_or_2
+#define this_cpu_or_2(pcp, val)		this_cpu_generic_to_op(pcp, val, |=)
+#endif
+#ifndef this_cpu_or_4
+#define this_cpu_or_4(pcp, val)		this_cpu_generic_to_op(pcp, val, |=)
+#endif
+#ifndef this_cpu_or_8
+#define this_cpu_or_8(pcp, val)		this_cpu_generic_to_op(pcp, val, |=)
+#endif
+
+#ifndef this_cpu_add_return_1
+#define this_cpu_add_return_1(pcp, val)	this_cpu_generic_add_return(pcp, val)
+#endif
+#ifndef this_cpu_add_return_2
+#define this_cpu_add_return_2(pcp, val)	this_cpu_generic_add_return(pcp, val)
+#endif
+#ifndef this_cpu_add_return_4
+#define this_cpu_add_return_4(pcp, val)	this_cpu_generic_add_return(pcp, val)
+#endif
+#ifndef this_cpu_add_return_8
+#define this_cpu_add_return_8(pcp, val)	this_cpu_generic_add_return(pcp, val)
+#endif
+
+#ifndef this_cpu_xchg_1
+#define this_cpu_xchg_1(pcp, nval)	this_cpu_generic_xchg(pcp, nval)
+#endif
+#ifndef this_cpu_xchg_2
+#define this_cpu_xchg_2(pcp, nval)	this_cpu_generic_xchg(pcp, nval)
+#endif
+#ifndef this_cpu_xchg_4
+#define this_cpu_xchg_4(pcp, nval)	this_cpu_generic_xchg(pcp, nval)
+#endif
+#ifndef this_cpu_xchg_8
+#define this_cpu_xchg_8(pcp, nval)	this_cpu_generic_xchg(pcp, nval)
+#endif
+
+#ifndef this_cpu_cmpxchg_1
+#define this_cpu_cmpxchg_1(pcp, oval, nval) \
+	this_cpu_generic_cmpxchg(pcp, oval, nval)
+#endif
+#ifndef this_cpu_cmpxchg_2
+#define this_cpu_cmpxchg_2(pcp, oval, nval) \
+	this_cpu_generic_cmpxchg(pcp, oval, nval)
+#endif
+#ifndef this_cpu_cmpxchg_4
+#define this_cpu_cmpxchg_4(pcp, oval, nval) \
+	this_cpu_generic_cmpxchg(pcp, oval, nval)
+#endif
+#ifndef this_cpu_cmpxchg_8
+#define this_cpu_cmpxchg_8(pcp, oval, nval) \
+	this_cpu_generic_cmpxchg(pcp, oval, nval)
+#endif
+
+#ifndef this_cpu_cmpxchg_double_1
+#define this_cpu_cmpxchg_double_1(pcp1, pcp2, oval1, oval2, nval1, nval2) \
+	this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+#endif
+#ifndef this_cpu_cmpxchg_double_2
+#define this_cpu_cmpxchg_double_2(pcp1, pcp2, oval1, oval2, nval1, nval2) \
+	this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+#endif
+#ifndef this_cpu_cmpxchg_double_4
+#define this_cpu_cmpxchg_double_4(pcp1, pcp2, oval1, oval2, nval1, nval2) \
+	this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+#endif
+#ifndef this_cpu_cmpxchg_double_8
+#define this_cpu_cmpxchg_double_8(pcp1, pcp2, oval1, oval2, nval1, nval2) \
+	this_cpu_generic_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)
+#endif
 
 #endif /* _ASM_GENERIC_PERCPU_H_ */
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 3aa7f29..31ef245 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -206,7 +206,8 @@
  * + 0 is required in order to convert the pointer type from a
  * potential array type to a pointer to a single item of the array.
  */
-#define __verify_pcpu_ptr(ptr)	do {					\
+#define __verify_pcpu_ptr(ptr)						\
+do {									\
 	const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;	\
 	(void)__vpp_verify;						\
 	smp_read_barrier_depends();					\
@@ -219,12 +220,13 @@
  * to prevent the compiler from making incorrect assumptions about the
  * pointer value.  The weird cast keeps both GCC and sparse happy.
  */
-#define SHIFT_PERCPU_PTR(__p, __offset)	({				\
-	__verify_pcpu_ptr((__p));					\
+#define SHIFT_PERCPU_PTR(__p, __offset)					\
+({									\
+	__verify_pcpu_ptr(__p);						\
 	RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset)); \
 })
 
-#define per_cpu_ptr(ptr, cpu)	SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)))
+#define per_cpu_ptr(ptr, cpu)	SHIFT_PERCPU_PTR(ptr, per_cpu_offset(cpu))
 #define raw_cpu_ptr(ptr)	arch_raw_cpu_ptr(ptr)
 
 #ifdef CONFIG_DEBUG_PREEMPT
@@ -235,12 +237,13 @@
 
 #else	/* CONFIG_SMP */
 
-#define VERIFY_PERCPU_PTR(__p) ({			\
-	__verify_pcpu_ptr((__p));			\
-	(typeof(*(__p)) __kernel __force *)(__p);	\
+#define VERIFY_PERCPU_PTR(__p)						\
+({									\
+	__verify_pcpu_ptr(__p);						\
+	(typeof(*(__p)) __kernel __force *)(__p);			\
 })
 
-#define per_cpu_ptr(ptr, cpu)	({ (void)(cpu); VERIFY_PERCPU_PTR((ptr)); })
+#define per_cpu_ptr(ptr, cpu)	({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
 #define raw_cpu_ptr(ptr)	per_cpu_ptr(ptr, 0)
 #define this_cpu_ptr(ptr)	raw_cpu_ptr(ptr)
 
@@ -257,26 +260,32 @@
  * Must be an lvalue. Since @var must be a simple identifier,
  * we force a syntax error here if it isn't.
  */
-#define get_cpu_var(var) (*({				\
-	preempt_disable();				\
-	this_cpu_ptr(&var); }))
+#define get_cpu_var(var)						\
+(*({									\
+	preempt_disable();						\
+	this_cpu_ptr(&var);						\
+}))
 
 /*
  * The weird & is necessary because sparse considers (void)(var) to be
  * a direct dereference of percpu variable (var).
  */
-#define put_cpu_var(var) do {				\
-	(void)&(var);					\
-	preempt_enable();				\
+#define put_cpu_var(var)						\
+do {									\
+	(void)&(var);							\
+	preempt_enable();						\
 } while (0)
 
-#define get_cpu_ptr(var) ({				\
-	preempt_disable();				\
-	this_cpu_ptr(var); })
+#define get_cpu_ptr(var)						\
+({									\
+	preempt_disable();						\
+	this_cpu_ptr(var);						\
+})
 
-#define put_cpu_ptr(var) do {				\
-	(void)(var);					\
-	preempt_enable();				\
+#define put_cpu_ptr(var)						\
+do {									\
+	(void)(var);							\
+	preempt_enable();						\
 } while (0)
 
 /*
@@ -293,15 +302,16 @@ static inline void __this_cpu_preempt_check(const char *op) { }
 #endif
 
 #define __pcpu_size_call_return(stem, variable)				\
-({	typeof(variable) pscr_ret__;					\
+({									\
+	typeof(variable) pscr_ret__;					\
 	__verify_pcpu_ptr(&(variable));					\
 	switch(sizeof(variable)) {					\
-	case 1: pscr_ret__ = stem##1(variable);break;			\
-	case 2: pscr_ret__ = stem##2(variable);break;			\
-	case 4: pscr_ret__ = stem##4(variable);break;			\
-	case 8: pscr_ret__ = stem##8(variable);break;			\
+	case 1: pscr_ret__ = stem##1(variable); break;			\
+	case 2: pscr_ret__ = stem##2(variable); break;			\
+	case 4: pscr_ret__ = stem##4(variable); break;			\
+	case 8: pscr_ret__ = stem##8(variable); break;			\
 	default:							\
-		__bad_size_call_parameter();break;			\
+		__bad_size_call_parameter(); break;			\
 	}								\
 	pscr_ret__;							\
 })
@@ -332,11 +342,11 @@ static inline void __this_cpu_preempt_check(const char *op) { }
 #define __pcpu_double_call_return_bool(stem, pcp1, pcp2, ...)		\
 ({									\
 	bool pdcrb_ret__;						\
-	__verify_pcpu_ptr(&pcp1);					\
+	__verify_pcpu_ptr(&(pcp1));					\
 	BUILD_BUG_ON(sizeof(pcp1) != sizeof(pcp2));			\
-	VM_BUG_ON((unsigned long)(&pcp1) % (2 * sizeof(pcp1)));		\
-	VM_BUG_ON((unsigned long)(&pcp2) !=				\
-		  (unsigned long)(&pcp1) + sizeof(pcp1));		\
+	VM_BUG_ON((unsigned long)(&(pcp1)) % (2 * sizeof(pcp1)));	\
+	VM_BUG_ON((unsigned long)(&(pcp2)) !=				\
+		  (unsigned long)(&(pcp1)) + sizeof(pcp1));		\
 	switch(sizeof(pcp1)) {						\
 	case 1: pdcrb_ret__ = stem##1(pcp1, pcp2, __VA_ARGS__); break;	\
 	case 2: pdcrb_ret__ = stem##2(pcp1, pcp2, __VA_ARGS__); break;	\
@@ -376,117 +386,132 @@ do {									\
  * cpu atomic operations for 2 byte sized RMW actions. If arch code does
  * not provide operations for a scalar size then the fallback in the
  * generic code will be used.
+ *
+ * cmpxchg_double replaces two adjacent scalars at once.  The first two
+ * parameters are per cpu variables which have to be of the same size.  A
+ * truth value is returned to indicate success or failure (since a double
+ * register result is difficult to handle).  There is very limited hardware
+ * support for these operations, so only certain sizes may work.
  */
 
 /*
- * Generic percpu operations for contexts where we do not want to do
- * any checks for preemptiosn.
+ * Operations for contexts where we do not want to do any checks for
+ * preemptions.  Unless strictly necessary, always use [__]this_cpu_*()
+ * instead.
  *
- * If there is no other protection through preempt disable and/or
- * disabling interupts then one of these RMW operations can show unexpected
- * behavior because the execution thread was rescheduled on another processor
- * or an interrupt occurred and the same percpu variable was modified from
- * the interrupt context.
+ * If there is no other protection through preempt disable and/or disabling
+ * interupts then one of these RMW operations can show unexpected behavior
+ * because the execution thread was rescheduled on another processor or an
+ * interrupt occurred and the same percpu variable was modified from the
+ * interrupt context.
  */
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
+#define raw_cpu_read(pcp)		__pcpu_size_call_return(raw_cpu_read_, pcp)
+#define raw_cpu_write(pcp, val)		__pcpu_size_call(raw_cpu_write_, pcp, val)
+#define raw_cpu_add(pcp, val)		__pcpu_size_call(raw_cpu_add_, pcp, val)
+#define raw_cpu_and(pcp, val)		__pcpu_size_call(raw_cpu_and_, pcp, val)
+#define raw_cpu_or(pcp, val)		__pcpu_size_call(raw_cpu_or_, pcp, val)
+#define raw_cpu_add_return(pcp, val)	__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val)
+#define raw_cpu_xchg(pcp, nval)		__pcpu_size_call_return2(raw_cpu_xchg_, pcp, nval)
+#define raw_cpu_cmpxchg(pcp, oval, nval) \
 	__pcpu_size_call_return2(raw_cpu_cmpxchg_, pcp, oval, nval)
-# define raw_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	__pcpu_double_call_return_bool(raw_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2))
+#define raw_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2) \
+	__pcpu_double_call_return_bool(raw_cpu_cmpxchg_double_, pcp1, pcp2, oval1, oval2, nval1, nval2)
+
+#define raw_cpu_sub(pcp, val)		raw_cpu_add(pcp, -(val))
+#define raw_cpu_inc(pcp)		raw_cpu_add(pcp, 1)
+#define raw_cpu_dec(pcp)		raw_cpu_sub(pcp, 1)
+#define raw_cpu_sub_return(pcp, val)	raw_cpu_add_return(pcp, -(typeof(pcp))(val))
+#define raw_cpu_inc_return(pcp)		raw_cpu_add_return(pcp, 1)
+#define raw_cpu_dec_return(pcp)		raw_cpu_add_return(pcp, -1)
 
 /*
- * Generic percpu operations for context that are safe from preemption/interrupts.
+ * Operations for contexts that are safe from preemption/interrupts.  These
+ * operations verify that preemption is disabled.
  */
-# define __this_cpu_read(pcp) \
-	(__this_cpu_preempt_check("read"),raw_cpu_read(pcp))
+#define __this_cpu_read(pcp)						\
+({									\
+	__this_cpu_preempt_check("read");				\
+	raw_cpu_read(pcp);						\
+})
 
-# define __this_cpu_write(pcp, val)					\
-do { __this_cpu_preempt_check("write");					\
-     raw_cpu_write(pcp, val);						\
-} while (0)
+#define __this_cpu_write(pcp, val)					\
+({									\
+	__this_cpu_preempt_check("write");				\
+	raw_cpu_write(pcp, val);					\
+})
 
-# define __this_cpu_add(pcp, val)					 \
-do { __this_cpu_preempt_check("add");					\
+#define __this_cpu_add(pcp, val)					\
+({									\
+	__this_cpu_preempt_check("add");				\
 	raw_cpu_add(pcp, val);						\
-} while (0)
-
-# define __this_cpu_sub(pcp, val)	__this_cpu_add((pcp), -(typeof(pcp))(val))
-# define __this_cpu_inc(pcp)		__this_cpu_add((pcp), 1)
-# define __this_cpu_dec(pcp)		__this_cpu_sub((pcp), 1)
+})
 
-# define __this_cpu_and(pcp, val)					\
-do { __this_cpu_preempt_check("and");					\
+#define __this_cpu_and(pcp, val)					\
+({									\
+	__this_cpu_preempt_check("and");				\
 	raw_cpu_and(pcp, val);						\
-} while (0)
+})
 
-# define __this_cpu_or(pcp, val)					\
-do { __this_cpu_preempt_check("or");					\
+#define __this_cpu_or(pcp, val)						\
+({									\
+	__this_cpu_preempt_check("or");					\
 	raw_cpu_or(pcp, val);						\
-} while (0)
+})
 
-# define __this_cpu_add_return(pcp, val)	\
-	(__this_cpu_preempt_check("add_return"),raw_cpu_add_return(pcp, val))
+#define __this_cpu_add_return(pcp, val)					\
+({									\
+	__this_cpu_preempt_check("add_return");				\
+	raw_cpu_add_return(pcp, val);					\
+})
 
-#define __this_cpu_sub_return(pcp, val)	__this_cpu_add_return(pcp, -(typeof(pcp))(val))
-#define __this_cpu_inc_return(pcp)	__this_cpu_add_return(pcp, 1)
-#define __this_cpu_dec_return(pcp)	__this_cpu_add_return(pcp, -1)
+#define __this_cpu_xchg(pcp, nval)					\
+({									\
+	__this_cpu_preempt_check("xchg");				\
+	raw_cpu_xchg(pcp, nval);					\
+})
 
-# define __this_cpu_xchg(pcp, nval)	\
-	(__this_cpu_preempt_check("xchg"),raw_cpu_xchg(pcp, nval))
+#define __this_cpu_cmpxchg(pcp, oval, nval)				\
+({									\
+	__this_cpu_preempt_check("cmpxchg");				\
+	raw_cpu_cmpxchg(pcp, oval, nval);				\
+})
 
-# define __this_cpu_cmpxchg(pcp, oval, nval)	\
-	(__this_cpu_preempt_check("cmpxchg"),raw_cpu_cmpxchg(pcp, oval, nval))
+#define __this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2) \
+({	__this_cpu_preempt_check("cmpxchg_double");			\
+	raw_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2);	\
+})
 
-# define __this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	(__this_cpu_preempt_check("cmpxchg_double"),raw_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2))
+#define __this_cpu_sub(pcp, val)	__this_cpu_add(pcp, -(typeof(pcp))(val))
+#define __this_cpu_inc(pcp)		__this_cpu_add(pcp, 1)
+#define __this_cpu_dec(pcp)		__this_cpu_sub(pcp, 1)
+#define __this_cpu_sub_return(pcp, val)	__this_cpu_add_return(pcp, -(typeof(pcp))(val))
+#define __this_cpu_inc_return(pcp)	__this_cpu_add_return(pcp, 1)
+#define __this_cpu_dec_return(pcp)	__this_cpu_add_return(pcp, -1)
 
 /*
- * this_cpu_*() operations are used for accesses that must be done in a
- * preemption safe way since we know that the context is not preempt
- * safe. Interrupts may occur. If the interrupt modifies the variable too
- * then RMW actions will not be reliable.
+ * Operations with implied preemption protection.  These operations can be
+ * used without worrying about preemption.  Note that interrupts may still
+ * occur while an operation is in progress and if the interrupt modifies
+ * the variable too then RMW actions may not be reliable.
  */
-# define this_cpu_read(pcp)	__pcpu_size_call_return(this_cpu_read_, (pcp))
-# define this_cpu_write(pcp, val)	__pcpu_size_call(this_cpu_write_, (pcp), (val))
-# define this_cpu_add(pcp, val)		__pcpu_size_call(this_cpu_add_, (pcp), (val))
-# define this_cpu_sub(pcp, val)		this_cpu_add((pcp), -(typeof(pcp))(val))
-# define this_cpu_inc(pcp)		this_cpu_add((pcp), 1)
-# define this_cpu_dec(pcp)		this_cpu_sub((pcp), 1)
-# define this_cpu_and(pcp, val)		__pcpu_size_call(this_cpu_and_, (pcp), (val))
-# define this_cpu_or(pcp, val)		__pcpu_size_call(this_cpu_or_, (pcp), (val))
-# define this_cpu_add_return(pcp, val)	__pcpu_size_call_return2(this_cpu_add_return_, pcp, val)
+#define this_cpu_read(pcp)		__pcpu_size_call_return(this_cpu_read_, pcp)
+#define this_cpu_write(pcp, val)	__pcpu_size_call(this_cpu_write_, pcp, val)
+#define this_cpu_add(pcp, val)		__pcpu_size_call(this_cpu_add_, pcp, val)
+#define this_cpu_and(pcp, val)		__pcpu_size_call(this_cpu_and_, pcp, val)
+#define this_cpu_or(pcp, val)		__pcpu_size_call(this_cpu_or_, pcp, val)
+#define this_cpu_add_return(pcp, val)	__pcpu_size_call_return2(this_cpu_add_return_, pcp, val)
+#define this_cpu_xchg(pcp, nval)	__pcpu_size_call_return2(this_cpu_xchg_, pcp, nval)
+#define this_cpu_cmpxchg(pcp, oval, nval) \
+	__pcpu_size_call_return2(this_cpu_cmpxchg_, pcp, oval, nval)
+#define this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2) \
+	__pcpu_double_call_return_bool(this_cpu_cmpxchg_double_, pcp1, pcp2, oval1, oval2, nval1, nval2)
+
+#define this_cpu_sub(pcp, val)		this_cpu_add(pcp, -(typeof(pcp))(val))
+#define this_cpu_inc(pcp)		this_cpu_add(pcp, 1)
+#define this_cpu_dec(pcp)		this_cpu_sub(pcp, 1)
 #define this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(typeof(pcp))(val))
 #define this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
 #define this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
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
 
 #endif /* __ASSEMBLY__ */
 #endif /* _LINUX_PERCPU_DEFS_H */
-- 
1.9.3

