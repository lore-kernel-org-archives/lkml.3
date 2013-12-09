Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab3LIDR5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 22:17:57 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36250 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760305Ab3LIDRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 22:17:54 -0500
Message-ID: <52A5363A.20801@oracle.com>
Date: Sun, 08 Dec 2013 22:17:14 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        tglx@linutronix.de, john.stultz@linaro.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched/timekeeping: lockdep spew
References: <52A50490.4080705@oracle.com>
In-Reply-To: <52A50490.4080705@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2013 06:45 PM, Sasha Levin wrote:
> Hi all,
>
> I've stumbled on this spew inside a KVM tools guest running latest -next kernel:
>

If it helps, I'm getting another similar spew (different locks):

[  554.572415] ======================================================
[  554.572851] [ INFO: possible circular locking dependency detected ]
[  554.573956] 3.13.0-rc2-next-20131206-sasha-00005-g8be2375-dirty #4054 Not tainted
[  554.575249] -------------------------------------------------------
[  554.576575] swapper/16/0 is trying to acquire lock:
[  554.577110]  (timekeeper_seq){----..}, at: [<ffffffff8116a8e7>] start_bandwidth_timer+0x27/0x60
[  554.578804]
[  554.578804] but task is already holding lock:
[  554.579961]  (&rt_b->rt_runtime_lock){-.-...}, at: [<ffffffff811842f9>] 
__enqueue_rt_entity+0x229/0x290
[  554.581701]
[  554.581701] which lock already depends on the new lock.
[  554.581701]
[  554.581701]
[  554.581701] the existing dependency chain (in reverse order) is:
[  554.581701]
-> #4 (&rt_b->rt_runtime_lock){-.-...}:
[  554.581701]        [<ffffffff81194803>] validate_chain+0x6c3/0x7b0
[  554.581701]        [<ffffffff81194d9d>] __lock_acquire+0x4ad/0x580
[  554.581701]        [<ffffffff81194ff2>] lock_acquire+0x182/0x1d0
[  554.581701]        [<ffffffff84398500>] _raw_spin_lock+0x40/0x80
[  554.581701]        [<ffffffff811842f9>] __enqueue_rt_entity+0x229/0x290
[  554.581701]        [<ffffffff811846db>] enqueue_rt_entity+0x6b/0x80
[  554.581701]        [<ffffffff81184726>] enqueue_task_rt+0x36/0xb0
[  554.581701]        [<ffffffff8116af42>] enqueue_task+0x52/0x60
[  554.581701]        [<ffffffff81171ebb>] __sched_setscheduler+0x33b/0x3f0
[  554.581701]        [<ffffffff81171f80>] sched_setscheduler_nocheck+0x10/0x20
[  554.581701]        [<ffffffff811b5e2b>] rcu_cpu_kthread_setup+0x2b/0x30
[  554.581701]        [<ffffffff81166efd>] smpboot_thread_fn+0x1ed/0x2c0
[  554.581701]        [<ffffffff8115d9e5>] kthread+0x105/0x110
[  554.581701]        [<ffffffff843a297c>] ret_from_fork+0x7c/0xb0
[  554.581701]
-> #3 (&rq->lock){-.-.-.}:
[  554.581701]        [<ffffffff81194803>] validate_chain+0x6c3/0x7b0
[  554.581701]        [<ffffffff81194d9d>] __lock_acquire+0x4ad/0x580
[  554.581701]        [<ffffffff81194ff2>] lock_acquire+0x182/0x1d0
[  554.581701]        [<ffffffff84398500>] _raw_spin_lock+0x40/0x80
[  554.581701]        [<ffffffff8116f489>] wake_up_new_task+0x149/0x270
[  554.581701]        [<ffffffff8113002a>] do_fork+0x1ba/0x270
[  554.581701]        [<ffffffff81130166>] kernel_thread+0x26/0x30
[  554.581701]        [<ffffffff84387c16>] rest_init+0x26/0x150
[  554.581701]        [<ffffffff87068377>] start_kernel+0x3b9/0x3c0
[  554.581701]        [<ffffffff870673d9>] x86_64_start_reservations+0x2a/0x2c
[  554.581701]        [<ffffffff870675ae>] x86_64_start_kernel+0x186/0x195
[  554.581701]
-> #2 (&p->pi_lock){-.-.-.}:
[  554.581701]        [<ffffffff81194803>] validate_chain+0x6c3/0x7b0
[  554.581701]        [<ffffffff81194d9d>] __lock_acquire+0x4ad/0x580
[  554.581701]        [<ffffffff81194ff2>] lock_acquire+0x182/0x1d0
[  554.581701]        [<ffffffff843986b1>] _raw_spin_lock_irqsave+0x91/0xd0
[  554.581701]        [<ffffffff81172909>] try_to_wake_up+0x39/0x2a0
[  554.581701]        [<ffffffff81172bef>] wake_up_process+0x3f/0x50
[  554.581701]        [<ffffffff811507da>] start_worker+0x2a/0x40
[  554.581701]        [<ffffffff81156a9d>] create_and_start_worker+0x4d/0x90
[  554.581701]        [<ffffffff8708ecec>] init_workqueues+0x192/0x3cb
[  554.581701]        [<ffffffff810020ca>] do_one_initcall+0xca/0x1e0
[  554.581701]        [<ffffffff87067cf1>] kernel_init_freeable+0x2b4/0x354
[  554.581701]        [<ffffffff84387d4e>] kernel_init+0xe/0x130
[  554.581701]        [<ffffffff843a297c>] ret_from_fork+0x7c/0xb0
[  554.581701]
-> #1 (&(&pool->lock)->rlock){-.-...}:
[  554.581701]        [<ffffffff81194803>] validate_chain+0x6c3/0x7b0
[  554.581701]        [<ffffffff81194d9d>] __lock_acquire+0x4ad/0x580
[  554.581701]        [<ffffffff81194ff2>] lock_acquire+0x182/0x1d0
[  554.581701]        [<ffffffff84398500>] _raw_spin_lock+0x40/0x80
[  554.581701]        [<ffffffff81153e69>] __queue_work+0x1a9/0x3f0
[  554.581701]        [<ffffffff81154168>] queue_work_on+0x98/0x120
[  554.581701]        [<ffffffff81161351>] clock_was_set_delayed+0x21/0x30
[  554.581701]        [<ffffffff811c4bd1>] do_adjtimex+0x111/0x160
[  554.581701]        [<ffffffff811e2711>] compat_sys_adjtimex+0x41/0x70
[  554.581701]        [<ffffffff843a4b49>] ia32_sysret+0x0/0x5
[  554.581701]
-> #0 (timekeeper_seq){----..}:
[  554.581701]        [<ffffffff81193d2f>] check_prev_add+0x13f/0x550
[  554.581701]        [<ffffffff81194803>] validate_chain+0x6c3/0x7b0
[  554.581701]        [<ffffffff81194d9d>] __lock_acquire+0x4ad/0x580
[  554.581701]        [<ffffffff81194ff2>] lock_acquire+0x182/0x1d0
[  554.581701]        [<ffffffff811c540a>] ktime_get+0x9a/0x1b0
[  554.581701]        [<ffffffff8116a8e7>] start_bandwidth_timer+0x27/0x60
[  554.581701]        [<ffffffff8118430e>] __enqueue_rt_entity+0x23e/0x290
[  554.581701]        [<ffffffff811846db>] enqueue_rt_entity+0x6b/0x80
[  554.581701]        [<ffffffff81184726>] enqueue_task_rt+0x36/0xb0
[  554.652241] can: request_module (can-proto-4) failed.
[  554.581701]        [<ffffffff8116af42>] enqueue_task+0x52/0x60
[  554.581701]        [<ffffffff8116af72>] activate_task+0x22/0x30
[  554.581701]        [<ffffffff8116afa1>] ttwu_activate+0x21/0x50
[  554.581701]        [<ffffffff8116b00c>] T.2138+0x3c/0x60
[  554.581701]        [<ffffffff8116b161>] sched_ttwu_pending+0x51/0x70
[  554.581701]        [<ffffffff8116dcd2>] scheduler_ipi+0x142/0x210
[  554.581701]        [<ffffffff810a301a>] smp_reschedule_interrupt+0x2a/0x30
[  554.581701]        [<ffffffff843a3db2>] reschedule_interrupt+0x72/0x80
[  554.581701]        [<ffffffff81077ecd>] default_idle+0x11d/0x260
[  554.581701]        [<ffffffff81077398>] arch_cpu_idle+0x18/0x50
[  554.581701]        [<ffffffff811a9211>] cpu_idle_loop+0x351/0x460
[  554.581701]        [<ffffffff811a9390>] cpu_startup_entry+0x70/0x80
[  554.581701]        [<ffffffff810a5263>] start_secondary+0xf3/0x100
[  554.581701]
[  554.581701] other info that might help us debug this:
[  554.581701]
[  554.581701] Chain exists of:
   timekeeper_seq --> &rq->lock --> &rt_b->rt_runtime_lock

