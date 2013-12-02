Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab3LBFey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 00:34:54 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:32875 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab3LBFei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 00:34:38 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 5/5] cpufreq: unicore2: send new set of notification for transition failures
Date: Mon,  2 Dec 2013 11:04:16 +0530
Message-Id: <a9ade5e83fda4f4e41cf1da87bb477a9fff98ca0.1385962178.git.viresh.kumar@linaro.org>
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

Also it returns a proper error message in case frequency transition failed.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/unicore2-cpufreq.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/cpufreq/unicore2-cpufreq.c b/drivers/cpufreq/unicore2-cpufreq.c
index 951152f..99d280d6 100644
--- a/drivers/cpufreq/unicore2-cpufreq.c
+++ b/drivers/cpufreq/unicore2-cpufreq.c
@@ -38,19 +38,17 @@ static int ucv2_target(struct cpufreq_policy *policy,
 			 unsigned int target_freq,
 			 unsigned int relation)
 {
-	unsigned int cur = policy->cur;
 	struct cpufreq_freqs freqs;
+	int ret;
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
-	if (!clk_set_rate(policy->clk, target_freq * 1000)) {
-		freqs.old = cur;
-		freqs.new = target_freq;
-	}
+	freqs.old = policy->cur;
+	freqs.new = target_freq;
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+	ret = clk_set_rate(policy->clk, target_freq * 1000);
+	cpufreq_notify_post_transition(policy, &freqs, ret);
 
-	return 0;
+	return ret;
 }
 
 static int __init ucv2_cpu_init(struct cpufreq_policy *policy)
-- 
1.7.12.rc2.18.g61b472e

