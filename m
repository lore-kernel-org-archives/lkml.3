Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab3LBFw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 00:52:59 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:33272 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab3LBFwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 00:52:53 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, swarren@wwwdotorg.org,
        kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, tianyu.lan@intel.com,
        jhbird.choi@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V4 3/6] cpufreq: Implement cpufreq_generic_suspend()
Date: Mon,  2 Dec 2013 11:22:33 +0530
Message-Id: <8f43348fdf8b796c6b53291e039710e91ec9ca56.1385962528.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1385962528.git.viresh.kumar@linaro.org>
References: <cover.1385962528.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1385962528.git.viresh.kumar@linaro.org>
References: <cover.1385962528.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/cpufreq.c | 25 +++++++++++++++++++++++++
 include/linux/cpufreq.h   |  3 +++
 2 files changed, 28 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 443c053..ae4923e 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1530,6 +1530,31 @@ static struct subsys_interface cpufreq_interface = {
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
+
 /**
  * cpufreq_suspend() - Suspend CPUFreq governors
  *
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index b26bfab..ce6f06f 100644
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
@@ -285,6 +287,7 @@ cpufreq_verify_within_cpu_limits(struct cpufreq_policy *policy)
 #ifdef CONFIG_CPU_FREQ
 void cpufreq_suspend(void);
 void cpufreq_resume(void);
+int cpufreq_generic_suspend(struct cpufreq_policy *policy);
 #else
 static inline void cpufreq_suspend(void) {}
 static inline void cpufreq_resume(void) {}
-- 
1.7.12.rc2.18.g61b472e

