Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab3JKMix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:38:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36891 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3JKMiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:38:51 -0400
Date: Fri, 11 Oct 2013 14:38:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131011123820.GV3081@twins.programming.kicks-ass.net>
References: <20131010145738.GA5167@gmail.com>
 <20131010152612.GA13375@redhat.com>
 <20131010090044.7f12ddaf.akpm@linux-foundation.org>
 <20131010123631.1be60315@gandalf.local.home>
 <20131010094355.6f75e5a2.akpm@linux-foundation.org>
 <20131010165337.GT3081@twins.programming.kicks-ass.net>
 <20131010131305.58558079@gandalf.local.home>
 <20131010104856.8f042977112d5ac2693973ae@linux-foundation.org>
 <20131010183409.GP13848@laptop.programming.kicks-ass.net>
 <CA+55aFyoP5KFUg44Xenp_Jz0_5ssosn-KF6LDsa0qsmCjyJ56g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyoP5KFUg44Xenp_Jz0_5ssosn-KF6LDsa0qsmCjyJ56g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 11:49:15AM -0700, Linus Torvalds wrote:
> On Thu, Oct 10, 2013 at 11:34 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > But my point is that even though there aren't many of these today; with
> > the growing number of cpus in 'commodity' hardware you want to move away
> > from using preempt_disable() as hotplug lock.
> 
> Umm.
> 
> Wasn't this pretty much the argument for the COMPLETELY F*CKED UP
> change to make the vma locking use a semaphore?

Not entirely; but fair enough, I did screw up there.

> The whole "it's more convenient to use sleeping locks" argument is
> PURE AND UTTER SHIT when it comes to really core code. We are *much*
> better off saying "this is core, we care so deeply about performance
> that you had better use your brain before you do this".
> 
> Seriously. Your argument is bad, but more importantly, it is
> *dangerously* bad. It's crap that results in bad code: and the bad
> code is almost impossible to fix up later, because once you encourage
> people to do the easy thing, they'll do so.

Right, I fell face first into this trap. The existence of
{get,put}_online_cpus() made me stop thinking and use it.

As a penance I'll start by removing all get_online_cpus() usage from the
scheduler.

---
Subject: sched: Remove get_online_cpus() usage

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
---
 kernel/cpu.c          | 17 +++++++++++++++++
 kernel/sched/core.c   | 20 ++++++++++----------
 kernel/stop_machine.c | 26 +++++++++++++++++++++-----
 3 files changed, 48 insertions(+), 15 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index d7f07a2da5a6..63aa50d7ce1e 100644
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
index 0c3feebcf112..498a5e5a53f5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1081,8 +1081,6 @@ int migrate_swap(struct task_struct *cur, struct task_struct *p)
 	struct migration_swap_arg arg;
 	int ret = -EINVAL;
 
-	get_online_cpus();
-
 	arg = (struct migration_swap_arg){
 		.src_task = cur,
 		.src_cpu = task_cpu(cur),
@@ -1093,6 +1091,10 @@ int migrate_swap(struct task_struct *cur, struct task_struct *p)
 	if (arg.src_cpu == arg.dst_cpu)
 		goto out;
 
+	/*
+	 * These three tests are all lockless; this is OK since all of them
+	 * will be re-checked with proper locks held further down the line.
+	 */
 	if (!cpu_active(arg.src_cpu) || !cpu_active(arg.dst_cpu))
 		goto out;
 
@@ -1105,7 +1107,6 @@ int migrate_swap(struct task_struct *cur, struct task_struct *p)
 	ret = stop_two_cpus(arg.dst_cpu, arg.src_cpu, migrate_swap_stop, &arg);
 
 out:
-	put_online_cpus();
 	return ret;
 }
 
@@ -3706,7 +3707,6 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	struct task_struct *p;
 	int retval;
 
-	get_online_cpus();
 	rcu_read_lock();
 
 	p = find_process_by_pid(pid);
@@ -3769,7 +3769,6 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	free_cpumask_var(cpus_allowed);
 out_put_task:
 	put_task_struct(p);
-	put_online_cpus();
 	return retval;
 }
 
@@ -3814,7 +3813,6 @@ long sched_getaffinity(pid_t pid, struct cpumask *mask)
 	unsigned long flags;
 	int retval;
 
-	get_online_cpus();
 	rcu_read_lock();
 
 	retval = -ESRCH;
@@ -3827,12 +3825,11 @@ long sched_getaffinity(pid_t pid, struct cpumask *mask)
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
@@ -6490,14 +6487,17 @@ void __init sched_init_smp(void)
 
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
index 32a6c44d8f78..a6eb6d519284 100644
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
+	msdata = (struct multi_stop_date){
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
 
