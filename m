Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3EXFgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 01:36:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:19655 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab3EXFgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 01:36:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,732,1363158000"; 
   d="scan'208";a="342435060"
Date: Fri, 24 May 2013 10:29:35 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Maarten ter Huurne <maarten@treewalker.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 3/6] dma: Add a jz4740 dmaengine driver
Message-ID: <20130524045935.GM30200@intel.com>
References: <1369341387-19147-1-git-send-email-lars@metafoo.de>
 <1369341387-19147-4-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369341387-19147-4-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 10:36:24PM +0200, Lars-Peter Clausen wrote:
> This patch adds dmaengine support for the JZ4740 DMA controller. For now the
> driver will be a wrapper around the custom JZ4740 DMA API. Once all users of the
> custom JZ4740 DMA API have been converted to the dmaengine API the custom API
> will be removed and direct hardware access will be added to the dmaengine
> driver.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---

> +static enum jz4740_dma_width jz4740_dma_width(enum dma_slave_buswidth width)
> +{
> +	switch (width) {
> +	case DMA_SLAVE_BUSWIDTH_1_BYTE:
> +		return JZ4740_DMA_WIDTH_8BIT;
> +	case DMA_SLAVE_BUSWIDTH_2_BYTES:
> +		return JZ4740_DMA_WIDTH_16BIT;
> +	case DMA_SLAVE_BUSWIDTH_4_BYTES:
> +		return JZ4740_DMA_WIDTH_32BIT;
> +	default:
> +		return JZ4740_DMA_WIDTH_32BIT;
> +	}
Only diff between the values here and dmaengien values is JZ4740_DMA_WIDTH_32BIT
as 0. But the header tells me taht its default and SIZE one has values in that
pattern too. If that is the case you maybe able to get rid on conversion and use
dmaengine values directly.

> +}
> +
> +static enum jz4740_dma_transfer_size jz4740_dma_maxburst(u32 maxburst)
> +{
> +	if (maxburst <= 1)
> +		return JZ4740_DMA_TRANSFER_SIZE_1BYTE;
> +	else if (maxburst <= 3)
> +		return JZ4740_DMA_TRANSFER_SIZE_2BYTE;
> +	else if (maxburst <= 15)
> +		return JZ4740_DMA_TRANSFER_SIZE_4BYTE;
> +	else if (maxburst <= 31)
> +		return JZ4740_DMA_TRANSFER_SIZE_16BYTE;
> +
> +	return JZ4740_DMA_TRANSFER_SIZE_32BYTE;
> +}
> +
> +static int jz4740_dma_slave_config(struct dma_chan *c,
> +	const struct dma_slave_config *config)
> +{
> +	struct jz4740_dmaengine_chan *chan = to_jz4740_dma_chan(c);
> +	struct jz4740_dma_config jzcfg;
> +
> +	switch (config->direction) {
> +	case DMA_MEM_TO_DEV:
> +		jzcfg.flags = JZ4740_DMA_SRC_AUTOINC;
> +		jzcfg.transfer_size = jz4740_dma_maxburst(config->dst_maxburst);
> +		break;
> +	case DMA_DEV_TO_MEM:
> +		jzcfg.flags = JZ4740_DMA_DST_AUTOINC;
> +		jzcfg.transfer_size = jz4740_dma_maxburst(config->src_maxburst);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +
> +	jzcfg.src_width = jz4740_dma_width(config->src_addr_width);
> +	jzcfg.dst_width = jz4740_dma_width(config->dst_addr_width);
this should be direction based, typically DMA engines have only one width to be
programmed.
> +	jzcfg.mode = JZ4740_DMA_MODE_SINGLE;
> +	jzcfg.request_type = config->slave_id;
> +
> +	chan->config = *config;
> +
> +	jz4740_dma_configure(chan->jz_chan, &jzcfg);
> +
> +	return 0;
You are NOT use src_addr/dstn_addr? How else are you passing the periphral
address?

> +}
> +
> +static int jz4740_dma_terminate_all(struct dma_chan *c)
> +{
> +	struct jz4740_dmaengine_chan *chan = to_jz4740_dma_chan(c);
> +	unsigned long flags;
> +	LIST_HEAD(head);
> +
> +	spin_lock_irqsave(&chan->vchan.lock, flags);
> +	jz4740_dma_disable(chan->jz_chan);
> +	chan->desc = NULL;
> +	vchan_get_all_descriptors(&chan->vchan, &head);
> +	spin_unlock_irqrestore(&chan->vchan.lock, flags);
> +
> +	vchan_dma_desc_free_list(&chan->vchan, &head);
> +
> +	return 0;
> +}
> +
> +static int jz4740_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> +	unsigned long arg)
> +{
> +	struct dma_slave_config *config = (struct dma_slave_config *)arg;
> +
> +	switch (cmd) {
> +	case DMA_SLAVE_CONFIG:
> +		return jz4740_dma_slave_config(chan, config);
> +	case DMA_TERMINATE_ALL:
> +		return jz4740_dma_terminate_all(chan);
> +	default:
> +		return -EINVAL;
ENXIO/ENOSYS perhaps?
> +	}
> +}
> +

