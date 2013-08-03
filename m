Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3HCPyF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 11:54:05 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:33536 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3HCPyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 11:54:03 -0400
X-Auth-Info: 4nu+fX1ebvHKQxWSsjZ0SGXTU9QazUVraZgHVr1pBA0=
Date: Sat, 3 Aug 2013 17:53:51 +0200
From: Gerhard Sittig <gsi@denx.de>
To: Alexander Popov <a13xp0p0v88@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        Anatolij Gustschin <agust@denx.de>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v3 2/5] dma: mpc512x: add support for peripheral
 transfers
Message-ID: <20130803155351.GK2580@book.gsilab.sittig.org>
Mail-Followup-To: Alexander Popov <a13xp0p0v88@gmail.com>,
	Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
	Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
	Anatolij Gustschin <agust@denx.de>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
References: <1375255292-11288-1-git-send-email-a13xp0p0v88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375255292-11288-1-git-send-email-a13xp0p0v88@gmail.com>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 11:21 +0400, Alexander Popov wrote:
> 
> Introduce support for slave s/g transfer preparation and the associated
> device control callback in the MPC512x DMA controller driver, which adds
> support for data transfers between memory and peripheral I/O to the
> previously supported mem-to-mem transfers.
> 
> Refuse to prepare chunked transfers (transfers with more than one part)
> as long as proper support for scatter/gather is lacking.
> 
> Keep MPC8308 operational by always starting transfers from software,
> this SoC appears to not have request lines for flow control when
> peripherals are involved in transfers.
> 
> Signed-off-by: Alexander Popov <a13xp0p0v88@gmail.com>
> ---
>  drivers/dma/mpc512x_dma.c | 183 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 176 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c

You don't provide a lot of information to those you want to
receive feedback from.  You should keep a history and list the
changes between versions.  And you may want to somehow link this
v3 to its predecessor -- especially when you only send part of
the series and assume that reviewers may know where to find the
remainder.

Please help those persons you want to get help from.

> index b8881de..d96d107 100644
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
> @@ -199,6 +195,11 @@ struct mpc_dma_chan {
>  	struct mpc_dma_tcd		*tcd;
>  	dma_addr_t			tcd_paddr;
>  
> +	/* Settings for access to peripheral FIFO */
> +	int				will_access_peripheral;
> +	dma_addr_t			per_paddr;	/* FIFO address */
> +	u32				tcd_nunits;
> +
>  	/* Lock for this structure */
>  	spinlock_t			lock;
>  };
> @@ -264,7 +265,10 @@ static void mpc_dma_execute(struct mpc_dma_chan *mchan)
>  
>  		prev->tcd->dlast_sga = mdesc->tcd_paddr;
>  		prev->tcd->e_sg = 1;
> -		mdesc->tcd->start = 1;
> +
> +		/* software start for mem-to-mem transfers */
> +		if (mdma->is_mpc8308 || !mchan->will_access_peripheral)
> +			mdesc->tcd->start = 1;

here (channel -> will access peripheral)

>  
>  		prev = mdesc;
>  	}
> @@ -276,7 +280,17 @@ static void mpc_dma_execute(struct mpc_dma_chan *mchan)
>  
>  	if (first != prev)
>  		mdma->tcd[cid].e_sg = 1;
> -	out_8(&mdma->regs->dmassrt, cid);
> +
> +	if (mdma->is_mpc8308) {
> +		/* MPC8308, no request lines, software initiated start */
> +		out_8(&mdma->regs->dmassrt, cid);
> +	} else if (mchan->will_access_peripheral) {
> +		/* peripherals involved, use external request line */
> +		out_8(&mdma->regs->dmaserq, cid);
> +	} else {
> +		/* memory to memory transfer, software initiated start */
> +		out_8(&mdma->regs->dmassrt, cid);
> +	}

and here (channel -> will access peripheral)

