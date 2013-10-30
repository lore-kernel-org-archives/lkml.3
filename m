Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab3J3Ww2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:52:28 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:37549 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab3J3WwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:52:25 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, viresh.kumar@linaro.org
Subject: [PATCH V2 Resend 05/16] cpufreq: dbx500: use cpufreq_generic_get() routine
Date: Thu, 31 Oct 2013 04:22:03 +0530
Message-Id: <956f3793295af6ac2552406ff3b7cf79edc93ae0.1383173230.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1383173230.git.viresh.kumar@linaro.org>
References: <cover.1383173230.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1383173230.git.viresh.kumar@linaro.org>
References: <cover.1383173230.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have common infrastructure available with us for getting a CPUs clk rate.
Lets use it for this driver.

We don't have to find closest frequency in platform specific ->get() routine
wihch dbx500 driver was doing and hence it can be removed as well.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/dbx500-cpufreq.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/cpufreq/dbx500-cpufreq.c b/drivers/cpufreq/dbx500-cpufreq.c
index 0e67ab9..d83129d 100644
--- a/drivers/cpufreq/dbx500-cpufreq.c
+++ b/drivers/cpufreq/dbx500-cpufreq.c
@@ -26,24 +26,9 @@ static int dbx500_cpufreq_target(struct cpufreq_policy *policy,
 	return clk_set_rate(armss_clk, freq_table[index].frequency * 1000);
 }
 
-static unsigned int dbx500_cpufreq_getspeed(unsigned int cpu)
-{
-	int i = 0;
-	unsigned long freq = clk_get_rate(armss_clk) / 1000;
-
-	/* The value is rounded to closest frequency in the defined table. */
-	while (freq_table[i + 1].frequency != CPUFREQ_TABLE_END) {
-		if (freq < freq_table[i].frequency +
-		   (freq_table[i + 1].frequency - freq_table[i].frequency) / 2)
-			return freq_table[i].frequency;
-		i++;
-	}
-
-	return freq_table[i].frequency;
-}
-
 static int dbx500_cpufreq_init(struct cpufreq_policy *policy)
 {
+	policy->clk = armss_clk;
 	return cpufreq_generic_init(policy, freq_table, 20 * 1000);
 }
 
@@ -51,7 +36,7 @@ static struct cpufreq_driver dbx500_cpufreq_driver = {
 	.flags  = CPUFREQ_STICKY | CPUFREQ_CONST_LOOPS,
 	.verify = cpufreq_generic_frequency_table_verify,
 	.target_index = dbx500_cpufreq_target,
-	.get    = dbx500_cpufreq_getspeed,
+	.get    = cpufreq_generic_get,
 	.init   = dbx500_cpufreq_init,
 	.name   = "DBX500",
 	.attr   = cpufreq_generic_attr,
-- 
1.7.12.rc2.18.g61b472e

