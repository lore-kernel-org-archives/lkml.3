Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254AbaCGGoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 01:44:07 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45802 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaCGGoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 01:44:05 -0500
Date: Thu, 6 Mar 2014 22:44:02 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Roman Pen <r.peniaev@gmail.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mtd: mtd_blkdevs: handle REQ_FLUSH request and do
 explicit flush of writeback buffer
Message-ID: <20140307064402.GA13420@norris-Latitude-E6410>
References: <1388593281-22613-1-git-send-email-r.peniaev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388593281-22613-1-git-send-email-r.peniaev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 01:21:21AM +0900, Roman Pen wrote:
> From: Roman Peniaev <r.peniaev@gmail.com>
> 
> mtd_blkdevs is device with volatile cache (writeback buffer), so it should support
> REQ_FLUSH to do explicit flush.
> 
> Without this patch 'sync' does not guarantee that writeback buffer will be flushed
> on disk in case of power off, e.g.:
> 
>   $ cp some_file /mnt
>   $ sync
> 
>   ### POWER OFF
> 
> In case of this sequence writeback buffer will not be flushed on disk.
> 
> This patch fixes this behaviour and explicitly reports to block layer that flush
> requests are being supported.
> 
> Signed-off-by: Roman Peniaev <r.peniaev@gmail.com>
> CC: David Woodhouse <dwmw2@infradead.org>
> CC: linux-mtd@lists.infradead.org
> CC: linux-kernel@vger.kernel.org
> ---
>  drivers/mtd/mtd_blkdevs.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
> index 5073cbc..feafe5c 100644
> --- a/drivers/mtd/mtd_blkdevs.c
> +++ b/drivers/mtd/mtd_blkdevs.c
> @@ -89,6 +89,12 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
>  	if (req->cmd_type != REQ_TYPE_FS)
>  		return -EIO;
>  
> +	if (req->cmd_flags & REQ_FLUSH) {
> +		if (tr->flush)
> +			return tr->flush(dev);
> +		return 0;
> +	}
> +
>  	if (blk_rq_pos(req) + blk_rq_cur_sectors(req) >
>  	    get_capacity(req->rq_disk))
>  		return -EIO;
> @@ -409,6 +415,8 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
>  	if (!new->rq)
>  		goto error3;
>  
> +	blk_queue_flush(new->rq, REQ_FLUSH);

How about only registering the flush command if we support it? So:

	if (tr->flush)
		blk_queue_flush(new->rq, REQ_FLUSH);

Then you can probably also change the earlier hunk to the following, no?

	if (req->cmd_flags & REQ_FLUSH)
		return tr->flush(dev);

> +
>  	new->rq->queuedata = new;
>  	blk_queue_logical_block_size(new->rq, tr->blksize);
>  

Brian
