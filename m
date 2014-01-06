Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbaAFQWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:22:37 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65377 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754993AbaAFQWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:22:34 -0500
Date: Mon, 6 Jan 2014 16:22:18 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Andreas Larsson <andreas@gaisler.com>, Felipe Balbi <balbi@ti.com>
Cc: Robert Baldyga <r.baldyga@samsung.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "software@gaisler.com" <software@gaisler.com>
Subject: Re: [PATCH v6] usb: gadget: Add UDC driver for Aeroflex Gaisler
 GRUSBDC
Message-ID: <20140106162218.GF24664@e106331-lin.cambridge.arm.com>
References: <1387830349-12241-1-git-send-email-andreas@gaisler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387830349-12241-1-git-send-email-andreas@gaisler.com>
Thread-Topic: [PATCH v6] usb: gadget: Add UDC driver for Aeroflex Gaisler
 GRUSBDC
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Apologies for the late reply, I wasn't able to access my mail much over
the Christmas break.

On Mon, Dec 23, 2013 at 08:25:49PM +0000, Andreas Larsson wrote:
> This adds an UDC driver for GRUSBDC USB Device Controller cores available in the
> GRLIB VHDL IP core library. The driver only supports DMA mode.
>
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> ---
>
> Differences since v1:
> - Use hexprint for debug printoutes instead of homemade equivalent
> - Use the dev_* printk variants over the board
> - Get rid of unnecessary casts and includes
> - Use USB_STATE_NOTATTACHED instead of USB_STATE_ATTACHED for clarity
> - Get rid of commented out VERBOSE_DEBUG definition
> - Do not devm-allocate any requests
> - Get rid of unnecessary resqueduling of the workqueue handler
> - Make sure that gadget setup function is called with interrupts disabled
> Differences since v2:
> - Fixed an error printout
> - Got rid of the work queue in favor of threaded interrupts
> Differences since v3:
> - Disable interrupts when locking spinlocks instead of using
>   local_irq_save deeper within critical section
> Differences since v4:
> - Set quirk_ep_out_aligned_size
> - Use usb_ep_set_maxpacket_limit
> - Add devicetree documentation
> Differences since v5:
> - Declare unexpected spin_unlock and spin_lock for sparse
> - Fix a bad comment
> - Use ACCESS_ONCE instead of gr_read32 when checking for update of dma descriptor
>
>  Documentation/devicetree/bindings/usb/gr-udc.txt |   28 +
>  drivers/usb/gadget/Kconfig                       |    7 +
>  drivers/usb/gadget/Makefile                      |    1 +
>  drivers/usb/gadget/gr_udc.c                      | 2242 ++++++++++++++++++++++
>  drivers/usb/gadget/gr_udc.h                      |  220 +++
>  5 files changed, 2498 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/usb/gr-udc.txt
>  create mode 100644 drivers/usb/gadget/gr_udc.c
>  create mode 100644 drivers/usb/gadget/gr_udc.h
>
> diff --git a/Documentation/devicetree/bindings/usb/gr-udc.txt b/Documentation/devicetree/bindings/usb/gr-udc.txt
> new file mode 100644
> index 0000000..0c5118f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/gr-udc.txt
> @@ -0,0 +1,28 @@
> +USB Peripheral Controller driver for Aeroflex Gaisler GRUSBDC.
> +
> +The GRUSBDC USB Device Controller core is available in the GRLIB VHDL
> +IP core library.
> +
> +Note: In the ordinary environment for the core, a Leon SPARC system,
> +these properties are built from information in the AMBA plug&play.
> +
> +Required properties:
> +
> +- name : Should be "GAISLER_USBDC" or "01_021"

What's this for?

Why is this not matched using a compatible string?

What does "01_021" mean?

> +
> +- reg : Address and length of the register set for the device
> +
> +- interrupts : Interrupt numbers for this device

How many, and what do they correspond to?

