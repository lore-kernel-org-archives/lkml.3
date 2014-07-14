Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbaGNPPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:15:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127AbaGNPPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:15:38 -0400
Date: Mon, 14 Jul 2014 17:13:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: Re: sched, timers: use after free in __lock_task_sighand when
	exiting a process
Message-ID: <20140714151331.GB8173@redhat.com>
References: <53C2FF4D.3020606@oracle.com> <53C31A34.8030500@oracle.com> <20140714090449.GL9918@twins.programming.kicks-ass.net> <20140714144953.GA8173@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714144953.GA8173@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm afraid I wasn't clear... Let me try again.

So yes, this "race" is of course possible:

	lock_task_sighand()				release_task()

	sighand = task->sighand;
							sighand = task->sighand;

							spin_lock(sighand->siglock);
							task->sighand = NULL;
							spin_unlcok(sighand->siglock);

							kmem_cache_free(sighand);

	spin_lock(sighand->siglock);

but this is fine. lock_task_sighand() will notice task->sighand == NULL
under ->siglock and fail.

SLAB_DESTROY_BY_RCU guarantees that this memory is still sighand_struct
even if it is freed (or even reallocated). spin_lock/spin_unlock is safe
because ->siglock initialized by sighand_ctor(). And until the caller of
lock_task_sighand() drops ->siglock kmem_cache_free() is not possible, the
task can't exit.

To remind, this is one of the reasons why rt_mutex_unlock() must be "atomic"
as spin_lock_t. Without the recent fix from tglx spin_unlock() (turned into
rt_mutex_unlock()) could play with the freed memory. Because, once "unlock"
makes another "lock" possible, the task can take this lock and free this
memory, but lock_task_sighand() can be called outside of rcu_read_lock().

On 07/14, Oleg Nesterov wrote:
>
> On 07/14, Peter Zijlstra wrote:
> >
> > On Sun, Jul 13, 2014 at 07:45:56PM -0400, Sasha Levin wrote:
> > >
> > > [  876.319044] ==================================================================
> > > [  876.319044] AddressSanitizer: use after free in do_raw_spin_unlock+0x4b/0x1a0 at addr ffff8803e48cec18
> > > [  876.319044] page:ffffea000f923380 count:0 mapcount:0 mapping:          (null) index:0x0
> > > [  876.319044] page flags: 0x2fffff80008000(tail)
> > > [  876.319044] page dumped because: kasan error
> > > [  876.319044] CPU: 26 PID: 8749 Comm: trinity-watchdo Tainted: G        W      3.16.0-rc4-next-20140711-sasha-00046-g07d3099-dirty #817
> > > [  876.319044]  00000000000000fb 0000000000000000 ffffea000f923380 ffff8805c417fc70
> > > [  876.319044]  ffffffff9de47068 ffff8805c417fd40 ffff8805c417fd30 ffffffff99426f5c
> > > [  876.319044]  0000000000000010 0000000000000000 ffff8805c417fc9d 66666620000000a8
> > > [  876.319044] Call Trace:
> > > [  876.319044] dump_stack (lib/dump_stack.c:52)
> > > [  876.319044] kasan_report_error (mm/kasan/report.c:98 mm/kasan/report.c:166)
> > > [  876.319044] __asan_load8 (mm/kasan/kasan.c:364)
> > > [  876.319044] do_raw_spin_unlock (./arch/x86/include/asm/current.h:14 kernel/locking/spinlock_debug.c:99 kernel/locking/spinlock_debug.c:158)
> > > [  876.319044] _raw_spin_unlock (include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
> > > [  876.319044] __lock_task_sighand (include/linux/rcupdate.h:858 kernel/signal.c:1285)
> > > [  876.319044] do_send_sig_info (kernel/signal.c:1191)
> > > [  876.319044] group_send_sig_info (kernel/signal.c:1304)
> > > [  876.319044] kill_pid_info (kernel/signal.c:1339)
> > > [  876.319044] SYSC_kill (kernel/signal.c:1423 kernel/signal.c:2900)
>
> Looks like a false alarm at first glance...
>
> > Oleg, what guarantees the RCU free of task-struct and sighand?
>
> > The only RCU I can find is delayed_put_task_struct() but that's not
> > often used.
>
> Yes, usually the code uses put_task_struct(). delayed_put_task_struct()
> acts almost as "if (dec_and_test(usage)) kfree_rcu(), but allows to use
> get_task_struct() if you observe this task under rcu_read_lock().
>
> Say,
> 	rcu_read_lock();
> 	task = find_task_by_vpid(...);
> 	if (task)
> 		get_task_struct(task);
> 	rcu_read_unlock();
>
> If release_task() used dec_and_test + kfree_rcu, the code above could
> not work.
>
> > TASK_DEAD etc. use regular put_task_struct() and that
> > doesn't seem to involve RCU.
>
> Yes, the task itself (or, depending ob pov, scheduler) has a reference.
> copy_process() does
>
> 	/*
> 	 * One for us, one for whoever does the "release_task()" (usually
> 	 * parent)
> 	 */
> 	atomic_set(&tsk->usage, 2);
>
> "us" actually means that put_task_struct(TASK_DEAD).
>
> As for ->sighand, note that sighand_cachep is SLAB_DESTROY_BY_RCU. So this
> memory is RCU free in a sense that it can't be returned to system, but it
> can be reused by another task. This is fine, lock_task_sighand() rechecks
> sighand == task->sighand under ->siglock.
>
> So perhaps this tool misinterprets kmem_cache_free(sighand_cachep) as use
> after free?
>
> We are going to add some comments into lock_task_sighand(). And cleanup it,
> it can look much simpler.
>
> Oleg.

