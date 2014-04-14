Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbaDNVKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:10:04 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54761 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755676AbaDNVKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:10:00 -0400
Message-ID: <534C4EA5.3090204@semaphore.gr>
Date: Tue, 15 Apr 2014 00:09:57 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/20] cpufreq: s3c64xx: Use cpufreq_for_each_valid_entry
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
 drivers/cpufreq/s3c64xx-cpufreq.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index ff7d3ec..176e84c 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -118,11 +118,10 @@ static void __init s3c64xx_cpufreq_config_regulator(void)
 		pr_err("Unable to check supported voltages\n");
 	}
 
-	freq = s3c64xx_freq_table;
-	while (count > 0 && freq->frequency != CPUFREQ_TABLE_END) {
-		if (freq->frequency == CPUFREQ_ENTRY_INVALID)
-			continue;
+	if (!count)
+		goto out;
 
+	cpufreq_for_each_valid_entry(freq, s3c64xx_freq_table) {
 		dvfs = &s3c64xx_dvfs_table[freq->driver_data];
 		found = 0;
 
@@ -137,10 +136,9 @@ static void __init s3c64xx_cpufreq_config_regulator(void)
 				 freq->frequency);
 			freq->frequency = CPUFREQ_ENTRY_INVALID;
 		}
-
-		freq++;
 	}
 
+out:
 	/* Guess based on having to do an I2C/SPI write; in future we
 	 * will be able to query the regulator performance here. */
 	regulator_latency = 1 * 1000 * 1000;
@@ -179,8 +177,7 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 	}
 #endif
 
-	freq = s3c64xx_freq_table;
-	while (freq->frequency != CPUFREQ_TABLE_END) {
+	cpufreq_for_each_entry(freq, s3c64xx_freq_table) {
 		unsigned long r;
 
 		/* Check for frequencies we can generate */
@@ -196,8 +193,6 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 		 * frequency is the maximum we can support. */
 		if (!vddarm && freq->frequency > clk_get_rate(policy->clk) / 1000)
 			freq->frequency = CPUFREQ_ENTRY_INVALID;
-
-		freq++;
 	}
 
 	/* Datasheet says PLL stabalisation time (if we were to use
-- 
1.9.0
