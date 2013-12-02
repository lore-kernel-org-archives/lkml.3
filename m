Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab3LBIsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 03:48:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:37023 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab3LBIsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 03:48:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,809,1378882800"; 
   d="scan'208";a="445165987"
Date: Mon, 2 Dec 2013 10:48:45 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 05/11] serial: support for 16550 serial ports on LP-8x4x
Message-ID: <20131202084845.GD3942@xps8300>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
 <1385879185-22455-6-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385879185-22455-6-git-send-email-ynvich@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Dec 01, 2013 at 10:26:18AM +0400, Sergei Ianovich wrote:
> The patch adds support for 3 additional LP-8x4x built-in serial
> ports.
> 
> The device can also host up to 8 extension cards with 4 serial ports
> on each card for a total of 35 ports. However, I don't have
> the hardware to test extension cards, so they are not supported, yet.
> 
> Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
> ---
>  arch/arm/configs/lp8x4x_defconfig       |   1 +
>  arch/arm/mach-pxa/include/mach/lp8x4x.h |   6 ++
>  drivers/tty/serial/8250/8250_lp8x4x.c   | 181 ++++++++++++++++++++++++++++++++
>  drivers/tty/serial/8250/Kconfig         |  11 ++
>  drivers/tty/serial/8250/Makefile        |   1 +
>  5 files changed, 200 insertions(+)
>  create mode 100644 drivers/tty/serial/8250/8250_lp8x4x.c
> 
> diff --git a/arch/arm/configs/lp8x4x_defconfig b/arch/arm/configs/lp8x4x_defconfig
> index 03c85bc..d297a67 100644
> --- a/arch/arm/configs/lp8x4x_defconfig
> +++ b/arch/arm/configs/lp8x4x_defconfig
> @@ -1141,6 +1141,7 @@ CONFIG_SERIAL_8250_NR_UARTS=36
>  CONFIG_SERIAL_8250_RUNTIME_UARTS=36
>  CONFIG_SERIAL_8250_EXTENDED=y
>  CONFIG_SERIAL_8250_MANY_PORTS=y
> +CONFIG_SERIAL_8250_LP8X4X=m
>  CONFIG_SERIAL_8250_SHARE_IRQ=y
>  # CONFIG_SERIAL_8250_DETECT_IRQ is not set
>  # CONFIG_SERIAL_8250_RSA is not set
> diff --git a/arch/arm/mach-pxa/include/mach/lp8x4x.h b/arch/arm/mach-pxa/include/mach/lp8x4x.h
> index a49df22..4d5474e 100644
> --- a/arch/arm/mach-pxa/include/mach/lp8x4x.h
> +++ b/arch/arm/mach-pxa/include/mach/lp8x4x.h
> @@ -50,6 +50,12 @@
>  #define LP8X4X_CLRFALLINT	LP8X4X_P2V(0x1700901a)
>  #define LP8X4X_RWRTC		LP8X4X_P2V(0x1700901c)
>  #define LP8X4X_SRAMBANK		0x1700901e
> +#define LP8X4X_TTYS0_QUIRK	0x17009030
> +#define LP8X4X_TTYS1_QUIRK	0x17009032
> +#define LP8X4X_TTYS2_QUIRK	0x17009034
> +#define LP8X4X_TTYS0_IOMEM	0x17009050
> +#define LP8X4X_TTYS1_IOMEM	0x17009060
> +#define LP8X4X_TTYS2_IOMEM	0x17009070
>  #define LP8X4X_SRAM		0x1700a000
>  
>  /* board specific IRQs */
> diff --git a/drivers/tty/serial/8250/8250_lp8x4x.c b/drivers/tty/serial/8250/8250_lp8x4x.c
> new file mode 100644
> index 0000000..27b01f0b
> --- /dev/null
> +++ b/drivers/tty/serial/8250/8250_lp8x4x.c
> @@ -0,0 +1,181 @@
> +/*  linux/drivers/tty/serial/8250/8250_lp8x4x.c
> + *
> + *  Support for 16550 serial ports on ICP DAS LP-8x4x
> + *
> + *  Copyright (C) 2013 Sergei Ianovich <ynvich@gmail.com>
> + *  Framework taken from linux/drivers/tty/serial/8250/8250_accent.c
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + */
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/irq.h>
> +#include <linux/delay.h>
> +#include <linux/serial_8250.h>
> +#include <mach/lp8x4x.h>
> +#include <linux/io.h>
> +
> +#define QUIRK_PORT(_base, _irq)					\
> +	{							\
> +		.iobase		= _base,			\
> +		.membase	= (void *) _base,		\
> +		.mapbase	= _base,			\
> +		.irq		= _irq,				\
> +		.uartclk	= 14745600,			\
> +		.regshift	= 1,				\
> +		.iotype		= UPIO_MEM,			\
> +		.flags		= UPF_IOREMAP,			\
> +		.set_termios	= lp8x4x_set_termios,		\
> +		.serial_in	= lp8x4x_serial_in,		\
> +		.serial_out	= lp8x4x_serial_out,		\
> +	}
> +
> +static void lp8x4x_set_termios(struct uart_port *port,
> +		struct ktermios *termios, struct ktermios *old)
> +{

<snip>

> +}
> +
> +static unsigned int lp8x4x_serial_in(struct uart_port *p, int offset)
> +{
> +	unsigned int b;
> +	udelay(30);
> +	offset = offset << p->regshift;
> +	b = readb(p->membase + offset);
> +	return b;
> +}
> +
> +static void lp8x4x_serial_out(struct uart_port *p, int offset, int value)
> +{
> +	offset = offset << p->regshift;
> +	writeb(value, p->membase + offset);
> +}
> +
> +static struct plat_serial8250_port lp8x4x_data[] = {
> +	QUIRK_PORT(LP8X4X_TTYS0_IOMEM, LP8X4X_TTYS0_IRQ),
> +	QUIRK_PORT(LP8X4X_TTYS1_IOMEM, LP8X4X_TTYS1_IRQ),
> +	QUIRK_PORT(LP8X4X_TTYS2_IOMEM, LP8X4X_TTYS2_IRQ),
> +	{ },
> +};
> +
> +/* Total number of ports can be 35. The first 3 ports are on
> + * the device, the rest are on extension slots. Only the first 3
> + * require termios quirk */
> +#define LP8X4X_QUIRK_PORTS	3
> +
> +static unsigned int extra_mem[LP8X4X_QUIRK_PORTS] = {
> +	LP8X4X_TTYS0_QUIRK,
> +	LP8X4X_TTYS1_QUIRK,
> +	LP8X4X_TTYS2_QUIRK
> +};
> +
> +static int request_and_remap(int i)
> +{
> +	if (!request_mem_region(extra_mem[i], 1, "serial"))
> +		return -EBUSY;
> +
> +	lp8x4x_data[i].private_data = ioremap(extra_mem[i], 1);
> +	if (lp8x4x_data[i].private_data)
> +		return 0;
> +
> +	release_mem_region(extra_mem[i], 1);
> +	return -ENODEV;
> +}
> +
> +static void release_and_unmap(int i)
> +{
> +	iounmap((void *) lp8x4x_data[i].private_data);
> +	release_mem_region(extra_mem[i], 1);
> +}
> +
> +static struct platform_device lp8x4x_device = {
> +	.name			= "serial8250",
> +	.id			= PLAT8250_DEV_ACCENT,
> +	.dev			= {
> +		.platform_data	= lp8x4x_data,
> +	},
> +};
> +
> +static int __init lp8x4x_init(void)
> +{
> +	int i = 0;
> +	int err = 0;
> +
> +	for (i = 0; i < LP8X4X_QUIRK_PORTS; i++) {
> +		err = request_and_remap(i);
> +		if (err == 0)
> +			continue;
> +
> +		for (; i >= 0; i--)
> +			release_and_unmap(i);
> +		lp8x4x_device.dev.platform_data = NULL;
> +		return err;
> +	}
> +	return platform_device_register(&lp8x4x_device);
> +}
> +
> +module_init(lp8x4x_init);

Instead of registering a platform device for serial8250 here, you need
to simply register a platform driver for something like lp8x4x_serial.
The platform code will to registers the platform devices for it. You
will use serial8250_register_8250_port() in your probe to register a
new port. Use 8250_em.c and 8250_dw.c under drivers/tty/serial/8250/
as an example.

You don't need to introduce plat_serial8250_port so you won't need
the QUIRK_PORT stuff. You deliver the iomem and the irq as normal
resources that the driver uses when you create the platform device.
That of course also means the driver does not need to care about the
instances. The platform code will generate a platform device for as
many ports you have and set to resources accordingly.


Thanks,

-- 
heikki
