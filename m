Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab3KROmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:42:39 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52874 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141Ab3KROmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:42:31 -0500
Date: Mon, 18 Nov 2013 14:41:55 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Florian Meier <florian.meier@koalo.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv7] dmaengine: Add support for BCM2835
Message-ID: <20131118144155.GJ30853@e106331-lin.cambridge.arm.com>
References: <5288E327.8050809@koalo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5288E327.8050809@koalo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 03:39:19PM +0000, Florian Meier wrote:
> Add support for DMA controller of BCM2835 as used in the Raspberry Pi.
> Currently it only supports cyclic DMA.
> 
> Signed-off-by: Florian Meier <florian.meier@koalo.de>
> ---
> 
> This version includes some more style improvements
> suggested in the previous thread.
> 
>  .../devicetree/bindings/dma/bcm2835-dma.txt        |   56 ++
>  drivers/dma/Kconfig                                |    6 +
>  drivers/dma/Makefile                               |    1 +
>  drivers/dma/bcm2835-dma.c                          |  736 ++++++++++++++++++++
>  4 files changed, 799 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/bcm2835-dma.txt
>  create mode 100644 drivers/dma/bcm2835-dma.c
> 
> diff --git a/Documentation/devicetree/bindings/dma/bcm2835-dma.txt b/Documentation/devicetree/bindings/dma/bcm2835-dma.txt
> new file mode 100644
> index 0000000..7d91019
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/bcm2835-dma.txt
> @@ -0,0 +1,56 @@
> +* BCM2835 DMA controller
> +
> +Required properties:
> +- compatible: Should be "brcm,bcm2835-dma".
> +- reg: Should contain DMA registers location and length.
> +- interrupts: Should contain the DMA interrupts associated
> +               to the DMA channels in ascending order.
> +               First cell is the IRQ bank.
> +               Second cell is the IRQ number.

The format of the cells is a property of the interrupt parent, not of
the DMA controller. It shouldn't be described here.

> +- #dma-cells: Must be <1>, used to represent the number of integer cells in
> +               the dmas property of client devices.

A brief description of the set of sane values of the dma-specifier cell
would be better.

How many channels does the DMA controller have?

> +- brcm,dma-channel-mask: Bit mask representing the channels
> +                        not used by the firmware.

Which bits correspond to which channels?

How many channels are likely to be reserved out of how many in total?

Are they likely to be an arbitrary set, or some contiguous range?

> +
> +Example:
> +
> +dma: dma@7e007000 {
> +       compatible = "brcm,bcm2835-dma";
> +       reg = <0x7e007000 0xf00>;
> +       interrupts = <1 16
> +                     1 17
> +                     1 18
> +                     1 19
> +                     1 20
> +                     1 21
> +                     1 22
> +                     1 23
> +                     1 24
> +                     1 25
> +                     1 26
> +                     1 27
> +                     1 28>;

Please bracket these individually.

> +
> +       #dma-cells = <1>;
> +       brcm,dma-channel-mask = <0x7f35>;
> +};
> +
> +DMA clients connected to the BCM2835 DMA controller must use the format
> +described in the dma.txt file, using a two-cell specifier for each channel:
> +a phandle plus one integer cells.
> +The two cells in order are:
> +
> +1. A phandle pointing to the DMA controller.
> +2. The DREQ number.

This description is unnecessary, and technically wrong (the phandle
isn't part of the specifier, as the specifier goes with the phandle).

> +
> +Example:
> +
> +bcm2835_i2s: i2s@7e203000 {
> +       compatible = "brcm,bcm2835-i2s";
> +       reg = < 0x7e203000 0x20
> +               0x7e101098 0x02>;
> +
> +       dmas = <&dma 2
> +               &dma 3>;

Brackets please.

[...]

> +struct bcm2835_dma_cb {
> +       uint32_t info;
> +       uint32_t src;
> +       uint32_t dst;
> +       uint32_t length;
> +       uint32_t stride;
> +       uint32_t next;
> +       uint32_t pad[2];

s/uint32_t/u32/ here and elsewhere.

[...]

> +static void bcm2835_dma_start_desc(struct bcm2835_chan *c)
> +{
> +       struct virt_dma_desc *vd = vchan_next_desc(&c->vc);
> +       struct bcm2835_desc *d;
> +
> +       if (!vd) {
> +               c->desc = NULL;
> +               return;
> +       }
> +
> +       list_del(&vd->node);
> +
> +       c->desc = d = to_bcm2835_dma_desc(&vd->tx);
> +
> +       dsb();  /* ARM data synchronization (push) operation */

We all know what a dsb is. What you should explain is _why_ the dsb is
here. As this is sat under drivers, it would be nicer to use an
architecture generic barrier rather than dsb() directly.

> +
> +       writel(d->control_block_base_phys, c->chan_base + BCM2835_DMA_ADDR);
> +       writel(BCM2835_DMA_ACTIVE, c->chan_base + BCM2835_DMA_CS);
> +}
> +
> +static irqreturn_t bcm2835_dma_callback(int irq, void *data)
> +{
> +       struct bcm2835_chan *c = data;
> +       struct bcm2835_desc *d;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&c->vc.lock, flags);
> +
> +       /* Acknowledge interrupt */
> +       writel(BCM2835_DMA_INT, c->chan_base + BCM2835_DMA_CS);
> +
> +       d = c->desc;
> +
> +       if (d) {
> +               /* TODO Only works for cyclic DMA */
> +               vchan_cyclic_callback(&d->vd);
> +       }
> +
> +       /* Keep the DMA engine running */
> +       dsb(); /* ARM synchronization barrier */

Better explanation please.

> +       writel(BCM2835_DMA_ACTIVE, c->chan_base + BCM2835_DMA_CS);
> +
> +       spin_unlock_irqrestore(&c->vc.lock, flags);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static int bcm2835_dma_alloc_chan_resources(struct dma_chan *chan)
> +{
> +       struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
> +
> +       dev_dbg(c->vc.chan.device->dev,
> +                       "Allocating DMA channel %i\n", c->ch);

Why not %d? It's far more common...


[...]

> +       if (pdev->dev.of_node) {
> +               /* Request DMA channel mask from device tree */
> +               if (of_property_read_u32(pdev->dev.of_node,
> +                               "brcm,dma-channel-mask",
> +                               &chans_available)) {
> +                       dev_err(&pdev->dev, "Failed to get channel mask\n");
> +                       bcm2835_dma_free(od);
> +                       return -EINVAL;
> +               }

As of_property_read_u32 has an implicit check on np, you don't need to
first check pdev->dev.of_node.

> +       } else {
> +               dev_err(&pdev->dev, "Failed to get channel mask. No device tree.\n");
> +               bcm2835_dma_free(od);
> +               return -EINVAL;
> +       }
> +
> +       /* Do not use the FIQ and BULK channels */
> +       chans_available &= ~0xD;

A couple of #defines would be nice, along with an explanation as to
why...

Thanks,
Mark.
