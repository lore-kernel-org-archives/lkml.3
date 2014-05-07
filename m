Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbaEGWhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:37:45 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14423 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaEGWhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:37:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 07 May 2014 15:33:02 -0700
Date: Wed, 7 May 2014 15:37:45 -0700
From: Christopher Freeman <cfreeman@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/3] dma: tegra: finer granularity residual for
 tx_status
Message-ID: <20140507223745.GB20137@nvidia.com>
References: <1399411343-12222-1-git-send-email-cfreeman@nvidia.com>
 <1399411343-12222-2-git-send-email-cfreeman@nvidia.com>
 <536A6145.2080106@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <536A6145.2080106@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 09:37:25AM -0700, Stephen Warren wrote:
> On 05/06/2014 03:22 PM, Christopher Freeman wrote:
> > Get word-level granularity from hardware for calculating
> > the transfer count remaining.
> 
> > diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
> 
> > +static int tegra_dma_wcount_in_bytes(struct dma_chan *dc)
> 
> A lot of the code in this function is identical to the code in
> tegra_dma_terminate_all() which does the same thing. Can this be pulled
> out into a shared utility function?
> 
I'll look at making utility functions for ISR handling and the calculations for the byte counts.

> > +	tegra_dma_pause(tdc, true);
> 
> Is this continual pausing/resuming of the DMA operation going to
> negatively affect performance?
> 
I tried testing the performance impact and each call took about 20 uS.  And of course, the client would have to be calling this constantly.
> > +	/* in case of interrupt, handle it and don't read wcount reg */
> > +	status = tdc_read(tdc, TEGRA_APBDMA_CHAN_STATUS);
> > +	if (status & TEGRA_APBDMA_STATUS_ISE_EOC) {
> > +		tdc_write(tdc, TEGRA_APBDMA_CHAN_STATUS, status);
> > +		dev_info(tdc2dev(tdc), "%s():handling isr\n", __func__);
> 
> If you swap the order of patches 1 and 2, then you can just add that
> line as dev_dbg() from the start, and you won't need to change it in the
> next patch.
> 
Will do.
> > +		tdc->isr_handler(tdc, false);
> > +		tegra_dma_resume(tdc);
> > +		return 0;
> 
> Why resume and return here? Shouldn't those last 2 lines be removed, so
> the code can simply continue through the balance of the function and
> return the actual status. tegra_dma_terminate_all() does that.
> 
Handling the interrupt will increment the transfer count when that segment is completed.  There's no need to read the hardware and in fact, we don't want to run the risk of reading a hardware register that is stale.  For example, the transfer is complete, but the transfer count register has not been zeroed.

> > @@ -812,9 +851,22 @@ static enum dma_status tegra_dma_tx_status(struct dma_chan *dc,
> >  	list_for_each_entry(sg_req, &tdc->pending_sg_req, node) {
> >  		dma_desc = sg_req->dma_desc;
> >  		if (dma_desc->txd.cookie == cookie) {
> > +			hw_byte_count = tegra_dma_wcount_in_bytes(dc);
> > +
> > +			if (!list_empty(&tdc->pending_sg_req))
> 
> Since this code is inside a loop that iterates over tha list, I don't
> think the list can ever be empty.
> $
tegra_dma_wcount_in_bytes may modify the pending_sg_req since it can invoke the ISR.  So the list may become empty.  Explaining that just now made me cringe, shall I rewrite it so we can't modify the list we're iterating over?  Granted, once this code is invoked, we're done iterating.

> > +				first_entry =
> > +					list_first_entry(&tdc->pending_sg_req,
> > +						typeof(*first_entry), node);
> > +
> >  			residual =  dma_desc->bytes_requested -
> >  					(dma_desc->bytes_transferred %
> >  						dma_desc->bytes_requested);
> > +
> > +			/* hw byte count only applies to current transaction */
> > +			if (first_entry &&
> > +				first_entry->dma_desc->txd.cookie == cookie)
> > +				residual -= hw_byte_count;
> > +
> >  			dma_set_residue(txstate, residual);
> 
> Why not re-order the added code so that all the new code is added in one
> place, and the hw_byte_count value is only calculated if it's used, i.e.:
> 
> residual = ...;
> first_entry = ...;
> if (sg_reg == first_entry) {
>     hw_byte_count = ...;
>     residual -= hw_byte_count;
> }
> 
My comment above may shed some light on the ordering reason.  The "first entry" may change when we handle the ISR.
