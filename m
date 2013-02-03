Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab3BCRdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 12:33:31 -0500
Received: from pequod.mess.org ([46.65.169.142]:58339 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab3BCRd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 12:33:28 -0500
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Feb 2013 12:33:28 EST
Date: Sun, 3 Feb 2013 17:26:57 +0000
From: Sean Young <sean@mess.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 061/128] 8250: blacklist Winbond CIR port
Message-ID: <20130203172657.GA23690@pequod.mess.org>
References: <20130203144644.035172954@decadent.org.uk>
 <20130203144649.474239317@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130203144649.474239317@decadent.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 03:47:45PM +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Sean Young <sean@mess.org>
> 
> commit 65ecc9c02dbad033a73a32916d17c107c5b25031 upstream.
> 
> The legacy serial driver will detect the Winbond CIR device as a serial
> port, since it looks exactly like a serial port unless you know what
> it is from the PNP ID.
> 
> Here we track this port as a special PORT_8250_CIR type, preventing the
> legacy serial driver from probing it.

This commit relies on an earlier commit which ensures that 8250 PNP probe
is done before legacy 8250 probe, else the Winbond CIR device will be 
claimed by the legacy 8250 driver rendering above commit useless.

commit 835d844d1a28efba81d5aca7385e24c29d3a6db2
Author: Sean Young <sean@mess.org>
Date:   Fri Sep 7 19:06:23 2012 +0100

    8250_pnp: do pnp probe before legacy probe
    
    We first probe the legacy serial ports and then check pnp. If there
    is a non-standard configuration then this might not work, also this
    change is needed so we can blacklist Winbond CIR based on PNP ID.
    
    For this to work the 8250_pnp driver must be merged into the 8250
    module.