> +static int jz4740_dma_alloc_chan_resources(struct dma_chan *c)
> +{
> +	struct jz4740_dmaengine_chan *chan = to_jz4740_dma_chan(c);
> +
> +	chan->jz_chan = jz4740_dma_request(chan, NULL);
> +	if (!chan->jz_chan)
> +		return -EBUSY;
> +
> +	jz4740_dma_set_complete_cb(chan->jz_chan, jz4740_dma_complete_cb);
> +
> +	return 0;
Zero is not expected value, you need to return the descriptors allocated
sucessfully.
> +}
> +
> +static void jz4740_dma_free_chan_resources(struct dma_chan *c)
> +{
> +	struct jz4740_dmaengine_chan *chan = to_jz4740_dma_chan(c);
> +
> +	vchan_free_chan_resources(&chan->vchan);
> +	jz4740_dma_free(chan->jz_chan);
> +	chan->jz_chan = NULL;
> +}
> +
> +static void jz4740_dma_desc_free(struct virt_dma_desc *vdesc)
> +{
> +	kfree(container_of(vdesc, struct jz4740_dma_desc, vdesc));
> +}
> +
> +static int jz4740_dma_probe(struct platform_device *pdev)
> +{
> +	struct jz4740_dmaengine_chan *chan;
> +	struct jz4740_dma_dev *dmadev;
> +	struct dma_device *dd;
> +	unsigned int i;
> +	int ret;
> +
> +	dmadev = devm_kzalloc(&pdev->dev, sizeof(*dmadev), GFP_KERNEL);
> +	if (!dmadev)
> +		return -EINVAL;
> +
> +	dd = &dmadev->ddev;
> +
> +	dma_cap_set(DMA_SLAVE, dd->cap_mask);
> +	dma_cap_set(DMA_CYCLIC, dd->cap_mask);
> +	dd->device_alloc_chan_resources = jz4740_dma_alloc_chan_resources;
> +	dd->device_free_chan_resources = jz4740_dma_free_chan_resources;
> +	dd->device_tx_status = jz4740_dma_tx_status;
> +	dd->device_issue_pending = jz4740_dma_issue_pending;
> +	dd->device_prep_slave_sg = jz4740_dma_prep_slave_sg;
> +	dd->device_prep_dma_cyclic = jz4740_dma_prep_dma_cyclic;
> +	dd->device_control = jz4740_dma_control;
> +	dd->dev = &pdev->dev;
> +	dd->chancnt = 6;
hard coding is not advised
> +	INIT_LIST_HEAD(&dd->channels);
> +
> +	for (i = 0; i < dd->chancnt; i++) {
> +		chan = &dmadev->chan[i];
> +		chan->vchan.desc_free = jz4740_dma_desc_free;
> +		vchan_init(&chan->vchan, dd);
> +	}
> +
> +	ret = dma_async_device_register(dd);
> +	if (ret)
> +		return ret;
> +
> +	platform_set_drvdata(pdev, dmadev);
> +
> +	return 0;
> +}
> +
> +static int jz4740_dma_remove(struct platform_device *pdev)
> +{
> +	struct jz4740_dma_dev *dmadev = platform_get_drvdata(pdev);
> +
> +	dma_async_device_unregister(&dmadev->ddev);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver jz4740_dma_driver = {
> +	.probe = jz4740_dma_probe,
> +	.remove = jz4740_dma_remove,
> +	.driver = {
> +		.name = "jz4740-dma",
> +		.owner = THIS_MODULE,
> +	},
> +};
> +module_platform_driver(jz4740_dma_driver);
typically lot of dma driver like to be higher up in the module order. The reason
is to have device initialized before clients, pls check if you need that

--
~Vinod
