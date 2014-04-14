Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbaDNVJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:09:52 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54758 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755676AbaDNVJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:09:47 -0400
Message-ID: <534C4E98.5080302@semaphore.gr>
Date: Tue, 15 Apr 2014 00:09:44 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/20] cpufreq: s3c2416: Use cpufreq_for_each_valid_entry
 macro for iteration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpufreq core supports the cpufreq_for_each_entry and
cpufreq_for_each_valid_entry macros helpers for iteration over the
cpufreq_frequency_table, so use them.

It should have no functional changes.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/s3c2416-cpufreq.c | 40 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/cpufreq/s3c2416-cpufreq.c b/drivers/cpufreq/s3c2416-cpufreq.c
index 4626f90..3fcc7b1 100644
--- a/drivers/cpufreq/s3c2416-cpufreq.c
+++ b/drivers/cpufreq/s3c2416-cpufreq.c
@@ -265,8 +265,8 @@ out:
 #ifdef CONFIG_ARM_S3C2416_CPUFREQ_VCORESCALE
 static void __init s3c2416_cpufreq_cfg_regulator(struct s3c2416_data *s3c_freq)
 {
+	struct cpufreq_frequency_table *pos;
 	int count, v, i, found;
-	struct cpufreq_frequency_table *freq;
 	struct s3c2416_dvfs *dvfs;
 
 	count = regulator_count_voltages(s3c_freq->vddarm);
@@ -275,12 +275,11 @@ static void __init s3c2416_cpufreq_cfg_regulator(struct s3c2416_data *s3c_freq)
 		return;
 	}
 
-	freq = s3c_freq->freq_table;
-	while (count > 0 && freq->frequency != CPUFREQ_TABLE_END) {
-		if (freq->frequency == CPUFREQ_ENTRY_INVALID)
-			continue;
+	if (!count)
+		goto out;
 
-		dvfs = &s3c2416_dvfs_table[freq->driver_data];
+	cpufreq_for_each_valid_entry(pos, s3c_freq->freq_table) {
+		dvfs = &s3c2416_dvfs_table[pos->driver_data];
 		found = 0;
 
 		/* Check only the min-voltage, more is always ok on S3C2416 */
@@ -292,13 +291,12 @@ static void __init s3c2416_cpufreq_cfg_regulator(struct s3c2416_data *s3c_freq)
 
 		if (!found) {
 			pr_debug("cpufreq: %dkHz unsupported by regulator\n",
-				 freq->frequency);
-			freq->frequency = CPUFREQ_ENTRY_INVALID;
+				 pos->frequency);
+			pos->frequency = CPUFREQ_ENTRY_INVALID;
 		}
-
-		freq++;
 	}
 
+out:
 	/* Guessed */
 	s3c_freq->regulator_latency = 1 * 1000 * 1000;
 }
@@ -338,7 +336,7 @@ static struct notifier_block s3c2416_cpufreq_reboot_notifier = {
 static int __init s3c2416_cpufreq_driver_init(struct cpufreq_policy *policy)
 {
 	struct s3c2416_data *s3c_freq = &s3c2416_cpufreq;
-	struct cpufreq_frequency_table *freq;
+	struct cpufreq_frequency_table *pos;
 	struct clk *msysclk;
 	unsigned long rate;
 	int ret;
@@ -427,31 +425,27 @@ static int __init s3c2416_cpufreq_driver_init(struct cpufreq_policy *policy)
 	s3c_freq->regulator_latency = 0;
 #endif
 
-	freq = s3c_freq->freq_table;
-	while (freq->frequency != CPUFREQ_TABLE_END) {
+	cpufreq_for_each_entry(pos, s3c_freq->freq_table) {
 		/* special handling for dvs mode */
-		if (freq->driver_data == 0) {
+		if (pos->driver_data == 0) {
 			if (!s3c_freq->hclk) {
 				pr_debug("cpufreq: %dkHz unsupported as it would need unavailable dvs mode\n",
-					 freq->frequency);
-				freq->frequency = CPUFREQ_ENTRY_INVALID;
+					 pos->frequency);
+				pos->frequency = CPUFREQ_ENTRY_INVALID;
 			} else {
-				freq++;
 				continue;
 			}
 		}
 
 		/* Check for frequencies we can generate */
 		rate = clk_round_rate(s3c_freq->armdiv,
-				      freq->frequency * 1000);
+				      pos->frequency * 1000);
 		rate /= 1000;
-		if (rate != freq->frequency) {
+		if (rate != pos->frequency) {
 			pr_debug("cpufreq: %dkHz unsupported by clock (clk_round_rate return %lu)\n",
-				 freq->frequency, rate);
-			freq->frequency = CPUFREQ_ENTRY_INVALID;
+				pos->frequency, rate);
+			pos->frequency = CPUFREQ_ENTRY_INVALID;
 		}
-
-		freq++;
 	}
 
 	/* Datasheet says PLL stabalisation time must be at least 300us,
-- 
1.9.0
