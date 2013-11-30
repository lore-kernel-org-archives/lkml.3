Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3K3P4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 10:56:44 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:59784 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab3K3P4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 10:56:39 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/5] cpufreq: send new set of notification for transition failures
Date: Sat, 30 Nov 2013 21:26:20 +0530
Message-Id: <4834ba7f5ae3838515f7b85102987cc3ec066627.1385826776.git.viresh.kumar@linaro.org>
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

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index a862aa9..557bb49 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1764,17 +1764,8 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 			pr_err("%s: Failed to change cpu frequency: %d\n",
 					__func__, retval);
 
-		if (notify) {
-			/*
-			 * Notify with old freq in case we failed to change
-			 * frequency
-			 */
-			if (retval)
-				freqs.new = freqs.old;
-
-			cpufreq_notify_transition(policy, &freqs,
-					CPUFREQ_POSTCHANGE);
-		}
+		if (notify)
+			cpufreq_notify_post_transition(policy, &freqs, retval);
 	}
 
 out:
-- 
1.7.12.rc2.18.g61b472e

