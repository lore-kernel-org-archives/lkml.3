Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934347Ab3IMN0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:26:51 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53781 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934335Ab3IMN0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:26:44 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 199/228] cpufreq: p4-clockmod: remove calls to cpufreq_notify_transition()
Date: Fri, 13 Sep 2013 18:32:25 +0530
Message-Id: <9c5d4a95b899267178c9383ca2ce81152f98c824.1379063063.git.viresh.kumar@linaro.org>
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

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/p4-clockmod.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/cpufreq/p4-clockmod.c b/drivers/cpufreq/p4-clockmod.c
index 3c23053..3d1cba9 100644
--- a/drivers/cpufreq/p4-clockmod.c
+++ b/drivers/cpufreq/p4-clockmod.c
@@ -107,15 +107,8 @@ static struct cpufreq_frequency_table p4clockmod_table[] = {
 
 static int cpufreq_p4_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	struct cpufreq_freqs freqs;
 	int i;
 
-	freqs.old = cpufreq_p4_get(policy->cpu);
-	freqs.new = stock_freq * p4clockmod_table[index].driver_data / 8;
-
-	/* notifiers */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	/* run on each logical CPU,
 	 * see section 13.15.3 of IA32 Intel Architecture Software
 	 * Developer's Manual, Volume 3
@@ -123,9 +116,6 @@ static int cpufreq_p4_target(struct cpufreq_policy *policy, unsigned int index)
 	for_each_cpu(i, policy->cpus)
 		cpufreq_p4_setdc(i, p4clockmod_table[index].driver_data);
 
-	/* notifiers */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	return 0;
 }
 
-- 
1.7.12.rc2.18.g61b472e

