Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3HPC3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:29:24 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:64193 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab3HPC3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:29:20 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 28/34] cpufreq: s5pv210: remove calls to cpufreq_notify_transition()
Date: Fri, 16 Aug 2013 07:55:25 +0530
Message-Id: <18ddada60c1c5b96c6771eb6047a4d5703d3a136.1376619363.git.viresh.kumar@linaro.org>
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

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/s5pv210-cpufreq.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index 76a4177..efa1080 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -26,7 +26,6 @@
 static struct clk *cpu_clk;
 static struct clk *dmc0_clk;
 static struct clk *dmc1_clk;
-static struct cpufreq_freqs freqs;
 static DEFINE_MUTEX(set_freq_lock);
 
 /* APLL M,P,S values for 1G/800Mhz */
@@ -179,6 +178,7 @@ static int s5pv210_target(struct cpufreq_policy *policy, unsigned int index)
 	unsigned int priv_index;
 	unsigned int pll_changing = 0;
 	unsigned int bus_speed_changing = 0;
+	unsigned int old_freq, new_freq;
 	int arm_volt, int_volt;
 	int ret = 0;
 
@@ -193,12 +193,12 @@ static int s5pv210_target(struct cpufreq_policy *policy, unsigned int index)
 		goto exit;
 	}
 
-	freqs.old = s5pv210_getspeed(0);
-	freqs.new = s5pv210_freq_table[index].frequency;
+	old_freq = s5pv210_getspeed(0);
+	new_freq = s5pv210_freq_table[index].frequency;
 
 	/* Finding current running level index */
 	if (cpufreq_frequency_table_target(policy, s5pv210_freq_table,
-					   freqs.old, CPUFREQ_RELATION_H,
+					   old_freq, CPUFREQ_RELATION_H,
 					   &priv_index)) {
 		ret = -EINVAL;
 		goto exit;
@@ -207,7 +207,7 @@ static int s5pv210_target(struct cpufreq_policy *policy, unsigned int index)
 	arm_volt = dvs_conf[index].arm_volt;
 	int_volt = dvs_conf[index].int_volt;
 
-	if (freqs.new > freqs.old) {
+	if (new_freq > old_freq) {
 		ret = regulator_set_voltage(arm_regulator,
 				arm_volt, arm_volt_max);
 		if (ret)
@@ -219,8 +219,6 @@ static int s5pv210_target(struct cpufreq_policy *policy, unsigned int index)
 			goto exit;
 	}
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	/* Check if there need to change PLL */
 	if ((index == L0) || (priv_index == L0))
 		pll_changing = 1;
@@ -431,9 +429,7 @@ static int s5pv210_target(struct cpufreq_policy *policy, unsigned int index)
 		}
 	}
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	if (freqs.new < freqs.old) {
+	if (new_freq < old_freq) {
 		regulator_set_voltage(int_regulator,
 				int_volt, int_volt_max);
 
-- 
1.7.12.rc2.18.g61b472e

