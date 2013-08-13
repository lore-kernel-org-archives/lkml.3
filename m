Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab3HMNeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:34:12 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58326 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758094Ab3HMNeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:34:08 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Mikael Starvik <starvik@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH V2 08/35] cpufreq: cris: Covert to light weight ->target_index() routine
Date: Tue, 13 Aug 2013 19:02:21 +0530
Message-Id: <2365125b0f67c5a11f5efb8a493cb782c3a599ab.1376392602.git.viresh.kumar@linaro.org>
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

Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: linux-cris-kernel@axis.com
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cris-artpec3-cpufreq.c | 18 ++----------------
 drivers/cpufreq/cris-etraxfs-cpufreq.c | 17 ++---------------
 2 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/drivers/cpufreq/cris-artpec3-cpufreq.c b/drivers/cpufreq/cris-artpec3-cpufreq.c
index d26f4e4..1488277 100644
--- a/drivers/cpufreq/cris-artpec3-cpufreq.c
+++ b/drivers/cpufreq/cris-artpec3-cpufreq.c
@@ -27,8 +27,7 @@ static unsigned int cris_freq_get_cpu_frequency(unsigned int cpu)
 	return clk_ctrl.pll ? 200000 : 6000;
 }
 
-static void cris_freq_set_cpu_state(struct cpufreq_policy *policy,
-		unsigned int state)
+static int cris_freq_target(struct cpufreq_policy *policy, unsigned int state)
 {
 	struct cpufreq_freqs freqs;
 	reg_clkgen_rw_clk_ctrl clk_ctrl;
@@ -52,19 +51,6 @@ static void cris_freq_set_cpu_state(struct cpufreq_policy *policy,
 	local_irq_enable();
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-};
-
-static int cris_freq_target(struct cpufreq_policy *policy,
-			    unsigned int target_freq,
-			    unsigned int relation)
-{
-	unsigned int newstate = 0;
-
-	if (cpufreq_frequency_table_target(policy, cris_freq_table,
-			target_freq, relation, &newstate))
-		return -EINVAL;
-
-	cris_freq_set_cpu_state(policy, newstate);
 
 	return 0;
 }
@@ -82,7 +68,7 @@ static int cris_freq_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver cris_freq_driver = {
 	.get	= cris_freq_get_cpu_frequency,
 	.verify	= cpufreq_generic_frequency_table_verify,
-	.target	= cris_freq_target,
+	.target_index = cris_freq_target,
 	.init	= cris_freq_cpu_init,
 	.exit	= cpufreq_generic_exit,
 	.name	= "cris_freq",
diff --git a/drivers/cpufreq/cris-etraxfs-cpufreq.c b/drivers/cpufreq/cris-etraxfs-cpufreq.c
index d384e63..4e3e9c7 100644
--- a/drivers/cpufreq/cris-etraxfs-cpufreq.c
+++ b/drivers/cpufreq/cris-etraxfs-cpufreq.c
@@ -27,8 +27,7 @@ static unsigned int cris_freq_get_cpu_frequency(unsigned int cpu)
 	return clk_ctrl.pll ? 200000 : 6000;
 }
 
-static void cris_freq_set_cpu_state(struct cpufreq_policy *policy,
-		unsigned int state)
+static int cris_freq_target(struct cpufreq_policy *policy, unsigned int state)
 {
 	struct cpufreq_freqs freqs;
 	reg_config_rw_clk_ctrl clk_ctrl;
@@ -52,18 +51,6 @@ static void cris_freq_set_cpu_state(struct cpufreq_policy *policy,
 	local_irq_enable();
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-};
-
-static int cris_freq_target(struct cpufreq_policy *policy,
-			    unsigned int target_freq, unsigned int relation)
-{
-	unsigned int newstate = 0;
-
-	if (cpufreq_frequency_table_target
-	    (policy, cris_freq_table, target_freq, relation, &newstate))
-		return -EINVAL;
-
-	cris_freq_set_cpu_state(policy, newstate);
 
 	return 0;
 }
@@ -80,7 +67,7 @@ static int cris_freq_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver cris_freq_driver = {
 	.get = cris_freq_get_cpu_frequency,
 	.verify = cpufreq_generic_frequency_table_verify,
-	.target = cris_freq_target,
+	.target_index = cris_freq_target,
 	.init = cris_freq_cpu_init,
 	.exit = cpufreq_generic_exit,
 	.name = "cris_freq",
-- 
1.7.12.rc2.18.g61b472e

