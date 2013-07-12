Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab3GLVPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 17:15:31 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34066 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757598Ab3GLVP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 17:15:29 -0400
Date: Fri, 12 Jul 2013 14:15:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: dipankar@in.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        peterz@infradead.org
Subject: Re: rcu: qs related lockup on boot
Message-ID: <20130712211524.GH16780@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <51E06841.50701@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E06841.50701@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071221-5806-0000-0000-0000220B2067
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 04:34:09PM -0400, Sasha Levin wrote:
> Hi all,
> 
> I've stumbled on the following rcu related spew at boot. It happened right when the
> kernel finished up it's boot sequence and passed it to userspace.
> 
> [  116.549044] BUG: soft lockup - CPU#0 stuck for 30s! [modprobe:12510]
> [  116.549884] Modules linked in:
> [  116.551796] hardirqs last  enabled at (3258): [<ffffffff84199eb7>] restore_args+0x0/0x30
> [  116.553684] hardirqs last disabled at (3259): [<ffffffff841a3ced>] apic_timer_interrupt+0x6d/0x80
> [  116.554753] softirqs last  enabled at (3212): [<ffffffff81132d07>] __do_softirq+0x447/0x4d0
> [  116.555857] softirqs last disabled at (3223): [<ffffffff81132ed6>] irq_exit+0x86/0x120
> [  116.556760] CPU: 0 PID: 12510 Comm: modprobe Tainted: G        W    3.10.0-next-20130712-sasha #3956
> [  116.557812] task: ffff8807c8173000 ti: ffff8807c72a6000 task.ti: ffff8807c72a6000
> [  116.558599] RIP: 0010:[<ffffffff8419965d>]  [<ffffffff8419965d>]
> _raw_spin_unlock_irqrestore+0x8d/0xc0
> [  116.558958] RSP: 0018:ffff8807eba03ce8  EFLAGS: 00000282
> [  116.558958] RAX: ffff8807c8173000 RBX: ffffffff84199eb7 RCX: 0000000000000000
> [  116.558958] RDX: ffff8807c8173000 RSI: 0000000000000000 RDI: 0000000000000282
> [  116.558958] RBP: ffff8807eba03cf8 R08: 0000000000000000 R09: 0000000000000000
> [  116.558958] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8807eba03c58
> [  116.558958] R13: ffffffff841a3cf2 R14: ffff8807eba03cf8 R15: ffffffff86098020
> [  116.558958] FS:  0000000000000000(0000) GS:ffff8807eba00000(0000) knlGS:0000000000000000
> [  116.558958] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  116.558958] CR2: 00007f99fc17f850 CR3: 00000007c8438000 CR4: 00000000000006f0
> [  116.558958] Stack:
> [  116.558958]  ffffffff86098020 0000000000000282 ffff8807eba03d38 ffffffff81169173
> [  116.558958]  ffff8807eba03d18 ffffffff85e8d000 0000000000000282 0000000000000000
> [  116.558958]  0000000000000000 0000000000000000 ffff8807eba03d58 ffffffff811e7743
> [  116.558958] Call Trace:
> [  116.558958]  <IRQ>
> [  116.558958]  [<ffffffff81169173>] __wake_up+0x53/0x70

Might be we figured out a new way to deadlock RCU and the scheduler,
but just in case you rediscovered an old way, could you please try this
patch from Peter Zijlstra?

http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg464708.html

If that doesn't help and you don't have lockdep enabled, could you
please enable it?

							Thanx, Paul

