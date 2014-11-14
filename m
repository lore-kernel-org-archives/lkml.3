Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422764AbaKNWbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:31:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161930AbaKNWbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:31:10 -0500
Date: Fri, 14 Nov 2014 17:30:59 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141114223059.GA10281@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>
References: <20141114213124.GB3344@redhat.com>
 <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 02:01:27PM -0800, Linus Torvalds wrote:
 
 > Plus, judging by the fact that there's a stale "leave_mm+0x210/0x210"
 > (wouldn't that be the *next* function, namely do_flush_tlb_all())
 > pointer on the stack, I suspect that whole range-flushing doesn't even
 > trigger, and we are flushing everything.
 > 
 > But since you say "several times a day", just for fun, can you test
 > the follow-up patch to that one-liner fix that Will Deacon posted
 > today (Subject: "[PATCH] mmu_gather: move minimal range calculations
 > into generic code"). That does some further cleanup in this area.

I'll give it a shot. Should know by the morning if it changes anything.

 > > The trace doesn't really enlighten me as to what we should be doing
 > > to prevent this though.
 > >
 > > ideas?
 > 
 > I can't say I have any ideas except to point at the TLB range patch,
 > and quite frankly, I don't see how that would matter.
 > 
 > If Will's patch doesn't make a difference, what about reverting that
 > ce9ec37bddb6? Although it really *is* a "obvious bugfix", and I really
 > don't see why any of this would be noticeable on x86 (it triggered
 > issues on ARM64, but that was because ARM64 cared much more about the
 > exact range).

Digging through the serial console logs, there was one other trace variant,
which is even less informative..

NMI watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [trinity-c104:19168]
irq event stamp: 223186
hardirqs last  enabled at (223185): [<ffffffff941a4092>] context_tracking_user_exit+0x52/0x260
hardirqs last disabled at (223186): [<ffffffff948756aa>] apic_timer_interrupt+0x6a/0x80
softirqs last  enabled at (187030): [<ffffffff9407f43a>] __do_softirq+0x26a/0x6f0
softirqs last disabled at (187017): [<ffffffff9407fb4d>] irq_exit+0x13d/0x170
CPU: 3 PID: 19168 Comm: trinity-c104 Not tainted 3.18.0-rc4+ #82 [loadavg: 99.30 85.88 82.88 9/303 19302]
task: ffff88023f8b4680 ti: ffff880157418000 task.ti: ffff880157418000
RIP: 0010:[<ffffffff941a4094>]  [<ffffffff941a4094>] context_tracking_user_exit+0x54/0x260
RSP: 0018:ffff88015741bee8  EFLAGS: 00000246
RAX: ffff88023f8b4680 RBX: ffffffff940b111b RCX: 0000000000000000
RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88023f8b4680
RBP: ffff88015741bef8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88015741bf58 R14: ffff88023f8b4ae8 R15: ffff88023f8b4b18
FS:  00007f9a0789b740(0000) GS:ffff880244e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000003dfa1b7c90 CR3: 0000000165f3c000 CR4: 00000000001407e0
DR0: 00000000ffffffbf DR1: 00007f2c0c3d9000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Stack:
 0000000000080000 ffff88015741c000 ffff88015741bf78 ffffffff94013d35
 ffff88015741bf28 ffffffff940d865d 0000000000004b02 0000000000000000
 00007f9a071bb000 ffffffff943d816b 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff94013d35>] syscall_trace_enter_phase1+0x125/0x1a0
 [<ffffffff940d865d>] ? trace_hardirqs_on_caller+0x16d/0x210
 [<ffffffff943d816b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff9487487f>] tracesys+0x14/0x4a
Code: fa e8 51 0a f3 ff 48 c7 c7 26 52 cd 94 e8 f5 21 24 00 65 8b 04 25 f4 f8 1c 00 83 f8 01 74 28 f6 c7 02 74 13 e8 6e 46 f3 ff 53 9d <5b> 41 5c 5d c3 0f 1f 80
 00 00 00 00 53 9d e8 19 0a f3 ff eb eb 

It looks like I've been seeing these since 3.18-rc1 though,
but for those, the machine crashed before the trace even made it
over usb-serial, leaving just the "NMI watchdog" line.


 > > I can try to bisect it, but it takes hours before it happens,
 > > so it might take days to complete, and the next few weeks are
 > > complicated timewise..
 > 
 > Hmm. Even narrowing it down a bit might help, ie if you could get say
 > four bisections in over a day, and see if that at least says "ok, it's
 > likely one of these pulls".
 > 
 > But yeah, I can see it being painful, so maybe a quick check of the
 > TLB ones, even if I can't for the life see why they would possibly
 > matter.

Assuming the NMI watchdog traces I saw in rc1 are the same problem,
I'll see if I can bisect between .17 and .18rc1 on Monday, and see
if that yields anything interesting.

	Dave

