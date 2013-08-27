Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab3H0WBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 18:01:30 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43023 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab3H0WB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 18:01:28 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J . Wysocki" <rjw@sisk.pl>
Subject: [PATCH] cpufreq: Don't use smp_processor_id() in preemptible context
Date: Tue, 27 Aug 2013 15:01:24 -0700
Message-Id: <1377640884-16827-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1377629249-1177-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueues are preemptible even if works are queued on them with
queue_work_on(). Let's just use the policy->cpu argument here
instead of using smp_processor_id() to silence the warning.

BUG: using smp_processor_id() in preemptible [00000000] code: kworker/3:2/674
caller is gov_queue_work+0x28/0xb0
CPU: 0 PID: 674 Comm: kworker/3:2 Tainted: G        W    3.10.0 #30
Workqueue: events od_dbs_timer
[<c010c178>] (unwind_backtrace+0x0/0x11c) from [<c0109dec>] (show_stack+0x10/0x14)
[<c0109dec>] (show_stack+0x10/0x14) from [<c03885a4>] (debug_smp_processor_id+0xbc/0xf0)
[<c03885a4>] (debug_smp_processor_id+0xbc/0xf0) from [<c0635864>] (gov_queue_work+0x28/0xb0)
[<c0635864>] (gov_queue_work+0x28/0xb0) from [<c0635618>] (od_dbs_timer+0x108/0x134)
[<c0635618>] (od_dbs_timer+0x108/0x134) from [<c01aa8f8>] (process_one_work+0x25c/0x444)
[<c01aa8f8>] (process_one_work+0x25c/0x444) from [<c01aaf88>] (worker_thread+0x200/0x344)
[<c01aaf88>] (worker_thread+0x200/0x344) from [<c01b03bc>] (kthread+0xa0/0xb0)
[<c01b03bc>] (kthread+0xa0/0xb0) from [<c01061b8>] (ret_from_fork+0x14/0x3c)

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Also found this one. I'm tracking down a pretty bad hotplug/sysfs
race on 3.10. I've applied all the stable patches but I'm seeing this
still. I'll start another thread on this

WARNING: at kernel/mutex.c:341 __mutex_lock_slowpath+0x14c/0x410()
DEBUG_LOCKS_WARN_ON(l->magic != l)
Modules linked in:
CPU: 0 PID: 1960 Comm: sh Tainted: G        W    3.10.0 #32
[<c010c178>] (unwind_backtrace+0x0/0x11c) from [<c0109dec>] (show_stack+0x10/0x14)
[<c0109dec>] (show_stack+0x10/0x14) from [<c01904cc>] (warn_slowpath_common+0x4c/0x6c)
[<c01904cc>] (warn_slowpath_common+0x4c/0x6c) from [<c019056c>] (warn_slowpath_fmt+0x2c/0x3c)
[<c019056c>] (warn_slowpath_fmt+0x2c/0x3c) from [<c08a0334>] (__mutex_lock_slowpath+0x14c/0x410)
[<c08a0334>] (__mutex_lock_slowpath+0x14c/0x410) from [<c08a0618>] (mutex_lock+0x20/0x3c)
[<c08a0618>] (mutex_lock+0x20/0x3c) from [<c0636114>] (cpufreq_governor_dbs+0x568/0x5f8)
[<c0636114>] (cpufreq_governor_dbs+0x568/0x5f8) from [<c06325b0>] (__cpufreq_governor+0xdc/0x1a4)
[<c06325b0>] (__cpufreq_governor+0xdc/0x1a4) from [<c06328f0>] (__cpufreq_set_policy+0x278/0x2c0)
[<c06328f0>] (__cpufreq_set_policy+0x278/0x2c0) from [<c0632ea0>] (store_scaling_min_freq+0x80/0x9c)
[<c0632ea0>] (store_scaling_min_freq+0x80/0x9c) from [<c0633ae4>] (store+0x58/0x90)
[<c0633ae4>] (store+0x58/0x90) from [<c02a69d4>] (sysfs_write_file+0x100/0x148)
[<c02a69d4>] (sysfs_write_file+0x100/0x148) from [<c0255c18>] (vfs_write+0xcc/0x174)
[<c0255c18>] (vfs_write+0xcc/0x174) from [<c0255f70>] (SyS_write+0x38/0x64)
[<c0255f70>] (SyS_write+0x38/0x64) from [<c0106120>] (ret_fast_syscall+0x0/0x30)

 drivers/cpufreq/cpufreq_governor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index b9b20fd..523af48 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -137,7 +137,7 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
 		return;
 
 	if (!all_cpus) {
-		__gov_queue_work(smp_processor_id(), dbs_data, delay);
+		__gov_queue_work(policy->cpu, dbs_data, delay);
 	} else {
 		for_each_cpu(i, policy->cpus)
 			__gov_queue_work(i, dbs_data, delay);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

