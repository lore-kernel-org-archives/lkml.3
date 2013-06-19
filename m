Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934573Ab3FSI4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:56:36 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62727 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934507Ab3FSI4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:56:30 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 13/13] cpufreq: make sure frequency transitions are serialized
Date: Wed, 19 Jun 2013 14:23:07 +0530
Message-Id: <0bebf56a27f799a282cc00d0c17c187f9941f122.1371630975.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1371630975.git.viresh.kumar@linaro.org>
References: <cover.1371630975.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1371630975.git.viresh.kumar@linaro.org>
References: <cover.1371630975.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whenever we are changing frequency of a cpu, we are calling PRECHANGE and
POSTCHANGE notifiers. They must be serialized. i.e. PRECHANGE or POSTCHANGE
shouldn't be called twice contiguously.

This can happen due to bugs in users of __cpufreq_driver_target() or actual
cpufreq drivers who are sending these notifiers.

This patch adds some protection against this. Now, we keep track of the last
transaction and see if something went wrong.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2d53f47..92cb8b3 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -107,6 +107,9 @@ static void handle_update(struct work_struct *work);
 static BLOCKING_NOTIFIER_HEAD(cpufreq_policy_notifier_list);
 static struct srcu_notifier_head cpufreq_transition_notifier_list;
 
+/* Tracks status of transition */
+static int transition_ongoing;
+
 static bool init_cpufreq_transition_notifier_list_called;
 static int __init init_cpufreq_transition_notifier_list(void)
 {
@@ -264,6 +267,8 @@ void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 	switch (state) {
 
 	case CPUFREQ_PRECHANGE:
+		WARN_ON(transition_ongoing++);
+
 		/* detect if the driver reported a value as "old frequency"
 		 * which is not equal to what the cpufreq core thinks is
 		 * "old frequency".
@@ -283,6 +288,8 @@ void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 		break;
 
 	case CPUFREQ_POSTCHANGE:
+		WARN_ON(!transition_ongoing--);
+
 		adjust_jiffies(CPUFREQ_POSTCHANGE, freqs);
 		pr_debug("FREQ: %lu - CPU: %lu", (unsigned long)freqs->new,
 			(unsigned long)freqs->cpu);
@@ -1458,6 +1465,8 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 
 	if (cpufreq_disabled())
 		return -ENODEV;
+	if (transition_ongoing)
+		return -EBUSY;
 
 	/* Make sure that target_freq is within supported range */
 	if (target_freq > policy->max)
-- 
1.7.12.rc2.18.g61b472e

