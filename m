Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab3IMNVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:21:30 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52039 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab3IMNVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:21:25 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 156/228] cpufreq: e_powersaver: Convert to light weight ->target_index() routine
Date: Fri, 13 Sep 2013 18:31:42 +0530
Message-Id: <d25ecdaa114fc4f0c403d7817fd83c002378512b.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts existing .target() to newly defined light weight
.target_index() routine for this driver.

CPUFreq core will call cpufreq_frequency_table_target() before calling this
routine and will pass index to it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/e_powersaver.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index 2c11ce3..b39c4ef 100644
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
@@ -418,7 +407,7 @@ static int eps_cpu_exit(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver eps_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= eps_target,
+	.target_index	= eps_target,
 	.init		= eps_cpu_init,
 	.exit		= eps_cpu_exit,
 	.get		= eps_get,
-- 
1.7.12.rc2.18.g61b472e

