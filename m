Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaCHWKB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 17:10:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbaCHWJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 17:09:59 -0500
Date: Sat, 8 Mar 2014 17:09:27 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@gmail.com>, Christoph Hellwig <hch@infradead.org>,
        Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: fix q->flush_rq NULL pointer crash on dm-mpath flush
Message-ID: <20140308220926.GA15421@redhat.com>
References: <20140130132620.GA6031@infradead.org>
 <20140130132630.GB6031@infradead.org>
 <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com>
 <20140308155240.GA32297@infradead.org>
 <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com>
 <531B74B6.4070004@suse.de>
 <CAMM=eLfVpc=B7ZzxBDbKW4GZ_E5rOqrcbyppNBSz_brQaH4VNw@mail.gmail.com>
 <531B8CB1.2010502@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531B8CB1.2010502@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08 2014 at  4:33pm -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 03/08/2014 07:13 PM, Mike Snitzer wrote:
> >
> >I'm calm.. was just a bit frustrated.  But this isn't a big deal.
> >I'll make an effort to reach out to relevant people sooner when
> >similar stuff is reported against recently upstreamed code.  Would be
> >cool if you did the same.  I can relate to needing to have the distro
> >vendor hat on (first needing to determine/answer "is this issue
> >specific to our hacked distro kernel?", etc).
> >
> The patch I made wasn't in the context of 'recently upstreamed
> code', it was due to a backport Jan Kara did for our next distro
> kernels (3.12-based).

"3.12-based" means nothing given all the backporting for SLES, much like
"3.10-based" means nothing in the context of RHEL7.

The only way this fix is applicable is in the context of "recently
upstreamed code", commit 1874198 ("blk-mq: rework flush sequencing
logic") went upstream for v3.14-rc3.

Jens, please feel free to queue this tested fix for 3.14-rc:

From: Mike Snitzer <snitzer@redhat.com>
Subject: block: fix q->flush_rq NULL pointer crash on dm-mpath flush

Commit 1874198 ("blk-mq: rework flush sequencing logic") switched
->flush_rq from being an embedded member of the request_queue structure
to being dynamically allocated in blk_init_queue_node().

Request-based DM multipath doesn't use blk_init_queue_node(), instead it
uses blk_alloc_queue_node() + blk_init_allocated_queue().  Because
commit 1874198 placed the dynamic allocation of ->flush_rq in
blk_init_queue_node() any flush issued to a dm-mpath device would crash
with a NULL pointer, e.g.:

BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff8125037e>] blk_rq_init+0x1e/0xb0
PGD bb3c7067 PUD bb01d067 PMD 0
Oops: 0002 [#1] SMP
...
CPU: 5 PID: 5028 Comm: dt Tainted: G        W  O 3.14.0-rc3.snitm+ #10
...
task: ffff88032fb270e0 ti: ffff880079564000 task.ti: ffff880079564000
RIP: 0010:[<ffffffff8125037e>]  [<ffffffff8125037e>] blk_rq_init+0x1e/0xb0
RSP: 0018:ffff880079565c98  EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000030
RDX: ffff880260c74048 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff880079565ca8 R08: ffff880260aa1e98 R09: 0000000000000001
R10: ffff88032fa78500 R11: 0000000000000246 R12: 0000000000000000
R13: ffff880260aa1de8 R14: 0000000000000650 R15: 0000000000000000
FS:  00007f8d36a2a700(0000) GS:ffff88033fca0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000079b36000 CR4: 00000000000007e0
Stack:
 0000000000000000 ffff880260c74048 ffff880079565cd8 ffffffff81257a47
 ffff880260aa1de8 ffff880260c74048 0000000000000001 0000000000000000
 ffff880079565d08 ffffffff81257c2d 0000000000000000 ffff880260aa1de8
Call Trace:
 [<ffffffff81257a47>] blk_flush_complete_seq+0x2d7/0x2e0
 [<ffffffff81257c2d>] blk_insert_flush+0x1dd/0x210
 [<ffffffff8124ec59>] __elv_add_request+0x1f9/0x320
 [<ffffffff81250681>] ? blk_account_io_start+0x111/0x190
 [<ffffffff81253a4b>] blk_queue_bio+0x25b/0x330
 [<ffffffffa0020bf5>] dm_request+0x35/0x40 [dm_mod]
 [<ffffffff812530c0>] generic_make_request+0xc0/0x100
 [<ffffffff81253173>] submit_bio+0x73/0x140
 [<ffffffff811becdd>] submit_bio_wait+0x5d/0x80
 [<ffffffff81257528>] blkdev_issue_flush+0x78/0xa0
 [<ffffffff811c1f6f>] blkdev_fsync+0x3f/0x60
 [<ffffffff811b7fde>] vfs_fsync_range+0x1e/0x20
 [<ffffffff811b7ffc>] vfs_fsync+0x1c/0x20
 [<ffffffff811b81f1>] do_fsync+0x41/0x80
 [<ffffffff8118874e>] ? SyS_lseek+0x7e/0x80
 [<ffffffff811b8260>] SyS_fsync+0x10/0x20
 [<ffffffff8154c2d2>] system_call_fastpath+0x16/0x1b

Fix this by moving the ->flush_rq allocation from blk_init_queue_node()
to blk_init_allocated_queue().  blk_init_queue_node() also calls
blk_init_allocated_queue() so this change is functionality equivalent
for all blk_init_queue_node() callers.

Reported-by: Hannes Reinecke <hare@suse.de>
Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 853f927..4cd5ffc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -693,20 +693,11 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 	if (!uninit_q)
 		return NULL;
 
-	uninit_q->flush_rq = kzalloc(sizeof(struct request), GFP_KERNEL);
-	if (!uninit_q->flush_rq)
-		goto out_cleanup_queue;
-
 	q = blk_init_allocated_queue(uninit_q, rfn, lock);
 	if (!q)
-		goto out_free_flush_rq;
-	return q;
+		blk_cleanup_queue(uninit_q);
 
-out_free_flush_rq:
-	kfree(uninit_q->flush_rq);
-out_cleanup_queue:
-	blk_cleanup_queue(uninit_q);
-	return NULL;
+	return q;
 }
 EXPORT_SYMBOL(blk_init_queue_node);
 
@@ -717,6 +708,10 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	if (!q)
 		return NULL;
 
+	q->flush_rq = kzalloc(sizeof(struct request), GFP_KERNEL);
+	if (!q->flush_rq)
+		return NULL;
+
 	if (blk_init_rl(&q->root_rl, q, GFP_KERNEL))
 		return NULL;
 
