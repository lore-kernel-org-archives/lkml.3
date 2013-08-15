Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab3HOQWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 12:22:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758226Ab3HOQWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 12:22:50 -0400
Date: Thu, 15 Aug 2013 18:23:16 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Mike Christie <mchristie@fusionio.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Message-ID: <20130815162316.GA27882@dhcp-26-207.brq.redhat.com>
References: <1374193399.7397.973.camel@haakon3.risingtidesystems.com>
 <20130719003034.GG28005@kernel.dk>
 <1374195825.7397.997.camel@haakon3.risingtidesystems.com>
 <1374215660.7397.1041.camel@haakon3.risingtidesystems.com>
 <1374248000.2266.20.camel@dabdike>
 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
 <51EAA33C.9010405@fusionio.com>
 <20130809191542.GD25306@dhcp-26-207.brq.redhat.com>
 <1376079457.5171.172.camel@haakon3.risingtidesystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376079457.5171.172.camel@haakon3.risingtidesystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 01:17:37PM -0700, Nicholas A. Bellinger wrote:
> On Fri, 2013-08-09 at 21:15 +0200, Alexander Gordeev wrote:
> Mmmm, I'm able to reproduce over here with ahci + scsi-mq, and it
> appears to be a bug related with using sdev->sdev_md_req.queue_depth=1,
> that ends up causing the blkdev_issue_flush() to wait forever because
> blk_mq_wait_for_tags() never ends up getting the single tag back for the
> WRITE_FLUSH bio -> SYNCHRONIZE_CACHE cdb.

It turns out this way - blkdev_issue_flush() claims the only tag, submits
the bio and waits for the completion. But because blk_mq_make_request()
does not mark any context in blk_mq_hw_ctx::ctx_map (nor enslists the request
into blk_mq_ctx::rq_list) it never gets processed from blk_mq_work_fn->
__blk_mq_run_hw_queue() and blkdev_issue_flush() waits endlessly. All other
requests are just waiting for the tag availability as result.

[...]

> Bumping queue_depth=2 seems to work-around the issue, but AFAICT it's a
> genuine tag starvation bug with queue_depth=1 and WRITE_FLUSH..

If I try to hack and force __blk_mq_run_hw_queue() to process the request...

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6fc1df3..c22b6f66 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -889,9 +962,12 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	hctx->queued++;
 
 	if (unlikely(is_flush_fua)) {
+		list_add(&rq->queuelist, &hctx->dispatch);
 		blk_mq_bio_to_request(q, rq, bio);
 		blk_mq_put_ctx(ctx);
 		blk_insert_flush(rq);
 		goto run_queue;
 	}

... I get a kernel BUG at drivers/scsi/scsi_lib.c:1233

	BUG_ON(!req->nr_phys_segments);

IOW I am not sure how to proceed.

> --nab
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
