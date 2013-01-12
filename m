Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab3ALFPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 00:15:01 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:41170 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab3ALFO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 00:14:59 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/5] cpufreq: Manage only online cpus
Date: Sat, 12 Jan 2013 10:44:38 +0530
Message-Id: <1765dc7c08c5cc2fccbdfba8e63492ff4a183a81.1357967566.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1357967566.git.viresh.kumar@linaro.org>
References: <cover.1357967566.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1357967566.git.viresh.kumar@linaro.org>
References: <cover.1357967566.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq core doesn't manage offline cpus and if driver->init() has returned
mask including offline cpus, it may result in unwanted behavior by cpufreq core
or governors.

We need to get only online cpus in this mask. There are two places to fix this
mask, cpufreq core and cpufreq driver. It makes sense to do this at common place
and hence is done in core.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 1f93dbd..de99517 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -970,6 +970,13 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 		pr_debug("initialization failed\n");
 		goto err_unlock_policy;
 	}
+
+	/*
+	 * affected cpus must always be the one, which are online. We aren't
+	 * managing offline cpus here.
+	 */
+	cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);
+
 	policy->user_policy.min = policy->min;
 	policy->user_policy.max = policy->max;
 
-- 
1.7.12.rc2.18.g61b472e

