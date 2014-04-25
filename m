Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaDYHkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:40:42 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:35907 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaDYHkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:40:39 -0400
Message-ID: <1398411635.11930.45.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14-rt1
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Fri, 25 Apr 2014 09:40:35 +0200
In-Reply-To: <1397918766.5436.16.camel@marge.simpson.net>
References: <20140411185739.GA6644@linutronix.de>
	 <1397918766.5436.16.camel@marge.simpson.net>
Content-Type: multipart/mixed; boundary="=-h3JmYiVAlZaH6RJPq49k"
X-Mailer: Evolution 3.2.3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-h3JmYiVAlZaH6RJPq49k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Sat, 2014-04-19 at 16:46 +0200, Mike Galbraith wrote: 
> Hi Sebastian,
> 
> On Fri, 2014-04-11 at 20:57 +0200, Sebastian Andrzej Siewior wrote: 
> > Dear RT folks!
> > 
> > I'm pleased to announce the v3.14-rt1 patch set.
> 
> This hunk in hotplug-light-get-online-cpus.patch looks like a bug.
> 
> @@ -333,7 +449,7 @@ static int __ref _cpu_down(unsigned int
>                 /* CPU didn't die: tell everyone.  Can't complain. */
>                 smpboot_unpark_threads(cpu);
>                 cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
> -               goto out_release;
> +               goto out_cancel;
>         }
>         BUG_ON(cpu_online(cpu));

...

BTW, the reason I was eyeballing this stuff is because I was highly
interested in what you were going to do here...

# XXX stomp-machine-deal-clever-with-stopper-lock.patch

...with that bloody lglock.  What I did is attached for your amusement.
(warning: viewing may induce "Medussa" syndrome:)

Hotplug can still deadlock in rt trees too, and will if you beat it
hard.  The splat below is virgin 3.12-rt (where wonderful lock doesn't
yet exist) while running Stevens stress-cpu-hotplug.sh, which is still
plenty deadly when liberally applied.

