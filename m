Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412Ab3JQQvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:51:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45172 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758368Ab3JQQvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:51:12 -0400
Date: Thu, 17 Oct 2013 09:49:39 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-6acce3ef84520537f8a09a12c9ddbe814a584dd2@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        riel@redhat.com, rostedt@goodmis.org, akpm@linux-foundation.org,
        aarcange@redhat.com, oleg@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        srikar@linux.vnet.ibm.com, mgorman@suse.de
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, riel@redhat.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, aarcange@redhat.com, tglx@linutronix.de,
        oleg@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, srikar@linux.vnet.ibm.com, mgorman@suse.de
In-Reply-To: <20131011123820.GV3081@twins.programming.kicks-ass.net>
References: <20131011123820.GV3081@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove get_online_cpus() usage
Git-Commit-ID: 6acce3ef84520537f8a09a12c9ddbe814a584dd2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 17 Oct 2013 09:49:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6acce3ef84520537f8a09a12c9ddbe814a584dd2
Gitweb:     http://git.kernel.org/tip/6acce3ef84520537f8a09a12c9ddbe814a584dd2
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 11 Oct 2013 14:38:20 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Oct 2013 14:22:16 +0200

sched: Remove get_online_cpus() usage

Remove get_online_cpus() usage from the scheduler; there's 4 sites that
use it:

 - sched_init_smp(); where its completely superfluous since we're in
   'early' boot and there simply cannot be any hotplugging.

 - sched_getaffinity(); we already take a raw spinlock to protect the
   task cpus_allowed mask, this disables preemption and therefore
   also stabilizes cpu_online_mask as that's modified using
   stop_machine. However switch to active mask for symmetry with
   sched_setaffinity()/set_cpus_allowed_ptr(). We guarantee active
   mask stability by inserting sync_rcu/sched() into _cpu_down.

 - sched_setaffinity(); we don't appear to need get_online_cpus()
   either, there's two sites where hotplug appears relevant:
    * cpuset_cpus_allowed(); for the !cpuset case we use possible_mask,
      for the cpuset case we hold task_lock, which is a spinlock and
      thus for mainline disables preemption (might cause pain on RT).
    * set_cpus_allowed_ptr(); Holds all scheduler locks and thus has
      preemption properly disabled; also it already deals with hotplug
      races explicitly where it releases them.

 - migrate_swap(); we can make stop_two_cpus() do the heavy lifting for
   us with a little trickery. By adding a sync_sched/rcu() after the
   CPU_DOWN_PREPARE notifier we can provide preempt/rcu guarantees for
   cpu_active_mask. Use these to validate that both our cpus are active
   when queueing the stop work before we queue the stop_machine works
   for take_cpu_down().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20131011123820.GV3081@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/cpu.c          | 17 +++++++++++++++++
 kernel/sched/core.c   | 20 ++++++++++----------
 kernel/stop_machine.c | 26 +++++++++++++++++++++-----
 3 files changed, 48 insertions(+), 15 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index d7f07a2..63aa50d 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -308,6 +308,23 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	}
 	smpboot_park_threads(cpu);
 
+	/*
+	 * By now we've cleared cpu_active_mask, wait for all preempt-disabled
+	 * and RCU users of this state to go away such that all new such users
+	 * will observe it.
+	 *
+	 * For CONFIG_PREEMPT we have preemptible RCU and its sync_rcu() might
+	 * not imply sync_sched(), so explicitly call both.
+	 */
+#ifdef CONFIG_PREEMPT
+	synchronize_sched();
+#endif
+	synchronize_rcu();
+
+	/*
+	 * So now all preempt/rcu users must observe !cpu_active().
+	 */
+
 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a972acd..c06b8d3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1085,8 +1085,6 @@ int migrate_swap(struct task_struct *cur, struct task_struct *p)
 	struct migration_swap_arg arg;
 	int ret = -EINVAL;
 
