Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaKEO70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:59:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348AbaKEOyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:54:19 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: robert.schoene@tu-dresden.de, sboyd@codeaurora.org,
        Prarit Bhargava <prarit@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
Subject: [PATCH 3/5] cpufreq, dbs_data->usage count must be atomic
Date: Wed,  5 Nov 2014 09:53:57 -0500
Message-Id: <1415199239-19019-4-git-send-email-prarit@redhat.com>
In-Reply-To: <1415199239-19019-1-git-send-email-prarit@redhat.com>
References: <1415199239-19019-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage_count value can be modified from several cpus concurrently if
!CPUFREQ_HAVE_GOVERNOR_PER_POLICY.  This leads to a variety of panics in
which the usage_count is negative or exceeds the number of cpus in the
system.  It must be switched to atomic_t and protected with a mutex to make sure
that future read/writes obtain the correct data.

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-pm@vger.kernel.org
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/cpufreq/cpufreq_governor.c |   16 ++++++++++++----
 drivers/cpufreq/cpufreq_governor.h |    3 ++-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 1b44496..32ad9db 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -265,7 +265,9 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		if (have_governor_per_policy()) {
 			WARN_ON(dbs_data);
 		} else if (dbs_data) {
-			dbs_data->usage_count++;
+			mutex_lock(&dbs_data->usage_count_mutex);
+			atomic_inc(&dbs_data->usage_count);
+			mutex_unlock(&dbs_data->usage_count_mutex);
 			policy->governor_data = dbs_data;
 			return 0;
 		}
@@ -277,7 +279,10 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		}
 
 		dbs_data->cdata = cdata;
-		dbs_data->usage_count = 1;
+		mutex_init(&dbs_data->usage_count_mutex);
+		mutex_lock(&dbs_data->usage_count_mutex);
+		atomic_set(&dbs_data->usage_count, 1);
+		mutex_unlock(&dbs_data->usage_count_mutex);
 		rc = cdata->init(dbs_data);
 		if (rc) {
 			pr_err("%s: POLICY_INIT: init() failed\n", __func__);
@@ -322,7 +327,8 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 
 		return 0;
 	case CPUFREQ_GOV_POLICY_EXIT:
-		if (!--dbs_data->usage_count) {
+		mutex_lock(&dbs_data->usage_count_mutex);
+		if (atomic_dec_and_test(&dbs_data->usage_count)) {
 			sysfs_remove_group(get_governor_parent_kobj(policy),
 					get_sysfs_attr(dbs_data));
 
@@ -338,9 +344,11 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			}
 
 			cdata->exit(dbs_data);
+			mutex_unlock(&dbs_data->usage_count_mutex);
 			kfree(dbs_data);
 			cdata->gdbs_data = NULL;
-		}
+		} else
+			mutex_unlock(&dbs_data->usage_count_mutex);
 
 		policy->governor_data = NULL;
 		return 0;
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index cc401d1..53ca449 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -219,7 +219,8 @@ struct common_dbs_data {
 struct dbs_data {
 	struct common_dbs_data *cdata;
 	unsigned int min_sampling_rate;
-	int usage_count;
+	struct mutex usage_count_mutex;
+	atomic_t usage_count;
 	void *tuners;
 
 	/* dbs_mutex protects dbs_enable in governor start/stop */
-- 
1.7.9.3

