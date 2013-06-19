Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab3FSHC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:02:57 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:52904 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995Ab3FSHCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:02:55 -0400
From: Xiaoguang Chen <chenxg@marvell.com>
To: <viresh.kumar@linaro.org>, <rjw@sisk.pl>
CC: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <njiang1@marvell.com>,
        <zjwu@marvell.com>, <ylmao@marvell.com>, <chenxg.marvell@gmail.com>,
        Xiaoguang Chen <chenxg@marvell.com>
Subject: [PATCH v9] Cpufreq: Fix governor start/stop race condition
Date: Wed, 19 Jun 2013 15:00:07 +0800
Message-ID: <1371625207-26702-1-git-send-email-chenxg@marvell.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cpufreq governor's stop and start operation should be kept in sequence.
If not, there will be unexpected behavior, for example:

There are 4 CPUs and policy->cpu=CPU0, CPU1/2/3 are linked to CPU0.
The normal sequence is as below:

1) Current governor is userspace, One application tries to set
governor to ondemand. It will call __cpufreq_set_policy in which it
will stop userspace governor and then start ondemand governor.

2) Current governor is userspace, Now CPU0 hotplugs in CPU3 (put CPU3 online),
It will call cpufreq_add_policy_cpu in which it first stops userspace
governor, and then starts userspace governor.

Now if the sequence of above two cases interleaves, It becomes like below:

1) Application stops userspace governor
2)                                      Hotplug stops userspace governor
3) Application starts ondemand governor
4)                                      Hotplug starts a governor

In step 4, Hotplug is supposed to start userspace governor, But now
the governor has been changed by application to ondemand, So hotplug
starts ondemand governor again !!!!

The solution is: Do not allow stop policy's governor multi-times.
Governor should only be stopped once for one policy, After it is stopped,
No other governor stop operation should be executed. also add one mutex to
protect __cpufreq_governor so governor operation can be kept in sequence.

Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 24 ++++++++++++++++++++++++
 include/linux/cpufreq.h   |  1 +
 2 files changed, 25 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2d53f47..6f5aa6f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -46,6 +46,7 @@ static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
 static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
 #endif
 static DEFINE_RWLOCK(cpufreq_driver_lock);
+static DEFINE_MUTEX(cpufreq_governor_lock);
 
 /*
  * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
@@ -1562,6 +1563,21 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 
 	pr_debug("__cpufreq_governor for CPU %u, event %u\n",
 						policy->cpu, event);
+
+	mutex_lock(&cpufreq_governor_lock);
+	if ((!policy->governor_enabled && (event == CPUFREQ_GOV_STOP)) ||
+	    (policy->governor_enabled && (event == CPUFREQ_GOV_START))) {
+		mutex_unlock(&cpufreq_governor_lock);
+		return -EBUSY;
+	}
+
+	if (event == CPUFREQ_GOV_STOP)
+		policy->governor_enabled = false;
+	else if (event == CPUFREQ_GOV_START)
+		policy->governor_enabled = true;
+
+	mutex_unlock(&cpufreq_governor_lock);
+
 	ret = policy->governor->governor(policy, event);
 
 	if (!ret) {
@@ -1569,6 +1585,14 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 			policy->governor->initialized++;
 		else if (event == CPUFREQ_GOV_POLICY_EXIT)
 			policy->governor->initialized--;
+	} else {
+		/* Restore original values */
+		mutex_lock(&cpufreq_governor_lock);
+		if (event == CPUFREQ_GOV_STOP)
+			policy->governor_enabled = true;
+		else if (event == CPUFREQ_GOV_START)
+			policy->governor_enabled = false;
+		mutex_unlock(&cpufreq_governor_lock);
 	}
 
 	/* we keep one module reference alive for
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 037d36a..1a81b74 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -107,6 +107,7 @@ struct cpufreq_policy {
 	unsigned int		policy; /* see above */
 	struct cpufreq_governor	*governor; /* see below */
 	void			*governor_data;
+	bool			governor_enabled; /* governor start/stop flag */
 
 	struct work_struct	update; /* if update_policy() needs to be
 					 * called, but you're in IRQ context */
-- 
1.8.0

