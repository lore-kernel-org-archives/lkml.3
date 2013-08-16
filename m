Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3HPC1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:27:48 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42407 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab3HPC1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:27:43 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 15/34] cpufreq: imx6q: remove calls to cpufreq_notify_transition()
Date: Fri, 16 Aug 2013 07:55:12 +0530
Message-Id: <91e60ba4e81b89fbdbf2ff495ccfbf8dc7cb6a04.1376619363.git.viresh.kumar@linaro.org>
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

Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/imx6q-cpufreq.c | 39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index 04a32fb..f35c674 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -41,14 +41,14 @@ static unsigned int imx6q_get_speed(unsigned int cpu)
 
 static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	struct cpufreq_freqs freqs;
 	struct opp *opp;
 	unsigned long freq_hz, volt, volt_old;
+	unsigned int old_freq, new_freq;
 	int ret;
 
-	freqs.new = freq_table[index].frequency;
-	freq_hz = freqs.new * 1000;
-	freqs.old = clk_get_rate(arm_clk) / 1000;
+	new_freq = freq_table[index].frequency;
+	freq_hz = new_freq * 1000;
+	old_freq = clk_get_rate(arm_clk) / 1000;
 
 	rcu_read_lock();
 	opp = opp_find_freq_ceil(cpu_dev, &freq_hz);
@@ -63,26 +63,23 @@ static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index)
 	volt_old = regulator_get_voltage(arm_reg);
 
 	dev_dbg(cpu_dev, "%u MHz, %ld mV --> %u MHz, %ld mV\n",
-		freqs.old / 1000, volt_old / 1000,
-		freqs.new / 1000, volt / 1000);
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+		old_freq / 1000, volt_old / 1000,
+		new_freq / 1000, volt / 1000);
 
 	/* scaling up?  scale voltage before frequency */
-	if (freqs.new > freqs.old) {
+	if (new_freq > old_freq) {
 		ret = regulator_set_voltage_tol(arm_reg, volt, 0);
 		if (ret) {
 			dev_err(cpu_dev,
 				"failed to scale vddarm up: %d\n", ret);
-			freqs.new = freqs.old;
-			goto post_notify;
+			return ret;
 		}
 
 		/*
 		 * Need to increase vddpu and vddsoc for safety
 		 * if we are about to run at 1.2 GHz.
 		 */
-		if (freqs.new == FREQ_1P2_GHZ / 1000) {
+		if (new_freq == FREQ_1P2_GHZ / 1000) {
 			regulator_set_voltage_tol(pu_reg,
 					PU_SOC_VOLTAGE_HIGH, 0);
 			regulator_set_voltage_tol(soc_reg,
@@ -103,13 +100,13 @@ static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index)
 	clk_set_parent(step_clk, pll2_pfd2_396m_clk);
 	clk_set_parent(pll1_sw_clk, step_clk);
 	if (freq_hz > clk_get_rate(pll2_pfd2_396m_clk)) {
-		clk_set_rate(pll1_sys_clk, freqs.new * 1000);
+		clk_set_rate(pll1_sys_clk, new_freq * 1000);
 		/*
 		 * If we are leaving 396 MHz set-point, we need to enable
 		 * pll1_sys_clk and disable pll2_pfd2_396m_clk to keep
 		 * their use count correct.
 		 */
-		if (freqs.old * 1000 <= clk_get_rate(pll2_pfd2_396m_clk)) {
+		if (old_freq * 1000 <= clk_get_rate(pll2_pfd2_396m_clk)) {
 			clk_prepare_enable(pll1_sys_clk);
 			clk_disable_unprepare(pll2_pfd2_396m_clk);
 		}
@@ -124,16 +121,15 @@ static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index)
 	}
 
 	/* Ensure the arm clock divider is what we expect */
-	ret = clk_set_rate(arm_clk, freqs.new * 1000);
+	ret = clk_set_rate(arm_clk, new_freq * 1000);
 	if (ret) {
 		dev_err(cpu_dev, "failed to set clock rate: %d\n", ret);
 		regulator_set_voltage_tol(arm_reg, volt_old, 0);
-		freqs.new = freqs.old;
-		goto post_notify;
+		return ret;
 	}
 
 	/* scaling down?  scale voltage after frequency */
-	if (freqs.new < freqs.old) {
+	if (new_freq < old_freq) {
 		ret = regulator_set_voltage_tol(arm_reg, volt, 0);
 		if (ret) {
 			dev_warn(cpu_dev,
@@ -141,7 +137,7 @@ static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index)
 			ret = 0;
 		}
 
-		if (freqs.old == FREQ_1P2_GHZ / 1000) {
+		if (old_freq == FREQ_1P2_GHZ / 1000) {
 			regulator_set_voltage_tol(pu_reg,
 					PU_SOC_VOLTAGE_NORMAL, 0);
 			regulator_set_voltage_tol(soc_reg,
@@ -149,10 +145,7 @@ static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index)
 		}
 	}
 
-post_notify:
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	return ret;
+	return 0;
 }
 
 static int imx6q_cpufreq_init(struct cpufreq_policy *policy)
-- 
1.7.12.rc2.18.g61b472e

