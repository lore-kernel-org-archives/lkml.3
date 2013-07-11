Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab3GKNdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:33:41 -0400
Received: from smtp.citrix.com ([66.165.176.89]:25082 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765Ab3GKNdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:33:39 -0400
X-IronPort-AV: E=Sophos;i="4.87,1043,1363132800"; 
   d="scan'208";a="36377724"
Message-ID: <51DEB3D5.2050101@citrix.com>
Date: Thu, 11 Jul 2013 14:32:05 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 3/4] xen-blkfront: prevent hoarding all
 grants
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com> <1373288607-1876-4-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1373288607-1876-4-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/13 14:03, Roger Pau Monne wrote:
> Prevent blkfront from hoarding all grants by adding a minimum number
> of grants that must be free at all times. We still need a way to free
> unused grants in blkfront, but this patch will mitigate the problem
> in the meantime.

I think this could end up with the a frontend being able to get no
grants because some other frontend always grabs the free grants first.

Particularly as the free grant callbacks are done in the wrong order.

David

> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -101,6 +101,12 @@ MODULE_PARM_DESC(max, "Maximum amount of segments in indirect requests (default
>  #define BLK_RING_SIZE __CONST_RING_SIZE(blkif, PAGE_SIZE)
>  
>  /*
> + * Make sure there are at least MIN_FREE_GRANTS at all times, preventing
> + * blkfront from hoarding all grants
> + */
> +#define MIN_FREE_GRANTS		512
> +
> +/*
>   * We have one of these per vbd, whether ide, scsi or 'other'.  They
>   * hang in private_data off the gendisk structure. We may end up
>   * putting all kinds of interesting stuff here :-)
> @@ -412,13 +418,13 @@ static int blkif_queue_request(struct request *req)
>  	if (info->persistent_gnts_c < max_grefs) {
>  		new_persistent_gnts = 1;
>  		if (gnttab_alloc_grant_references(
> -		    max_grefs - info->persistent_gnts_c,
> +		    max_grefs - info->persistent_gnts_c + MIN_FREE_GRANTS,
>  		    &gref_head) < 0) {
>  			gnttab_request_free_callback(
>  				&info->callback,
>  				blkif_restart_queue_callback,
>  				info,
> -				max_grefs);
> +				max_grefs + MIN_FREE_GRANTS);
>  			return 1;
>  		}
>  	} else

