Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab3K3P4w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 10:56:52 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35117 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab3K3P4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 10:56:47 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/5] cpufreq: pcc: send new set of notification for transition failures
Date: Sat, 30 Nov 2013 21:26:21 +0530
Message-Id: <cd109686d6f54f51d0307cdb93af6d24fbad4366.1385826776.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <0d635c6701654a75f6d25dd435705dc1ede3e19c.1385826776.git.viresh.kumar@linaro.org>
References: <0d635c6701654a75f6d25dd435705dc1ede3e19c.1385826776.git.viresh.kumar@linaro.org>
In-Reply-To: <0d635c6701654a75f6d25dd435705dc1ede3e19c.1385826776.git.viresh.kumar@linaro.org>
References: <0d635c6701654a75f6d25dd435705dc1ede3e19c.1385826776.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current code, if we fail during a frequency transition we simply send the
POSTCHANGE notification with old frequency. This isn't enough.

One of the core user of these notifications is the code responsible for keeping
loops_per_jiffy aligned with frequency change. And mostly it is written as:

	if ((val == CPUFREQ_PRECHANGE  && freq->old < freq->new) ||
	    (val == CPUFREQ_POSTCHANGE && freq->old > freq->new)) {
		update-loops-per-jiffy...
	}

So, suppose we are changing to a higher frequency and failed during transition,
then following will happen:
- CPUFREQ_PRECHANGE notification with freq-new > freq-old
- CPUFREQ_POSTCHANGE notification with freq-new == freq-old

The first one will update loops_per_jiffy and second one will do nothing. Even
if we send the 2nd notification by exchanging values of freq-new and old, some
users of these notifications might get unstable.

This can be fixed by simply calling cpufreq_notify_post_transition() with error
code and this routine will take care of sending notifications in correct order.

Also it fills freqs.old before starting the first notification, this was missing
since ever.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/pcc-cpufreq.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/pcc-cpufreq.c b/drivers/cpufreq/pcc-cpufreq.c
index e2b4f40..1c0f106 100644
--- a/drivers/cpufreq/pcc-cpufreq.c
+++ b/drivers/cpufreq/pcc-cpufreq.c
@@ -213,6 +213,7 @@ static int pcc_cpufreq_target(struct cpufreq_policy *policy,
 		cpu, target_freq,
 		(pcch_virt_addr + pcc_cpu_data->input_offset));
 
+	freqs.old = policy->cur;
 	freqs.new = target_freq;
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
@@ -228,25 +229,20 @@ static int pcc_cpufreq_target(struct cpufreq_policy *policy,
 	memset_io((pcch_virt_addr + pcc_cpu_data->input_offset), 0, BUF_SZ);
 
 	status = ioread16(&pcch_hdr->status);
+	iowrite16(0, &pcch_hdr->status);
+
+	cpufreq_notify_post_transition(policy, &freqs, status != CMD_COMPLETE);
+	spin_unlock(&pcc_lock);
+
 	if (status != CMD_COMPLETE) {
 		pr_debug("target: FAILED for cpu %d, with status: 0x%x\n",
 			cpu, status);
-		goto cmd_incomplete;
+		return -EINVAL;
 	}
-	iowrite16(0, &pcch_hdr->status);
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 	pr_debug("target: was SUCCESSFUL for cpu %d\n", cpu);
-	spin_unlock(&pcc_lock);
 
 	return 0;
-
-cmd_incomplete:
-	freqs.new = freqs.old;
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-	iowrite16(0, &pcch_hdr->status);
-	spin_unlock(&pcc_lock);
-	return -EINVAL;
 }
 
 static int pcc_get_offset(int cpu)
-- 
1.7.12.rc2.18.g61b472e