>  }
>  
>  /* Handle interrupt on one half of DMA controller (32 channels) */
> @@ -649,6 +663,158 @@ mpc_dma_prep_memcpy(struct dma_chan *chan, dma_addr_t dst, dma_addr_t src,
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
> +	dma_addr_t per_paddr;
> +	u32 tcd_nunits = 0;
> +	struct mpc_dma_tcd *tcd;
> +	unsigned long iflags;
> +	struct scatterlist *sg;
> +	size_t len;
> +	int iter, i;
> +
> +	if (!list_empty(&mchan->active))
> +		return NULL;
> +
> +	/* currently there is no proper support for scatter/gather */
> +	if (sg_len > 1)
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
> +		per_paddr = mchan->per_paddr;
> +		tcd_nunits = mchan->tcd_nunits;
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
> +			tcd->saddr = per_paddr;
> +			tcd->daddr = sg_dma_address(sg);
> +			tcd->soff = 0;
> +			tcd->doff = 4;
> +		} else if (direction == DMA_MEM_TO_DEV) {
> +			tcd->saddr = sg_dma_address(sg);
> +			tcd->daddr = per_paddr;
> +			tcd->soff = 4;
> +			tcd->doff = 0;
> +		} else {
> +			return NULL;
> +		}
> +		tcd->ssize = MPC_DMA_TSIZE_4;
> +		tcd->dsize = MPC_DMA_TSIZE_4;
> +
> +		len = sg_dma_len(sg);
> +
> +		if (tcd_nunits)
> +			tcd->nbytes = tcd_nunits * 4;
> +		else
> +			return NULL;
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
> +	return &mdesc->desc;
> +}
> +
> +static int mpc_dma_device_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> +				  unsigned long arg)
> +{
> +	struct mpc_dma_chan *mchan;
> +	struct mpc_dma *mdma;
> +	struct dma_slave_config *cfg;
> +	unsigned long flags;
> +
> +	mchan = dma_chan_to_mpc_dma_chan(chan);
> +	switch (cmd) {
> +	case DMA_TERMINATE_ALL:
> +		/* disable channel requests */
> +		mdma = dma_chan_to_mpc_dma(chan);
> +
> +		spin_lock_irqsave(&mchan->lock, flags);
> +
> +		out_8(&mdma->regs->dmacerq, chan->chan_id);
> +		list_splice_tail_init(&mchan->prepared, &mchan->free);
> +		list_splice_tail_init(&mchan->queued, &mchan->free);
> +		list_splice_tail_init(&mchan->active, &mchan->free);
> +
> +		spin_unlock_irqrestore(&mchan->lock, flags);
> +
> +		return 0;
> +	case DMA_SLAVE_CONFIG:
> +		cfg = (void *)arg;
> +		if (cfg->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES &&
> +		    cfg->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES)
> +			return -EINVAL;
> +
> +		spin_lock_irqsave(&mchan->lock, flags);
> +
> +		mchan->will_access_peripheral = 1;
> +
> +		if (cfg->direction == DMA_DEV_TO_MEM) {
> +			mchan->per_paddr = cfg->src_addr;
> +			mchan->tcd_nunits = cfg->src_maxburst;
> +		} else {
> +			mchan->per_paddr = cfg->dst_addr;
> +			mchan->tcd_nunits = cfg->dst_maxburst;
> +		}
> +
> +		spin_unlock_irqrestore(&mchan->lock, flags);
> +
> +		return 0;
> +	default:
> +		return -ENOSYS;
> +	}
> +
> +	return -EINVAL;
> +}
> +

and here


I think it's unfortunate to attribute the "will access
peripheral" to the channel instead of the transfer job, and to
set the flag from within the device control callback, and to
nevery clear the flag (what will happen if a channel gets freed
and reallocated by some other client?).

I think that the peripheral access is an attribute of the
transfer job, and should be setup in the prep routines (both set
and cleared, depending on what gets setup).  This would be more
robust and more readable (read: maintainable) in my eyes.

>  static int mpc_dma_probe(struct platform_device *op)
>  {
>  	struct device_node *dn = op->dev.of_node;
> @@ -733,9 +899,12 @@ static int mpc_dma_probe(struct platform_device *op)
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


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
