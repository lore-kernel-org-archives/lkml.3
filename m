Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab3LWUlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 15:41:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33542 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757916Ab3LWUjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 15:39:54 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: pmladek@suse.cz, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5/9] smp: Provide __smp_call_function_any()
Date: Mon, 23 Dec 2013 21:39:26 +0100
Message-Id: <1387831171-5264-6-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387831171-5264-1-git-send-email-jack@suse.cz>
References: <1387831171-5264-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide function to call given function on any cpu from a given cpu mask
while providing own csd structure.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/smp.h |  9 +++++++
 kernel/smp.c        | 67 +++++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 58 insertions(+), 18 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 1e8c72100eda..37aa794a93ce 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -100,6 +100,8 @@ void smp_call_function_many(const struct cpumask *mask,
 
 int smp_call_function_any(const struct cpumask *mask,
 			  smp_call_func_t func, void *info, int wait);
+int __smp_call_function_any(const struct cpumask *mask,
+			    struct call_single_data *csd, int wait);
 
 void kick_all_cpus_sync(void);
 
@@ -149,6 +151,13 @@ smp_call_function_any(const struct cpumask *mask, smp_call_func_t func,
 	return smp_call_function_single(0, func, info, wait);
 }
 
+static inline int
+__smp_call_function_any(const struct cpumask *mask,
+			struct call_single_data *csd, int wait)
+{
+	return __smp_call_function_single(0, csd, wait);
+}
+
 static inline void kick_all_cpus_sync(void) {  }
 
 #endif /* !SMP */
diff --git a/kernel/smp.c b/kernel/smp.c
index 2efcfa1d11ee..4c44554ff5b6 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -238,6 +238,27 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
+static unsigned int pick_any_cpu(const struct cpumask *mask)
+{
+	unsigned int cpu = smp_processor_id();
+	const struct cpumask *nodemask;
+
+	/* Try for same CPU (cheapest) */
+	if (cpumask_test_cpu(cpu, mask))
+		return cpu;
+
+	/* Try for same node. */
+	nodemask = cpumask_of_node(cpu_to_node(cpu));
+	for (cpu = cpumask_first_and(nodemask, mask); cpu < nr_cpu_ids;
+	     cpu = cpumask_next_and(cpu, nodemask, mask)) {
+		if (cpu_online(cpu))
+			return cpu;
+	}
+
+	/* Any online will do */
+	return cpumask_any_and(mask, cpu_online_mask);
+}
+
 /*
  * smp_call_function_any - Run a function on any of the given cpus
  * @mask: The mask of cpus it can run on.
@@ -256,27 +277,13 @@ int smp_call_function_any(const struct cpumask *mask,
 			  smp_call_func_t func, void *info, int wait)
 {
 	unsigned int cpu;
-	const struct cpumask *nodemask;
 	int ret;
 
-	/* Try for same CPU (cheapest) */
-	cpu = get_cpu();
-	if (cpumask_test_cpu(cpu, mask))
-		goto call;
-
-	/* Try for same node. */
-	nodemask = cpumask_of_node(cpu_to_node(cpu));
-	for (cpu = cpumask_first_and(nodemask, mask); cpu < nr_cpu_ids;
-	     cpu = cpumask_next_and(cpu, nodemask, mask)) {
-		if (cpu_online(cpu))
-			goto call;
-	}
-
-	/* Any online will do: smp_call_function_single handles nr_cpu_ids. */
-	cpu = cpumask_any_and(mask, cpu_online_mask);
-call:
+	preempt_disable();
+	cpu = pick_any_cpu(mask);
+	/* smp_call_function_single handles nr_cpu_ids. */
 	ret = smp_call_function_single(cpu, func, info, wait);
-	put_cpu();
+	preempt_enable();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(smp_call_function_any);
@@ -322,6 +329,30 @@ int __smp_call_function_single(int cpu, struct call_single_data *csd, int wait)
 }
 EXPORT_SYMBOL_GPL(__smp_call_function_single);
 
+/*
+ * __smp_call_function_any - Run a function on any of the given cpus
+ * @mask: The mask of cpus it can run on.
+ * @csd: Pre-allocated and setup data structure
+ * @wait: If true, wait until function has completed.
+ *
+ * Like smp_call_function_any() but allow caller to pass in a pre-allocated
+ * data structure.
+ */
+int __smp_call_function_any(const struct cpumask *mask,
+			    struct call_single_data *csd, int wait)
+{
+	unsigned int cpu;
+	int ret;
+
+	preempt_disable();
+	cpu = pick_any_cpu(mask);
+	/* smp_call_function_single handles nr_cpu_ids. */
+	ret = __smp_call_function_single(cpu, csd, wait);
+	preempt_enable();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__smp_call_function_any);
+
 /**
  * smp_call_function_many(): Run a function on a set of other CPUs.
  * @mask: The set of cpus to run on (only runs on online subset).
-- 
1.8.1.4

