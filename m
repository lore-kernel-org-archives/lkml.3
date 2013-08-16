Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab3HPC34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:29:56 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:45377 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3HPC3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:29:52 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, spear-devel@list.st.com
Subject: [PATCH 32/34] cpufreq: SPEAr: remove calls to cpufreq_notify_transition()
Date: Fri, 16 Aug 2013 07:55:29 +0530
Message-Id: <8ce6bd268bfae0bba7b6e5f7fa0914c2d1810cb9.1376619363.git.viresh.kumar@linaro.org>
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

Cc: spear-devel@list.st.com
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/spear-cpufreq.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
index efacfa1..4ad35a5 100644
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -107,12 +107,10 @@ static int spear1340_set_cpu_rate(struct clk *sys_pclk, unsigned long newfreq)
 static int spear_cpufreq_target(struct cpufreq_policy *policy,
 		unsigned int index)
 {
-	struct cpufreq_freqs freqs;
 	unsigned long newfreq;
 	struct clk *srcclk;
 	int ret, mult = 1;
 
-	freqs.old = spear_cpufreq_get(0);
 	newfreq = spear_cpufreq.freq_tbl[index].frequency * 1000;
 
 	if (of_machine_is_compatible("st,spear1340")) {
@@ -145,23 +143,14 @@ static int spear_cpufreq_target(struct cpufreq_policy *policy,
 		return newfreq;
 	}
 
-	freqs.new = newfreq / 1000;
-	freqs.new /= mult;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	if (mult == 2)
 		ret = spear1340_set_cpu_rate(srcclk, newfreq);
 	else
 		ret = clk_set_rate(spear_cpufreq.clk, newfreq);
 
-	/* Get current rate after clk_set_rate, in case of failure */
-	if (ret) {
+	if (ret)
 		pr_err("CPU Freq: cpu clk_set_rate failed: %d\n", ret);
-		freqs.new = clk_get_rate(spear_cpufreq.clk) / 1000;
-	}
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 	return ret;
 }
 
-- 
1.7.12.rc2.18.g61b472e

