Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965312AbaDJDc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:32:29 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30607 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758323AbaDJDcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:32:22 -0400
Message-ID: <534610A4.5000302@oracle.com>
Date: Wed, 09 Apr 2014 23:31:48 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Michael wang <wangyun@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: hang in migrate_swap
References: <5304F32A.4040907@oracle.com> <5305856F.3000109@linux.vnet.ibm.com> <53078241.3060201@oracle.com> <53080122.609@linux.vnet.ibm.com> <530ABB44.5000601@oracle.com> <530AD653.3000808@linux.vnet.ibm.com> <20140224071028.GW9987@twins.programming.kicks-ass.net> <530B1B80.4000307@linux.vnet.ibm.com> <20140224121218.GR15586@twins.programming.kicks-ass.net>
In-Reply-To: <20140224121218.GR15586@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 07:12 AM, Peter Zijlstra wrote:
> Subject: sched: Guarantee task priority in pick_next_task()
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri Feb 14 12:25:08 CET 2014
> 
> Michael spotted that the idle_balance() push down created a task
> priority problem.
> 
> Previously, when we called idle_balance() before pick_next_task() it
> wasn't a problem when -- because of the rq->lock droppage -- an rt/dl
> task slipped in.
> 
> Similarly for pre_schedule(), rt pre-schedule could have a dl task
> slip in.
> 
> But by pulling it into the pick_next_task() loop, we'll not try a
> higher task priority again.
> 
> Cure this by creating a re-start condition in pick_next_task(); and
> triggering this from pick_next_task_{rt,fair}().
> 
> Fixes: 38033c37faab ("sched: Push down pre_schedule() and idle_balance()")
> Cc: Juri Lelli <juri.lelli@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Reported-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

I'd like to re-open this issue. It seems that something broke and I'm
now seeing the same issues that have gone away 2 months with this patch
again.

Stack trace is similar to before:

[ 6004.990292] CPU: 20 PID: 26054 Comm: trinity-c58 Not tainted 3.14.0-next-20140409-sasha-00022-g984f7c5-dirty #385
[ 6004.990292] task: ffff880375bb3000 ti: ffff88036058e000 task.ti: ffff88036058e000
[ 6004.990292] RIP: generic_exec_single (kernel/smp.c:91 kernel/smp.c:175)
[ 6004.990292] RSP: 0000:ffff88036058f978  EFLAGS: 00000202
[ 6004.990292] RAX: ffff8802b71dec00 RBX: ffff88036058f978 RCX: ffff8802b71decd8
[ 6004.990292] RDX: ffff8802b71d85c0 RSI: ffff88036058f978 RDI: ffff88036058f978
[ 6004.990292] RBP: ffff88036058f9c8 R08: 0000000000000001 R09: ffffffffa70bc580
[ 6004.990292] R10: ffff880375bb3000 R11: 0000000000000000 R12: 000000000000000c
[ 6004.990292] R13: 0000000000000001 R14: ffff88036058fa20 R15: ffffffffa121f560
[ 6004.990292] FS:  00007fe993fbd700(0000) GS:ffff880437000000(0000) knlGS:0000000000000000
[ 6004.990292] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6004.990292] CR2: 00007fffb56b0a18 CR3: 00000003755df000 CR4: 00000000000006a0
[ 6004.990292] DR0: 0000000000695000 DR1: 0000000000695000 DR2: 0000000000000000
[ 6004.990292] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[ 6004.990292] Stack:
[ 6004.990292]  ffff88040513da18 ffffffffa121f560 ffff88036058fa20 0000000000000002
[ 6004.990292]  000000000000000c 000000000000000c ffffffffa121f560 ffff88036058fa20
[ 6004.990292]  0000000000000001 ffff880189fe3000 ffff88036058fa08 ffffffffa11ff7b2
[ 6004.990292] Call Trace:
[ 6004.990292] ? cpu_stop_queue_work (kernel/stop_machine.c:227)
[ 6004.990292] ? cpu_stop_queue_work (kernel/stop_machine.c:227)
[ 6004.990292] smp_call_function_single (kernel/smp.c:234 (discriminator 7))
[ 6004.990292] ? lg_local_lock (kernel/locking/lglock.c:25)
[ 6004.990292] stop_two_cpus (kernel/stop_machine.c:297)
[ 6004.990292] ? retint_restore_args (arch/x86/kernel/entry_64.S:1040)
[ 6004.990292] ? __stop_cpus (kernel/stop_machine.c:170)
[ 6004.990292] ? __stop_cpus (kernel/stop_machine.c:170)
[ 6004.990292] ? __migrate_swap_task (kernel/sched/core.c:1042)
[ 6004.990292] migrate_swap (kernel/sched/core.c:1110)
[ 6004.990292] task_numa_migrate (kernel/sched/fair.c:1321)
[ 6004.990292] ? task_numa_migrate (kernel/sched/fair.c:1227)
[ 6004.990292] ? sched_clock_cpu (kernel/sched/clock.c:311)
[ 6004.990292] numa_migrate_preferred (kernel/sched/fair.c:1342)
[ 6004.990292] task_numa_fault (kernel/sched/fair.c:1796)
[ 6004.990292] __handle_mm_fault (mm/memory.c:3812 mm/memory.c:3812 mm/memory.c:3925)
[ 6004.990292] ? __const_udelay (arch/x86/lib/delay.c:126)
[ 6004.990292] ? __rcu_read_unlock (kernel/rcu/update.c:97)
[ 6004.990292] handle_mm_fault (include/linux/memcontrol.h:147 mm/memory.c:3951)
[ 6004.990292] __do_page_fault (arch/x86/mm/fault.c:1220)
[ 6004.990292] ? vtime_account_user (kernel/sched/cputime.c:687)
[ 6004.990292] ? get_parent_ip (kernel/sched/core.c:2472)
[ 6004.990292] ? context_tracking_user_exit (include/linux/vtime.h:89 include/linux/jump_label.h:105 include/trace/events/context_tracking.h:47 kernel/context_tracking.c:178)
[ 6004.990292] ? preempt_count_sub (kernel/sched/core.c:2527)
[ 6004.990292] ? context_tracking_user_exit (kernel/context_tracking.c:182)
[ 6004.990292] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[ 6004.990292] ? trace_hardirqs_off_caller (kernel/locking/lockdep.c:2638 (discriminator 2))
[ 6004.990292] do_page_fault (arch/x86/mm/fault.c:1272 include/linux/jump_label.h:105 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:45 arch/x86/mm/fault.c:1273)
[ 6004.990292] do_async_page_fault (arch/x86/kernel/kvm.c:263)
[ 6004.990292] async_page_fault (arch/x86/kernel/entry_64.S:1496)
[ 6004.990292] Code: 44 89 e7 ff 15 70 2d c5 04 45 85 ed 75 0b 31 c0 eb 27 0f 1f 80 00 00 00 00 f6 43 18 01 74 ef 66 2e 0f 1f 84 00 00 00 00 00 f3 90 <f6> 43 18 01 75 f8 eb db 66 0f 1f 44 00 00 48 83 c4 28 5b 41 5c


Thanks,
Sasha
