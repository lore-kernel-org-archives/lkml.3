Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaJVGIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:08:10 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60096 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaJVGIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:08:07 -0400
From: Mike Turquette <mturquette@linaro.org>
To: peterz@infradead.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, kamalesh@linux.vnet.ibm.com, riel@redhat.com,
        efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, patches@linaro.org,
        tuukka.tikkanen@linaro.org, amit.kucheria@linaro.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH RFC 7/7] sched: energy_model: simple cpu frequency scaling policy
Date: Tue, 21 Oct 2014 23:07:31 -0700
Message-Id: <1413958051-7103-8-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building on top of the scale invariant capacity patches and earlier
patches in this series that prepare CFS for scaling cpu frequency, this
patch implements a simple, naive ondemand-like cpu frequency scaling
policy that is driven by enqueue_task_fair and dequeue_tassk_fair. This
new policy is named "energy_model" as an homage to the on-going work in
that area. It is NOT an actual energy model.

This policy is implemented using the CPUfreq governor interface for two
main reasons:

1) re-using the CPUfreq machine drivers without using the governor
interface is hard. I do not forsee any issue continuing to use the
governor interface going forward but it is worth making clear what this
patch does up front.

2) using the CPUfreq interface allows us to switch between the
energy_model governor and other CPUfreq governors (such as ondemand) at
run-time. This is very useful for comparative testing and tuning.

A caveat to #2 above is that the weak arch function used by the governor
means that only one scheduler-driven policy can be linked at a time.
This limitation does not apply to "traditional" governors. I raised this
in my previous capacity_ops patches[0] but as discussed at LPC14 last
week, it seems desirable to pursue a single cpu frequency scaling policy
at first, and try to make that work for everyone interested in using it.
If that model breaks down then we can revisit the idea of dynamic
selection of scheduler-driven cpu frequency scaling.

Unlike legacy CPUfreq governors, this policy does not implement its own
logic loop (such as a workqueue triggered by a timer), but instead uses
an event-driven design. Frequency is evaluated by entering
{en,de}queue_task_fair and then a kthread is woken from
run_rebalance_domains which scales cpu frequency based on the latest
evaluation.

