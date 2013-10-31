Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab3JaPFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:05:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:46219 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab3JaPFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:05:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="315287187"
Date: Thu, 31 Oct 2013 19:40:12 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Joel Fernandes <joelf@ti.com>
Cc: dmaengine@vger.kernel.org, Matt Porter <matt@ohporter.com>,
        Russell King <linux@arm.linux.org.uk>, Dan Williams <djbw@fb.com>,
        Jyri Sarha <jsarha@ti.com>, Lars Peter-Clausen <lars@metafoo.de>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/3] dma: edma: Add support for Cyclic DMA
Message-ID: <20131031141012.GJ18788@intel.com>
References: <1379977515-3794-1-git-send-email-joelf@ti.com>
 <1379977515-3794-3-git-send-email-joelf@ti.com>
 <20131021065319.GM14013@intel.com>
 <52669A23.2080805@ti.com>
 <20131024163829.GA21230@intel.com>
 <52695F6E.4030002@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52695F6E.4030002@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 12:57:02PM -0500, Joel Fernandes wrote:
> Rebased on slave-dma/next branch and reapplied:
Looks like your MUA caused lines to get wrapped and patch is corrupt, can you
pls resend again using git-send email. I tried even the patch from
patchworks but that too failed!
> 
> ----8<---
> From: Joel Fernandes <joelf@ti.com>
> Subject: [PATCH v2] dma: edma: Add support for Cyclic DMA
> 
> Using the PaRAM configuration function that we split for reuse by the
> different DMA types, we implement Cyclic DMA support.
> For the cyclic case, we pass different configuration parameters to this
> function, and handle all the Cyclic-specific functionality separately.
> 
> Callbacks to the DMA users are handled using vchan_cyclic_callback in
> the virt-dma layer. Linking is handled the same way as the slave SG case
> except for the last slot where we link it back to the first one in a
> cyclic fashion.
> 
> For continuity, we check for cases where no.of periods is great than the
> MAX number of slots the driver can allocate for a particular descriptor
> and error out on such cases.
> 
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>  drivers/dma/edma.c | 159 ++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 151 insertions(+), 8 deletions(-)
> 

>  	struct edma_chan *echan = data;
> @@ -464,24 +602,28 @@ static void edma_callback(unsigned ch_num, u16 ch_status,
> void *data)
This seems bad
>  	unsigned long flags;
>  	struct edmacc_param p;
> 
> -	/* Pause the channel */
> -	edma_pause(echan->ch_num);
> +	edesc = echan->edesc;
> +
> +	/* Pause the channel for non-cyclic */
> +	if (!edesc || (edesc && !edesc->cyclic))
> +		edma_pause(echan->ch_num);
> 
>  	switch (ch_status) {
>  	case DMA_COMPLETE:
>  		spin_lock_irqsave(&echan->vchan.lock, flags);
> 
> -		edesc = echan->edesc;
>  		if (edesc) {
> -			if (edesc->processed == edesc->pset_nr) {
> +			if (edesc->cyclic) {
> +				vchan_cyclic_callback(&edesc->vdesc);
> +			} else if (edesc->processed == edesc->pset_nr) {
>  				dev_dbg(dev, "Transfer complete, stopping channel %d\n", ch_num);
>  				edma_stop(echan->ch_num);
>  				vchan_cookie_complete(&edesc->vdesc);
> +				edma_execute(echan);
>  			} else {
>  				dev_dbg(dev, "Intermediate transfer complete on channel %d\n", ch_num);
> +				edma_execute(echan);
>  			}
> -
> -			edma_execute(echan);
>  		}
> 
>  		spin_unlock_irqrestore(&echan->vchan.lock, flags);
> @@ -677,6 +819,7 @@ static void edma_dma_init(struct edma_cc *ecc, struct
> dma_device *dma,
ditto and few other which checkpatch was not happy about!
>  			  struct device *dev)
>  {
>  	dma->device_prep_slave_sg = edma_prep_slave_sg;
> +	dma->device_prep_dma_cyclic = edma_prep_dma_cyclic;
>  	dma->device_alloc_chan_resources = edma_alloc_chan_resources;
>  	dma->device_free_chan_resources = edma_free_chan_resources;
>  	dma->device_issue_pending = edma_issue_pending;
> -- 
> 1.8.1.2
> 

--
~Vinod
