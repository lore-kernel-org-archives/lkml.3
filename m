Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788Ab3IMNU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:20:27 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:40666 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933757Ab3IMNUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:20:22 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 147/228] cpufreq: Implement light weight ->target_index() routine
Date: Fri, 13 Sep 2013 18:31:33 +0530
Message-Id: <6d62be97c30726a2eb7edfe891595f57bcd00f53.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently prototype of cpufreq_drivers target routines is:

int target(struct cpufreq_policy *policy, unsigned int target_freq,
		unsigned int relation);

And most of the drivers call cpufreq_frequency_table_target() to get a valid
index of their frequency table which is closest to the target_freq. And they
don't use target_freq and relation after it.

So, it makes sense to just do this work in cpufreq core before calling
cpufreq_frequency_table_target() and simply pass index instead. But this can be
done only with drivers which expose their frequency table with cpufreq core. For
others we need to stick with the old prototype of target() until those drivers
are converted to expose frequency tables.

This patch implements the new light weight prototype for target_index() routine.
It looks like this:

int target_index(struct cpufreq_policy *policy, unsigned int index);

CPUFreq core will call cpufreq_frequency_table_target() before calling this
routine and pass index to it. Because CPUFreq core now requires to call routines
present in freq_table.c CONFIG_CPU_FREQ_TABLE must be enabled all the time.

This also marks target() interface as deprecated. So, that new drivers avoid
using it. And Documentation is updated accordingly.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 Documentation/cpu-freq/cpu-drivers.txt | 27 ++++++++++------
 Documentation/cpu-freq/governors.txt   |  4 +--
 drivers/cpufreq/cpufreq.c              | 59 +++++++++++++++++++++++++++-------
 include/linux/cpufreq.h                |  4 ++-
 4 files changed, 71 insertions(+), 23 deletions(-)

diff --git a/Documentation/cpu-freq/cpu-drivers.txt b/Documentation/cpu-freq/cpu-drivers.txt
index 40282e6..8b1a445 100644
--- a/Documentation/cpu-freq/cpu-drivers.txt
+++ b/Documentation/cpu-freq/cpu-drivers.txt
@@ -23,8 +23,8 @@ Contents:
 1.1  Initialization
 1.2  Per-CPU Initialization
 1.3  verify
-1.4  target or setpolicy?
-1.5  target
+1.4  target/target_index or setpolicy?
+1.5  target/target_index
 1.6  setpolicy
 2.   Frequency Table Helpers
 
@@ -56,7 +56,8 @@ cpufreq_driver.init -		A pointer to the per-CPU initialization
 cpufreq_driver.verify -		A pointer to a "verification" function.
 
 cpufreq_driver.setpolicy _or_ 
-cpufreq_driver.target -		See below on the differences.
+cpufreq_driver.target/
+target_index		-	See below on the differences.
 
 And optionally
 
@@ -66,7 +67,7 @@ cpufreq_driver.resume -		A pointer to a per-CPU resume function
 				which is called with interrupts disabled
 				and _before_ the pre-suspend frequency
 				and/or policy is restored by a call to
-				->target or ->setpolicy.
+				->target/target_index or ->setpolicy.
 
 cpufreq_driver.attr -		A pointer to a NULL-terminated list of
 				"struct freq_attr" which allow to
@@ -103,8 +104,8 @@ policy->governor		must contain the "default policy" for
 				this CPU. A few moments later,
 				cpufreq_driver.verify and either
 				cpufreq_driver.setpolicy or
-				cpufreq_driver.target is called with
-				these values.
+				cpufreq_driver.target/target_index is called
+				with these values.
 
 For setting some of these values (cpuinfo.min[max]_freq, policy->min[max]), the
 frequency table helpers might be helpful. See the section 2 for more information
@@ -133,20 +134,28 @@ range) is within policy->min and policy->max. If necessary, increase
 policy->max first, and only if this is no solution, decrease policy->min.
 
 
-1.4 target or setpolicy?
+1.4 target/target_index or setpolicy?
 ----------------------------
 
 Most cpufreq drivers or even most cpu frequency scaling algorithms 
 only allow the CPU to be set to one frequency. For these, you use the
