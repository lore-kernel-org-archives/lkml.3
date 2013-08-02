Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab3HBOKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:10:55 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33452 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976Ab3HBOKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:10:39 -0400
Date: Fri, 2 Aug 2013 15:09:51 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>, "djbw@fb.com" <djbw@fb.com>
Subject: Re: [PATCH v6] dmaengine: Add MOXA ART DMA engine driver
Message-ID: <20130802140951.GP2884@e106331-lin.cambridge.arm.com>
References: <1375445018-20713-1-git-send-email-jonas.jensen@gmail.com>
 <1375450125-29767-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375450125-29767-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 02:28:45PM +0100, Jonas Jensen wrote:
> Add dmaengine driver for MOXA ART SoCs.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
> 
> Notes:
>     Preemptively submitting a new version that has the previously
>     mentioned two cell xlate.
> 
>     Changes since v5:
> 
>     1. add line request number and use two cell xlate
> 
>     device tree bindings document:
>     2. update description, describe the two cells of #dma-cells
> 
>     Applies to next-20130802
> 
>  .../devicetree/bindings/dma/moxa,moxart-dma.txt    |  21 +
>  drivers/dma/Kconfig                                |   7 +
>  drivers/dma/Makefile                               |   1 +
>  drivers/dma/moxart-dma.c                           | 610 +++++++++++++++++++++
>  4 files changed, 639 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
>  create mode 100644 drivers/dma/moxart-dma.c
> 
> diff --git a/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt b/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
> new file mode 100644
> index 0000000..dc2b686
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
> @@ -0,0 +1,21 @@
> +MOXA ART DMA Controller
> +
> +See dma.txt first
> +
> +Required properties:
> +
> +- compatible : Must be "moxa,moxart-dma"
> +- reg :                Should contain registers location and length
> +- interrupts : Should contain the interrupt number
> +- #dma-cells : Should be 2
> +               cell index 0: channel number between 0-3
> +               cell index 1: line request number
> +
> +Example:
> +
> +       dma: dma@90500000 {
> +               compatible = "moxa,moxart-dma";
> +               reg = <0x90500000 0x1000>;
> +               interrupts = <24 0>;
> +               #dma-cells = <1>;

This should be #dma-cells = <2>;

[...]

> +struct moxart_dma_reg {
> +       u32 source_addr;
> +       u32 dest_addr;
> +#define APB_DMA_CYCLES_MASK                    0x00ffffff
> +       u32 cycles;     /* depend on burst mode */
> +       u32 ctrl;
> +};

I'm not keen on relying on structs for register offsets, but at least
they're exact width u32s.

[...]

> +static int moxart_alloc_chan_resources(struct dma_chan *chan)
> +{
> +       struct moxart_dma_chan *mchan = to_moxart_dma_chan(chan);
> +       int i;
> +       bool found = false;
> +
> +       for (i = 0; i < APB_DMA_MAX_CHANNEL; i++) {
> +               if (i == mchan->ch_num
> +                       && !mchan->allocated) {
> +                       dev_dbg(chan2dev(chan), "%s: allocating channel #%d\n",
> +                               __func__, mchan->ch_num);
> +                       mchan->allocated = true;
> +                       found = true;

Why not return 0 here...

> +                       break;
> +               }
> +       }


...and always return -ENODEV here?

That way you can also get rid of the found variable.

> +
> +       if (!found)
> +               return -ENODEV;
> +
> +       return 0;
> +}

[...]

> +static struct irqaction moxart_dma_irq = {
> +       .name       = "moxart-dma-engine",
> +       .flags      = IRQF_DISABLED,
> +       .handler    = moxart_dma_interrupt,
> +};
> +
> +static int moxart_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct device_node *node = dev->of_node;
> +       struct resource *res;
> +       static void __iomem *dma_base_addr;
> +       int ret, i;
> +       unsigned int irq;
> +       struct moxart_dma_chan *mchan;
> +       struct moxart_dma_container *mdc;
> +
> +       mdc = devm_kzalloc(dev, sizeof(*mdc), GFP_KERNEL);
> +       if (!mdc) {
> +               dev_err(dev, "can't allocate DMA container\n");
> +               return -ENOMEM;
> +       }
> +
> +       irq = irq_of_parse_and_map(node, 0);

What if this fails (where irq == 0)?.

> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       dma_base_addr = devm_ioremap_resource(dev, res);
> +       if (IS_ERR(dma_base_addr)) {
> +               dev_err(dev, "devm_ioremap_resource failed\n");
> +               return PTR_ERR(dma_base_addr);
> +       }
> +
> +       mdc->ctlr = pdev->id;
> +       spin_lock_init(&mdc->dma_lock);
> +
> +       dma_cap_zero(mdc->dma_slave.cap_mask);
> +       dma_cap_set(DMA_SLAVE, mdc->dma_slave.cap_mask);
> +
> +       moxart_dma_init(&mdc->dma_slave, dev);
> +
> +       mchan = &mdc->slave_chans[0];
> +       for (i = 0; i < APB_DMA_MAX_CHANNEL; i++, mchan++) {
> +               mchan->ch_num = i;
> +               mchan->reg = (struct moxart_dma_reg *)(dma_base_addr + 0x80
> +                            + i * sizeof(struct moxart_dma_reg));
> +               mchan->callback = NULL;
> +               mchan->allocated = 0;
> +               mchan->callback_param = NULL;
> +
> +               dma_cookie_init(&mchan->chan);
> +               mchan->chan.device = &mdc->dma_slave;
> +               list_add_tail(&mchan->chan.device_node,
> +                             &mdc->dma_slave.channels);
> +
> +               dev_dbg(dev, "%s: mchans[%d]: mchan->ch_num=%d mchan->reg=%p\n",
> +                       __func__, i, mchan->ch_num, mchan->reg);
> +       }
> +
> +       ret = dma_async_device_register(&mdc->dma_slave);
> +       platform_set_drvdata(pdev, mdc);
> +
> +       of_dma_controller_register(node, moxart_of_xlate, &moxart_dma_info);
> +
> +       moxart_dma_irq.dev_id = &mdc->dma_slave;
> +       setup_irq(irq, &moxart_dma_irq);

What if this fails?

Is there any reason you can't use request_irq over setup_irq?

> +
> +       dev_dbg(dev, "%s: IRQ=%d\n", __func__, irq);
> +
> +       return ret;
> +}

Thanks,
Mark.
