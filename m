Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbaEQEvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 00:51:42 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47594 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148AbaEQEvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 00:51:40 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        swarren@nvidia.com, nicolas.pitre@linaro.org, swarren@wwwdotorg.org,
        dianders@chromium.org, linux@arm.linux.org.uk,
        thomas.abraham@linaro.org, pdeschrijver@nvidia.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3 1/4] cpufreq: handle calls to ->target_index() in separate routine
Date: Sat, 17 May 2014 10:21:20 +0530
Message-Id: <914cddcb07a8aa1a9ec984f436dd2bba69cfd128.1400302114.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1400302114.git.viresh.kumar@linaro.org>
References: <cover.1400302114.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1400302114.git.viresh.kumar@linaro.org>
References: <cover.1400302114.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handling calls to ->target_index() has got complex over time and might become
more complex. So, its better to take target_index() bits out in another routine
__target_index() for better code readability. Shouldn't have any functional
impact.

Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 56 ++++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index a05c921..9bf12a2 100644
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
+				__func__, policy->cpu, freqs.old, freqs.new);
+
+		cpufreq_freq_transition_begin(policy, &freqs);
+	}
+
+	retval = cpufreq_driver->target_index(policy, index);
+	if (retval)
+		pr_err("%s: Failed to change cpu frequency: %d\n",
+				__func__, retval);
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

