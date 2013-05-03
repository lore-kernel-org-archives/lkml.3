Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762831Ab3ECIkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 04:40:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:43846 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab3ECIks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 04:40:48 -0400
Date: Fri, 3 May 2013 10:40:46 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jain Priyanka-B32167 <B32167@freescale.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.8.10-rt6
Message-ID: <20130503084046.GB8230@linutronix.de>
References: <20130429201202.GB7979@linutronix.de>
 <AC83832D6324604BB08FAE5A33553F190B360375@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AC83832D6324604BB08FAE5A33553F190B360375@039-SN2MPN1-013.039d.mgd.msft.net>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jain Priyanka-B32167 | 2013-05-03 04:40:33 [+0000]:

>Hello Sebastian,
Hello Jain,

>It is mentioned below that SLxB is broken.
>I assume it means bit SLUB and SLAB is broken?

Yes. It looks like that this is limited to Book-E / e500. I have here a
MPC8572DS which shows this:
|[27173.423355] ------------[ cut here ]------------
|[27173.423360] kernel BUG at mm/slab.c:3227!
|[27173.423364] Oops: Exception in kernel mode, sig: 5 [#1]
|[27173.423367] PREEMPT SMP NR_CPUS=2 MPC8572 DS
|[27173.423370] NIP: 800b236c LR: 800b2290 CTR: 802bd168
|[27173.423373] REGS: ba557b90 TRAP: 0700   Not tainted  (3.8.9-rt4-dirty)
|[27173.423378] MSR: 00029000 <CE,EE,ME>  CR: 24002444  XER: 00000000
|[27173.423402] TASK = ba101290[31018] 'hackbench' THREAD: ba556000 CPU: 0
|[27173.423402] GPR00: 800b2bb8 ba557c40 ba101290 b7374200 000106d0 00000000 00000000 00000200
|[27173.423402] GPR08: 00000001 00000008 00000008 b7a0fc60 24002462 1001a810 00000000 803c0000
|[27173.423402] GPR16: 00000001 bf002490 bf002488 803c0000 00100100 00200200 bf002480 803c32f0
|[27173.423402] GPR24: 00000000 bf0024a4 000106d0 ba556000 bf000540 bf00f200 00000003 81eb5ae0
|[27173.423412] NIP [800b236c] cache_alloc_refill+0x16c/0x7e8
|[27173.423414] LR [800b2290] cache_alloc_refill+0x90/0x7e8
|[27173.423415] Call Trace:
|[27173.423422] [ba557c40] [802d0c54] rt_spin_lock_slowlock+0x58/0x288 (unreliable)
|[27173.423426] [ba557c90] [800b2bb8] __kmalloc+0x1d0/0x204
|[27173.423432] [ba557cc0] [80236ee4] __kmalloc_reserve+0x28/0x84
|[27173.423435] [ba557ce0] [80236fc4] __alloc_skb+0x84/0x18c
|[27173.423439] [ba557d20] [802338ec] sock_alloc_send_pskb+0x1d8/0x36c
|[27173.423444] [ba557d80] [802bd414] unix_stream_sendmsg+0x2ac/0x3ec
|[27173.423453] [ba557de0] [8022e4c4] sock_aio_write+0x110/0x148
|[27173.423458] [ba557e40] [800b7030] do_sync_write+0x94/0x108
|[27173.423462] [ba557ef0] [800b7204] vfs_write+0x160/0x170
|[27173.423465] [ba557f10] [800b7308] sys_write+0x4c/0xa8
|[27173.423471] [ba557f40] [8000d3c0] ret_from_syscall+0x0/0x3c
|[27173.423473] --- Exception: c01 at 0xffad0ec
|[27173.423473]     LR = 0x100011c8
|[27173.423474] Instruction dump:
|[27173.423480] 3de0803c 62940100 62b50200 3a560008 83f60000 7f16f800 419a019c 813f0010
|[27173.423486] 815c0018 7d0a4810 39000000 7d084114 <0f080000> 7f0a4840 40990084 3bdeffff
|[27173.604492] ---[ end trace 0000000000000002 ]---

after (according to the timestamp) 7:32 hours runtime. It run was
running in one shell
| cyclictest -m -n -S -p 80 -d 0 -i 500
and the other
|while ((1)); do hackbench; done

This was done with SLAB, the backtrace is different with SLUB. I
tried with one CPU but it is same thing.

I tried MPC5200b based board and it did not do anything stupid for over
two days while doing exact the same thing.
The obvious difference is the different MMU implementation of those two.
The other difference is ~400Mhz CPU vs 1.5Ghz.

>Can you please share the error-details/logs/scenario/steps-to-reproduce.

As I wrote above, cyclictest + hackbench. My MPC8572 boots from hard
disk into a e500 based root file system (that means it uses its FPU for
floating point instead SW-emulation).

>Regards
>Priyanka

Sebastian
