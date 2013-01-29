Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3A2EkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 23:40:16 -0500
Received: from service87.mimecast.com ([91.220.42.44]:47649 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab3A2EkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 23:40:09 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, inderpal.singh@linaro.org
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/2] Revert "cpufreq: Don't use cpu removed during cpufreq_driver_unregister"
Date: Tue, 29 Jan 2013 10:10:00 +0530
Message-Id: <c5f698edde8215a706fb82c158fb0050798797f2.1359434113.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <d6827976a56d429848ab8ababa2779a21c68d65f.1359434113.git.viresh.kumar@linaro.org>
References: <d6827976a56d429848ab8ababa2779a21c68d65f.1359434113.git.viresh.kumar@linaro.org>
In-Reply-To: <d6827976a56d429848ab8ababa2779a21c68d65f.1359434113.git.viresh.kumar@linaro.org>
References: <d6827976a56d429848ab8ababa2779a21c68d65f.1359434113.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 29 Jan 2013 04:40:05.0066 (UTC) FILETIME=[B55692A0:01CDFDDA]
X-MC-Unique: 113012904400702301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r0T4eIq6006043

This reverts commit 956f33948b95aa91f6cbc6860087671c6ac1de4b.

With the addition of following patch, this change/variable is not required:

commit b9ba2725343ae57add3f324dfa5074167f48de96
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Mon Jan 14 13:23:03 2013 +0000

    cpufreq: Simplify __cpufreq_remove_dev()

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index db81382..8d521422 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -47,9 +47,6 @@ static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
 #endif
 static DEFINE_SPINLOCK(cpufreq_driver_lock);
 
-/* Used when we unregister cpufreq driver */
-static struct cpumask cpufreq_online_mask;
-
 /*
  * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
  * all cpufreq/hotplug/workqueue/etc related lock issues.
@@ -951,7 +948,6 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	 * managing offline cpus here.
 	 */
 	cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);
-	cpumask_and(policy->cpus, policy->cpus, &cpufreq_online_mask);
 
 	policy->user_policy.min = policy->min;
 	policy->user_policy.max = policy->max;
@@ -1133,7 +1129,6 @@ static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 	if (unlikely(lock_policy_rwsem_write(cpu)))
 		BUG();
 
-	cpumask_clear_cpu(cpu, &cpufreq_online_mask);
 	retval = __cpufreq_remove_dev(dev, sif);
 	return retval;
 }
@@ -1875,8 +1870,6 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	cpufreq_driver = driver_data;
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-	cpumask_setall(&cpufreq_online_mask);
-
 	ret = subsys_interface_register(&cpufreq_interface);
 	if (ret)
 		goto err_null_driver;
-- 
1.7.12.rc2.18.g61b472e


