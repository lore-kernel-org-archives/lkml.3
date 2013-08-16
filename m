Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3HPC0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:26:55 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:44984 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab3HPC0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:26:51 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, Sekhar Nori <nsekhar@ti.com>
Subject: [PATCH 08/34] cpufreq: davinci: remove calls to cpufreq_notify_transition()
Date: Fri, 16 Aug 2013 07:55:05 +0530
Message-Id: <afcf37938eb552cccba058f414cd900ee585bc0a.1376619363.git.viresh.kumar@linaro.org>
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

Cc: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/davinci-cpufreq.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/cpufreq/davinci-cpufreq.c b/drivers/cpufreq/davinci-cpufreq.c
index 07ea6c0..7fcae0c 100644
--- a/drivers/cpufreq/davinci-cpufreq.c
+++ b/drivers/cpufreq/davinci-cpufreq.c
@@ -70,46 +70,36 @@ static unsigned int davinci_getspeed(unsigned int cpu)
 
 static int davinci_target(struct cpufreq_policy *policy, unsigned int idx)
 {
-	int ret = 0;
-	struct cpufreq_freqs freqs;
 	struct davinci_cpufreq_config *pdata = cpufreq.dev->platform_data;
 	struct clk *armclk = cpufreq.armclk;
+	unsigned int old_freq, new_freq;
+	int ret = 0;
 
-	freqs.old = davinci_getspeed(0);
-	freqs.new = pdata->freq_table[idx].frequency;
-
-	dev_dbg(cpufreq.dev, "transition: %u --> %u\n", freqs.old, freqs.new);
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+	old_freq = davinci_getspeed(0);
+	new_freq = pdata->freq_table[idx].frequency;
 
 	/* if moving to higher frequency, up the voltage beforehand */
-	if (pdata->set_voltage && freqs.new > freqs.old) {
+	if (pdata->set_voltage && new_freq > old_freq) {
 		ret = pdata->set_voltage(idx);
 		if (ret)
-			goto out;
+			return ret;
 	}
 
 	ret = clk_set_rate(armclk, idx);
 	if (ret)
-		goto out;
+		return ret;
 
 	if (cpufreq.asyncclk) {
 		ret = clk_set_rate(cpufreq.asyncclk, cpufreq.asyncrate);
 		if (ret)
-			goto out;
+			return ret;
 	}
 
 	/* if moving to lower freq, lower the voltage after lowering freq */
-	if (pdata->set_voltage && freqs.new < freqs.old)
+	if (pdata->set_voltage && new_freq < old_freq)
 		pdata->set_voltage(idx);
 
-out:
-	if (ret)
-		freqs.new = freqs.old;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	return ret;
+	return 0;
 }
 
 static int davinci_cpu_init(struct cpufreq_policy *policy)
-- 
1.7.12.rc2.18.g61b472e

