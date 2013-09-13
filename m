Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299Ab3IMNzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:55:44 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:48681 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728Ab3IMNNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:13:40 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 090/228] cpufreq: call cpufreq_driver->get() after calling ->init()
Date: Fri, 13 Sep 2013 18:30:36 +0530
Message-Id: <65ceb79aa6cf70ee2ee64f92ffe92e43e8663c4e.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almost all drivers set policy->cur with current cpu frequency in their ->init()
part. This can be done for all of them at core level and so they wouldn't need
to do it.

This patch adds supporting code in cpufreq core for calling get() after we have
called init() for a policy.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index c7274e6..1e6b602 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1081,6 +1081,14 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 		goto err_set_policy_cpu;
 	}
 
+	if (cpufreq_driver->get) {
+		policy->cur = cpufreq_driver->get(policy->cpu);
+		if (!policy->cur) {
+			pr_err("%s: ->get() failed\n", __func__);
+			goto err_get_freq;
+		}
+	}
+
 	/* related cpus should atleast have policy->cpus */
 	cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
 
@@ -1135,6 +1143,9 @@ err_out_unregister:
 		per_cpu(cpufreq_cpu_data, j) = NULL;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
+err_get_freq:
+	if (cpufreq_driver->exit)
+		cpufreq_driver->exit(policy);
 err_set_policy_cpu:
 	cpufreq_policy_free(policy);
 nomem_out:
-- 
1.7.12.rc2.18.g61b472e

