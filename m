Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3LLSdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:33:07 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45779 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3LLSdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:33:04 -0500
Message-ID: <52AA014B.6000301@oracle.com>
Date: Thu, 12 Dec 2013 13:32:43 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/5] timekeeping: Avoid possible deadlock from clock_was_set_delayed
References: <1386789098-17391-1-git-send-email-john.stultz@linaro.org> <1386789098-17391-4-git-send-email-john.stultz@linaro.org> <52A9E5B2.8040702@oracle.com>
In-Reply-To: <52A9E5B2.8040702@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 11:34 AM, Sasha Levin wrote:
> On 12/11/2013 02:11 PM, John Stultz wrote:
>> As part of normal operaions, the hrtimer subsystem frequently calls
>> into the timekeeping code, creating a locking order of
>>    hrtimer locks -> timekeeping locks
>>
>> clock_was_set_delayed() was suppoed to allow us to avoid deadlocks
>> between the timekeeping the hrtimer subsystem, so that we could
>> notify the hrtimer subsytem the time had changed while holding
>> the timekeeping locks. This was done by scheduling delayed work
>> that would run later once we were out of the timekeeing code.
>>
>> But unfortunately the lock chains are complex enoguh that in
>> scheduling delayed work, we end up eventually trying to grab
>> an hrtimer lock.
>>
>> Sasha Levin noticed this in testing when the new seqlock lockdep
>> enablement triggered the following (somewhat abrieviated) message:
>
> [snip]
>
> This seems to work for me, I don't see the lockdep spew anymore.
>
>      Tested-by: Sasha Levin <sasha.levin@oracle.com>

I think I spoke too soon.

It took way more time to reproduce than previously, but I got:


[ 1195.547491] ======================================================
[ 1195.548319] [ INFO: possible circular locking dependency detected ]
[ 1195.549222] 3.13.0-rc3-next-20131212-sasha-00007-gbcfdb32 #4062 Not tainted
[ 1195.550184] -------------------------------------------------------
[ 1195.550184] trinity-child89/28195 is trying to acquire lock:

