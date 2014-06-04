Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaFDPrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:47:18 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:35200 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaFDPrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:47:17 -0400
Message-ID: <538F3F82.5060805@kernel.dk>
Date: Wed, 04 Jun 2014 09:47:14 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
References: <20140509120733.GA27918@kernel.org> <20140509150018.GA26215@infradead.org> <20140510040023.GA13788@kernel.org> <5388912F.7010609@kernel.dk> <20140604111133.GA7826@infradead.org> <538F2A11.4060800@kernel.dk> <20140604142012.GA20056@infradead.org> <538F331F.60101@kernel.dk> <20140604145803.GA7826@infradead.org> <538F34FB.7050003@kernel.dk> <20140604153159.GA27096@infradead.org> <538F3DC4.4030104@kernel.dk>
In-Reply-To: <538F3DC4.4030104@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------090407060304010502010500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090407060304010502010500
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 06/04/2014 09:39 AM, Jens Axboe wrote:
> On 06/04/2014 09:31 AM, Christoph Hellwig wrote:
>> On Wed, Jun 04, 2014 at 09:02:19AM -0600, Jens Axboe wrote:
>>>> scsi_mq_find_tag only gets the scsi host, which may have multiple
>>>> queues.  When called from scsi_find_tag we actually have a scsi device,
>>>> so that's not an issue, but when called from scsi_host_find_tag the
>>>> driver only provides the host.
>>>
>>> Only solution I see right now is to have the flush_rq in the shared
>>> tags, but that would potentially be a regression for multiple
>>> devices and heavy flush uses cases. I'll see if I can come up with
>>> something better, or maybe Shaohua has an idea.
>>
>> What about something like the following (untest, uncompiled, maybe
>> pseudo-code):
>>
>> struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
>> {
>> 	struct request *rq = tags->rqs[tag];
>>
>> 	if ((rq->cmd_flags & REQ_FLUSH_SEQ) && rq->q->flush_rq->tag == tag)
>> 		return rq->q->flush_rq;
>> 	return rq;
> 
> Ah yes, that'll work, the queue is always assigned. I'll make that change.

Something like this in complete form. Compile tested only, I'll test it
on dev box. Probably doesn't matter too much, but I prefer to
potentially have the faster path (non-flush) just fall inline.


-- 
Jens Axboe


--------------090407060304010502010500
Content-Type: text/x-patch;
 name="tag-to-request.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tag-to-request.patch"

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4e8e8cf00815..4e4cd6208052 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -529,15 +529,20 @@ void blk_mq_kick_requeue_list(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_mq_kick_requeue_list);
 
-struct request *blk_mq_tag_to_rq(struct blk_mq_hw_ctx *hctx, unsigned int tag)
+static inline bool is_flush_request(struct request *rq, unsigned int tag)
 {
-	struct request_queue *q = hctx->queue;
+	return ((rq->cmd_flags & REQ_FLUSH_SEQ) &&
+			rq->q->flush_rq->tag == tag);
+}
 
-	if ((q->flush_rq->cmd_flags & REQ_FLUSH_SEQ) &&
-	    q->flush_rq->tag == tag)
-		return q->flush_rq;
+struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
+{
+	struct request *rq = tags->rqs[tag];
+
+	if (!is_flush_request(rq, tag))
+		return rq;
 
-	return hctx->tags->rqs[tag];
+	return rq->q->flush_rq;
 }
 EXPORT_SYMBOL(blk_mq_tag_to_rq);
 
@@ -566,7 +571,7 @@ static void blk_mq_timeout_check(void *__data, unsigned long *free_tags)
 		if (tag >= hctx->tags->nr_tags)
 			break;
 
-		rq = blk_mq_tag_to_rq(hctx, tag++);
+		rq = blk_mq_tag_to_rq(hctx->tags, tag++);
 		if (rq->q != hctx->queue)
 			continue;
 		if (!test_bit(REQ_ATOM_STARTED, &rq->atomic_flags))
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index abc858b3528b..74abd49fabdc 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -193,7 +193,9 @@ static void mtip_put_int_command(struct driver_data *dd, struct mtip_cmd *cmd)
 static struct request *mtip_rq_from_tag(struct driver_data *dd,
 					unsigned int tag)
 {
-	return blk_mq_tag_to_rq(dd->queue->queue_hw_ctx[0], tag);
+	struct blk_mq_hw_ctx *hctx = dd->queue->queue_hw_ctx[0];
+
+	return blk_mq_tag_to_rq(hctx->tags, tag);
 }
 
 static struct mtip_cmd *mtip_cmd_from_tag(struct driver_data *dd,
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index c15128833100..0feedebfde48 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -155,7 +155,7 @@ void blk_mq_free_request(struct request *rq);
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
 struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
 		gfp_t gfp, bool reserved);
-struct request *blk_mq_tag_to_rq(struct blk_mq_hw_ctx *hctx, unsigned int tag);
+struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag);
 
 struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *, const int ctx_index);
 struct blk_mq_hw_ctx *blk_mq_alloc_single_hw_queue(struct blk_mq_tag_set *, unsigned int, int);

--------------090407060304010502010500--
