Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3GKNUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:20:06 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:42978 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab3GKNUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:20:04 -0400
X-IronPort-AV: E=Sophos;i="4.87,1043,1363132800"; 
   d="scan'208";a="34645383"
Message-ID: <51DEB102.7060802@citrix.com>
Date: Thu, 11 Jul 2013 14:20:02 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 2/4] xen-blkfront: improve aproximation
 of	required grants per request
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com> <1373288607-1876-3-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1373288607-1876-3-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/13 14:03, Roger Pau Monne wrote:
> Improve the calculation of required grants to process a request by
> using nr_phys_segments instead of always assuming a request is going
> to use all posible segments.

This isn't obviously correct to me.  Why is this correct value for the
number of pages that need to be granted?

David

> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -400,10 +400,13 @@ static int blkif_queue_request(struct request *req)
>  	if (unlikely(info->connected != BLKIF_STATE_CONNECTED))
>  		return 1;
>  
> -	max_grefs = info->max_indirect_segments ?
> -		    info->max_indirect_segments +
> -		    INDIRECT_GREFS(info->max_indirect_segments) :
> -		    BLKIF_MAX_SEGMENTS_PER_REQUEST;
> +	max_grefs = req->nr_phys_segments;
> +	if (max_grefs > BLKIF_MAX_SEGMENTS_PER_REQUEST)
> +		/*
> +		 * If we are using indirect segments we need to account
> +		 * for the indirect grefs used in the request.
> +		 */
> +		max_grefs += INDIRECT_GREFS(req->nr_phys_segments);
>  
>  	/* Check if we have enough grants to allocate a requests */
>  	if (info->persistent_gnts_c < max_grefs) {

