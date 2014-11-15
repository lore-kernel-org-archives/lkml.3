Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaKOVeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 16:34:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbaKOVeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 16:34:16 -0500
Date: Sat, 15 Nov 2014 16:34:05 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141115213405.GA31971@redhat.com>
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

 > But since you say "several times a day", just for fun, can you test
 > the follow-up patch to that one-liner fix that Will Deacon posted
 > today (Subject: "[PATCH] mmu_gather: move minimal range calculations
 > into generic code"). That does some further cleanup in this area.

A few hours ago it hit the NMI watchdog again with that patch applied.
Incomplete trace, but it looks different based on what did make it over.
Different RIP at least.

[65155.054155] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [trinity-c127:12559]
[65155.054573] irq event stamp: 296752
[65155.054589] hardirqs last  enabled at (296751): [<ffffffff9d87403d>] _raw_spin_unlock_irqrestore+0x5d/0x80
[65155.054625] hardirqs last disabled at (296752): [<ffffffff9d875cea>] apic_timer_interrupt+0x6a/0x80
[65155.054657] softirqs last  enabled at (296188): [<ffffffff9d259943>] bdi_queue_work+0x83/0x270
[65155.054688] softirqs last disabled at (296184): [<ffffffff9d259920>] bdi_queue_work+0x60/0x270
[65155.054721] CPU: 1 PID: 12559 Comm: trinity-c127 Not tainted 3.18.0-rc4+ #84 [loadavg: 209.68 187.90 185.33 34/431 17515]
[65155.054795] task: ffff88023f664680 ti: ffff8801649f0000 task.ti: ffff8801649f0000
[65155.054820] RIP: 0010:[<ffffffff9d87403f>]  [<ffffffff9d87403f>] _raw_spin_unlock_irqrestore+0x5f/0x80
[65155.054852] RSP: 0018:ffff8801649f3be8  EFLAGS: 00000292
[65155.054872] RAX: ffff88023f664680 RBX: 0000000000000007 RCX: 0000000000000007
[65155.054895] RDX: 00000000000029e0 RSI: ffff88023f664ea0 RDI: ffff88023f664680
[65155.054919] RBP: ffff8801649f3bf8 R08: 0000000000000000 R09: 0000000000000000
[65155.055956] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[65155.056985] R13: ffff8801649f3b58 R14: ffffffff9d3e7d0e R15: 00000000000003e0
[65155.058037] FS:  00007f0dc957c700(0000) GS:ffff880244200000(0000) knlGS:0000000000000000
[65155.059083] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[65155.060121] CR2: 00007f0dc958e000 CR3: 000000022f31e000 CR4: 00000000001407e0
[65155.061152] DR0: 00007f54162bc000 DR1: 00007feb92c3d000 DR2: 0000000000000000
[65155.062180] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[65155.063202] Stack:

And that's all she wrote.

 > If Will's patch doesn't make a difference, what about reverting that
 > ce9ec37bddb6? Although it really *is* a "obvious bugfix", and I really
 > don't see why any of this would be noticeable on x86 (it triggered
 > issues on ARM64, but that was because ARM64 cared much more about the
 > exact range).

I'll try that next, and check in on it tomorrow.

	Dave
