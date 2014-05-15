Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaEOF5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 01:57:03 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:62619 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbaEOF5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 01:57:01 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        swarren@nvidia.com, nicolas.pitre@linaro.org, swarren@wwwdotorg.org,
        dianders@chromium.org, linux@arm.linux.org.uk,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC] cpufreq: send notifications for intermediate (stable) frequencies
Date: Thu, 15 May 2014 11:26:51 +0530
Message-Id: <25738681139c04272b6d2ebeff244c6d36c893f7.1400133090.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Douglas Anderson, recently pointed out an interesting problem due to which his
udelay() was expiring earlier than it should:
https://lkml.org/lkml/2014/5/13/766

While transitioning between frequencies few platforms may temporarily switch to
a stable frequency, waiting for the main PLL to stabilize.

For example: When we transition between very low frequencies on exynos, like
between 200MHz and 300MHz, we may temporarily switch to a PLL running at 800MHz.
No CPUFREQ notification is sent for that. That means there's a period of time
when we're running at 800MHz but loops_per_jiffy is calibrated at between 200MHz
and 300MHz. And so udelay behaves badly.

To get this fixed in a generic way, lets introduce another callback safe_freq()
for the cpufreq drivers.

safe_freq() should return a stable intermediate frequency a platform might want
to switch to, before jumping to the frequency corresponding to 'index'. Core
will send the 'PRE' notification for this 'stable' frequency and 'POST' for the
'target' frequency. Though if ->target_index() fails, it will handle POST for
'stable' frequency only.

Drivers must send 'POST' notification for 'stable' freq and 'PRE' for 'target'
freq. If they can't switch to target frequency, they don't need to send any
notification.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Doug/Stephen,

If this doesn't look too ugly, then I would need patches from you to fix your
platforms as I am not well aware of clk hierarchy of your platforms.

 drivers/cpufreq/cpufreq.c | 13 +++++++++++--
 include/linux/cpufreq.h   | 18 ++++++++++++++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index a05c921..8d1cb4f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1874,11 +1874,17 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 
 		if (notify) {
 			freqs.old = policy->cur;
-			freqs.new = freq_table[index].frequency;
+			/* Switch to some safe intermediate freq */
+			if (cpufreq_driver->safe_freq)
+				freqs.new = cpufreq_driver->safe_freq(policy,
+								      index);
+			else
+				freqs.new = freq_table[index].frequency;
 			freqs.flags = 0;
 
 			pr_debug("%s: cpu: %d, oldfreq: %u, new freq: %u\n",
-				 __func__, policy->cpu, freqs.old, freqs.new);
+				 __func__, policy->cpu, freqs.old,
+				 freq_table[index].frequency);
 
 			cpufreq_freq_transition_begin(policy, &freqs);
 		}
@@ -1887,6 +1893,9 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 		if (retval)
 			pr_err("%s: Failed to change cpu frequency: %d\n",
 			       __func__, retval);
+		else
+			/* Send POST notification for the target frequency */
+			freqs.new = freq_table[index].frequency;
 
 		if (notify)
 			cpufreq_freq_transition_end(policy, &freqs, retval);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 3f45889..b5ba275 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -226,6 +226,24 @@ struct cpufreq_driver {
 				 unsigned int relation);
 	int	(*target_index)	(struct cpufreq_policy *policy,
 				 unsigned int index);
+	/*
+	 * Only for drivers with target_index() and CPUFREQ_ASYNC_NOTIFICATION
+	 * unset.
+	 *
+	 * safe_freq() should return a stable intermediate frequency a platform
+	 * might want to switch to, before jumping to the frequency
+	 * corresponding to 'index'. Core will send the 'PRE' notification for
+	 * this 'stable' frequency and 'POST' for the 'target' frequency. Though
+	 * if ->target_index() fails, it will handle POST for 'stable' frequency
+	 * only.
+	 *
+	 * Drivers must send 'POST' notification for 'stable' freq and 'PRE' for
+	 * 'target' freq. If they can't switch to target frequency, they don't
+	 * need to send any notification.
+	 *
+	 */
+	unsigned int (*safe_freq)(struct cpufreq_policy *policy,
+				  unsigned int index);
 
 	/* should be defined, if possible */
 	unsigned int	(*get)	(unsigned int cpu);
-- 
2.0.0.rc2