> +
> +Optional properties:
> +
> +- epobufsizes : An array of buffer sizes for OUT endpoints. If the property is
> +       not present, or for endpoints outside of the array, 1024 is assumed by
> +       the driver.
> +
> +- epibufsizes : An array of buffer sizes for IN endpoints. If the property is
> +       not present, or for endpoints outside of the array, 1024 is assumed by
> +       the driver.

These names are rather opaque. Something like {input,output}-buf-lens
would be far clearer.

How many entries are expected?

A specific driver should have no relevance to the binding. Just say "if
not 1024".

[...]

> +/* Must be called with dev->lock held */
> +static int gr_udc_init(struct gr_udc *dev)
> +{
> +       struct device_node *np = dev->dev->of_node;
> +       u32 epctrl_val;
> +       u32 dmactrl_val;
> +       int i;
> +       int ret = 0;
> +       u32 *bufsizes;
> +       u32 bufsize;
> +       int len;
> +
> +       gr_set_address(dev, 0);
> +
> +       INIT_LIST_HEAD(&dev->gadget.ep_list);
> +       dev->gadget.speed = USB_SPEED_UNKNOWN;
> +       dev->gadget.ep0 = &dev->epi[0].ep;
> +
> +       INIT_LIST_HEAD(&dev->ep_list);
> +       gr_set_ep0state(dev, GR_EP0_DISCONNECT);
> +
> +       bufsizes = (u32 *)of_get_property(np, "epobufsizes", &len);

of_get_property gives you the raw property value bye string, which is
_not_ a u32 pointer -- it's not necessarily the same endianness as the
kernel. Please use an appropriate accessor.

> +       len /= sizeof(u32);
> +       for (i = 0; i < dev->nepo; i++) {
> +               bufsize = (bufsizes && i < len) ? bufsizes[i] : 1024;

You can use of_property_read_u32_index within the loop for this:

                if (of_property_read_u32_index(np, "epobufsizes", &bufsize)
                        bufsize = 1024;

> +               ret = gr_ep_init(dev, i, 0, bufsize);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       bufsizes = (u32 *)of_get_property(np, "epibufsizes", &len);
> +       len /= sizeof(u32);
> +       for (i = 0; i < dev->nepi; i++) {
> +               bufsize = (bufsizes && i < len) ? bufsizes[i] : 1024;

Likewise here.

[...]

> +static int gr_probe(struct platform_device *ofdev)
> +{
> +       struct gr_udc *dev;
> +       struct resource *res;
> +       struct gr_regs __iomem *regs;
> +       int retval;
> +       u32 status;
> +
> +       dev = devm_kzalloc(&ofdev->dev, sizeof(*dev), GFP_KERNEL);
> +       if (!dev)
> +               return -ENOMEM;
> +       dev->dev = &ofdev->dev;
> +
> +       res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
> +       regs = devm_ioremap_resource(dev->dev, res);
> +       if (IS_ERR(regs))
> +               return PTR_ERR(regs);
> +
> +       dev->irq = irq_of_parse_and_map(dev->dev->of_node, 0);
> +       if (!dev->irq) {
> +               dev_err(dev->dev, "No irq found\n");
> +               return -ENODEV;
> +       }

The platform_device probing code will have parsed and mapped the irq
already. You can use platform_get_irq(ofdev->dev, 0) here.

Also, naming the platform_device ofdev is confusing. It has nothing to
do with OF, and the more common pdev name would be far clearer.

> +
> +       /* Some core configurations has separate irqs for IN and OUT events */
> +       dev->irqi = irq_of_parse_and_map(dev->dev->of_node, 1);
> +       if (dev->irqi) {
> +               dev->irqo = irq_of_parse_and_map(dev->dev->of_node, 2);
> +               if (!dev->irqo) {
> +                       dev_err(dev->dev, "Found irqi but not irqo\n");
> +                       return -ENODEV;
> +               }
> +       }

Likewise here you can use platform_get_irq.

[...]

> +static struct of_device_id gr_match[] = {
> +       {.name = "GAISLER_USBDC"},
> +       {.name = "01_021"},
> +       {},

This seems extremely odd to me. I think a compatible string would be far
preferable.

Thanks,
Mark.
