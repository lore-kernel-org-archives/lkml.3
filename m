Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab3GJM6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 08:58:21 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:59312 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3GJM6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 08:58:18 -0400
X-Auth-Info: NKP0yK1YoKikRPqSpRYWiGyFb5JvE5vxGhg/CyOmWnQ=
Date: Wed, 10 Jul 2013 14:58:11 +0200
From: Gerhard Sittig <gsi@denx.de>
To: Alexander Popov <a13xp0p0v88@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [V2 1/2] powerpc: mpc512x_dma: add support for data transfers
 between memory and i/o memory
Message-ID: <20130710125811.GB2615@book.gsilab.sittig.org>
Mail-Followup-To: Alexander Popov <a13xp0p0v88@gmail.com>,
	Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <1373451651-20029-1-git-send-email-a13xp0p0v88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373451651-20029-1-git-send-email-a13xp0p0v88@gmail.com>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disclaimer:  It's been a while since I worked with the MPC512x
DMA controller, and I only read the RM rev3 back then.

On Wed, Jul 10, 2013 at 14:20 +0400, Alexander Popov wrote:
> 
> Data transfers between memory and i/o memory require more delicate TCD
> (Transfer Control Descriptor) configuration and DMA channel service requests
> via hardware.
> 
> dma_device.device_control callback function is needed to configure
> DMA channel to work with i/o memory.
> 
> Signed-off-by: Alexander Popov <a13xp0p0v88@gmail.com>
> ---
>  drivers/dma/mpc512x_dma.c | 147 +++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 140 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
> index 2d95673..f90b717 100644
> --- a/drivers/dma/mpc512x_dma.c
> +++ b/drivers/dma/mpc512x_dma.c
> @@ -2,6 +2,7 @@
>   * Copyright (C) Freescale Semicondutor, Inc. 2007, 2008.
>   * Copyright (C) Semihalf 2009
>   * Copyright (C) Ilya Yanok, Emcraft Systems 2010
> + * Copyright (C) Alexander Popov, Promcontroller 2013
>   *
>   * Written by Piotr Ziecik <kosmo@semihalf.com>. Hardware description
>   * (defines, structures and comments) was taken from MPC5121 DMA driver
> @@ -28,11 +29,6 @@
>   * file called COPYING.
>   */
>  
> -/*
> - * This is initial version of MPC5121 DMA driver. Only memory to memory
> - * transfers are supported (tested using dmatest module).
> - */
> -
>  #include <linux/module.h>
>  #include <linux/dmaengine.h>
>  #include <linux/dma-mapping.h>
> @@ -190,9 +186,13 @@ struct mpc_dma_chan {
>  	struct list_head		completed;
>  	struct mpc_dma_tcd		*tcd;
>  	dma_addr_t			tcd_paddr;
> +	u32				tcd_nunits;
>  
>  	/* Lock for this structure */
>  	spinlock_t			lock;
> +
> +	/* Channel's peripheral fifo address */
> +	dma_addr_t			per_paddr;
>  };
>  
>  struct mpc_dma {
> @@ -256,7 +256,9 @@ static void mpc_dma_execute(struct mpc_dma_chan *mchan)
>  
>  		prev->tcd->dlast_sga = mdesc->tcd_paddr;
>  		prev->tcd->e_sg = 1;
> -		mdesc->tcd->start = 1;
> +		/* only start explicitly on MDDRC channel */
> +		if (cid == 32)
> +			mdesc->tcd->start = 1;
>  
>  		prev = mdesc;
>  	}
> @@ -268,7 +270,15 @@ static void mpc_dma_execute(struct mpc_dma_chan *mchan)
>  
>  	if (first != prev)
>  		mdma->tcd[cid].e_sg = 1;
> -	out_8(&mdma->regs->dmassrt, cid);
> +
> +	switch (cid) {
> +	case 26:
> +		out_8(&mdma->regs->dmaserq, cid);
> +		break;
> +	case 32:
> +		out_8(&mdma->regs->dmassrt, cid);
> +		break;
> +	}
>  }
>  
>  /* Handle interrupt on one half of DMA controller (32 channels) */

