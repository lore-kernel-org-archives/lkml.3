Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934510Ab3FSIz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:55:28 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:58922 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934459Ab3FSIzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:55:22 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 08/13] cpufreq: omap: call CPUFREQ_POSTCHANGE notfier in error cases
Date: Wed, 19 Jun 2013 14:23:02 +0530
Message-Id: <957838f1065ccc20b0252e0a6d37b61f6b173970.1371630975.git.viresh.kumar@linaro.org>
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

Omap driver was taking care of it well, but wasn't restoring freqs.new to
freqs.old in some cases. I wasn't required to add code for it as moving
PRECHANGE notifier down was a better option, so that we call it just before
starting frequency transition.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/omap-cpufreq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index 0279d18..29468a5 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -93,9 +93,6 @@ static int omap_target(struct cpufreq_policy *policy,
 	if (freqs.old == freqs.new && policy->cur == freqs.new)
 		return ret;
 
-	/* notifiers */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	freq = freqs.new * 1000;
 	ret = clk_round_rate(mpu_clk, freq);
 	if (IS_ERR_VALUE(ret)) {
@@ -125,6 +122,9 @@ static int omap_target(struct cpufreq_policy *policy,
 		freqs.old / 1000, volt_old ? volt_old / 1000 : -1,
 		freqs.new / 1000, volt ? volt / 1000 : -1);
 
+	/* notifiers */
+	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+
 	/* scaling up?  scale voltage before frequency */
 	if (mpu_reg && (freqs.new > freqs.old)) {
 		r = regulator_set_voltage(mpu_reg, volt - tol, volt + tol);
-- 
1.7.12.rc2.18.g61b472e

