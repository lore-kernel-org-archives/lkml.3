Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab3C3OSS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 10:18:18 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:63893 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab3C3OSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 10:18:16 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, shawn.guo@linaro.org
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        arvind.chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: cpufreq-cpu0: Call CPUFREQ_POSTCHANGE notifier for failure cases too
Date: Sat, 30 Mar 2013 19:48:07 +0530
Message-Id: <cbaaebaef94c13405888bc150e12d62754fc266d.1364653063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we are simply returning from target() if we encounter some error after
broadcasting CPUFREQ_PRECHANGE notifier. Which looks to be wrong as others might
depend on POSTCHANGE notifier for their functioning.

So, better broadcast CPUFREQ_POSTCHANGE notifier for these failure cases too,
but with old frequency.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 1cab820..6561853 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -74,7 +74,9 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 		if (IS_ERR(opp)) {
 			rcu_read_unlock();
 			pr_err("failed to find OPP for %ld\n", freq_Hz);
-			return PTR_ERR(opp);
+			freqs.new = freqs.old;
+			ret = PTR_ERR(opp);
+			goto post_notify;
 		}
 		volt = opp_get_voltage(opp);
 		rcu_read_unlock();
@@ -92,7 +94,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 		if (ret) {
 			pr_err("failed to scale voltage up: %d\n", ret);
 			freqs.new = freqs.old;
-			return ret;
+			goto post_notify;
 		}
 	}
 
@@ -101,7 +103,8 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 		pr_err("failed to set clock rate: %d\n", ret);
 		if (cpu_reg)
 			regulator_set_voltage_tol(cpu_reg, volt_old, tol);
-		return ret;
+		freqs.new = freqs.old;
+		goto post_notify;
 	}
 
 	/* scaling down?  scale voltage after frequency */
@@ -111,13 +114,13 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 			pr_err("failed to scale voltage down: %d\n", ret);
 			clk_set_rate(cpu_clk, freqs.old * 1000);
 			freqs.new = freqs.old;
-			return ret;
 		}
 	}
 
+post_notify:
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 
-	return 0;
+	return ret;
 }
 
 static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
-- 
1.7.12.rc2.18.g61b472e

