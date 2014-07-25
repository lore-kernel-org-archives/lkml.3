Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbaGYBHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:07:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34419 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaGYBHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 21:07:43 -0400
From: Saravana Kannan <skannan@codeaurora.org>
To: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Saravana Kannan" <skannan@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH v4 1/5] cpufreq: Don't wait for CPU to going offline to restart governor
Date: Thu, 24 Jul 2014 18:07:24 -0700
Message-Id: <1406250448-470-2-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1406250448-470-1-git-send-email-skannan@codeaurora.org>
References: <1406250448-470-1-git-send-email-skannan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to wait for the CPU going down to fully go offline to
restart the governor. We can stop the governor, change policy->cpus and
immediately restart the governor. This should reduce the time without any
CPUfreq monitoring and also help future patches with simplifying the code.

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/cpufreq/cpufreq.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 62259d2..ee0eb7b 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1390,6 +1390,21 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 		cpufreq_driver->stop_cpu(policy);
 	}
 
+	down_write(&policy->rwsem);
+	cpumask_clear_cpu(cpu, policy->cpus);
+	up_write(&policy->rwsem);
+
+	if (cpus > 1 && has_target()) {
+		ret = __cpufreq_governor(policy, CPUFREQ_GOV_START);
+		if (!ret)
+			ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
+
+		if (ret) {
+			pr_err("%s: Failed to start governor\n", __func__);
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
@@ -1410,15 +1425,12 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 		return -EINVAL;
 	}
 
-	down_write(&policy->rwsem);
+	down_read(&policy->rwsem);
 	cpus = cpumask_weight(policy->cpus);
-
-	if (cpus > 1)
-		cpumask_clear_cpu(cpu, policy->cpus);
-	up_write(&policy->rwsem);
+	up_read(&policy->rwsem);
 
 	/* If cpu is last user of policy, free policy */
-	if (cpus == 1) {
+	if (cpus == 0) {
 		if (has_target()) {
 			ret = __cpufreq_governor(policy,
 					CPUFREQ_GOV_POLICY_EXIT);
@@ -1447,15 +1459,6 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 
 		if (!cpufreq_suspended)
 			cpufreq_policy_free(policy);
-	} else if (has_target()) {
-		ret = __cpufreq_governor(policy, CPUFREQ_GOV_START);
-		if (!ret)
-			ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
-
-		if (ret) {
-			pr_err("%s: Failed to start governor\n", __func__);
-			return ret;
-		}
 	}
 
 	per_cpu(cpufreq_cpu_data, cpu) = NULL;
-- 
1.8.2.1

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
