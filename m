Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab3HLRtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:49:55 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45260 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab3HLRtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:49:49 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        John Crispin <blogic@openwrt.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-cris-kernel@axis.com,
        Mikael Starvik <starvik@axis.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        sparclinux@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Steven Miao <realmz6@gmail.com>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 02/31] cpufreq: Implement light weight ->target() routine
Date: Mon, 12 Aug 2013 23:18:38 +0530
Message-Id: <1e550a8b0292a64a6ba27d64b8d5f14b6194dcbd.1376329128.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376329128.git.viresh.kumar@linaro.org>
References: <cover.1376329128.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376329128.git.viresh.kumar@linaro.org>
References: <cover.1376329128.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the new light weight prototype for target() routine. It
looks like this:

int target(struct cpufreq_policy *policy, unsigned int index);

CPUFreq core will call cpufreq_frequency_table_target() before calling this
routine and pass index to it.

This also marks target_old() interface as deprecated. So, that new drivers avoid
using it.

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: John Crispin <blogic@openwrt.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-cris-kernel@axis.com
Cc: Mikael Starvik <starvik@axis.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: sparclinux@vger.kernel.org
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 55 +++++++++++++++++++++++++++++++++++++----------
 include/linux/cpufreq.h   |  4 +++-
 2 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 1cbea5b..a897a70 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -47,6 +47,11 @@ static LIST_HEAD(cpufreq_policy_list);
 static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
 #endif
 
+static inline bool has_target(void)
+{
+	return cpufreq_driver->target || cpufreq_driver->target_old;
+}
+
 /*
  * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
  * all cpufreq/hotplug/workqueue/etc related lock issues.
@@ -377,7 +382,7 @@ static int cpufreq_parse_governor(char *str_governor, unsigned int *policy,
 			*policy = CPUFREQ_POLICY_POWERSAVE;
 			err = 0;
 		}
-	} else if (cpufreq_driver->target_old) {
+	} else if (has_target()) {
 		struct cpufreq_governor *t;
 
 		mutex_lock(&cpufreq_governor_mutex);
@@ -539,7 +544,7 @@ static ssize_t show_scaling_available_governors(struct cpufreq_policy *policy,
 	ssize_t i = 0;
 	struct cpufreq_governor *t;
 
-	if (!cpufreq_driver->target_old) {
+	if (!has_target()) {
 		i += sprintf(buf, "performance powersave");
 		goto out;
 	}
@@ -822,7 +827,7 @@ static int cpufreq_add_dev_interface(struct cpufreq_policy *policy,
 		if (ret)
 			goto err_out_kobj_put;
 	}
-	if (cpufreq_driver->target_old) {
+	if (has_target()) {
 		ret = sysfs_create_file(&policy->kobj, &scaling_cur_freq.attr);
 		if (ret)
 			goto err_out_kobj_put;
@@ -871,10 +876,10 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
 				  unsigned int cpu, struct device *dev,
 				  bool frozen)
 {
-	int ret = 0, has_target = !!cpufreq_driver->target_old;
+	int ret = 0;
 	unsigned long flags;
 
-	if (has_target) {
+	if (has_target()) {
 		ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
 		if (ret) {
 			pr_err("%s: Failed to stop governor\n", __func__);
@@ -893,7 +898,7 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
 
 	unlock_policy_rwsem_write(policy->cpu);
 
-	if (has_target) {
+	if (has_target()) {
 		if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
 			(ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
 			pr_err("%s: Failed to start governor\n", __func__);
@@ -1204,7 +1209,7 @@ static int __cpufreq_remove_dev(struct device *dev,
 		return -EINVAL;
 	}
 
-	if (cpufreq_driver->target_old) {
+	if (has_target()) {
 		ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
 		if (ret) {
 			pr_err("%s: Failed to stop governor\n", __func__);
@@ -1244,7 +1249,7 @@ static int __cpufreq_remove_dev(struct device *dev,
 
 	/* If cpu is last user of policy, free policy */
 	if (cpus == 1) {
-		if (cpufreq_driver->target_old) {
+		if (has_target()) {
 			ret = __cpufreq_governor(policy,
 					CPUFREQ_GOV_POLICY_EXIT);
 			if (ret) {
@@ -1282,7 +1287,7 @@ static int __cpufreq_remove_dev(struct device *dev,
 		if (!frozen)
 			cpufreq_policy_free(policy);
 	} else {
-		if (cpufreq_driver->target_old) {
+		if (has_target()) {
 			if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
 					(ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
 				pr_err("%s: Failed to start governor\n",
@@ -1646,11 +1651,39 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
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
 
 	if (cpufreq_driver->target_old)
 		retval = cpufreq_driver->target_old(policy, target_freq, relation);
+	else if (cpufreq_driver->target) {
+		struct cpufreq_frequency_table *freq_table;
+		int index;
+
+		freq_table = cpufreq_frequency_get_table(policy->cpu);
+		if (unlikely(!freq_table)) {
+			pr_err("%s: Unable to find freq_table\n", __func__);
+			return retval;
+		}
+
+		retval = cpufreq_frequency_table_target(policy, freq_table,
+				target_freq, relation, &index);
+		if (unlikely(retval)) {
+			pr_err("%s: Unable to find matching freq\n", __func__);
+			return retval;
+		}
+
+		if (freq_table[index].frequency == policy->cur)
+			return 0;
+
+		retval = cpufreq_driver->target(policy, index);
+	}
 
 	return retval;
 }
@@ -1983,7 +2016,7 @@ int cpufreq_update_policy(unsigned int cpu)
 			pr_debug("Driver did not initialize current freq");
 			policy->cur = new_policy.cur;
 		} else {
-			if (policy->cur != new_policy.cur && cpufreq_driver->target_old)
+			if (policy->cur != new_policy.cur && has_target())
 				cpufreq_out_of_sync(cpu, policy->cur,
 								new_policy.cur);
 		}
@@ -2058,7 +2091,7 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 		return -ENODEV;
 
 	if (!driver_data || !driver_data->verify || !driver_data->init ||
-	    ((!driver_data->setpolicy) && (!driver_data->target_old)))
+	    (!driver_data->setpolicy && !has_target()))
 		return -EINVAL;
 
 	pr_debug("trying to register driver %s\n", driver_data->name);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 47adf32..7c2e35b 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -195,9 +195,11 @@ struct cpufreq_driver {
 
 	/* define one out of two */
 	int	(*setpolicy)	(struct cpufreq_policy *policy);
-	int	(*target_old)	(struct cpufreq_policy *policy,
+	int	(*target_old)	(struct cpufreq_policy *policy,	/* Deprecated */
 				 unsigned int target_freq,
 				 unsigned int relation);
+	int	(*target)	(struct cpufreq_policy *policy,
+				 unsigned int index);
 
 	/* should be defined, if possible */
 	unsigned int	(*get)	(unsigned int cpu);
-- 
1.7.12.rc2.18.g61b472e

