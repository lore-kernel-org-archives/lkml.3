Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab3DAM6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:58:35 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:63534 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab3DAM6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:58:32 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 4/9] cpufreq: cpufreq-cpu0: Call CPUFREQ_POSTCHANGE notifier for failure cases too
Date: Mon,  1 Apr 2013 18:27:44 +0530
Message-Id: <905a002107e37c1a20ea14f758e68f335578b00f.1364820620.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364820620.git.viresh.kumar@linaro.org>
References: <cover.1364820620.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364820620.git.viresh.kumar@linaro.org>
References: <cover.1364820620.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we are simply returning from target() if we encounter some error after
broadcasting CPUFREQ_PRECHANGE notifier. Which looks to be wrong as others might
depend on POSTCHANGE notifier for their functioning.

So, better broadcast CPUFREQ_POSTCHANGE notifier for these failure cases too,
but with old frequency.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 4c5a4cf..a7e51bd 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -77,7 +77,9 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
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
@@ -95,7 +97,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 		if (ret) {
 			pr_err("failed to scale voltage up: %d\n", ret);
 			freqs.new = freqs.old;
-			return ret;
+			goto post_notify;
 		}
 	}
 
@@ -104,7 +106,8 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 		pr_err("failed to set clock rate: %d\n", ret);
 		if (cpu_reg)
 			regulator_set_voltage_tol(cpu_reg, volt_old, tol);
-		return ret;
+		freqs.new = freqs.old;
+		goto post_notify;
 	}
 
 	/* scaling down?  scale voltage after frequency */
@@ -114,16 +117,16 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 			pr_err("failed to scale voltage down: %d\n", ret);
 			clk_set_rate(cpu_clk, freqs.old * 1000);
 			freqs.new = freqs.old;
-			return ret;
 		}
 	}
 
+post_notify:
 	for_each_online_cpu(cpu) {
 		freqs.cpu = cpu;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
 
-	return 0;
+	return ret;
 }
 
 static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
-- 
1.7.12.rc2.18.g61b472e

