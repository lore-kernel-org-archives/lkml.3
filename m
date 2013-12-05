Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab3LEOWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:22:53 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:63612 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3LEOWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:22:51 -0500
Date: Thu, 5 Dec 2013 22:22:20 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Ming Lei <tom.leiming@gmail.com>
Subject: Re: [OOPS, 3.13-rc2] null ptr in dio_complete()
Message-ID: <20131205222220.5d7f4a48@tom-ThinkPad-T410>
In-Reply-To: <20131204015837.GJ10988@dastard>
References: <20131203215940.GX10988@dastard>
	<20131204015837.GJ10988@dastard>
Organization: Ming
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013 12:58:38 +1100
Dave Chinner <david@fromorbit.com> wrote:

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

This one might be caused by using-after-'free' request because the freed
request may be allocated to another CPU immediately, and the below patch
may be helpful, would you mind testing it?

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6875736..2358bdf 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -311,12 +311,12 @@ void blk_mq_complete_request(struct request *rq, int error)
 
 	blk_account_io_completion(rq, bytes);
 
+	blk_account_io_done(rq);
+
 	if (rq->end_io)
 		rq->end_io(rq, error);
 	else
 		blk_mq_free_request(rq);
-
-	blk_account_io_done(rq);
 }
 
 void __blk_mq_end_io(struct request *rq, int error)


Thanks,
-- 
Ming Lei