-->target call.
+->target/target_index call.
 
 Some cpufreq-capable processors switch the frequency between certain
 limits on their own. These shall use the ->setpolicy call
 
 
-1.4. target
+1.4. target/target_index
 -------------
 
+The target_index call has two arguments: struct cpufreq_policy *policy,
+and unsigned int index (into the exposed frequency table).
+
+The CPUfreq driver must set the new frequency when called here. The
+actual frequency must be determined by freq_table[index].frequency.
+
+Deprecated:
+----------
 The target call has three arguments: struct cpufreq_policy *policy,
 unsigned int target_frequency, unsigned int relation.
 
diff --git a/Documentation/cpu-freq/governors.txt b/Documentation/cpu-freq/governors.txt
index 219970b..77ec215 100644
--- a/Documentation/cpu-freq/governors.txt
+++ b/Documentation/cpu-freq/governors.txt
@@ -40,7 +40,7 @@ Most cpufreq drivers (in fact, all except one, longrun) or even most
 cpu frequency scaling algorithms only offer the CPU to be set to one
 frequency. In order to offer dynamic frequency scaling, the cpufreq
 core must be able to tell these drivers of a "target frequency". So
-these specific drivers will be transformed to offer a "->target"
+these specific drivers will be transformed to offer a "->target/target_index"
 call instead of the existing "->setpolicy" call. For "longrun", all
 stays the same, though.
 
@@ -71,7 +71,7 @@ CPU can be set to switch independently	 |	   CPU can only be set
 		    /			       the limits of policy->{min,max}
 		   /			            \
 		  /				     \
-	Using the ->setpolicy call,		 Using the ->target call,
+	Using the ->setpolicy call,		 Using the ->target/target_index call,
 	    the limits and the			  the frequency closest
 	     "policy" is set.			  to target_freq is set.
 						  It is assured that it
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 5295694..3fd24b1 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -47,6 +47,11 @@ static LIST_HEAD(cpufreq_policy_list);
 static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
 #endif
 
