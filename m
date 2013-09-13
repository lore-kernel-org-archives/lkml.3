Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab3IMNIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:08:41 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35541 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421Ab3IMNIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:08:36 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 047/228] cpufreq: at32ap: add frequency table
Date: Fri, 13 Sep 2013 18:29:53 +0530
Message-Id: <3a35746ef433eb30448302efe2c610c14b7feeca.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans-Christian Egtvedt <egtvedt@samfundet.no>

This patch adds a dynamically calculated frequency table to the at32ap driver.
In short the architecture can scale in power of two between a maximum and
minimum frequency. Min, max, and the steps in between are added to the table.

Signed-off-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/at32ap-cpufreq.c | 49 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/at32ap-cpufreq.c b/drivers/cpufreq/at32ap-cpufreq.c
index e0c38d9..1d19fa5 100644
--- a/drivers/cpufreq/at32ap-cpufreq.c
+++ b/drivers/cpufreq/at32ap-cpufreq.c
@@ -19,8 +19,10 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/export.h>
+#include <linux/slab.h>
 
 static struct clk *cpuclk;
+static struct cpufreq_frequency_table *freq_table;
 
 static int at32_verify_speed(struct cpufreq_policy *policy)
 {
@@ -85,13 +87,17 @@ static int at32_set_target(struct cpufreq_policy *policy,
 
 static int __init at32_cpufreq_driver_init(struct cpufreq_policy *policy)
 {
+	unsigned int frequency, rate;
+	int retval, steps, i;
+
 	if (policy->cpu != 0)
 		return -EINVAL;
 
 	cpuclk = clk_get(NULL, "cpu");
 	if (IS_ERR(cpuclk)) {
 		pr_debug("cpufreq: could not get CPU clk\n");
-		return PTR_ERR(cpuclk);
+		retval = PTR_ERR(cpuclk);
+		goto out_err;
 	}
 
 	policy->cpuinfo.min_freq = (clk_round_rate(cpuclk, 1) + 500) / 1000;
@@ -101,9 +107,46 @@ static int __init at32_cpufreq_driver_init(struct cpufreq_policy *policy)
 	policy->min = policy->cpuinfo.min_freq;
 	policy->max = policy->cpuinfo.max_freq;
 
-	printk("cpufreq: AT32AP CPU frequency driver\n");
+	/*
+	 * AVR32 CPU frequency rate scales in power of two between maximum and
+	 * minimum, also add space for the table end marker.
+	 *
+	 * Further validate that the frequency is usable, and append it to the
+	 * frequency table.
+	 */
+	steps = fls(policy->cpuinfo.max_freq / policy->cpuinfo.min_freq) + 1;
+	freq_table = kzalloc(steps * sizeof(struct cpufreq_frequency_table),
+			GFP_KERNEL);
+	if (!freq_table) {
+		retval = -ENOMEM;
+		goto out_err_put_clk;
+	}
 
-	return 0;
+	frequency = policy->cpuinfo.max_freq;
+	for (i = 0; i < (steps - 1); i++) {
+		rate = clk_round_rate(cpuclk, frequency * 1000) / 1000;
+
+		if (rate != frequency)
+			freq_table[i].frequency = CPUFREQ_ENTRY_INVALID;
+		else
+			freq_table[i].frequency = frequency;
+
+		frequency /= 2;
+	}
+
+	freq_table[steps - 1].frequency = CPUFREQ_TABLE_END;
+
+	retval = cpufreq_table_validate_and_show(policy, freq_table);
+	if (!retval) {
+		printk("cpufreq: AT32AP CPU frequency driver\n");
+		return 0;
+	}
+
+	kfree(freq_table);
+out_err_put_clk:
+	clk_put(cpuclk);
+out_err:
+	return retval;
 }
 
 static struct cpufreq_driver at32_driver = {
-- 
1.7.12.rc2.18.g61b472e

