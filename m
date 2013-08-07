Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab3HGPOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:14:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41949 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756023Ab3HGPOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 11:14:06 -0400
Date: Wed, 7 Aug 2013 16:13:16 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "djbw@fb.com" <djbw@fb.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v8] dmaengine: Add MOXA ART DMA engine driver
Message-ID: <20130807151316.GH28558@e106331-lin.cambridge.arm.com>
References: <1375713457-5562-1-git-send-email-jonas.jensen@gmail.com>
 <1375792711-21853-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375792711-21853-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 01:38:31PM +0100, Jonas Jensen wrote:
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
>     Add test dummy DMA channels to MMC, prove the controller
>     has support for interchangeable channel numbers [0].
> 
>     Add new filter data struct, store dma_spec passed in xlate,
>     similar to proposed patch for omap/edma [1][2].
> 
>     [0] https://bitbucket.org/Kasreyn/linux-next/commits/2f17ac38c5d3af49bc0c559c429a351ddd40063d
>     [1] https://lkml.org/lkml/2013/8/1/750  "[PATCH] DMA: let filter functions of of_dma_simple_xlate possible check of_node"
>     [2] https://lkml.org/lkml/2013/3/11/203 "A proposal to check the device in generic way"
> 
>     Changes since v7:
> 
>     1. remove unnecessary loop in moxart_alloc_chan_resources()
>     2. remove unnecessary status check in moxart_tx_status()
>     3. check/handle dma_async_device_register() return value
>     4. check/handle devm_request_irq() return value
>     5. add and use filter data struct
>     6. check if channel device is the same as passed to
>        of_dma_controller_register()
>     7. add check if chan->device->dev->of_node is the same as
>        dma_spec->np (xlate)
>     8. support interchangeable channels, #dma-cells is now <1>
> 
>     device tree bindings document:
>     9. update description and example, change "#dma-cells" to "<1>"
> 
>     Applies to next-20130806
> 
>  .../devicetree/bindings/dma/moxa,moxart-dma.txt    |  19 +
>  drivers/dma/Kconfig                                |   7 +
>  drivers/dma/Makefile                               |   1 +
>  drivers/dma/moxart-dma.c                           | 614 +++++++++++++++++++++
>  4 files changed, 641 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
>  create mode 100644 drivers/dma/moxart-dma.c
> 
> diff --git a/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt b/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
> new file mode 100644
> index 0000000..69e7001
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/moxa,moxart-dma.txt
> @@ -0,0 +1,19 @@
> +MOXA ART DMA Controller
> +
> +See dma.txt first
> +
> +Required properties:
> +
> +- compatible : Must be "moxa,moxart-dma"
> +- reg :                Should contain registers location and length
> +- interrupts : Should contain the interrupt number
> +- #dma-cells : Should be 1, a single cell holding a line request number
> +
> +Example:
> +
> +       dma: dma@90500000 {
> +               compatible = "moxa,moxart-dma";
> +               reg = <0x90500000 0x1000>;
> +               interrupts = <24 0>;
> +               #dma-cells = <1>;
> +       };

The binding looks sensible to me now, but I have a couple of (hopefully
final) questions on the probe failure path.

[...]

> +
> +       ret = dma_async_device_register(&mdc->dma_slave);
> +       if (ret) {
> +               dev_err(dev, "dma_async_device_register failed\n");
> +               return ret;
> +       }
> +
> +       ret = of_dma_controller_register(node, moxart_of_xlate, mdc);
> +       if (ret) {
> +               dev_err(dev, "of_dma_controller_register failed\n");
> +               dma_async_device_unregister(&mdc->dma_slave);
> +               return ret;
> +       }
> +
> +       platform_set_drvdata(pdev, mdc);
> +
> +       tasklet_init(&mdc->tasklet, moxart_dma_tasklet, (unsigned long)mdc);
> +
> +       ret = devm_request_irq(dev, irq, moxart_dma_interrupt, 0,
> +                              "moxart-dma-engine", mdc);
> +       if (ret) {
> +               dev_err(dev, "devm_request_irq failed\n");

Do you not need calls to of_dma_controller_free and
dma_async_device_unregister here? I'm not all that familiar with the DMA
API, so maybe you don't.

> +               return ret;
> +       }
> +
> +       dev_dbg(dev, "%s: IRQ=%u\n", __func__, irq);
> +
> +       return 0;
> +}
> +
> +static int moxart_remove(struct platform_device *pdev)
> +{
> +       struct moxart_dma_container *m = dev_get_drvdata(&pdev->dev);

Similarly, do you not need to call of_dma_controller free here?

> +       dma_async_device_unregister(&m->dma_slave);
> +       return 0;
> +}

Thanks,
Mark.
