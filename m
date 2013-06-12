Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab3FLJKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:10:37 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:53120 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754620Ab3FLJKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:10:34 -0400
From: Xiaoguang Chen <chenxg@marvell.com>
To: <viresh.kumar@linaro.org>, <rjw@sisk.pl>
CC: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <njiang1@marvell.com>,
        <zjwu@marvell.com>, <ylmao@marvell.com>, <chenxg.marvell@gmail.com>,
        Xiaoguang Chen <chenxg@marvell.com>
Subject: [PATCH v4] cpufreq: fix governor start/stop race condition
Date: Wed, 12 Jun 2013 17:09:49 +0800
Message-ID: <1371028189-15758-1-git-send-email-chenxg@marvell.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq governor stop and start should be kept in sequence.
If not, there will be unexpected behavior, for example:

we have 4 cpus and policy->cpu=cpu0, cpu1/2/3 are linked to cpu0.
the normal sequence is as below:

1) Current governor is userspace, one application tries to set
governor to ondemand. it will call __cpufreq_set_policy in which it
will stop userspace governor and then start ondemand governor.

2) Current governor is userspace, now cpu0 hotplugs in cpu3, it will
call cpufreq_add_policy_cpu. on which it first stops userspace
governor, and then starts userspace governor.

Now if the sequence of above two cases interleaves, it becames
below sequence:

1) application stops userspace governor
2)                                      hotplug stops userspace governor
3) application starts ondemand governor
4)                                      hotplug starts a governor

in step 4, hotplug is supposed to start userspace governor, but now
the governor has been changed by application to ondemand, so hotplug
starts ondemand governor again !!!!

The solution is: do not allow stop one policy's governor multi-times
Governor stop should only do once for one policy, after it is stopped,
no other governor stop should be executed. also add one mutext to
protect __cpufreq_governor so governor operation can be kept in sequence.

Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
---
 drivers/cpufreq/cpufreq.c | 28 +++++++++++++++++++++++-----
 include/linux/cpufreq.h   |  1 +
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2d53f47..6c10cf0 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -46,6 +46,7 @@ static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
 static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
 #endif
 static DEFINE_RWLOCK(cpufreq_driver_lock);
+static DEFINE_MUTEX(cpufreq_governor_lock);
 
 /*
  * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
@@ -896,6 +897,8 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 		goto module_out;
 	}
 
+
+
 	policy = kzalloc(sizeof(struct cpufreq_policy), GFP_KERNEL);
 	if (!policy)
 		goto nomem_out;
@@ -1541,13 +1544,14 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 #else
 	struct cpufreq_governor *gov = NULL;
 #endif
-
+	mutex_lock(&cpufreq_governor_lock);
 	if (policy->governor->max_transition_latency &&
 	    policy->cpuinfo.transition_latency >
 	    policy->governor->max_transition_latency) {
-		if (!gov)
+		if (!gov) {
+			mutex_unlock(&cpufreq_governor_lock);
 			return -EINVAL;
-		else {
+		} else {
 			printk(KERN_WARNING "%s governor failed, too long"
 			       " transition latency of HW, fallback"
 			       " to %s governor\n",
@@ -1557,11 +1561,19 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 		}
 	}
 
-	if (!try_module_get(policy->governor->owner))
+	if (!try_module_get(policy->governor->owner)) {
+		mutex_unlock(&cpufreq_governor_lock);
 		return -EINVAL;
-
+	}
 	pr_debug("__cpufreq_governor for CPU %u, event %u\n",
 						policy->cpu, event);
+
+	if ((!policy->governor_enabled && (event == CPUFREQ_GOV_STOP)) ||
+	    (policy->governor_enabled && (event == CPUFREQ_GOV_START))) {
+		mutex_unlock(&cpufreq_governor_lock);
+		return -EBUSY;
+	}
+
 	ret = policy->governor->governor(policy, event);
 
 	if (!ret) {
@@ -1569,6 +1581,10 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 			policy->governor->initialized++;
 		else if (event == CPUFREQ_GOV_POLICY_EXIT)
 			policy->governor->initialized--;
+		else if (event == CPUFREQ_GOV_STOP)
+			policy->governor_enabled = 0;
+		else if (event == CPUFREQ_GOV_START)
+			policy->governor_enabled = 1;
 	}
 
 	/* we keep one module reference alive for
@@ -1578,6 +1594,8 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 	if ((event == CPUFREQ_GOV_STOP) && !ret)
 		module_put(policy->governor->owner);
 
+	mutex_unlock(&cpufreq_governor_lock);
+
 	return ret;
 }
 
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 037d36a..c12db73 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -107,6 +107,7 @@ struct cpufreq_policy {
 	unsigned int		policy; /* see above */
 	struct cpufreq_governor	*governor; /* see below */
 	void			*governor_data;
+	int			governor_enabled; /* governor start/stop flag */
 
 	struct work_struct	update; /* if update_policy() needs to be
 					 * called, but you're in IRQ context */
-- 
1.8.0

