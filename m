Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbaD3HQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 03:16:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:2113 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbaD3HQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 03:16:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,956,1389772800"; 
   d="scan'208";a="503545534"
Date: Wed, 30 Apr 2014 12:34:08 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, andriy.shevchenko@intel.com,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v7] DMA: sun6i: Add driver for the Allwinner A31 DMA
 controller
Message-ID: <20140430070408.GR32284@intel.com>
References: <1398349364-10726-1-git-send-email-maxime.ripard@free-electrons.com>
 <1398349364-10726-2-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398349364-10726-2-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 04:22:44PM +0200, Maxime Ripard wrote:
> The Allwinner A31 has a 16 channels DMA controller that it shares with the
> newer A23. Although sharing some similarities with the DMA controller of the
> older Allwinner SoCs, it's significantly different, I don't expect it to be
> possible to share the driver for these two.
> 
> The A31 Controller is able to memory-to-memory or memory-to-device transfers on
> the 16 channels in parallel.

Overall driver looks in good shape, few comments though...

> +This driver follows the generic DMA bindings defined in dma.txt.
> +
> +Required properties:
> +
> +- compatible:	Must be "allwinner,sun6i-a31-dma"
> +- reg:		Should contain the registers base address and length
> +- interrupts:	Should contain a reference to the interrupt used by this device
> +- clocks:	Should contain a reference to the parent AHB clock
> +- resets:	Should contain a reference to the reset controller asserting
> +	  	this device in reset
> +- #dma-cells :	Should be 1, a single cell holding a line request number
> +
> +Example:
> +	dma: dma-controller@01c02000 {
> +		compatible = "allwinner,sun6i-a31-dma";
> +		reg = <0x01c02000 0x1000>;
> +		interrupts = <0 50 4>;
> +		clocks = <&ahb1_gates 6>;
> +		resets = <&ahb1_rst 6>;
> +		#dma-cells = <1>;
> +	};
> +
> +Clients:
> +
> +DMA clients connected to the A31 DMA controller must use the format
> +described in the dma.txt file, using a two-cell specifier for each
> +channel: a phandle plus one integer cells.
> +The two cells in order are:
> +
> +1. A phandle pointing to the DMA controller.
> +2. The port ID as specified in the datasheet
> +
> +Example:
> +spi2: spi@01c6a000 {
> +	compatible = "allwinner,sun6i-a31-spi";
> +	reg = <0x01c6a000 0x1000>;
> +	interrupts = <0 67 4>;
> +	clocks = <&ahb1_gates 22>, <&spi2_clk>;
> +	clock-names = "ahb", "mod";
> +	dmas = <&dma 25>, <&dma 25>;
> +	dma-names = "rx", "tx";
> +	resets = <&ahb1_rst 22>;
> +};
Ideally binding should be a separate patch

> +static inline u8 convert_burst(u8 maxburst)
> +{
> +	if (maxburst == 1 || maxburst > 16)
> +		return 0;
are these valid configurations?

> +
> +	return fls(maxburst) - 1;
> +}
> +
> +static inline u8 convert_buswidth(enum dma_slave_buswidth addr_width)
> +{
> +	switch (addr_width) {
> +	case DMA_SLAVE_BUSWIDTH_2_BYTES:
> +		return 1;
> +	case DMA_SLAVE_BUSWIDTH_4_BYTES:
> +		return 2;
return (addr_width >> 1); ..??
since DMA_SLAVE_BUSWIDTH_2_BYTES is numeric 2 and DMA_SLAVE_BUSWIDTH_4_BYTES
numeric 4. 
> +	default:
> +		return 0;
error?

> +static inline void sun6i_dma_cfg_lli(struct sun6i_dma_lli *lli,
> +				     dma_addr_t src,
> +				     dma_addr_t dst, u32 len,
> +				     struct dma_slave_config *config)
> +{
> +	u32 src_width, dst_width, src_burst, dst_burst;
> +
> +	if (!config)
> +		return;
> +
> +	src_burst = convert_burst(config->src_maxburst);
> +	dst_burst = convert_burst(config->dst_maxburst);
> +
> +	src_width = convert_buswidth(config->src_addr_width);
> +	dst_width = convert_buswidth(config->dst_addr_width);
is 0 a valid case then?

> +
> +static int sun6i_dma_terminate_all(struct sun6i_vchan *vchan)
> +{
> +	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(vchan->vc.chan.device);
> +	struct sun6i_pchan *pchan = vchan->phy;
> +	unsigned long flags;
> +	LIST_HEAD(head);
> +
> +	spin_lock(&sdev->lock);
> +	list_del_init(&vchan->node);
> +	spin_unlock(&sdev->lock);
> +
> +	spin_lock_irqsave(&vchan->vc.lock, flags);
> +
> +	vchan_get_all_descriptors(&vchan->vc, &head);
> +
> +	if (pchan) {
> +		writel(DMA_CHAN_ENABLE_STOP, pchan->base + DMA_CHAN_ENABLE);
> +		writel(DMA_CHAN_PAUSE_RESUME, pchan->base + DMA_CHAN_PAUSE);
> +
> +		vchan->phy = NULL;
> +		pchan->vchan = NULL;
> +		pchan->desc = NULL;
> +		pchan->done = NULL;
> +	}
> +
> +	spin_unlock_irqrestore(&vchan->vc.lock, flags);
> +
> +	vchan_dma_desc_free_list(&vchan->vc, &head);

shouldn't you kill the tasklet as well here?

> +static inline void sun6i_dma_free(struct sun6i_dma_dev *sdc)
> +{
> +	int i;
> +
> +	for (i = 0; i < NR_MAX_VCHANS; i++) {
> +		struct sun6i_vchan *vchan = &sdc->vchans[i];
> +
> +		list_del(&vchan->vc.chan.device_node);
> +		tasklet_kill(&vchan->vc.task);
> +	}
> +
> +	tasklet_kill(&sdc->task);
This is again not good. see http://lwn.net/Articles/588457/
At this point HW can still generate interrupts or you can have irq running!

> +
> +static int sun6i_dma_probe(struct platform_device *pdev)
> +{
> +	struct sun6i_dma_dev *sdc;
> +	struct resource *res;
> +	struct clk *mux, *pll6;
> +	int irq;
> +	int ret, i;
> +
> +	sdc = devm_kzalloc(&pdev->dev, sizeof(*sdc), GFP_KERNEL);
> +	if (!sdc)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	sdc->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(sdc->base))
> +		return PTR_ERR(sdc->base);
> +
> +	irq = platform_get_irq(pdev, 0);
> +	ret = devm_request_irq(&pdev->dev, irq, sun6i_dma_interrupt, 0,
> +			       dev_name(&pdev->dev), sdc);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Cannot request IRQ\n");
> +		return ret;
> +	}
this is not good. You have registered for irq, so your irq handlers can be
invoked but you initialization is not complete yet.

-- 
~Vinod
