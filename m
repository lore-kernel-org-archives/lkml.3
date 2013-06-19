Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934550Ab3FSI4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:56:09 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:62896 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934507Ab3FSI4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:56:03 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 11/13] cpufreq: s3c64xx: call CPUFREQ_POSTCHANGE notfier in error cases
Date: Wed, 19 Jun 2013 14:23:05 +0530
Message-Id: <eb0db3a997a59f7f73c51b99028cac17cbc395cf.1371630975.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1371630975.git.viresh.kumar@linaro.org>
References: <cover.1371630975.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1371630975.git.viresh.kumar@linaro.org>
References: <cover.1371630975.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PRECHANGE and POSTCHANGE notifiers must be called in groups, i.e either both
should be called or both shouldn't be.

In case we have started PRECHANGE notifier and found an error, we must call
POSTCHANGE notifier with freqs.new = freqs.old to guarantee that sequence of
calling notifiers is complete.

This patch fixes it.

Cc: Mark Brown <broonie@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/s3c64xx-cpufreq.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index 27cacb5..017ade0 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -104,7 +104,8 @@ static int s3c64xx_cpufreq_set_target(struct cpufreq_policy *policy,
 		if (ret != 0) {
 			pr_err("Failed to set VDDARM for %dkHz: %d\n",
 			       freqs.new, ret);
-			goto err;
+			freqs.new = freqs.old;
+			goto post_notify;
 		}
 	}
 #endif
@@ -113,10 +114,13 @@ static int s3c64xx_cpufreq_set_target(struct cpufreq_policy *policy,
 	if (ret < 0) {
 		pr_err("Failed to set rate %dkHz: %d\n",
 		       freqs.new, ret);
-		goto err;
+		freqs.new = freqs.old;
 	}
 
+post_notify:
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	if (ret)
+		goto err;
 
 #ifdef CONFIG_REGULATOR
 	if (vddarm && freqs.new < freqs.old) {
-- 
1.7.12.rc2.18.g61b472e

