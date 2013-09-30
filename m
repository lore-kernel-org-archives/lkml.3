Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab3I3L2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:28:06 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:62604 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3I3L17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:27:59 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the block tree
Date: Mon, 30 Sep 2013 13:26:04 +0200
Message-Id: <1380540373-25352-2-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380540373-25352-1-git-send-email-treding@nvidia.com>
References: <1380540373-25352-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the block tree got conflicts in

	drivers/md/bcache/bcache.h
	drivers/md/bcache/bset.c
	drivers/md/bcache/journal.c
	drivers/md/bcache/request.c
	drivers/md/bcache/writeback.c

I fixed it up (see below). Please check if the resolution looks correct.

Thanks,
Thierry

diff --cc drivers/md/bcache/btree.c
index f42fc7e,117a12a..1ccb702
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@@ -633,10 -712,10 +707,10 @@@ static unsigned long bch_mca_scan(struc
  			break;
  
  		if (++i > 3 &&
- 		    !mca_reap(b, NULL, 0)) {
+ 		    !mca_reap(b, 0, false)) {
  			mca_data_free(b);
  			rw_unlock(true, b);
 -			--nr;
 +			freed++;
  		}
  	}
  
diff --cc drivers/md/bcache/request.c
index 71eb233,231b108..49ee1cf
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@@ -979,68 -1059,52 +1059,55 @@@ static void cached_dev_write(struct cac
  
  	if (should_writeback(dc, s->orig_bio,
  			     cache_mode(dc, bio),
- 			     s->op.skip)) {
- 		s->op.skip = false;
- 		s->writeback = true;
+ 			     s->iop.bypass)) {
+ 		s->iop.bypass = false;
+ 		s->iop.writeback = true;
  	}
  
- 	if (s->op.skip)
- 		goto skip;
- 
- 	trace_bcache_write(s->orig_bio, s->writeback, s->op.skip);
+ 	if (s->iop.bypass) {
+ 		s->iop.bio = s->orig_bio;
+ 		bio_get(s->iop.bio);
  
- 	if (!s->writeback) {
- 		s->op.cache_bio = bio_clone_bioset(bio, GFP_NOIO,
- 						   dc->disk.bio_split);
- 
- 		closure_bio_submit(bio, cl, s->d);
- 	} else {
+ 		if (!(bio->bi_rw & REQ_DISCARD) ||
+ 		    blk_queue_discard(bdev_get_queue(dc->bdev)))
+ 			closure_bio_submit(bio, cl, s->d);
+ 	} else if (s->iop.writeback) {
  		bch_writeback_add(dc);
  
 -		if (s->iop.flush_journal) {
 +		if (bio->bi_rw & REQ_FLUSH) {
  			/* Also need to send a flush to the backing device */
 -			s->iop.bio = bio_clone_bioset(bio, GFP_NOIO,
 -						      dc->disk.bio_split);
 +			struct bio *flush = bio_alloc_bioset(0, GFP_NOIO,
 +							     dc->disk.bio_split);
  
 -			bio->bi_size = 0;
 -			bio->bi_vcnt = 0;
 -			closure_bio_submit(bio, cl, s->d);
 +			flush->bi_rw	= WRITE_FLUSH;
 +			flush->bi_bdev	= bio->bi_bdev;
 +			flush->bi_end_io = request_endio;
 +			flush->bi_private = cl;
 +
 +			closure_bio_submit(flush, cl, s->d);
  		} else {
- 			s->op.cache_bio = bio;
+ 			s->iop.bio = bio;
  		}
- 	}
- out:
- 	closure_call(&s->op.cl, bch_insert_data, NULL, cl);
- 	continue_at(cl, cached_dev_write_complete, NULL);
- skip:
- 	s->op.skip = true;
- 	s->op.cache_bio = s->orig_bio;
- 	bio_get(s->op.cache_bio);
+ 	} else {
+ 		s->iop.bio = bio_clone_bioset(bio, GFP_NOIO,
+ 					      dc->disk.bio_split);
  
- 	if ((bio->bi_rw & REQ_DISCARD) &&
- 	    !blk_queue_discard(bdev_get_queue(dc->bdev)))
- 		goto out;
+ 		closure_bio_submit(bio, cl, s->d);
+ 	}
  
- 	closure_bio_submit(bio, cl, s->d);
- 	goto out;
+ 	closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
+ 	continue_at(cl, cached_dev_write_complete, NULL);
  }
  
- static void request_nodata(struct cached_dev *dc, struct search *s)
+ static void cached_dev_nodata(struct closure *cl)
  {
- 	struct closure *cl = &s->cl;
+ 	struct search *s = container_of(cl, struct search, cl);
  	struct bio *bio = &s->bio.bio;
  
- 	if (bio->bi_rw & REQ_DISCARD) {
- 		request_write(dc, s);
- 		return;
- 	}
- 
- 	if (s->op.flush_journal)
- 		bch_journal_meta(s->op.c, cl);
+ 	if (s->iop.flush_journal)
+ 		bch_journal_meta(s->iop.c, cl);
  
+ 	/* If it's a flush, we send the flush to the backing device too */
  	closure_bio_submit(bio, cl, s->d);
  
  	continue_at(cl, cached_dev_bio_complete, NULL);
