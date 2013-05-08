Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab3EHGUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 02:20:09 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34732 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3EHGUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 02:20:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130508051602.GV28721@atomide.com>
References: <alpine.LFD.2.03.1305070936320.2383@kernel.org>
	<20130508003022.GS28721@atomide.com>
	<20130508042422.GU28721@atomide.com>
	<20130508051602.GV28721@atomide.com>
Date: Wed, 8 May 2013 09:20:06 +0300
X-Google-Sender-Auth: QraA65FpcQ86IsgKlXXHGKV-buY
Message-ID: <CAOJsxLEB2gSWefNHNeKfxv9Hp=H9PG0bGgTcUPE4abz3fv_fxw@mail.gmail.com>
Subject: Re: [GIT PULL] SLAB changes for v3.10
From: Pekka Enberg <penberg@kernel.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Wed, May 8, 2013 at 8:16 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Tony Lindgren <tony@atomide.com> [130507 21:30]:
>> * Tony Lindgren <tony@atomide.com> [130507 17:35]:
>> > * Pekka Enberg <penberg@kernel.org> [130506 23:42]:
>> > > Hi Linus,
>> > >
>> > > Please pull the latest SLAB tree from:
>> > >
>> > >   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus
>> > ...
>> >
>> > >       mm, slab_common: Fix bootstrap creation of kmalloc caches
>> >
>> > This one seems to cause a regression for me on at least arm omap
>> > and vexpress that depends on some kconfig option I have not been
>> > able to figure out yet. Reverting 8a965b3b fixes the issue.
>> >
>> > Any ideas?
>>
>> OK got it narrowed down to CONFIG_DEBUG_SPINLOCK=y causing the problem
>> with commit 8a965b3b. Ain't nothing like bisecting and booting and then
>> diffing .config files on top of that.
>
> Hmm it's actually CONFIG_PROVE_LOCKING=y that causes the problem,
> not CONFIG_DEBUG_SPINLOCK=y. CONFIG_DEBUG_SPINLOCK=y was just selected
> by CONFIG_PROVE_LOCKING=y in my non-booting .config. I can now fix my
> non-booting .config by removing PROVE_LOCKING and DEBUG_SPINLOCK,
> but I cannot break my other working .config by adding PROVE_LOCKING
> and DEBUG_SPINLOCK. Hmm.

That's almost certainly a slab bootstrap issue. Lockdep et al just
change struct sizes which is why the problem shows up. Is this with
SLAB or SLUB? Christoph, Glauber, care to take a look?

>> > Without reverting 8a965b3b I'm getting:
>> >
>> > [    0.000000] Unable to handle kernel NULL pointer dereference at virtual address 00000054
>> > [    0.000000] pgd = c0004000
>> > [    0.000000] [00000054] *pgd=00000000
>> > [    0.000000] Internal error: Oops: 5 [#1] SMP ARM
>> > [    0.000000] Modules linked in:
>> > [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.9.0-11486-g6d13e11 #689
>> > [    0.000000] task: c06f77c8 ti: c06ec000 task.ti: c06ec000
>> > [    0.000000] PC is at kmem_cache_alloc_trace+0x50/0x178
>> > [    0.000000] LR is at kmem_cache_alloc_trace+0x38/0x178
>> > [    0.000000] pc : [<c00edab4>]    lr : [<c00eda9c>]    psr: 600001d3
>> > [    0.000000] sp : c06edf70  ip : 600001d3  fp : 00000000
>> > [    0.000000] r10: 000000c0  r9 : c0086958  r8 : 000080d0
>> > [    0.000000] r7 : 00000000  r6 : 600001d3  r5 : 00000000  r4 : 00008000
>> > [    0.000000] r3 : 00000050  r2 : c06ec000  r1 : c06f77c8  r0 : c00eda9c
>> > [    0.000000] Flags: nZCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
>> > [    0.000000] Control: 10c5387d  Table: 6000406a  DAC: 00000015
>> > [    0.000000] Process swapper/0 (pid: 0, stack limit = 0xc06ec240)
>> > [    0.000000] Stack: (0xc06edf70 to 0xc06ee000)
>> > [    0.000000] df60:                                     00002014 00000010 c0702890 00000000
>> > [    0.000000] df80: 00000000 00000000 00000000 410fc090 c06f4480 c0086958 c0702890 00000000
>> > [    0.000000] dfa0: 00000010 c06dc0b0 ffffffff c06b44f4 9fffffff c073834c c0738340 c06a5828
>> > [    0.000000] dfc0: ffffffff ffffffff c06a5478 00000000 00000000 c06dc0b0 00000000 10c5387d
>> > [    0.000000] dfe0: c06f44c8 c06dc4b4 c06f8cac 6000406a 00000000 60008074 00000000 00000000
>> > [    0.000000] [<c00edab4>] (kmem_cache_alloc_trace+0x50/0x178) from [<c0086958>] (alloc_desc+0x24/0xb4)
>> > [    0.000000] [<c0086958>] (alloc_desc+0x24/0xb4) from [<c06b44f4>] (early_irq_init+0x78/0xec)
>> > [    0.000000] [<c06b44f4>] (early_irq_init+0x78/0xec) from [<c06a5828>] (start_kernel+0x17c/0x33c)
>> > [    0.000000] [<c06a5828>] (start_kernel+0x17c/0x33c) from [<60008074>] (0x60008074)
>> > [    0.000000] Code: e5923014 e2833014 e1a03103 e0873003 (e5931004)
>> > [    0.000000] ---[ end trace 1b75b31a2719ed1c ]---
