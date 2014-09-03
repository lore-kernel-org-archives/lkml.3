Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbaICUDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:03:12 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53206 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544AbaICUDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:03:08 -0400
Date: Wed, 3 Sep 2014 22:03:02 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Weike Chen <alvin.chen@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Boon Leong Ong <boon.leong.ong@intel.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH 1/3] GPIO: gpio-dwapb: Enable platform driver binding to
 MFD driver
Message-ID: <20140903200302.GA7673@breakpoint.cc>
References: <1409161588-19417-1-git-send-email-alvin.chen@intel.com>
 <1409161588-19417-2-git-send-email-alvin.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409161588-19417-2-git-send-email-alvin.chen@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-27 10:46:26 [-0700], Weike Chen wrote:
> index 9de1515..8250a44 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -136,7 +136,6 @@ config GPIO_DWAPB
>  	tristate "Synopsys DesignWare APB GPIO driver"
>  	select GPIO_GENERIC
>  	select GENERIC_IRQ_CHIP
> -	depends on OF_GPIO

you need either OF_GPIO or PCI

>  	help
>  	  Say Y or M here to build support for the Synopsys DesignWare APB
>  	  GPIO block.
> diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
> index d6618a6..155a64b 100644
> --- a/drivers/gpio/gpio-dwapb.c
> +++ b/drivers/gpio/gpio-dwapb.c
> @@ -21,6 +21,7 @@
>  #include <linux/of_irq.h>
>  #include <linux/platform_device.h>
>  #include <linux/spinlock.h>
> +#include <linux/platform_data/gpio-dwapb.h>
>  
>  #define GPIO_SWPORTA_DR		0x00
>  #define GPIO_SWPORTA_DDR	0x04
> @@ -52,14 +53,15 @@ struct dwapb_gpio_port {
>  	struct bgpio_chip	bgc;
>  	bool			is_registered;
>  	struct dwapb_gpio	*gpio;
> +	struct dwapb_gpio_port_property *pp;
>  };
>  
>  struct dwapb_gpio {
>  	struct	device		*dev;
>  	void __iomem		*regs;
>  	struct dwapb_gpio_port	*ports;
> -	unsigned int		nr_ports;

you could keep this the way it is

>  	struct irq_domain	*domain;
> +	const struct dwapb_gpio_platform_data	*pdata;

and not making this a member of this struct. I've been going up and down
the source and I don't see the need to marry dwapb_gpio to
dwapb_gpio_platform_data. 
That dwapb_gpio_port_property thing has a long name. Could you just set
it up, pass it for registration and the free it? You can't free the
pdata for the non-OF tree but for the OF case you keep that struct
around for no reason.
You could safe some memory and use pdata directly for setup.

>  };
>  
>  static int dwapb_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
> @@ -207,22 +209,24 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
>  	return 0;
>  }
>  
> +static irqreturn_t dwapb_irq_handler_mfd(int irq, void *dev_id)
> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
> +
> +	dwapb_irq_handler(irq, desc);
> +
> +	return IRQ_HANDLED;

I suggest to teach dwapb_irq_handler() to return something that makes
you decide whether or not IRQ_HANDLED is the thing to do here. If
something goes crazy the core has no way of knowing and shutting you down.
Also invoking ->irq_eoi() _before_ your shared was invoked might not smart.
What you want is something like

 static u32 _dwapb_irq_handler(struct dwapb_gpio *gpio,  struct irq_chip *chip)
 {
         u32 irq_status = readl_relaxed(gpio->regs + GPIO_INTSTATUS);
	 u32 ret = irq_status;
 
         while (irq_status) {
                 int hwirq = fls(irq_status) - 1;
                 int gpio_irq = irq_find_mapping(gpio->domain, hwirq);
 
                 generic_handle_irq(gpio_irq);
                 irq_status &= ~BIT(hwirq);
 
                 if ((irq_get_trigger_type(gpio_irq) & IRQ_TYPE_SENSE_MASK)
                         == IRQ_TYPE_EDGE_BOTH)
                         dwapb_toggle_trigger(gpio, hwirq);
         }
	 return ret;
 }

 static void dwapb_irq_handler(u32 irq, struct irq_desc *desc)
 {
         struct dwapb_gpio *gpio = irq_get_handler_data(irq);
         struct irq_chip *chip = irq_desc_get_chip(desc);

	_dwapb_irq_handler(gpio, chip);
 
         if (chip->irq_eoi)
                 chip->irq_eoi(irq_desc_get_irq_data(desc));
 }

 static irqreturn_t dwapb_irq_handler_mfd(int irq, void *dev_id)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
	struct irq_chip *chip = irq_desc_get_chip(desc);
	int worked;
 
 	worked = dwapb_irq_handler(dev_id, chip);
	if (worked)
		return IRQ_HANDLED;
	else
		return IRQ_NONE;
 }

How about it?

