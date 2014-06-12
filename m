Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbaFLQXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:23:51 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:44928 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbaFLQXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:23:47 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/12] percpu: use raw_cpu_*() to define __this_cpu_*()
Date: Thu, 12 Jun 2014 12:23:27 -0400
Message-Id: <1402590209-31610-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402590209-31610-1-git-send-email-tj@kernel.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__this_cpu_*() operations are the same as raw_cpu_*() operations
except for the added __this_cpu_preempt_check().  Curiously, these
were defined using __pcu_size_call_*() instead of being layered on top
of raw_cpu_*().

Let's layer them so that __this_cpu_*() are defined in terms of
raw_cpu_*().  It's simpler and less error-prone this way.

This patch doesn't introduce any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 include/linux/percpu-defs.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 2dcacc5..3aa7f29 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -412,16 +412,16 @@ do {									\
  * Generic percpu operations for context that are safe from preemption/interrupts.
  */
 # define __this_cpu_read(pcp) \
-	(__this_cpu_preempt_check("read"),__pcpu_size_call_return(raw_cpu_read_, (pcp)))
+	(__this_cpu_preempt_check("read"),raw_cpu_read(pcp))
 
 # define __this_cpu_write(pcp, val)					\
 do { __this_cpu_preempt_check("write");					\
-     __pcpu_size_call(raw_cpu_write_, (pcp), (val));			\
+     raw_cpu_write(pcp, val);						\
 } while (0)
 
 # define __this_cpu_add(pcp, val)					 \
 do { __this_cpu_preempt_check("add");					\
-	__pcpu_size_call(raw_cpu_add_, (pcp), (val));			\
+	raw_cpu_add(pcp, val);						\
 } while (0)
 
 # define __this_cpu_sub(pcp, val)	__this_cpu_add((pcp), -(typeof(pcp))(val))
@@ -430,29 +430,29 @@ do { __this_cpu_preempt_check("add");					\
 
 # define __this_cpu_and(pcp, val)					\
 do { __this_cpu_preempt_check("and");					\
-	__pcpu_size_call(raw_cpu_and_, (pcp), (val));			\
+	raw_cpu_and(pcp, val);						\
 } while (0)
 
 # define __this_cpu_or(pcp, val)					\
 do { __this_cpu_preempt_check("or");					\
-	__pcpu_size_call(raw_cpu_or_, (pcp), (val));			\
+	raw_cpu_or(pcp, val);						\
 } while (0)
 
 # define __this_cpu_add_return(pcp, val)	\
-	(__this_cpu_preempt_check("add_return"),__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val))
+	(__this_cpu_preempt_check("add_return"),raw_cpu_add_return(pcp, val))
 
 #define __this_cpu_sub_return(pcp, val)	__this_cpu_add_return(pcp, -(typeof(pcp))(val))
 #define __this_cpu_inc_return(pcp)	__this_cpu_add_return(pcp, 1)
 #define __this_cpu_dec_return(pcp)	__this_cpu_add_return(pcp, -1)
 
 # define __this_cpu_xchg(pcp, nval)	\
-	(__this_cpu_preempt_check("xchg"),__pcpu_size_call_return2(raw_cpu_xchg_, (pcp), nval))
+	(__this_cpu_preempt_check("xchg"),raw_cpu_xchg(pcp, nval))
 
 # define __this_cpu_cmpxchg(pcp, oval, nval)	\
-	(__this_cpu_preempt_check("cmpxchg"),__pcpu_size_call_return2(raw_cpu_cmpxchg_, pcp, oval, nval))
+	(__this_cpu_preempt_check("cmpxchg"),raw_cpu_cmpxchg(pcp, oval, nval))
 
 # define __this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2)	\
-	(__this_cpu_preempt_check("cmpxchg_double"),__pcpu_double_call_return_bool(raw_cpu_cmpxchg_double_, (pcp1), (pcp2), (oval1), (oval2), (nval1), (nval2)))
+	(__this_cpu_preempt_check("cmpxchg_double"),raw_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2))
 
 /*
  * this_cpu_*() operations are used for accesses that must be done in a
-- 
1.9.3

