Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934283Ab3IMN01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:26:27 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:58960 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934296Ab3IMN0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:26:21 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        John Crispin <blogic@openwrt.org>
Subject: [PATCH 196/228] cpufreq: loongson2: remove calls to cpufreq_notify_transition()
Date: Fri, 13 Sep 2013 18:32:22 +0530
Message-Id: <c1bf7fd24b713d4f10488c177157556ff6adceac.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
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

Cc: John Crispin <blogic@openwrt.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/loongson2_cpufreq.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
index 41a8e2c..a436092 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -57,7 +57,6 @@ static int loongson2_cpufreq_target(struct cpufreq_policy *policy,
 {
 	unsigned int cpu = policy->cpu;
 	cpumask_t cpus_allowed;
-	struct cpufreq_freqs freqs;
 	unsigned int freq;
 
 	cpus_allowed = current->cpus_allowed;
@@ -67,26 +66,11 @@ static int loongson2_cpufreq_target(struct cpufreq_policy *policy,
 	    ((cpu_clock_freq / 1000) *
 	     loongson2_clockmod_table[index].driver_data) / 8;
 
-	pr_debug("cpufreq: requested frequency %u Hz\n",
-			loongson2_clockmod_table[index].frequency * 1000);
-
-	freqs.old = loongson2_cpufreq_get(cpu);
-	freqs.new = freq;
-	freqs.flags = 0;
-
-	/* notifiers */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	set_cpus_allowed_ptr(current, &cpus_allowed);
 
 	/* setting the cpu frequency */
 	clk_set_rate(cpuclk, freq);
 
-	/* notifiers */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	pr_debug("cpufreq: set frequency %u kHz\n", freq);
-
 	return 0;
 }
 
-- 
1.7.12.rc2.18.g61b472e

