Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3HERPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:15:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:49980 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab3HERPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:15:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,819,1367996400"; 
   d="scan'208";a="277982413"
Date: Mon, 5 Aug 2013 22:04:44 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Jingchang Lu <b35083@freescale.com>
Cc: djbw@fb.com, shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alison Wang <b18965@freescale.com>, Xiaochun Li <b41219@freescale.com>
Subject: Re: [PATCH v2 3/3] dma: Add Freescale eDMA engine driver support
Message-ID: <20130805163444.GQ29095@intel.com>
References: <1375682824-11443-1-git-send-email-b35083@freescale.com>
 <1375682824-11443-2-git-send-email-b35083@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375682824-11443-2-git-send-email-b35083@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 02:07:04PM +0800, Jingchang Lu wrote:
> Add Freescale enhanced direct memory(eDMA) controller support.
> The eDMA controller deploys DMAMUXs routing DMA request sources(slot)
> to eDMA channels.
> This module can be found on Vybrid and LS-1 SoCs.
> 
> Signed-off-by: Alison Wang <b18965@freescale.com>
> Signed-off-by: Xiaochun Li <b41219@freescale.com>
> Signed-off-by: Jingchang Lu <b35083@freescale.com>
> ---

> +
> +static void fsl_edma_free_desc(struct virt_dma_desc *vdesc)
> +{
> +	struct fsl_edma_desc *fsl_desc;
> +	int i;
> +
> +	fsl_desc = to_fsl_edma_desc(vdesc);
> +	for (i = 0; i < fsl_desc->n_tcds; i++)
> +			dma_pool_free(fsl_desc->echan->tcd_pool,
> +					fsl_desc->tcd[i].vtcd,
> +					fsl_desc->tcd[i].ptcd);
> +	kfree(fsl_desc);
should this be called with lock held or not?

> +}
> +
> +static int fsl_edma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> +		unsigned long arg)
> +{
> +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> +	struct dma_slave_config *cfg = (void *)arg;
> +
> +	switch (cmd) {
> +	case DMA_TERMINATE_ALL:
> +		fsl_edma_disable_request(fsl_chan);
> +		fsl_chan->edesc = NULL;
> +		vchan_free_chan_resources(&fsl_chan->vchan);
> +		return 0;
empty line here pls

> +	case DMA_SLAVE_CONFIG:
> +		fsl_chan->fsc.dir = cfg->direction;
> +		if (cfg->direction == DMA_DEV_TO_MEM) {
> +			fsl_chan->fsc.dev_addr = cfg->src_addr;
> +			fsl_chan->fsc.addr_width = cfg->src_addr_width;
> +			fsl_chan->fsc.burst = cfg->src_maxburst;
> +		} else {
i would prefer you check for DMA_MEM_TO_DEV here and discard rest of the cases
if sent as error

> +			fsl_chan->fsc.dev_addr = cfg->dst_addr;
> +			fsl_chan->fsc.addr_width = cfg->dst_addr_width;
> +			fsl_chan->fsc.burst = cfg->dst_maxburst;
> +		}
> +		fsl_chan->fsc.attr = fsl_edma_get_tcd_attr(fsl_chan->fsc.addr_width);
> +		return 0;
> +	default:
> +		return -ENOSYS;
-ENXIO perhaps...

> +	}
> +}
> +

