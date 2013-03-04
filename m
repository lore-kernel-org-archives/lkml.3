Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3CDHiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:38:18 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35936 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab3CDHiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:38:14 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3 1/4] cpufreq: Add per policy governor-init/exit infrastructure
Date: Mon,  4 Mar 2013 15:37:53 +0800
Message-Id: <5f69096f1e7b255967aa3f5af1645868b7c4325a.1362381470.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1362381470.git.viresh.kumar@linaro.org>
References: <cover.1362381470.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1362381470.git.viresh.kumar@linaro.org>
References: <cover.1362381470.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there can't be multiple instances of single governor_type. If we have
a multi-package system, where we have multiple instances of struct policy (per
package), we can't have multiple instances of same governor. i.e. We can't have
multiple instances of ondemand governor for multiple packages.

Governors directory in sysfs is created at /sys/devices/system/cpu/cpufreq/
governor-name/. Which again reflects that there can be only one instance of a
governor_type in the system.

This is a bottleneck for multicluster system, where we want different packages
to use same governor type, but with different tunables.

This patch is inclined towards providing this infrastructure. Because we are
required to allocate governor's resources dynamically now, we must do it at
policy creation and end. And so got CPUFREQ_GOV_POLICY_INIT/EXIT.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 21 ++++++++++++++++++---
 include/linux/cpufreq.h   |  9 ++++++---
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index b02824d..7d59688 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1070,6 +1070,8 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 
 	/* If cpu is last user of policy, free policy */
 	if (cpus == 1) {
+		__cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
+
 		lock_policy_rwsem_read(cpu);
 		kobj = &data->kobj;
 		cmp = &data->kobj_unregister;
@@ -1651,7 +1653,7 @@ EXPORT_SYMBOL(cpufreq_get_policy);
 static int __cpufreq_set_policy(struct cpufreq_policy *data,
 				struct cpufreq_policy *policy)
 {
-	int ret = 0;
+	int ret = 0, failed = 1;
 
 	pr_debug("setting new policy for CPU %u: %u - %u kHz\n", policy->cpu,
 		policy->min, policy->max);
@@ -1705,18 +1707,31 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
 			pr_debug("governor switch\n");
 
 			/* end old governor */
-			if (data->governor)
+			if (data->governor) {
 				__cpufreq_governor(data, CPUFREQ_GOV_STOP);
+				__cpufreq_governor(data,
+						CPUFREQ_GOV_POLICY_EXIT);
+			}
 
 			/* start new governor */
 			data->governor = policy->governor;
-			if (__cpufreq_governor(data, CPUFREQ_GOV_START)) {
+			if (!__cpufreq_governor(data, CPUFREQ_GOV_POLICY_INIT)) {
+				if (!__cpufreq_governor(data, CPUFREQ_GOV_START))
+					failed = 0;
+				else
+					__cpufreq_governor(data,
+							CPUFREQ_GOV_POLICY_EXIT);
+			}
+
+			if (failed) {
 				/* new governor failed, so re-start old one */
 				pr_debug("starting governor %s failed\n",
 							data->governor->name);
 				if (old_gov) {
 					data->governor = old_gov;
 					__cpufreq_governor(data,
+							CPUFREQ_GOV_POLICY_INIT);
+					__cpufreq_governor(data,
 							   CPUFREQ_GOV_START);
 				}
 				ret = -EINVAL;
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index a22944c..b7393b5 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -106,6 +106,7 @@ struct cpufreq_policy {
 					 * governors are used */
 	unsigned int		policy; /* see above */
 	struct cpufreq_governor	*governor; /* see below */
+	void			*governor_data;
 
 	struct work_struct	update; /* if update_policy() needs to be
 					 * called, but you're in IRQ context */
@@ -178,9 +179,11 @@ static inline unsigned long cpufreq_scale(unsigned long old, u_int div, u_int mu
  *                          CPUFREQ GOVERNORS                        *
  *********************************************************************/
 
-#define CPUFREQ_GOV_START  1
-#define CPUFREQ_GOV_STOP   2
-#define CPUFREQ_GOV_LIMITS 3
+#define CPUFREQ_GOV_START	1
+#define CPUFREQ_GOV_STOP	2
+#define CPUFREQ_GOV_LIMITS	3
+#define CPUFREQ_GOV_POLICY_INIT	4
+#define CPUFREQ_GOV_POLICY_EXIT	5
 
 struct cpufreq_governor {
 	char	name[CPUFREQ_NAME_LEN];
-- 
1.7.12.rc2.18.g61b472e

