Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab3KSKgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:36:39 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:41419 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3KSKgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:36:38 -0500
Date: Tue, 19 Nov 2013 02:36:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [Regression x2, 3.13-git] virtio block mq hang, iostat busted on
 virtio devices
Message-ID: <20131119103635.GA9223@infradead.org>
References: <20131119080218.GJ11434@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119080218.GJ11434@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 07:02:18PM +1100, Dave Chinner wrote:
> I have no idea if it's related to the above hang, but either way
> breaking iostat is a major regression....

Both of them are most likely due to the conversion of virtio_blk
to the blk-mq code.

I've not seen the hang in my heavy xfstests testing, but that was a
slightly different codebase than what finally got in, so I'll try
to reproduce it once I get some spare QA cycles.

The missing stats should be solved by something like the patch below
(untested so far):


diff --git a/block/blk-mq.c b/block/blk-mq.c
index 862f458..41e3b85 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -175,7 +175,7 @@ static void blk_mq_rq_ctx_init(struct blk_mq_ctx *ctx, struct request *rq,
 			       unsigned int rw_flags)
 {
 	rq->mq_ctx = ctx;
-	rq->cmd_flags = rw_flags;
+	rq->cmd_flags = rw_flags | REQ_IO_STAT;
 	ctx->rq_dispatched[rw_is_sync(rw_flags)]++;
 }
 
