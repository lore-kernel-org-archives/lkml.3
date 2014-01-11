Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbaAKOnc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 09:43:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49937 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaAKOn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 09:43:28 -0500
Date: Sat, 11 Jan 2014 07:43:23 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matias Bjorling <m@bjorling.me>, Muthu Kumar <muthu.lkml@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ming Lei <tom.leiming@gmail.com>
Subject: Re: [block:for-3.14/core] blk-mq: Compile fix for null_blk
Message-ID: <20140111144323.GL6780@kernel.dk>
References: <CAFR8uedovPTT0562nZSAfatjqqhyi8WXRdHj5wa9oCkVbzrBag@mail.gmail.com>
 <52CF0D85.7060905@bjorling.me>
 <CA+55aFwC75Afeo8KKm5=v2c8_ynVG9E5VFGjbUnhyB765Ro4PA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwC75Afeo8KKm5=v2c8_ynVG9E5VFGjbUnhyB765Ro4PA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11 2014, Linus Torvalds wrote:
> On Fri, Jan 10, 2014 at 3:58 AM, Matias Bjorling <m@bjorling.me> wrote:
> >
> > The patch from Ming Lei is missing in -rc6
> >
> > 4af48694451676403188a62385dd1a2849fc05c5
> > block: null_blk: fix queue leak inside removing device
> >
> > Its queued for -rc7. It removes the usage of blk_mq_free_queue in blk_null.
> 
> Jens? I'm going to do an rc8 tomorrow, and I haven't seen any pull requests..

Sorry, between jobs and houses, and the two other patches in there were
being evaluated. If you could just apply this one directly, then that'd
be great!

commit 4af48694451676403188a62385dd1a2849fc05c5
Author: Ming Lei <tom.leiming@gmail.com>
Date:   Thu Dec 26 21:31:37 2013 +0800

    block: null_blk: fix queue leak inside removing device
    
    When queue_mode is NULL_Q_MQ and null_blk is being removed,
    blk_cleanup_queue() isn't called to cleanup queue, so the
    queue allocated won't be freed.
    
    This patch calls blk_cleanup_queue() for MQ to drain all
    pending requests first and release the reference counter
    of queue kobject, then blk_mq_free_queue() will be called
    in queue kobject's release handler when queue kobject's
    reference counter drops to zero.
    
    Cc: Jens Axboe <axboe@kernel.dk>
    Signed-off-by: Ming Lei <tom.leiming@gmail.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index a2e69d26266d..83a598ebb65a 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -425,10 +425,7 @@ static void null_del_dev(struct nullb *nullb)
 	list_del_init(&nullb->list);
 
 	del_gendisk(nullb->disk);
-	if (queue_mode == NULL_Q_MQ)
-		blk_mq_free_queue(nullb->q);
-	else
-		blk_cleanup_queue(nullb->q);
+	blk_cleanup_queue(nullb->q);
 	put_disk(nullb->disk);
 	kfree(nullb);
 }
@@ -578,10 +575,7 @@ static int null_add_dev(void)
 	disk = nullb->disk = alloc_disk_node(1, home_node);
 	if (!disk) {
 queue_fail:
-		if (queue_mode == NULL_Q_MQ)
-			blk_mq_free_queue(nullb->q);
-		else
-			blk_cleanup_queue(nullb->q);
+		blk_cleanup_queue(nullb->q);
 		cleanup_queues(nullb);
 err:
 		kfree(nullb);

-- 
Jens Axboe

