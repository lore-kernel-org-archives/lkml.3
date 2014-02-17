Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaBQRTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:19:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaBQRTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:19:04 -0500
Date: Mon, 17 Feb 2014 18:19:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>, Tejun Heo <tj@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: WARNING at kernel/workqueue.c:829 wq_worker_waking_up+0x53/0x70()
Message-ID: <20140217171900.GB29173@redhat.com>
References: <20140213124059.GA2908@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213124059.GA2908@krava.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13, Jiri Olsa wrote:
>
> hi,
> not sure you'd be interested nor if I can reproduce it,
> but got another workqueue warning
>
> jirka
>
> [ 4324.514324] ------------[ cut here ]------------
> [ 4324.514547] WARNING: CPU: 0 PID: 12 at kernel/workqueue.c:829 wq_worker_waking_up+0x53/0x70()
> [ 4324.514933] Modules linked in:
> [ 4324.515076] CPU: 0 PID: 12 Comm: migration/0 Tainted: G        W    3.13.0+ #213
> [ 4324.515411] Hardware name: Intel Corporation Montevina platform/To be filled by O.E.M., BIOS AMVACRB1.86C.0066.B00.0805070703 05/07/2008
> [ 4324.515966]  0000000000000009 ffff8800001c9b78 ffffffff81643b6a 0000000000000004
> [ 4324.516320]  0000000000000000 ffff8800001c9bb8 ffffffff81045a7c ffff88007a9d35c0
> [ 4324.516674]  0000000000000001 ffff88007a9d35c0 ffff8800751828f8 0000000000000086
> [ 4324.517027] Call Trace:
> [ 4324.517141]  [<ffffffff81643b6a>] dump_stack+0x4f/0x7c
> [ 4324.517374]  [<ffffffff81045a7c>] warn_slowpath_common+0x8c/0xc0
> [ 4324.517647]  [<ffffffff81045aca>] warn_slowpath_null+0x1a/0x20
> [ 4324.517912]  [<ffffffff810663f3>] wq_worker_waking_up+0x53/0x70
> [ 4324.518181]  [<ffffffff81079f09>] ttwu_do_activate.constprop.98+0x59/0x70
> [ 4324.518489]  [<ffffffff8107d99f>] try_to_wake_up+0x1cf/0x2e0
> [ 4324.518745]  [<ffffffff8107dac2>] default_wake_function+0x12/0x20
> [ 4324.519022]  [<ffffffff8108cad5>] __wake_up_common+0x55/0x90
> [ 4324.519279]  [<ffffffff8107a3f0>] ? __migrate_task+0x1a0/0x1a0
> [ 4324.519543]  [<ffffffff8108cb23>] __wake_up_locked+0x13/0x20
> [ 4324.519799]  [<ffffffff8108d4d2>] complete+0x42/0x60
> [ 4324.520024]  [<ffffffff8107a424>] ? migration_cpu_stop+0x34/0x40
> [ 4324.520297]  [<ffffffff810d207d>] cpu_stop_signal_done+0x2d/0x30
> [ 4324.520570]  [<ffffffff810d226f>] cpu_stopper_thread+0xaf/0x130
> [ 4324.520838]  [<ffffffff81092f0e>] ? put_lock_stats.isra.18+0xe/0x30
> [ 4324.521122]  [<ffffffff8164dded>] ? _raw_spin_unlock_irqrestore+0x6d/0x80
> [ 4324.521430]  [<ffffffff8107af61>] ? get_parent_ip+0x11/0x50
> [ 4324.521684]  [<ffffffff81074e91>] smpboot_thread_fn+0x1a1/0x2b0
> [ 4324.521952]  [<ffffffff81074cf0>] ? SyS_setgroups+0x150/0x150
> [ 4324.522213]  [<ffffffff8106db04>] kthread+0xe4/0x100
> [ 4324.522439]  [<ffffffff816498a8>] ? wait_for_common+0xd8/0x160
> [ 4324.522703]  [<ffffffff8106da20>] ? __init_kthread_worker+0x70/0x70
> [ 4324.522988]  [<ffffffff8165682c>] ret_from_fork+0x7c/0xb0
> [ 4324.523233]  [<ffffffff8106da20>] ? __init_kthread_worker+0x70/0x70
> [ 4324.523517] ---[ end trace 8659853860e530bc ]---

