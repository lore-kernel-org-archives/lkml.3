Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab3CHNDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:03:48 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59184 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186Ab3CHNDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:03:47 -0500
Date: Fri, 8 Mar 2013 18:29:51 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Can we avoid sched:sched_migrate_task event being called twice
 from sched_fork()
Message-ID: <20130308125951.GA5669@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030813-7182-0000-0000-000005B3C0B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using sched:sched_migrate_tasks, its little awkward to see records that
suggest current task migrating from the current cpu to the same current cpu.

perf record -e sched:sched_migrate_task -af bash -c "ls;ps"; perf script

            perf  5292 [035] 347249.373741: sched:sched_migrate_task: comm=perf pid=5293 prio=120 orig_cpu=43 dest_cpu=34
    migration/34   144 [034] 347249.373938: sched:sched_migrate_task: comm=perf pid=5293 prio=120 orig_cpu=34 dest_cpu=43
         swapper     0 [035] 347249.375030: sched:sched_migrate_task: comm=rcu_sched pid=10 prio=120 orig_cpu=11 dest_cpu=35
            bash  5293 [043] 347249.377255: sched:sched_migrate_task: comm=bash pid=5293 prio=120 orig_cpu=43 dest_cpu=43     <---- 1
            bash  5293 [043] 347249.377580: sched:sched_migrate_task: comm=bash pid=5294 prio=120 orig_cpu=43 dest_cpu=51     <---- 2
    migration/51   231 [051] 347249.377888: sched:sched_migrate_task: comm=bash pid=5294 prio=120 orig_cpu=51 dest_cpu=59
         swapper     0 [043] 347249.380039: sched:sched_migrate_task: comm=rcu_sched pid=10 prio=120 orig_cpu=35 dest_cpu=43
           :5294  5294 [059] 347249.381911: sched:sched_migrate_task: comm=bash pid=5293 prio=120 orig_cpu=43 dest_cpu=58
            bash  5293 [058] 347249.382449: sched:sched_migrate_task: comm=bash pid=5293 prio=120 orig_cpu=58 dest_cpu=58     <---- 3
            bash  5293 [058] 347249.382995: sched:sched_migrate_task: comm=bash pid=5295 prio=120 orig_cpu=58 dest_cpu=3      <---- 4
     migration/3    20 [003] 347249.383351: sched:sched_migrate_task: comm=bash pid=5295 prio=120 orig_cpu=3 dest_cpu=11
    kworker/11:1   175 [011] 347249.419342: sched:sched_migrate_task: comm=tmux pid=10349 prio=120 orig_cpu=11 dest_cpu=10
           :5295  5295 [011] 347249.427053: sched:sched_migrate_task: comm=bash pid=5293 prio=120 orig_cpu=58 dest_cpu=10

If we look at reference 1 & 3 above, the orig_cpu and dest_cpu are the same.
Also from pid column and the recorded pid, we get an impression that the
current task is asking itself to be migrated from the current cpu on to the
current cpu. 

On fork/clone path, we set the cpu twice. The first time we do it from
sched_fork() (references 1 & 3) and then later in wake_up_new_task()
(references 2 & 4). 

However perf sw event migrations get accounted correctly.

perf stat numbers also indicate the same. (i.e lesser number of migrations
than the actual sched:sched_migrate_task)

perf stat -a -e sched:sched_migrate_task -e migrations bash -c "ls;ps"

 Performance counter stats for 'bash -c ls;ps':

                12 sched:sched_migrate_task                                     [100.00%]
                10 migrations                                                  

       0.052509285 seconds time elapsed

At the time of sched_fork(), even pid field of child is also not updated.
Further we are trying to set it to the parent's current cpu which should be
the same as the set in child, (copied from parent in dup_task_struct)

The child task wont run till wake_up_new_task() is called, and the
actual cpu setting happens at wake_up_new_task(). Can we avoid the trace
being called from the sched_fork() path?

The below patch tries to call __set_task_cpu() instead of set_task_cpu()
in sched_fork() and hence avoids calling the trace. 

Here are the results after we avoid trace_sched_migrate_task() from
sched_fork().

perf record -e sched:sched_migrate_task -af bash -c "ls;ps"; perf script 

    migration/19   104 [019]   406.931532: sched:sched_migrate_task: comm=perf pid=60217 prio=120 orig_cpu=19 dest_cpu=27
            bash 60217 [027]   406.939006: sched:sched_migrate_task: comm=bash pid=60218 prio=120 orig_cpu=27 dest_cpu=35
    migration/35   195 [035]   406.939515: sched:sched_migrate_task: comm=bash pid=60218 prio=120 orig_cpu=35 dest_cpu=43
         swapper     0 [027]   406.942050: sched:sched_migrate_task: comm=rcu_sched pid=10 prio=120 orig_cpu=19 dest_cpu=27
          :60218 60218 [043]   406.949920: sched:sched_migrate_task: comm=bash pid=60217 prio=120 orig_cpu=27 dest_cpu=42
            bash 60217 [042]   406.951489: sched:sched_migrate_task: comm=bash pid=60219 prio=120 orig_cpu=42 dest_cpu=51
    migration/51   289 [051]   406.951950: sched:sched_migrate_task: comm=bash pid=60219 prio=120 orig_cpu=51 dest_cpu=59
         swapper     0 [043]   406.988034: sched:sched_migrate_task: comm=rcu_sched pid=10 prio=120 orig_cpu=27 dest_cpu=43
          :60219 60219 [059]   407.051751: sched:sched_migrate_task: comm=bash pid=60217 prio=120 orig_cpu=42 dest_cpu=58

perf stat -a -e sched:sched_migrate_task -e migrations bash -c "ls;ps"

 Performance counter stats for 'bash -c ls;ps':

                17 sched:sched_migrate_task                                     [100.00%]
                17 migrations                                                  

       0.107531428 seconds time elapsed

Other options could be avoid setting the cpu from sched_fork or move the
trace_sched_migrate_task() in set_task_cpu() to where the perf sw migrations 
are accounted.

-- 
Thanks and Regards
Srikar

-----8<--------------------------------------------------------------
>From ac9df9bca38ce22c16f1e9b7949015c14257772c Mon Sep 17 00:00:00 2001
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Thu, 7 Mar 2013 23:40:50 -0800
Subject: [PATCH] sched: Avoid redundant trace_sched_migrate_task from sched_fork path.

On fork/clone, trace_sched_migrate_task gets called twice. The first call
tries to record the migration with the parent pid and the migration seems to
be from the current cpu to the same current cpu. Also the numbers from
sched:sched_migrate_task and migrations events may vary. 

Avoid duplicate migrate traces by calling __set_task_cpu instead of
set_task_cpu.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26058d0..bf1e62d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1660,7 +1660,7 @@ void sched_fork(struct task_struct *p)
 	 * Silence PROVE_RCU.
 	 */
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
-	set_task_cpu(p, cpu);
+	__set_task_cpu(p, cpu);
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)

