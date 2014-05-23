Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaEWRvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:51:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38378 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaEWRvN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:51:13 -0400
Date: Fri, 23 May 2014 13:51:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH] xen-blkfront: check feature-persitent on resume
Message-ID: <20140523175105.GA8995@phenom.dumpdata.com>
References: <1400769607-17278-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1400769607-17278-1-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 04:40:07PM +0200, Roger Pau Monne wrote:
> We are missing a check to see if the backend supports persistent
> grants on resume, meaning we will always run with the value fetched
> from the firsts host on which we run on.
> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: David Vrabel <david.vrabel@citrix.com>
> ---
>  drivers/block/xen-blkfront.c |   23 ++++++++++++++++-------
>  1 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index efe1b47..00ae36b 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -1430,6 +1430,20 @@ static void split_bio_end(struct bio *bio, int error)
>  	bio_put(bio);
>  }
>  
> +static void blkfront_setup_persistent(struct blkfront_info *info)
> +{
> +	unsigned int persistent;
> +	int err;
> +
> +	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
> +			    "feature-persistent", "%u", &persistent,
> +			    NULL);
> +	if (err)
> +		info->feature_persistent = 0;
> +	else
> +		info->feature_persistent = persistent;
> +}
> +
>  static int blkif_recover(struct blkfront_info *info)
>  {
>  	int i;
> @@ -1456,6 +1470,7 @@ static int blkif_recover(struct blkfront_info *info)
>  	info->shadow_free = info->ring.req_prod_pvt;
>  	info->shadow[BLK_RING_SIZE-1].req.u.rw.id = 0x0fffffff;
>  
> +	blkfront_setup_persistent(info);
>  	rc = blkfront_setup_indirect(info);
>  	if (rc) {
>  		kfree(copy);
> @@ -1851,13 +1866,7 @@ static void blkfront_connect(struct blkfront_info *info)
>  	if (!err && discard)
>  		blkfront_setup_discard(info);
>  
> -	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
> -			    "feature-persistent", "%u", &persistent,
> -			    NULL);
> -	if (err)
> -		info->feature_persistent = 0;
> -	else
> -		info->feature_persistent = persistent;
> +	blkfront_setup_persistent(info);

Should we also flush the ones that are on the info->grants list if
we turning it off?

>  
>  	err = blkfront_setup_indirect(info);
>  	if (err) {
> -- 
> 1.7.7.5 (Apple Git-26)
> 
