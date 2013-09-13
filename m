Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938Ab3IMNWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:22:07 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:50579 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933884Ab3IMNWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:22:00 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 161/228] cpufreq: kirkwood: Convert to light weight ->target_index() routine
Date: Fri, 13 Sep 2013 18:31:47 +0530
Message-Id: <c08916667ab7341dd746ef2d1292ef960b6a5bfd.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts existing .target() to newly defined light weight
.target_index() routine for this driver.

CPUFreq core will call cpufreq_frequency_table_target() before calling this
routine and will pass index to it.

Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/kirkwood-cpufreq.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
index fff8653..0ae4dd7 100644
--- a/drivers/cpufreq/kirkwood-cpufreq.c
+++ b/drivers/cpufreq/kirkwood-cpufreq.c
@@ -55,8 +55,8 @@ static unsigned int kirkwood_cpufreq_get_cpu_frequency(unsigned int cpu)
 	return kirkwood_freq_table[0].frequency;
 }
 
-static void kirkwood_cpufreq_set_cpu_state(struct cpufreq_policy *policy,
-		unsigned int index)
+static int kirkwood_cpufreq_target(struct cpufreq_policy *policy,
+			    unsigned int index)
 {
 	struct cpufreq_freqs freqs;
 	unsigned int state = kirkwood_freq_table[index].driver_data;
@@ -100,19 +100,6 @@ static void kirkwood_cpufreq_set_cpu_state(struct cpufreq_policy *policy,
 		local_irq_enable();
 	}
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-};
-
-static int kirkwood_cpufreq_target(struct cpufreq_policy *policy,
-			    unsigned int target_freq,
-			    unsigned int relation)
-{
-	unsigned int index = 0;
-
-	if (cpufreq_frequency_table_target(policy, kirkwood_freq_table,
-				target_freq, relation, &index))
-		return -EINVAL;
-
-	kirkwood_cpufreq_set_cpu_state(policy, index);
 
 	return 0;
 }
@@ -126,7 +113,7 @@ static int kirkwood_cpufreq_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver kirkwood_cpufreq_driver = {
 	.get	= kirkwood_cpufreq_get_cpu_frequency,
 	.verify	= cpufreq_generic_frequency_table_verify,
-	.target	= kirkwood_cpufreq_target,
+	.target_index = kirkwood_cpufreq_target,
 	.init	= kirkwood_cpufreq_cpu_init,
 	.exit	= cpufreq_generic_exit,
 	.name	= "kirkwood-cpufreq",
-- 
1.7.12.rc2.18.g61b472e

