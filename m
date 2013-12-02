Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab3LBFet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 00:34:49 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:53493 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab3LBFe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 00:34:26 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 2/5] cpufreq: send new set of notification for transition failures
Date: Mon,  2 Dec 2013 11:04:13 +0530
Message-Id: <09131009236f613c6589737449f5973f7eb6f216.1385962178.git.viresh.kumar@linaro.org>
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

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 3b877d4..a7fcb84 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1815,17 +1815,8 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
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