[  161.951908] CPU0 attaching NULL sched-domain.
[  161.970417] CPU2 attaching NULL sched-domain.
[  161.976594] CPU3 attaching NULL sched-domain.
[  161.981044] CPU0 attaching sched-domain:
[  161.985010]  domain 0: span 0,3 level CPU
[  161.990627]   groups: 0 (cpu_power = 997) 3 (cpu_power = 1021)
[  162.000609] CPU3 attaching sched-domain:
[  162.007723]  domain 0: span 0,3 level CPU
[  162.012756]   groups: 3 (cpu_power = 1021) 0 (cpu_power = 997)
[  162.025533] smpboot: CPU 2 is now offline
[  162.036113] 
[  162.036114] ======================================================
[  162.036115] [ INFO: possible circular locking dependency detected ]
[  162.036116] 3.12.17-rt25 #14 Not tainted
[  162.036117] -------------------------------------------------------
[  162.036118] boot.kdump/6853 is trying to acquire lock:
[  162.036126]  (&hp->lock){+.+...}, at: [<ffffffff81044974>] pin_current_cpu+0x84/0x1d0
[  162.036126] 
[  162.036126] but task is already holding lock:
[  162.036131]  (&mm->mmap_sem){+++++.}, at: [<ffffffff8156285c>] __do_page_fault+0x14c/0x5d0
[  162.036132] 
[  162.036132] which lock already depends on the new lock.
[  162.036132] 
[  162.036133] 
[  162.036133] the existing dependency chain (in reverse order) is:
[  162.036135] 
[  162.036135] -> #2 (&mm->mmap_sem){+++++.}:
[  162.036138]        [<ffffffff810ae4a8>] check_prevs_add+0xf8/0x180
[  162.036140]        [<ffffffff810aeada>] validate_chain.isra.45+0x5aa/0x750
[  162.036142]        [<ffffffff810af4f6>] __lock_acquire+0x3f6/0x9f0
[  162.036143]        [<ffffffff810b01bc>] lock_acquire+0x8c/0x160
[  162.036146]        [<ffffffff8112df03>] might_fault+0x83/0xb0
[  162.036149]        [<ffffffff81341851>] sel_loadlut+0x11/0x70
[  162.036152]        [<ffffffff8134aa1d>] tioclinux+0x23d/0x2c0
[  162.036153]        [<ffffffff8133f88c>] vt_ioctl+0x86c/0x11f0
[  162.036155]        [<ffffffff81333cf8>] tty_ioctl+0x2a8/0x940
[  162.036158]        [<ffffffff8116c161>] do_vfs_ioctl+0x81/0x340
[  162.036159]        [<ffffffff8116c46b>] SyS_ioctl+0x4b/0x90
[  162.036162]        [<ffffffff81566c22>] system_call_fastpath+0x16/0x1b
[  162.036164] 
[  162.036164] -> #1 (console_lock){+.+.+.}:
[  162.036165]        [<ffffffff810ae4a8>] check_prevs_add+0xf8/0x180
[  162.036167]        [<ffffffff810aeada>] validate_chain.isra.45+0x5aa/0x750
[  162.036169]        [<ffffffff810af4f6>] __lock_acquire+0x3f6/0x9f0
[  162.036171]        [<ffffffff810b01bc>] lock_acquire+0x8c/0x160
[  162.036173]        [<ffffffff810957bf>] console_lock+0x6f/0x80
[  162.036174]        [<ffffffff8109673d>] console_cpu_notify+0x1d/0x30
[  162.036176]        [<ffffffff81562d3d>] notifier_call_chain+0x4d/0x70
[  162.036179]        [<ffffffff81070b49>] __raw_notifier_call_chain+0x9/0x10
[  162.036181]        [<ffffffff8104443b>] __cpu_notify+0x1b/0x30
[  162.036182]        [<ffffffff81044650>] cpu_notify_nofail+0x10/0x20
[  162.036185]        [<ffffffff815480fd>] _cpu_down+0x20d/0x440
[  162.036186]        [<ffffffff81548360>] cpu_down+0x30/0x50
[  162.036188]        [<ffffffff8137118c>] cpu_subsys_offline+0x1c/0x30
[  162.036191]        [<ffffffff8136c285>] device_offline+0x95/0xc0
[  162.036192]        [<ffffffff8136c390>] online_store+0x40/0x80
[  162.036194]        [<ffffffff813697c3>] dev_attr_store+0x13/0x30
[  162.036197]        [<ffffffff811c8820>] sysfs_write_file+0xf0/0x170
[  162.036200]        [<ffffffff8115a068>] vfs_write+0xc8/0x1d0
[  162.036202]        [<ffffffff8115a500>] SyS_write+0x50/0xa0
[  162.036203]        [<ffffffff81566c22>] system_call_fastpath+0x16/0x1b
[  162.036205] 
[  162.036205] -> #0 (&hp->lock){+.+...}:
[  162.036207]        [<ffffffff810ae39d>] check_prev_add+0x7bd/0x7d0
[  162.036209]        [<ffffffff810ae4a8>] check_prevs_add+0xf8/0x180
[  162.036210]        [<ffffffff810aeada>] validate_chain.isra.45+0x5aa/0x750
[  162.036212]        [<ffffffff810af4f6>] __lock_acquire+0x3f6/0x9f0
[  162.036214]        [<ffffffff810b01bc>] lock_acquire+0x8c/0x160
[  162.036216]        [<ffffffff8155e645>] rt_spin_lock+0x55/0x70
[  162.036218]        [<ffffffff81044974>] pin_current_cpu+0x84/0x1d0
[  162.036220]        [<ffffffff81079ef1>] migrate_disable+0x81/0x100
[  162.036222]        [<ffffffff8112fd38>] handle_pte_fault+0xf8/0x1c0
[  162.036223]        [<ffffffff81131646>] __handle_mm_fault+0x106/0x1b0
[  162.036225]        [<ffffffff81131712>] handle_mm_fault+0x22/0x30
[  162.036227]        [<ffffffff815628c1>] __do_page_fault+0x1b1/0x5d0
[  162.036229]        [<ffffffff81562ce9>] do_page_fault+0x9/0x10
[  162.036230]        [<ffffffff8155f9d2>] page_fault+0x22/0x30
[  162.036232]        [<ffffffff81566b0f>] ret_from_fork+0xf/0xb0
[  162.036233] 
[  162.036233] other info that might help us debug this:
[  162.036233] 
[  162.036235] Chain exists of:
[  162.036235]   &hp->lock --> console_lock --> &mm->mmap_sem
[  162.036235] 
[  162.036236]  Possible unsafe locking scenario:
[  162.036236] 
[  162.036236]        CPU0                    CPU1
[  162.036237]        ----                    ----
[  162.036238]   lock(&mm->mmap_sem);
[  162.036239]                                lock(console_lock);
[  162.036241]                                lock(&mm->mmap_sem);
[  162.036242]   lock(&hp->lock);
[  162.036242] 
[  162.036242]  *** DEADLOCK ***
[  162.036242] 
[  162.036243] 1 lock held by boot.kdump/6853:
[  162.036247]  #0:  (&mm->mmap_sem){+++++.}, at: [<ffffffff8156285c>] __do_page_fault+0x14c/0x5d0
[  162.036247] 
[  162.036247] stack backtrace:
[  162.036250] CPU: 0 PID: 6853 Comm: boot.kdump Not tainted 3.12.17-rt25 #14
[  162.036251] Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
[  162.036253]  ffff8801fd0e6d58 ffff8800bbe85918 ffffffff8155532c 0000000000000000
[  162.036255]  0000000000000000 ffff8800bbe85968 ffffffff8154d07f ffff8800bbe85958
[  162.036257]  ffffffff82350640 ffff8801fd0e6d58 ffff8801fd0e6d20 ffff8801fd0e6d58
[  162.036258] Call Trace:
[  162.036261]  [<ffffffff8155532c>] dump_stack+0x4f/0x91
[  162.036263]  [<ffffffff8154d07f>] print_circular_bug+0xd3/0xe4
[  162.036265]  [<ffffffff810ae39d>] check_prev_add+0x7bd/0x7d0
[  162.036268]  [<ffffffff8107e1f5>] ? sched_clock_local+0x25/0x90
[  162.036270]  [<ffffffff8107e388>] ? sched_clock_cpu+0xa8/0x120
[  162.036272]  [<ffffffff810ae4a8>] check_prevs_add+0xf8/0x180
[  162.036273]  [<ffffffff810aeada>] validate_chain.isra.45+0x5aa/0x750
[  162.036275]  [<ffffffff810af4f6>] __lock_acquire+0x3f6/0x9f0
[  162.036277]  [<ffffffff8155d9b1>] ? rt_spin_lock_slowlock+0x231/0x280
[  162.036279]  [<ffffffff8155d8b1>] ? rt_spin_lock_slowlock+0x131/0x280
[  162.036281]  [<ffffffff81044974>] ? pin_current_cpu+0x84/0x1d0
[  162.036282]  [<ffffffff810b01bc>] lock_acquire+0x8c/0x160
[  162.036284]  [<ffffffff81044974>] ? pin_current_cpu+0x84/0x1d0
[  162.036286]  [<ffffffff8155e645>] rt_spin_lock+0x55/0x70
[  162.036288]  [<ffffffff81044974>] ? pin_current_cpu+0x84/0x1d0
[  162.036289]  [<ffffffff81044974>] pin_current_cpu+0x84/0x1d0
[  162.036291]  [<ffffffff81079ef1>] migrate_disable+0x81/0x100
[  162.036293]  [<ffffffff8112fd38>] handle_pte_fault+0xf8/0x1c0
[  162.036295]  [<ffffffff8156285c>] ? __do_page_fault+0x14c/0x5d0
[  162.036296]  [<ffffffff81131646>] __handle_mm_fault+0x106/0x1b0
[  162.036298]  [<ffffffff81131712>] handle_mm_fault+0x22/0x30
[  162.036300]  [<ffffffff815628c1>] __do_page_fault+0x1b1/0x5d0
[  162.036302]  [<ffffffff8107e1f5>] ? sched_clock_local+0x25/0x90
[  162.036304]  [<ffffffff810790d1>] ? get_parent_ip+0x11/0x50
[  162.036306]  [<ffffffff81562f7d>] ? add_preempt_count.part.93+0x5d/0xb0
[  162.036307]  [<ffffffff810aa2c2>] ? get_lock_stats+0x22/0x70
[  162.036309]  [<ffffffff810aa7ce>] ? put_lock_stats.isra.26+0xe/0x40
[  162.036311]  [<ffffffff812841ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  162.036313]  [<ffffffff81562ce9>] do_page_fault+0x9/0x10
[  162.036315]  [<ffffffff8155f9d2>] page_fault+0x22/0x30
[  162.036317]  [<ffffffff81284130>] ? __put_user_4+0x20/0x30
[  162.036319]  [<ffffffff81078c47>] ? schedule_tail+0x67/0xb0
[  162.036321]  [<ffffffff81566b0f>] ret_from_fork+0xf/0xb0


