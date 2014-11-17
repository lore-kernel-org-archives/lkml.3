Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaKQPHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:07:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbaKQPHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:07:33 -0500
Date: Mon, 17 Nov 2014 10:07:28 -0500
From: Don Zickus <dzickus@redhat.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141117150728.GN108701@redhat.com>
References: <20141114213124.GB3344@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114213124.GB3344@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 04:31:24PM -0500, Dave Jones wrote:
> I'm not sure how long this goes back (3.17 was fine afair) but I'm
> seeing these several times a day lately..
> 
> 
> NMI watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [trinity-c129:25570]
> irq event stamp: 74224
> hardirqs last  enabled at (74223): [<ffffffff9c875664>] restore_args+0x0/0x30
> hardirqs last disabled at (74224): [<ffffffff9c8759aa>] apic_timer_interrupt+0x6a/0x80
> softirqs last  enabled at (74222): [<ffffffff9c07f43a>] __do_softirq+0x26a/0x6f0
> softirqs last disabled at (74209): [<ffffffff9c07fb4d>] irq_exit+0x13d/0x170
> CPU: 3 PID: 25570 Comm: trinity-c129 Not tainted 3.18.0-rc4+ #83 [loadavg: 198.04 186.66 181.58 24/442 26708]
> task: ffff880213442f00 ti: ffff8801ea714000 task.ti: ffff8801ea714000
> RIP: 0010:[<ffffffff9c11e98a>]  [<ffffffff9c11e98a>] generic_exec_single+0xea/0x1d0
> RSP: 0018:ffff8801ea717a08  EFLAGS: 00000202
> RAX: ffff880213442f00 RBX: ffffffff9c875664 RCX: 0000000000000006
> RDX: 0000000000001370 RSI: ffff880213443790 RDI: ffff880213442f00
> RBP: ffff8801ea717a68 R08: ffff880242b56690 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801ea717978
> R13: ffff880213442f00 R14: ffff8801ea714000 R15: ffff880213442f00
> FS:  00007f240994e700(0000) GS:ffff880244600000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000004 CR3: 000000019a017000 CR4: 00000000001407e0
> DR0: 00007fb3367e0000 DR1: 00007f82542ab000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Stack:
>  ffffffff9ce4c620 0000000000000000 ffffffff9c048b20 ffff8801ea717b18
>  0000000000000003 0000000052e0da3d ffffffff9cc7ef3c 0000000000000002
>  ffffffff9c048b20 ffff8801ea717b18 0000000000000001 0000000000000003
> Call Trace:
>  [<ffffffff9c048b20>] ? leave_mm+0x210/0x210
>  [<ffffffff9c048b20>] ? leave_mm+0x210/0x210
>  [<ffffffff9c11ead6>] smp_call_function_single+0x66/0x110
>  [<ffffffff9c048b20>] ? leave_mm+0x210/0x210
>  [<ffffffff9c11f021>] smp_call_function_many+0x2f1/0x390


Hi Dave,

When I usually see stuff like this, it is because another cpu is blocking
the IPI from smp_call_function_many from finishing, so this cpu waits
forever.

The problem usually becomes obvious with a dump of all cpus at the time
the lockup is detected.

Can you try adding 'softlockup_all_cpu_backtrace=1' to the kernel
commandline?  That should dump all the cpus to see if anything stands out.

Though I don't normally see it traverse down to smp_call_function_single.

Anyway something to try.

Cheers,
Don

>  [<ffffffff9c049300>] flush_tlb_mm_range+0xe0/0x370
>  [<ffffffff9c1d95a2>] tlb_flush_mmu_tlbonly+0x42/0x50
>  [<ffffffff9c1d9cb5>] tlb_finish_mmu+0x45/0x50
>  [<ffffffff9c1daf59>] zap_page_range_single+0x119/0x170
>  [<ffffffff9c1db140>] unmap_mapping_range+0x140/0x1b0
>  [<ffffffff9c1c7edd>] shmem_fallocate+0x43d/0x540
>  [<ffffffff9c0b111b>] ? preempt_count_sub+0xab/0x100
>  [<ffffffff9c0cdac7>] ? prepare_to_wait+0x27/0x80
>  [<ffffffff9c2287f3>] ? __sb_start_write+0x103/0x1d0
>  [<ffffffff9c223aba>] do_fallocate+0x12a/0x1c0
>  [<ffffffff9c1f0bd3>] SyS_madvise+0x3d3/0x890
>  [<ffffffff9c1a40d2>] ? context_tracking_user_exit+0x52/0x260
>  [<ffffffff9c013ebd>] ? syscall_trace_enter_phase2+0x10d/0x3d0
>  [<ffffffff9c874c89>] tracesys_phase2+0xd4/0xd9
> Code: 63 c7 48 89 de 48 89 df 48 c7 c2 c0 50 1d 00 48 03 14 c5 40 b9 f2 9c e8 d5 ea 2b 00 84 c0 74 0b e9 bc 00 00 00 0f 1f 40 00 f3 90 <f6> 43 18 01 75 f8 31 c0 48 8b 4d c8 65 48 33 0c 25 28 00 00 00 
> Kernel panic - not syncing: softlockup: hung tasks
> 
> 
> I've got a local hack to dump loadavg on traces, and as you can see in that
> example, the machine was really busy, but we were at least making progress
> before the trace spewed, and the machine rebooted. (I have reboot-on-lockup sysctl
> set, without it, the machine just wedges indefinitely shortly after the spew).
> 
> The trace doesn't really enlighten me as to what we should be doing
> to prevent this though.
> 
> ideas?
> I can try to bisect it, but it takes hours before it happens,
> so it might take days to complete, and the next few weeks are
> complicated timewise..
> 
> 	Dave
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
