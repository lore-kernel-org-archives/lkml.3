Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab3K0MyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 07:54:12 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44078 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab3K0MyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:54:06 -0500
Date: Wed, 27 Nov 2013 04:54:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH 4/5] blk-lib.c: generic_make_request() handles large bios
 now
Message-ID: <20131127125405.GA21086@infradead.org>
References: <1385418633-9753-1-git-send-email-kmo@daterainc.com>
 <1385418633-9753-5-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385418633-9753-5-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags)
>  {
> -	DECLARE_COMPLETION_ONSTACK(wait);
>  	struct request_queue *q = bdev_get_queue(bdev);
>  	int type = REQ_WRITE | REQ_DISCARD;
> -	unsigned int max_discard_sectors, granularity;
> -	int alignment;
> -	struct bio_batch bb;
>  	struct bio *bio;
>  	int ret = 0;
> -	struct blk_plug plug;
>  
>  	if (!q)
>  		return -ENXIO;
> @@ -56,78 +34,28 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  	if (!blk_queue_discard(q))
>  		return -EOPNOTSUPP;
>  
> -	/* Zero-sector (unknown) and one-sector granularities are the same.  */
> -	granularity = max(q->limits.discard_granularity >> 9, 1U);
> -	alignment = (bdev_discard_alignment(bdev) >> 9) % granularity;
> -
> -	/*
> -	 * Ensure that max_discard_sectors is of the proper
> -	 * granularity, so that requests stay aligned after a split.
> -	 */
> -	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
> -	max_discard_sectors -= max_discard_sectors % granularity;

Seems like this is also missing the code to trim down the request to
be properly aligned to the device limit.  I don't think our low-level
drivers are ready to handle this, and even if they were it should be a
separate change.

