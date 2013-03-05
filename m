Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3CEIHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:07:08 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:63498 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3CEIHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:07:07 -0500
Message-ID: <5135A77F.2010705@huawei.com>
Date: Tue, 5 Mar 2013 16:06:23 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/9] sched: Move struct sched_group to kernel/sched/sched.h
References: <5135A736.8050104@huawei.com>
In-Reply-To: <5135A736.8050104@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move struct sched_group_power and sched_group and related inline
functions to kernel/sched/sched.h, as they are used internally only.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/sched.h | 58 ++-------------------------------------------------
 kernel/sched/sched.h  | 56 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 56 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f8826d0..0d64130 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -780,62 +780,6 @@ enum cpu_idle_type {
 
 extern int __weak arch_sd_sibiling_asym_packing(void);
 
-struct sched_group_power {
-	atomic_t ref;
-	/*
-	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
-	 * single CPU.
-	 */
-	unsigned int power, power_orig;
-	unsigned long next_update;
-	/*
-	 * Number of busy cpus in this group.
-	 */
-	atomic_t nr_busy_cpus;
-
-	unsigned long cpumask[0]; /* iteration mask */
-};
-
-struct sched_group {
-	struct sched_group *next;	/* Must be a circular list */
-	atomic_t ref;
-
-	unsigned int group_weight;
-	struct sched_group_power *sgp;
-
-	/*
-	 * The CPUs this group covers.
-	 *
-	 * NOTE: this field is variable length. (Allocated dynamically
-	 * by attaching extra space to the end of the structure,
-	 * depending on how many CPUs the kernel has booted up with)
-	 */
-	unsigned long cpumask[0];
-};
-
-static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
-{
-	return to_cpumask(sg->cpumask);
-}
-
-/*
- * cpumask masking which cpus in the group are allowed to iterate up the domain
- * tree.
- */
-static inline struct cpumask *sched_group_mask(struct sched_group *sg)
-{
-	return to_cpumask(sg->sgp->cpumask);
-}
-
-/**
- * group_first_cpu - Returns the first cpu in the cpumask of a sched_group.
- * @group: The group whose first cpu is to be returned.
- */
-static inline unsigned int group_first_cpu(struct sched_group *group)
-{
-	return cpumask_first(sched_group_cpus(group));
-}
-
 struct sched_domain_attr {
 	int relax_domain_level;
 };
@@ -846,6 +790,8 @@ struct sched_domain_attr {
 
 extern int sched_domain_level_max;
 
+struct sched_group;
+
 struct sched_domain {
 	/* These fields must be setup */
 	struct sched_domain *parent;	/* top domain must be null terminated */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 709a30c..1a4a2b1 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -572,6 +572,62 @@ static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
 DECLARE_PER_CPU(struct sched_domain *, sd_llc);
 DECLARE_PER_CPU(int, sd_llc_id);
 
+struct sched_group_power {
+	atomic_t ref;
+	/*
+	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
+	 * single CPU.
+	 */
+	unsigned int power, power_orig;
+	unsigned long next_update;
+	/*
+	 * Number of busy cpus in this group.
+	 */
+	atomic_t nr_busy_cpus;
+
+	unsigned long cpumask[0]; /* iteration mask */
+};
+
+struct sched_group {
+	struct sched_group *next;	/* Must be a circular list */
+	atomic_t ref;
+
+	unsigned int group_weight;
+	struct sched_group_power *sgp;
+
+	/*
+	 * The CPUs this group covers.
+	 *
+	 * NOTE: this field is variable length. (Allocated dynamically
+	 * by attaching extra space to the end of the structure,
+	 * depending on how many CPUs the kernel has booted up with)
+	 */
+	unsigned long cpumask[0];
+};
+
+static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
+{
+	return to_cpumask(sg->cpumask);
+}
+
+/*
+ * cpumask masking which cpus in the group are allowed to iterate up the domain
+ * tree.
+ */
+static inline struct cpumask *sched_group_mask(struct sched_group *sg)
+{
+	return to_cpumask(sg->sgp->cpumask);
+}
+
+/**
+ * group_first_cpu - Returns the first cpu in the cpumask of a sched_group.
+ * @group: The group whose first cpu is to be returned.
+ */
+static inline unsigned int group_first_cpu(struct sched_group *group)
+{
+	return cpumask_first(sched_group_cpus(group));
+}
+
 extern int group_balance_cpu(struct sched_group *sg);
 
 #endif /* CONFIG_SMP */
-- 
1.8.0.2
