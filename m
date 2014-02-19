Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbaBSSJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:09:20 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37046 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbaBSSJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:09:14 -0500
Message-ID: <5304F32A.4040907@oracle.com>
Date: Wed, 19 Feb 2014 13:08:42 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Michael wang <wangyun@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: sched: hang in migrate_swap
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest, running latest -next kernel, I see to hit the 
following hang quite often.

The initial spew is:

[  293.110057] BUG: soft lockup - CPU#8 stuck for 22s! [migration/8:258]
[  293.110057] Modules linked in:
[  293.110057] irq event stamp: 20828
[  293.110057] hardirqs last  enabled at (20827): [<ffffffff84385437>] restore_args+0x0/0x30
[  293.110057] hardirqs last disabled at (20828): [<ffffffff8438f02d>] apic_timer_interrupt+0x6d/0x80
[  293.110057] softirqs last  enabled at (20826): [<ffffffff811418e7>] __do_softirq+0x447/0x4f0
[  293.110057] softirqs last disabled at (20821): [<ffffffff81141fa3>] irq_exit+0x83/0x160
[  293.110057] CPU: 8 PID: 258 Comm: migration/8 Tainted: G        W 
3.14.0-rc3-next-20140218-sasha-00008-g16140ff-dirty #109
[  293.110057] task: ffff8805b8283000 ti: ffff8805b82c0000 task.ti: ffff8805b82c0000
[  293.110057] RIP: 0010:[<ffffffff81203892>]  [<ffffffff81203892>] multi_cpu_stop+0xc2/0x1c0
[  293.110057] RSP: 0000:ffff8805b82c1cd8  EFLAGS: 00000293
[  293.110057] RAX: 0000000000000001 RBX: ffffffff84385437 RCX: 0000000000000000
[  293.110057] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff8800c40bb978
[  293.110057] RBP: ffff8805b82c1d18 R08: 0000000000000000 R09: 0000000000000000
[  293.110057] R10: 0000000000000001 R11: 0000000000000001 R12: ffff8805b82c1c48
[  293.110057] R13: ffff8805b8283000 R14: ffff8805b82c0000 R15: ffff8805b8283000
[  293.110057] FS:  0000000000000000(0000) GS:ffff8805b9000000(0000) knlGS:0000000000000000
[  293.110057] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  293.110057] CR2: 0000000000942d58 CR3: 0000000005c26000 CR4: 00000000000006e0
[  293.110057] DR0: 000000000089e000 DR1: 00007f938d51a000 DR2: 0000000000000000
[  293.110057] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  293.110057] Stack:
[  293.110057]  ffff8805b91d0be0 00000000c40bb9d8 ffff8805b82c1cf8 ffff8805b91d0be0
[  293.110057]  ffff8800c40bba28 ffffffff812037d0 ffff8800c40bb978 ffff8805b91d0c30
[  293.110057]  ffff8805b82c1de8 ffffffff81202f56 0000000000000001 ffffffff81202e44
[  293.110057] Call Trace:
[  293.110057]  [<ffffffff812037d0>] ? stop_cpus+0x60/0x60
[  293.110057]  [<ffffffff81202f56>] cpu_stopper_thread+0x96/0x190
[  293.110057]  [<ffffffff81202e44>] ? cpu_stop_should_run+0x44/0x60
[  293.110057]  [<ffffffff811a3d1a>] ? __lock_release+0x1da/0x1f0
[  293.110057]  [<ffffffff84384ec5>] ? _raw_spin_unlock_irqrestore+0x65/0xb0
[  293.110057]  [<ffffffff811a1f0d>] ? trace_hardirqs_on+0xd/0x10
[  293.110057]  [<ffffffff81170826>] smpboot_thread_fn+0x2b6/0x2c0
[  293.110057]  [<ffffffff81170570>] ? smpboot_register_percpu_thread+0x100/0x100
[  293.110057]  [<ffffffff81167755>] kthread+0x105/0x110
[  293.110057]  [<ffffffff8437fca2>] ? wait_for_completion+0xc2/0x110
[  293.110057]  [<ffffffff81167650>] ? set_kthreadd_affinity+0x30/0x30
[  293.110057]  [<ffffffff8438e28c>] ret_from_fork+0x7c/0xb0
[  293.110057]  [<ffffffff81167650>] ? set_kthreadd_affinity+0x30/0x30
[  293.110057] Code: b5 05 01 66 0f 1f 44 00 00 45 89 ed 4d 0f a3 2e 45 19 ed 45 85 ed 41 0f 95 c7 
4c 8d 73 24 31 c0 c7 45 cc 00 00 00 00 66 90 f3 90 <44> 8b 6b 20 41 39 c5 74 66 41 83 fd 02 74 0f 41 
83 fd 03 75 41

