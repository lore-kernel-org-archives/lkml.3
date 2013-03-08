Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab3CHUsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:48:41 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51137 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab3CHUsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:48:40 -0500
Message-ID: <513A4E8F.2020704@oracle.com>
Date: Fri, 08 Mar 2013 15:48:15 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130227 Thunderbird/17.0.3
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        paul.gortmaker@windriver.com, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: irq_work: WARNING: at kernel/irq_work.c:98 irq_work_needs_cpu+0x8a/0xb0()
References: <51397B96.7030008@oracle.com> <20130308164435.GI3268@linux.vnet.ibm.com> <513A2CF1.9060006@oracle.com> <20130308194608.GK3268@linux.vnet.ibm.com>
In-Reply-To: <20130308194608.GK3268@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 02:46 PM, Paul E. McKenney wrote:
> On Fri, Mar 08, 2013 at 01:24:49PM -0500, Sasha Levin wrote:
>> On 03/08/2013 11:44 AM, Paul E. McKenney wrote:
>>> On Fri, Mar 08, 2013 at 12:48:06AM -0500, Sasha Levin wrote:
>>>> Hi guys,
>>>>
>>>> While fuzzing with trinity inside a KVM tools guest it seemed to have hit the
>>>> new warning in kernel/irq_work.c:
>>>>
>>>> [  486.527075] ------------[ cut here ]------------
>>>> [  486.527788] WARNING: at kernel/irq_work.c:98 irq_work_needs_cpu+0x8a/0xb0()
>>>> [  486.528870] Modules linked in:
>>>> [  486.529377] Pid: 0, comm: swapper/2 Tainted: G        W    3.9.0-rc1-next-20130307-sasha-00047-g0a7d304-dirty #1037
>>>> [  486.530165] Call Trace:
>>>> [  486.530165]  [<ffffffff8110774c>] warn_slowpath_common+0x8c/0xc0
>>>> [  486.530165]  [<ffffffff81107795>] warn_slowpath_null+0x15/0x20
>>>> [  486.530165]  [<ffffffff811eadda>] irq_work_needs_cpu+0x8a/0xb0
>>>> [  486.530165]  [<ffffffff81174585>] tick_nohz_stop_sched_tick+0x95/0x2a0
>>>> [  486.530165]  [<ffffffff811749d9>] __tick_nohz_idle_enter+0x189/0x1b0
>>>> [  486.530165]  [<ffffffff81174ae1>] tick_nohz_idle_enter+0xa1/0xd0
>>>> [  486.530165]  [<ffffffff8106e4f7>] cpu_idle+0x77/0x180
>>>> [  486.530165]  [<ffffffff83d2e8ae>] ? setup_APIC_timer+0xc9/0xce
>>>> [  486.530165]  [<ffffffff83d2dea9>] start_secondary+0xe1/0xe8
>>>> [  486.530165] ---[ end trace dd075f5cfc2c4f26 ]---
>>>>
>>>> Obviously this was happening when trinity tried to exercise the shutdown syscall.
>>>>
>>>> It was followed by RCU choking and causing a bunch of locked tasks, preventing
>>>> shutdown. I guess it's the result of whatever caused this warning above to
>>>> happen, but in-case it isn't, the relevant parts of the RCU hang are:
>>>>
>>>> [  607.040283] INFO: task init:1 blocked for more than 120 seconds.
>>>> [  607.042932] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>> [  607.047046] init            D ffff8800ba308000  2736     1      0 0x00000000
>>>> [  607.050498]  ffff8800ba311b18 0000000000000002 0000000000000003 ffff8800ba308000
>>>> [  607.055110]  ffff8800ba310000 ffff8800ba310010 ffff8800ba311fd8 ffff8800ba310000
>>>> [  607.058208]  ffff8800ba310010 ffff8800ba311fd8 ffffffff8542c420 ffff8800ba308000
>>>> [  607.060611] Call Trace:
>>>> [  607.060847]  [<ffffffff83d38c85>] ? __mutex_lock_common+0x365/0x5d0
>>>> [  607.061462]  [<ffffffff83d3ad85>] schedule+0x55/0x60
>>>> [  607.061948]  [<ffffffff83d3b143>] schedule_preempt_disabled+0x13/0x20
>>>> [  607.062590]  [<ffffffff83d38cc5>] __mutex_lock_common+0x3a5/0x5d0
>>>> [  607.063209]  [<ffffffff811c2262>] ? rcu_cleanup_dead_cpu+0x52/0x250
>>>> [  607.063840]  [<ffffffff819e73b9>] ? free_cpumask_var+0x9/0x10
>>>> [  607.064453]  [<ffffffff811c2262>] ? rcu_cleanup_dead_cpu+0x52/0x250
>>>> [  607.065035]  [<ffffffff83d39020>] mutex_lock_nested+0x40/0x50
>>>> [  607.065606]  [<ffffffff811c2262>] rcu_cleanup_dead_cpu+0x52/0x250
>>>> [  607.066230]  [<ffffffff8117c2dd>] ? trace_hardirqs_on+0xd/0x10
>>>> [  607.066810]  [<ffffffff83d30f5e>] rcu_cpu_notify+0x1b4/0x1ef
>>>> [  607.067375]  [<ffffffff83d415ae>] notifier_call_chain+0xee/0x130
>>>> [  607.067975]  [<ffffffff8113cec9>] __raw_notifier_call_chain+0x9/0x10
>>>> [  607.068631]  [<ffffffff8110b5ab>] __cpu_notify+0x1b/0x30
>>>> [  607.069165]  [<ffffffff8110b5d0>] cpu_notify_nofail+0x10/0x30
>>>> [  607.069749]  [<ffffffff83d22605>] _cpu_down+0x185/0x2e0
>>>> [  607.070319]  [<ffffffff8110bd38>] disable_nonboot_cpus+0x88/0x1b0
>>>> [  607.070937]  [<ffffffff81125766>] kernel_restart+0x16/0x60
>>>> [  607.071487]  [<ffffffff8112594c>] SYSC_reboot+0x18c/0x2a0
>>>> [  607.072020]  [<ffffffff811c17e3>] ? rcu_cleanup_after_idle+0x23/0xf0
>>>> [  607.072635]  [<ffffffff811c1914>] ? rcu_eqs_exit_common+0x64/0x280
>>>> [  607.073251]  [<ffffffff811fd815>] ? user_exit+0xc5/0x100
>>>> [  607.073772]  [<ffffffff8117c2dd>] ? trace_hardirqs_on+0xd/0x10
>>>> [  607.074352]  [<ffffffff810725f3>] ? syscall_trace_enter+0x23/0x290
>>>> [  607.075054]  [<ffffffff81125a69>] SyS_reboot+0x9/0x10
>>>> [  607.075495]  [<ffffffff83d45c10>] tracesys+0xdd/0xe2
>>>> [  607.075967] 4 locks held by init/1:
>>>> [  607.076439]  #0:  (reboot_mutex){+.+.+.}, at: [<ffffffff811258a6>] SYSC_reboot+0xe6/0x2a0
>>>> [  607.077276]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8110b602>] cpu_maps_update_begin+0x12/0x20
>>>> [  607.078288]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8110b6f7>] cpu_hotplug_begin+0x27/0x60
>>>> [  607.079260]  #3:  (rcu_preempt_state.onoff_mutex){+.+...}, at: [<ffffffff811c2262>] rcu_cleanup_dead_cpu+0x52/0x250
>>>>
>>>> [  607.187177] rcu_preempt     D ffff8800aa8884a8  5136    11      2 0x00000000
>>>> [  607.187890]  ffff8800ba391c08 0000000000000002 ffff8800ba391bb8 000000078117e00a
>>>> [  607.188674]  ffff8800ba390000 ffff8800ba390010 ffff8800ba391fd8 ffff8800ba390000
>>>> [  607.189472]  ffff8800ba390010 ffff8800ba391fd8 ffff8800ba308000 ffff8800ba388000
>>>> [  607.190581] Call Trace:
>>>> [  607.190849]  [<ffffffff83d3ad85>] schedule+0x55/0x60
>>>> [  607.191336]  [<ffffffff83d381c6>] schedule_timeout+0x276/0x2c0
>>>> [  607.191904]  [<ffffffff81119e40>] ? lock_timer_base+0x70/0x70
>>>> [  607.192460]  [<ffffffff83d38229>] schedule_timeout_uninterruptible+0x19/0x20
>>>> [  607.193132]  [<ffffffff811c61d8>] rcu_gp_init+0x438/0x490
>>>> [  607.193646]  [<ffffffff8117c2dd>] ? trace_hardirqs_on+0xd/0x10
>>>> [  607.194216]  [<ffffffff811c62ec>] rcu_gp_kthread+0xbc/0x2d0
>>>> [  607.194760]  [<ffffffff811c6230>] ? rcu_gp_init+0x490/0x490
>>>> [  607.195298]  [<ffffffff81136570>] ? wake_up_bit+0x40/0x40
>>>> [  607.195823]  [<ffffffff811c6230>] ? rcu_gp_init+0x490/0x490
>>>> [  607.196364]  [<ffffffff81135b72>] kthread+0xe2/0xf0
>>>> [  607.196842]  [<ffffffff8117e00a>] ? __lock_release+0x1da/0x1f0
>>>> [  607.197405]  [<ffffffff81135a90>] ? __init_kthread_worker+0x70/0x70
>>>> [  607.198022]  [<ffffffff83d4593c>] ret_from_fork+0x7c/0xb0
>>>> [  607.198559]  [<ffffffff81135a90>] ? __init_kthread_worker+0x70/0x70
>>>>
>>>> [  609.414891] Showing all locks held in the system:
>>>> [  609.415490] 4 locks held by init/1:
>>>> [  609.415836]  #0:  (reboot_mutex){+.+.+.}, at: [<ffffffff811258a6>] SYSC_reboot+0xe6/0x2a0
>>>> [  609.416708]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8110b602>] cpu_maps_update_begin+0x12/0x20
>>>> [  609.417712]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8110b6f7>] cpu_hotplug_begin+0x27/0x60
>>>> [  609.418668]  #3:  (rcu_preempt_state.onoff_mutex){+.+...}, at: [<ffffffff811c2262>] rcu_cleanup_dead_cpu+0x52/0x250
>>>> [  609.419819] 1 lock held by rcu_preempt/11:
>>>> [  609.420277]  #0:  (rcu_preempt_state.onoff_mutex){+.+...}, at: [<ffffffff811c5f09>] rcu_gp_init+0x169/0x490
>>>> [  609.421391] 2 locks held by khungtaskd/3087:
>>>> [  609.421811]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff811b0cec>] check_hung_uninterruptible_tasks+0x3c/0x390
>>>> [  609.422867]  #1:  (tasklist_lock){.+.+..}, at: [<ffffffff811791ac>] debug_show_all_locks+0x5c/0x270
>>>> [  609.423841] 2 locks held by sh/7108:
>>>> [  609.424199]  #0:  (&tty->ldisc_sem){.+.+.+}, at: [<ffffffff81c1b03f>] tty_ldisc_ref_wait+0x1f/0x50
>>>> [  609.425134]  #1:  (&ldata->atomic_read_lock){+.+...}, at: [<ffffffff81c1772e>] n_tty_read+0x31e/0x980
>>>>
>>>> It looks like rcu_gp_init() went sleeping with the onoff_mutex held and
>>>> never got it's wakeup, while the rcu_cleanup_dead_cpu() code is waiting
>>>> to grab on that mutex.
>>>
>>> If your workload was busy enough with enough non-SCHED_OTHER activity
>>> that SCHED_OTHER tasks (like RCU's grace-period kthread) don't get to
>>> run, this is expected behavior.  If this is reproducible, could you
>>> please try using chrt to increase that kthread's priority?
>>
>> I've tried bumping all the rcu gp related threads before trinity starts, but
>> it still didn't help - got the same hang.
>>
>> Also, it's always comes after that IRQ warning, and when it happens it doesn't
>> look like the vm is doing anything else - the cpu usage (on the host) drops and
>> it seems like it's just waiting.
> 
> So you have CONFIG_PROVE_RCU_DELAY=y, right?  Otherwise, I am at a loss to
> explain why rcu_gp_init() is calling schedule_timeout_uninterruptible().
> Which is fair enough, as even if you do have CONFIG_PROVE_RCU_DELAY=y,
> I am at a loss to explain why schedule_timeout_uninterruptible() doesn't
> return after two jiffies.

Indeed I do.

> Ah, but why trust the stack trace?  We certainly should not trust the
> list of held locks, given that it shows two separate tasks holding
> rcu_preempt_state.onoff_mutex!!!  That would be bad...

I think that the case here is that the GP thread is holding on to the
onoff_mutex, and the rcu_cpu_notify thread is trying to acquire it. Since
lockdep marks locks as held before they are actually acquired this is
why you see 2 threads "holding" the lock.

> But it is legitimate if the rcu_preempt_state.onoff_mutex is simply being
> acquired and released in quick succession.  Which seems unlikely, because
> there are only so many CPUs to offline.  Besides, the offlining has been
> reportedly held up for 120 seconds.
> 
>> btw, wouldn't the same thing happen even when the vm isn't going for a reboot
>> if it was a priority issue?
> 
> Indeed, one nagging concern is that the RCU grace-period kthreads might be
> prevented from executing by a very heavy workload.  I do have some ideas
> on how to deal with that, but would rather see it really happen first.
> Speculative engineering has its benefits, but...  ;-)
> 
> Does lockdep show anything?

The lockdep spew I have is what I've attached at the bottom of the original
report, it suggests that the problem indeed looks like what I've described
above.


Thanks,
Sasha

