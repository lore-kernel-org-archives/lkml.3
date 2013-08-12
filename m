Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3HLRuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:50:50 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46768 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3HLRuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:50:44 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 10/31] cpufreq: e_powersaver: Covert to light weight ->target() routine
Date: Mon, 12 Aug 2013 23:18:46 +0530
Message-Id: <6ed364b4a3b721d44ab6938d7a892dfa3b10e712.1376329128.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376329128.git.viresh.kumar@linaro.org>
References: <cover.1376329128.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376329128.git.viresh.kumar@linaro.org>
References: <cover.1376329128.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts existing .target_old() to newly defined light weight
.target() routine for this driver.

CPUFreq core will call cpufreq_frequency_table_target() before calling this
routine and will pass index to it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/e_powersaver.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index 00f963a..503496d 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -168,12 +168,9 @@ postchange:
 	return err;
 }
 
-static int eps_target(struct cpufreq_policy *policy,
-			       unsigned int target_freq,
-			       unsigned int relation)
+static int eps_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	struct eps_cpu_data *centaur;
-	unsigned int newstate = 0;
 	unsigned int cpu = policy->cpu;
 	unsigned int dest_state;
 	int ret;
@@ -182,16 +179,8 @@ static int eps_target(struct cpufreq_policy *policy,
 		return -ENODEV;
 	centaur = eps_cpu[cpu];
 
-	if (unlikely(cpufreq_frequency_table_target(policy,
-			&eps_cpu[cpu]->freq_table[0],
-			target_freq,
-			relation,
-			&newstate))) {
-		return -EINVAL;
-	}
-
 	/* Make frequency transition */
-	dest_state = centaur->freq_table[newstate].driver_data & 0xffff;
+	dest_state = centaur->freq_table[index].driver_data & 0xffff;
 	ret = eps_set_state(centaur, policy, dest_state);
 	if (ret)
 		printk(KERN_ERR "eps: Timeout!\n");
@@ -419,7 +408,7 @@ static int eps_cpu_exit(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver eps_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target_old	= eps_target,
+	.target		= eps_target,
 	.init		= eps_cpu_init,
 	.exit		= eps_cpu_exit,
 	.get		= eps_get,
-- 
1.7.12.rc2.18.g61b472e