Sean
> 
> Signed-off-by: Sean Young <sean@mess.org>
> Acked-by: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [bwh: Backported to 3.2:
>  - Adjust filenames
>  - Adjust context
>  - First available port type number is 22 not 23
>  - s/uart\.port/port/]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/tty/serial/8250.c     |   16 ++++++++++++++--
>  drivers/tty/serial/8250_pnp.c |   20 +++++++++++++++-----
>  include/linux/serial_core.h        |    3 ++-
>  3 files changed, 31 insertions(+), 8 deletions(-)
> 
> --- a/drivers/tty/serial/8250.c
> +++ b/drivers/tty/serial/8250.c
> @@ -316,6 +316,9 @@ static const struct serial8250_config ua
>  		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
>  		.flags		= UART_CAP_FIFO | UART_CAP_AFE | UART_CAP_EFR,
>  	},
> +	[PORT_8250_CIR] = {
> +		.name		= "CIR port"
> +	}
>  };
>  
>  #if defined(CONFIG_MIPS_ALCHEMY)
> @@ -1984,6 +1987,9 @@ static int serial8250_startup(struct uar
>  	unsigned char lsr, iir;
>  	int retval;
>  
> +	if (port->type == PORT_8250_CIR)
> +		return -ENODEV;
> +
>  	up->port.fifosize = uart_config[up->port.type].fifo_size;
>  	up->tx_loadsz = uart_config[up->port.type].tx_loadsz;
>  	up->capabilities = uart_config[up->port.type].flags;
> @@ -2628,7 +2634,10 @@ static int serial8250_request_port(struc
>  {
>  	struct uart_8250_port *up =
>  		container_of(port, struct uart_8250_port, port);
> -	int ret = 0;
> +	int ret;
> +
> +	if (port->type == PORT_8250_CIR)
> +		return -ENODEV;
>  
>  	ret = serial8250_request_std_resource(up);
>  	if (ret == 0 && up->port.type == PORT_RSA) {
> @@ -2647,6 +2656,9 @@ static void serial8250_config_port(struc
>  	int probeflags = PROBE_ANY;
>  	int ret;
>  
> +	if (port->type == PORT_8250_CIR)
> +		return;
> +
>  	/*
>  	 * Find the region that we can probe for.  This in turn
>  	 * tells us whether we can probe for the type of port.
> @@ -3215,7 +3227,7 @@ int serial8250_register_port(struct uart
>  	mutex_lock(&serial_mutex);
>  
>  	uart = serial8250_find_match_or_unused(port);
> -	if (uart) {
> +	if (uart && uart->port.type != PORT_8250_CIR) {
>  		uart_remove_one_port(&serial8250_reg, &uart->port);
>  
>  		uart->port.iobase       = port->iobase;
> --- a/drivers/tty/serial/8250_pnp.c
> +++ b/drivers/tty/serial/8250_pnp.c
> @@ -25,7 +25,7 @@
>  #include "8250.h"
>  
>  #define UNKNOWN_DEV 0x3000
> -
> +#define CIR_PORT	0x0800
>  
>  static const struct pnp_device_id pnp_dev_table[] = {
>  	/* Archtek America Corp. */
> @@ -362,6 +362,9 @@ static const struct pnp_device_id pnp_de
>  	{	"PNPCXXX",		UNKNOWN_DEV	},
>  	/* More unknown PnP modems */
>  	{	"PNPDXXX",		UNKNOWN_DEV	},
> +	/* Winbond CIR port, should not be probed. We should keep track
> +	   of it to prevent the legacy serial driver from probing it */
> +	{	"WEC1022",		CIR_PORT	},
>  	{	"",			0	}
>  };
>  
> @@ -409,7 +412,7 @@ static int __devinit check_resources(str
>   * PnP modems, alternatively we must hardcode all modems in pnp_devices[]
>   * table.
>   */
> -static int __devinit serial_pnp_guess_board(struct pnp_dev *dev, int *flags)
> +static int __devinit serial_pnp_guess_board(struct pnp_dev *dev)
>  {
>  	if (!(check_name(pnp_dev_name(dev)) ||
>  		(dev->card && check_name(dev->card->name))))
> @@ -428,7 +431,7 @@ serial_pnp_probe(struct pnp_dev *dev, co
>  	int ret, line, flags = dev_id->driver_data;
>  
>  	if (flags & UNKNOWN_DEV) {
> -		ret = serial_pnp_guess_board(dev, &flags);
> +		ret = serial_pnp_guess_board(dev);
>  		if (ret < 0)
>  			return ret;
>  	}
> @@ -436,7 +439,10 @@ serial_pnp_probe(struct pnp_dev *dev, co
>  	memset(&port, 0, sizeof(struct uart_port));
>  	if (pnp_irq_valid(dev, 0))
>  		port.irq = pnp_irq(dev, 0);
> -	if (pnp_port_valid(dev, 0)) {
> +	if ((flags & CIR_PORT) && pnp_port_valid(dev, 2)) {
> +		port.iobase = pnp_port_start(dev, 2);
> +		port.iotype = UPIO_PORT;
> +	} else if (pnp_port_valid(dev, 0)) {
>  		port.iobase = pnp_port_start(dev, 0);
>  		port.iotype = UPIO_PORT;
>  	} else if (pnp_mem_valid(dev, 0)) {
> @@ -451,6 +457,10 @@ serial_pnp_probe(struct pnp_dev *dev, co
>  		"Setup PNP port: port %x, mem 0x%lx, irq %d, type %d\n",
>  		       port.iobase, port.mapbase, port.irq, port.iotype);
>  #endif
> +	if (flags & CIR_PORT) {
> +		port.flags |= UPF_FIXED_PORT | UPF_FIXED_TYPE;
> +		port.type = PORT_8250_CIR;
> +	}
>  
>  	port.flags |= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF;
>  	if (pnp_irq_flags(dev, 0) & IORESOURCE_IRQ_SHAREABLE)
> @@ -459,7 +469,7 @@ serial_pnp_probe(struct pnp_dev *dev, co
>  	port.dev = &dev->dev;
>  
>  	line = serial8250_register_port(&port);
> -	if (line < 0)
> +	if (line < 0 || (flags & CIR_PORT))
>  		return -ENODEV;
>  
>  	pnp_set_drvdata(dev, (void *)((long)line + 1));
> --- a/include/linux/serial_core.h
> +++ b/include/linux/serial_core.h
> @@ -47,7 +47,8 @@
>  #define PORT_U6_16550A	19	/* ST-Ericsson U6xxx internal UART */
>  #define PORT_TEGRA	20	/* NVIDIA Tegra internal UART */
>  #define PORT_XR17D15X	21	/* Exar XR17D15x UART */
> -#define PORT_MAX_8250	21	/* max port ID */
> +#define PORT_8250_CIR	22	/* CIR infrared port, has its own driver */
> +#define PORT_MAX_8250	22	/* max port ID */
>  
>  /*
>   * ARM specific type numbers.  These are not currently guaranteed
> 
