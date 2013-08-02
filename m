Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab3HBVJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:09:44 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:56653 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3HBVJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:09:42 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>
Subject: [PATCH 1/3] smp: Quit unconditionally enabling irq in on_each_cpu_mask and on_each_cpu_cond
Date: Fri,  2 Aug 2013 14:09:34 -0700
Message-Id: <1375477776-13302-2-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375477776-13302-1-git-send-email-ddaney.cavm@gmail.com>
References: <1375477776-13302-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

As in f21afc25f9ed (smp.h: Use local_irq_{save,restore}() in !SMP
version of on_each_cpu().), we don't want to enable irqs if they are
not already enabled.  There are currently no known problematical
callers of these functions, but since it is a known failure pattern,
we preemptively fix them.

Since they are not trivial functions, make them non-inline by moving
them to up.c.  This also makes it so we don't have to fix #include
dependancies for preempt_{disable,enable}.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 include/linux/smp.h | 62 ++++++++++++++---------------------------------------
 kernel/up.c         | 39 +++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 46 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index c848876..3724a90 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -29,6 +29,22 @@ extern unsigned int total_cpus;
 int smp_call_function_single(int cpuid, smp_call_func_t func, void *info,
 			     int wait);
 
+/*
+ * Call a function on processors specified by mask, which might include
+ * the local one.
+ */
+void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
+		void *info, bool wait);
+
+/*
+ * Call a function on each processor for which the supplied function
+ * cond_func returns a positive value. This may include the local
+ * processor.
+ */
+void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
+		smp_call_func_t func, void *info, bool wait,
+		gfp_t gfp_flags);
+
 #ifdef CONFIG_SMP
 
 #include <linux/preempt.h>
@@ -101,22 +117,6 @@ static inline void call_function_init(void) { }
 int on_each_cpu(smp_call_func_t func, void *info, int wait);
 
 /*
- * Call a function on processors specified by mask, which might include
- * the local one.
- */
-void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
-		void *info, bool wait);
-
-/*
- * Call a function on each processor for which the supplied function
- * cond_func returns a positive value. This may include the local
- * processor.
- */
-void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
-		smp_call_func_t func, void *info, bool wait,
-		gfp_t gfp_flags);
-
-/*
  * Mark the boot cpu "online" so that it can call console drivers in
  * printk() and can access its per-cpu storage.
  */
@@ -151,36 +151,6 @@ static inline int on_each_cpu(smp_call_func_t func, void *info, int wait)
 	return 0;
 }
 
-/*
- * Note we still need to test the mask even for UP
- * because we actually can get an empty mask from
- * code that on SMP might call us without the local
- * CPU in the mask.
- */
-#define on_each_cpu_mask(mask, func, info, wait) \
-	do {						\
-		if (cpumask_test_cpu(0, (mask))) {	\
-			local_irq_disable();		\
-			(func)(info);			\
-			local_irq_enable();		\
-		}					\
-	} while (0)
-/*
- * Preemption is disabled here to make sure the cond_func is called under the
- * same condtions in UP and SMP.
- */
-#define on_each_cpu_cond(cond_func, func, info, wait, gfp_flags)\
-	do {							\
-		void *__info = (info);				\
-		preempt_disable();				\
-		if ((cond_func)(0, __info)) {			\
-			local_irq_disable();			\
-			(func)(__info);				\
-			local_irq_enable();			\
-		}						\
-		preempt_enable();				\
-	} while (0)
-
 static inline void smp_send_reschedule(int cpu) { }
 #define smp_prepare_boot_cpu()			do {} while (0)
 #define smp_call_function_many(mask, func, info, wait) \
diff --git a/kernel/up.c b/kernel/up.c
index c54c75e..144e572 100644
--- a/kernel/up.c
+++ b/kernel/up.c
@@ -19,3 +19,42 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 	return 0;
 }
 EXPORT_SYMBOL(smp_call_function_single);
+
+/*
+ * Note we still need to test the mask even for UP
+ * because we actually can get an empty mask from
+ * code that on SMP might call us without the local
+ * CPU in the mask.
+ */
+void on_each_cpu_mask(const struct cpumask *mask,
+		      smp_call_func_t func, void *info, bool wait)
+{
+	unsigned long flags;
+
+	if (cpumask_test_cpu(0, mask)) {
+		local_irq_save(flags);
+		func(info);
+		local_irq_restore(flags);
+	}
+}
+EXPORT_SYMBOL(on_each_cpu_mask);
+
+/*
+ * Preemption is disabled here to make sure the cond_func is called under the
+ * same condtions in UP and SMP.
+ */
+void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
+		      smp_call_func_t func, void *info, bool wait,
+		      gfp_t gfp_flags)
+{
+	unsigned long flags;
+
+	preempt_disable();
+	if (cond_func(0, info)) {
+		local_irq_save(flags);
+		func(info);
+		local_irq_restore(flags);
+	}
+	preempt_enable();
+}
+EXPORT_SYMBOL(on_each_cpu_cond);
-- 
1.7.11.7

