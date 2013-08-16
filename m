Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab3HPC0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:26:33 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:47468 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab3HPC02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:26:28 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Steven Miao <realmz6@gmail.com>
Subject: [PATCH 05/34] cpufreq: blackfin: remove calls to cpufreq_notify_transition()
Date: Fri, 16 Aug 2013 07:55:02 +0530
Message-Id: <f2d1c020e86a1b95fa38eab1d127bb9645e01b3c.1376619363.git.viresh.kumar@linaro.org>
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

Cc: Steven Miao <realmz6@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/blackfin-cpufreq.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/cpufreq/blackfin-cpufreq.c b/drivers/cpufreq/blackfin-cpufreq.c
index 12528b2..e9e63fc 100644
--- a/drivers/cpufreq/blackfin-cpufreq.c
+++ b/drivers/cpufreq/blackfin-cpufreq.c
@@ -132,27 +132,23 @@ static int bfin_target(struct cpufreq_policy *policy, unsigned int index)
 #ifndef CONFIG_BF60x
 	unsigned int plldiv;
 #endif
-	struct cpufreq_freqs freqs;
 	static unsigned long lpj_ref;
 	static unsigned int  lpj_ref_freq;
+	unsigned int old_freq, new_freq;
 	int ret = 0;
 
 #if defined(CONFIG_CYCLES_CLOCKSOURCE)
 	cycles_t cycles;
 #endif
 
-	freqs.old = bfin_getfreq_khz(0);
-	freqs.new = bfin_freq_table[index].frequency;
+	old_freq = bfin_getfreq_khz(0);
+	new_freq = bfin_freq_table[index].frequency;
 
-	pr_debug("cpufreq: changing cclk to %lu; target = %u, oldfreq = %u\n",
-			freqs.new, freqs.new, freqs.old);
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 #ifndef CONFIG_BF60x
 	plldiv = (bfin_read_PLL_DIV() & SSEL) | dpm_state_table[index].csel;
 	bfin_write_PLL_DIV(plldiv);
 #else
-	ret = cpu_set_cclk(policy->cpu, freqs.new * 1000);
+	ret = cpu_set_cclk(policy->cpu, new_freq * 1000);
 	if (ret != 0) {
 		WARN_ONCE(ret, "cpufreq set freq failed %d\n", ret);
 		return ret;
@@ -168,17 +164,13 @@ static int bfin_target(struct cpufreq_policy *policy, unsigned int index)
 #endif
 	if (!lpj_ref_freq) {
 		lpj_ref = loops_per_jiffy;
-		lpj_ref_freq = freqs.old;
+		lpj_ref_freq = old_freq;
 	}
-	if (freqs.new != freqs.old) {
+	if (new_freq != old_freq) {
 		loops_per_jiffy = cpufreq_scale(lpj_ref,
-				lpj_ref_freq, freqs.new);
+				lpj_ref_freq, new_freq);
 	}
 
-	/* TODO: just test case for cycles clock source, remove later */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	pr_debug("cpufreq: done\n");
 	return ret;
 }
 
-- 
1.7.12.rc2.18.g61b472e

