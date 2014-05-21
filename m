Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaEUJEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:04:44 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:33224 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaEUJEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:04:41 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        swarren@nvidia.com, dianders@chromium.org, linux@arm.linux.org.uk,
        nicolas.pitre@linaro.org, thomas.abraham@linaro.org,
        pdeschrijver@nvidia.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V4 1/3] cpufreq: handle calls to ->target_index() in separate routine
Date: Wed, 21 May 2014 14:29:29 +0530
Message-Id: <b2ed4e111222c2367a77a1382a6a7ea232ef9b59.1400662383.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1400662383.git.viresh.kumar@linaro.org>
References: <cover.1400662383.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1400662383.git.viresh.kumar@linaro.org>
References: <cover.1400662383.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handling calls to ->target_index() has got complex over time and might become
more complex. So, its better to take target_index() bits out in another routine
__target_index() for better code readability. Shouldn't have any functional
impact.

Tested-by: Stephen Warren <swarren@nvidia.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 56 ++++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index a05c921..ae11dd5 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1816,12 +1816,43 @@ EXPORT_SYMBOL(cpufreq_unregister_notifier);
  *                              GOVERNORS                            *
  *********************************************************************/
 
+static int __target_index(struct cpufreq_policy *policy,
+			  struct cpufreq_frequency_table *freq_table, int index)
+{
+	struct cpufreq_freqs freqs;
+	int retval = -EINVAL;
+	bool notify;
+
+	notify = !(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION);
+
+	if (notify) {
+		freqs.old = policy->cur;
+		freqs.new = freq_table[index].frequency;
+		freqs.flags = 0;
+
+		pr_debug("%s: cpu: %d, oldfreq: %u, new freq: %u\n",
+			 __func__, policy->cpu, freqs.old, freqs.new);
+
+		cpufreq_freq_transition_begin(policy, &freqs);
+	}
+
+	retval = cpufreq_driver->target_index(policy, index);
+	if (retval)
+		pr_err("%s: Failed to change cpu frequency: %d\n", __func__,
+		       retval);
+
+	if (notify)
+		cpufreq_freq_transition_end(policy, &freqs, retval);
+
+	return retval;
+}
+
 int __cpufreq_driver_target(struct cpufreq_policy *policy,
 			    unsigned int target_freq,
 			    unsigned int relation)
 {
-	int retval = -EINVAL;
 	unsigned int old_target_freq = target_freq;
+	int retval = -EINVAL;
 
 	if (cpufreq_disabled())
 		return -ENODEV;
@@ -1848,8 +1879,6 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 		retval = cpufreq_driver->target(policy, target_freq, relation);
 	else if (cpufreq_driver->target_index) {
 		struct cpufreq_frequency_table *freq_table;
-		struct cpufreq_freqs freqs;
-		bool notify;
 		int index;
 
 		freq_table = cpufreq_frequency_get_table(policy->cpu);
@@ -1870,26 +1899,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 			goto out;
 		}
 
-		notify = !(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION);
-
-		if (notify) {
-			freqs.old = policy->cur;
-			freqs.new = freq_table[index].frequency;
-			freqs.flags = 0;
-
-			pr_debug("%s: cpu: %d, oldfreq: %u, new freq: %u\n",
-				 __func__, policy->cpu, freqs.old, freqs.new);
-
-			cpufreq_freq_transition_begin(policy, &freqs);
-		}
-
-		retval = cpufreq_driver->target_index(policy, index);
-		if (retval)
-			pr_err("%s: Failed to change cpu frequency: %d\n",
-			       __func__, retval);
-
-		if (notify)
-			cpufreq_freq_transition_end(policy, &freqs, retval);
+		retval = __target_index(policy, freq_table, index);
 	}
 
 out:
-- 
2.0.0.rc2