[ 1195.550184]  (timekeeper_seq){----..}, at: [<ffffffff8116a8e7>] start_bandwidth_timer+0x27/0x60
[ 1195.550184]
[ 1195.550184] but task is already holding lock:
[ 1195.550184]  (&rt_b->rt_runtime_lock){-.-...}, at: [<ffffffff811842f9>] 
__enqueue_rt_entity+0x229/0x290
[ 1195.550184]
[ 1195.550184] which lock already depends on the new lock.
[ 1195.550184]
[ 1195.550184]
[ 1195.550184] the existing dependency chain (in reverse order) is:
[ 1195.550184]
-> #4 (&rt_b->rt_runtime_lock){-.-...}:
[ 1195.550184]        [<ffffffff81194803>] validate_chain+0x6c3/0x7b0
[ 1195.550184]        [<ffffffff81194d9d>] __lock_acquire+0x4ad/0x580
[ 1195.550184]        [<ffffffff81194ff2>] lock_acquire+0x182/0x1d0
[ 1195.550184]        [<ffffffff843b0760>] _raw_spin_lock+0x40/0x80
[ 1195.550184]        [<ffffffff811842f9>] __enqueue_rt_entity+0x229/0x290
[ 1195.550184]        [<ffffffff811846db>] enqueue_rt_entity+0x6b/0x80
[ 1195.550184]        [<ffffffff81184726>] enqueue_task_rt+0x36/0xb0
[ 1195.550184]        [<ffffffff8116af42>] enqueue_task+0x52/0x60
[ 1195.550184]        [<ffffffff81171ebb>] __sched_setscheduler+0x33b/0x3f0
[ 1195.550184]        [<ffffffff81171f80>] sched_setscheduler_nocheck+0x10/0x20
[ 1195.550184]        [<ffffffff811b5e2b>] rcu_cpu_kthread_setup+0x2b/0x30
[ 1195.550184]        [<ffffffff81166efd>] smpboot_thread_fn+0x1ed/0x2c0
[ 1195.550184]        [<ffffffff8115d9e5>] kthread+0x105/0x110
[ 1195.550184]        [<ffffffff843babfc>] ret_from_fork+0x7c/0xb0
[ 1195.550184]
-> #3 (&rq->lock){-.-.-.}:
[ 1195.550184]        [<ffffffff81194803>] validate_chain+0x6c3/0x7b0
[ 1195.550184]        [<ffffffff81194d9d>] __lock_acquire+0x4ad/0x580
[ 1195.550184]        [<ffffffff81194ff2>] lock_acquire+0x182/0x1d0
[ 1195.550184]        [<ffffffff843b0760>] _raw_spin_lock+0x40/0x80
[ 1195.550184]        [<ffffffff8116f489>] wake_up_new_task+0x149/0x270
[ 1195.550184]        [<ffffffff8113002a>] do_fork+0x1ba/0x270
[ 1195.550184]        [<ffffffff81130166>] kernel_thread+0x26/0x30
[ 1195.550184]        [<ffffffff8439fe76>] rest_init+0x26/0x150
[ 1195.578519]        [<ffffffff8706b377>] start_kernel+0x3b9/0x3c0
[ 1195.578519]        [<ffffffff8706a3d9>] x86_64_start_reservations+0x2a/0x2c
[ 1195.578519]        [<ffffffff8706a5ae>] x86_64_start_kernel+0x186/0x195
[ 1195.578519]
-> #2 (&p->pi_lock){-.-.-.}:
[ 1195.578519]        [<ffffffff81194803>] validate_chain+0x6c3/0x7b0
[ 1195.578519]        [<ffffffff81194d9d>] __lock_acquire+0x4ad/0x580
[ 1195.578519]        [<ffffffff81194ff2>] lock_acquire+0x182/0x1d0
[ 1195.578519]        [<ffffffff843b0911>] _raw_spin_lock_irqsave+0x91/0xd0
[ 1195.578519]        [<ffffffff81172909>] try_to_wake_up+0x39/0x2a0
[ 1195.578519]        [<ffffffff81172bef>] wake_up_process+0x3f/0x50
[ 1195.578519]        [<ffffffff811507da>] start_worker+0x2a/0x40
[ 1195.578519]        [<ffffffff81156a9d>] create_and_start_worker+0x4d/0x90
[ 1195.578519]        [<ffffffff87091ceb>] init_workqueues+0x192/0x3cb
[ 1195.578519]        [<ffffffff810020ca>] do_one_initcall+0xca/0x1e0
[ 1195.578519]        [<ffffffff8706acf1>] kernel_init_freeable+0x2b4/0x354
[ 1195.578519]        [<ffffffff8439ffae>] kernel_init+0xe/0x130
[ 1195.578519]        [<ffffffff843babfc>] ret_from_fork+0x7c/0xb0
[ 1195.578519]
-> #1 (&(&pool->lock)->rlock){-.-...}:
[ 1195.578519]        [<ffffffff81194803>] validate_chain+0x6c3/0x7b0
[ 1195.578519]        [<ffffffff81194d9d>] __lock_acquire+0x4ad/0x580
[ 1195.578519]        [<ffffffff81194ff2>] lock_acquire+0x182/0x1d0
[ 1195.578519]        [<ffffffff843b0760>] _raw_spin_lock+0x40/0x80
[ 1195.578519]        [<ffffffff81153e0e>] __queue_work+0x14e/0x3f0
[ 1195.578519]        [<ffffffff81154168>] queue_work_on+0x98/0x120
[ 1195.578519]        [<ffffffff81161351>] clock_was_set_delayed+0x21/0x30
[ 1195.578519]        [<ffffffff811c4b41>] do_adjtimex+0x111/0x160
[ 1195.578519]        [<ffffffff811360e3>] SYSC_adjtimex+0x43/0x80
[ 1195.578519]        [<ffffffff8113612e>] SyS_adjtimex+0xe/0x10
[ 1195.578519]        [<ffffffff843baed0>] tracesys+0xdd/0xe2
[ 1195.578519]
-> #0 (timekeeper_seq){----..}:
[ 1195.578519]        [<ffffffff81193d2f>] check_prev_add+0x13f/0x550
[ 1195.578519]        [<ffffffff81194803>] validate_chain+0x6c3/0x7b0
[ 1195.578519]        [<ffffffff81194d9d>] __lock_acquire+0x4ad/0x580
[ 1195.578519]        [<ffffffff81194ff2>] lock_acquire+0x182/0x1d0
[ 1195.578519]        [<ffffffff811c541a>] ktime_get+0x9a/0x1b0
[ 1195.578519]        [<ffffffff8116a8e7>] start_bandwidth_timer+0x27/0x60
[ 1195.578519]        [<ffffffff8118430e>] __enqueue_rt_entity+0x23e/0x290
[ 1195.578519]        [<ffffffff811846db>] enqueue_rt_entity+0x6b/0x80
[ 1195.578519]        [<ffffffff81184726>] enqueue_task_rt+0x36/0xb0
[ 1195.578519]        [<ffffffff8116af42>] enqueue_task+0x52/0x60
[ 1195.578519]        [<ffffffff81171ebb>] __sched_setscheduler+0x33b/0x3f0
[ 1195.578519]        [<ffffffff81172043>] sched_setscheduler+0x13/0x20
[ 1195.578519]        [<ffffffff811720c9>] do_sched_setscheduler+0x79/0xa0
[ 1195.578519]        [<ffffffff81172129>] SyS_sched_setscheduler+0x19/0x20
[ 1195.578519]        [<ffffffff843baed0>] tracesys+0xdd/0xe2
[ 1195.578519]
[ 1195.578519] other info that might help us debug this:
[ 1195.578519]
[ 1195.578519] Chain exists of:
   timekeeper_seq --> &rq->lock --> &rt_b->rt_runtime_lock

