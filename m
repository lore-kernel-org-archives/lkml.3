Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598Ab3GZVak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:30:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759987Ab3GZUsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: [ 49/79] bcache: Advertise that flushes are supported
Date: Fri, 26 Jul 2013 13:47:39 -0700
Message-Id: <20130726204727.672361489@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit 54d12f2b4fd0f218590d1490b41a18d0e2328a9a upstream.

Whoops - bcache's flush/FUA was mostly correct, but flushes get filtered
out unless we say we support them...

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/request.c |    8 +++++++-
 drivers/md/bcache/super.c   |    2 ++
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -489,6 +489,12 @@ static void bch_insert_data_loop(struct
 		bch_queue_gc(op->c);
 	}
 
+	/*
+	 * Journal writes are marked REQ_FLUSH; if the original write was a
+	 * flush, it'll wait on the journal write.
+	 */
+	bio->bi_rw &= ~(REQ_FLUSH|REQ_FUA);
+
 	do {
 		unsigned i;
 		struct bkey *k;
@@ -716,7 +722,7 @@ static struct search *search_alloc(struc
 	s->task			= current;
 	s->orig_bio		= bio;
 	s->write		= (bio->bi_rw & REQ_WRITE) != 0;
-	s->op.flush_journal	= (bio->bi_rw & REQ_FLUSH) != 0;
+	s->op.flush_journal	= (bio->bi_rw & (REQ_FLUSH|REQ_FUA)) != 0;
 	s->op.skip		= (bio->bi_rw & REQ_DISCARD) != 0;
 	s->recoverable		= 1;
 	s->start_time		= jiffies;
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -781,6 +781,8 @@ static int bcache_device_init(struct bca
 	set_bit(QUEUE_FLAG_NONROT,	&d->disk->queue->queue_flags);
 	set_bit(QUEUE_FLAG_DISCARD,	&d->disk->queue->queue_flags);
 
+	blk_queue_flush(q, REQ_FLUSH|REQ_FUA);
+
 	return 0;
 }
 


