Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaFDPWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:22:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44890 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaFDPWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:22:18 -0400
Date: Wed, 4 Jun 2014 08:22:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
Message-ID: <20140604152217.GA8781@infradead.org>
References: <20140510040023.GA13788@kernel.org>
 <5388912F.7010609@kernel.dk>
 <20140604111133.GA7826@infradead.org>
 <538F2A11.4060800@kernel.dk>
 <20140604142012.GA20056@infradead.org>
 <538F331F.60101@kernel.dk>
 <20140604145803.GA7826@infradead.org>
 <538F34FB.7050003@kernel.dk>
 <20140604150508.GA21551@infradead.org>
 <538F365C.8050604@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538F365C.8050604@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 09:08:12AM -0600, Jens Axboe wrote:
> On 2014-06-04 09:05, Christoph Hellwig wrote:
> >On Wed, Jun 04, 2014 at 09:02:19AM -0600, Jens Axboe wrote:
> >>OK strange, there hasn't been that much churn since the last rebase.
> >>In my for-linus, there's a patch for a single queue crash, but that
> >>should just hit for the removal case. And then there's the atomic
> >>schedule patch, but that issue was actually in the code base for
> >>about a month, so not a new one either.
> >
> >You're request initializaion optimization doesn't set up req->cmd and
> >thus causes all BLOCK_PC I/O (including the SCSI LUN scan) to crash and
> >burn.  The trivial fix is on your way.
> 
> OK. That'll arguably be a good cleanup as well, getting that
> initialized in the right place. I hate the 'lets clear all the
> memory' part of rq init, it's not super cheap to do.

What would the right place be?  We don't really know if a request is
going to be used for BLOCK_PC purposes until it has been returned to
the caller.

I also found another issue when just initializing req->cmd instead
of blindly reverting the patch due to the lack of req->biotail
initialization.  For now I'll got back to a revert of that patch
for my scsi-mq tree, and I'd prefer to keep that for mainline as well
until this has been throughoutly tested.

