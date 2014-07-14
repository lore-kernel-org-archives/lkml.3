Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbaGNPhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:37:13 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19659 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbaGNPhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:37:08 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-24-53c3f9179e96
Message-id: <53C3F7CE.7090301@samsung.com>
Date: Mon, 14 Jul 2014 19:31:26 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: sched, timers: use after free in __lock_task_sighand when	exiting
 a process
References: <53C2FF4D.3020606@oracle.com> <53C31A34.8030500@oracle.com>
 <20140714090449.GL9918@twins.programming.kicks-ass.net>
 <20140714144953.GA8173@redhat.com>
In-reply-to: <20140714144953.GA8173@redhat.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xy7riPw8HG7QvM7XYcr2JyWLm624m
	izO/dS0u75rDZrH63ylGi637WxktjvceYLJYfOQ2s8XmTVOZHTg9ds66y+6xeYWWx6ZVnWwe
	d67tYfN4d+4cu8fHp7dYPN7vu8rm8XmTXABHFJdNSmpOZllqkb5dAlfG9yMf2Ao+SVe8ufuc
	rYFxqngXIyeHhICJxJPJ31khbDGJC/fWs3UxcnEICSxllFh+ajcrhNPMJLFv3StGkCpeAS2J
	aW9XsIHYLAKqEm/+/GEBsdkE9CT+zdoOFhcViJA40PeMFaJeUOLH5HtgNSICXhI7775hBhnK
	LNDBJDH33UuwImGBKImXe48yQmxbxigxf8pxsA5OAX2JC527mUBsZgEdif2t09ggbHmJzWve
	Mk9gFJiFZMksJGWzkJQtYGRexSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESGV92MC4+ZnWI
	UYCDUYmHt0LscLAQa2JZcWXuIUYJDmYlEd6jH4BCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGJum
	i/mpTCjvUg9iC5U3vqyT5fFxHssDW7FXfUzOqTq5G7/FXNul+uPSnBKuoFOnRYt3Hdg1b4qj
	VqPH+Q2qQU2G0xP23N4u2anz6VdAVdOe5c1Pd7FxFrpF2206/9a1SCpxX8sUxkNrjaQfr2Oy
	fiJswqDwnruovvqrqfvDXauWb5Jcap5tpsRSnJFoqMVcVJwIAN3KlG1qAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/14 18:49, Oleg Nesterov wrote:
> On 07/14, Peter Zijlstra wrote:
>>
>> On Sun, Jul 13, 2014 at 07:45:56PM -0400, Sasha Levin wrote:
>>>
>>> [  876.319044] ==================================================================
>>> [  876.319044] AddressSanitizer: use after free in do_raw_spin_unlock+0x4b/0x1a0 at addr ffff8803e48cec18
>>> [  876.319044] page:ffffea000f923380 count:0 mapcount:0 mapping:          (null) index:0x0
>>> [  876.319044] page flags: 0x2fffff80008000(tail)
>>> [  876.319044] page dumped because: kasan error
>>> [  876.319044] CPU: 26 PID: 8749 Comm: trinity-watchdo Tainted: G        W      3.16.0-rc4-next-20140711-sasha-00046-g07d3099-dirty #817
>>> [  876.319044]  00000000000000fb 0000000000000000 ffffea000f923380 ffff8805c417fc70
>>> [  876.319044]  ffffffff9de47068 ffff8805c417fd40 ffff8805c417fd30 ffffffff99426f5c
>>> [  876.319044]  0000000000000010 0000000000000000 ffff8805c417fc9d 66666620000000a8
>>> [  876.319044] Call Trace:
>>> [  876.319044] dump_stack (lib/dump_stack.c:52)
>>> [  876.319044] kasan_report_error (mm/kasan/report.c:98 mm/kasan/report.c:166)
>>> [  876.319044] __asan_load8 (mm/kasan/kasan.c:364)
>>> [  876.319044] do_raw_spin_unlock (./arch/x86/include/asm/current.h:14 kernel/locking/spinlock_debug.c:99 kernel/locking/spinlock_debug.c:158)
>>> [  876.319044] _raw_spin_unlock (include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
>>> [  876.319044] __lock_task_sighand (include/linux/rcupdate.h:858 kernel/signal.c:1285)
>>> [  876.319044] do_send_sig_info (kernel/signal.c:1191)
>>> [  876.319044] group_send_sig_info (kernel/signal.c:1304)
>>> [  876.319044] kill_pid_info (kernel/signal.c:1339)
>>> [  876.319044] SYSC_kill (kernel/signal.c:1423 kernel/signal.c:2900)
> 
> Looks like a false alarm at first glance...
> 
>> Oleg, what guarantees the RCU free of task-struct and sighand?
> 
>> The only RCU I can find is delayed_put_task_struct() but that's not
>> often used.
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
>> TASK_DEAD etc. use regular put_task_struct() and that
>> doesn't seem to involve RCU.
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

Yes, you are right. I already seen such false positive with rcu slabs and kasan,
and it was fixed at some point, but somehow fix for this didn't get to the final patches.

I'm sorry for wasting everyone's time.

> We are going to add some comments into lock_task_sighand(). And cleanup it,
> it can look much simpler.
> 
> Oleg.
> 
> 

