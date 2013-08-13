Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab3HMNdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:33:55 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36592 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085Ab3HMNdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:33:52 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Steven Miao <realmz6@gmail.com>
Subject: [PATCH V2 06/35] cpufreq: blackfin: Covert to light weight ->target_index() routine
Date: Tue, 13 Aug 2013 19:02:19 +0530
Message-Id: <57b9c4fa9e22a22debe96f00d868745f8fdaa104.1376392602.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376392602.git.viresh.kumar@linaro.org>
References: <cover.1376392602.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376392602.git.viresh.kumar@linaro.org>
References: <cover.1376392602.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts existing .target() to newly defined light weight
.target_index() routine for this driver.

CPUFreq core will call cpufreq_frequency_table_target() before calling this
routine and will pass index to it.

Cc: Steven Miao <realmz6@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/blackfin-cpufreq.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/blackfin-cpufreq.c b/drivers/cpufreq/blackfin-cpufreq.c
index 48888cf..b343c7b 100644
--- a/drivers/cpufreq/blackfin-cpufreq.c
+++ b/drivers/cpufreq/blackfin-cpufreq.c
@@ -127,14 +127,11 @@ unsigned long cpu_set_cclk(int cpu, unsigned long new)
 }
 #endif
 
-static int bfin_target(struct cpufreq_policy *policy,
-			unsigned int target_freq, unsigned int relation)
+static int bfin_target(struct cpufreq_policy *policy, unsigned int index)
 {
 #ifndef CONFIG_BF60x
 	unsigned int plldiv;
 #endif
-	unsigned int index;
-	unsigned long cclk_hz;
 	struct cpufreq_freqs freqs;
 	static unsigned long lpj_ref;
 	static unsigned int  lpj_ref_freq;
@@ -144,17 +141,11 @@ static int bfin_target(struct cpufreq_policy *policy,
 	cycles_t cycles;
 #endif
 
-	if (cpufreq_frequency_table_target(policy, bfin_freq_table, target_freq,
-				relation, &index))
-		return -EINVAL;
-
-	cclk_hz = bfin_freq_table[index].frequency;
-
 	freqs.old = bfin_getfreq_khz(0);
-	freqs.new = cclk_hz;
+	freqs.new = bfin_freq_table[index].frequency;
 
 	pr_debug("cpufreq: changing cclk to %lu; target = %u, oldfreq = %u\n",
-			cclk_hz, target_freq, freqs.old);
+			freqs.new, freqs.new, freqs.old);
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 #ifndef CONFIG_BF60x
@@ -210,7 +201,7 @@ static int __bfin_cpu_init(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver bfin_driver = {
 	.verify = cpufreq_generic_frequency_table_verify,
-	.target = bfin_target,
+	.target_index = bfin_target,
 	.get = bfin_getfreq_khz,
 	.init = __bfin_cpu_init,
 	.exit = cpufreq_generic_exit,
-- 
1.7.12.rc2.18.g61b472e

