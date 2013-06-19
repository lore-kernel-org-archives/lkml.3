Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934497Ab3FSIzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:55:20 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62837 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934459Ab3FSIzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:55:09 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 07/13] cpufreq: imx6q: call CPUFREQ_POSTCHANGE notfier in error cases
Date: Wed, 19 Jun 2013 14:23:01 +0530
Message-Id: <ca85a6fad679b2e305a21893811474f5802f837e.1371630975.git.viresh.kumar@linaro.org>
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

This also moves PRECHANGE notifier down so that we call it just before starting
frequency transition.

Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/imx6q-cpufreq.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index b78bc35..e37cdae 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -68,8 +68,6 @@ static int imx6q_set_target(struct cpufreq_policy *policy,
 	if (freqs.old == freqs.new)
 		return 0;
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	rcu_read_lock();
 	opp = opp_find_freq_ceil(cpu_dev, &freq_hz);
 	if (IS_ERR(opp)) {
@@ -86,13 +84,16 @@ static int imx6q_set_target(struct cpufreq_policy *policy,
 		freqs.old / 1000, volt_old / 1000,
 		freqs.new / 1000, volt / 1000);
 
+	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+
 	/* scaling up?  scale voltage before frequency */
 	if (freqs.new > freqs.old) {
 		ret = regulator_set_voltage_tol(arm_reg, volt, 0);
 		if (ret) {
 			dev_err(cpu_dev,
 				"failed to scale vddarm up: %d\n", ret);
-			return ret;
+			freqs.new = freqs.old;
+			goto post_notify;
 		}
 
 		/*
@@ -145,15 +146,18 @@ static int imx6q_set_target(struct cpufreq_policy *policy,
 	if (ret) {
 		dev_err(cpu_dev, "failed to set clock rate: %d\n", ret);
 		regulator_set_voltage_tol(arm_reg, volt_old, 0);
-		return ret;
+		freqs.new = freqs.old;
+		goto post_notify;
 	}
 
 	/* scaling down?  scale voltage after frequency */
 	if (freqs.new < freqs.old) {
 		ret = regulator_set_voltage_tol(arm_reg, volt, 0);
-		if (ret)
+		if (ret) {
 			dev_warn(cpu_dev,
 				 "failed to scale vddarm down: %d\n", ret);
+			ret = 0;
+		}
 
 		if (freqs.old == FREQ_1P2_GHZ / 1000) {
 			regulator_set_voltage_tol(pu_reg,
@@ -163,9 +167,10 @@ static int imx6q_set_target(struct cpufreq_policy *policy,
 		}
 	}
 
+post_notify:
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 
-	return 0;
+	return ret;
 }
 
 static int imx6q_cpufreq_init(struct cpufreq_policy *policy)
-- 
1.7.12.rc2.18.g61b472e

