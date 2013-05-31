Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab3EaVkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:40:13 -0400
Received: from mail.candelatech.com ([208.74.158.172]:35227 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab3EaVkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:40:08 -0400
Message-ID: <51A918B7.3030302@candelatech.com>
Date: Fri, 31 May 2013 14:40:07 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.9.4+ watchdog overflow and migration lockup soon after boot
 (cpu_stopper_thread related?)
References: <51A8F875.8070606@candelatech.com>
In-Reply-To: <51A8F875.8070606@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 12:22 PM, Ben Greear wrote:
> While trying to verify that the kobject patch
> (see "Please add to stable:  module: don't unlink the module until we've removed all exposure." email)
> fixed the problems I was seeing, I hit what I believe is a different problem.  Much harder to reproduce
> (maybe 15-20 reboots before I saw this..haven't seen it since).
>
> This was on a kernel with additional non-upstream patches, but it's not obviously related to anything
> I've been hacking on.  I'm trying to reproduce now on standard 3.9.4 plus the kobj patch,
> but this seems to be quite rare, so not sure how long it will take.

I reproduced this with only stock 3.9.4 and the kobj patch, so looks like it's
a real bug.  The info looks basically identical to what I posted previously.

I have logs if someone wants to see it.

It took around 20-30 reboots to hit the problem.

I'm thinking the cpu_stopper_thread is stuck in a loop..here are some of
the stack points decoded:

(gdb) l *(stop_machine_cpu_stop+0x68)
0xffffffff81103875 is in stop_machine_cpu_stop (/home/greearb/git/linux-2.6.linus/kernel/stop_machine.c:427).
422	
423		/* Simple state machine */
424		do {
425			/* Chill out and ensure we re-read stopmachine_state. */
426			cpu_relax();
427			if (smdata->state != curstate) {
428				curstate = smdata->state;
429				switch (curstate) {
430				case STOPMACHINE_DISABLE_IRQ:
431					local_irq_disable();
(gdb) l *(cpu_stopper_thread+0xbd)
0xffffffff81103574 is in cpu_stopper_thread (/home/greearb/git/linux-2.6.linus/kernel/stop_machine.c:286).
281	
282			/* cpu stop callbacks are not allowed to sleep */
283			preempt_disable();
284	
285			ret = fn(arg);
286			if (ret)
287				done->ret = ret;
288	
289			/* restore preemption and check it's still balanced */
290			preempt_enable();
(gdb)


SysRq : Show backtrace of all active CPUs
sending NMI to all CPUs:
NMI backtrace for cpu 3
CPU 3
Pid: 29, comm: migration/3 Tainted: G        WC   3.9.4+ #6 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff81103875>]  [<ffffffff81103875>] stop_machine_cpu_stop+0x68/0xfb
RSP: 0018:ffff8802223f3cc8  EFLAGS: 00000093
RAX: 0000000000000002 RBX: ffff880219ac3e18 RCX: 0000000000000000
RDX: ffff8802223ec2c0 RSI: 0000000000000040 RDI: ffffffff81103898
RBP: ffff8802223f3d08 R08: 0000000000000000 R09: ffff8802223f3b98
R10: ffffffff81cfc860 R11: 0000000000000002 R12: 0000000000000292
R13: 0000000000000002 R14: ffff880219ac3e3c R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003397a07cc0 CR3: 000000021b7ce000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 29, threadinfo ffff8802223f2000, task ffff8802223ec2c0)
Stack:
  ffff88022bd8e5b0 00ff88022bd8e610 ffff8802223f3ce8 ffff88022bd8e5b0
  ffff880219ac3d58 ffff8802223f2000 ffff8802223f2000 ffffffff8110380d
  ffff8802223f3de8 ffffffff81103574 ffff8802223f3fd8 ffff8802223f2010
Call Trace:
  [<ffffffff8110380d>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff81103574>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e8db7>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea223>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7e6a>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7eae>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea245>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f0cac>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 40 00 00 00 e8 f5 ad 20 00 41 39 c5 0f 94 45 cf eb 0e 44 0f a3 28 45 19 ed 45 85 ed 0f 95 45 cf 4c 8d 73 24 45 31 ff 31 c0 f3 90 <44> 8b 6b 20 41 39 c5 74 
44 41 83 fd 02 74 08 41 83 fd 03 75 1f
NMI backtrace for cpu 1
CPU 1
Pid: 17, comm: migration/1 Tainted: G        WC   3.9.4+ #6 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff81103875>]  [<ffffffff81103875>] stop_machine_cpu_stop+0x68/0xfb
RSP: 0018:ffff88022230fcc8  EFLAGS: 00000093
RAX: 0000000000000002 RBX: ffff880219ac3e18 RCX: 0000000000000000
RDX: ffff8802223142c0 RSI: 0000000000000040 RDI: ffffffff81103898
RBP: ffff88022230fd08 R08: 0000000000000000 R09: ffff88022230fb98
R10: ffff880219ac3cf8 R11: ffff8802223ec2c0 R12: 0000000000000292
R13: 0000000000000002 R14: ffff880219ac3e3c R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88022bc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000440b70 CR3: 000000021a03b000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/1 (pid: 17, threadinfo ffff88022230e000, task ffff8802223142c0)
Stack:
  ffff88022bc8e5b0 00ff88022bc8e610 ffff88022230fce8 ffff88022bc8e5b0
  ffff880219ac3d58 ffff88022230e000 ffff88022230e000 ffffffff8110380d
  ffff88022230fde8 ffffffff81103574 ffff88022230ffd8 ffff88022230e010
Call Trace:
  [<ffffffff8110380d>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff81103574>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e8db7>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea223>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7e6a>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7eae>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea245>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f0cac>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 40 00 00 00 e8 f5 ad 20 00 41 39 c5 0f 94 45 cf eb 0e 44 0f a3 28 45 19 ed 45 85 ed 0f 95 45 cf 4c 8d 73 24 45 31 ff 31 c0 f3 90 <44> 8b 6b 20 41 39 c5 74 
44 41 83 fd 02 74 08 41 83 fd 03 75 1f
NMI backtrace for cpu 2
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC   3.9.4+ #6 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff81016549>]  [<ffffffff81016549>] native_read_tsc+0x14/0x16
RSP: 0000:ffff88022bd03b40  EFLAGS: 00000006
RAX: 00000057e22024ac RBX: ffff8802223b4000 RCX: 00000000e22024ac
RDX: 0000000000000057 RSI: 0000000000000002 RDI: 0000000000289789
RBP: ffff88022bd03b40 R08: 0000000000000002 R09: 0000000000000000
R10: ffff88022bd03a90 R11: 0000000000000006 R12: 000000000000006c
R13: 0000000000000002 R14: 0000000000000086 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000574fe0 CR3: 0000000214ca8000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff8802223b4000, task ffff8802223bc2c0)
Stack:
  ffff88022bd03ba0 ffffffff81309ea2 ffff88022bd03b70 0000000000000046
  ffff88022bd03b70 00289789810e5676 ffff88022bd03ba0 0000000000000001
  000000000000006c 0000000000000007 0000000000000086 0000000000000001
Call Trace:
  <IRQ>
  [<ffffffff81309ea2>] delay_tsc+0x40/0xee
  [<ffffffff81309e35>] __const_udelay+0x28/0x2a
  [<ffffffff8103053d>] arch_trigger_all_cpu_backtrace+0x66/0x7d
  [<ffffffff813c467a>] sysrq_handle_showallcpus+0xe/0x10
  [<ffffffff813c49ab>] __handle_sysrq+0xbf/0x15b
  [<ffffffff813c4d68>] handle_sysrq+0x2c/0x2e
  [<ffffffff813d8fcc>] serial8250_rx_chars+0x145/0x1c5
  [<ffffffff813d90be>] serial8250_handle_irq+0x72/0xa8
  [<ffffffff813d917f>] serial8250_default_handle_irq+0x23/0x28
  [<ffffffff813d7e14>] serial8250_interrupt+0x4d/0xc6
  [<ffffffff8110e760>] handle_irq_event_percpu+0x7a/0x1ea
  [<ffffffff8110e911>] handle_irq_event+0x41/0x61
  [<ffffffff8111113c>] handle_edge_irq+0xa6/0xcb
  [<ffffffff81011dd7>] handle_irq+0x24/0x2d
  [<ffffffff815f2a4d>] do_IRQ+0x4d/0xb4
  [<ffffffff815ea872>] common_interrupt+0x72/0x72
  [<ffffffff815ea937>] ? retint_restore_args+0x13/0x13
  [<ffffffff811146d2>] ? rcu_sched_qs+0x22/0x22
  [<ffffffff8109e4f1>] ? __do_softirq+0x185/0x25a
  [<ffffffff8109e68f>] irq_exit+0x5f/0xbc
  [<ffffffff815f2a9d>] do_IRQ+0x9d/0xb4
  [<ffffffff815ea872>] common_interrupt+0x72/0x72
  <EOI>
  [<ffffffff815ea937>] ? retint_restore_args+0x13/0x13
  [<ffffffff81103875>] ? stop_machine_cpu_stop+0x68/0xfb
  [<ffffffff81103853>] ? stop_machine_cpu_stop+0x46/0xfb
  [<ffffffff8110380d>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff81103574>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e8db7>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea223>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7e6a>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7eae>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea245>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f0cac>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: 31 c9 48 c1 ef 0a 48 01 f8 c3 55 48 89 e5 e8 33 0a 00 00 66 90 c9 c3 55 48 89 e5 0f 31 89 c1 48 89 d0 48 c1 e0 20 89 c9 48 09 c8 <c9> c3 55 8b 05 12 c3 ad 
00 48 89 e5 c9 c3 55 b8 ed ff ff ff 48
NMI backtrace for cpu 0
CPU 0
Pid: 8, comm: migration/0 Tainted: G        WC   3.9.4+ #6 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff81103879>]  [<ffffffff81103879>] stop_machine_cpu_stop+0x6c/0xfb
RSP: 0018:ffff8802222abcc8  EFLAGS: 00000093
RAX: 0000000000000002 RBX: ffff880219ac3e18 RCX: 0000000000000000
RDX: ffff8802222a42c0 RSI: 0000000000000040 RDI: ffffffff81103898
RBP: ffff8802222abd08 R08: 0000000000000000 R09: ffff8802222abb98
R10: ffffffff81a01ec8 R11: 0000000000000000 R12: 0000000000000292
R13: 0000000000000002 R14: ffff880219ac3e3c R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88022bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fff998bbff0 CR3: 0000000001a0c000 CR4: 00000000000007f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/0 (pid: 8, threadinfo ffff8802222aa000, task ffff8802222a42c0)
Stack:
  ffff88022bc0e5b0 01ff88022bc0e610 ffff8802222abce8 ffff88022bc0e5b0
  ffff880219ac3d58 ffff8802222aa000 ffff8802222aa000 ffffffff8110380d
  ffff8802222abde8 ffffffff81103574 ffff8802222abfd8 ffff8802222aa010
Call Trace:
  [<ffffffff8110380d>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff81103574>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815e8db7>] ? __schedule+0x5e7/0x62f
  [<ffffffff815ea223>] ? _raw_spin_unlock_irqrestore+0x47/0x77
  [<ffffffff810e7e6a>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e7eae>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ea245>] ? _raw_spin_unlock_irqrestore+0x69/0x77
  [<ffffffff810bdcb2>] smpboot_thread_fn+0x217/0x21d
  [<ffffffff810bda9b>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b6a86>] kthread+0xc7/0xcf
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f0cac>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b69bf>] ? __init_kthread_worker+0x5b/0x5b
Code: e8 f5 ad 20 00 41 39 c5 0f 94 45 cf eb 0e 44 0f a3 28 45 19 ed 45 85 ed 0f 95 45 cf 4c 8d 73 24 45 31 ff 31 c0 f3 90 44 8b 6b 20 <41> 39 c5 74 44 41 83 fd 
02 74 08 41 83 fd 03 75 1f eb 0e fa 66

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

