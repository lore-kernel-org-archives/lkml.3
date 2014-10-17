Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaJQNEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 09:04:05 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47384 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710AbaJQNEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:04:02 -0400
Date: Fri, 17 Oct 2014 14:03:54 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "artagnon@gmail.com" <artagnon@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>
Subject: Re: [PATCH v2 5/5] tty/serial: Add earlycon support for Spreadtrum
 serial driver
Message-ID: <20141017130354.GC5587@leverpostej>
References: <sprd-1017-v2>
 <1413539665-11484-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1413539665-11484-6-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413539665-11484-6-git-send-email-chunyan.zhang@spreadtrum.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 10:54:25AM +0100, Chunyan Zhang wrote:
> Add serial driver for spreadtrum sharkl platform with earlycon
> support at first.
> 
> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
> ---
>  drivers/tty/serial/Kconfig       |   24 ++++++++++++++
>  drivers/tty/serial/Makefile      |    1 +
>  drivers/tty/serial/sprd-serial.c |   64 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 89 insertions(+)
>  create mode 100644 drivers/tty/serial/sprd-serial.c
> 
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index 26cec64..33b8f90 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -113,6 +113,30 @@ config SERIAL_SB1250_DUART_CONSOLE
>  
>  	  If unsure, say Y.
>  
> +config SERIAL_SPRD
> +	tristate "Support for SPRD serial"
> +	depends on ARM || ARM64
> +	select SERIAL_CORE
> +	help
> +          This enables the driver for the Spreadtrum's serial.
> +
> +config SERIAL_SPRD_NR
> +        int "Maximum number of sprd serial ports"
> +        depends on SERIAL_SPRD
> +        default "4"

This is not used below.

> +
> +config SERIAL_SPRD_CONSOLE
> +        bool "SPRD UART console support"
> +        depends on SERIAL_SPRD=y
> +        select SERIAL_CORE_CONSOLE
> +	select SERIAL_EARLYCON
> +        help
> +	  Support for early debug console using Spreadtrum's serial. This enables
> +	  the console before standard serial driver is probed. This is enabled
> +	  with "earlycon=serial_sprd" on the kernel command line. The console is
> +	  enabled when early_param is processed.

There only appears to be an earlycon driver, and not "standard serial
driver".

What happens after earlycon?

Surely there should be a real driver to take ownership of the UART?

As far as I can see it won't be possible to boot your platform to a
prompt, because earlycon will have gone before that.

Thanks,
Mark.

> +
> +
>  config SERIAL_ATMEL
>  	bool "AT91 / AT32 on-chip serial port support"
>  	depends on ARCH_AT91 || AVR32
> diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
> index 0080cc3..b16e0d4 100644
> --- a/drivers/tty/serial/Makefile
> +++ b/drivers/tty/serial/Makefile
> @@ -92,6 +92,7 @@ obj-$(CONFIG_SERIAL_ARC)	+= arc_uart.o
>  obj-$(CONFIG_SERIAL_RP2)	+= rp2.o
>  obj-$(CONFIG_SERIAL_FSL_LPUART)	+= fsl_lpuart.o
>  obj-$(CONFIG_SERIAL_MEN_Z135)	+= men_z135_uart.o
> +obj-$(CONFIG_SERIAL_SPRD) += sprd-serial.o
>  
>  # GPIOLIB helpers for modem control lines
>  obj-$(CONFIG_SERIAL_MCTRL_GPIO)	+= serial_mctrl_gpio.o
> diff --git a/drivers/tty/serial/sprd-serial.c b/drivers/tty/serial/sprd-serial.c
> new file mode 100644
> index 0000000..9ae594f
> --- /dev/null
> +++ b/drivers/tty/serial/sprd-serial.c
> @@ -0,0 +1,64 @@
> +/*
> + * Copyright (C) 2012 Spreadtrum Communications Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/console.h>
> +#include <linux/init.h>
> +#include <linux/serial_core.h>
> +#include <linux/of.h>
> +
> +/*offset*/
> +#define UART_TXD	0x0000
> +#define UART_RXD	0x0004
> +#define UART_STS0	0x0008
> +#define UART_STS1	0x000C
> +#define UART_IEN	0x0010
> +#define UART_ICLR	0x0014
> +#define UART_CTL0	0x0018
> +#define UART_CTL1	0x001C
> +#define UART_CTL2	0x0020
> +#define UART_CLKD0	0x0024
> +#define UART_CLKD1	0x0028
> +#define UART_STS2	0x002C
> +
> +/*line status */
> +#define UART_LSR_TX_OVER	(0x1<<15)
> +
> +static void serial_sprd_putc(struct uart_port *port, int c)
> +{
> +	while (!(readl(port->membase + UART_STS0) & UART_LSR_TX_OVER))
> +		;
> +	writeb(c, port->membase + UART_TXD);
> +}
> +
> +static void serial_sprd_early_write(struct console *con, const char *s,
> +				    unsigned n)
> +{
> +	struct earlycon_device *dev = con->data;
> +
> +	uart_console_write(&dev->port, s, n, serial_sprd_putc);
> +}
> +
> +static int __init serial_sprd_early_console_setup(
> +				struct earlycon_device *device,
> +				const char *opt)
> +{
> +	if (!device->port.membase)
> +		return -ENODEV;
> +
> +	device->con->write = serial_sprd_early_write;
> +	return 0;
> +}
> +EARLYCON_DECLARE(serial_sprd, serial_sprd_early_console_setup);
> +OF_EARLYCON_DECLARE(serial_sprd, "sprd,serial",
> +		    serial_sprd_early_console_setup);
> -- 
> 1.7.9.5
> 
> 
