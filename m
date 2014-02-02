Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbaBBEWp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 23:22:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:51872 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaBBEWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 23:22:43 -0500
Message-ID: <1391314950.5444.18.camel@marge.simpson.net>
Subject: Re: [PATCH 1/2] irq_work: allow certain work in hard irq context
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de
Date: Sun, 02 Feb 2014 05:22:30 +0100
In-Reply-To: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de>
References: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:4+W1QYFWqnyvu325HzYQWmd0qao3jvG/pvl5YYkuBxz
 rAY/PweKTF7SE8gcQ7NM/3903ZCOl7Dn+vaEOlvSp+zgpflbXt
 KVqeI8+pMcwCIqiK3Pyfw2ZoEWCarUdOWq4i02f6n18VBdy0Ir
 n9OJ/53M6YOwMAICP6nBIyTYiJvgcptlGaNE3QffuBzcZD5yj0
 49Aq9FzmR0idZd53d9e68DFXLobknLkWv5cxZRMTq1y8OhfSbc
 IzvnQExsWq3HKj56avu0s6XksYqsjw2WyYF3yWQuVqBz4C1fwi
 QFNPiztMGhD75jIk45qX4CA7pBDJTT3bZ6Sy5OcMt9A5dNardC
 XKtpYGNdZEgIzIM3D54LnKkmeoFHzDMeAFyW18VXA5FdQJxCLh
 HyQVHOQSQPcWg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-31 at 15:34 +0100, Sebastian Andrzej Siewior wrote: 
