Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbaHOQqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:46:31 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:55666 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaHOQqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:46:30 -0400
Message-ID: <53EE3966.60609@kernel.dk>
Date: Fri, 15 Aug 2014 10:46:30 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@canonical.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Benjamin LaHaise <bcrl@kvack.org>, Kent Overstreet <kmo@daterainc.com>,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v1 5/9] block: loop: convert to blk-mq
References: <1408031441-31156-1-git-send-email-ming.lei@canonical.com> <1408031441-31156-6-git-send-email-ming.lei@canonical.com> <20140815163111.GA16652@infradead.org> <53EE370D.1060106@kernel.dk>
In-Reply-To: <53EE370D.1060106@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------030301080607020805050407"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030301080607020805050407
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 08/15/2014 10:36 AM, Jens Axboe wrote:
> On 08/15/2014 10:31 AM, Christoph Hellwig wrote:
>>> +static void loop_queue_work(struct work_struct *work)
>>
>> Offloading work straight to a workqueue dosn't make much sense
>> in the blk-mq model as we'll usually be called from one.  If you
>> need to avoid the cases where we are called directly a flag for
>> the blk-mq code to always schedule a workqueue sounds like a much
>> better plan.
> 
> That's a good point - would clean up this bit, and be pretty close to a
> one-liner to support in blk-mq for the drivers that always need blocking
> context.

Something like this should do the trick - totally untested. But with
that, loop would just need to add BLK_MQ_F_WQ_CONTEXT to it's tag set
flags and it could always do the work inline from ->queue_rq().

-- 
Jens Axboe


--------------030301080607020805050407
Content-Type: text/x-patch;
 name="blk-mq-wq.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="blk-mq-wq.patch"

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5189cb1e478a..a97eb9a4af60 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -803,6 +803,9 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
 		return;
 
+	if (hctx->flags & BLK_MQ_F_WQ_CONTEXT)
+		async = true;
+
 	if (!async && cpumask_test_cpu(smp_processor_id(), hctx->cpumask))
 		__blk_mq_run_hw_queue(hctx);
 	else if (hctx->queue->nr_hw_queues == 1)
@@ -1173,7 +1176,7 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		goto run_queue;
 	}
 
-	if (is_sync) {
+	if (is_sync && !(data.hctx->flags & BLK_MQ_F_WQ_CONTEXT)) {
 		int ret;
 
 		blk_mq_bio_to_request(rq, bio);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index eb726b9c5762..c7a8c5fdd380 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -127,7 +127,8 @@ enum {
 	BLK_MQ_RQ_QUEUE_ERROR	= 2,	/* end IO with error */
 
 	BLK_MQ_F_SHOULD_MERGE	= 1 << 0,
-	BLK_MQ_F_SHOULD_SORT	= 1 << 1,
+	BLK_MQ_F_WQ_CONTEXT	= 1 << 1,	/* ->queue_rq() must run from
+						 * a blocking context */
 	BLK_MQ_F_TAG_SHARED	= 1 << 2,
 	BLK_MQ_F_SG_MERGE	= 1 << 3,
 	BLK_MQ_F_SYSFS_UP	= 1 << 4,

--------------030301080607020805050407--
