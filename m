Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab3FLH1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 03:27:16 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:39033 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752280Ab3FLH1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 03:27:14 -0400
From: Xiaoguang Chen <chenxg@marvell.com>
To: <viresh.kumar@linaro.org>, <rjw@sisk.pl>
CC: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <njiang1@marvell.com>,
        <zjwu@marvell.com>, <ylmao@marvell.com>, <chenxg.marvell@gmail.com>,
        Xiaoguang Chen <chenxg@marvell.com>
Subject: [PATCH v3] cpufreq: fix governor start/stop race condition
Date: Wed, 12 Jun 2013 15:26:26 +0800
Message-ID: <1371021986-20985-1-git-send-email-chenxg@marvell.com>
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
no other governor stop should be executed.

Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
---
 drivers/cpufreq/cpufreq.c | 9 +++++++++
 include/linux/cpufreq.h   | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2d53f47..b4a2c94 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1562,6 +1562,11 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 
 	pr_debug("__cpufreq_governor for CPU %u, event %u\n",
 						policy->cpu, event);
+
+	if ((!policy->governor_enabled && (event == CPUFREQ_GOV_STOP)) ||
+	    (policy->governor_enabled && (event == CPUFREQ_GOV_START)))
+		return 0;
+
 	ret = policy->governor->governor(policy, event);
 
 	if (!ret) {
@@ -1569,6 +1574,10 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 			policy->governor->initialized++;
 		else if (event == CPUFREQ_GOV_POLICY_EXIT)
 			policy->governor->initialized--;
+		else if (event == CPUFREQ_GOV_STOP)
+			policy->governor_enabled = 0;
+		else if (event == CPUFREQ_GOV_START)
+			policy->governor_enabled = 1;
 	}
 
 	/* we keep one module reference alive for
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

