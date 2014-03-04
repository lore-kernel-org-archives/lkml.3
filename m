Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbaCDDoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 22:44:32 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:60693 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163AbaCDDo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 22:44:28 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, skannan@codeaurora.org
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 2/3] cpufreq: Initialize policy before making it available for others to use
Date: Tue,  4 Mar 2014 11:44:00 +0800
Message-Id: <99ab97f08241ac295eae898b48587fedda13f340.1393904428.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <98b7ae22d936456bf830aa749556a115969cfa47.1393904428.git.viresh.kumar@linaro.org>
References: <98b7ae22d936456bf830aa749556a115969cfa47.1393904428.git.viresh.kumar@linaro.org>
In-Reply-To: <98b7ae22d936456bf830aa749556a115969cfa47.1393904428.git.viresh.kumar@linaro.org>
References: <98b7ae22d936456bf830aa749556a115969cfa47.1393904428.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Policy must be fully initialized before it is being made available for use by
others. Otherwise cpufreq_cpu_get() would be able to grab a half initialized
policy structure that might not have affected_cpus (for example) filled. And so
anybody accessing those fields will get the wrong value and hence the results
would be unpredictable.

So, in order to fix this lets do all the necessary initialization before we make
policy structure available via cpufreq_cpu_get(). With this we can guarantee
that any code accessing fields of policy would be stable enough, as policy would
be completely initialized by now.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V1->V2:
- Improved commit logs

 drivers/cpufreq/cpufreq.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index fff2968..3c6f9a5 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1114,6 +1114,20 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 		goto err_set_policy_cpu;
 	}
 
+	/* related cpus should atleast have policy->cpus */
+	cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
+
+	/*
+	 * affected cpus must always be the one, which are online. We aren't
+	 * managing offline cpus here.
+	 */
+	cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);
+
+	if (!frozen) {
+		policy->user_policy.min = policy->min;
+		policy->user_policy.max = policy->max;
+	}
+
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu(j, policy->cpus)
 		per_cpu(cpufreq_cpu_data, j) = policy;
@@ -1167,20 +1181,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 		}
 	}
 
-	/* related cpus should atleast have policy->cpus */
-	cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
-
-	/*
-	 * affected cpus must always be the one, which are online. We aren't
-	 * managing offline cpus here.
-	 */
-	cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);
-
-	if (!frozen) {
-		policy->user_policy.min = policy->min;
-		policy->user_policy.max = policy->max;
-	}
-
 	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
 				     CPUFREQ_START, policy);
 
-- 
1.7.12.rc2.18.g61b472e

