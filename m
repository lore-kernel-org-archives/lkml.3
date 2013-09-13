Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934169Ab3IMNZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:25:19 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:52743 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934155Ab3IMNZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:25:09 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 186/228] cpufreq: cpu0: remove calls to cpufreq_notify_transition()
Date: Fri, 13 Sep 2013 18:32:12 +0530
Message-Id: <1c07e89f6741b395cd10368b94d4afce9047c447.1379063063.git.viresh.kumar@linaro.org>
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

Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 22a358f..7b5547f 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -36,20 +36,19 @@ static unsigned int cpu0_get_speed(unsigned int cpu)
 
 static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	struct cpufreq_freqs freqs;
 	struct opp *opp;
 	unsigned long volt = 0, volt_old = 0, tol = 0;
+	unsigned int old_freq, new_freq;
 	long freq_Hz, freq_exact;
 	int ret;
 
 	freq_Hz = clk_round_rate(cpu_clk, freq_table[index].frequency * 1000);
 	if (freq_Hz < 0)
 		freq_Hz = freq_table[index].frequency * 1000;
-	freq_exact = freq_Hz;
-	freqs.new = freq_Hz / 1000;
-	freqs.old = clk_get_rate(cpu_clk) / 1000;
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+	freq_exact = freq_Hz;
+	new_freq = freq_Hz / 1000;
+	old_freq = clk_get_rate(cpu_clk) / 1000;
 
 	if (!IS_ERR(cpu_reg)) {
 		rcu_read_lock();
@@ -57,9 +56,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 		if (IS_ERR(opp)) {
 			rcu_read_unlock();
 			pr_err("failed to find OPP for %ld\n", freq_Hz);
-			freqs.new = freqs.old;
-			ret = PTR_ERR(opp);
-			goto post_notify;
+			return PTR_ERR(opp);
 		}
 		volt = opp_get_voltage(opp);
 		rcu_read_unlock();
@@ -68,16 +65,15 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 	}
 
 	pr_debug("%u MHz, %ld mV --> %u MHz, %ld mV\n",
-		 freqs.old / 1000, volt_old ? volt_old / 1000 : -1,
-		 freqs.new / 1000, volt ? volt / 1000 : -1);
+		 old_freq / 1000, volt_old ? volt_old / 1000 : -1,
+		 new_freq / 1000, volt ? volt / 1000 : -1);
 
 	/* scaling up?  scale voltage before frequency */
-	if (!IS_ERR(cpu_reg) && freqs.new > freqs.old) {
+	if (!IS_ERR(cpu_reg) && new_freq > old_freq) {
 		ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
 		if (ret) {
 			pr_err("failed to scale voltage up: %d\n", ret);
-			freqs.new = freqs.old;
-			goto post_notify;
+			return ret;
 		}
 	}
 
@@ -86,23 +82,18 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 		pr_err("failed to set clock rate: %d\n", ret);
 		if (!IS_ERR(cpu_reg))
 			regulator_set_voltage_tol(cpu_reg, volt_old, tol);
-		freqs.new = freqs.old;
-		goto post_notify;
+		return ret;
 	}
 
 	/* scaling down?  scale voltage after frequency */
-	if (!IS_ERR(cpu_reg) && freqs.new < freqs.old) {
+	if (!IS_ERR(cpu_reg) && new_freq < old_freq) {
 		ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
 		if (ret) {
 			pr_err("failed to scale voltage down: %d\n", ret);
-			clk_set_rate(cpu_clk, freqs.old * 1000);
-			freqs.new = freqs.old;
+			clk_set_rate(cpu_clk, old_freq * 1000);
 		}
 	}
 
-post_notify:
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	return ret;
 }
 
-- 
1.7.12.rc2.18.g61b472e

