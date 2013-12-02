Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab3LBFer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 00:34:47 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:37107 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab3LBFea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 00:34:30 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 3/5] cpufreq: pcc: send new set of notification for transition failures
Date: Mon,  2 Dec 2013 11:04:14 +0530
Message-Id: <3d86feabdc6f223b68a4936c9529b4edec3e39ba.1385962178.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <a6668c7fa63d67ca33b9e59d0189cd99a2ddcd05.1385962178.git.viresh.kumar@linaro.org>
References: <a6668c7fa63d67ca33b9e59d0189cd99a2ddcd05.1385962178.git.viresh.kumar@linaro.org>
In-Reply-To: <a6668c7fa63d67ca33b9e59d0189cd99a2ddcd05.1385962178.git.viresh.kumar@linaro.org>
References: <a6668c7fa63d67ca33b9e59d0189cd99a2ddcd05.1385962178.git.viresh.kumar@linaro.org>
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