This part of the change looks suspicious to me.  The logic
changes from always starting the transfer in software to only
starting from software for memory or having hardware request the
start for LPB controller requests, while _all_other_ channels
remain without setup of the start condition.

Either make sure that only the new source (LPB) gets handled
specially, or put a huge comment there about "if more components
start using DMA channels, they need to get added here".  Go with
the first approach if possible.

Or -- after some more thought -- if "memory" appears to be the
exception (since everything else involves hardware requests)
treat this one case specially and everything else the same way.

In addition, try to get rid of the magic numbers.  Use symbolic
identifiers instead (regardless of whether other floating patches
used magic numbers as well).


> @@ -641,6 +651,126 @@ mpc_dma_prep_memcpy(struct dma_chan *chan, dma_addr_t dst, dma_addr_t src,
>  	return &mdesc->desc;
>  }
>  
> +static struct dma_async_tx_descriptor *mpc_dma_prep_slave_sg(
> +		struct dma_chan *chan, struct scatterlist *sgl,
> +		unsigned int sg_len, enum dma_transfer_direction direction,
> +		unsigned long flags, void *context)
> +{
> +	struct mpc_dma *mdma = dma_chan_to_mpc_dma(chan);
> +	struct mpc_dma_chan *mchan = dma_chan_to_mpc_dma_chan(chan);
> +	struct mpc_dma_desc *mdesc = NULL;
> +	struct mpc_dma_tcd *tcd;
> +	unsigned long iflags;
> +	struct scatterlist *sg;
> +	size_t len;
> +	int iter, i;
> +
> +	if (!list_empty(&mchan->active))
> +		return NULL;
> +
> +	for_each_sg(sgl, sg, sg_len, i) {
> +		spin_lock_irqsave(&mchan->lock, iflags);
> +
> +		mdesc = list_first_entry(&mchan->free, struct mpc_dma_desc,
> +									node);
> +		if (!mdesc) {
> +			spin_unlock_irqrestore(&mchan->lock, iflags);
> +			/* try to free completed descriptors */
> +			mpc_dma_process_completed(mdma);
> +			return NULL;
> +		}
> +
> +		list_del(&mdesc->node);
> +
> +		spin_unlock_irqrestore(&mchan->lock, iflags);
> +
> +		mdesc->error = 0;
> +		tcd = mdesc->tcd;
> +
> +		/* Prepare Transfer Control Descriptor for this transaction */
> +		memset(tcd, 0, sizeof(struct mpc_dma_tcd));
> +
> +		if (!IS_ALIGNED(sg_dma_address(sg), 4))
> +			return NULL;
> +
> +		if (direction == DMA_DEV_TO_MEM) {
> +			tcd->saddr = mchan->per_paddr;
> +			tcd->daddr = sg_dma_address(sg);
> +			tcd->soff = 0;
> +			tcd->doff = 4;
> +		} else if (direction == DMA_MEM_TO_DEV) {
> +			tcd->saddr = sg_dma_address(sg);
> +			tcd->daddr = mchan->per_paddr;
> +			tcd->soff = 4;
> +			tcd->doff = 0;
> +		} else {
> +			return NULL;
> +		}
> +		tcd->ssize = MPC_DMA_TSIZE_4;
> +		tcd->dsize = MPC_DMA_TSIZE_4;

This hardcodes the address increments and the source and
destination port sizes to 32bits, right?  This may be an
acceptable limitation given the current use of the DMA engine,
but might need a comment as well.  (Because I understand that the
hardware isn't limited in that way as long as address and length
specs are aligned to the port width.)

OTOH are we dealing with IP-bus attached peripherals here, where
all RX/TX data registers and FIFO ports might be 32bits wide.

> +
> +		len = sg_dma_len(sg);
> +
> +		if (mchan->tcd_nunits)
> +			tcd->nbytes = mchan->tcd_nunits * 4;
> +		else
> +			tcd->nbytes = 64;
> +
> +		if (!IS_ALIGNED(len, tcd->nbytes))
> +			return NULL;
> +
> +		iter = len / tcd->nbytes;
> +		if (iter > ((1 << 15) - 1)) {   /* maximum biter */
> +			return NULL; /* len is too big */
> +		} else {
> +			/* citer_linkch contains the high bits of iter */
> +			tcd->biter = iter & 0x1ff;
> +			tcd->biter_linkch = iter >> 9;
> +			tcd->citer = tcd->biter;
> +			tcd->citer_linkch = tcd->biter_linkch;
> +		}

I cannot tell how these magic numbers here (bit masks, shift
numbers) are acceptable or shall get replaced by something else.
Just pointing at potential for improvement. :)

> +
> +		tcd->e_sg = 0;
> +		tcd->d_req = 1;
> +
> +		/* Place descriptor in prepared list */
> +		spin_lock_irqsave(&mchan->lock, iflags);
> +		list_add_tail(&mdesc->node, &mchan->prepared);
> +		spin_unlock_irqrestore(&mchan->lock, iflags);
> +	}
> +
> +	/* Return the last descriptor */
> +	return &mdesc->desc;
> +}
> +

