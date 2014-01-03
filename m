Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaACJU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 04:20:26 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15984 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096AbaACJUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 04:20:22 -0500
From: <jiel@marvell.com>
To: <rjw@rjwysocki.net>, <viresh.kumar@linaro.org>
CC: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jane Li <jiel@marvell.com>
Subject: [PATCH v4] cpufreq: Fix timer/workqueue corruption by protecting reading governor_enabled
Date: Fri, 3 Jan 2014 17:17:41 +0800
Message-ID: <1388740661-15011-1-git-send-email-jiel@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-03_03:2014-01-02,2014-01-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1401030005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jane Li <jiel@marvell.com>

When a CPU is hot removed we'll cancel all the delayed work items via
gov_cancel_work(). Sometimes the delayed work function determines that
it should adjust the delay for all other CPUs that the policy is
managing. If this scenario occurs, the canceling CPU will cancel its own
work but queue up the other CPUs works to run.

Commit 3617f2(cpufreq: Fix timer/workqueue corruption due to double
queueing) has tried to fix this, but reading governor_enabled is not
protected by cpufreq_governor_lock. Even though od_dbs_timer() checks
governor_enabled before gov_queue_work(), this scenario may occur. For
example:

 CPU0                                        CPU1
 ----                                        ----
 cpu_down()
  ...                                        <work runs>
  __cpufreq_remove_dev()                     od_dbs_timer()
   __cpufreq_governor()                       policy->governor_enabled
    policy->governor_enabled = false;
    cpufreq_governor_dbs()
     case CPUFREQ_GOV_STOP:
      gov_cancel_work(dbs_data, policy);
       cpu0 work is canceled
        timer is canceled
        cpu1 work is canceled
        <waits for cpu1>
                                              gov_queue_work(*, *, true);
                                               cpu0 work queued
                                               cpu1 work queued
                                               cpu2 work queued
                                               ...
        cpu1 work is canceled
        cpu2 work is canceled
        ...

At the end of the GOV_STOP case cpu0 still has a work queued to
run although the code is expecting all of the works to be
canceled. __cpufreq_remove_dev() will then proceed to
re-initialize all the other CPUs works except for the CPU that is
going down. The CPUFREQ_GOV_START case in cpufreq_governor_dbs()
will trample over the queued work and debugobjects will spit out
a warning:

WARNING: at lib/debugobjects.c:260 debug_print_object+0x94/0xbc()
ODEBUG: init active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x14
Modules linked in:
CPU: 1 PID: 1205 Comm: sh Tainted: G        W    3.10.0 #200
[<c01144f0>] (unwind_backtrace+0x0/0xf8) from [<c0111d98>] (show_stack+0x10/0x14)
[<c0111d98>] (show_stack+0x10/0x14) from [<c01272cc>] (warn_slowpath_common+0x4c/0x68)
[<c01272cc>] (warn_slowpath_common+0x4c/0x68) from [<c012737c>] (warn_slowpath_fmt+0x30/0x40)
[<c012737c>] (warn_slowpath_fmt+0x30/0x40) from [<c034c640>] (debug_print_object+0x94/0xbc)
[<c034c640>] (debug_print_object+0x94/0xbc) from [<c034c7f8>] (__debug_object_init+0xc8/0x3c0)
[<c034c7f8>] (__debug_object_init+0xc8/0x3c0) from [<c01360e0>] (init_timer_key+0x20/0x104)
[<c01360e0>] (init_timer_key+0x20/0x104) from [<c04872ac>] (cpufreq_governor_dbs+0x1dc/0x68c)
[<c04872ac>] (cpufreq_governor_dbs+0x1dc/0x68c) from [<c04833a8>] (__cpufreq_governor+0x80/0x1b0)
[<c04833a8>] (__cpufreq_governor+0x80/0x1b0) from [<c0483704>] (__cpufreq_remove_dev.isra.12+0x22c/0x380)
[<c0483704>] (__cpufreq_remove_dev.isra.12+0x22c/0x380) from [<c0692f38>] (cpufreq_cpu_callback+0x48/0x5c)
[<c0692f38>] (cpufreq_cpu_callback+0x48/0x5c) from [<c014fb40>] (notifier_call_chain+0x44/0x84)
[<c014fb40>] (notifier_call_chain+0x44/0x84) from [<c012ae44>] (__cpu_notify+0x2c/0x48)
[<c012ae44>] (__cpu_notify+0x2c/0x48) from [<c068dd40>] (_cpu_down+0x80/0x258)
[<c068dd40>] (_cpu_down+0x80/0x258) from [<c068df40>] (cpu_down+0x28/0x3c)
[<c068df40>] (cpu_down+0x28/0x3c) from [<c068e4c0>] (store_online+0x30/0x74)
[<c068e4c0>] (store_online+0x30/0x74) from [<c03a7308>] (dev_attr_store+0x18/0x24)
[<c03a7308>] (dev_attr_store+0x18/0x24) from [<c0256fe0>] (sysfs_write_file+0x100/0x180)
[<c0256fe0>] (sysfs_write_file+0x100/0x180) from [<c01fec9c>] (vfs_write+0xbc/0x184)
[<c01fec9c>] (vfs_write+0xbc/0x184) from [<c01ff034>] (SyS_write+0x40/0x68)
[<c01ff034>] (SyS_write+0x40/0x68) from [<c010e200>] (ret_fast_syscall+0x0/0x48)

In gov_queue_work(), lock cpufreq_governor_lock before gov_queue_work,
and unlock it after __gov_queue_work(). In this way, governor_enabled
is guaranteed not changed in gov_queue_work().

Signed-off-by: Jane Li <jiel@marvell.com>
---
 drivers/cpufreq/cpufreq.c          |    2 +-
 drivers/cpufreq/cpufreq_governor.c |    6 +++++-
 drivers/cpufreq/cpufreq_governor.h |    2 ++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 16d7b4a..185c9f5 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -39,7 +39,7 @@ static struct cpufreq_driver *cpufreq_driver;
 static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
 static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data_fallback);
 static DEFINE_RWLOCK(cpufreq_driver_lock);
-static DEFINE_MUTEX(cpufreq_governor_lock);
+DEFINE_MUTEX(cpufreq_governor_lock);
 static LIST_HEAD(cpufreq_policy_list);
 
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index e6be635..ba43991 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -119,8 +119,9 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
 {
 	int i;
 
+	mutex_lock(&cpufreq_governor_lock);
 	if (!policy->governor_enabled)
-		return;
+		goto out_unlock;
 
 	if (!all_cpus) {
 		/*
@@ -135,6 +136,9 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
 		for_each_cpu(i, policy->cpus)
 			__gov_queue_work(i, dbs_data, delay);
 	}
+
+out_unlock:
+	mutex_unlock(&cpufreq_governor_lock);
 }
 EXPORT_SYMBOL_GPL(gov_queue_work);
 
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index b5f2b86..bfb9ae1 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -257,6 +257,8 @@ static ssize_t show_sampling_rate_min_gov_pol				\
 	return sprintf(buf, "%u\n", dbs_data->min_sampling_rate);	\
 }
 
+extern struct mutex cpufreq_governor_lock;
+
 void dbs_check_cpu(struct dbs_data *dbs_data, int cpu);
 bool need_load_eval(struct cpu_dbs_common_info *cdbs,
 		unsigned int sampling_rate);
-- 
1.7.9.5

