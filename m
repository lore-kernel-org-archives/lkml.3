Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3HLSKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:10:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:35242 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab3HLSKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:10:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,863,1367996400"; 
   d="scan'208";a="385138336"
Date: Mon, 12 Aug 2013 11:10:03 -0700
From: Jon Mason <jon.mason@intel.com>
To: Dan Williams <djbw@fb.com>, "Koul, Vinod" <vinod.koul@intel.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>, Brice Goglin <Brice.Goglin@inria.fr>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ioatdma: add ioat_raid_enabled module parameter
Message-ID: <20130812181002.GF6385@jonmason-lab>
References: <CE213A73.1D265%djbw@fb.com>
 <51FC05EB.2020501@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51FC05EB.2020501@inria.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 09:18:03PM +0200, Brice Goglin wrote:
> Le 02/08/2013 19:47, Dan Williams a écrit :
> > Yup, but should also fold in the deletions of the other is_xeon_cb32()
> > alignment fixups further below.
> >
> > Actually all the alignment settings can be removed now.
> >
> > ...and the PQ_VAL/XOR_VAL fixup for is_xeon_cb32() can go.
> 
> Ok, here's another one, but we're close to the limit of my understanding
> of this driver's internals.
> 
> Removed all alignment fixups and all is_xeon_cb32() fixups.
> 
> Brice

Dan/Vinod, I would really like for this to get into 3.12.  It
dovetails very nicely with my patch to use DMA engines in NTB, which I
am aiming for 3.12 as well (though still waiting for some review,
hint-hint).  Is this doable?

Thanks,
Jon

> 
> 
> 
> ioatdma: disable RAID on non-Atom platforms and reenable unaligned copies
> 
> Disable RAID on non-Atom platform and remove related fixups such as the
> 64-byte alignement restriction on legacy DMA operations (introduced in
> commit f26df1a1 as a workaround for silicon errata).
> 
> Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
> ---
>  drivers/dma/ioat/dma_v3.c |   24 +-----------------------
>  1 file changed, 1 insertion(+), 23 deletions(-)
> 
> Index: b/drivers/dma/ioat/dma_v3.c
> ===================================================================
> --- a/drivers/dma/ioat/dma_v3.c	2013-07-31 23:06:24.163810000 +0200
> +++ b/drivers/dma/ioat/dma_v3.c	2013-08-02 21:10:36.560044703 +0200
> @@ -1775,15 +1775,12 @@ int ioat3_dma_probe(struct ioatdma_devic
>  	dma->device_alloc_chan_resources = ioat2_alloc_chan_resources;
>  	dma->device_free_chan_resources = ioat2_free_chan_resources;
>  
> -	if (is_xeon_cb32(pdev))
> -		dma->copy_align = 6;
> -
>  	dma_cap_set(DMA_INTERRUPT, dma->cap_mask);
>  	dma->device_prep_dma_interrupt = ioat3_prep_interrupt_lock;
>  
>  	device->cap = readl(device->reg_base + IOAT_DMA_CAP_OFFSET);
>  
> -	if (is_bwd_noraid(pdev))
> +	if (is_xeon_cb32(pdev) || is_bwd_noraid(pdev))
>  		device->cap &= ~(IOAT_CAP_XOR | IOAT_CAP_PQ | IOAT_CAP_RAID16SS);
>  
>  	/* dca is incompatible with raid operations */
> @@ -1793,7 +1790,6 @@ int ioat3_dma_probe(struct ioatdma_devic
>  	if (device->cap & IOAT_CAP_XOR) {
>  		is_raid_device = true;
>  		dma->max_xor = 8;
> -		dma->xor_align = 6;
>  
>  		dma_cap_set(DMA_XOR, dma->cap_mask);
>  		dma->device_prep_dma_xor = ioat3_prep_xor;
> @@ -1812,13 +1808,8 @@ int ioat3_dma_probe(struct ioatdma_devic
>  
>  		if (device->cap & IOAT_CAP_RAID16SS) {
>  			dma_set_maxpq(dma, 16, 0);
> -			dma->pq_align = 0;
>  		} else {
>  			dma_set_maxpq(dma, 8, 0);
> -			if (is_xeon_cb32(pdev))
> -				dma->pq_align = 6;
> -			else
> -				dma->pq_align = 0;
>  		}
>  
>  		if (!(device->cap & IOAT_CAP_XOR)) {
> @@ -1829,13 +1820,8 @@ int ioat3_dma_probe(struct ioatdma_devic
>  
>  			if (device->cap & IOAT_CAP_RAID16SS) {
>  				dma->max_xor = 16;
> -				dma->xor_align = 0;
>  			} else {
>  				dma->max_xor = 8;
> -				if (is_xeon_cb32(pdev))
> -					dma->xor_align = 6;
> -				else
> -					dma->xor_align = 0;
>  			}
>  		}
>  	}
> @@ -1844,14 +1830,6 @@ int ioat3_dma_probe(struct ioatdma_devic
>  	device->cleanup_fn = ioat3_cleanup_event;
>  	device->timer_fn = ioat3_timer_event;
>  
> -	if (is_xeon_cb32(pdev)) {
> -		dma_cap_clear(DMA_XOR_VAL, dma->cap_mask);
> -		dma->device_prep_dma_xor_val = NULL;
> -
> -		dma_cap_clear(DMA_PQ_VAL, dma->cap_mask);
> -		dma->device_prep_dma_pq_val = NULL;
> -	}
> -
>  	/* starting with CB3.3 super extended descriptors are supported */
>  	if (device->cap & IOAT_CAP_RAID16SS) {
>  		char pool_name[14];
> 
