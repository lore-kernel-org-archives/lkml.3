Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab3DDCDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:03:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:29737 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932881Ab3DDCDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:03:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="280534634"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: [patch v7 21/21] sched: make sure select_tas_rq_fair get a cpu
Date: Thu,  4 Apr 2013 10:01:02 +0800
Message-Id: <1365040862-8390-22-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Preeti U Murthy <preeti@linux.vnet.ibm.com>

Problem:

select_task_rq_fair() returns a target CPU/ waking CPU if no balancing is
required. However with the current power aware scheduling in this path, an
invalid CPU might be returned.

If get_cpu_for_power_policy() fails to find a new_cpu for the forked task,
then there is a possibility that the new_cpu could continue to be -1, till
the end of the select_task_rq_fair() if the search for a new cpu ahead in
this function also fails. Since this scenario is unexpected by
the callers of  select_task_rq_fair(),this needs to be fixed.

Fix:

Do not intermix the variables meant to reflect the target CPU of power save
and performance policies. If the target CPU of powersave is successful in being
found, return it. Else allow the performance policy to take a call on the
target CPU.

The above scenario was caught when a kernel crash resulted with a bad data access
interrupt, during a kernbench run on a 2 socket,16 core machine,with each core
having SMT-4

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3a0284b..142c1ee 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3529,6 +3529,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
+	int power_cpu = -1;
 	int want_affine = 0;
 	int sync = flags & WF_SYNC;
 	struct sd_lb_stats sds;
@@ -3560,16 +3561,16 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
 		if (tmp->flags & sd_flag) {
 			sd = tmp;
 
-			new_cpu = get_cpu_for_power_policy(sd, cpu, p, &sds,
+			power_cpu = get_cpu_for_power_policy(sd, cpu, p, &sds,
 						sd_flag & SD_BALANCE_WAKE);
-			if (new_cpu != -1)
+			if (power_cpu != -1)
 				goto unlock;
 		}
 	}
 
 	if (affine_sd) {
-		new_cpu = get_cpu_for_power_policy(affine_sd, cpu, p, &sds, 1);
-		if (new_cpu != -1)
+		power_cpu = get_cpu_for_power_policy(affine_sd, cpu, p, &sds, 1);
+		if (power_cpu != -1)
 			goto unlock;
 
 		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
@@ -3619,8 +3620,10 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
 	}
 unlock:
 	rcu_read_unlock();
+	if (power_cpu == -1)
+                return new_cpu;
 
-	return new_cpu;
+	return power_cpu;
 }
 
 /*
-- 
1.7.12

