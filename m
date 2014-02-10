Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaBJLYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:24:25 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44221 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbaBJLYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:24:21 -0500
Date: Mon, 10 Feb 2014 03:24:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
Subject: virtio_blk softlockup in block/for-linus
Message-ID: <20140210112420.GA17598@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running xfstests on Jens' current for-linus tree I see the
softlockup below (which locks the VM hard).  I bisected it down to 
"blk-mq: Don't reserve a tag for flush request".  My recently posted
flush rework also fixes the issue, btw.

generic/006 4s ... 3s
[   60.026776] BUG: soft lockup - CPU#0 stuck for 22s! [umount:7783]
[   60.030047] Modules linked in:
[   60.030047] irq event stamp: 81329012
[   60.030047] hardirqs last  enabled at (81329011): [<ffffffff81754e6d>] percpu_ida_free+0x8d/0x180
[   60.030047] hardirqs last disabled at (81329012): [<ffffffff81cde7ad>] apic_timer_interrupt+0x6d/0x80
[   60.030047] softirqs last  enabled at (81315148): [<ffffffff810b26bb>] __do_softirq+0x1eb/0x2e0
[   60.030047] softirqs last disabled at (81315143): [<ffffffff810b2aae>] irq_exit+0x9e/0xc0
[   60.030047] CPU: 0 PID: 7783 Comm: umount Not tainted 3.13.0+ #266
[   60.030047] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   60.030047] task: ffff880077e2c010 ti: ffff880074848000 task.ti: ffff880074848000
[   60.030047] RIP: 0010:[<ffffffff81754e72>]  [<ffffffff81754e72>] percpu_ida_free+0x92/0x180
[   60.030047] RSP: 0018:ffff8800748497a8  EFLAGS: 00000216
[   60.030047] RAX: ffff880077e2c010 RBX: ffffffff810fa1fa RCX: 0000000000000006
[   60.030047] RDX: 0000000000000006 RSI: ffff880077e2c7a8 RDI: 0000000000000216
[   60.030047] RBP: ffff8800748497d8 R08: 0000000000000006 R09: 0000000000000001
[   60.030047] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880077e2c010
[   60.030047] R13: 0000000000000006 R14: 0000000000000007 R15: ffff880077e2c7a8
[   60.030047] FS:  00007ff81e94a7e0(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[   60.030047] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   60.030047] CR2: 000000000132d808 CR3: 0000000077da8000 CR4: 00000000000006f0
[   60.030047] Stack:
[   60.030047]  ffff8800748497a8 ffff88007b627400 0000000000001c31 ffff88007b6d0148
[   60.030047]  ffff88007fc19cc0 0000000000000010 ffff8800748497e8 ffffffff8172b47f
[   60.030047]  ffff880074849808 ffffffff8172b4c0 ffff88007fc19cc0 ffff88007b627800
[   60.030047] Call Trace:
[   60.030047]  [<ffffffff8172b47f>] blk_mq_put_tag+0x2f/0x40
[   60.030047]  [<ffffffff8172b4c0>] blk_mq_wait_for_tags+0x30/0x40
[   60.030047]  [<ffffffff8172a2ad>] blk_mq_alloc_request_pinned+0x4d/0xf0
[   60.030047]  [<ffffffff8172ab18>] blk_mq_make_request+0x478/0x4d0
[   60.030047]  [<ffffffff8171eee0>] generic_make_request+0xc0/0x110
[   60.030047]  [<ffffffff8171ef9c>] submit_bio+0x6c/0x140
[   60.030047]  [<ffffffff814b9f06>] _xfs_buf_ioapply+0x2c6/0x3a0
[   60.030047]  [<ffffffff81526c21>] ? xlog_bdstrat+0x21/0x60
[   60.030047]  [<ffffffff814ba04a>] xfs_buf_iorequest+0x6a/0xc0
[   60.030047]  [<ffffffff81526c21>] xlog_bdstrat+0x21/0x60
[   60.030047]  [<ffffffff81528c47>] xlog_sync+0x3a7/0x5c0
[   60.030047]  [<ffffffff81528f84>] xlog_state_release_iclog+0x124/0x130
[   60.030047]  [<ffffffff8152a043>] xlog_write+0x653/0x7d0
[   60.030047]  [<ffffffff8152b0fc>] xlog_cil_push+0x2cc/0x450
[   60.030047]  [<ffffffff8152b9f8>] xlog_cil_force_lsn+0x1a8/0x1d0
[   60.030047]  [<ffffffff811d77cc>] ? sync_inodes_sb+0x20c/0x260
[   60.030047]  [<ffffffff815293a7>] _xfs_log_force+0x67/0x280
[   60.030047]  [<ffffffff815295e5>] xfs_log_force+0x25/0x80
[   60.030047]  [<ffffffff814cf5fd>] xfs_fs_sync_fs+0x2d/0x50
[   60.030047]  [<ffffffff811dcb35>] sync_filesystem+0x95/0xd0
[   60.030047]  [<ffffffff811ae4a6>] generic_shutdown_super+0x36/0x100
[   60.030047]  [<ffffffff811ae59b>] kill_block_super+0x2b/0x80
[   60.030047]  [<ffffffff811aebed>] deactivate_locked_super+0x3d/0x70
[   60.030047]  [<ffffffff811af449>] deactivate_super+0x49/0x70
[   60.030047]  [<ffffffff811cb9bb>] mntput_no_expire+0x16b/0x250
[   60.030047]  [<ffffffff811ccde9>] ? SyS_umount+0x99/0x450
[   60.030047]  [<ffffffff811c38de>] ? dput+0x1e/0x110
[   60.030047]  [<ffffffff811ccde9>] SyS_umount+0x99/0x450
[   60.030047]  [<ffffffff81cddbb9>] ? system_call_fastpath+0x16/0x1b
[   60.030047]  [<ffffffff81cddbb9>] system_call_fastpath+0x16/0x1b

