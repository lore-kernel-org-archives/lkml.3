Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaHOQbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:31:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50365 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbaHOQbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:31:14 -0400
Date: Fri, 15 Aug 2014 09:31:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v1 5/9] block: loop: convert to blk-mq
Message-ID: <20140815163111.GA16652@infradead.org>
References: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
 <1408031441-31156-6-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408031441-31156-6-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +static int loop_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
> +			  unsigned int index)
> +{
> +	struct loop_device *lo = data;
> +
> +	hctx->driver_data = lo;

I don't think there is much of a point to store this in the hctx
instead of relying on the queue.

> +static void loop_softirq_done_fn(struct request *rq)
> +{
> +	blk_mq_end_io(rq, rq->errors);
> +}

no need for a noop softirq done function.

> +static void loop_queue_work(struct work_struct *work)

Offloading work straight to a workqueue dosn't make much sense
in the blk-mq model as we'll usually be called from one.  If you
need to avoid the cases where we are called directly a flag for
the blk-mq code to always schedule a workqueue sounds like a much
better plan.

