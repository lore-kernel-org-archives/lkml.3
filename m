Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbaKTP2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:28:45 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:41839 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498AbaKTP2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:28:43 -0500
Date: Thu, 20 Nov 2014 16:28:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Lutomirski <luto@amacapital.net>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141120152837.GF2542@lerouge>
References: <20141114213124.GB3344@redhat.com>
 <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
 <20141115213405.GA31971@redhat.com>
 <20141116014006.GA5016@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141116014006.GA5016@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2014 at 08:40:06PM -0500, Dave Jones wrote:
> On Sat, Nov 15, 2014 at 04:34:05PM -0500, Dave Jones wrote:
>  > On Fri, Nov 14, 2014 at 02:01:27PM -0800, Linus Torvalds wrote:
>  > 
>  >  > But since you say "several times a day", just for fun, can you test
>  >  > the follow-up patch to that one-liner fix that Will Deacon posted
>  >  > today (Subject: "[PATCH] mmu_gather: move minimal range calculations
>  >  > into generic code"). That does some further cleanup in this area.
>  > 
>  > A few hours ago it hit the NMI watchdog again with that patch applied.
>  > Incomplete trace, but it looks different based on what did make it over.
>  > Different RIP at least.
>  > 
>  > [65155.054155] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c127:12559]
>  > [65155.054573] irq event stamp: 296752
>  > [65155.054589] hardirqs last  enabled at (296751): [<ffffffff9d87403d>] _raw_spin_unlock_irqrestore+0x5d/0x80
>  > [65155.054625] hardirqs last disabled at (296752): [<ffffffff9d875cea>] apic_timer_interrupt+0x6a/0x80
>  > [65155.054657] softirqs last  enabled at (296188): [<ffffffff9d259943>] bdi_queue_work+0x83/0x270
>  > [65155.054688] softirqs last disabled at (296184): [<ffffffff9d259920>] bdi_queue_work+0x60/0x270
>  > [65155.054721] CPU: 1 PID: 12559 Comm: trinity-c127 Not tainted 3.18.0-rc4+ #84 [loadavg: 209.68 187.90 185.33 34/431 17515]
>  > [65155.054795] task: ffff88023f664680 ti: ffff8801649f0000 task.ti: ffff8801649f0000
>  > [65155.054820] RIP: 0010:[<ffffffff9d87403f>]  [<ffffffff9d87403f>] _raw_spin_unlock_irqrestore+0x5f/0x80
>  > [65155.054852] RSP: 0018:ffff8801649f3be8  EFLAGS: 00000292
>  > [65155.054872] RAX: ffff88023f664680 RBX: 0000000000000007 RCX: 0000000000000007
>  > [65155.054895] RDX: 00000000000029e0 RSI: ffff88023f664ea0 RDI: ffff88023f664680
>  > [65155.054919] RBP: ffff8801649f3bf8 R08: 0000000000000000 R09: 0000000000000000
>  > [65155.055956] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>  > [65155.056985] R13: ffff8801649f3b58 R14: ffffffff9d3e7d0e R15: 00000000000003e0
>  > [65155.058037] FS:  00007f0dc957c700(0000) GS:ffff880244200000(0000) knlGS:0000000000000000
>  > [65155.059083] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  > [65155.060121] CR2: 00007f0dc958e000 CR3: 000000022f31e000 CR4: 00000000001407e0
>  > [65155.061152] DR0: 00007f54162bc000 DR1: 00007feb92c3d000 DR2: 0000000000000000
>  > [65155.062180] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
>  > [65155.063202] Stack:
>  > 
>  > And that's all she wrote.
>  > 
>  >  > If Will's patch doesn't make a difference, what about reverting that
>  >  > ce9ec37bddb6? Although it really *is* a "obvious bugfix", and I really
>  >  > don't see why any of this would be noticeable on x86 (it triggered
>  >  > issues on ARM64, but that was because ARM64 cared much more about the
>  >  > exact range).
>  > 
>  > I'll try that next, and check in on it tomorrow.
> 
> No luck. Died even faster this time.
> 
> [  772.459481] NMI watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [modprobe:31400]
> [  772.459858] irq event stamp: 3362
> [  772.459872] hardirqs last  enabled at (3361): [<ffffffff941a437c>] context_tracking_user_enter+0x9c/0x2c0
> [  772.459907] hardirqs last disabled at (3362): [<ffffffff94875bea>] apic_timer_interrupt+0x6a/0x80
> [  772.459937] softirqs last  enabled at (0): [<ffffffff940764d5>] copy_process.part.26+0x635/0x1d80
> [  772.459968] softirqs last disabled at (0): [<          (null)>]           (null)
> [  772.459996] CPU: 3 PID: 31400 Comm: modprobe Not tainted 3.18.0-rc4+ #85 [loadavg: 207.70 163.33 92.64 11/433 31547]
> [  772.460086] task: ffff88022f0b2f00 ti: ffff88019a944000 task.ti: ffff88019a944000
> [  772.460110] RIP: 0010:[<ffffffff941a437e>]  [<ffffffff941a437e>] context_tracking_user_enter+0x9e/0x2c0
> [  772.460142] RSP: 0018:ffff88019a947f00  EFLAGS: 00000282
> [  772.460161] RAX: ffff88022f0b2f00 RBX: 0000000000000000 RCX: 0000000000000000
> [  772.460184] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88022f0b2f00
> [  772.460207] RBP: ffff88019a947f10 R08: 0000000000000000 R09: 0000000000000000
> [  772.460229] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88019a947e90
> [  772.460252] R13: ffffffff940f6d04 R14: ffff88019a947ec0 R15: ffff8802447cd640
> [  772.460294] FS:  00007f3b71ee4700(0000) GS:ffff880244600000(0000) knlGS:0000000000000000
> [  772.460362] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  772.460391] CR2: 00007fffdad5af58 CR3: 000000011608e000 CR4: 00000000001407e0
> [  772.460424] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  772.460447] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  772.460470] Stack:
> [  772.460480]  ffff88019a947f58 00000000006233a8 ffff88019a947f40 ffffffff9401429d
> [  772.460512]  00000000006233a8 000000000041d68a 00000000006233a8 0000000000000000
> [  772.460543]  00000000006233a0 ffffffff94874fa4 000000001008feff 000507d93d73a434
> [  772.460574] Call Trace:
> [  772.461576]  [<ffffffff9401429d>] syscall_trace_leave+0xad/0x2e0
> [  772.462572]  [<ffffffff94874fa4>] int_check_syscall_exit_work+0x34/0x3d
> [  772.463575] Code: f8 1c 00 84 c0 75 46 48 c7 c7 51 53 cd 94 e8 aa 23 24 00 65 c7 04 25 f4 f8 1c 00 01 00 00 00 f6 c7 02 74 19 e8 84 43 f3 ff 53 9d <5b> 41 5c 5d c3 0f 1f 44 00 00 c3 0f 1f 80 00 00 00 00 53 9d e8 
> [  772.465797] Kernel panic - not syncing: softlockup: hung tasks
> [  772.466821] CPU: 3 PID: 31400 Comm: modprobe Tainted: G             L 3.18.0-rc4+ #85 [loadavg: 207.70 163.33 92.64 11/433 31547]
> [  772.468915]  ffff88022f0b2f00 00000000de65d5f5 ffff880244603dc8 ffffffff94869e01
> [  772.470031]  0000000000000000 ffffffff94c7599b ffff880244603e48 ffffffff94866b21
> [  772.471085]  ffff880200000008 ffff880244603e58 ffff880244603df8 00000000de65d5f5
> [  772.472141] Call Trace:
> [  772.473183]  <IRQ>  [<ffffffff94869e01>] dump_stack+0x4f/0x7c
> [  772.474253]  [<ffffffff94866b21>] panic+0xcf/0x202
> [  772.475346]  [<ffffffff94154d1e>] watchdog_timer_fn+0x27e/0x290
> [  772.476414]  [<ffffffff94106297>] __run_hrtimer+0xe7/0x740
> [  772.477475]  [<ffffffff94106b64>] ? hrtimer_interrupt+0x94/0x270
> [  772.478555]  [<ffffffff94154aa0>] ? watchdog+0x40/0x40
> [  772.479627]  [<ffffffff94106be7>] hrtimer_interrupt+0x117/0x270
> [  772.480703]  [<ffffffff940303db>] local_apic_timer_interrupt+0x3b/0x70
> [  772.481777]  [<ffffffff948777f3>] smp_apic_timer_interrupt+0x43/0x60
> [  772.482856]  [<ffffffff94875bef>] apic_timer_interrupt+0x6f/0x80
> [  772.483915]  <EOI>  [<ffffffff941a437e>] ? context_tracking_user_enter+0x9e/0x2c0
> [  772.484972]  [<ffffffff9401429d>] syscall_trace_leave+0xad/0x2e0

It looks like we are looping somewhere around syscall_trace_leave(). Maybe the
TIF WORK_SYSCALL_EXIT flags aren't cleared properly after some of them got processed. Or
something keeps setting a TIF_WORK_SYSCALL_EXIT flag after they get cleared and we loop
endlessly to jump to int_check_syscall_exit_work().

Andi did some work there lately. Cc'ing him.

> [  772.486042]  [<ffffffff94874fa4>] int_check_syscall_exit_work+0x34/0x3d
> [  772.487187] Kernel Offset: 0x13000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> 
> 
> 	Dave
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
