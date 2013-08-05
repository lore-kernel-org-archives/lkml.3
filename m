Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab3HEHyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:54:03 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:53740 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab3HEHyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:54:00 -0400
Message-ID: <20991.23049.78707.457046@ipc1.ka-ro>
Date: Mon, 5 Aug 2013 09:53:45 +0200
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Jingchang Lu <b35083@freescale.com>
Cc: <vinod.koul@intel.com>, Xiaochun Li <b41219@freescale.com>,
        Alison Wang <b18965@freescale.com>, linux-kernel@vger.kernel.org,
        djbw@fb.com, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 3/3] dma: Add Freescale eDMA engine driver support
In-Reply-To: <1375682824-11443-2-git-send-email-b35083@freescale.com>
References: <1375682824-11443-1-git-send-email-b35083@freescale.com>
	<1375682824-11443-2-git-send-email-b35083@freescale.com>
X-Mailer: VM 8.1.0 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jingchang Lu writes:
> Add Freescale enhanced direct memory(eDMA) controller support.
> The eDMA controller deploys DMAMUXs routing DMA request sources(slot)
> to eDMA channels.
> This module can be found on Vybrid and LS-1 SoCs.
> 
[...]
> +static struct fsl_edma_desc *fsl_edma_alloc_desc(struct fsl_edma_chan *fsl_chan,
> +		int sg_len)
> +{
> +	struct fsl_edma_desc *fsl_desc;
> +	int size, i;
> +
> +	size = sizeof(struct fsl_edma_desc);
> +	size += sizeof(struct fsl_edma_sw_tcd) * sg_len;
> +	fsl_desc = kzalloc(size, GFP_KERNEL);
> +	if (!fsl_desc)
> +		return NULL;
> +
> +	fsl_desc->echan = fsl_chan;
> +	fsl_desc->n_tcds = sg_len;
> +	for (i = 0; i < sg_len; i++) {
> +		fsl_desc->tcd[i].vtcd = dma_pool_alloc(fsl_chan->tcd_pool,
> +					GFP_ATOMIC, &fsl_desc->tcd[i].ptcd);
>
Why is this called with GFP_ATOMIC while fsl_desc above is being
allocated with GFP_KERNEL?

> +		if (!fsl_desc->tcd[i].vtcd)
> +			goto free_on_err;
> +	}
> +	return fsl_desc;
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
> +static void fsl_edma_xfer_desc(struct fsl_edma_chan *fsl_chan)
> +{
> +	struct fsl_edma_hw_tcd *tcd;
> +	struct virt_dma_desc *vdesc;
> +
> +	vdesc = vchan_next_desc(&fsl_chan->vchan);
> +	if (!vdesc)
> +		return;
> +	fsl_chan->edesc = to_fsl_edma_desc(vdesc);
> +	tcd = fsl_chan->edesc->tcd[0].vtcd;
> +	fsl_edma_set_tcd_params(fsl_chan, tcd->saddr, tcd->daddr, tcd->attr,
> +			tcd->soff, tcd->nbytes, tcd->slast, tcd->citer,
> +			tcd->biter, tcd->doff, tcd->dlast_sga, tcd->csr);
> +	fsl_edma_enable_request(fsl_chan);
> +	fsl_chan->status = DMA_IN_PROGRESS;
> +}
> +
> +static irqreturn_t fsl_edma_irq_handler(int irq, void *dev_id)
> +{
> +	struct fsl_edma_engine *fsl_edma = dev_id;
> +	unsigned int intr, ch;
> +	void __iomem *base_addr;
> +	struct fsl_edma_chan *fsl_chan;
> +
> +	base_addr = fsl_edma->membase;
> +
	void __iomem *base_addr = fsl_edma->membase;

> +	intr = readl(base_addr + EDMA_INTR);
> +	if (!intr)
> +		return IRQ_NONE;
> +
> +	for (ch = 0; ch < 32; ch++)
> +		if (intr & (0x1 << ch))
> +			break;
> +
What, if IRQs for multiple channels are pending at the same time?
You could handle them all in one go without extra calls of the IRQ
handler.

> +	writeb(EDMA_CINT_CINT(ch), base_addr + EDMA_CINT);
> +
> +	fsl_chan = &fsl_edma->chans[ch];
> +
> +	if (!fsl_chan->edesc->iscyclic) {
> +		list_del(&fsl_chan->edesc->vdesc.node);
>
Ain't there any protection needed for the list operation?

> +static irqreturn_t fsl_edma_err_handler(int irq, void *dev_id)
> +{
> +	struct fsl_edma_engine *fsl_edma = dev_id;
> +	unsigned long err;
> +	int ch;
> +
> +	err = readl(fsl_edma->membase + EDMA_ERR);
> +	if (!err)
> +		return IRQ_NONE;
> +
> +	for (ch = 0; ch < 32; ch++)
> +		if (err & (0x1 << ch))
> +			break;
> +
see above.

> +static void fsl_edma_issue_pending(struct dma_chan *chan)
> +{
> +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&fsl_chan->vchan.lock, flags);
> +
> +	if (vchan_issue_pending(&fsl_chan->vchan) && !fsl_chan->edesc)
> +		fsl_edma_xfer_desc(fsl_chan);
> +
> +	spin_unlock_irqrestore(&fsl_chan->vchan.lock, flags);
> +}
> +
> +static bool fsl_edma_filter_fn(struct dma_chan *chan, void *fn_param)
> +{
> +	struct fsl_edma_filter_param *fparam = fn_param;
> +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> +
> +	if (fsl_chan->edmamux->mux_id != fparam->mux_id)
> +		return false;
> +
> +	fsl_chan->slot_id = fparam->slot_id;
> +	chan->private = fn_param;
> +	return true;
> +}
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
> +	return dma_request_channel(mask, fsl_edma_filter_fn, (void *)&fparam);
> +}
> +
> +static int fsl_edma_alloc_chan_resources(struct dma_chan *chan)
> +{
> +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> +	struct fsl_edma_filter_param *data = chan->private;
> +	unsigned char val;
> +
> +	val = EDMAMUX_CHCFG_ENBL | EDMAMUX_CHCFG_SOURCE(data->slot_id);
> +	fsl_edmamux_config_chan(fsl_chan, val);
> +
> +	fsl_chan->tcd_pool = dma_pool_create("tcd_pool", chan->device->dev,
> +				sizeof(struct fsl_edma_hw_tcd),
> +				32, 0);
> +	return 0;
> +}
> +
> +static void fsl_edma_free_chan_resources(struct dma_chan *chan)
> +{
> +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> +
> +	fsl_edma_disable_request(fsl_chan);
> +	fsl_edmamux_config_chan(fsl_chan, EDMAMUX_CHCFG_DIS);
> +	fsl_chan->edesc = NULL;
> +	vchan_free_chan_resources(&fsl_chan->vchan);
> +	dma_pool_destroy(fsl_chan->tcd_pool);
> +	fsl_chan->tcd_pool = NULL;
> +}
> +
> +static int
> +fsl_init_edmamux(struct platform_device *pdev, struct fsl_edma_engine *fsl_edma)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct fsl_edma_dmamux *fsl_edmamux;
> +	struct device_node *phandle;
> +	const void *prop;
> +	struct resource res;
> +	int len, n_muxes, chans_per_mux, ch_off;
> +	int i, j;
> +	int ret;
> +
> +	prop = of_get_property(np, "fsl,dma-mux", &len);
> +	if (!prop)
> +		return -EINVAL;
> +
> +	n_muxes = len / sizeof(u32);
> +	chans_per_mux = fsl_edma->n_chans / n_muxes;
> +	fsl_edmamux = devm_kzalloc(&pdev->dev,
> +			sizeof(struct fsl_edma_dmamux) * n_muxes, GFP_KERNEL);
> +	if (!fsl_edmamux)
> +		return -ENOMEM;
> +
> +	fsl_edma->n_muxes = 0;
> +	fsl_edma->edmamux = fsl_edmamux;
> +	for (i = 0; i < n_muxes; i++) {
> +		phandle = of_parse_phandle(np, "fsl,dma-mux", i);
> +		ret = of_address_to_resource(phandle, 0, &res);
> +		if (ret)
> +			return ret;
> +		fsl_edmamux->membase = devm_ioremap_resource(&pdev->dev, &res);
> +		if (IS_ERR(fsl_edmamux->membase))
> +			return PTR_ERR(fsl_edmamux->membase);
> +
> +		fsl_edmamux->clk = of_clk_get(phandle, 0);
> +		if (IS_ERR(fsl_edmamux->clk))
> +			return PTR_ERR(fsl_edmamux->clk);
> +
> +		clk_prepare_enable(fsl_edmamux->clk);
>
What, if this fails?

> +
> +		ret = of_property_read_u32_index(phandle, "fsl,dmamux-id", 0,
> +				&fsl_edmamux->mux_id);
> +		if (ret)
> +			return ret;
> +
>
some error messages would be nice to find out what's wrong in case of
failure.

> +		ch_off = fsl_edma->n_muxes * chans_per_mux;
> +		for (j = 0; j < chans_per_mux; j++)
> +			fsl_edma->chans[ch_off + j].edmamux = fsl_edmamux;
> +
> +		fsl_edmamux++;
> +		fsl_edma->n_muxes++;
> +	}
> +	return 0;
> +}
> +
> +static int
> +fsl_edma_init_irq(struct platform_device *pdev, struct fsl_edma_engine *fsl_edma)
> +{
> +	int ret;
> +
> +	fsl_edma->edmairq.txirq = platform_get_irq_byname(pdev, "edma-tx");
> +	if (fsl_edma->edmairq.txirq < 0)
> +		return -EINVAL;
>
You already have an error code in fsl_edma->edmairq.txirq. Why drop it
and return -EINVAL instead?

> +	ret = devm_request_irq(&pdev->dev, fsl_edma->edmairq.txirq,
> +			fsl_edma_irq_handler, IRQF_SHARED, "eDMA tx", fsl_edma);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Can't register eDMA tx IRQ.\n");
> +		return  ret;
> +	}
> +
> +	fsl_edma->edmairq.errirq = platform_get_irq_byname(pdev, "edma-err");
> +	if (fsl_edma->edmairq.errirq < 0)
> +		return -EINVAL;
>
see above.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
