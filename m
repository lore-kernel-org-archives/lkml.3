Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422817AbaKNWB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:01:29 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:61920 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422734AbaKNWB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:01:28 -0500
MIME-Version: 1.0
In-Reply-To: <20141114213124.GB3344@redhat.com>
References: <20141114213124.GB3344@redhat.com>
Date: Fri, 14 Nov 2014 14:01:27 -0800
X-Google-Sender-Auth: k2pJ156eHsP-slq-x2Dy6vcFo3s
Message-ID: <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 1:31 PM, Dave Jones <davej@redhat.com> wrote:
> I'm not sure how long this goes back (3.17 was fine afair) but I'm
> seeing these several times a day lately..

Hmm. I don't see what would have changed in this area since v3.17.
There's a TLB range fix in mm/memory.c, but for the life of me I can't
see how that would possibly matter the way x86 does TLB flushing (if
the range fix does something bad and the range goes too large, x86
will just end up doing a full TLB invalidate instead).

Plus, judging by the fact that there's a stale "leave_mm+0x210/0x210"
(wouldn't that be the *next* function, namely do_flush_tlb_all())
pointer on the stack, I suspect that whole range-flushing doesn't even
trigger, and we are flushing everything.

But since you say "several times a day", just for fun, can you test
the follow-up patch to that one-liner fix that Will Deacon posted
today (Subject: "[PATCH] mmu_gather: move minimal range calculations
into generic code"). That does some further cleanup in this area.

I don't see any changes to the x86 IPI or TLB flush handling, but
maybe I'm missing something, so I'm adding the x86 maintainers to the
cc.

> I've got a local hack to dump loadavg on traces, and as you can see in that
> example, the machine was really busy, but we were at least making progress
> before the trace spewed, and the machine rebooted. (I have reboot-on-lockup sysctl
> set, without it, the machine just wedges indefinitely shortly after the spew).
>
> The trace doesn't really enlighten me as to what we should be doing
> to prevent this though.
>
> ideas?

I can't say I have any ideas except to point at the TLB range patch,
and quite frankly, I don't see how that would matter.

If Will's patch doesn't make a difference, what about reverting that
ce9ec37bddb6? Although it really *is* a "obvious bugfix", and I really
don't see why any of this would be noticeable on x86 (it triggered
issues on ARM64, but that was because ARM64 cared much more about the
exact range).

> I can try to bisect it, but it takes hours before it happens,
> so it might take days to complete, and the next few weeks are
> complicated timewise..

Hmm. Even narrowing it down a bit might help, ie if you could get say
four bisections in over a day, and see if that at least says "ok, it's
likely one of these pulls".

But yeah, I can see it being painful, so maybe a quick check of the
TLB ones, even if I can't for the life see why they would possibly
matter.

                 Linus

---
> NMI watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [trinity-c129:25570]
> irq event stamp: 74224
> hardirqs last  enabled at (74223): [<ffffffff9c875664>] restore_args+0x0/0x30
> hardirqs last disabled at (74224): [<ffffffff9c8759aa>] apic_timer_interrupt+0x6a/0x80
> softirqs last  enabled at (74222): [<ffffffff9c07f43a>] __do_softirq+0x26a/0x6f0
> softirqs last disabled at (74209): [<ffffffff9c07fb4d>] irq_exit+0x13d/0x170
> CPU: 3 PID: 25570 Comm: trinity-c129 Not tainted 3.18.0-rc4+ #83 [loadavg: 198.04 186.66 181.58 24/442 26708]
> RIP: 0010:[<ffffffff9c11e98a>]  [<ffffffff9c11e98a>] generic_exec_single+0xea/0x1d0
> Call Trace:
>  [<ffffffff9c048b20>] ? leave_mm+0x210/0x210
>  [<ffffffff9c048b20>] ? leave_mm+0x210/0x210
>  [<ffffffff9c11ead6>] smp_call_function_single+0x66/0x110
>  [<ffffffff9c048b20>] ? leave_mm+0x210/0x210
>  [<ffffffff9c11f021>] smp_call_function_many+0x2f1/0x390
>  [<ffffffff9c049300>] flush_tlb_mm_range+0xe0/0x370
>  [<ffffffff9c1d95a2>] tlb_flush_mmu_tlbonly+0x42/0x50
>  [<ffffffff9c1d9cb5>] tlb_finish_mmu+0x45/0x50
>  [<ffffffff9c1daf59>] zap_page_range_single+0x119/0x170
>  [<ffffffff9c1db140>] unmap_mapping_range+0x140/0x1b0
>  [<ffffffff9c1c7edd>] shmem_fallocate+0x43d/0x540
>  [<ffffffff9c223aba>] do_fallocate+0x12a/0x1c0
>  [<ffffffff9c1f0bd3>] SyS_madvise+0x3d3/0x890
>  [<ffffffff9c874c89>] tracesys_phase2+0xd4/0xd9
> Kernel panic - not syncing: softlockup: hung tasks
