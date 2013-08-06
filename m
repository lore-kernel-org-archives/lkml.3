Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab3HFR0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:26:22 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36409 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534Ab3HFRYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:24:20 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Lukasz Majewski <l.majewski@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 06/11] cpufreq: Store cpufreq policies in a list
Date: Tue,  6 Aug 2013 22:53:08 +0530
Message-Id: <614e2013bbd3833cc17d0a0a1d49cd11d43cf1d3.1375809311.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375809311.git.viresh.kumar@linaro.org>
References: <cover.1375809311.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375809311.git.viresh.kumar@linaro.org>
References: <cover.1375809311.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lukasz Majewski <l.majewski@samsung.com>

Policies available in a cpufreq framework are now linked together. They are
accessible via cpufreq_policy_list defined at cpufreq core.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 11 +++++++++++
 include/linux/cpufreq.h   |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 9e83d91..f5999c4 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -40,6 +40,7 @@ static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
 static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data_fallback);
 static DEFINE_RWLOCK(cpufreq_driver_lock);
 static DEFINE_MUTEX(cpufreq_governor_lock);
+static LIST_HEAD(cpufreq_policy_list);
 
 #ifdef CONFIG_HOTPLUG_CPU
 /* This one keeps track of the previously set governor of a removed CPU */
@@ -964,6 +965,12 @@ err_free_policy:
 
 static void cpufreq_policy_free(struct cpufreq_policy *policy)
 {
+	unsigned long flags;
+
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	list_del(&policy->policy_list);
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
 	free_cpumask_var(policy->related_cpus);
 	free_cpumask_var(policy->cpus);
 	kfree(policy);
@@ -1077,6 +1084,10 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 		ret = cpufreq_add_dev_interface(policy, dev);
 		if (ret)
 			goto err_out_unregister;
+
+		write_lock_irqsave(&cpufreq_driver_lock, flags);
+		list_add(&policy->policy_list, &cpufreq_policy_list);
+		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 	}
 
 	cpufreq_init_policy(policy);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 2920892..431a05d 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -82,6 +82,7 @@ struct cpufreq_policy {
 
 	struct cpufreq_real_policy	user_policy;
 
+	struct list_head        policy_list;
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
 	int			transition_ongoing; /* Tracks transition status */
-- 
1.7.12.rc2.18.g61b472e

