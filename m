Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaCIA6E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 19:58:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbaCIA6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 19:58:00 -0500
Date: Sat, 8 Mar 2014 19:57:29 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>,
        Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: block: fix q->flush_rq NULL pointer crash on dm-mpath flush
Message-ID: <20140309005729.GA18321@redhat.com>
References: <20140130132620.GA6031@infradead.org>
 <20140130132630.GB6031@infradead.org>
 <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com>
 <20140308155240.GA32297@infradead.org>
 <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com>
 <531B74B6.4070004@suse.de>
 <CAMM=eLfVpc=B7ZzxBDbKW4GZ_E5rOqrcbyppNBSz_brQaH4VNw@mail.gmail.com>
 <531B8CB1.2010502@suse.de>
 <20140308220926.GA15421@redhat.com>
 <531BB4A9.5000305@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531BB4A9.5000305@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08 2014 at  7:24pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 2014-03-08 15:09, Mike Snitzer wrote:
> >On Sat, Mar 08 2014 at  4:33pm -0500,
> >Hannes Reinecke <hare@suse.de> wrote:
> >
> >>On 03/08/2014 07:13 PM, Mike Snitzer wrote:
> >>>
> >>>I'm calm.. was just a bit frustrated.  But this isn't a big deal.
> >>>I'll make an effort to reach out to relevant people sooner when
> >>>similar stuff is reported against recently upstreamed code.  Would be
> >>>cool if you did the same.  I can relate to needing to have the distro
> >>>vendor hat on (first needing to determine/answer "is this issue
> >>>specific to our hacked distro kernel?", etc).
> >>>
> >>The patch I made wasn't in the context of 'recently upstreamed
> >>code', it was due to a backport Jan Kara did for our next distro
> >>kernels (3.12-based).
> >
> >"3.12-based" means nothing given all the backporting for SLES, much like
> >"3.10-based" means nothing in the context of RHEL7.
> >
> >The only way this fix is applicable is in the context of "recently
> >upstreamed code", commit 1874198 ("blk-mq: rework flush sequencing
> >logic") went upstream for v3.14-rc3.
> >
> >Jens, please feel free to queue this tested fix for 3.14-rc:
> 
> Thanks Mike, queued up.

Thanks.

> Also queued up the list addition reversal change.

I had a look at what you queued, thing is commit 1874198 replaced code
in blk_kick_flush() that did use list_add_tail().  So getting back to
the way the original code  was (before 1874198) would need something
like the following patch.

But it isn't clear to me why we'd have the duality of front vs tail
additions for flushes.  Maybe Christoph knows?

diff --git a/block/blk-flush.c b/block/blk-flush.c
index f598f79..43e6b47 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -140,14 +140,17 @@ static void mq_flush_run(struct work_struct *work)
 	blk_mq_insert_request(rq, false, true, false);
 }
 
-static bool blk_flush_queue_rq(struct request *rq)
+static bool blk_flush_queue_rq(struct request *rq, bool add_front)
 {
 	if (rq->q->mq_ops) {
 		INIT_WORK(&rq->mq_flush_work, mq_flush_run);
 		kblockd_schedule_work(rq->q, &rq->mq_flush_work);
 		return false;
 	} else {
-		list_add_tail(&rq->queuelist, &rq->q->queue_head);
+		if (add_front)
+			list_add(&rq->queuelist, &rq->q->queue_head);
+		else
+			list_add_tail(&rq->queuelist, &rq->q->queue_head);
 		return true;
 	}
 }
@@ -193,7 +196,7 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 
 	case REQ_FSEQ_DATA:
 		list_move_tail(&rq->flush.list, &q->flush_data_in_flight);
-		queued = blk_flush_queue_rq(rq);
+		queued = blk_flush_queue_rq(rq, true);
 		break;
 
 	case REQ_FSEQ_DONE:
@@ -326,7 +329,7 @@ static bool blk_kick_flush(struct request_queue *q)
 	q->flush_rq->rq_disk = first_rq->rq_disk;
 	q->flush_rq->end_io = flush_end_io;
 
-	return blk_flush_queue_rq(q->flush_rq);
+	return blk_flush_queue_rq(q->flush_rq, false);
 }
 
 static void flush_data_end_io(struct request *rq, int error)
