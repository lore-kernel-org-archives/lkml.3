Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497Ab3IMNYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:24:42 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:48321 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934119Ab3IMNYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:24:34 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 181/228] cpufreq: move freq change notifications to cpufreq core
Date: Fri, 13 Sep 2013 18:32:07 +0530
Message-Id: <fd43341751c7a00d2f4eedf48d6338f866b26a52.1379063063.git.viresh.kumar@linaro.org>
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

There are few special cases though, like exynos5440, which doesn't do everything
on the call to ->target_index() routine and call some kind of bottom halves for
doing this work, work/tasklet/etc..

They may continue doing notification from their own code and so this patch
introduces another flag: CPUFREQ_ASYNC_NOTIFICATION, which will be set by such
drivers.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 3fd24b1..79f89c3 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1787,6 +1787,9 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 		retval = cpufreq_driver->target(policy, target_freq, relation);
 	else if (cpufreq_driver->target_index) {
 		struct cpufreq_frequency_table *freq_table;
+		struct cpufreq_freqs freqs;
+		unsigned long flags;
+		bool notify;
 		int index;
 
 		freq_table = cpufreq_frequency_get_table(policy->cpu);
@@ -1807,7 +1810,39 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 			goto out;
 		}
 
+		read_lock_irqsave(&cpufreq_driver_lock, flags);
+		notify = !(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION);
+		read_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
+		if (notify) {
+			freqs.old = policy->cur;
+			freqs.new = freq_table[index].frequency;
+			freqs.flags = 0;
+
+			pr_debug("%s: cpu: %d, oldfreq: %u, new freq: %u\n",
+					__func__, policy->cpu, freqs.old,
+					freqs.new);
+
+			cpufreq_notify_transition(policy, &freqs,
+					CPUFREQ_PRECHANGE);
+		}
+
 		retval = cpufreq_driver->target_index(policy, index);
+		if (retval)
+			pr_err("%s: Failed to change cpu frequency: %d\n",
+					__func__, retval);
+
+		if (notify) {
+			/*
+			 * Notify with old freq in case we failed to change
+			 * frequency
+			 */
+			if (retval)
+				freqs.new = freqs.old;
+
+			cpufreq_notify_transition(policy, &freqs,
+					CPUFREQ_POSTCHANGE);
+		}
 	}
 
 out:
-- 
1.7.12.rc2.18.g61b472e

