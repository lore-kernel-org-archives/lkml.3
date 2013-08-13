Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab3HMNfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:35:23 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:51420 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab3HMNfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:35:17 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 17/35] cpufreq: longhaul: Covert to light weight ->target_index() routine
Date: Tue, 13 Aug 2013 19:02:30 +0530
Message-Id: <65691d6e5ef6f37f54774a5f33c30cbe43bed042.1376392602.git.viresh.kumar@linaro.org>
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

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/longhaul.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index 57d7b02..e566776 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -626,21 +626,12 @@ static void longhaul_setup_voltagescaling(void)
 
 
 static int longhaul_target(struct cpufreq_policy *policy,
-			    unsigned int target_freq, unsigned int relation)
+			    unsigned int table_index)
 {
-	unsigned int table_index = 0;
 	unsigned int i;
 	unsigned int dir = 0;
 	u8 vid, current_vid;
 
-	if (cpufreq_frequency_table_target(policy, longhaul_table, target_freq,
-				relation, &table_index))
-		return -EINVAL;
-
-	/* Don't set same frequency again */
-	if (longhaul_index == table_index)
-		return 0;
-
 	if (!can_scale_voltage)
 		longhaul_setstate(policy, table_index);
 	else {
@@ -920,7 +911,7 @@ static int longhaul_cpu_init(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver longhaul_driver = {
 	.verify	= cpufreq_generic_frequency_table_verify,
-	.target	= longhaul_target,
+	.target_index = longhaul_target,
 	.get	= longhaul_get,
 	.init	= longhaul_cpu_init,
 	.exit	= cpufreq_generic_exit,
-- 
1.7.12.rc2.18.g61b472e

