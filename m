Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3HPCaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:30:12 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50349 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab3HPCaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:30:09 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 34/34] cpufreq: tegra: remove calls to cpufreq_notify_transition()
Date: Fri, 16 Aug 2013 07:55:31 +0530
Message-Id: <ed605b862dbdea6f40edcd104c88ab909be1381f.1376619363.git.viresh.kumar@linaro.org>
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

Cc: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/tegra-cpufreq.c | 25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index 3c2b12b..b376b67 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -102,12 +102,8 @@ static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
 		unsigned long rate)
 {
 	int ret = 0;
-	struct cpufreq_freqs freqs;
 
-	freqs.old = tegra_getspeed(0);
-	freqs.new = rate;
-
-	if (freqs.old == freqs.new)
+	if (tegra_getspeed(0) == rate)
 		return ret;
 
 	/*
@@ -121,21 +117,10 @@ static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
 	else
 		clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
-#ifdef CONFIG_CPU_FREQ_DEBUG
-	printk(KERN_DEBUG "cpufreq-tegra: transition: %u --> %u\n",
-	       freqs.old, freqs.new);
-#endif
-
-	ret = tegra_cpu_clk_set_rate(freqs.new * 1000);
-	if (ret) {
-		pr_err("cpu-tegra: Failed to set cpu frequency to %d kHz\n",
-			freqs.new);
-		freqs.new = freqs.old;
-	}
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	ret = tegra_cpu_clk_set_rate(rate * 1000);
+	if (ret)
+		pr_err("cpu-tegra: Failed to set cpu frequency to %lu kHz\n",
+			rate);
 
 	return ret;
 }
-- 
1.7.12.rc2.18.g61b472e