[    1.139357] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=8, opts=0x0
[    1.143630] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[    1.145583] IP: [<ffffffff817242b4>] ll_back_merge_fn+0x84/0x170
[    1.146692] PGD 0 
[    1.146692] Oops: 0000 [#1] SMP 
[    1.146692] Modules linked in:
[    1.146692] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc1+ #138
[    1.146692] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    1.146692] task: ffff88007d490010 ti: ffff88007d48e000 task.ti: ffff88007d48e000
[    1.146692] RIP: 0010:[<ffffffff817242b4>]  [<ffffffff817242b4>] ll_back_merge_fn+0x84/0x170
[    1.146692] RSP: 0000:ffff88007d48f818  EFLAGS: 00010287
[    1.146692] RAX: 0000000000000000 RBX: ffff88007b100000 RCX: 0000000000000000
[    1.146692] RDX: 0000000000000400 RSI: 0000000000000000 RDI: ffff88007d7bc290
[    1.146692] RBP: ffff88007d48f838 R08: 0000000000000500 R09: 0000000000000000
[    1.146692] R10: 000000000000ffff R11: 0000000000000000 R12: ffff88007d7dad00
[    1.146692] R13: ffff88007d7bc290 R14: ffff88007d7dad00 R15: ffff88007b100000
[    1.146692] FS:  0000000000000000(0000) GS:ffff88007fc80000(0000) knlGS:0000000000000000
[    1.146692] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.146692] CR2: 0000000000000010 CR3: 0000000002347000 CR4: 00000000000006e0
[    1.146692] Stack:
[    1.146692]  ffff88007b100000 ffff88007d7dad00 0000000000000001 ffff88007d7dad00
[    1.146692]  ffff88007d48f858 ffffffff81722f92 ffff88007d7bc290 ffff88007b100000
[    1.146692]  ffff88007d48f898 ffffffff81723090 ffff88007d48f898 ffffffff811a195d
[    1.146692] Call Trace:
[    1.146692]  [<ffffffff81722f92>] blk_rq_append_bio+0x22/0x70
[    1.146692]  [<ffffffff81723090>] blk_rq_map_kern+0xb0/0x170
[    1.146692]  [<ffffffff811a195d>] ? cache_alloc_debugcheck_after.isra.63+0x9d/0x1b0
[    1.146692]  [<ffffffff818f5b68>] scsi_execute+0x148/0x170
[    1.146692]  [<ffffffff818f5c27>] scsi_execute_req_flags+0x97/0x110
[    1.146692]  [<ffffffff818f99c8>] scsi_probe_and_add_lun+0x208/0xd00
[    1.146692]  [<ffffffff810f61ba>] ? mark_held_locks+0x6a/0x90
[    1.146692]  [<ffffffff81d48e3a>] ? _raw_spin_unlock_irqrestore+0x3a/0x70
[    1.146692]  [<ffffffff818cfab5>] ? __pm_runtime_resume+0x55/0x70
[    1.146692]  [<ffffffff818fa7d8>] __scsi_scan_target+0xe8/0x6d0
[    1.146692]  [<ffffffff810f61ba>] ? mark_held_locks+0x6a/0x90
[    1.146692]  [<ffffffff81d48e3a>] ? _raw_spin_unlock_irqrestore+0x3a/0x70
[    1.146692]  [<ffffffff810f62ed>] ? trace_hardirqs_on_caller+0x10d/0x1d0
[    1.146692]  [<ffffffff818fae1e>] scsi_scan_channel.part.8+0x5e/0x80
[    1.146692]  [<ffffffff818fb1a9>] scsi_scan_host_selected+0x109/0x1d0
[    1.146692]  [<ffffffff818fb2f9>] do_scsi_scan_host+0x89/0x90
[    1.146692]  [<ffffffff818fb490>] scsi_scan_host+0x190/0x1c0
[    1.146692]  [<ffffffff819a0323>] sdebug_driver_probe+0x163/0x2d0
[    1.146692]  [<ffffffff818c7136>] driver_probe_device+0x76/0x240
[    1.146692]  [<ffffffff818c73b0>] ? __driver_attach+0xb0/0xb0
[    1.146692]  [<ffffffff818c73fb>] __device_attach+0x4b/0x60
[    1.146692]  [<ffffffff818c530e>] bus_for_each_drv+0x4e/0xa0
[    1.146692]  [<ffffffff818c7088>] device_attach+0x98/0xb0
[    1.146692]  [<ffffffff818c65b0>] bus_probe_device+0xb0/0xe0
[    1.146692]  [<ffffffff818c45c6>] device_add+0x466/0x590
[    1.146692]  [<ffffffff818d0306>] ? pm_runtime_init+0x106/0x110
[    1.146692]  [<ffffffff818c48a9>] device_register+0x19/0x20
[    1.146692]  [<ffffffff819a058c>] sdebug_add_adapter+0xfc/0x1c0
[    1.146692]  [<ffffffff824e404f>] scsi_debug_init+0x5e0/0x665
[    1.146692]  [<ffffffff824e3a6f>] ? osd_uld_init+0xc3/0xc3
[    1.146692]  [<ffffffff81000352>] do_one_initcall+0x102/0x160
[    1.146692]  [<ffffffff82492128>] kernel_init_freeable+0x108/0x19c
[    1.146692]  [<ffffffff824918ca>] ? do_early_param+0x8c/0x8c
[    1.146692]  [<ffffffff81d35510>] ? rest_init+0xc0/0xc0
[    1.146692]  [<ffffffff81d35519>] kernel_init+0x9/0xe0
[    1.146692]  [<ffffffff81d5180c>] ret_from_fork+0x7c/0xb0
[    1.146692]  [<ffffffff81d35510>] ? rest_init+0xc0/0xc0

