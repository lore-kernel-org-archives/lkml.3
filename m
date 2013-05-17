Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab3EQVcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:32:46 -0400
Received: from mail-ye0-f169.google.com ([209.85.213.169]:40130 "EHLO
	mail-ye0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab3EQVco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:32:44 -0400
Date: Fri, 17 May 2013 16:32:23 -0500
From: Calvin Owens <jcalvinowens@gmail.com>
To: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: [PATCH] md: Partially revert 2f6db2a7, which broke raid5
Message-ID: <20130517213223.GA2530@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2f6db2a7 was part of a series that cleaned up mdraid code by
replacing explicit re-initialization of struct bio with bio_reset().

In raid5 it incorrectly assumed that a couple initializations of its
members was a full reset, erasing the existing data and unconditionally
triggering the following BUG when assembling arrays:

[   14.653072] kernel BUG at /home/calvinow/git/linux/drivers/scsi/scsi_lib.c:1196!
[   14.653074] invalid opcode: 0000 [#1] PREEMPT SMP
[   14.653076] CPU: 1 PID: 40 Comm: kworker/1:0H Not tainted 3.10.0-rc1-amd-00279-g8f710dd #3
[   14.653077] Hardware name: System manufacturer System Product Name/M5A88-M, BIOS 0601    09/20/2011
[   14.653082] Workqueue: kblockd blk_delay_work
<snip>
[   14.653123] Call Trace:
[   14.653126]  [<ffffffff81477248>] sd_prep_fn+0x2c8/0xb70
[   14.653129]  [<ffffffff812c8b70>] ? deadline_remove_request.isra.9+0x50/0x90
[   14.653132]  [<ffffffff812b8f5b>] blk_peek_request+0xdb/0x210
[   14.653134]  [<ffffffff81465f15>] scsi_request_fn+0x45/0x4e0
[   14.653136]  [<ffffffff812b6a51>] __blk_run_queue+0x31/0x40
[   14.653138]  [<ffffffff812b6a84>] blk_delay_work+0x24/0x40
[   14.653141]  [<ffffffff8105dc2a>] process_one_work+0x1da/0x490
[   14.653143]  [<ffffffff8105dbcd>] ? process_one_work+0x17d/0x490
[   14.653145]  [<ffffffff8105e32a>] worker_thread+0x11a/0x370
[   14.653147]  [<ffffffff8105e210>] ? rescuer_thread+0x2f0/0x2f0
[   14.653149]  [<ffffffff81066296>] kthread+0xd6/0xe0
[   14.653151]  [<ffffffff810661c0>] ? __kthread_unpark+0x50/0x50
[   14.653154]  [<ffffffff816e4d6c>] ret_from_fork+0x7c/0xb0
[   14.653156]  [<ffffffff810661c0>] ? __kthread_unpark+0x50/0x50
[   14.653172] Code: <snip>
[   14.653174] RIP  [<ffffffff81467329>] scsi_setup_fs_cmnd+0x89/0x90

Signed-off-by: Calvin Owens <jcalvinowens@gmail.com>
---
 drivers/md/raid5.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9359828..97be03f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -643,7 +643,6 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 			set_bit(STRIPE_IO_STARTED, &sh->state);
 
-			bio_reset(bi);
 			bi->bi_bdev = rdev->bdev;
 			bi->bi_rw = rw;
 			bi->bi_end_io = (rw & WRITE)
@@ -664,9 +663,12 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
 				bi->bi_rw |= REQ_FLUSH;
 
+			bi->bi_flags = 1 << BIO_UPTODATE;
+			bi->bi_idx = 0;
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			bi->bi_io_vec[0].bv_offset = 0;
 			bi->bi_size = STRIPE_SIZE;
+			bi->bi_next = NULL;
 			if (rrdev)
 				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
 
@@ -683,7 +685,6 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 			set_bit(STRIPE_IO_STARTED, &sh->state);
 
-			bio_reset(rbi);
 			rbi->bi_bdev = rrdev->bdev;
 			rbi->bi_rw = rw;
 			BUG_ON(!(rw & WRITE));
-- 
1.8.2.1