+static inline bool has_target(void)
+{
+	return cpufreq_driver->target_index || cpufreq_driver->target;
+}
+
 /*
  * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
  * all cpufreq/hotplug/workqueue/etc related lock issues.
@@ -437,7 +442,7 @@ static int cpufreq_parse_governor(char *str_governor, unsigned int *policy,
 			*policy = CPUFREQ_POLICY_POWERSAVE;
 			err = 0;
 		}
-	} else if (cpufreq_driver->target) {
+	} else if (has_target()) {
 		struct cpufreq_governor *t;
 
 		mutex_lock(&cpufreq_governor_mutex);
@@ -595,7 +600,7 @@ static ssize_t show_scaling_available_governors(struct cpufreq_policy *policy,
 	ssize_t i = 0;
 	struct cpufreq_governor *t;
 
-	if (!cpufreq_driver->target) {
+	if (!has_target()) {
 		i += sprintf(buf, "performance powersave");
 		goto out;
 	}
@@ -885,7 +890,7 @@ static int cpufreq_add_dev_interface(struct cpufreq_policy *policy,
 		if (ret)
 			goto err_out_kobj_put;
 	}
-	if (cpufreq_driver->target) {
+	if (has_target()) {
 		ret = sysfs_create_file(&policy->kobj, &scaling_cur_freq.attr);
 		if (ret)
 			goto err_out_kobj_put;
@@ -934,10 +939,10 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
 				  unsigned int cpu, struct device *dev,
 				  bool frozen)
 {
-	int ret = 0, has_target = !!cpufreq_driver->target;
+	int ret = 0;
 	unsigned long flags;
 
-	if (has_target) {
+	if (has_target()) {
 		ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
 		if (ret) {
 			pr_err("%s: Failed to stop governor\n", __func__);
@@ -955,7 +960,7 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
 
 	unlock_policy_rwsem_write(policy->cpu);
 
-	if (has_target) {
+	if (has_target()) {
 		if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
 			(ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
 			pr_err("%s: Failed to start governor\n", __func__);
@@ -1254,7 +1259,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 		return -EINVAL;
 	}
 
-	if (cpufreq_driver->target) {
+	if (has_target()) {
 		ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
 		if (ret) {
 			pr_err("%s: Failed to stop governor\n", __func__);
@@ -1321,7 +1326,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 
 	/* If cpu is last user of policy, free policy */
 	if (cpus == 1) {
-		if (cpufreq_driver->target) {
+		if (has_target()) {
 			ret = __cpufreq_governor(policy,
 					CPUFREQ_GOV_POLICY_EXIT);
 			if (ret) {
@@ -1364,7 +1369,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 		if (!frozen)
 			cpufreq_policy_free(policy);
 	} else {
-		if (cpufreq_driver->target) {
+		if (has_target()) {
 			if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
 					(ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
 				pr_err("%s: Failed to start governor\n",
@@ -1761,6 +1766,12 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 	pr_debug("target for CPU %u: %u kHz, relation %u, requested %u kHz\n",
 			policy->cpu, target_freq, relation, old_target_freq);
 
+	/*
+	 * This might look like a redundant call as we are checking it again
+	 * after finding index. But it is left intentionally for cases where
+	 * exactly same freq is called again and so we can save on few function
+	 * calls.
+	 */
 	if (target_freq == policy->cur)
 		return 0;
 
@@ -1774,7 +1785,32 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 
 	if (cpufreq_driver->target)
 		retval = cpufreq_driver->target(policy, target_freq, relation);
+	else if (cpufreq_driver->target_index) {
+		struct cpufreq_frequency_table *freq_table;
+		int index;
+
+		freq_table = cpufreq_frequency_get_table(policy->cpu);
+		if (unlikely(!freq_table)) {
+			pr_err("%s: Unable to find freq_table\n", __func__);
+			goto out;
+		}
 
+		retval = cpufreq_frequency_table_target(policy, freq_table,
+				target_freq, relation, &index);
+		if (unlikely(retval)) {
+			pr_err("%s: Unable to find matching freq\n", __func__);
+			goto out;
+		}
+
+		if (freq_table[index].frequency == policy->cur) {
+			retval = 0;
+			goto out;
+		}
+
+		retval = cpufreq_driver->target_index(policy, index);
+	}
+
+out:
 	/*
 	 * For drivers with CPUFREQ_ASYNC_NOTIFICATION flag set, we decrement
 	 * transition_ongoing from POSTCHANGE notifiers.
@@ -2114,7 +2150,7 @@ int cpufreq_update_policy(unsigned int cpu)
 			pr_debug("Driver did not initialize current freq");
 			policy->cur = new_policy.cur;
 		} else {
-			if (policy->cur != new_policy.cur && cpufreq_driver->target)
+			if (policy->cur != new_policy.cur && has_target())
 				cpufreq_out_of_sync(cpu, policy->cur,
 								new_policy.cur);
 		}
@@ -2193,7 +2229,8 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 		return -ENODEV;
 
 	if (!driver_data || !driver_data->verify || !driver_data->init ||
-	    ((!driver_data->setpolicy) && (!driver_data->target)))
+	    !(driver_data->setpolicy || driver_data->target_index ||
+		    driver_data->target))
 		return -EINVAL;
 
 	pr_debug("trying to register driver %s\n", driver_data->name);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index c2184c6..f13beec 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -188,9 +188,11 @@ struct cpufreq_driver {
 
 	/* define one out of two */
 	int	(*setpolicy)	(struct cpufreq_policy *policy);
-	int	(*target)	(struct cpufreq_policy *policy,
+	int	(*target)	(struct cpufreq_policy *policy,	/* Deprecated */
 				 unsigned int target_freq,
 				 unsigned int relation);
+	int	(*target_index)	(struct cpufreq_policy *policy,
+				 unsigned int index);
 
 	/* should be defined, if possible */
 	unsigned int	(*get)	(unsigned int cpu);
-- 
1.7.12.rc2.18.g61b472e