> +static struct fsl_edma_desc *fsl_edma_alloc_desc(struct fsl_edma_chan *fsl_chan,
> +		int sg_len)
> +{
> +	struct fsl_edma_desc *fsl_desc;
> +	int size, i;
> +
> +	size = sizeof(struct fsl_edma_desc);
> +	size += sizeof(struct fsl_edma_sw_tcd) * sg_len;
> +	fsl_desc = kzalloc(size, GFP_KERNEL);
how about, kzalloc(sizeof(*fsl_desc) * sg_len, GFP_NOWAIT)
> +	if (!fsl_desc)
> +		return NULL;
> +
> +	fsl_desc->echan = fsl_chan;
> +	fsl_desc->n_tcds = sg_len;
> +	for (i = 0; i < sg_len; i++) {
> +		fsl_desc->tcd[i].vtcd = dma_pool_alloc(fsl_chan->tcd_pool,
> +					GFP_ATOMIC, &fsl_desc->tcd[i].ptcd);
> +		if (!fsl_desc->tcd[i].vtcd)
> +			goto free_on_err;
> +	}
> +	return fsl_desc;
empty line here

> +free_on_err:
> +	while (--i >= 0)
> +		dma_pool_free(fsl_chan->tcd_pool, fsl_desc->tcd[i].vtcd,
> +				fsl_desc->tcd[i].ptcd);
> +	kfree(fsl_desc);
> +	return NULL;
> +}
> +
> +static struct dma_async_tx_descriptor *fsl_edma_prep_dma_cyclic(
> +		struct dma_chan *chan, dma_addr_t dma_addr, size_t buf_len,
> +		size_t period_len, enum dma_transfer_direction direction,
> +		unsigned long flags, void *context)
> +{
> +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> +	struct fsl_edma_desc *fsl_desc;
> +	dma_addr_t dma_buf_next;
> +	int sg_len, i;
> +	u32 src_addr, dst_addr, last_sg, nbytes;
> +	u16 soff, doff, iter;
> +
> +	sg_len = buf_len / period_len;
> +	fsl_desc = fsl_edma_alloc_desc(fsl_chan, sg_len);
> +	if (!fsl_desc)
> +		return NULL;
> +	fsl_desc->iscyclic = true;
> +
> +	dma_buf_next = dma_addr;
> +	nbytes = fsl_chan->fsc.addr_width * fsl_chan->fsc.burst;
> +	iter = period_len / nbytes;
> +	for (i = 0; i < sg_len; i++) {
> +		if (dma_buf_next >= dma_addr + buf_len)
> +			dma_buf_next = dma_addr;
> +
> +		/* get next sg's physical address */
> +		last_sg = fsl_desc->tcd[(i + 1) % sg_len].ptcd;
> +
> +		if (fsl_chan->fsc.dir == DMA_MEM_TO_DEV) {
> +			src_addr = dma_buf_next;
> +			dst_addr = fsl_chan->fsc.dev_addr;
> +			soff = fsl_chan->fsc.addr_width;
> +			doff = 0;
> +		} else {
again check for dirrection would be apt

> +			src_addr = fsl_chan->fsc.dev_addr;
> +			dst_addr = dma_buf_next;
> +			soff = 0;
> +			doff = fsl_chan->fsc.addr_width;
> +		}
> +
> +		fill_tcd_params(fsl_desc->tcd[i].vtcd, src_addr, dst_addr,
> +				fsl_chan->fsc.attr, soff, nbytes, 0,
> +				iter, iter, doff, last_sg, true, false, true);
> +		dma_buf_next += period_len;
> +	}
> +
> +	return vchan_tx_prep(&fsl_chan->vchan, &fsl_desc->vdesc, flags);
> +}
> +
> +static struct dma_async_tx_descriptor *fsl_edma_prep_slave_sg(
> +		struct dma_chan *chan, struct scatterlist *sgl,
> +		unsigned int sg_len, enum dma_transfer_direction direction,
> +		unsigned long flags, void *context)
> +{
> +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> +	struct fsl_edma_desc *fsl_desc;
> +	struct scatterlist *sg;
> +	u32 src_addr, dst_addr, last_sg, nbytes;
> +	u16 soff, doff, iter;
> +	int i;
> +
> +	fsl_desc = fsl_edma_alloc_desc(fsl_chan, sg_len);
> +	if (!fsl_desc)
> +		return NULL;
> +	fsl_desc->iscyclic = false;
> +
> +	nbytes = fsl_chan->fsc.addr_width * fsl_chan->fsc.burst;
> +	for_each_sg(sgl, sg, sg_len, i) {
> +		/* get next sg's physical address */
> +		last_sg = fsl_desc->tcd[(i + 1) % sg_len].ptcd;
> +
> +		if (fsl_chan->fsc.dir == DMA_MEM_TO_DEV) {
> +			src_addr = sg_dma_address(sg);
> +			dst_addr = fsl_chan->fsc.dev_addr;
> +			soff = fsl_chan->fsc.addr_width;
> +			doff = 0;
> +		} else {
ditto

> +			src_addr = fsl_chan->fsc.dev_addr;
> +			dst_addr = sg_dma_address(sg);
> +			soff = 0;
> +			doff = fsl_chan->fsc.addr_width;
> +		}
> +
> +		iter = sg_dma_len(sg) / nbytes;
> +		if (i < sg_len - 1) {
> +			last_sg = fsl_desc->tcd[(i + 1)].ptcd;
> +			fill_tcd_params(fsl_desc->tcd[i].vtcd, src_addr,
> +				dst_addr, fsl_chan->fsc.attr, soff, nbytes, 0,
> +				iter, iter, doff, last_sg, false, false, true);
> +		} else {
> +			last_sg = 0;
> +			fill_tcd_params(fsl_desc->tcd[i].vtcd, src_addr,
> +				dst_addr, fsl_chan->fsc.attr, soff, nbytes, 0,
> +				iter, iter, doff, last_sg, true, true, false);
> +		}
> +	}
> +
> +	return vchan_tx_prep(&fsl_chan->vchan, &fsl_desc->vdesc, flags);
> +}
> +

> +
> +static struct dma_chan *fsl_edma_xlate(struct of_phandle_args *dma_spec,
> +		struct of_dma *ofdma)
> +{
> +	dma_cap_mask_t mask;
> +	struct fsl_edma_filter_param fparam;
> +
> +	if (dma_spec->args_count != 2)
> +		return NULL;
> +
> +	fparam.mux_id = dma_spec->args[0];
> +	fparam.slot_id = dma_spec->args[1];
> +
> +	dma_cap_zero(mask);
> +	dma_cap_set(DMA_SLAVE, mask);
not cyclic?

> +	return dma_request_channel(mask, fsl_edma_filter_fn, (void *)&fparam);
> +}
> +

> +static int __init fsl_edma_module_init(void)
> +{
> +	return platform_driver_probe(&fsl_edma_driver, fsl_edma_probe);
> +}
> +module_init(fsl_edma_module_init);
> +
> +MODULE_DESCRIPTION("Freescale eDMA engine driver");
> +MODULE_LICENSE("GPL v2");
MODULE_ALAIS?

~Vinod
-- 
