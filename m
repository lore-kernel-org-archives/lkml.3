Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab3IMN1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:27:46 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40884 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815Ab3IMN1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:27:40 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 207/228] cpufreq: sc520: remove calls to cpufreq_notify_transition()
Date: Fri, 13 Sep 2013 18:32:33 +0530
Message-Id: <fabe8375c86b98b72611fe237ff0884c0d1135d9.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
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

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/sc520_freq.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/cpufreq/sc520_freq.c b/drivers/cpufreq/sc520_freq.c
index 6c86452..6adb354 100644
--- a/drivers/cpufreq/sc520_freq.c
+++ b/drivers/cpufreq/sc520_freq.c
@@ -56,17 +56,8 @@ static unsigned int sc520_freq_get_cpu_frequency(unsigned int cpu)
 static int sc520_freq_target(struct cpufreq_policy *policy, unsigned int state)
 {
 
-	struct cpufreq_freqs	freqs;
 	u8 clockspeed_reg;
 
-	freqs.old = sc520_freq_get_cpu_frequency(0);
-	freqs.new = sc520_freq_table[state].frequency;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
-	pr_debug("attempting to set frequency to %i kHz\n",
-			sc520_freq_table[state].frequency);
-
 	local_irq_disable();
 
 	clockspeed_reg = *cpuctl & ~0x03;
@@ -74,8 +65,6 @@ static int sc520_freq_target(struct cpufreq_policy *policy, unsigned int state)
 
 	local_irq_enable();
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	return 0;
 }
 
-- 
1.7.12.rc2.18.g61b472e

