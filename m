Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab3HAMaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 08:30:39 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:54874 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab3HAMai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 08:30:38 -0400
X-IronPort-AV: E=Sophos;i="4.89,793,1367971200"; 
   d="scan'208";a="38770091"
Message-ID: <51FA54EC.6030604@citrix.com>
Date: Thu, 1 Aug 2013 13:30:36 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH] xen-blkback: use bigger array for batch gnt
 operations
References: <1375358934-6335-1-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1375358934-6335-1-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/13 13:08, Roger Pau Monne wrote:
> Right now the maximum number of grant operations that can be batched
> in a single request is BLKIF_MAX_SEGMENTS_PER_REQUEST (11). This was
> OK before indirect descriptors because the maximum number of segments
> in a request was 11, but with the introduction of indirect
> descriptors the maximum number of segments in a request has been
> increased past 11.
> 
> The memory used by the structures that are passed in the hypercall was
> allocated from the stack, but if we have to increase the size of the
> array we can no longer use stack memory, so we have to pre-allocate
> it.
> 
> This patch increases the maximum size of batch grant operations and
> replaces the use of stack memory with pre-allocated memory, that is
> reserved when the blkback instance is initialized.
[...]
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
[...]
> @@ -148,6 +155,16 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
>  			if (!req->indirect_pages[j])
>  				goto fail;
>  		}
> +		req->map = kcalloc(GNT_OPERATIONS_SIZE, sizeof(req->map[0]), GFP_KERNEL);
> +		if (!req->map)
> +			goto fail;
> +		req->unmap = kcalloc(GNT_OPERATIONS_SIZE, sizeof(req->unmap[0]), GFP_KERNEL);
> +		if (!req->unmap)
> +			goto fail;
> +		req->pages_to_gnt = kcalloc(GNT_OPERATIONS_SIZE, sizeof(req->pages_to_gnt[0]),
> +		                            GFP_KERNEL);
> +		if (!req->pages_to_gnt)
> +			goto fail;

Do these need to be per-request? Or can they all share a common set of
arrays?

David
