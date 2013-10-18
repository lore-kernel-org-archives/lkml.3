Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3JROEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:04:05 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:58276 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab3JROEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:04:00 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 Resend 30/34] cpufreq: sc520: Convert to light weight ->target_index() routine
Date: Fri, 18 Oct 2013 19:29:53 +0530
Message-Id: <a8a7719e1d1f47cebc23f188bc85d04a0d0ea953.1382104515.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1382104514.git.viresh.kumar@linaro.org>
References: <cover.1382104514.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1382104514.git.viresh.kumar@linaro.org>
References: <cover.1382104514.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts existing .target() to newly defined light weight
.target_index() routine for this driver.

CPUFreq core will call cpufreq_frequency_table_target() before calling this
routine and will pass index to it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/sc520_freq.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/cpufreq/sc520_freq.c b/drivers/cpufreq/sc520_freq.c
index 9047ab1..6c86452 100644
--- a/drivers/cpufreq/sc520_freq.c
+++ b/drivers/cpufreq/sc520_freq.c
@@ -53,8 +53,7 @@ static unsigned int sc520_freq_get_cpu_frequency(unsigned int cpu)
 	}
 }
 
-static void sc520_freq_set_cpu_state(struct cpufreq_policy *policy,
-		unsigned int state)
+static int sc520_freq_target(struct cpufreq_policy *policy, unsigned int state)
 {
 
 	struct cpufreq_freqs	freqs;
@@ -76,24 +75,10 @@ static void sc520_freq_set_cpu_state(struct cpufreq_policy *policy,
 	local_irq_enable();
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-};
-
-static int sc520_freq_target(struct cpufreq_policy *policy,
-			    unsigned int target_freq,
-			    unsigned int relation)
-{
-	unsigned int newstate = 0;
-
-	if (cpufreq_frequency_table_target(policy, sc520_freq_table,
-				target_freq, relation, &newstate))
-		return -EINVAL;
-
-	sc520_freq_set_cpu_state(policy, newstate);
 
 	return 0;
 }
 
-
 /*
  *	Module init and exit code
  */
@@ -117,7 +102,7 @@ static int sc520_freq_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver sc520_freq_driver = {
 	.get	= sc520_freq_get_cpu_frequency,
 	.verify	= cpufreq_generic_frequency_table_verify,
-	.target	= sc520_freq_target,
+	.target_index = sc520_freq_target,
 	.init	= sc520_freq_cpu_init,
 	.exit	= cpufreq_generic_exit,
 	.name	= "sc520_freq",
-- 
1.7.12.rc2.18.g61b472e