> [  116.558958]  [<ffffffff811e7743>] rcu_report_qs_rsp+0x73/0x80
> [  116.558958]  [<ffffffff811edbbd>] rcu_report_qs_rnp+0x26d/0x2c0
> [  116.558958]  [<ffffffff811edf3a>] ? rcu_check_quiescent_state+0x4a/0xf0
> [  116.558958]  [<ffffffff811edfbc>] rcu_check_quiescent_state+0xcc/0xf0
> [  116.558958]  [<ffffffff811ee03b>] __rcu_process_callbacks+0x5b/0x180
> [  116.558958]  [<ffffffff811ee1e8>] rcu_process_callbacks+0x88/0xc0
> [  116.558958]  [<ffffffff81132b21>] __do_softirq+0x261/0x4d0
> [  116.558958]  [<ffffffff81132ed6>] irq_exit+0x86/0x120
> [  116.558958]  [<ffffffff841a53aa>] smp_apic_timer_interrupt+0x4a/0x60
> [  116.558958]  [<ffffffff841a3cf2>] apic_timer_interrupt+0x72/0x80
> [  116.558958]  <EOI>
> [  116.558958]  [<ffffffff84199eb7>] ? retint_restore_args+0x13/0x13
> [  116.558958]  [<ffffffff841996dc>] ? _raw_spin_unlock_irq+0x4c/0x80
> [  116.558958]  [<ffffffff841996c0>] ? _raw_spin_unlock_irq+0x30/0x80
> [  116.558958]  [<ffffffff8116a626>] finish_task_switch+0x96/0x120
> [  116.558958]  [<ffffffff8116a5e8>] ? finish_task_switch+0x58/0x120
> [  116.558958]  [<ffffffff841971db>] __schedule+0x81b/0x8e0
> [  116.558958]  [<ffffffff811ed0f7>] ? rcu_irq_exit+0x1b7/0x200
> [  116.558958]  [<ffffffff84199eb7>] ? retint_restore_args+0x13/0x13
> [  116.558958]  [<ffffffff841978c4>] preempt_schedule_irq+0xa4/0xf0
> [  116.558958]  [<ffffffff84199fe6>] retint_kernel+0x26/0x30
> [  116.558958]  [<ffffffff812355e5>] ? user_enter+0x135/0x150
> [  116.558958]  [<ffffffff81077d6d>] syscall_trace_leave+0x12d/0x160
> [  116.558958]  [<ffffffff841a32f7>] int_check_syscall_exit_work+0x34/0x3d
> [  116.558958] Code: 1f 80 00 00 00 00 e8 73 e2 00 fd 48 83 3d e3 d6
> 8a 01 00 75 11 0f 0b 0f 1f 80 00 00 00 00 eb fe 66 0f 1f 44 00 00 4c
> 89 e7 57 9d <66> 66 90 66 90 bf 01 00 00 00 e8 94 4f 00 00 65 48 8b
> 04 25 88
> 
> The other cpus with anything in their callstack are:
> 
> [  118.366894] CPU: 140 PID: 0 Comm: swapper/140 Tainted: G        W    3.10.0-next-20130712-sasha #3956
> [  118.366894] task: ffff8807de5bb000 ti: ffff8807de5c0000 task.ti: ffff8807de5c0000
> [  118.366894] RIP: 0010:[<ffffffff81a73602>]  [<ffffffff81a73602>] delay_tsc+0xb2/0x140
> [  118.366894] RSP: 0018:ffff8807fd203eb8  EFLAGS: 00000046
> [  118.366894] RAX: 0000000000080000 RBX: 000000005af9b24b RCX: 000000005af9c2c7
> [  118.366894] RDX: 0000000000000043 RSI: 0000000000000000 RDI: 0000000000000001
> [  118.366894] RBP: ffff8807fd203ee8 R08: 00000000e26ec8c5 R09: 0000000000000001
> [  118.366894] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8807de5c0010
> [  118.366894] R13: 0000000000005854 R14: 000000000000008c R15: 000000005af9c2c7
> [  118.366894] FS:  0000000000000000(0000) GS:ffff8807fd200000(0000) knlGS:0000000000000000
> [  118.366894] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  118.366894] CR2: 00007f55dc6b6000 CR3: 0000000005a24000 CR4: 00000000000006e0
> [  118.366894] Stack:
> [  118.366894]  ffff8807de5bb000 ffff8807de5bb000 0000000000000000 00000000ffffffff
> [  118.366894]  0000000000000000 0000000000000002 ffff8807fd203ef8 ffffffff81a734f9
> [  118.366894]  ffff8807fd203f18 ffffffff81156af4 0000000000000000 0000000000000000
> [  118.366894] Call Trace:
> [  118.366894]  <IRQ>
> [  118.366894]  [<ffffffff81a734f9>] __const_udelay+0x29/0x30
> [  118.366894]  [<ffffffff81156af4>] __rcu_read_unlock+0x44/0xb0
> [  118.366894]  [<ffffffff8419e58d>] __atomic_notifier_call_chain+0x10d/0x130
> [  118.366894]  [<ffffffff8419e480>] ? notifier_call_chain+0x130/0x130
> [  118.366894]  [<ffffffff8419e5c6>] atomic_notifier_call_chain+0x16/0x20
> [  118.366894]  [<ffffffff810732ff>] exit_idle+0x3f/0x50
> [  118.366894]  [<ffffffff841a539e>] smp_apic_timer_interrupt+0x3e/0x60
> [  118.366894]  [<ffffffff841a3cf2>] apic_timer_interrupt+0x72/0x80
> [  118.366894]  <EOI>
> [  118.366894]  [<ffffffff810b0066>] ? native_safe_halt+0x6/0x10
> [  118.366894]  [<ffffffff811a78bd>] ? trace_hardirqs_on+0xd/0x10
> [  118.366894]  [<ffffffff81073dad>] default_idle+0x13d/0x2a0
> [  118.366894]  [<ffffffff81073258>] arch_cpu_idle+0x18/0x50
> [  118.366894]  [<ffffffff811925ef>] cpu_idle_loop+0x32f/0x410
> [  118.366894]  [<ffffffff81192740>] cpu_startup_entry+0x70/0x80
> [  118.366894]  [<ffffffff810a0ab3>] start_secondary+0xf3/0x100
> [  118.366894] Code: 41 89 c7 29 d8 44 39 e8 73 6f bf 01 00 00 00 e8
> 15 b0 72 02 49 8b 04 24 a8 08 74 0d e8 58 3d 72 02 0f 1f 84 00 00 00
> 00 00 f3 90 <bf> 01 00 00 00 e8 e4 b0 72 02 e8 af d6 01 00 41 39 c6
> 74 9a e8
> 
> and:
> 
> [  116.900485] CPU: 230 PID: 2154 Comm: watchdog/230 Tainted: G
> W 3.10.0-next-20130712-sasha #3956
> [  116.900485] task: ffff8807da8c8000 ti: ffff8807da8bc000 task.ti: ffff8807da8bc000
> [  116.900485] RIP: 0010:[<ffffffff81a73602>]  [<ffffffff81a73602>] delay_tsc+0xb2/0x140
> [  116.900485] RSP: 0018:ffff8807da8bdc58  EFLAGS: 00000046
> [  116.900485] RAX: 0000000000080000 RBX: 000000007a14c1cd RCX: 000000007a1518e5
> [  116.900485] RDX: 0000000000000043 RSI: 0000000000000000 RDI: 0000000000000001
> [  116.900485] RBP: ffff8807da8bdc88 R08: 00000000e26ec8c5 R09: 0000000000000001
> [  116.900485] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8807da8bc010
> [  116.900485] R13: 0000000000005854 R14: 00000000000000e6 R15: 000000007a1518e5
> [  116.900485] FS:  0000000000000000(0000) GS:ffff880808600000(0000) knlGS:0000000000000000
> [  116.900485] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  116.900485] CR2: 0000000000625370 CR3: 0000000005a24000 CR4: 00000000000006e0
> [  116.900485] Stack:
> [  116.900485]  ffff8807da8c8000 ffff8807da8c8000 00000000ffffb87a ffff8808087d78c0
> [  116.900485]  00000000000000e6 ffff8807da8bdcf4 ffff8807da8bdc98 ffffffff81a734f9
> [  116.900485]  ffff8807da8bdcb8 ffffffff81156af4 00000000000000e6 0000000000000000
> [  116.900485] Call Trace:
> [  116.900485]  [<ffffffff81a734f9>] __const_udelay+0x29/0x30
> [  116.900485]  [<ffffffff81156af4>] __rcu_read_unlock+0x44/0xb0
> [  116.900485]  [<ffffffff8117eae5>] idle_balance+0x205/0x240
> [  116.900485]  [<ffffffff8117e924>] ? idle_balance+0x44/0x240
> [  116.900485]  [<ffffffff81181dd9>] ? dequeue_task_rt+0x39/0x50
> [  116.900485]  [<ffffffff84196c35>] __schedule+0x275/0x8e0
> [  116.900485]  [<ffffffff8419741d>] schedule+0x5d/0x70
> [  116.900485]  [<ffffffff81166d25>] smpboot_thread_fn+0x295/0x2f0
> [  116.900485]  [<ffffffff81166a90>] ? smpboot_register_percpu_thread+0x100/0x100
> [  116.900485]  [<ffffffff8115bc27>] kthread+0xe7/0xf0
> [  116.900485]  [<ffffffff8419684a>] ? wait_for_completion+0xca/0x120
> [  116.900485]  [<ffffffff8115bb40>] ? __init_kthread_worker+0x70/0x70
> [  116.900485]  [<ffffffff841a2f2c>] ret_from_fork+0x7c/0xb0
> [  116.900485]  [<ffffffff8115bb40>] ? __init_kthread_worker+0x70/0x70
> [  116.900485] Code: 41 89 c7 29 d8 44 39 e8 73 6f bf 01 00 00 00 e8
> 15 b0 72 02 49 8b 04 24 a8 08 74 0d e8 58 3d 72 02 0f 1f 84 00 00 00
> 00 00 f3 90 <bf> 01 00 00 00 e8 e4 b0 72 02 e8 af d6 01 00 41 39 c6
> 74 9a e8
> 
> All other cpus are idle.
> 
> 
> Thanks,
> Sasha
> 

