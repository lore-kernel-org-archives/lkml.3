Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbaFLQ2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:28:51 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:35961 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbaFLQXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:23:39 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/12] percpu: move accessors from include/linux/percpu.h to percpu-defs.h
Date: Thu, 12 Jun 2014 12:23:21 -0400
Message-Id: <1402590209-31610-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402590209-31610-1-git-send-email-tj@kernel.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/percpu-defs.h is gonna host all accessors and operations
so that arch headers can make use of them too without worrying about
circular dependency through include/linux/percpu.h.

This patch moves the following accessors from include/linux/percpu.h
to include/linux/percpu-defs.h.

* get/put_cpu_var()
* get/put_cpu_ptr()
* per_cpu_ptr()

This is pure reorgniazation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 include/linux/percpu-defs.h | 32 ++++++++++++++++++++++++++++++++
 include/linux/percpu.h      | 37 -------------------------------------
 2 files changed, 32 insertions(+), 37 deletions(-)

diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 55e04e9..f25bb94 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -261,5 +261,37 @@
 /* keep until we have removed all uses of __this_cpu_ptr */
 #define __this_cpu_ptr(ptr)	raw_cpu_ptr(ptr)
 
+/*
+ * Must be an lvalue. Since @var must be a simple identifier,
+ * we force a syntax error here if it isn't.
+ */
+#define get_cpu_var(var) (*({				\
+	preempt_disable();				\
+	this_cpu_ptr(&var); }))
+
+/*
+ * The weird & is necessary because sparse considers (void)(var) to be
+ * a direct dereference of percpu variable (var).
+ */
+#define put_cpu_var(var) do {				\
+	(void)&(var);					\
+	preempt_enable();				\
+} while (0)
+
+#define get_cpu_ptr(var) ({				\
+	preempt_disable();				\
+	this_cpu_ptr(var); })
+
+#define put_cpu_ptr(var) do {				\
+	(void)(var);					\
+	preempt_enable();				\
+} while (0)
+
+#ifdef CONFIG_SMP
+#define per_cpu_ptr(ptr, cpu)	SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)))
+#else
+#define per_cpu_ptr(ptr, cpu)	({ (void)(cpu); VERIFY_PERCPU_PTR((ptr)); })
+#endif
+
 #endif /* __ASSEMBLY__ */
 #endif /* _LINUX_PERCPU_DEFS_H */
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 8419053..97b2079 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -23,32 +23,6 @@
 	 PERCPU_MODULE_RESERVE)
 #endif
 
-/*
- * Must be an lvalue. Since @var must be a simple identifier,
- * we force a syntax error here if it isn't.
- */
-#define get_cpu_var(var) (*({				\
-	preempt_disable();				\
-	this_cpu_ptr(&var); }))
-
-/*
- * The weird & is necessary because sparse considers (void)(var) to be
- * a direct dereference of percpu variable (var).
- */
-#define put_cpu_var(var) do {				\
-	(void)&(var);					\
-	preempt_enable();				\
-} while (0)
-
-#define get_cpu_ptr(var) ({				\
-	preempt_disable();				\
-	this_cpu_ptr(var); })
-
-#define put_cpu_ptr(var) do {				\
-	(void)(var);					\
-	preempt_enable();				\
-} while (0)
-
 /* minimum unit size, also is the maximum supported allocation size */
 #define PCPU_MIN_UNIT_SIZE		PFN_ALIGN(32 << 10)
 
@@ -140,17 +114,6 @@ extern int __init pcpu_page_first_chunk(size_t reserved_size,
 				pcpu_fc_populate_pte_fn_t populate_pte_fn);
 #endif
 
-/*
- * Use this to get to a cpu's version of the per-cpu object
- * dynamically allocated. Non-atomic access to the current CPU's
- * version should probably be combined with get_cpu()/put_cpu().
- */
-#ifdef CONFIG_SMP
-#define per_cpu_ptr(ptr, cpu)	SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)))
-#else
-#define per_cpu_ptr(ptr, cpu)	({ (void)(cpu); VERIFY_PERCPU_PTR((ptr)); })
-#endif
-
 extern void __percpu *__alloc_reserved_percpu(size_t size, size_t align);
 extern bool is_kernel_percpu_address(unsigned long addr);
 
-- 
1.9.3

