Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab3HPC3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:29:12 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:46770 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab3HPC3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:29:05 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH 26/34] cpufreq: pxa: remove calls to cpufreq_notify_transition()
Date: Fri, 16 Aug 2013 07:55:23 +0530
Message-Id: <28fce5fee42ed283ec0d176c2e7be41e4eca79a4.1376619363.git.viresh.kumar@linaro.org>
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

Cc: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/pxa2xx-cpufreq.c | 27 ++++++---------------------
 drivers/cpufreq/pxa3xx-cpufreq.c | 12 ------------
 2 files changed, 6 insertions(+), 33 deletions(-)

diff --git a/drivers/cpufreq/pxa2xx-cpufreq.c b/drivers/cpufreq/pxa2xx-cpufreq.c
index 183bc13..0a0f436 100644
--- a/drivers/cpufreq/pxa2xx-cpufreq.c
+++ b/drivers/cpufreq/pxa2xx-cpufreq.c
@@ -271,7 +271,6 @@ static int pxa_set_target(struct cpufreq_policy *policy, unsigned int idx)
 {
 	struct cpufreq_frequency_table *pxa_freqs_table;
 	pxa_freqs_t *pxa_freq_settings;
-	struct cpufreq_freqs freqs;
 	unsigned long flags;
 	unsigned int new_freq_cpu, new_freq_mem;
 	unsigned int unused, preset_mdrefr, postset_mdrefr, cclkcfg;
@@ -282,24 +281,17 @@ static int pxa_set_target(struct cpufreq_policy *policy, unsigned int idx)
 
 	new_freq_cpu = pxa_freq_settings[idx].khz;
 	new_freq_mem = pxa_freq_settings[idx].membus;
-	freqs.old = policy->cur;
-	freqs.new = new_freq_cpu;
 
 	if (freq_debug)
 		pr_debug("Changing CPU frequency to %d Mhz, (SDRAM %d Mhz)\n",
-			 freqs.new / 1000, (pxa_freq_settings[idx].div2) ?
+			 new_freq_cpu / 1000, (pxa_freq_settings[idx].div2) ?
 			 (new_freq_mem / 2000) : (new_freq_mem / 1000));
 
-	if (vcc_core && freqs.new > freqs.old)
+	if (vcc_core && new_freq_cpu > policy->cur) {
 		ret = pxa_cpufreq_change_voltage(&pxa_freq_settings[idx]);
-	if (ret)
-		return ret;
-	/*
-	 * Tell everyone what we're about to do...
-	 * you should add a notify client with any platform specific
-	 * Vcc changing capability
-	 */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+		if (ret)
+			return ret;
+	}
 
 	/* Calculate the next MDREFR.  If we're slowing down the SDRAM clock
 	 * we need to preset the smaller DRI before the change.	 If we're
@@ -350,13 +342,6 @@ static int pxa_set_target(struct cpufreq_policy *policy, unsigned int idx)
 	local_irq_restore(flags);
 
 	/*
-	 * Tell everyone what we've just done...
-	 * you should add a notify client with any platform specific
-	 * SDRAM refresh timer adjustments
-	 */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	/*
 	 * Even if voltage setting fails, we don't report it, as the frequency
 	 * change succeeded. The voltage reduction is not a critical failure,
 	 * only power savings will suffer from this.
@@ -365,7 +350,7 @@ static int pxa_set_target(struct cpufreq_policy *policy, unsigned int idx)
 	 * bug is triggered (seems a deadlock). Should anybody find out where,
 	 * the "return 0" should become a "return ret".
 	 */
-	if (vcc_core && freqs.new < freqs.old)
+	if (vcc_core && new_freq_cpu < policy->cur)
 		ret = pxa_cpufreq_change_voltage(&pxa_freq_settings[idx]);
 
 	return 0;
diff --git a/drivers/cpufreq/pxa3xx-cpufreq.c b/drivers/cpufreq/pxa3xx-cpufreq.c
index 132e37d..9384004 100644
--- a/drivers/cpufreq/pxa3xx-cpufreq.c
+++ b/drivers/cpufreq/pxa3xx-cpufreq.c
@@ -158,7 +158,6 @@ static unsigned int pxa3xx_cpufreq_get(unsigned int cpu)
 static int pxa3xx_cpufreq_set(struct cpufreq_policy *policy, unsigned int index)
 {
 	struct pxa3xx_freq_info *next;
-	struct cpufreq_freqs freqs;
 	unsigned long flags;
 
 	if (policy->cpu != 0)
@@ -166,22 +165,11 @@ static int pxa3xx_cpufreq_set(struct cpufreq_policy *policy, unsigned int index)
 
 	next = &pxa3xx_freqs[index];
 
-	freqs.old = policy->cur;
-	freqs.new = next->cpufreq_mhz * 1000;
-
-	pr_debug("CPU frequency from %d MHz to %d MHz%s\n",
-			freqs.old / 1000, freqs.new / 1000,
-			(freqs.old == freqs.new) ? " (skipped)" : "");
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	local_irq_save(flags);
 	__update_core_freq(next);
 	__update_bus_freq(next);
 	local_irq_restore(flags);
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	return 0;
 }
 
-- 
1.7.12.rc2.18.g61b472e

