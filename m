Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758998Ab3KMPCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:02:22 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:49631 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab3KMPCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:02:20 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Florian Meier <florian.meier@koalo.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] dmaengine: Add support for BCM2835.
Date: Wed, 13 Nov 2013 16:02:16 +0100
Message-ID: <4133885.XyqaHYljiZ@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <527D1DDA.2040004@koalo.de>
References: <527D1DDA.2040004@koalo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

Most of technical issues have been already mentioned by Russell, but let
me also point those that I found. Please see my comments inline.

On Friday 08 of November 2013 18:22:34 Florian Meier wrote:
> Add support for DMA controller of BCM2835 as used in the Raspberry Pi.
> Currently it only supports cyclic DMA for serving the I2S driver.
> 
> Signed-off-by: Florian Meier <florian.meier@koalo.de>
> ---
>  arch/arm/boot/dts/bcm2835.dtsi |   22 +
>  drivers/dma/Kconfig            |    6 +
>  drivers/dma/Makefile           |    1 +
>  drivers/dma/bcm2835-dma.c      |  880 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 909 insertions(+)
>  create mode 100644 drivers/dma/bcm2835-dma.c
> 
> diff --git a/arch/arm/boot/dts/bcm2835.dtsi b/arch/arm/boot/dts/bcm2835.dtsi
> index 1e12aef..1514198 100644
> --- a/arch/arm/boot/dts/bcm2835.dtsi
> +++ b/arch/arm/boot/dts/bcm2835.dtsi
> @@ -103,6 +103,28 @@
>  			clocks = <&clk_mmc>;
>  			status = "disabled";
>  		};
> +
> +		dma: dma@7e007000 {
> +			compatible = "brcm,bcm2835-dma";
> +			reg = <0x7e007000 0xf00>;
> +			interrupts = <1 16
> +				      1 17
> +				      1 18
> +				      1 19
> +				      1 20
> +				      1 21
> +				      1 22
> +				      1 23
> +				      1 24
> +				      1 25
> +				      1 26
> +				      1 27
> +				      1 28>;
> +
> +			#dma-cells = <1>;
> +			dma-channels = <15>;   /* DMA channel 15 is not handled yet */

This should represent the real configuration of the hardware, regardless
of what the driver supports.

> +			dma-requests = <32>;
> +		};
>  	};
>  
>  	clocks {

This should be a separate patch, following the one adding the driver.

In addition, you are introducing a new device tree binding with this
patch, so you should document it in appropriate location under
Documentation/devicetree/bindings.

> diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
> new file mode 100644
> index 0000000..c3e53b3
> --- /dev/null
> +++ b/drivers/dma/bcm2835-dma.c
> @@ -0,0 +1,880 @@
[snip]
> +struct bcm2835_dma_cb {
> +	unsigned long info;
> +	unsigned long src;
> +	unsigned long dst;
> +	unsigned long length;
> +	unsigned long stride;
> +	unsigned long next;
> +	unsigned long pad[2];
> +};

Is unsigned long really what you want here, not some explicitly sized
types, such as u32 or uint32_t? This seems to be some kind of hardware
interface, so the latter sounds more reasonable to me.

[snip]
> +#if defined(CONFIG_OF)
> +static const struct of_device_id bcm2835_dma_of_match[] = {
> +	{
> +		.compatible = "brcm,bcm2835-dma",
> +	}

A dummy terminating entry is needed here.

> +};
> +MODULE_DEVICE_TABLE(of, bcm2835_dma_of_match);
> +#endif
> +
> +static int bcm2835_dma_probe(struct platform_device *pdev)
> +{
> +	struct bcm2835_dmadev *od;
> +	struct resource *dma_res = NULL;
> +	void __iomem *dma_base = NULL;
> +	int rc = 0;
> +	int i;
> +	struct resource *irq;
> +	int irq_resources;
> +
> +	od = devm_kzalloc(&pdev->dev, sizeof(*od), GFP_KERNEL);
> +	if (!od)
> +		return -ENOMEM;
> +
> +	dma_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	dma_base = devm_ioremap_resource(&pdev->dev, dma_res);
> +	if (IS_ERR(dma_base))
> +		return PTR_ERR(dma_base);
> +
> +	od->dma_base = dma_base;
> +	od->chans_available = BCM2835_DMA_CHANNEL_MASK;
> +
> +	dma_cap_set(DMA_SLAVE, od->ddev.cap_mask);
> +	dma_cap_set(DMA_CYCLIC, od->ddev.cap_mask);
> +	od->ddev.device_alloc_chan_resources = bcm2835_dma_alloc_chan_resources;
> +	od->ddev.device_free_chan_resources = bcm2835_dma_free_chan_resources;
> +	od->ddev.device_tx_status = bcm2835_dma_tx_status;
> +	od->ddev.device_issue_pending = bcm2835_dma_issue_pending;
> +	od->ddev.device_prep_dma_cyclic = bcm2835_dma_prep_dma_cyclic;
> +	od->ddev.device_control = bcm2835_dma_control;
> +	od->ddev.dev = &pdev->dev;
> +	INIT_LIST_HEAD(&od->ddev.channels);
> +	INIT_LIST_HEAD(&od->pending);
> +	spin_lock_init(&od->lock);
> +
> +	tasklet_init(&od->task, bcm2835_dma_sched, (unsigned long)od);

Just a question out of curiosity, as I don't really know much about the
DMA engine subsystem:

What is the reason to use tasklets here instead of, let's say, a workqueue?

> +
> +	irq_resources = 0;
> +
> +	for (i = 0; i < pdev->num_resources; i++) {
> +		if (IORESOURCE_IRQ == resource_type(&pdev->resource[i]))
> +			irq_resources++;
> +	}
> +
> +	od->dma_irq_numbers = devm_kzalloc(&pdev->dev,
> +			irq_resources*sizeof(int), GFP_KERNEL);
> +	if (!od)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < irq_resources; i++) {

You could call platform_get_irq() here and break out of the loop if it
fails with -ENXIO. Then the IRQ number could be passed to
bcm2835_dma_chan_init() and stored in per-channel struct. This way you
could remove the ugly IRQ counting code above and IRQ array allocation.

> +		rc = bcm2835_dma_chan_init(od, i);
> +		if (rc) {
> +			bcm2835_dma_free(od);
> +			return rc;
> +		}
> +
> +		irq = platform_get_resource(pdev, IORESOURCE_IRQ, i);

There is platform_get_irq() for reading IRQ resources specifically.

> +		if (!irq) {
> +			dev_err(&pdev->dev,
> +					"No IRQ resource for channel %i\n", i);
> +			return -ENODEV;
> +		}
> +		od->dma_irq_numbers[i] = irq->start;
> +	}
> +
> +	rc = dma_async_device_register(&od->ddev);

This should be called at the end of probe, to ensure that any potential
users can start generating requests to your DMA engine as soon as
it is registered.

> +	if (rc) {
> +		dev_err(&pdev->dev,
> +			"Failed to register slave DMA engine device: %d\n", rc);
> +		bcm2835_dma_free(od);
> +		return rc;
> +	}
> +
> +	platform_set_drvdata(pdev, od);
[snip]
> +
> +static const struct platform_device_info bcm2835_dma_dev_info = {
> +	.name = "bcm2835-dma",
> +	.id = -1,
> +	.dma_mask = DMA_BIT_MASK(32),
> +};

What's this?

> +
> +static int bcm2835_dma_init(void)
> +{
> +	int rc = platform_driver_register(&bcm2835_dma_driver);
> +	return rc;
> +}
> +subsys_initcall(bcm2835_dma_init);

Do you really need subsys_initcall here?

Best regards,
Tomasz

