Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419AbaIDCA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 22:00:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:43100 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbaIDCA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 22:00:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,462,1406617200"; 
   d="scan'208";a="597640715"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Darren Hart <dvhart@linux.intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: RE: [PATCH 1/3] GPIO: gpio-dwapb: Enable platform driver binding to
 MFD driver
Thread-Topic: [PATCH 1/3] GPIO: gpio-dwapb: Enable platform driver binding
 to MFD driver
Thread-Index: AQHPx7IeGXSX4urFPUSWYL9l2BIkHZvwKfyA
Date: Thu, 4 Sep 2014 02:00:03 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E982384@SHSMSX101.ccr.corp.intel.com>
References: <1409161588-19417-1-git-send-email-alvin.chen@intel.com>
 <1409161588-19417-2-git-send-email-alvin.chen@intel.com>
 <20140903200302.GA7673@breakpoint.cc>
In-Reply-To: <20140903200302.GA7673@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8420bRI006926

> 
> > --- a/drivers/gpio/Kconfig
> > +++ b/drivers/gpio/Kconfig
> > @@ -136,7 +136,6 @@ config GPIO_DWAPB
> >  	tristate "Synopsys DesignWare APB GPIO driver"
> >  	select GPIO_GENERIC
> >  	select GENERIC_IRQ_CHIP
> > -	depends on OF_GPIO
> you need either OF_GPIO or PCI
Since we enable this module not only support OF devices, but also support MFD devices, so we remove OF_GPIO dependency.
For 'PCI', the original code is also not depended on PCI, and this patch also not, do you think it is necessary?

> >
> >  struct dwapb_gpio {
> >  	struct	device		*dev;
> >  	void __iomem		*regs;
> >  	struct dwapb_gpio_port	*ports;
> > -	unsigned int		nr_ports;
> you could keep this the way it is
It has been moved to 'pdata'.

> >  	struct irq_domain	*domain;
> > +	const struct dwapb_gpio_platform_data	*pdata;
> 
> and not making this a member of this struct. I've been going up and down the
> source and I don't see the need to marry dwapb_gpio to
> dwapb_gpio_platform_data.
> That dwapb_gpio_port_property thing has a long name. Could you just set it up,
> pass it for registration and the free it? You can't free the pdata for the non-OF
> tree but for the OF case you keep that struct around for no reason.
> You could safe some memory and use pdata directly for setup.
Here, 'pdata' is used for both OF and MFD. For MFD, 'pdata' is passed from MFD.
For OF, 'pdata' is getting from device nodes properties. Why do we have such design? Because it can make the handling
more easy for flowing routine. All necessary properties get from 'pdata', never care it is from OF or MFD. And someone
are working on replacing OF interface with a firmware agnostic device_property* interface which will work with both OF and ACPI.
More information for this design, please contact Darren Hart <dvhart@linux.intel.com>. Darren Hart wrote to me:
"Generally speaking, rather than if/else blocks throughout the code checking if it is enumerated via open firmware or as a platform device,
a cleaner approach is to check if the pdata is null, and if so, populate the pdata from the open firmware description if present.
Then use the pdata throughout the driver.

Something to keep in mind is that we are working to replace the of_* interface with a firmware agnostic device_property* interface
which will work with both OF and ACPI. Patches to hit LKML this week for the acpi and driver core. 
Organizing the code as described above will better encapsulate the firmware-config logic and make it easier to update."

And you can also refer the code 'driver/input/keyboard/gpio_keys.c', and this patch takes it as an example.


> >  };
> >
> >  static int dwapb_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
> > @@ -207,22 +209,24 @@ static int dwapb_irq_set_type(struct irq_data *d,
> u32 type)
> >  	return 0;
> >  }
> >
> > +static irqreturn_t dwapb_irq_handler_mfd(int irq, void *dev_id) {
> > +	struct irq_desc *desc = irq_to_desc(irq);
> > +
> > +	dwapb_irq_handler(irq, desc);
> > +
> > +	return IRQ_HANDLED;
> 
> I suggest to teach dwapb_irq_handler() to return something that makes you
> decide whether or not IRQ_HANDLED is the thing to do here. If something goes
> crazy the core has no way of knowing and shutting you down.
> Also invoking ->irq_eoi() _before_ your shared was invoked might not smart.
> What you want is something like
> 
>  static u32 _dwapb_irq_handler(struct dwapb_gpio *gpio,  struct irq_chip
> *chip)  {
>          u32 irq_status = readl_relaxed(gpio->regs + GPIO_INTSTATUS);
> 	 u32 ret = irq_status;
> 
>          while (irq_status) {
>                  int hwirq = fls(irq_status) - 1;
>                  int gpio_irq = irq_find_mapping(gpio->domain, hwirq);
> 
>                  generic_handle_irq(gpio_irq);
>                  irq_status &= ~BIT(hwirq);
> 
>                  if ((irq_get_trigger_type(gpio_irq) &
> IRQ_TYPE_SENSE_MASK)
>                          == IRQ_TYPE_EDGE_BOTH)
>                          dwapb_toggle_trigger(gpio, hwirq);
>          }
> 	 return ret;
>  }
> 
>  static void dwapb_irq_handler(u32 irq, struct irq_desc *desc)  {
>          struct dwapb_gpio *gpio = irq_get_handler_data(irq);
>          struct irq_chip *chip = irq_desc_get_chip(desc);
> 
> 	_dwapb_irq_handler(gpio, chip);
> 
>          if (chip->irq_eoi)
>                  chip->irq_eoi(irq_desc_get_irq_data(desc));
>  }
> 
>  static irqreturn_t dwapb_irq_handler_mfd(int irq, void *dev_id)  {
>  	struct irq_desc *desc = irq_to_desc(irq);
> 	struct irq_chip *chip = irq_desc_get_chip(desc);
> 	int worked;
> 
>  	worked = dwapb_irq_handler(dev_id, chip);
> 	if (worked)
> 		return IRQ_HANDLED;
> 	else
> 		return IRQ_NONE;
>  }
> 
> How about it?
OK, I will improve it as your suggestion.


> > +	irq_set_handler_data(port->pp->irq, gpio);
> 
> This does not look like it belongs here. It should only be used together with
> irq_set_chained_handler() or am I missing here something?
This patch reused ' dwapb_irq_handler', it needs the irq handler data. For ' irq_set_handler_data', it just sets the irq data.
Why do you think it must be used together with ' irq_set_chained_handler'?

> >  	/*
> >  	 * Only port A can provide interrupts in all configurations of the IP.
> >  	 */
> So we had a port_idx check which was refered by the comment. Now we have a
> comment and no check for it. You could do that loop over that array here and
> keep that check.
Let me move it to 'dwapb_gpio_get_pdata_of'.

> >
> > +/*
> > + * Handlers for alternative sources of platform_data  */
> 
> Those abvious commentsâ€¦
> 
> > +
> > +#ifdef CONFIG_OF_GPIO
> > +/*
> > + * Translate OpenFirmware node properties into platform_data  */
> â€¦ are not really helping
Let me remove them.

> > +static struct dwapb_gpio_platform_data *
> 
> Sebastian
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
