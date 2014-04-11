Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422829AbaDKQJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:09:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759439AbaDKQHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:07:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xiaoguang Chen <chenxg@marvell.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 3.10 40/41] cpufreq: Fix governor start/stop race condition
Date: Fri, 11 Apr 2014 09:10:11 -0700
Message-Id: <20140411160935.906769115@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160932.865173041@linuxfoundation.org>
References: <20140411160932.865173041@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaoguang Chen <chenxg@marvell.com>

commit 95731ebb114c5f0c028459388560fc2a72fe5049 upstream.

Cpufreq governors' stop and start operations should be carried out
in sequence.  Otherwise, there will be unexpected behavior, like in
the example below.

Suppose there are 4 CPUs and policy->cpu=CPU0, CPU1/2/3 are linked
to CPU0.  The normal sequence is:

 1) Current governor is userspace.  An application tries to set the
    governor to ondemand.  It will call __cpufreq_set_policy() in
    which it will stop the userspace governor and then start the
    ondemand governor.

 2) Current governor is userspace.  The online of CPU3 runs on CPU0.
    It will call cpufreq_add_policy_cpu() in which it will first
    stop the userspace governor, and then start it again.

If the sequence of the above two cases interleaves, it becomes:

 1) Application stops userspace governor
 2)                                  Hotplug stops userspace governor

which is a problem, because the governor shouldn't be stopped twice
in a row.  What happens next is:

 3) Application starts ondemand governor
 4)                                  Hotplug starts a governor

In step 4, the hotplug is supposed to start the userspace governor,
but now the governor has been changed by the application to ondemand,
so the ondemand governor is started once again, which is incorrect.

The solution is to prevent policy governors from being stopped
multiple times in a row.  A governor should only be stopped once for
one policy.  After it has been stopped, no more governor stop
operations should be executed.

Also add a mutex to serialize governor operations.

[rjw: Changelog.  And you owe me a beverage of my choice.]
Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c |   24 ++++++++++++++++++++++++
 include/linux/cpufreq.h   |    1 +
 2 files changed, 25 insertions(+)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -46,6 +46,7 @@ static DEFINE_PER_CPU(struct cpufreq_pol
 static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
 #endif
 static DEFINE_RWLOCK(cpufreq_driver_lock);
+static DEFINE_MUTEX(cpufreq_governor_lock);
 
 /*
  * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
@@ -1563,6 +1564,21 @@ static int __cpufreq_governor(struct cpu
 
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
@@ -1570,6 +1586,14 @@ static int __cpufreq_governor(struct cpu
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
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -107,6 +107,7 @@ struct cpufreq_policy {
 	unsigned int		policy; /* see above */
 	struct cpufreq_governor	*governor; /* see below */
 	void			*governor_data;
+	bool			governor_enabled; /* governor start/stop flag */
 
 	struct work_struct	update; /* if update_policy() needs to be
 					 * called, but you're in IRQ context */


