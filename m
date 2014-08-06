Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaHFWD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 18:03:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:29568 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbaHFWDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:03:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,814,1400050800"; 
   d="scan'208";a="572761569"
Message-ID: <1407362634.2869.2.camel@rzwisler-mobl1.amr.corp.intel.com>
Subject: Re: [PATCH 4/4] brd: Request from fdisk 4k alignment
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Wed, 06 Aug 2014 16:03:54 -0600
In-Reply-To: <53E21317.7080403@plexistor.com>
References: <53E21125.9080308@plexistor.com>
	 <53E21317.7080403@plexistor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-06 at 14:35 +0300, Boaz Harrosh wrote:
> Because of the direct_access() API which returns a PFN. partitions
> better start on 4K boundary, else offset ZERO of a partition will
> not be aligned and blk_direct_access() will fail the call.
> 
> By setting blk_queue_physical_block_size(PAGE_SIZE) we can communicate
> this to fdisk and friends.
> Note that blk_queue_physical_block_size() also trashes io_min, but
> we can leave this one to be 512.
> 
> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
> ---
>  drivers/block/brd.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index 9673704..514cfe1 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -495,10 +495,17 @@ static struct brd_device *brd_alloc(int i)
>  	brd->brd_queue = blk_alloc_queue(GFP_KERNEL);
>  	if (!brd->brd_queue)
>  		goto out_free_dev;
> +
>  	blk_queue_make_request(brd->brd_queue, brd_make_request);
>  	blk_queue_max_hw_sectors(brd->brd_queue, 1024);
>  	blk_queue_bounce_limit(brd->brd_queue, BLK_BOUNCE_ANY);
>  
> +	/* This is so fdisk will align partitions on 4k, because of
> +	 * direct_access API needing 4k alignment, returning a PFN
> +	 */
> +	blk_queue_physical_block_size(brd->brd_queue, PAGE_SIZE);
> +	brd->brd_queue->limits.io_min = 512; /* Don't use the accessor */
> +
>  	brd->brd_queue->limits.discard_granularity = PAGE_SIZE;
>  	brd->brd_queue->limits.max_discard_sectors = UINT_MAX;
>  	brd->brd_queue->limits.discard_zeroes_data = 1;

Is there an error case that this patch fixes?  I've had page alignment checks
in my PRD direct_access code forever, and I don't know if they've ever
tripped.  

Also, blk_queue_physical_block_size() seems wrong - here's the comment for
that function:

	/**
	 * blk_queue_physical_block_size - set physical block size for the queue
	 * @q:  the request queue for the device
	 * @size:  the physical block size, in bytes
	 *
	 * Description:
	 *   This should be set to the lowest possible sector size that the
	 *   hardware can operate on without reverting to read-modify-write
	 *   operations.
	 */

It doesn't sound like this is what you're after?  It sounds like instead you
want to control the alignment, not minimum natural I/O size?  It seems like if
you did want to do this, blk_queue_alignment_offset() would be more what you
were after?

- Ross


