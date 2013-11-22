Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab3KVLaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 06:30:09 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:46438 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab3KVLaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 06:30:06 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, tianyu.lan@intel.com, nm@ti.com,
        jinchoi@broadcom.com, sebastian.capella@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 2/2] cpufreq: Change freq before suspending governors
Date: Fri, 22 Nov 2013 16:59:49 +0530
Message-Id: <df162ba4cbdf1379ccfa5dd4ca34153626ae9c71.1385118256.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1385118255.git.viresh.kumar@linaro.org>
References: <cover.1385118255.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1385118255.git.viresh.kumar@linaro.org>
References: <cover.1385118255.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms might want to change frequency before suspending governors. Like:
- Some platform which want to set freq to max to speed up suspend/hibernation
  process.
- Some platform (like: Tegra or exynos), set this to min or bootloader's
  frequency.

This patch adds an option for those, so that they can specify this at call to
->init(), so that cpufreq core can take care of this before suspending system.

If this variable is not updated by ->init() then its value would be zero and so
core wouldn't do anything.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 17 +++++++++++++++++
 include/linux/cpufreq.h   |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 540bd87..e609102 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1476,6 +1476,7 @@ void cpufreq_suspend(void)
 {
 	struct cpufreq_policy *policy;
 	unsigned long flags;
+	int ret;
 
 	if (!has_target())
 		return;
@@ -1487,6 +1488,22 @@ void cpufreq_suspend(void)
 			pr_err("%s: Failed to stop governor for policy: %p\n",
 					__func__, policy);
 
+	/*
+	 * In case platform wants some specific frequency to be configured
+	 * during suspend
+	 */
+	if (policy->suspend_freq) {
+		pr_debug("%s: Suspending Governors: Setting suspend-freq: %u\n",
+				__func__, policy->suspend_freq);
+
+		ret = __cpufreq_driver_target(policy, policy->suspend_freq,
+				CPUFREQ_RELATION_H);
+		/* We can still suspend even if this failed */
+		if (ret)
+			pr_err("%s: Unable to set suspend-freq: %u. Err: %d\n",
+					__func__, policy->suspend_freq, ret);
+	}
+
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	cpufreq_suspended = true;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 6d93f91..867fdd4 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -72,6 +72,8 @@ struct cpufreq_policy {
 	unsigned int		max;    /* in kHz */
 	unsigned int		cur;    /* in kHz, only needed if cpufreq
 					 * governors are used */
+	unsigned int		suspend_freq; /* freq to set during suspend */
+
 	unsigned int		policy; /* see above */
 	struct cpufreq_governor	*governor; /* see below */
 	void			*governor_data;
-- 
1.7.12.rc2.18.g61b472e

