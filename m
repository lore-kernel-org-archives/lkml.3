Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbaGYBHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:07:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34427 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaGYBHn (ORCPT
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
Subject: [PATCH v4 2/5] cpufreq: Keep track of which CPU owns the kobj/sysfs nodes separately
Date: Thu, 24 Jul 2014 18:07:25 -0700
Message-Id: <1406250448-470-3-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1406250448-470-1-git-send-email-skannan@codeaurora.org>
References: <1406250448-470-1-git-send-email-skannan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ownership of the kobj doesn't need to match policy->cpu or change as
frequently. So, keep track of it separately.

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/cpufreq/cpufreq.c | 4 +++-
 include/linux/cpufreq.h   | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index ee0eb7b..af4f291 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -868,7 +868,7 @@ static int cpufreq_add_dev_symlink(struct cpufreq_policy *policy)
 	for_each_cpu(j, policy->cpus) {
 		struct device *cpu_dev;
 
-		if (j == policy->cpu)
+		if (j == policy->kobj_cpu)
 			continue;
 
 		pr_debug("Adding link for CPU: %u\n", j);
@@ -917,6 +917,7 @@ static int cpufreq_add_dev_interface(struct cpufreq_policy *policy,
 			goto err_out_kobj_put;
 	}
 
+	policy->kobj_cpu = policy->cpu;
 	ret = cpufreq_add_dev_symlink(policy);
 	if (ret)
 		goto err_out_kobj_put;
@@ -1330,6 +1331,7 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
 
 		return -EINVAL;
 	}
+	policy->kobj_cpu = cpu_dev->id;
 
 	return cpu_dev->id;
 }
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index ec4112d..91c2e38 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -68,6 +68,7 @@ struct cpufreq_policy {
 	unsigned int		cpu;    /* cpu nr of CPU managing this policy */
 	unsigned int		last_cpu; /* cpu nr of previous CPU that managed
 					   * this policy */
+	unsigned int		kobj_cpu; /* Tracks which CPU own the kobj */
 	struct clk		*clk;
 	struct cpufreq_cpuinfo	cpuinfo;/* see above */
 
-- 
1.8.2.1

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
