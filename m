Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934280Ab3IMN0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:26:06 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:41503 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934265Ab3IMNZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:25:58 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 193/228] cpufreq: ia64-acpi: remove calls to cpufreq_notify_transition()
Date: Fri, 13 Sep 2013 18:32:19 +0530
Message-Id: <b297569ac875e892ac665c9190212f63a5305000.1379063063.git.viresh.kumar@linaro.org>
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

Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/ia64-acpi-cpufreq.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/cpufreq/ia64-acpi-cpufreq.c b/drivers/cpufreq/ia64-acpi-cpufreq.c
index 4695fa2..53c6ac6 100644
--- a/drivers/cpufreq/ia64-acpi-cpufreq.c
+++ b/drivers/cpufreq/ia64-acpi-cpufreq.c
@@ -141,7 +141,6 @@ processor_set_freq (
 {
 	int			ret = 0;
 	u32			value = 0;
-	struct cpufreq_freqs    cpufreq_freqs;
 	cpumask_t		saved_mask;
 	int			retval;
 
@@ -168,13 +167,6 @@ processor_set_freq (
 	pr_debug("Transitioning from P%d to P%d\n",
 		data->acpi_data.state, state);
 
-	/* cpufreq frequency struct */
-	cpufreq_freqs.old = data->freq_table[data->acpi_data.state].frequency;
-	cpufreq_freqs.new = data->freq_table[state].frequency;
-
-	/* notify cpufreq */
-	cpufreq_notify_transition(policy, &cpufreq_freqs, CPUFREQ_PRECHANGE);
-
 	/*
 	 * First we write the target state's 'control' value to the
 	 * control_register.
@@ -186,22 +178,11 @@ processor_set_freq (
 
 	ret = processor_set_pstate(value);
 	if (ret) {
-		unsigned int tmp = cpufreq_freqs.new;
-		cpufreq_notify_transition(policy, &cpufreq_freqs,
-				CPUFREQ_POSTCHANGE);
-		cpufreq_freqs.new = cpufreq_freqs.old;
-		cpufreq_freqs.old = tmp;
-		cpufreq_notify_transition(policy, &cpufreq_freqs,
-				CPUFREQ_PRECHANGE);
-		cpufreq_notify_transition(policy, &cpufreq_freqs,
-				CPUFREQ_POSTCHANGE);
 		printk(KERN_WARNING "Transition failed with error %d\n", ret);
 		retval = -ENODEV;
 		goto migrate_end;
 	}
 
-	cpufreq_notify_transition(policy, &cpufreq_freqs, CPUFREQ_POSTCHANGE);
-
 	data->acpi_data.state = state;
 
 	retval = 0;
-- 
1.7.12.rc2.18.g61b472e