[  554.581701]  Possible unsafe locking scenario:
[  554.581701]
[  554.581701]        CPU0                    CPU1
[  554.581701]        ----                    ----
[  554.581701]   lock(&rt_b->rt_runtime_lock);
[  554.581701]                                lock(&rq->lock);
[  554.581701]                                lock(&rt_b->rt_runtime_lock);
[  554.581701]   lock(timekeeper_seq);
[  554.581701]
[  554.581701]  *** DEADLOCK ***
[  554.581701]
[  554.678330] 2 locks held by swapper/16/0:
[  554.678330]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff8116b144>] sched_ttwu_pending+0x34/0x70
[  554.678330]  #1:  (&rt_b->rt_runtime_lock){-.-...}, at: [<ffffffff811842f9>] 
__enqueue_rt_entity+0x229/0x290
[  554.678330]
[  554.678330] stack backtrace:
[  554.678330] CPU: 16 PID: 0 Comm: swapper/16 Not tainted 
3.13.0-rc2-next-20131206-sasha-00005-g8be2375-dirty #4054
[  554.678330]  0000000000000000 ffff880fe5603ba8 ffffffff84391b37 0000000000000000
[  554.678330]  0000000000000000 ffff880fe5603bf8 ffffffff811918d9 ffff880fe5603c18
[  554.678330]  ffffffff875f9d00 ffff880fe5603bf8 ffff880fcc543c10 ffff880fcc543c48
[  554.678330] Call Trace:
[  554.678330]  <IRQ>  [<ffffffff84391b37>] dump_stack+0x52/0x7f
[  554.678330]  [<ffffffff811918d9>] print_circular_bug+0x129/0x160
[  554.678330]  [<ffffffff81193d2f>] check_prev_add+0x13f/0x550
[  554.678330]  [<ffffffff81175588>] ? sched_clock_cpu+0x108/0x120
[  554.678330]  [<ffffffff81194803>] validate_chain+0x6c3/0x7b0
[  554.678330]  [<ffffffff81175588>] ? sched_clock_cpu+0x108/0x120
[  554.678330]  [<ffffffff81194d9d>] __lock_acquire+0x4ad/0x580
[  554.678330]  [<ffffffff81194ff2>] lock_acquire+0x182/0x1d0
[  554.678330]  [<ffffffff8116a8e7>] ? start_bandwidth_timer+0x27/0x60
[  554.678330]  [<ffffffff81190ea2>] ? __lock_acquired+0x2a2/0x2e0
[  554.678330]  [<ffffffff811c540a>] ktime_get+0x9a/0x1b0
[  554.678330]  [<ffffffff8116a8e7>] ? start_bandwidth_timer+0x27/0x60
[  554.678330]  [<ffffffff8118430e>] __enqueue_rt_entity+0x23e/0x290
[  554.678330]  [<ffffffff811846db>] enqueue_rt_entity+0x6b/0x80
[  554.678330]  [<ffffffff81184726>] enqueue_task_rt+0x36/0xb0
[  554.678330]  [<ffffffff8116af42>] enqueue_task+0x52/0x60
[  554.678330]  [<ffffffff8116b144>] ? sched_ttwu_pending+0x34/0x70
[  554.678330]  [<ffffffff8116af72>] activate_task+0x22/0x30
[  554.678330]  [<ffffffff8116afa1>] ttwu_activate+0x21/0x50
[  554.678330]  [<ffffffff8116b00c>] T.2138+0x3c/0x60
[  554.678330]  [<ffffffff8116b161>] sched_ttwu_pending+0x51/0x70
[  554.678330]  [<ffffffff8116dcd2>] scheduler_ipi+0x142/0x210
[  554.678330]  [<ffffffff810b403a>] ? kvm_guest_apic_eoi_write+0x1a/0x50
[  554.678330]  [<ffffffff810a301a>] smp_reschedule_interrupt+0x2a/0x30
[  554.678330]  [<ffffffff843a3db2>] reschedule_interrupt+0x72/0x80
[  554.678330]  <EOI>  [<ffffffff810b5646>] ? native_safe_halt+0x6/0x10
[  554.678330]  [<ffffffff8119376d>] ? trace_hardirqs_on+0xd/0x10
[  554.678330]  [<ffffffff81077ecd>] default_idle+0x11d/0x260
[  554.678330]  [<ffffffff81077398>] arch_cpu_idle+0x18/0x50
[  554.678330]  [<ffffffff811a9211>] cpu_idle_loop+0x351/0x460
[  554.678330]  [<ffffffff811a9390>] cpu_startup_entry+0x70/0x80
[  554.678330]  [<ffffffff810a5263>] start_secondary+0xf3/0x100