The policy implemented in this patch takes the highest cpu utilization
from policy->cpus and uses that select a frequency target based on the
same 80%/20% thresholds used as defaults in ondemand. Frequenecy-scaled
thresholds are pre-computed when energy_model inits. The frequency
selection is a simple comparison of cpu utilization (as defined in
Morten's latest RFC) to the threshold values. In the future this logic
could be replaced with something more sophisticated that uses PELT to
get a historical overview. Ideas are welcome.

Note that the pre-computed thresholds above do not take into account
micro-architecture differences (SMT or big.LITTLE hardware), only
frequency invariance.

Not-signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/cpufreq/Kconfig     |  21 +++
 include/linux/cpufreq.h     |   3 +
 kernel/sched/Makefile       |   1 +
 kernel/sched/energy_model.c | 341 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 366 insertions(+)
 create mode 100644 kernel/sched/energy_model.c

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 22b42d5..78a2caa 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -102,6 +102,15 @@ config CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
 	  Be aware that not all cpufreq drivers support the conservative
 	  governor. If unsure have a look at the help section of the
 	  driver. Fallback governor will be the performance governor.
+
+config CPU_FREQ_DEFAULT_GOV_ENERGY_MODEL
+	bool "energy_model"
+	select CPU_FREQ_GOV_ENERGY_MODEL
+	select CPU_FREQ_GOV_PERFORMANCE
+	help
+	  Use the CPUfreq governor 'energy_model' as default. This
+	  scales cpu frequency from the scheduler as per-task statistics
+	  are updated.
 endchoice
 
 config CPU_FREQ_GOV_PERFORMANCE
@@ -183,6 +192,18 @@ config CPU_FREQ_GOV_CONSERVATIVE
 
 	  If in doubt, say N.
 
+config CPU_FREQ_GOV_ENERGY_MODEL
+	tristate "'energy model' cpufreq governor"
+	depends on CPU_FREQ
+	select CPU_FREQ_GOV_COMMON
+	help
+	  'energy_model' - this governor scales cpu frequency from the
+	  scheduler as a function of cpu utilization. It does not
+	  evaluate utilization on a periodic basis (unlike ondemand) but
+	  instead is invoked from CFS when updating per-task statistics.
+
+	  If in doubt, say N.
+
 config CPUFREQ_GENERIC
 	tristate "Generic cpufreq driver"
 	depends on HAVE_CLK && OF
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 91d173c..69cbbec 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -482,6 +482,9 @@ extern struct cpufreq_governor cpufreq_gov_ondemand;
 #elif defined(CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE)
 extern struct cpufreq_governor cpufreq_gov_conservative;
 #define CPUFREQ_DEFAULT_GOVERNOR	(&cpufreq_gov_conservative)
+#elif defined(CONFIG_CPU_FREQ_DEFAULT_GOV_ENERGY_MODEL)
+extern struct cpufreq_governor cpufreq_gov_energy_model;
+#define CPUFREQ_DEFAULT_GOVERNOR	(&cpufreq_gov_energy_model)
 #endif
 
 /*********************************************************************
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index ab32b7b..7cd404c 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -19,3 +19,4 @@ obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
 obj-$(CONFIG_SCHED_DEBUG) += debug.o
 obj-$(CONFIG_CGROUP_CPUACCT) += cpuacct.o
+obj-$(CONFIG_CPU_FREQ_GOV_ENERGY_MODEL) += energy_model.o
diff --git a/kernel/sched/energy_model.c b/kernel/sched/energy_model.c
new file mode 100644
index 0000000..5cdea9a
--- /dev/null
+++ b/kernel/sched/energy_model.c
@@ -0,0 +1,341 @@
+/*
+ *  Copyright (C)  2014 Michael Turquette <mturquette@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/cpufreq.h>
+#include <linux/module.h>
+#include <linux/kthread.h>
+
+#include "sched.h"
+
+#define THROTTLE_MSEC		50
+#define UP_THRESHOLD		80
+#define DOWN_THRESHOLD		20
+
+/**
+ * em_data - per-policy data used by energy_mode
+ * @throttle: bail if current time is less than than ktime_throttle.
+ * 		    Derived from THROTTLE_MSEC
+ * @up_threshold:   table of normalized capacity states to determine if cpu
+ * 		    should run faster. Derived from UP_THRESHOLD
+ * @down_threshold: table of normalized capacity states to determine if cpu
+ * 		    should run slower. Derived from DOWN_THRESHOLD
+ *
+ * struct em_data is the per-policy energy_model-specific data structure. A
+ * per-policy instance of it is created when the energy_model governor receives
+ * the CPUFREQ_GOV_START condition and a pointer to it exists in the gov_data
+ * member of struct cpufreq_policy.
+ *
+ * Readers of this data must call down_read(policy->rwsem). Writers must
+ * call down_write(policy->rwsem).
+ */
+struct em_data {
+	/* per-policy throttling */
+	ktime_t throttle;
+	unsigned int *up_threshold;
+	unsigned int *down_threshold;
+	struct task_struct *task;
+	atomic_long_t target_freq;
+	atomic_t need_wake_task;
+};
+
+/*
+ * we pass in struct cpufreq_policy. This is safe because changing out the
+ * policy requires a call to __cpufreq_governor(policy, CPUFREQ_GOV_STOP),
+ * which tears all of the data structures down and __cpufreq_governor(policy,
+ * CPUFREQ_GOV_START) will do a full rebuild, including this kthread with the
+ * new policy pointer
+ */
+static int energy_model_thread(void *data)
+{
+	struct sched_param param;
+	struct cpufreq_policy *policy;
+	struct em_data *em;
+	int ret;
+
+	policy = (struct cpufreq_policy *) data;
+	if (!policy) {
+		pr_warn("%s: missing policy\n", __func__);
+		do_exit(-EINVAL);
+	}
+
+	em = policy->gov_data;
+	if (!em) {
+		pr_warn("%s: missing governor data\n", __func__);
+		do_exit(-EINVAL);
+	}
+
+	param.sched_priority = 0;
+	sched_setscheduler(current, SCHED_FIFO, &param);
+
+
+	do {
+		down_write(&policy->rwsem);
+		if (!atomic_read(&em->need_wake_task))  {
+			up_write(&policy->rwsem);
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule();
+			continue;
+		}
+
+		ret = __cpufreq_driver_target(policy, atomic_read(&em->target_freq),
+				CPUFREQ_RELATION_H);
+		if (ret)
+			pr_debug("%s: __cpufreq_driver_target returned %d\n",
+					__func__, ret);
+
+		em->throttle = ktime_get();
+		atomic_set(&em->need_wake_task, 0);
+		up_write(&policy->rwsem);
+	} while (!kthread_should_stop());
+
+	do_exit(0);
+}
+
+static void em_wake_up_process(struct task_struct *task)
+{
+	/* this is null during early boot */
+	if (IS_ERR_OR_NULL(task)) {
+		return;
+	}
+
+	wake_up_process(task);
+}
+
+void arch_scale_cpu_freq(void)
+{
+	struct cpufreq_policy *policy;
+	struct em_data *em;
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		policy = cpufreq_cpu_get(cpu);
+		if (IS_ERR_OR_NULL(policy))
+			continue;
+
+		em = policy->gov_data;
+		if (!em)
+			continue;
+
+		/*
+		 * FIXME replace the atomic stuff by holding write-locks
+		 * in arch_eval_cpu_freq?
+		 */
+		if (atomic_read(&em->need_wake_task)) {
+			em_wake_up_process(em->task);
+		}
+
+		cpufreq_cpu_put(policy);
+	}
+}
+
+/**
+ * arch_eval_cpu_freq - scale cpu frequency based on CFS utilization
+ * @update_cpus: mask of CPUs with updated utilization and capacity
+ *
+ * Declared and weakly defined in kernel/sched/fair.c This definition overrides
+ * the default. In the case of CONFIG_FAIR_GROUP_SCHED, update_cpus may
+ * contains cpus that are not in the same policy. Otherwise update_cpus will be
+ * a single cpu.
+ *
+ * Holds read lock for policy->rw_sem.
+ *
+ * FIXME weak arch function means that only one definition of this function can
+ * be linked. How to support multiple energy model policies?
+ */
+void arch_eval_cpu_freq(struct cpumask *update_cpus)
+{
+	struct cpufreq_policy *policy;
+	struct em_data *em;
+	int index;
+	unsigned int cpu, tmp;
+	unsigned long percent_util = 0, max_util = 0, cap = 0, util = 0;
+
+	/*
+	 * In the case of CONFIG_FAIR_GROUP_SCHED, policy->cpus may be a subset
+	 * of update_cpus. In such case take the first cpu in update_cpus, get
+	 * its policy and try to scale the affects cpus. Then we clear the
+	 * corresponding bits from update_cpus and try again. If a policy does
+	 * not exist for a cpu then we remove that bit as well, preventing an
+	 * infinite loop.
+	 */
+	while (!cpumask_empty(update_cpus)) {
+		percent_util = 0;
+		max_util = 0;
+		cap = 0;
+		util = 0;
+
+		cpu = cpumask_first(update_cpus);
+		policy = cpufreq_cpu_get(cpu);
+		if (IS_ERR_OR_NULL(policy)) {
+			cpumask_clear_cpu(cpu, update_cpus);
+			continue;
+		}
+
+		if (!policy->gov_data)
+			return;
+
+		em = policy->gov_data;
+
+		if (ktime_before(ktime_get(), em->throttle)) {
+			trace_printk("THROTTLED");
+			goto bail;
+		}
+
+		/*
+		 * try scaling cpus
+		 *
+		 * algorithm assumptions & description:
+		 * 	all cpus in a policy run at the same rate/capacity.
+		 * 	choose frequency target based on most utilized cpu.
+		 * 	do not care about aggregating cpu utilization.
+		 * 	do not track any historical trends beyond utilization
+		 * 	if max_util > 80% of current capacity,
+		 * 		go to max capacity
+		 * 	if max_util < 20% of current capacity,
+		 * 		go to the next lowest capacity
+		 * 	otherwise, stay at the same capacity state
+		 */
+		for_each_cpu(tmp, policy->cpus) {
+			util = usage_util_of(cpu);
+			if (util > max_util)
+				max_util = util;
+		}
+
+		cap = capacity_of(cpu);
+		if (!cap) {
+			goto bail;
+		}
+
+		index = cpufreq_frequency_table_get_index(policy, policy->cur);
+		if (max_util > em->up_threshold[index]) {
+			/* write em->target_freq with read lock held */
+			atomic_long_set(&em->target_freq, policy->max);
+			/*
+			 * FIXME this is gross. convert arch_eval_cpu_freq to
+			 * hold the write lock?
+			 */
+			atomic_set(&em->need_wake_task, 1);
+		} else if (max_util < em->down_threshold[index]) {
+			/* write em->target_freq with read lock held */
+			atomic_long_set(&em->target_freq, policy->cur - 1);
+			/*
+			 * FIXME this is gross. convert arch_eval_cpu_freq to
+			 * hold the write lock?
+			 */
+			atomic_set(&em->need_wake_task, 1);
+		}
+
+bail:
+		/* remove policy->cpus fromm update_cpus */
+		cpumask_andnot(update_cpus, update_cpus, policy->cpus);
+		cpufreq_cpu_put(policy);
+	}
+
+	return;
+}
+
+static void em_start(struct cpufreq_policy *policy)
+{
+	int index = 0, count = 0;
+	unsigned int capacity;
+	struct em_data *em;
+	struct cpufreq_frequency_table *pos;
+
+	/* prepare per-policy private data */
+	em = kzalloc(sizeof(*em), GFP_KERNEL);
+	if (!em) {
+		pr_debug("%s: failed to allocate private data\n", __func__);
+		return;
+	}
+
+	policy->gov_data = em;
+
+	/* how many entries in the frequency table? */
+	cpufreq_for_each_entry(pos, policy->freq_table)
+		count++;
+
+	/* pre-compute thresholds */
+	em->up_threshold = kcalloc(count, sizeof(unsigned int), GFP_KERNEL);
+	em->down_threshold = kcalloc(count, sizeof(unsigned int), GFP_KERNEL);
+
+	cpufreq_for_each_entry(pos, policy->freq_table) {
+		/* FIXME capacity below is not scaled for uarch */
+		capacity = pos->frequency * SCHED_CAPACITY_SCALE / policy->max;
+		em->up_threshold[index] = capacity * UP_THRESHOLD / 100;
+		em->down_threshold[index] = capacity * DOWN_THRESHOLD / 100;
+		pr_debug("%s: cpu = %u index = %d capacity = %u up = %u down = %u\n",
+				__func__, cpumask_first(policy->cpus), index,
+				capacity, em->up_threshold[index],
+				em->down_threshold[index]);
+		index++;
+	}
+
+	/* init per-policy kthread */
+	em->task = kthread_create(energy_model_thread, policy, "kenergy_model_task");
+	if (IS_ERR_OR_NULL(em->task))
+		pr_err("%s: failed to create kenergy_model_task thread\n", __func__);
+}
+
+
+static void em_stop(struct cpufreq_policy *policy)
+{
+	struct em_data *em;
+
+	em = policy->gov_data;
+
+	kthread_stop(em->task);
+
+	/* replace with devm counterparts */
+	kfree(em->up_threshold);
+	kfree(em->down_threshold);
+	kfree(em);
+}
+
+static int energy_model_setup(struct cpufreq_policy *policy, unsigned int event)
+{
+	switch (event) {
+		case CPUFREQ_GOV_START:
+			/* Start managing the frequency */
+			em_start(policy);
+			return 0;
+
+		case CPUFREQ_GOV_STOP:
+			em_stop(policy);
+			return 0;
+
+		case CPUFREQ_GOV_LIMITS:	/* unused */
+		case CPUFREQ_GOV_POLICY_INIT:	/* unused */
+		case CPUFREQ_GOV_POLICY_EXIT:	/* unused */
+			break;
+	}
+	return 0;
+}
+
+#ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_ENERGY_MODEL
+static
+#endif
+struct cpufreq_governor cpufreq_gov_energy_model = {
+	.name			= "energy_model",
+	.governor		= energy_model_setup,
+	.owner			= THIS_MODULE,
+};
+
+static int __init energy_model_init(void)
+{
+	return cpufreq_register_governor(&cpufreq_gov_energy_model);
+}
+
+static void __exit energy_model_exit(void)
+{
+	cpufreq_unregister_governor(&cpufreq_gov_energy_model);
+}
+
+/* Try to make this the default governor */
+fs_initcall(energy_model_init);
+
+MODULE_LICENSE("GPL");
-- 
1.8.3.2

