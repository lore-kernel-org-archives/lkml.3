Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3HPC02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:26:28 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:43144 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab3HPC0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:26:21 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH 04/34] cpufreq: at32ap: remove calls to cpufreq_notify_transition()
Date: Fri, 16 Aug 2013 07:55:01 +0530
Message-Id: <1507bf552f7f9f61197c599236be870e739b337c.1376619363.git.viresh.kumar@linaro.org>
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

Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/at32ap-cpufreq.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/at32ap-cpufreq.c b/drivers/cpufreq/at32ap-cpufreq.c
index 81d0752..856ad80 100644
--- a/drivers/cpufreq/at32ap-cpufreq.c
+++ b/drivers/cpufreq/at32ap-cpufreq.c
@@ -37,27 +37,23 @@ static unsigned long	loops_per_jiffy_ref;
 
 static int at32_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	struct cpufreq_freqs freqs;
+	unsigned int old_freq, new_freq;
 
-	freqs.old = at32_get_speed(0);
-	freqs.new = freq_table[index].frequency;
+	old_freq = at32_get_speed(0);
+	new_freq = freq_table[index].frequency;
 
 	if (!ref_freq) {
-		ref_freq = freqs.old;
+		ref_freq = old_freq;
 		loops_per_jiffy_ref = boot_cpu_data.loops_per_jiffy;
 	}
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-	if (freqs.old < freqs.new)
+	if (old_freq < new_freq)
 		boot_cpu_data.loops_per_jiffy = cpufreq_scale(
-				loops_per_jiffy_ref, ref_freq, freqs.new);
-	clk_set_rate(cpuclk, freqs.new * 1000);
-	if (freqs.new < freqs.old)
+				loops_per_jiffy_ref, ref_freq, new_freq);
+	clk_set_rate(cpuclk, new_freq * 1000);
+	if (new_freq < old_freq)
 		boot_cpu_data.loops_per_jiffy = cpufreq_scale(
-				loops_per_jiffy_ref, ref_freq, freqs.new);
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	pr_debug("cpufreq: set frequency %u Hz\n", freqs.new * 1000);
+				loops_per_jiffy_ref, ref_freq, new_freq);
 
 	return 0;
 }
-- 
1.7.12.rc2.18.g61b472e

