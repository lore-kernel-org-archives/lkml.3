Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab3HPC1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:27:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab3HPC1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:27:12 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 11/34] cpufreq: elanfreq: remove calls to cpufreq_notify_transition()
Date: Fri, 16 Aug 2013 07:55:08 +0530
Message-Id: <e0fcc0ad8dfce1f0d8296ff6c99241f74b85c86d.1376619363.git.viresh.kumar@linaro.org>
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

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/elanfreq.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/cpufreq/elanfreq.c b/drivers/cpufreq/elanfreq.c
index 4ab4153..de08acf 100644
--- a/drivers/cpufreq/elanfreq.c
+++ b/drivers/cpufreq/elanfreq.c
@@ -108,17 +108,6 @@ static unsigned int elanfreq_get_cpu_frequency(unsigned int cpu)
 static int elanfreq_target(struct cpufreq_policy *policy,
 			    unsigned int state)
 {
-	struct cpufreq_freqs    freqs;
-
-	freqs.old = elanfreq_get_cpu_frequency(0);
-	freqs.new = elan_multiplier[state].clock;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
-	printk(KERN_INFO "elanfreq: attempting to set frequency to %i kHz\n",
-			elan_multiplier[state].clock);
-
-
 	/*
 	 * Access to the Elan's internal registers is indexed via
 	 * 0x22: Chip Setup & Control Register Index Register (CSCI)
@@ -149,8 +138,6 @@ static int elanfreq_target(struct cpufreq_policy *policy,
 	udelay(10000);
 	local_irq_enable();
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	return 0;
 }
 /*
-- 
1.7.12.rc2.18.g61b472e