> irq_work is processed in softirq context on -RT because we want to avoid
> long latencies which might arise from processing lots of perf events.
> The noHZ-full mode requires its callback to be called from real hardirq
> context (commit 76c24fb ("nohz: New APIs to re-evaluate the tick on full
> dynticks CPUs")). If it is called from a thread context we might get
> wrong results for checks like "is_idle_task(current)".
> This patch introduces a second list (hirq_work_list) which will be used
> if irq_work_run() has been invoked from hardirq context and process only
> work items marked with IRQ_WORK_HARD_IRQ.

This patch (w. too noisy to live pr_err whacked) reliable kills my 64
core test box, but only in _virgin_ 3.12-rt11.  Add my local patches,
and it runs and runs, happy as a clam.  Odd.  But whatever, box with
virgin source running says it's busted.

Killing what was killable in this run before box had a chance to turn
into a brick, the two tasks below were left, burning 100% CPU until 5
minute RCU deadline expired.  All other cores were idle.

[  705.465667] INFO: rcu_preempt detected stalls on CPUs/tasks:
[  705.465674] 	5: (714 GPs behind) idle=b03/1/0 softirq=1/1 
[  705.465681] 	(detected by 0, t=300002 jiffies, g=14203, c=14202, q=0)
[  705.465681] sending NMI to all CPUs:
[  705.465685] NMI backtrace for cpu 0
[  705.465688] CPU: 0 PID: 0 Comm: swapper/0 Tainted: GF            3.12.9-rt11 #376
[  705.465689] Hardware name: Hewlett-Packard ProLiant DL980 G7, BIOS P66 07/07/2010
[  705.465691] task: ffffffff81a14460 ti: ffffffff81a00000 task.ti: ffffffff81a00000
[  705.465701] RIP: 0010:[<ffffffff8104155a>]  [<ffffffff8104155a>] native_write_msr_safe+0xa/0x10
[  705.465702] RSP: 0000:ffff880276e03c48  EFLAGS: 00000046
[  705.465703] RAX: 0000000000000400 RBX: 000000000000b084 RCX: 0000000000000830
[  705.465704] RDX: 0000000000000002 RSI: 0000000000000400 RDI: 0000000000000830
[  705.465705] RBP: ffff880276e03c48 R08: 0000000000000100 R09: ffffffff81ab74a0
[  705.465705] R10: 0000000000000502 R11: 0000000000000028 R12: ffffffff81ab74a0
[  705.465706] R13: 0000000000080000 R14: 0000000000000002 R15: 0000000000000002
[  705.465708] FS:  0000000000000000(0000) GS:ffff880276e00000(0000) knlGS:0000000000000000
[  705.465709] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  705.465710] CR2: 00007ff8086cbed0 CR3: 000000026347c000 CR4: 00000000000007f0
[  705.465710] Stack:
[  705.465712]  ffff880276e03cb8 ffffffff8103aab9 0000000000000001 0000000000000001
[  705.465714]  ffff880276e03cc8 ffffffff815d1810 0000000000000000 0000000000000092
[  705.465715]  ffff880276e03c98 0000000000000000 ffffffff81a42e00 ffffffff81ab7480
[  705.465716] Call Trace:
[  705.465718]  <IRQ> 
[  705.465722]  [<ffffffff8103aab9>] __x2apic_send_IPI_mask+0xa9/0xe0
[  705.465727]  [<ffffffff815d1810>] ? printk+0x54/0x78
[  705.465729]  [<ffffffff8103ab09>] x2apic_send_IPI_all+0x19/0x20
[  705.465731]  [<ffffffff81036533>] arch_trigger_all_cpu_backtrace+0x73/0xb0
[  705.465734]  [<ffffffff81103df9>] print_other_cpu_stall+0x259/0x360
[  705.465739]  [<ffffffff8100a8d0>] ? native_sched_clock+0x20/0xa0
[  705.465740]  [<ffffffff81103f88>] __rcu_pending+0x88/0x1f0
[  705.465742]  [<ffffffff811042e5>] rcu_check_callbacks+0x1f5/0x300
[  705.465745]  [<ffffffff81068346>] update_process_times+0x46/0x80
[  705.465749]  [<ffffffff810c4f02>] tick_sched_handle+0x32/0x70
[  705.465751]  [<ffffffff810c51d0>] tick_sched_timer+0x40/0x70
[  705.465755]  [<ffffffff81084b8d>] __run_hrtimer+0x14d/0x280
[  705.465757]  [<ffffffff810c5190>] ? tick_nohz_handler+0xa0/0xa0
[  705.465758]  [<ffffffff81084dea>] hrtimer_interrupt+0x12a/0x310
[  705.465762]  [<ffffffff815d94ef>] ? __atomic_notifier_call_chain+0x4f/0x70
[  705.465764]  [<ffffffff81034af6>] local_apic_timer_interrupt+0x36/0x60
[  705.465766]  [<ffffffff810359fe>] smp_apic_timer_interrupt+0x3e/0x60
[  705.465768]  [<ffffffff815ddcdd>] apic_timer_interrupt+0x6d/0x80
[  705.465770]  <EOI> 
[  705.465771]  [<ffffffff81041696>] ? native_safe_halt+0x6/0x10
[  705.465774]  [<ffffffff8100c8d3>] default_idle+0x83/0x120
[  705.465776]  [<ffffffff8100bfa6>] arch_cpu_idle+0x26/0x30
[  705.465778]  [<ffffffff810b341d>] cpu_idle_loop+0x28d/0x2e0
[  705.465779]  [<ffffffff810b34bc>] cpu_startup_entry+0x4c/0x50
[  705.465781]  [<ffffffff815c8fd3>] rest_init+0x83/0x90
[  705.465785]  [<ffffffff81ad5175>] start_kernel+0x3fc/0x4a3
[  705.465787]  [<ffffffff81ad4b66>] ? repair_env_string+0x58/0x58
[  705.465789]  [<ffffffff81ad451f>] x86_64_start_reservations+0x1b/0x32
[  705.465791]  [<ffffffff81ad46a5>] x86_64_start_kernel+0x16f/0x17e
[  705.465792]  [<ffffffff81ad4120>] ? early_idt_handlers+0x120/0x120
[  705.465805] Code: 00 55 89 f9 48 89 e5 0f 32 31 c9 89 c7 48 89 d0 89 0e 48 c1 e0 20 89 fa 48 09 d0 c9 c3 0f 1f 40 00 55 89 f9 89 f0 48 89 e5 0f 30 <31> c0 c9 c3 66 90 55 89 f9 48 89 e5 0f 33 89 c1 48 89 d0 48 c1 
[  705.466006] NMI backtrace for cpu 5
[  705.466009] CPU: 5 PID: 21792 Comm: cc1 Tainted: GF            3.12.9-rt11 #376
[  705.466010] Hardware name: Hewlett-Packard ProLiant DL980 G7, BIOS P66 07/07/2010
[  705.466011] task: ffff88026e9ebdb0 ti: ffff880037b62000 task.ti: ffff880037b62000
[  705.466015] RIP: 0010:[<ffffffff815d5450>]  [<ffffffff815d5450>] _raw_spin_unlock_irq+0x40/0x40
[  705.466016] RSP: 0000:ffff880276ea3d00  EFLAGS: 00000002
[  705.466017] RAX: ffff880276eadcc0 RBX: 00000000ffffffff RCX: 0000000000000086
[  705.466018] RDX: 0000000000000002 RSI: 0000000000000086 RDI: ffff880276eadc40
[  705.466019] RBP: ffff880276ea3d38 R08: 00000000000008ad R09: 00000000000000a2
[  705.466020] R10: 0000000000000005 R11: ffff880276eb41a0 R12: ffff880276eae4e0
[  705.466020] R13: ffff880276eadcc0 R14: 0000000000000000 R15: ffff880276eadcc0
[  705.466022] FS:  00002b5fa3f5c600(0000) GS:ffff880276ea0000(0000) knlGS:0000000000000000
[  705.466023] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  705.466023] CR2: 00002b5fa4c92000 CR3: 0000000078766000 CR4: 00000000000007e0
[  705.466024] Stack:
[  705.466026]  ffffffff81085074 ffff880276ea3d28 ffff88026e9ebe20 0000000000000086
[  705.466027]  ffff880276eae4e0 ffff880276eae4e0 000000000000000a ffff880276ea3d58
[  705.466028]  ffffffff81085160 ffff880276ea3d68 0000005e2f828d7f ffff880276ea3d78
[  705.466029] Call Trace:
[  705.466030]  <IRQ> 
[  705.466033]  [<ffffffff81085074>] ? hrtimer_try_to_cancel+0x44/0x110
[  705.466035]  [<ffffffff81085160>] hrtimer_cancel+0x20/0x30
[  705.466037]  [<ffffffff810c52b2>] tick_nohz_restart+0x12/0x90
[  705.466039]  [<ffffffff810c56da>] tick_nohz_restart_sched_tick+0x4a/0x60
[  705.466041]  [<ffffffff810c5e99>] __tick_nohz_full_check+0x89/0x90
[  705.466043]  [<ffffffff810c5ea9>] nohz_full_kick_work_func+0x9/0x10
[  705.466047]  [<ffffffff81129e89>] __irq_work_run+0x79/0xb0
[  705.466049]  [<ffffffff81129ec9>] irq_work_run+0x9/0x10
[  705.466051]  [<ffffffff81068362>] update_process_times+0x62/0x80
[  705.466053]  [<ffffffff810c4f02>] tick_sched_handle+0x32/0x70
[  705.466055]  [<ffffffff810c51d0>] tick_sched_timer+0x40/0x70
[  705.466057]  [<ffffffff81084b8d>] __run_hrtimer+0x14d/0x280
[  705.466059]  [<ffffffff810c5190>] ? tick_nohz_handler+0xa0/0xa0
[  705.466060]  [<ffffffff81084dea>] hrtimer_interrupt+0x12a/0x310
[  705.466065]  [<ffffffff81096e4c>] ? vtime_account_user+0x6c/0x100
[  705.466067]  [<ffffffff81034af6>] local_apic_timer_interrupt+0x36/0x60
[  705.466069]  [<ffffffff8103a8c4>] ? native_apic_msr_eoi_write+0x14/0x20
[  705.466071]  [<ffffffff810359fe>] smp_apic_timer_interrupt+0x3e/0x60
[  705.466074]  [<ffffffff815ddcdd>] apic_timer_interrupt+0x6d/0x80
[  705.466075]  <EOI> 
[  705.466088] Code: b9 00 00 83 aa 44 e0 ff ff 01 48 8b 82 38 e0 ff ff a8 08 75 0c 48 8b 82 38 e0 ff ff f6 c4 02 74 05 e8 45 dc ff ff c9 c3 0f 1f 00 <55> 48 89 e5 66 83 07 01 48 89 f7 57 9d 66 66 90 66 90 65 48 8b 
[  705.468619] NMI backtrace for cpu 52
[  705.468622] CPU: 52 PID: 23285 Comm: objdump Tainted: GF            3.12.9-rt11 #376
[  705.468623] Hardware name: Hewlett-Packard ProLiant DL980 G7, BIOS P66 07/07/2010
[  705.468625] task: ffff8802640c5820 ti: ffff8801e8b0c000 task.ti: ffff8801e8b0c000
[  705.468634] RIP: 0010:[<ffffffff81085083>]  [<ffffffff81085083>] hrtimer_try_to_cancel+0x53/0x110
[  705.468635] RSP: 0000:ffff880277483d40  EFLAGS: 00000046
[  705.468636] RAX: 00000000ffffffff RBX: ffff88027748e4e0 RCX: 0000000000000086
[  705.468637] RDX: ffff8801e8b0dfd8 RSI: 0000000000000086 RDI: 0000000000000086
[  705.468638] RBP: ffff880277483d58 R08: 000000000000013e R09: 000000000000012f
[  705.468639] R10: 0000000000000005 R11: ffff8802774941a0 R12: ffff88027748e4e0
[  705.468640] R13: 000000000000000a R14: 0000000000000000 R15: ffff88027748dcc0
[  705.468642] FS:  00002ab0cef7d100(0000) GS:ffff880277480000(0000) knlGS:0000000000000000
[  705.468643] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  705.468644] CR2: 00002ab0cff9bed0 CR3: 0000000265bbb000 CR4: 00000000000007e0
[  705.468645] Stack:
[  705.468647]  ffffffff81085160 ffff880277483d68 0000005ec8c10810 ffff880277483d78
[  705.468648]  ffffffff810c52b2 0000005ec8c10810 ffff88027748e4e0 ffff880277483d98
[  705.468649]  ffffffff810c56da ffff88027748e4e0 0000000000000008 ffff880277483db8
[  705.468650] Call Trace:
[  705.468651]  <IRQ> 
[  705.468653]  [<ffffffff81085160>] ? hrtimer_cancel+0x20/0x30
[  705.468660]  [<ffffffff810c52b2>] tick_nohz_restart+0x12/0x90
[  705.468662]  [<ffffffff810c56da>] tick_nohz_restart_sched_tick+0x4a/0x60
[  705.468665]  [<ffffffff810c5e99>] __tick_nohz_full_check+0x89/0x90
[  705.468667]  [<ffffffff810c5ea9>] nohz_full_kick_work_func+0x9/0x10
[  705.468674]  [<ffffffff81129e89>] __irq_work_run+0x79/0xb0
[  705.468676]  [<ffffffff81129ec9>] irq_work_run+0x9/0x10
[  705.468681]  [<ffffffff81068362>] update_process_times+0x62/0x80
[  705.468683]  [<ffffffff810c4f02>] tick_sched_handle+0x32/0x70
[  705.468685]  [<ffffffff810c51d0>] tick_sched_timer+0x40/0x70
[  705.468687]  [<ffffffff81084b8d>] __run_hrtimer+0x14d/0x280
[  705.468689]  [<ffffffff810c5190>] ? tick_nohz_handler+0xa0/0xa0
[  705.468691]  [<ffffffff81084dea>] hrtimer_interrupt+0x12a/0x310
[  705.468700]  [<ffffffff81096c22>] ? vtime_account_system+0x52/0xe0
[  705.468703]  [<ffffffff81034af6>] local_apic_timer_interrupt+0x36/0x60
[  705.468708]  [<ffffffff8103a8c4>] ? native_apic_msr_eoi_write+0x14/0x20
[  705.468710]  [<ffffffff810359fe>] smp_apic_timer_interrupt+0x3e/0x60
[  705.468721]  [<ffffffff815ddcdd>] apic_timer_interrupt+0x6d/0x80
[  705.468722]  <EOI> 
[  705.468733]  [<ffffffff8105ae13>] ? pin_current_cpu+0x63/0x180
[  705.468742]  [<ffffffff81090505>] migrate_disable+0x95/0x100
[  705.468746]  [<ffffffff81168d21>] __do_fault+0x181/0x590
[  705.468748]  [<ffffffff811691c3>] handle_pte_fault+0x93/0x250
[  705.468750]  [<ffffffff811694b7>] __handle_mm_fault+0x137/0x1e0
[  705.468752]  [<ffffffff81169653>] handle_mm_fault+0xf3/0x1a0
[  705.468755]  [<ffffffff815d90f1>] __do_page_fault+0x291/0x550
[  705.468758]  [<ffffffff8100a8d0>] ? native_sched_clock+0x20/0xa0
[  705.468766]  [<ffffffff81108547>] ? acct_account_cputime+0x17/0x20
[  705.468768]  [<ffffffff81096dc2>] ? account_user_time+0xd2/0xf0
[  705.468770]  [<ffffffff81096e4c>] ? vtime_account_user+0x6c/0x100
[  705.468772]  [<ffffffff815d93f0>] do_page_fault+0x40/0x70
[  705.468774]  [<ffffffff815d5d48>] page_fault+0x28/0x30
[  705.468787] Code: 24 38 49 89 c5 89 d0 a8 02 74 25 49 8b 44 24 30 48 8b 75 e0 48 8b 38 e8 dc 03 55 00 89 d8 4c 8b 65 f0 48 8b 5d e8 4c 8b 6d f8 c9 <c3> 0f 1f 40 00 31 db a8 01 74 d5 8b 05 74 1f a2 00 85 c0 74 5d 