It's not related to your specific patch, but I guess that the
current implementation of the MPC512x DMA engine cannot really
cope with scatter/gather as it should.  Unfortunately the Linux
DMA API appears to "somehow intermingle" the S/G aspect with
"peripheral access", while it actually should be orthogonal.

The current implementation does abuse(?) the TCD's S/G flag to
concatenate individually submitted requests, while those requests
themselves _cannot_ use the S/G feature (adjusting the submit
routine might fix that, but I haven't checked in depth).

To cut it short:  As long as "mdesc" items and "TCD" items can't
get allocated and chained individually, and as long as the prep
and submit routines assume that an mdesc is associated with
exactly one tcd, there should be a comment about this limitation
or even better an explicit check in the prep slave sg routine to
reject S/G lists with more than one entry.  Assuming that DMA
clients won't construct invalid lists appears to be fragile.

> +static int mpc_dma_device_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> +				  unsigned long arg)
> +{
> +	struct mpc_dma_chan *mchan = dma_chan_to_mpc_dma_chan(chan);
> +	struct dma_slave_config *cfg = (void *)arg;
> +
> +	switch (cmd) {
> +	case DMA_SLAVE_CONFIG:
> +		if (cfg->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES &&
> +		    cfg->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES)
> +			return -EINVAL;
> +
> +		if (cfg->direction == DMA_DEV_TO_MEM) {
> +			mchan->per_paddr = cfg->src_addr;
> +			mchan->tcd_nunits = cfg->src_maxburst;
> +		} else {
> +			mchan->per_paddr = cfg->dst_addr;
> +			mchan->tcd_nunits = cfg->dst_maxburst;
> +		}
> +
> +		return 0;
> +	default:
> +		return -ENOSYS;
> +	}
> +
> +	return -EINVAL;
> +}
> +
>  static int mpc_dma_probe(struct platform_device *op)
>  {
>  	struct device_node *dn = op->dev.of_node;
> @@ -725,9 +855,12 @@ static int mpc_dma_probe(struct platform_device *op)
>  	dma->device_issue_pending = mpc_dma_issue_pending;
>  	dma->device_tx_status = mpc_dma_tx_status;
>  	dma->device_prep_dma_memcpy = mpc_dma_prep_memcpy;
> +	dma->device_prep_slave_sg = mpc_dma_prep_slave_sg;
> +	dma->device_control = mpc_dma_device_control;
>  
>  	INIT_LIST_HEAD(&dma->channels);
>  	dma_cap_set(DMA_MEMCPY, dma->cap_mask);
> +	dma_cap_set(DMA_SLAVE, dma->cap_mask);
>  
>  	for (i = 0; i < dma->chancnt; i++) {
>  		mchan = &mdma->channels[i];
> -- 
> 1.7.11.3
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
