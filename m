Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280Ab3CFOhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:37:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44275 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab3CFOht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:37:49 -0500
Date: Wed, 6 Mar 2013 06:36:31 -0800
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-5e6521eaa1ee581a13b904f35b80c5efeb2baccb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <5135A77F.2010705@huawei.com>
References: <5135A77F.2010705@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Move struct sched_group to kernel/sched/
 sched.h
Git-Commit-ID: 5e6521eaa1ee581a13b904f35b80c5efeb2baccb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Mar 2013 06:36:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e6521eaa1ee581a13b904f35b80c5efeb2baccb
Gitweb:     http://git.kernel.org/tip/5e6521eaa1ee581a13b904f35b80c5efeb2baccb
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Tue, 5 Mar 2013 16:06:23 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Mar 2013 11:24:31 +0100

sched: Move struct sched_group to kernel/sched/sched.h

Move struct sched_group_power and sched_group and related inline
functions to kernel/sched/sched.h, as they are used internally
only.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5135A77F.2010705@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