--=-h3JmYiVAlZaH6RJPq49k
Content-Disposition: attachment; filename="stomp-machine-create-lg_global_trylock_relax.patch"
Content-Type: text/x-patch; name="stomp-machine-create-lg_global_trylock_relax.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 7bit

---
 include/linux/lglock.h      |    6 ++++++
 include/linux/spinlock_rt.h |    1 +
 kernel/locking/lglock.c     |   25 +++++++++++++++++++++++++
 kernel/locking/rtmutex.c    |    5 +++++
 4 files changed, 37 insertions(+)

--- a/include/linux/lglock.h
+++ b/include/linux/lglock.h
@@ -74,4 +74,10 @@ void lg_local_unlock_cpu(struct lglock *
 void lg_global_lock(struct lglock *lg);
 void lg_global_unlock(struct lglock *lg);
 
+#ifndef CONFIG_PREEMPT_RT_FULL
+#define lg_global_trylock_relax(name)	lg_global_lock(name)
+#else
+void lg_global_trylock_relax(struct lglock *lg);
+#endif
+
 #endif
--- a/include/linux/spinlock_rt.h
+++ b/include/linux/spinlock_rt.h
@@ -35,6 +35,7 @@ extern int atomic_dec_and_spin_lock(atom
  */
 extern void __lockfunc __rt_spin_lock(struct rt_mutex *lock);
 extern void __lockfunc __rt_spin_unlock(struct rt_mutex *lock);
+extern int __lockfunc __rt_spin_trylock(struct rt_mutex *lock);
 
 #define spin_lock(lock)				\
 	do {					\
--- a/kernel/locking/lglock.c
+++ b/kernel/locking/lglock.c
@@ -105,3 +105,28 @@ void lg_global_unlock(struct lglock *lg)
 	preempt_enable_nort();
 }
 EXPORT_SYMBOL(lg_global_unlock);
+
+#ifdef CONFIG_PREEMPT_RT_FULL
+/*
+ * HACK: If you use this, you get to keep the pieces.
+ * Used in queue_stop_cpus_work() when stop machinery
+ * is called from inactive CPU, so we can't schedule.
+ */
+# define lg_do_trylock_relax(l)			\
+	do {					\
+		while (!__rt_spin_trylock(l))	\
+			cpu_relax();		\
+	} while (0)
+
+void lg_global_trylock_relax(struct lglock *lg)
+{
+	int i;
+
+	lock_acquire_exclusive(&lg->lock_dep_map, 0, 0, NULL, _RET_IP_);
+	for_each_possible_cpu(i) {
+		lg_lock_ptr *lock;
+		lock = per_cpu_ptr(lg->lock, i);
+		lg_do_trylock_relax(lock);
+	}
+}
+#endif
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1001,6 +1001,11 @@ void __lockfunc rt_spin_unlock_wait(spin
 }
 EXPORT_SYMBOL(rt_spin_unlock_wait);
 
+int __lockfunc __rt_spin_trylock(struct rt_mutex *lock)
+{
+	return rt_mutex_trylock(lock);
+}
+
 int __lockfunc rt_spin_trylock(spinlock_t *lock)
 {
 	int ret = rt_mutex_trylock(&lock->lock);

--=-h3JmYiVAlZaH6RJPq49k
Content-Disposition: attachment; filename="stomp-machine-deal-clever-with-stopper-lock.patch"
Content-Type: text/x-patch; name="stomp-machine-deal-clever-with-stopper-lock.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 7bit

---
 kernel/stop_machine.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -266,7 +266,7 @@ int stop_two_cpus(unsigned int cpu1, uns
 	struct irq_cpu_stop_queue_work_info call_args;
 	struct multi_stop_data msdata;
 
-	preempt_disable();
+	preempt_disable_nort();
 	msdata = (struct multi_stop_data){
 		.fn = fn,
 		.data = arg,
@@ -299,7 +299,7 @@ int stop_two_cpus(unsigned int cpu1, uns
 	 * This relies on the stopper workqueues to be FIFO.
 	 */
 	if (!cpu_active(cpu1) || !cpu_active(cpu2)) {
-		preempt_enable();
+		preempt_enable_nort();
 		return -ENOENT;
 	}
 
@@ -313,7 +313,7 @@ int stop_two_cpus(unsigned int cpu1, uns
 				 &irq_cpu_stop_queue_work,
 				 &call_args, 1);
 	lg_local_unlock(&stop_cpus_lock);
-	preempt_enable();
+	preempt_enable_nort();
 
 	wait_for_stop_done(&done);
 
@@ -346,7 +346,7 @@ static DEFINE_PER_CPU(struct cpu_stop_wo
 
 static void queue_stop_cpus_work(const struct cpumask *cpumask,
 				 cpu_stop_fn_t fn, void *arg,
-				 struct cpu_stop_done *done)
+				 struct cpu_stop_done *done, bool inactive)
 {
 	struct cpu_stop_work *work;
 	unsigned int cpu;
@@ -360,11 +360,13 @@ static void queue_stop_cpus_work(const s
 	}
 
 	/*
-	 * Disable preemption while queueing to avoid getting
-	 * preempted by a stopper which might wait for other stoppers
-	 * to enter @fn which can lead to deadlock.
+	 * Make sure that all work is queued on all cpus before
+	 * any of the cpus can execute it.
 	 */
-	lg_global_lock(&stop_cpus_lock);
+	if (!inactive)
+		lg_global_lock(&stop_cpus_lock);
+	else
+		lg_global_trylock_relax(&stop_cpus_lock);
 	for_each_cpu(cpu, cpumask)
 		cpu_stop_queue_work(cpu, &per_cpu(stop_cpus_work, cpu));
 	lg_global_unlock(&stop_cpus_lock);
@@ -376,7 +378,7 @@ static int __stop_cpus(const struct cpum
 	struct cpu_stop_done done;
 
 	cpu_stop_init_done(&done, cpumask_weight(cpumask));
-	queue_stop_cpus_work(cpumask, fn, arg, &done);
+	queue_stop_cpus_work(cpumask, fn, arg, &done, false);
 	wait_for_stop_done(&done);
 	return done.executed ? done.ret : -ENOENT;
 }
@@ -572,6 +574,8 @@ static int __init cpu_stop_init(void)
 		INIT_LIST_HEAD(&stopper->works);
 	}
 
+	lg_lock_init(&stop_cpus_lock, "stop_cpus_lock");
+
 	BUG_ON(smpboot_register_percpu_thread(&cpu_stop_threads));
 	stop_machine_initialized = true;
 	return 0;
@@ -667,7 +671,7 @@ int stop_machine_from_inactive_cpu(int (
 	set_state(&msdata, MULTI_STOP_PREPARE);
 	cpu_stop_init_done(&done, num_active_cpus());
 	queue_stop_cpus_work(cpu_active_mask, multi_cpu_stop, &msdata,
-			     &done);
+			     &done, true);
 	ret = multi_cpu_stop(&msdata);
 
 	/* Busy wait for completion. */

--=-h3JmYiVAlZaH6RJPq49k--