This is followed by a dump of the rest of the CPU states, and I see the following:

[  268.450444] NMI backtrace for cpu 34
[  268.450444] CPU: 34 PID: 9859 Comm: trinity-c129 Tainted: G        W 
3.14.0-rc3-next-20140218-sasha-00008-g16140ff-dirty #109
[  268.450444] task: ffff880154aa3000 ti: ffff8800c40ba000 task.ti: ffff8800c40ba000
[  268.450444] RIP: 0010:[<ffffffff810b801a>]  [<ffffffff810b801a>] pvclock_clocksource_read+0x1a/0xc0
[  268.450444] RSP: 0018:ffff8800c40bb538  EFLAGS: 00000082
[  268.450444] RAX: 00000000905f62ec RBX: ffff8805b93d8500 RCX: 000000000000000a
[  268.450444] RDX: 00000000000000a1 RSI: 0000000000000040 RDI: ffff881027f12880
[  268.450444] RBP: ffff8800c40bb548 R08: 0000000000000000 R09: 0000000000000001
[  268.450444] R10: 0000000000000002 R11: 0000000000000001 R12: ffff8805b93d8510
[  268.450444] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
[  268.450444] FS:  00007f938e16a700(0000) GS:ffff8805b9200000(0000) knlGS:0000000000000000
[  268.450444] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  268.450444] CR2: 00007f938a658a38 CR3: 00000000c40b2000 CR4: 00000000000006e0
[  268.450444] DR0: 000000000089e000 DR1: 00007f938d51a000 DR2: 0000000000000000
[  268.450444] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000f7060a
[  268.450444] Stack:
[  268.450444]  ffff8805b93d8500 ffff8805b93d8510 ffff8800c40bb558 ffffffff810b6f04
[  268.450444]  ffff8800c40bb568 ffffffff81076e1d ffff8800c40bb598 ffffffff81180635
[  268.450444]  ffffffff875f7be0 0000000000000022 00000000001d8500 ffff8805b93d8500
[  268.450444] Call Trace:
[  268.450444]  [<ffffffff810b6f04>] kvm_clock_read+0x24/0x50
[  268.450444]  [<ffffffff81076e1d>] sched_clock+0x1d/0x30
[  268.450444]  [<ffffffff81180635>] sched_clock_local+0x25/0x90
[  268.450444]  [<ffffffff811808a8>] sched_clock_cpu+0xb8/0x110
[  268.450444]  [<ffffffff8118094d>] local_clock+0x2d/0x40
[  268.450444]  [<ffffffff811a3358>] __lock_acquire+0x2a8/0x580
[  268.450444]  [<ffffffff8118c84d>] ? update_blocked_averages+0x61d/0x670
[  268.450444]  [<ffffffff811a37b2>] lock_acquire+0x182/0x1d0
[  268.450444]  [<ffffffff8118ce2c>] ? idle_balance+0x3c/0x2c0
[  268.450444]  [<ffffffff8118ce61>] idle_balance+0x71/0x2c0
[  268.450444]  [<ffffffff8118ce2c>] ? idle_balance+0x3c/0x2c0
[  268.450444]  [<ffffffff8118d2fe>] pick_next_task_fair+0x24e/0x290
[  268.450444]  [<ffffffff81173a2e>] ? dequeue_task+0x6e/0x80
[  268.450444]  [<ffffffff8437e3b5>] __schedule+0x2a5/0x840
[  268.450444]  [<ffffffff8437ec15>] schedule+0x65/0x70
[  268.450444]  [<ffffffff8437d8d8>] schedule_timeout+0x38/0x2a0
[  268.450444]  [<ffffffff8119c8fe>] ? put_lock_stats+0xe/0x30
[  268.450444]  [<ffffffff811a196c>] ? mark_held_locks+0x6c/0x90
[  268.450444]  [<ffffffff84384e0b>] ? _raw_spin_unlock_irq+0x2b/0x80
[  268.450444]  [<ffffffff8437fc97>] wait_for_completion+0xb7/0x110
[  268.450444]  [<ffffffff8117e6b0>] ? try_to_wake_up+0x2a0/0x2a0
[  268.450444]  [<ffffffff812034a1>] stop_two_cpus+0x261/0x2b0
[  268.450444]  [<ffffffff81176c00>] ? __migrate_swap_task+0xa0/0xa0
[  268.450444]  [<ffffffff810b6f04>] ? kvm_clock_read+0x24/0x50
[  268.450444]  [<ffffffff812037d0>] ? stop_cpus+0x60/0x60
[  268.450444]  [<ffffffff812037d0>] ? stop_cpus+0x60/0x60
[  268.450444]  [<ffffffff8119c8fe>] ? put_lock_stats+0xe/0x30
[  268.450444]  [<ffffffff8437fc1f>] ? wait_for_completion+0x3f/0x110
[  268.450444]  [<ffffffff811740d5>] migrate_swap+0x175/0x1a0
[  268.450444]  [<ffffffff8118b1e0>] task_numa_migrate+0x510/0x600
[  268.450444]  [<ffffffff8118acd0>] ? select_task_rq_fair+0x440/0x440
[  268.450444]  [<ffffffff8118b31d>] numa_migrate_preferred+0x4d/0x60
[  268.450444]  [<ffffffff8118b900>] task_numa_fault+0x190/0x210
[  268.450444]  [<ffffffff812c4f62>] do_huge_pmd_numa_page+0x432/0x450
[  268.450444]  [<ffffffff8119c8fe>] ? put_lock_stats+0xe/0x30
[  268.450444]  [<ffffffff81abccda>] ? delay_tsc+0xea/0x110
[  268.450444]  [<ffffffff81288724>] __handle_mm_fault+0x244/0x3a0
[  268.450444]  [<ffffffff812c776d>] ? rcu_read_unlock+0x5d/0x60
[  268.450444]  [<ffffffff8128898b>] handle_mm_fault+0x10b/0x1b0
[  268.450444]  [<ffffffff84389252>] ? __do_page_fault+0x2e2/0x590
[  268.450444]  [<ffffffff843894c1>] __do_page_fault+0x551/0x590
[  268.450444]  [<ffffffff81181561>] ? vtime_account_user+0x91/0xa0
[  268.450444]  [<ffffffff8124f0c8>] ? context_tracking_user_exit+0xa8/0x1c0
[  268.450444]  [<ffffffff84384f40>] ? _raw_spin_unlock+0x30/0x50
[  268.450444]  [<ffffffff81181561>] ? vtime_account_user+0x91/0xa0
[  268.450444]  [<ffffffff8124f0c8>] ? context_tracking_user_exit+0xa8/0x1c0
[  268.450444]  [<ffffffff843895bd>] do_page_fault+0x3d/0x70
[  268.450444]  [<ffffffff843888b5>] do_async_page_fault+0x35/0x100
[  268.450444]  [<ffffffff84385798>] async_page_fault+0x28/0x30
[  268.450444] Code: 6d e1 10 00 e8 98 8a 15 00 c9 c3 66 0f 1f 44 00 00 55 48 89 e5 48 83 ec 10 8b 
37 eb 06 0f 1f 40 00 89 c6 0f 1f 00 0f ae e8 0f 31 <48> c1 e2 20 89 c0 0f be 4f 1c 48 09 c2 44 8b 47 
18 48 2b 57 08

The stack trace is always pointing to migrate_swap() calling stop_two_cpus(). Note that I don't
see another CPU in a stopped state when it occurs.


Thanks,
Sasha
