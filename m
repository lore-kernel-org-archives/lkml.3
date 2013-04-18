Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967334Ab3DRMV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 08:21:28 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29541 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967265Ab3DRMV1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 08:21:27 -0400
Date: Thu, 18 Apr 2013 08:21:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: Re: [PATCH v2 7/7] xen-block: implement indirect descriptors
Message-ID: <20130418122119.GB29883@phenom.dumpdata.com>
References: <1366222741-39902-1-git-send-email-roger.pau@citrix.com>
 <1366222741-39902-8-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1366222741-39902-8-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 08:19:01PM +0200, Roger Pau Monne wrote:
> Indirect descriptors introduce a new block operation
> (BLKIF_OP_INDIRECT) that passes grant references instead of segments
> in the request. This grant references are filled with arrays of
> blkif_request_segment_aligned, this way we can send more segments in a
> request.
> 
> The proposed implementation sets the maximum number of indirect grefs
> (frames filled with blkif_request_segment_aligned) to 256 in the
> backend and 32 in the frontend. The value in the frontend has been
> chosen experimentally, and the backend value has been set to a sane
> value that allows expanding the maximum number of indirect descriptors
> in the frontend if needed.
> 
> The migration code has changed from the previous implementation, in
> which we simply remapped the segments on the shared ring. Now the
> maximum number of segments allowed in a request can change depending
> on the backend, so we have to requeue all the requests in the ring and
> in the queue and split the bios in them if they are bigger than the
> new maximum number of segments.
> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: xen-devel@lists.xen.org
> ---
> Changes since v1:
>  * Added padding to make the indirect request 64bit aligned.
>  * Added some BUGs.
>  * Added comments.
>  * Fixed number of indirect pages in blkif_get_x86_{32/64}_req.
>  * Added description about the indirect operation in blkif.h

Good. I only have three comments - and if you want to handle them later
as seperate patches that is OK too.

They are:

> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -107,6 +107,8 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
>  	struct xen_blkif *blkif;
>  	int i;
>  
> +	BUILD_BUG_ON(MAX_INDIRECT_PAGES > BLKIF_MAX_INDIRECT_PAGES_PER_REQUEST);
> +
>  	blkif = kmem_cache_zalloc(xen_blkif_cachep, GFP_KERNEL);
>  	if (!blkif)
>  		return ERR_PTR(-ENOMEM);
> @@ -710,6 +712,12 @@ again:
>  		goto abort;
>  	}
>  
> +	err = xenbus_printf(xbt, dev->nodename, "feature-max-indirect-segments", "%u",
> +	                    MAX_INDIRECT_SEGMENTS);
> +	if (err)
> +		xenbus_dev_fatal(dev, err, "writing %s/feature-max-indirect-segments",
> +				 dev->nodename);

Not really fatal. We can continue on and just not use that feature.

.. snip..
> @@ -1483,6 +1799,13 @@ static void blkfront_connect(struct blkfront_info *info)
>  	else
>  		info->feature_persistent = persistent;
>  
> +	err = blkfront_setup_indirect(info);
> +	if (err) {
> +		xenbus_dev_fatal(info->xbdev, err, "setup_indirect at %s",
> +				 info->xbdev->otherend);
> +		return;

I thought we decided not to make it fatal?

> +	}
> +
>  	err = xlvbd_alloc_gendisk(sectors, info, binfo, sector_size);
>  	if (err) {
>  		xenbus_dev_fatal(info->xbdev, err, "xlvbd_add at %s",
> diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
> index ffd4652..7901e58 100644
> --- a/include/xen/interface/io/blkif.h
> +++ b/include/xen/interface/io/blkif.h
> @@ -103,12 +103,41 @@ typedef uint64_t blkif_sector_t;
>  #define BLKIF_OP_DISCARD           5
>  
>  /*
> + * Recognized if "feature-max-indirect-segments" in present in the backend
> + * xenbus info. The "feature-max-indirect-segments" node contains the maximum
> + * number of segments allowed by the backend. If the node is present,
                                               ^-'per request'.

> + * the frontend might use blkif_request_indirect in order to issue requests
                                                   ^ structs
> + * with more than BLKIF_MAX_SEGMENTS_PER_REQUEST. The maximum number
                                                   ^(11)

> + * of indirect segments is fixed by the backend, but the frontend can issue
> + * requests with any number of indirect segments as long as it's inferior
                                                                    ^^- less 
> + * than the number provided by the backend. The indirect_grefs field in
> + * blkif_request_indirect should be filled by the frontend with the
> + * grant references of the pages that are holding the indirect segments.
> + * This pages are filled with an array of blkif_request_segment_aligned
> + * that hold the information about the segments.

You should probably explain where the counter for the amount of indirect_grefs
that are going to be used is computed.

> + *
> + * If a backend does not recognize BLKIF_OP_INDIRECT, it should *not*
> + * create the "feature-max-indirect-segments" node!
> + */
> +#define BLKIF_OP_INDIRECT          6