> +
>  static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
>  				 struct dwapb_gpio_port *port)
>  {
>  	struct gpio_chip *gc = &port->bgc.gc;
> -	struct device_node *node =  gc->of_node;
> -	struct irq_chip_generic	*irq_gc;
> +	struct device_node *node = port->pp->node;
> +	struct irq_chip_generic	*irq_gc = NULL;
>  	unsigned int hwirq, ngpio = gc->ngpio;
>  	struct irq_chip_type *ct;
> -	int err, irq, i;
> -
> -	irq = irq_of_parse_and_map(node, 0);
> -	if (!irq) {
> -		dev_warn(gpio->dev, "no irq for bank %s\n",
> -			port->bgc.gc.of_node->full_name);
> -		return;
> -	}
> +	int err, i;
>  
>  	gpio->domain = irq_domain_add_linear(node, ngpio,
>  					     &irq_generic_chip_ops, gpio);
> @@ -269,8 +273,24 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
>  	irq_gc->chip_types[1].type = IRQ_TYPE_EDGE_BOTH;
>  	irq_gc->chip_types[1].handler = handle_edge_irq;
>  
> -	irq_set_chained_handler(irq, dwapb_irq_handler);
> -	irq_set_handler_data(irq, gpio);
> +	if (!port->pp->irq_shared) {
> +		irq_set_chained_handler(port->pp->irq, dwapb_irq_handler);
> +	} else {
> +		/*
> +		 * Request a shared IRQ since where MFD would have devices
> +		 * using the same irq pin
> +		 */
> +		err = devm_request_irq(gpio->dev, port->pp->irq,
> +				       dwapb_irq_handler_mfd,
> +				       IRQF_SHARED, "gpio-dwapb-mfd", gpio);
> +		if (err) {
> +			dev_err(gpio->dev, "error requesting IRQ\n");
> +			irq_domain_remove(gpio->domain);
> +			gpio->domain = NULL;
> +			return;
> +		}
> +	}
> +	irq_set_handler_data(port->pp->irq, gpio);

This does not look like it belongs here. It should only be used together
with irq_set_chained_handler() or am I missing here something?

>  
>  	for (hwirq = 0 ; hwirq < ngpio ; hwirq++)
>  		irq_create_mapping(gpio->domain, hwirq);
> @@ -296,57 +316,43 @@ static void dwapb_irq_teardown(struct dwapb_gpio *gpio)
>  }
>  
>  static int dwapb_gpio_add_port(struct dwapb_gpio *gpio,
> -			       struct device_node *port_np,
> +			       struct dwapb_gpio_port_property *pp,
>  			       unsigned int offs)
>  {
>  	struct dwapb_gpio_port *port;
> -	u32 port_idx, ngpio;
>  	void __iomem *dat, *set, *dirout;
>  	int err;
>  
> -	if (of_property_read_u32(port_np, "reg", &port_idx) ||
> -		port_idx >= DWAPB_MAX_PORTS) {
> -		dev_err(gpio->dev, "missing/invalid port index for %s\n",
> -			port_np->full_name);
> -		return -EINVAL;
> -	}
> -
>  	port = &gpio->ports[offs];
>  	port->gpio = gpio;
> +	port->pp   = pp;
>  
> -	if (of_property_read_u32(port_np, "snps,nr-gpios", &ngpio)) {
> -		dev_info(gpio->dev, "failed to get number of gpios for %s\n",
> -			 port_np->full_name);
> -		ngpio = 32;
> -	}
> -
> -	dat = gpio->regs + GPIO_EXT_PORTA + (port_idx * GPIO_EXT_PORT_SIZE);
> -	set = gpio->regs + GPIO_SWPORTA_DR + (port_idx * GPIO_SWPORT_DR_SIZE);
> +	dat = gpio->regs + GPIO_EXT_PORTA + (pp->idx * GPIO_EXT_PORT_SIZE);
> +	set = gpio->regs + GPIO_SWPORTA_DR + (pp->idx * GPIO_SWPORT_DR_SIZE);
>  	dirout = gpio->regs + GPIO_SWPORTA_DDR +
> -		(port_idx * GPIO_SWPORT_DDR_SIZE);
> +		(pp->idx * GPIO_SWPORT_DDR_SIZE);
>  
>  	err = bgpio_init(&port->bgc, gpio->dev, 4, dat, set, NULL, dirout,
>  			 NULL, false);
>  	if (err) {
>  		dev_err(gpio->dev, "failed to init gpio chip for %s\n",
> -			port_np->full_name);
> +			pp->name);
>  		return err;
>  	}
>  
> -	port->bgc.gc.ngpio = ngpio;
> -	port->bgc.gc.of_node = port_np;
> +	port->bgc.gc.ngpio = pp->ngpio;
> +	port->bgc.gc.base = pp->gpio_base;
>  
>  	/*
>  	 * Only port A can provide interrupts in all configurations of the IP.
>  	 */
So we had a port_idx check which was refered by the comment. Now we have
a comment and no check for it. You could do that loop over that array
here and keep that check.

> -	if (port_idx == 0 &&
> -	    of_property_read_bool(port_np, "interrupt-controller"))
> +	if (pp->irq)
>  		dwapb_configure_irqs(gpio, port);
>  
>  	err = gpiochip_add(&port->bgc.gc);
>  	if (err)
>  		dev_err(gpio->dev, "failed to register gpiochip for %s\n",
> -			port_np->full_name);
> +			pp->name);
>  	else
>  		port->is_registered = true;
>  
> @@ -357,30 +363,115 @@ static void dwapb_gpio_unregister(struct dwapb_gpio *gpio)
>  {
>  	unsigned int m;
>  
> -	for (m = 0; m < gpio->nr_ports; ++m)
> +	for (m = 0; m < gpio->pdata->nports; ++m)
>  		if (gpio->ports[m].is_registered)
>  			gpiochip_remove(&gpio->ports[m].bgc.gc);
>  }
>  
> +/*
> + * Handlers for alternative sources of platform_data
> + */

Those abvious comments…

> +
> +#ifdef CONFIG_OF_GPIO
> +/*
> + * Translate OpenFirmware node properties into platform_data
> + */
… are not really helping

> +static struct dwapb_gpio_platform_data *

Sebastian
