Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab3HEQ6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:58:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60591 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655Ab3HEQ6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:58:48 -0400
Date: Mon, 5 Aug 2013 17:57:55 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "djbw@fb.com" <djbw@fb.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v7] dmaengine: Add MOXA ART DMA engine driver
Message-ID: <20130805165755.GD13091@e106331-lin.cambridge.arm.com>
References: <1375450125-29767-1-git-send-email-jonas.jensen@gmail.com>
 <1375713457-5562-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375713457-5562-1-git-send-email-jonas.jensen@gmail.com>
Thread-Topic: [PATCH v7] dmaengine: Add MOXA ART DMA engine driver
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 03:37:37PM +0100, Jonas Jensen wrote:
> The MOXA ART SoC has a DMA controller capable of offloading expensive
> memory operations, such as large copies. This patch adds support for
> the controller including four channels. Two of these are used to
> handle MMC copy on the UC-7112-LX hardware. The remaining two can be
> used in a future audio driver or client application.
>
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> ---
>
> Notes:
>     Thanks for the replies.
>
>     Changes since v6:
>
>     1. move callback from interrupt context to tasklet
>     2. remove callback and callback_param, use those provided by tx_desc
>     3. don't rely on structs for register offsets
>     4. remove local bool "found" variable from moxart_alloc_chan_resources()
>     5. check return value of irq_of_parse_and_map
>     6. use devm_request_irq instead of setup_irq
>     7. elaborate commit message
>
>     device tree bindings document:
>     8. in the example, change "#dma-cells" to "<2>"
>
>     Applies to next-20130805
>
>  .../devicetree/bindings/dma/moxa,moxart-dma.txt    |  21 +
>  drivers/dma/Kconfig                                |   7 +
>  drivers/dma/Makefile                               |   1 +
>  drivers/dma/moxart-dma.c                           | 614 +++++++++++++++++++++
>  4 files changed, 643 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
>  create mode 100644 drivers/dma/moxart-dma.c
>
> diff --git a/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt b/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
> new file mode 100644
> index 0000000..5b9f82c
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
> +               #dma-cells = <2>;
> +       };

Thanks for the updates on this. :)

The binding and example look sensible to me; it would be nice if someone
familiar with the dma subsystem could check that this has the necessary
information.

[...]

> +static int moxart_alloc_chan_resources(struct dma_chan *chan)
> +{
> +       struct moxart_dma_chan *mchan = to_moxart_dma_chan(chan);
> +       int i;
> +
> +       for (i = 0; i < APB_DMA_MAX_CHANNEL; i++) {
> +               if (i == mchan->ch_num
> +                       && !mchan->allocated) {
> +                       dev_dbg(chan2dev(chan), "%s: allocating channel #%d\n",
> +                               __func__, mchan->ch_num);
> +                       mchan->allocated = true;
> +                       return 0;
> +               }
> +       }

Come to think of it, why do you need to iterate over all of the channels
to handle a particular channel number that you already know, and already
have the struct for?

I'm not familiar with the dma subsystem, and I couldn't spot when the
dma channel is actually assigned/selected prior to this.

[...]

> +static enum dma_status moxart_tx_status(struct dma_chan *chan,
> +                                       dma_cookie_t cookie,
> +                                       struct dma_tx_state *txstate)
> +{
> +       enum dma_status ret;
> +
> +       ret = dma_cookie_status(chan, cookie, txstate);
> +       if (ret == DMA_SUCCESS || !txstate)
> +               return ret;
> +
> +       return ret;

No special status handling?

This function is equivalent to:

        return dma_cookie_status(chan, cookie, txstate);

[...]

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
> +       if (irq <= 0) {
> +               dev_err(dev, "irq_of_parse_and_map failed\n");
> +               return -EINVAL;
> +       }
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
> +               mchan->base = dma_base_addr + 0x80 + i * REG_CHAN_SIZE;
> +               mchan->allocated = 0;
> +
> +               dma_cookie_init(&mchan->chan);
> +               mchan->chan.device = &mdc->dma_slave;
> +               list_add_tail(&mchan->chan.device_node,
> +                             &mdc->dma_slave.channels);
> +
> +               dev_dbg(dev, "%s: mchans[%d]: mchan->ch_num=%d mchan->base=%p\n",
> +                       __func__, i, mchan->ch_num, mchan->base);
> +       }
> +
> +       ret = dma_async_device_register(&mdc->dma_slave);

What if this fails?

> +       platform_set_drvdata(pdev, mdc);
> +
> +       of_dma_controller_register(node, moxart_of_xlate, &moxart_dma_info);
> +
> +       tasklet_init(&mdc->tasklet, moxart_dma_tasklet, (unsigned long)mdc);
> +
> +       devm_request_irq(dev, irq, moxart_dma_interrupt, 0,
> +                        "moxart-dma-engine", mdc);

The return value of devm_request_irq should be checked; it might fail.

> +
> +       dev_dbg(dev, "%s: IRQ=%d\n", __func__, irq);
> +
> +       return ret;
> +}

Thanks,
Mark.
