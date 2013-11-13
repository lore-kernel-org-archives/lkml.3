Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759666Ab3KMSnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:43:25 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:37511 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654Ab3KMSnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:43:16 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Florian Meier <florian.meier@koalo.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree <devicetree@vger.kernel.org>, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv4] dmaengine: Add support for BCM2835
Date: Wed, 13 Nov 2013 19:43:13 +0100
Message-ID: <3722902.ByNK8Ptc5Y@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <5283BC93.1090801@koalo.de>
References: <5283BC93.1090801@koalo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

Seems like I accidentally replied to some old version of this patch.
Not sure how many of those comments were still relevant for V3, but
let me look at this version and see whether we can still improve things
a bit. Please see my comments inline.

On Wednesday 13 of November 2013 18:53:23 Florian Meier wrote:
> Add support for DMA controller of BCM2835 as used in the Raspberry Pi.
> Currently it only supports cyclic DMA.
> 
> Signed-off-by: Florian Meier <florian.meier@koalo.de>
> ---
> 
> Besides of many minor improvements (thanks to your helpful comments),
> this fourth version does the assignment of the virtual to the hardware
> channel already in probe. This simplifies things a lot
> (first of all the complex alloc_chan_resources is now gone).
> 
> Regarding the maximum segment size: 0x3FFFFFFF is the maximum possible
> DMA transfer length value and I have no evidence that the maximum
> segment size is smaller.
> 
>  .../devicetree/bindings/dma/bcm2835-dma.txt        |   59 ++
>  drivers/dma/Kconfig                                |    6 +
>  drivers/dma/Makefile                               |    1 +
>  drivers/dma/bcm2835-dma.c                          |  750 ++++++++++++++++++++
>  4 files changed, 816 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/bcm2835-dma.txt
>  create mode 100644 drivers/dma/bcm2835-dma.c
> 
> diff --git a/Documentation/devicetree/bindings/dma/bcm2835-dma.txt b/Documentation/devicetree/bindings/dma/bcm2835-dma.txt
> new file mode 100644
> index 0000000..bca5e84
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/bcm2835-dma.txt
> @@ -0,0 +1,59 @@
> +* BCM2835 DMA controller
> +
> +Required properties:
> +- compatible: Should be "brcm,bcm2835-dma".
> +- reg: Should contain DMA registers location and length.
> +- interrupts: Should contain the DMA interrupts associated
> +		to the DMA channels in ascending order.
> +		First cell is the IRQ bank.
> +		Second cell is the IRQ number.
> +- #dma-cells: Must be <1>, used to represent the number of integer cells in
> +		the dmas property of client devices.
> +- dma-channels: Maximum number of DMA channels available.
> +- dma-requests: Number of DMA Requests.

The two properties above do not seem to be used anywhere in the driver.

> +- brcm,dma-channel-mask: Bit mask representing the channels available.

What does the value of this property depend on? Could you describe the
structure of this DMA controller?

> +
> +Example:
> +
> +dma: dma@7e007000 {
> +	compatible = "brcm,bcm2835-dma";
> +	reg = <0x7e007000 0xf00>;
> +	interrupts = <1 16
> +		      1 17
> +		      1 18
> +		      1 19
> +		      1 20
> +		      1 21
> +		      1 22
> +		      1 23
> +		      1 24
> +		      1 25
> +		      1 26
> +		      1 27
> +		      1 28>;

There are 13 interrupts specified here, but...

> +
> +	#dma-cells = <1>;
> +	dma-channels = <16>;

...16 channels here...

> +	dma-requests = <32>;
> +	brcm,dma-channel-mask = <0x7f35>;

...and 11 set bits here. May I ask you to explain this to me, please?

[snip]
> diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
> new file mode 100644
> index 0000000..baf072e
> --- /dev/null
> +++ b/drivers/dma/bcm2835-dma.c
[snip]
> +static int bcm2835_dma_probe(struct platform_device *pdev)
> +{
> +	struct bcm2835_dmadev *od;
> +	struct resource *dma_res = NULL;
> +	void __iomem *dma_base = NULL;
> +	int rc = 0;
> +	int i = 0;
> +	int irq;
> +	uint32_t chans_available;
[snip]
> +	if (pdev->dev.of_node) {

Is this driver supposed to support non-DT based instantation (aka board
files)? If not, maybe it would be cleaner to simply check for
!pdev->dev.of_node at the beginning of probe and return an error?

> +		const void *chan_mask;
> +
> +		/* Device-tree DMA controller registration */
> +		rc = of_dma_controller_register(pdev->dev.of_node,
> +				bcm2835_dma_xlate, od);
> +		if (rc) {
> +			dev_err(&pdev->dev, "Failed to register DMA controller\n");
> +			dma_async_device_unregister(&od->ddev);
> +			bcm2835_dma_free(od);
> +			return rc;
> +		}
> +
> +		/* Request DMA channel mask from device tree */
> +		chan_mask = of_get_property(pdev->dev.of_node,
> +				"brcm,dma-channel-mask", NULL);
> +
> +		if (!chan_mask) {
> +			dev_err(&pdev->dev, "Failed to get channel mask\n");
> +			dma_async_device_unregister(&od->ddev);
> +			bcm2835_dma_free(od);
> +			return -EINVAL;
> +		}
> +
> +		chans_available = be32_to_cpup(chan_mask);

You can use of_property_read_u32(), which will do both of_get_property()
and be32_to_cpup() for you.

> +
> +		/* do not use the FIQ and BULK channels */
> +		chans_available &= ~0xD;

I'm clearly lacking the information about hardware here, but it would be
nice to hear what these channels are.

Otherwise, the driver looks pretty good.

Best regards,
Tomasz