-	get_online_cpus();
-
 	arg = (struct migration_swap_arg){
 		.src_task = cur,
 		.src_cpu = task_cpu(cur),
@@ -1097,6 +1095,10 @@ int migrate_swap(struct task_struct *cur, struct task_struct *p)
 	if (arg.src_cpu == arg.dst_cpu)
 		goto out;
 
+	/*
+	 * These three tests are all lockless; this is OK since all of them
+	 * will be re-checked with proper locks held further down the line.
+	 */
 	if (!cpu_active(arg.src_cpu) || !cpu_active(arg.dst_cpu))
 		goto out;
 
@@ -1109,7 +1111,6 @@ int migrate_swap(struct task_struct *cur, struct task_struct *p)
 	ret = stop_two_cpus(arg.dst_cpu, arg.src_cpu, migrate_swap_stop, &arg);
 
 out:
-	put_online_cpus();
 	return ret;
 }
 
@@ -3710,7 +3711,6 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	struct task_struct *p;
 	int retval;
 
-	get_online_cpus();
 	rcu_read_lock();
 
 	p = find_process_by_pid(pid);
@@ -3773,7 +3773,6 @@ out_free_cpus_allowed:
 	free_cpumask_var(cpus_allowed);
 out_put_task:
 	put_task_struct(p);
-	put_online_cpus();
 	return retval;
 }
 
@@ -3818,7 +3817,6 @@ long sched_getaffinity(pid_t pid, struct cpumask *mask)
 	unsigned long flags;
 	int retval;
 
-	get_online_cpus();
 	rcu_read_lock();
 
 	retval = -ESRCH;
@@ -3831,12 +3829,11 @@ long sched_getaffinity(pid_t pid, struct cpumask *mask)
 		goto out_unlock;
 
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
-	cpumask_and(mask, &p->cpus_allowed, cpu_online_mask);
+	cpumask_and(mask, &p->cpus_allowed, cpu_active_mask);
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
 out_unlock:
 	rcu_read_unlock();
-	put_online_cpus();
 
 	return retval;
 }
@@ -6494,14 +6491,17 @@ void __init sched_init_smp(void)
 
 	sched_init_numa();
 
-	get_online_cpus();
+	/*
+	 * There's no userspace yet to cause hotplug operations; hence all the
+	 * cpu masks are stable and all blatant races in the below code cannot
+	 * happen.
+	 */
 	mutex_lock(&sched_domains_mutex);
 	init_sched_domains(cpu_active_mask);
 	cpumask_andnot(non_isolated_cpus, cpu_possible_mask, cpu_isolated_map);
 	if (cpumask_empty(non_isolated_cpus))
 		cpumask_set_cpu(smp_processor_id(), non_isolated_cpus);
 	mutex_unlock(&sched_domains_mutex);
-	put_online_cpus();
 
 	hotcpu_notifier(sched_domains_numa_masks_update, CPU_PRI_SCHED_ACTIVE);
 	hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 32a6c44..c530bc5 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -234,11 +234,13 @@ static void irq_cpu_stop_queue_work(void *arg)
  */
 int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn, void *arg)
 {
-	int call_cpu;
 	struct cpu_stop_done done;
 	struct cpu_stop_work work1, work2;
 	struct irq_cpu_stop_queue_work_info call_args;
-	struct multi_stop_data msdata = {
+	struct multi_stop_data msdata;
+
+	preempt_disable();
+	msdata = (struct multi_stop_data){
 		.fn = fn,
 		.data = arg,
 		.num_threads = 2,
@@ -262,16 +264,30 @@ int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn, void *
 	set_state(&msdata, MULTI_STOP_PREPARE);
 
 	/*
+	 * If we observe both CPUs active we know _cpu_down() cannot yet have
+	 * queued its stop_machine works and therefore ours will get executed
+	 * first. Or its not either one of our CPUs that's getting unplugged,
+	 * in which case we don't care.
+	 *
+	 * This relies on the stopper workqueues to be FIFO.
+	 */
+	if (!cpu_active(cpu1) || !cpu_active(cpu2)) {
+		preempt_enable();
+		return -ENOENT;
+	}
+
+	/*
 	 * Queuing needs to be done by the lowest numbered CPU, to ensure
 	 * that works are always queued in the same order on every CPU.
 	 * This prevents deadlocks.
 	 */
-	call_cpu = min(cpu1, cpu2);
-
-	smp_call_function_single(call_cpu, &irq_cpu_stop_queue_work,
+	smp_call_function_single(min(cpu1, cpu2),
+				 &irq_cpu_stop_queue_work,
 				 &call_args, 0);
+	preempt_enable();
 
 	wait_for_completion(&done.completion);
+
 	return done.executed ? done.ret : -ENOENT;
 }
 
