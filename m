Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab3HCLue (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 07:50:34 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53833 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab3HCLua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 07:50:30 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        l.majewski@samsung.com, Myungjoo Ham <myungjoo.ham@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 06/10] cpufreq: Store cpufreq policies in a list
Date: Sat,  3 Aug 2013 17:19:24 +0530
Message-Id: <c46357807ec1517cf90e3cece6edba31117a67a9.1375530162.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375530162.git.viresh.kumar@linaro.org>
References: <cover.1375530162.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375530162.git.viresh.kumar@linaro.org>
References: <cover.1375530162.git.viresh.kumar@linaro.org>
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
index 496e31c..4c3aef0 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -39,6 +39,7 @@ static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
 static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data_fallback);
 static DEFINE_RWLOCK(cpufreq_driver_lock);
 static DEFINE_MUTEX(cpufreq_governor_lock);
+static LIST_HEAD(cpufreq_policy_list);
 
 #ifdef CONFIG_HOTPLUG_CPU
 /* This one keeps track of the previously set governor of a removed CPU */
@@ -963,6 +964,12 @@ err_free_policy:
 
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
@@ -1076,6 +1083,10 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
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
index 9876712..d272fa4 100644
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

