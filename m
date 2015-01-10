Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbbAJS6z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 13:58:55 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:40295 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbbAJS6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 13:58:55 -0500
Date: Sat, 10 Jan 2015 10:58:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Richard Weinberger <richard@nod.at>
Cc: dedekind1@gmail.com, dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, axboe@fb.com, tom.leiming@gmail.com
Subject: Re: [PATCH 2/2] UBI: Block: Add blk-mq support
Message-ID: <20150110185851.GA3945@infradead.org>
References: <1420900188-15781-1-git-send-email-richard@nod.at>
 <1420900188-15781-2-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420900188-15781-2-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +struct ubiblock_pdu {
> +	struct request *req;

No need to store the request, you can trivially get at it using
blk_mq_rq_from_pdu().

> +	struct ubiblock *dev;

Why do you need the dev pointer?  You can always trivially get
it using req->queuedata.

> +static void ubiblock_do_work(struct work_struct *work)
> +{
> +	int ret;
> +	struct ubiblock_pdu *pdu = container_of(work, struct ubiblock_pdu, work);
> +
> +	ret = ubiblock_read(pdu);
> +	blk_mq_end_request(pdu->req, ret ?: 0);

Why not just pass ret as-is?

> +	if (blk_rq_pos(req) + blk_rq_cur_sectors(req) >
> +	    get_capacity(req->rq_disk))
> +		return BLK_MQ_RQ_QUEUE_ERROR;

The upper layers take are of this check.

> +	pdu->usgl.list_pos = 0;
> +	pdu->usgl.page_pos = 0;

Having a helper to initialize a ubi_sgl would be nicer than having
to open code it ike here.

> +
> +	blk_mq_start_request(req);
> +	ret = blk_rq_map_sg(hctx->queue, req, pdu->usgl.sg);
> +
> +	queue_work(dev->wq, &pdu->work);

Why don't you move these calls into the work queue as well?  The
queue_rq call would literally just become a queue_work call.

And given that this is a fairly common patter this should allow
us to refactor / optimize this case a bit later on.

