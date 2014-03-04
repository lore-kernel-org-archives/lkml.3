Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbaCDDBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 22:01:55 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56318 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125AbaCDDAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 22:00:46 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, nm@ti.com,
        swarren@wwwdotorg.org, kgene.kim@samsung.com, jinchoi@broadcom.com,
        tianyu.lan@intel.com, sebastian.capella@linaro.org,
        jhbird.choi@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V6 Resend 2/5] cpufreq: Implement cpufreq_generic_suspend()
Date: Tue,  4 Mar 2014 11:00:27 +0800
Message-Id: <45ab2c8aa3c46d6ec6c87424e1529ccd54f6db47.1393901906.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <b37f304efa4a007c0c53d9e8a33e11b7977cb0a4.1393901906.git.viresh.kumar@linaro.org>
References: <b37f304efa4a007c0c53d9e8a33e11b7977cb0a4.1393901906.git.viresh.kumar@linaro.org>
In-Reply-To: <b37f304efa4a007c0c53d9e8a33e11b7977cb0a4.1393901906.git.viresh.kumar@linaro.org>
References: <b37f304efa4a007c0c53d9e8a33e11b7977cb0a4.1393901906.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple platforms need to set CPU to a particular frequency before suspending
system. And so they need a common infrastructure which is provided by this
patch. Those platforms just need to initialize their ->suspend() pointers with
the generic routine.

Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 26 ++++++++++++++++++++++++++
 include/linux/cpufreq.h   |  3 +++
 2 files changed, 29 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2e43c08..b6f8545 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1578,6 +1578,32 @@ static struct subsys_interface cpufreq_interface = {
 	.remove_dev	= cpufreq_remove_dev,
 };
 
+/*
+ * In case platform wants some specific frequency to be configured
+ * during suspend..
+ */
+int cpufreq_generic_suspend(struct cpufreq_policy *policy)
+{
+	int ret;
+
+	if (!policy->suspend_freq) {
+		pr_err("%s: suspend_freq can't be zero\n", __func__);
+		return -EINVAL;
+	}
+
+	pr_debug("%s: Setting suspend-freq: %u\n", __func__,
+			policy->suspend_freq);
+
+	ret = __cpufreq_driver_target(policy, policy->suspend_freq,
+			CPUFREQ_RELATION_H);
+	if (ret)
+		pr_err("%s: unable to set suspend-freq: %u. err: %d\n",
+				__func__, policy->suspend_freq, ret);
+
+	return ret;
+}
+EXPORT_SYMBOL(cpufreq_generic_suspend);
+
 /**
  * cpufreq_suspend() - Suspend CPUFreq governors
  *
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 94ed907..325bab0 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -74,6 +74,8 @@ struct cpufreq_policy {
 	unsigned int		max;    /* in kHz */
 	unsigned int		cur;    /* in kHz, only needed if cpufreq
 					 * governors are used */
+	unsigned int		suspend_freq; /* freq to set during suspend */
+
 	unsigned int		policy; /* see above */
 	struct cpufreq_governor	*governor; /* see below */
 	void			*governor_data;
@@ -299,6 +301,7 @@ cpufreq_verify_within_cpu_limits(struct cpufreq_policy *policy)
 #ifdef CONFIG_CPU_FREQ
 void cpufreq_suspend(void);
 void cpufreq_resume(void);
+int cpufreq_generic_suspend(struct cpufreq_policy *policy);
 #else
 static inline void cpufreq_suspend(void) {}
 static inline void cpufreq_resume(void) {}
-- 
1.7.12.rc2.18.g61b472e

