Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab3ALFPK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 00:15:10 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:59987 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3ALFPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 00:15:05 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/5] cpufreq: Notify governors when cpus are hot-[un]plugged
Date: Sat, 12 Jan 2013 10:44:39 +0530
Message-Id: <6def83ce4bb23170d9c4fdf7a7105b90d3cb73b7.1357967566.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1357967566.git.viresh.kumar@linaro.org>
References: <cover.1357967566.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1357967566.git.viresh.kumar@linaro.org>
References: <cover.1357967566.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because cpufreq core and governors worry only about the online cpus, if a cpu is
hot [un]plugged, we must notify governors about it, otherwise be ready to expect
something unexpected.

We already have notifiers in the form of CPUFREQ_GOV_START/CPUFREQ_GOV_STOP, we
just need to call them now.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index de99517..a0a33bd 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -751,11 +751,16 @@ static int cpufreq_add_dev_policy(unsigned int cpu,
 				return -EBUSY;
 			}
 
+			__cpufreq_governor(managed_policy, CPUFREQ_GOV_STOP);
+
 			spin_lock_irqsave(&cpufreq_driver_lock, flags);
 			cpumask_copy(managed_policy->cpus, policy->cpus);
 			per_cpu(cpufreq_cpu_data, cpu) = managed_policy;
 			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
+			__cpufreq_governor(managed_policy, CPUFREQ_GOV_START);
+			__cpufreq_governor(managed_policy, CPUFREQ_GOV_LIMITS);
+
 			pr_debug("CPU already managed, adding link\n");
 			ret = sysfs_create_link(&dev->kobj,
 						&managed_policy->kobj,
@@ -1066,8 +1071,13 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 	 */
 	if (unlikely(cpu != data->cpu)) {
 		pr_debug("removing link\n");
+		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
 		cpumask_clear_cpu(cpu, data->cpus);
 		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
+		__cpufreq_governor(data, CPUFREQ_GOV_START);
+		__cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
+
 		kobj = &dev->kobj;
 		cpufreq_cpu_put(data);
 		unlock_policy_rwsem_write(cpu);
-- 
1.7.12.rc2.18.g61b472e

