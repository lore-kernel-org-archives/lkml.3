Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab3DRRw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:52:56 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54057 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3DRRwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 13:52:55 -0400
Date: Thu, 18 Apr 2013 10:52:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>,
        namhyung@gmail.com, agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
Message-ID: <20130418175251.GC9897@mtj.dyndns.org>
References: <516E5EF8.9090507@cn.fujitsu.com>
 <1366209997.8817.12.camel@pippen.local.home>
 <20130418123738.GV4816@kernel.dk>
 <516FED09.1040008@cn.fujitsu.com>
 <20130418133546.GX4816@kernel.dk>
 <516FFFAC.8040103@cn.fujitsu.com>
 <20130418143014.GZ4816@kernel.dk>
 <517006F6.7030806@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517006F6.7030806@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Wanlong.

On Thu, Apr 18, 2013 at 10:45:10PM +0800, Wanlong Gao wrote:
> OK, but I should capture it tomorrow morning because this remote machine has already panicked
> and need hard reboot.

Can you please apply the following patch when you try the next time
and report the kernel log?  It should prevent the oops from happening
and dump information on at least who are the involved parties.

Thanks.

diff --git a/block/blk-core.c b/block/blk-core.c
index 074b758..d5efebe 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -150,6 +150,8 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 }
 EXPORT_SYMBOL(blk_rq_init);
 
+
+
 static void req_bio_endio(struct request *rq, struct bio *bio,
 			  unsigned int nbytes, int error)
 {
@@ -174,8 +176,15 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 		bio_integrity_advance(bio, nbytes);
 
 	/* don't actually finish bio if it's part of flush sequence */
-	if (bio->bi_size == 0 && !(rq->cmd_flags & REQ_FLUSH_SEQ))
+	if (bio->bi_size == 0 && !(rq->cmd_flags & REQ_FLUSH_SEQ)) {
+		if (bio->bi_bdev && (unsigned long)bio->bi_bdev < 4096) {
+			printk_ratelimited("XXX req_bio_endio: queue %s bio=%p bi_bdev=%p bi_end_io=%pf\n",
+					   (rq->q && rq->q->backing_dev_info.dev) ?
+					   dev_name(rq->q->backing_dev_info.dev) : "<unknown>",
+					   bio, bio->bi_bdev, bio->bi_end_io);
+		}
 		bio_endio(bio, error);
+	}
 }
 
 void blk_dump_rq_flags(struct request *rq, char *msg)
diff --git a/fs/bio.c b/fs/bio.c
index bb5768f..da64e5a 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1428,7 +1428,10 @@ void bio_endio(struct bio *bio, int error)
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
-	trace_block_bio_complete(bio, error);
+	if (bio->bi_bdev && (unsigned long)bio->bi_bdev < 4096)
+		printk_ratelimited("XXX bio_endio: skipping TP for %p\n", bio);
+	else
+		trace_block_bio_complete(bio, error);
 
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, error);
