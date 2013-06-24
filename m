Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab3FXN2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:28:50 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44096 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3FXN2s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:28:48 -0400
Date: Mon, 24 Jun 2013 09:28:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] xen-blkback: check the number of iovecs before
 allocating a bios
Message-ID: <20130624132841.GA21144@phenom.dumpdata.com>
References: <1371812216-17093-4-git-send-email-roger.pau@citrix.com>
 <1371887957-18301-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1371887957-18301-1-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 09:59:17AM +0200, Roger Pau Monne wrote:
> With the introduction of indirect segments we can receive requests
> with a number of segments bigger than the maximum number of allowed
> iovecs in a bios, so make sure that blkback doesn't try to allocate a
> bios with more iovecs than BIO_MAX_PAGES

Shouldn't we just gate the feature-indirect-descriptor value to
take this into account?

What happens if the nseg is > BIO_MAX_PAGES? Do we "lose" the request
for the remaining segments?

> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/block/xen-blkback/blkback.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index d622d86..b3897f5d 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -1236,7 +1236,8 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
>  				     seg[i].nsec << 9,
>  				     seg[i].offset) == 0)) {
>  
> -			bio = bio_alloc(GFP_KERNEL, nseg-i);
> +			int nr_iovecs = min_t(int, (nseg-i), BIO_MAX_PAGES);
> +			bio = bio_alloc(GFP_KERNEL, nr_iovecs);
>  			if (unlikely(bio == NULL))
>  				goto fail_put_bio;
>  
> -- 
> 1.7.7.5 (Apple Git-26)
> 
