Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaJROZg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 10:25:36 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:59726 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaJROZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 10:25:32 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v4 00/13] Add ACPI _DSD and unified device
 =?iso-8859-1?Q?properties=0D?= support
To: David Woodhouse <dwmw2@infradead.org>,
        Darren Hart <dvhart@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "dvhart@infradead.org" <dvhart@infradead.org>
In-Reply-To: <1413471356.2762.81.camel@infradead.org>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
	<1413378271.2762.77.camel@infradead.org>
	<20141015131551.GC20034@leverpostej>
	<1413379736.2762.79.camel@infradead.org>
	<20141015134209.GD20034@leverpostej>
	<db4038336b5e165b8b61eda064b10eeb.squirrel@twosheds.infradead.org>
	<543E88CF.5060504@linux.intel.com> <20141015151702.GG20034@leverpostej>
	<543E9605.6020502@linux.intel.com>
	<1413471356.2762.81.camel@infradead.org>
Date: Sat, 18 Oct 2014 10:39:54 +0200
Message-Id: <20141018083954.13F35C4099B@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2014 16:55:56 +0200
, David Woodhouse <dwmw2@infradead.org>
 wrote:
> On Wed, 2014-10-15 at 17:43 +0200, Darren Hart wrote:
> > 
> > So my objection here is that by keeping the of_* terms in the driver we
> > are required to include of, although it does safely convert to returning
> > NULL if !CONFIG_OF I suppose.
> 
> New version removes everything but the of_match_id bits which we need to
> match ACPI devices too. Perhaps they ought to be renamed, but I'm not
> sure it's worth it.
> 
> This also removes the call to platform_get_resource(IORESOURCE_MEM) and
> fall back to platform_get_resource(IORESOURCE_IO) as discussed IRL with
> Rafael. I'm not sure it's much of an improvement, mind you :)
> 
> Still untested. I think it's OK to switch to platform_get_irq() and then
> drop the irq_dispose_mapping() call, right? The platform_device takes
> care of all of that for us?
> 
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index 26cec64..be95a4c 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -1094,14 +1094,14 @@ config SERIAL_NETX_CONSOLE
>  	  you can make it the console by answering Y to this option.
>  
>  config SERIAL_OF_PLATFORM
> -	tristate "Serial port on Open Firmware platform bus"
> -	depends on OF
> +	tristate "Serial port on firmware platform bus"
> +	depends on OF || ACPI
>  	depends on SERIAL_8250 || SERIAL_OF_PLATFORM_NWPSERIAL
>  	help
> -	  If you have a PowerPC based system that has serial ports
> -	  on a platform specific bus, you should enable this option.
> -	  Currently, only 8250 compatible ports are supported, but
> -	  others can easily be added.
> +	  If you have a system which advertises its serial ports through
> +	  devicetree or ACPI, you should enable this option. Currently
> +	  only 8250 compatible and NWP ports and are supported, but others
> +	  can easily be added.
>  
>  config SERIAL_OMAP
>  	tristate "OMAP serial port support"
> diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
> index 68d4455..cc6c99b 100644
> --- a/drivers/tty/serial/of_serial.c
> +++ b/drivers/tty/serial/of_serial.c
> @@ -14,8 +14,7 @@
>  #include <linux/delay.h>
>  #include <linux/serial_core.h>
>  #include <linux/serial_reg.h>
> -#include <linux/of_address.h>
> -#include <linux/of_irq.h>
> +#include <linux/property.h>
>  #include <linux/of_platform.h>
>  #include <linux/nwpserial.h>
>  #include <linux/clk.h>
> @@ -53,22 +52,22 @@ static inline void tegra_serial_handle_break(struct uart_port *port)
>  /*
>   * Fill a struct uart_port for a given device node
>   */
> -static int of_platform_serial_setup(struct platform_device *ofdev,
> +static int of_platform_serial_setup(struct platform_device *pdev,
>  			int type, struct uart_port *port,
>  			struct of_serial_info *info)
>  {
> -	struct resource resource;
> -	struct device_node *np = ofdev->dev.of_node;
>  	u32 clk, spd, prop;
> -	int ret;
> +	int iotype = -1;
> +	u32 res_start;
> +	int ret, i;
>  
>  	memset(port, 0, sizeof *port);
> -	if (of_property_read_u32(np, "clock-frequency", &clk)) {
> +	if (device_property_read_u32(&pdev->dev, "clock-frequency", &clk)) {
>  
>  		/* Get clk rate through clk driver if present */
> -		info->clk = clk_get(&ofdev->dev, NULL);
> +		info->clk = clk_get(&pdev->dev, NULL);
>  		if (IS_ERR(info->clk)) {
> -			dev_warn(&ofdev->dev,
> +			dev_warn(&pdev->dev,
>  				"clk or clock-frequency not defined\n");
>  			return PTR_ERR(info->clk);
>  		}
> @@ -77,57 +76,63 @@ static int of_platform_serial_setup(struct platform_device *ofdev,
>  		clk = clk_get_rate(info->clk);
>  	}
>  	/* If current-speed was set, then try not to change it. */
> -	if (of_property_read_u32(np, "current-speed", &spd) == 0)
> +	if (device_property_read_u32(&pdev->dev, "current-speed", &spd) == 0)
>  		port->custom_divisor = clk / (16 * spd);
>  
> -	ret = of_address_to_resource(np, 0, &resource);
> -	if (ret) {
> -		dev_warn(&ofdev->dev, "invalid address\n");
> +	/* Check for shifted address mapping */
> +	if (device_property_read_u32(&pdev->dev, "reg-offset", &prop) != 0)
> +		prop = 0;
> +
> +	for (i = 0; iotype == -1 && i < pdev->num_resources; i++) {
> +		struct resource *resource = &pdev->resource[i];
> +		if (resource_type(resource) == IORESOURCE_MEM) {
> +			iotype = UPIO_MEM;
> +			port->mapbase = res_start + prop;
> +		} else if (resource_type(resource) == IORESOURCE_IO) {
> +			iotype = UPIO_PORT;
> +			port->iobase = res_start + prop;
> +		}
> +
> +		res_start = resource->start;
> +	}
> +	if (iotype == -1) {
> +		dev_warn(&pdev->dev, "invalid address\n");
>  		goto out;
>  	}
>  
>  	spin_lock_init(&port->lock);
> -	port->mapbase = resource.start;
> -
> -	/* Check for shifted address mapping */
> -	if (of_property_read_u32(np, "reg-offset", &prop) == 0)
> -		port->mapbase += prop;
>  
>  	/* Check for registers offset within the devices address range */
> -	if (of_property_read_u32(np, "reg-shift", &prop) == 0)
> +	if (device_property_read_u32(&pdev->dev, "reg-shift", &prop) == 0)
>  		port->regshift = prop;
>  
>  	/* Check for fifo size */
> -	if (of_property_read_u32(np, "fifo-size", &prop) == 0)
> +	if (device_property_read_u32(&pdev->dev, "fifo-size", &prop) == 0)
>  		port->fifosize = prop;
>  
> -	port->irq = irq_of_parse_and_map(np, 0);
> -	port->iotype = UPIO_MEM;
> -	if (of_property_read_u32(np, "reg-io-width", &prop) == 0) {
> -		switch (prop) {
> -		case 1:
> -			port->iotype = UPIO_MEM;
> -			break;
> -		case 4:
> -			port->iotype = UPIO_MEM32;
> -			break;
> -		default:
> -			dev_warn(&ofdev->dev, "unsupported reg-io-width (%d)\n",
> +	port->irq = platform_get_irq(pdev, 0);
> +
> +	if (device_property_read_u32(&pdev->dev, "reg-io-width", &prop) == 0) {
> +		if (prop == 4 && iotype == UPIO_MEM) {
> +			iotype = UPIO_MEM32;
> +		} else {
> +			dev_warn(&pdev->dev, "unsupported reg-io-width (%d)\n",
>  				 prop);
>  			ret = -EINVAL;
>  			goto out;
>  		}
>  	}
>  
> +	port->iotype = iotype;
>  	port->type = type;
>  	port->uartclk = clk;
>  	port->flags = UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_IOREMAP
>  		| UPF_FIXED_PORT | UPF_FIXED_TYPE;
>  
> -	if (of_find_property(np, "no-loopback-test", NULL))
> +	if (!device_get_property(&pdev->dev, "no-loopback-test", NULL))
>  		port->flags |= UPF_SKIP_TEST;
>  
> -	port->dev = &ofdev->dev;
> +	port->dev = &pdev->dev;
>  
>  	if (type == PORT_TEGRA)
>  		port->handle_break = tegra_serial_handle_break;
> @@ -143,7 +148,7 @@ out:
>   * Try to register a serial port
>   */
>  static struct of_device_id of_platform_serial_table[];
> -static int of_platform_serial_probe(struct platform_device *ofdev)
> +static int of_platform_serial_probe(struct platform_device *pdev)

Nit: Separate patch please. The rename of ofdev to pdev is nothing more
than cleanup. It has no functional impact and just makes the patch
larger.

>  {
>  	const struct of_device_id *match;
>  	struct of_serial_info *info;
> @@ -151,11 +156,11 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
>  	int port_type;
>  	int ret;
>  
> -	match = of_match_device(of_platform_serial_table, &ofdev->dev);
> +	match = of_match_device(of_platform_serial_table, &pdev->dev);
>  	if (!match)
>  		return -EINVAL;
>  
> -	if (of_find_property(ofdev->dev.of_node, "used-by-rtas", NULL))
> +	if (!device_get_property(&pdev->dev, "used-by-rtas", NULL))
>  		return -EBUSY;
>  
>  	info = kmalloc(sizeof(*info), GFP_KERNEL);
> @@ -163,7 +168,7 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
>  		return -ENOMEM;
>  
>  	port_type = (unsigned long)match->data;
> -	ret = of_platform_serial_setup(ofdev, port_type, &port, info);
> +	ret = of_platform_serial_setup(pdev, port_type, &port, info);
>  	if (ret)
>  		goto out;
>  
> @@ -179,12 +184,10 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
>  		if (port.fifosize)
>  			port8250.capabilities = UART_CAP_FIFO;
>  
> -		if (of_property_read_bool(ofdev->dev.of_node,
> -					  "auto-flow-control"))
> +		if (!device_get_property(&pdev->dev, "auto-flow-control", NULL))
>  			port8250.capabilities |= UART_CAP_AFE;
>  
> -		if (of_property_read_bool(ofdev->dev.of_node,
> -					  "has-hw-flow-control"))
> +		if (!device_get_property(&pdev->dev, "has-hw-flow-control", NULL))
>  			port8250.port.flags |= UPF_HARD_FLOW;
>  
>  		ret = serial8250_register_8250_port(&port8250);
> @@ -199,7 +202,7 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
>  	default:
>  		/* need to add code for these */
>  	case PORT_UNKNOWN:
> -		dev_info(&ofdev->dev, "Unknown serial port found, ignored\n");
> +		dev_info(&pdev->dev, "Unknown serial port found, ignored\n");
>  		ret = -ENODEV;
>  		break;
>  	}
> @@ -208,20 +211,19 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
>  
>  	info->type = port_type;
>  	info->line = ret;
> -	platform_set_drvdata(ofdev, info);
> +	platform_set_drvdata(pdev, info);
>  	return 0;
>  out:
>  	kfree(info);
> -	irq_dispose_mapping(port.irq);
>  	return ret;
>  }
>  
>  /*
>   * Release a line
>   */
> -static int of_platform_serial_remove(struct platform_device *ofdev)
> +static int of_platform_serial_remove(struct platform_device *pdev)
>  {
> -	struct of_serial_info *info = platform_get_drvdata(ofdev);
> +	struct of_serial_info *info = platform_get_drvdata(pdev);
>  	switch (info->type) {
>  #ifdef CONFIG_SERIAL_8250
>  	case PORT_8250 ... PORT_MAX_8250:
> 
> 
> -- 
> David Woodhouse                            Open Source Technology Centre
> David.Woodhouse@intel.com                              Intel Corporation
Attachment: smime.p7s (application/x-pkcs7-signature)

