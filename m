Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3LDDiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 22:38:55 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:45194 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468Ab3LDDiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 22:38:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AloHACmjnlJ5LHyk/2dsb2JhbABagweDMbB+hU+BIBd0giUBAQU6HCMQCAMYCSUPBSUDNIgAwUIXFo5oB4QzA5gTikyHSIM9KA
Date: Wed, 4 Dec 2013 14:38:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: Re: [OOPS, 3.13-rc2] null ptr in dio_complete()
Message-ID: <20131204033815.GK10988@dastard>
References: <20131203215940.GX10988@dastard>
 <20131204015837.GJ10988@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204015837.GJ10988@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 12:58:38PM +1100, Dave Chinner wrote:
> On Wed, Dec 04, 2013 at 08:59:40AM +1100, Dave Chinner wrote:
> > Hi Jens,
> > 
> > Not sure who to direct this to or CC, so I figured you are the
> > person to do that. I just had xfstests generic/299 (an AIO/DIO test)
> > oops in dio_complete() like so:
> > 
> > [ 9650.586724] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> > [ 9650.590131] Modules linked in:
> > [ 9650.590630] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc2-dgc+ #73
> > [ 9650.590630] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> > [ 9650.590630] task: ffffffff81f35480 ti: ffffffff81f24000 task.ti: ffffffff81f24000
> > [ 9650.590630] RIP: 0010:[<ffffffff811ee5f1>]  [<ffffffff811ee5f1>] aio_complete+0xb1/0x1e0
> > [ 9650.590630] RSP: 0018:ffff88007f803cf8  EFLAGS: 00010003
> > [ 9650.590630] RAX: 0000000000000086 RBX: ffff8800688ae000 RCX: 0000000000d6d6d6
> > [ 9650.590630] RDX: 6b6b6b6b6b6b6b6b RSI: 0000000000001000 RDI: ffff8800688ae1c4
> > [ 9650.590630] RBP: ffff88007f803d28 R08: 0000000000000000 R09: 000000006b6b6b6c
> > [ 9650.590630] R10: ff79a1a35779b009 R11: 0000000000000010 R12: ffff88006953a540
> > [ 9650.590630] R13: 0000000000001000 R14: 0000000000000000 R15: ffff8800688ae1c4
> > [ 9650.590630] FS:  0000000000000000(0000) GS:ffff88007f800000(0000) knlGS:0000000000000000
> > [ 9650.590630] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [ 9650.590630] CR2: 00007ffa9c48448f CR3: 0000000028061000 CR4: 00000000000006f0
> > [ 9650.590630] Stack:
> > [ 9650.590630]  ffff88007f803d18 0000000000001000 ffff880068b80800 0000000000001000
> > [ 9650.590630]  0000000000000001 0000000031f6d000 ffff88007f803d68 ffffffff811ddae3
> > [ 9650.590630]  0000000000000086 ffff880068b80800 0000000000000000 ffff880068b80828
> > [ 9650.590630] Call Trace:
> > [ 9650.590630]  <IRQ>
> > [ 9650.590630]  [<ffffffff811ddae3>] dio_complete+0xa3/0x140
> > [ 9650.590630]  [<ffffffff811ddc2a>] dio_bio_end_aio+0x7a/0x110
> > [ 9650.590630]  [<ffffffff811ddbb5>] ? dio_bio_end_aio+0x5/0x110
> > [ 9650.590630]  [<ffffffff811d8a9d>] bio_endio+0x1d/0x30
> > [ 9650.590630]  [<ffffffff8175d65f>] blk_mq_complete_request+0x5f/0x120
> > [ 9650.590630]  [<ffffffff8175d736>] __blk_mq_end_io+0x16/0x20
> > [ 9650.590630]  [<ffffffff8175d7a8>] blk_mq_end_io+0x68/0xd0
> > [ 9650.590630]  [<ffffffff818539a7>] virtblk_done+0x67/0x110
> > [ 9650.590630]  [<ffffffff817f74c5>] vring_interrupt+0x35/0x60
> > [ 9650.590630]  [<ffffffff810e4e34>] handle_irq_event_percpu+0x54/0x1e0
> > [ 9650.590630]  [<ffffffff810e5008>] handle_irq_event+0x48/0x70
> > [ 9650.590630]  [<ffffffff8107d6f5>] ? kvm_guest_apic_eoi_write+0x5/0x50
> > [ 9650.590630]  [<ffffffff810e7807>] handle_edge_irq+0x77/0x110
> > [ 9650.590630]  [<ffffffff8104796f>] handle_irq+0xbf/0x150
> > [ 9650.590630]  [<ffffffff810478b5>] ? handle_irq+0x5/0x150
> > [ 9650.590630]  [<ffffffff81aee136>] ? atomic_notifier_call_chain+0x16/0x20
> > [ 9650.590630]  [<ffffffff81af43ca>] do_IRQ+0x5a/0xe0
> > [ 9650.590630]  [<ffffffff81aea16d>] common_interrupt+0x6d/0x6d
> > [ 9650.590630]  <EOI>
> > [ 9650.590630]  [<ffffffff8107e616>] ? native_safe_halt+0x6/0x10
> > [ 9650.590630]  [<ffffffff8104e4f5>] ? default_idle+0x5/0xc0
> > [ 9650.590630]  [<ffffffff8104e50f>] default_idle+0x1f/0xc0
> > [ 9650.590630]  [<ffffffff8104edb6>] arch_cpu_idle+0x26/0x30
> > [ 9650.590630]  [<ffffffff810e4331>] cpu_startup_entry+0x81/0x240
> > [ 9650.590630]  [<ffffffff81ad5d67>] rest_init+0x77/0x80
> > [ 9650.590630]  [<ffffffff8203ceec>] start_kernel+0x3cd/0x3da
> > [ 9650.590630]  [<ffffffff8203c91e>] ? repair_env_string+0x5e/0x5e
> > [ 9650.590630]  [<ffffffff8203c117>] ? early_idt_handlers+0x117/0x120
> > [ 9650.590630]  [<ffffffff8203c5c2>] x86_64_start_reservations+0x2a/0x2c
> > [ 9650.590630]  [<ffffffff8203c70a>] x86_64_start_kernel+0x146/0x155
> > [ 9650.590630] Code: e8 05 b5 8f 00 44 8b 8b c0 01 00 00 45 31 c0 48 8b 93 98 00 00 00 41 83 c1 01 44 3b 8b 80 00 00 00 44 89 c9 45 0f 42 c1 c1 e9 07 <48> 8b 0c ca 65
> > [ 9650.590630] RIP  [<ffffffff811ee5f1>] aio_complete+0xb1/0x1e0
> > [ 9650.590630]  RSP <ffff88007f803cf8>
> > 
> > I'm not sure if it is related to blk_mq, virtio, dio  or bio changes
> > (or even somethign else), but I haven't seen anything like this
> > before. I've only seen it once so far (haven't rerun the test yet at
> > all).
> 
> And I just hit this from running xfs_repair which is doing
> multithreaded direct IO directly on /dev/vdc:
> 
> [ 1776.508599] BUG: unable to handle kernel NULL pointer dereference at 0000000000000328
> [ 1776.510446] IP: [<ffffffff81755b6a>] blk_account_io_done+0x6a/0x180
> [ 1776.511762] PGD 38e75b067 PUD 41987d067 PMD 0
> [ 1776.512577] Oops: 0000 [#1] SMP
> [ 1776.512577] Modules linked in:
> [ 1776.512577] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc2-dgc+ #75
> [ 1776.512577] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [ 1776.512577] task: ffffffff81f37480 ti: ffffffff81f26000 task.ti: ffffffff81f26000
> [ 1776.512577] RIP: 0010:[<ffffffff81755b6a>]  [<ffffffff81755b6a>] blk_account_io_done+0x6a/0x180
> [ 1776.512577] RSP: 0000:ffff88011bc03da8  EFLAGS: 00010046
> [ 1776.512577] RAX: 0000000010000000 RBX: 0000000000000000 RCX: 0000000000000000
> [ 1776.512577] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff8800dba59fc0
> [ 1776.512577] RBP: ffff88011bc03db8 R08: 0000000000000000 R09: ffff88021a828928
> [ 1776.512577] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
> [ 1776.512577] R13: 0000000000000000 R14: 0000000000002000 R15: 0000000000000000
> [ 1776.512577] FS:  0000000000000000(0000) GS:ffff88011bc00000(0000) knlGS:0000000000000000
> [ 1776.512577] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1776.512577] CR2: 0000000000000328 CR3: 000000041a4b0000 CR4: 00000000000006f0
> [ 1776.512577] Stack:
> [ 1776.512577]  0000000000000000 ffff8800dba59fc0 ffff88011bc03df8 ffffffff8175e4b8
> [ 1776.512577]  00000000000001c0 ffff8800dba59fc0 ffffe8fcfbc03a80 ffff88041aac0800
> [ 1776.512577]  ffff88011ad53b10 0000000000000096 ffff88011bc03e08 ffffffff8175e536
> [ 1776.512577] Call Trace:
> [ 1776.512577]  <IRQ>
> [ 1776.512577]  [<ffffffff8175e4b8>] blk_mq_complete_request+0xb8/0x120
> [ 1776.512577]  [<ffffffff8175e536>] __blk_mq_end_io+0x16/0x20
> [ 1776.512577]  [<ffffffff8175e5a8>] blk_mq_end_io+0x68/0xd0
> [ 1776.512577]  [<ffffffff81852e47>] virtblk_done+0x67/0x110
> [ 1776.512577]  [<ffffffff817f7925>] vring_interrupt+0x35/0x60
> [ 1776.512577]  [<ffffffff810e48a4>] handle_irq_event_percpu+0x54/0x1e0
> [ 1776.512577]  [<ffffffff810e4a78>] handle_irq_event+0x48/0x70
> [ 1776.512577]  [<ffffffff810e71d7>] handle_edge_irq+0x77/0x110
> [ 1776.512577]  [<ffffffff8104796f>] handle_irq+0xbf/0x150
> [ 1776.512577]  [<ffffffff81aec8c2>] ? __atomic_notifier_call_chain+0x12/0x20
> [ 1776.512577]  [<ffffffff81aec8e6>] ? atomic_notifier_call_chain+0x16/0x20
> [ 1776.512577]  [<ffffffff81af2b8a>] do_IRQ+0x5a/0xe0
> [ 1776.512577]  [<ffffffff81ae892d>] common_interrupt+0x6d/0x6d
> [ 1776.512577]  <EOI>
> [ 1776.512577]  [<ffffffff8107e626>] ? native_safe_halt+0x6/0x10
> [ 1776.512577]  [<ffffffff8104e50f>] default_idle+0x1f/0xc0
> [ 1776.512577]  [<ffffffff8104edb6>] arch_cpu_idle+0x26/0x30
> [ 1776.512577]  [<ffffffff810e3d81>] cpu_startup_entry+0x81/0x240
> [ 1776.512577]  [<ffffffff81ad4f97>] rest_init+0x77/0x80
> [ 1776.512577]  [<ffffffff82041ee7>] start_kernel+0x3c8/0x3d5
> [ 1776.512577]  [<ffffffff8204191e>] ? repair_env_string+0x5e/0x5e
> [ 1776.512577]  [<ffffffff82041117>] ? early_idt_handlers+0x117/0x120
> [ 1776.512577]  [<ffffffff820415c2>] x86_64_start_reservations+0x2a/0x2c
> [ 1776.512577]  [<ffffffff8204170a>] x86_64_start_kernel+0x146/0x155
> [ 1776.512577] Code: 54 41 89 c4 53 41 83 e4 01 48 2b 97 d8 00 00 00 48 8b 9f d0 00 00 00 4d 63 e4 65 44 8b 04 25 1c b0 00 00 49 8d 74 24 02 49 63 c8 <48> 8b 83 28 03
> [ 1776.512577] RIP  [<ffffffff81755b6a>] blk_account_io_done+0x6a/0x180
> [ 1776.512577]  RSP <ffff88011bc03da8>
> [ 1776.512577] CR2: 0000000000000328
> [ 1776.512577] ---[ end trace 33a5787221ff13b4 ]---
> [ 1776.512577] Kernel panic - not syncing: Fatal exception in interrupt
> [ 1776.512577] Shutting down cpus with NMI
> 
> So this is looking like another virtio+blk_mq problem....

This one is definitely reproducable. Just hit it again...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
