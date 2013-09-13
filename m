Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657Ab3IMNTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:19:30 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33279 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933610Ab3IMNTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:19:21 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 138/228] cpufreq: omap: use cpufreq_generic_init() routine
Date: Fri, 13 Sep 2013 18:31:24 +0530
Message-Id: <e3b7b2442c78b1ca7b708f4e5ecd8512f0f2fcbe.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use generic cpufreq_generic_init() routine instead of replicating the same code
here.

This also rearranges the code a bit to make it more sensible. Also removes some
unnecessary checks.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/omap-cpufreq.c | 41 +++++++++++------------------------------
 1 file changed, 11 insertions(+), 30 deletions(-)

diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index a8c3f90..58b2200 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -160,50 +160,31 @@ static inline void freq_table_free(void)
 
 static int omap_cpu_init(struct cpufreq_policy *policy)
 {
-	int result = 0;
+	int result;
 
 	mpu_clk = clk_get(NULL, "cpufreq_ck");
 	if (IS_ERR(mpu_clk))
 		return PTR_ERR(mpu_clk);
 
-	if (policy->cpu >= NR_CPUS) {
-		result = -EINVAL;
-		goto fail_ck;
-	}
-
-	if (!freq_table)
+	if (!freq_table) {
 		result = opp_init_cpufreq_table(mpu_dev, &freq_table);
-
-	if (result) {
-		dev_err(mpu_dev, "%s: cpu%d: failed creating freq table[%d]\n",
+		if (result) {
+			dev_err(mpu_dev,
+				"%s: cpu%d: failed creating freq table[%d]\n",
 				__func__, policy->cpu, result);
-		goto fail_ck;
+			goto fail;
+		}
 	}
 
 	atomic_inc_return(&freq_table_users);
 
-	result = cpufreq_table_validate_and_show(policy, freq_table);
-	if (result)
-		goto fail_table;
-
-	/*
-	 * On OMAP SMP configuartion, both processors share the voltage
-	 * and clock. So both CPUs needs to be scaled together and hence
-	 * needs software co-ordination. Use cpufreq affected_cpus
-	 * interface to handle this scenario. Additional is_smp() check
-	 * is to keep SMP_ON_UP build working.
-	 */
-	if (is_smp())
-		cpumask_setall(policy->cpus);
-
 	/* FIXME: what's the actual transition time? */
-	policy->cpuinfo.transition_latency = 300 * 1000;
-
-	return 0;
+	result = cpufreq_generic_init(policy, freq_table, 300 * 1000);
+	if (!result)
+		return 0;
 
-fail_table:
 	freq_table_free();
-fail_ck:
+fail:
 	clk_put(mpu_clk);
 	return result;
 }
-- 
1.7.12.rc2.18.g61b472e