[ 1195.578519]  Possible unsafe locking scenario:
[ 1195.578519]
[ 1195.578519]        CPU0                    CPU1
[ 1195.578519]        ----                    ----
[ 1195.578519]   lock(&rt_b->rt_runtime_lock);
[ 1195.578519]                                lock(&rq->lock);
[ 1195.578519]                                lock(&rt_b->rt_runtime_lock);
[ 1195.578519]   lock(timekeeper_seq);
[ 1195.578519]
[ 1195.578519]  *** DEADLOCK ***
[ 1195.578519]
[ 1195.578519] 4 locks held by trinity-child89/28195:
[ 1195.578519]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff81167d00>] rcu_read_lock+0x0/0x80
[ 1195.578519]  #1:  (&p->pi_lock){-.-.-.}, at: [<ffffffff811691d0>] task_rq_lock+0x40/0xb0
[ 1195.578519]  #2:  (&rq->lock){-.-.-.}, at: [<ffffffff811691eb>] task_rq_lock+0x5b/0xb0
[ 1195.578519]  #3:  (&rt_b->rt_runtime_lock){-.-...}, at: [<ffffffff811842f9>] 
__enqueue_rt_entity+0x229/0x290
[ 1195.578519]
[ 1195.578519] stack backtrace:
[main] Random reseed: 2208014823
[ 1195.578519] CPU: 60 PID: 28195 Comm: trinity-child89 Not tainted 
3.13.0-rc3-next-20131212-sasha-00007-gbcfdb32 #4062
[ 1195.578519]  0000000000000000 ffff8800b0995b48 ffffffff843a9d97 0000000000000000
[ 1195.578519]  0000000000000000 ffff8800b0995b98 ffffffff811918d9 ffff8800b0995bb8
[ 1195.578519]  ffffffff875fdd00 ffff8800b0995b98 ffff880e48048c80 ffff880e48048cb8
[ 1195.578519] Call Trace:
[ 1195.578519]  [<ffffffff843a9d97>] dump_stack+0x52/0x7f
[ 1195.578519]  [<ffffffff811918d9>] print_circular_bug+0x129/0x160
[ 1195.578519]  [<ffffffff81193d2f>] check_prev_add+0x13f/0x550
[ 1195.578519]  [<ffffffff81194803>] validate_chain+0x6c3/0x7b0
[ 1195.578519]  [<ffffffff81175588>] ? sched_clock_cpu+0x108/0x120
[ 1195.578519]  [<ffffffff81194d9d>] __lock_acquire+0x4ad/0x580
[ 1195.578519]  [<ffffffff81194ff2>] lock_acquire+0x182/0x1d0
[ 1195.578519]  [<ffffffff8116a8e7>] ? start_bandwidth_timer+0x27/0x60
[ 1195.578519]  [<ffffffff81190ea2>] ? __lock_acquired+0x2a2/0x2e0
[ 1195.578519]  [<ffffffff811c541a>] ktime_get+0x9a/0x1b0
[ 1195.578519]  [<ffffffff8116a8e7>] ? start_bandwidth_timer+0x27/0x60
[ 1195.578519]  [<ffffffff8116a8e7>] start_bandwidth_timer+0x27/0x60
[ 1195.578519]  [<ffffffff8118430e>] __enqueue_rt_entity+0x23e/0x290
[ 1195.578519]  [<ffffffff8117a027>] ? update_rq_runnable_avg+0x127/0x1d0
[ 1195.578519]  [<ffffffff811846db>] enqueue_rt_entity+0x6b/0x80
[ 1195.578519]  [<ffffffff81184726>] enqueue_task_rt+0x36/0xb0
[ 1195.578519]  [<ffffffff8116af42>] enqueue_task+0x52/0x60
[ 1195.578519]  [<ffffffff81171ebb>] __sched_setscheduler+0x33b/0x3f0
[ 1195.578519]  [<ffffffff812793d6>] ? might_fault+0x56/0xb0
[ 1195.578519]  [<ffffffff81172043>] sched_setscheduler+0x13/0x20
[ 1195.578519]  [<ffffffff811720c9>] do_sched_setscheduler+0x79/0xa0
[ 1195.578519]  [<ffffffff81172129>] SyS_sched_setscheduler+0x19/0x20
[ 1195.578519]  [<ffffffff843baed0>] tracesys+0xdd/0xe2


Thanks,
Sasha
