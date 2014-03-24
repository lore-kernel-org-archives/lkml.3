Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaCXHAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 03:00:38 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:37447 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaCXHAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 03:00:36 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: resume drivers before enabling governors
Date: Mon, 24 Mar 2014 12:30:29 +0530
Message-Id: <f067d833e8aded9d83fc4869121afdc78e96c544.1395644255.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During suspend, we first stop governors and then suspend cpufreq drivers and
resume must be exactly opposite of that. i.e. resume drivers first and then
start governors.

But the current code in resume enables governors first and then resume drivers.
Fix it be changing code sequence there.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
For 3.15-rc2 ..

 drivers/cpufreq/cpufreq.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 3aa7a7a..d8d6bc9 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1652,14 +1652,13 @@ void cpufreq_resume(void)
 	cpufreq_suspended = false;
 
 	list_for_each_entry(policy, &cpufreq_policy_list, policy_list) {
-		if (__cpufreq_governor(policy, CPUFREQ_GOV_START)
+		if (cpufreq_driver->resume && cpufreq_driver->resume(policy))
+			pr_err("%s: Failed to resume driver: %p\n", __func__,
+				policy);
+		else if (__cpufreq_governor(policy, CPUFREQ_GOV_START)
 		    || __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))
 			pr_err("%s: Failed to start governor for policy: %p\n",
 				__func__, policy);
-		else if (cpufreq_driver->resume
-		    && cpufreq_driver->resume(policy))
-			pr_err("%s: Failed to resume driver: %p\n", __func__,
-				policy);
 
 		/*
 		 * schedule call cpufreq_update_policy() for boot CPU, i.e. last
-- 
1.7.12.rc2.18.g61b472e