And with this debugging patch

	--- a/kernel/sched/core.c
	+++ b/kernel/sched/core.c
	@@ -2649,6 +2649,9 @@ pick_next_task(struct rq *rq)
	  *          - return from syscall or exception to user-space
	  *          - return from interrupt-handler to user-space
	  */
	+
	+void ret_from_sched(void);
	+
	 static void __sched __schedule(void)
	 {
		struct task_struct *prev, *next;
	@@ -2733,6 +2736,9 @@ need_resched:
		sched_preempt_enable_no_resched();
		if (need_resched())
			goto need_resched;
	+
	+	if (current->flags & PF_WQ_WORKER)
	+		ret_from_sched();
	 }
	 
	 static inline void sched_submit_work(struct task_struct *tsk)
	--- a/kernel/workqueue.c
	+++ b/kernel/workqueue.c
	@@ -108,6 +108,8 @@ enum {
		WQ_NAME_LEN		= 24,
	 };
	 
	+#define WQ_MARK		(1 << 10)
	+
	 /*
	  * Structure fields follow one of the following exclusion rules.
	  *
	@@ -826,11 +828,22 @@ void wq_worker_waking_up(struct task_struct *task, int cpu)
		struct worker *worker = kthread_data(task);
	 
		if (!(worker->flags & WORKER_NOT_RUNNING)) {
	-		WARN_ON_ONCE(worker->pool->cpu != cpu);
	+		if (worker->pool->cpu != cpu) {
	+			pr_crit("WARN: %d %s\n", worker->task->pid, worker->task->comm);
	+			worker->flags |= WQ_MARK;
	+		}
			atomic_inc(&worker->pool->nr_running);
		}
	 }
	 
	+void ret_from_sched(void)
	+{
	+	struct worker *worker = kthread_data(current);
	+
	+	if (WARN_ON(worker->flags & WQ_MARK))
	+		worker->flags &= ~WQ_MARK;
	+}
	+
	 /**
	  * wq_worker_sleeping - a worker is going to sleep
	  * @task: task going to sleep

Jiri got the following:

	[ 3438.192852] WARN: 29668 kworker/0:2
	[ 3438.193022] ------------[ cut here ]------------
	[ 3438.193391] ------------[ cut here ]------------
	[ 3438.193606] WARNING: CPU: 1 PID: 29668 at kernel/workqueue.c:843 ret_from_sched+0x38/0x50()
	[ 3438.193988] Modules linked in:
	[ 3438.194132] CPU: 1 PID: 29668 Comm: kworker/0:2 Tainted: G        W    3.13.0+ #238
	[ 3438.194491] Hardware name: Intel Corporation Montevina platform/To be filled by O.E.M., BIOS AMVACRB1.86C.0066.B00.0805070703 05/07/2008
	[ 3438.195055] Workqueue: events_freezable thermal_zone_device_check
	[ 3438.195350]  0000000000000009 ffff88007b5b94c8 ffffffff81642f0a 00000000000015c0
	[ 3438.195707]  0000000000000000 ffff88007b5b9508 ffffffff81045a7c ffff88007b5b94f8
	[ 3438.196064]  ffff88007a9d35c0 0000000000000000 ffff8800746b5a00 0000000000000001
	[ 3438.196426] Call Trace:
	[ 3438.196540]  [<ffffffff81642f0a>] dump_stack+0x4f/0x7c
	[ 3438.196775]  [<ffffffff81045a7c>] warn_slowpath_common+0x8c/0xc0
	[ 3438.197049]  [<ffffffff81045aca>] warn_slowpath_null+0x1a/0x20
	[ 3438.197327]  [<ffffffff81066448>] ret_from_sched+0x38/0x50
	[ 3438.197578]  [<ffffffff81647a9f>] __schedule+0x37f/0xb00
	[ 3438.197823]  [<ffffffff810951f5>] ? mark_held_locks+0x95/0x140
	[ 3438.198091]  [<ffffffff8164c795>] ? _raw_spin_lock_irqsave+0x25/0x90
	[ 3438.198389]  [<ffffffff816486de>] ? preempt_schedule_irq+0x3e/0x70
	[ 3438.198671]  [<ffffffff816486e4>] preempt_schedule_irq+0x44/0x70
	[ 3438.198943]  [<ffffffff8164da70>] retint_kernel+0x20/0x30
	[ 3438.199191]  [<ffffffff810a28eb>] ? vprintk_emit+0x18b/0x510
	[ 3438.199459]  [<ffffffff81066448>] ? ret_from_sched+0x38/0x50
	[ 3438.199718]  [<ffffffff816412a6>] printk+0x4d/0x4f
	[ 3438.199936]  [<ffffffff81066448>] ? ret_from_sched+0x38/0x50
	[ 3438.200199]  [<ffffffff81045a33>] warn_slowpath_common+0x43/0xc0
	[ 3438.200475]  [<ffffffff81045aca>] warn_slowpath_null+0x1a/0x20
	[ 3438.200740]  [<ffffffff81066448>] ret_from_sched+0x38/0x50
	[ 3438.200989]  [<ffffffff81647a9f>] __schedule+0x37f/0xb00
	[ 3438.201240]  [<ffffffff81097749>] ? __lock_acquire+0x479/0x21d0
	[ 3438.201510]  [<ffffffff8106642b>] ? ret_from_sched+0x1b/0x50
	[ 3438.201768]  [<ffffffff8100a9b5>] ? native_sched_clock+0x85/0xd0
	[ 3438.202042]  [<ffffffff816482e9>] schedule+0x29/0x70
	[ 3438.202273]  [<ffffffff8164715c>] schedule_timeout+0x19c/0x290
	[ 3438.202538]  [<ffffffff81092f5e>] ? put_lock_stats.isra.18+0xe/0x30
	[ 3438.202824]  [<ffffffff8164d1e0>] ? _raw_spin_unlock_irq+0x30/0x60
	[ 3438.203106]  [<ffffffff8107afb1>] ? get_parent_ip+0x11/0x50
	[ 3438.203368]  [<ffffffff8165172b>] ? preempt_count_sub+0x7b/0x100
	[ 3438.203642]  [<ffffffff81648c4d>] wait_for_common+0xcd/0x160
	[ 3438.203900]  [<ffffffff8107db00>] ? try_to_wake_up+0x2e0/0x2e0
	[ 3438.204165]  [<ffffffff81648cfd>] wait_for_completion+0x1d/0x20
	[ 3438.204441]  [<ffffffff810d27ca>] stop_one_cpu+0x6a/0x90
	[ 3438.204684]  [<ffffffff8107a440>] ? __migrate_task+0x1a0/0x1a0
	[ 3438.204949]  [<ffffffff8108d508>] ? complete+0x28/0x60
	[ 3438.205182]  [<ffffffff8107e159>] set_cpus_allowed_ptr+0x109/0x110
	[ 3438.205474]  [<ffffffff81303333>] acpi_processor_set_throttling+0x1b1/0x276
	[ 3438.205792]  [<ffffffff81304d45>] processor_set_cur_state+0x55/0x60
	[ 3438.206078]  [<ffffffff8147039d>] thermal_cdev_update+0x9d/0xc0
	[ 3438.206354]  [<ffffffff81471f21>] step_wise_throttle+0x61/0xa0
	[ 3438.206619]  [<ffffffff81470da3>] handle_thermal_trip+0x53/0x150
	[ 3438.218006]  [<ffffffff81470f25>] thermal_zone_device_update+0x75/0xb0
	[ 3438.229503]  [<ffffffff81471a55>] thermal_zone_device_check+0x15/0x20
	[ 3438.240967]  [<ffffffff810648ac>] process_one_work+0x1dc/0x660
	[ 3438.252429]  [<ffffffff81064842>] ? process_one_work+0x172/0x660
	[ 3438.263823]  [<ffffffff81065881>] worker_thread+0x121/0x380
	[ 3438.275116]  [<ffffffff8108d52d>] ? complete+0x4d/0x60
	[ 3438.286413]  [<ffffffff8164d17b>] ? _raw_spin_unlock_irqrestore+0x4b/0x80
	[ 3438.297786]  [<ffffffff81065760>] ? manage_workers.isra.25+0x2b0/0x2b0
	[ 3438.309004]  [<ffffffff8106db54>] kthread+0xe4/0x100
	[ 3438.319983]  [<ffffffff8165172b>] ? preempt_count_sub+0x7b/0x100
	[ 3438.330842]  [<ffffffff8106da70>] ? __init_kthread_worker+0x70/0x70
	[ 3438.341534]  [<ffffffff81655bac>] ret_from_fork+0x7c/0xb0
	[ 3438.352137]  [<ffffffff8106da70>] ? __init_kthread_worker+0x70/0x70
	[ 3438.362782] ---[ end trace 579ce178e4febac3 ]---

acpi_processor_set_throttling() plays with set_cpus_allowed_ptr(current),
this is obviously wrong, and the worker is bound.

Oleg.

