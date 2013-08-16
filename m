Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3HPC0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:26:17 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:33632 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab3HPC0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:26:14 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 03/34] cpufreq: arm_big_little: remove calls to cpufreq_notify_transition()
Date: Fri, 16 Aug 2013 07:55:00 +0530
Message-Id: <abfababbb45f34fbc43e51a183d27e20adb0beae.1376619363.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376619363.git.viresh.kumar@linaro.org>
References: <cover.1376619363.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376619363.git.viresh.kumar@linaro.org>
References: <cover.1376619363.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the drivers do following in their ->target_index() routines:

	struct cpufreq_freqs freqs;
	freqs.old = old freq...
	freqs.new = new freq...

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);

	/* Change rate here */

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);

This is replicated over all cpufreq drivers today and there doesn't exists a
good enough reason why this shouldn't be moved to cpufreq core instead.

Earlier patches have added support in cpufreq core to do cpufreq notification on
frequency change, this one removes it from this driver.

Some related minor cleanups are also done along with it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/arm_big_little.c | 25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index daf4423..e3e8f25 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -51,30 +51,11 @@ static unsigned int bL_cpufreq_get(unsigned int cpu)
 static int bL_cpufreq_set_target(struct cpufreq_policy *policy,
 		unsigned int index)
 {
-	struct cpufreq_freqs freqs;
-	u32 cpu = policy->cpu, cur_cluster;
-	int ret = 0;
+	u32 cur_cluster;
 
 	cur_cluster = cpu_to_cluster(policy->cpu);
-
-	freqs.old = bL_cpufreq_get(policy->cpu);
-	freqs.new = freq_table[cur_cluster][index].frequency;
-
-	pr_debug("%s: cpu: %d, cluster: %d, oldfreq: %d, target freq: %d, new freq: %d\n",
-			__func__, cpu, cur_cluster, freqs.old, freqs.new,
-			freqs.new);
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
-	ret = clk_set_rate(clk[cur_cluster], freqs.new * 1000);
-	if (ret) {
-		pr_err("clk_set_rate failed: %d\n", ret);
-		freqs.new = freqs.old;
-	}
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	return ret;
+	return clk_set_rate(clk[cur_cluster],
+			freq_table[cur_cluster][index].frequency * 1000);
 }
 
 static void put_cluster_clk_and_freq_table(struct device *cpu_dev)
-- 
1.7.12.rc2.18.g61b472e

