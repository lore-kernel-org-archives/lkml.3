Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbaKEO7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:59:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345AbaKEOyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:54:19 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: robert.schoene@tu-dresden.de, sboyd@codeaurora.org,
        Prarit Bhargava <prarit@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
Subject: [PATCH 5/5] cpufreq, add BUG() messages in critical paths to aid debugging failures
Date: Wed,  5 Nov 2014 09:53:59 -0500
Message-Id: <1415199239-19019-6-git-send-email-prarit@redhat.com>
In-Reply-To: <1415199239-19019-1-git-send-email-prarit@redhat.com>
References: <1415199239-19019-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some additional debug to capture failures in the locking scheme for
cpufreq.  Instead of just a NULL pointer, these warnings will capture failure
points if the locking scheme for cpufreq is broken.

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-pm@vger.kernel.org
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/cpufreq/cpufreq_governor.c |   32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index b1ee597..f158882 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -161,9 +161,18 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 EXPORT_SYMBOL_GPL(dbs_check_cpu);
 
 static inline void __gov_queue_work(int cpu, struct dbs_data *dbs_data,
-		unsigned int delay)
+				    unsigned int delay,
+				    struct cpufreq_policy *policy)
 {
-	struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
+	struct cpu_dbs_common_info *cdbs;
+
+	if (!dbs_data->cdata) {
+		pr_emerg("common_dbs_data is NULL for %s but initialized = %d",
+			 policy->governor->name,
+			 atomic_read(&policy->governor->initialized));
+		BUG();
+	}
+	cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
 
 	mod_delayed_work_on(cpu, system_wq, &cdbs->work, delay);
 }
@@ -185,10 +194,11 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
 		 * those works are canceled during CPU_DOWN_PREPARE so they
 		 * can't possibly run on any other CPU.
 		 */
-		__gov_queue_work(raw_smp_processor_id(), dbs_data, delay);
+		__gov_queue_work(raw_smp_processor_id(), dbs_data, delay,
+				 policy);
 	} else {
 		for_each_cpu(i, policy->cpus)
-			__gov_queue_work(i, dbs_data, delay);
+			__gov_queue_work(i, dbs_data, delay, policy);
 	}
 
 out_unlock:
@@ -258,7 +268,13 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 	else
 		dbs_data = cdata->gdbs_data;
 
-	WARN_ON(!dbs_data && (event != CPUFREQ_GOV_POLICY_INIT));
+	if (!dbs_data && (event != CPUFREQ_GOV_POLICY_INIT)) {
+		pr_emerg("governor_data is NULL but governor %s is initialized = %d [governor_enabled = %d event = %u]\n",
+			 policy->governor->name,
+			 atomic_read(&policy->governor->initialized),
+			 policy->governor_enabled, event);
+		BUG();
+	}
 
 	switch (event) {
 	case CPUFREQ_GOV_POLICY_INIT:
@@ -329,6 +345,12 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 	case CPUFREQ_GOV_POLICY_EXIT:
 		mutex_lock(&dbs_data->usage_count_mutex);
 		if (atomic_dec_and_test(&dbs_data->usage_count)) {
+			if (atomic_read(&policy->governor->initialized) > 1) {
+				pr_emerg("Removing governor %s but initialized = %d, dbs_data->usage_count = 0\n",
+					 policy->governor->name,
+				   atomic_read(&policy->governor->initialized));
+				BUG();
+			}
 			sysfs_remove_group(get_governor_parent_kobj(policy),
 					get_sysfs_attr(dbs_data));
 
-- 
1.7.9.3

