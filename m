Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab3D3Ocp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:32:45 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:61958 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3D3Ocj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:32:39 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] cpufreq: governors: Fix CPUFREQ_GOV_POLICY_{INIT|EXIT} notifiers
Date: Tue, 30 Apr 2013 20:02:17 +0530
Message-Id: <49cc0bdaea95098d3782c8ff3ea0d6ffe21127aa.1367332148.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1367332148.git.viresh.kumar@linaro.org>
References: <cover.1367332148.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1367332148.git.viresh.kumar@linaro.org>
References: <cover.1367332148.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two types of INIT/EXIT activities that we need to do for governors:
- Done only once per governor (doesn't depend how many instances of governor
  were there). eg: cpufreq_register_notifier() for conservative governor.
- Done per instance of governor, eg: sysfs_{create|remove}_group().

There were some corner cases where current code isn't able to handle them
separately and so failing for some test cases.

We use two separate variables now for keeping track of above two requirements.
- governor->initialized for first one
- dbs_data->usage_count for per governor instance

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq_governor.c | 11 +++++++----
 drivers/cpufreq/cpufreq_governor.h |  1 +
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 443442d..5af40ad 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -255,6 +255,7 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		if (have_governor_per_policy()) {
 			WARN_ON(dbs_data);
 		} else if (dbs_data) {
+			dbs_data->usage_count++;
 			policy->governor_data = dbs_data;
 			return 0;
 		}
@@ -266,6 +267,7 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		}
 
 		dbs_data->cdata = cdata;
+		dbs_data->usage_count = 1;
 		rc = cdata->init(dbs_data);
 		if (rc) {
 			pr_err("%s: POLICY_INIT: init() failed\n", __func__);
@@ -294,7 +296,8 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		set_sampling_rate(dbs_data, max(dbs_data->min_sampling_rate,
 					latency * LATENCY_MULTIPLIER));
 
-		if (dbs_data->cdata->governor == GOV_CONSERVATIVE) {
+		if ((cdata->governor == GOV_CONSERVATIVE) &&
+				(!policy->governor->initialized)) {
 			struct cs_ops *cs_ops = dbs_data->cdata->gov_ops;
 
 			cpufreq_register_notifier(cs_ops->notifier_block,
@@ -306,12 +309,12 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 
 		return 0;
 	case CPUFREQ_GOV_POLICY_EXIT:
-		if ((policy->governor->initialized == 1) ||
-				have_governor_per_policy()) {
+		if (!--dbs_data->usage_count) {
 			sysfs_remove_group(get_governor_parent_kobj(policy),
 					get_sysfs_attr(dbs_data));
 
-			if (dbs_data->cdata->governor == GOV_CONSERVATIVE) {
+			if ((dbs_data->cdata->governor == GOV_CONSERVATIVE) &&
+				(policy->governor->initialized == 1)) {
 				struct cs_ops *cs_ops = dbs_data->cdata->gov_ops;
 
 				cpufreq_unregister_notifier(cs_ops->notifier_block,
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index 8ac3353..e16a961 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -211,6 +211,7 @@ struct common_dbs_data {
 struct dbs_data {
 	struct common_dbs_data *cdata;
 	unsigned int min_sampling_rate;
+	int usage_count;
 	void *tuners;
 
 	/* dbs_mutex protects dbs_enable in governor start/stop */
-- 
1.7.12.rc2.18.g61b472e

