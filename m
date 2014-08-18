Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaHRNry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 09:47:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:57972 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaHRNrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:47:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,886,1400050800"; 
   d="scan'208";a="560029289"
Date: Mon, 18 Aug 2014 16:46:43 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 05/15] tty: serial: Add 8250-core based omap driver
Message-ID: <20140818134643.GA32400@xps8300>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
 <1408124563-31541-6-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408124563-31541-6-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 15, 2014 at 07:42:33PM +0200, Sebastian Andrzej Siewior wrote:
> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
> index cc90c19..ab003b6 100644
> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -264,6 +264,12 @@ static const struct serial8250_config uart_config[] = {
>  		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
>  		.flags		= UART_CAP_FIFO | UART_CAP_AFE,
>  	},
> +	[PORT_OMAP_16750] = {
> +		.name		= "OMAP",
> +		.fifo_size	= 64,
> +		.tx_loadsz	= 64,
> +		.flags		= UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP,
> +	},

I don't think you need this. Reasons below...

>  	[PORT_TEGRA] = {
>  		.name		= "Tegra",
>  		.fifo_size	= 32,
> @@ -1390,6 +1396,8 @@ static void serial8250_stop_rx(struct uart_port *port)
>  	serial8250_rpm_get(up);
>  
>  	up->ier &= ~UART_IER_RLSI;
> +	if (port->type == PORT_OMAP_16750)
> +		up->ier &= ~UART_IER_RDI;

I don't see any reason why this could not be always cleared regardless
of the type:

        up->ier &= ~(UART_IER_RLSI | UART_IRE_RDI);

>  	up->port.read_status_mask &= ~UART_LSR_DR;
>  	serial_port_out(port, UART_IER, up->ier);
>  
> diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
> new file mode 100644
> index 0000000..368e9d8
> --- /dev/null
> +++ b/drivers/tty/serial/8250/8250_omap.c
> @@ -0,0 +1,911 @@
> +/*
> + * 8250-core based driver for the OMAP internal UART
> + *
> + *  Copyright (C) 2014 Sebastian Andrzej Siewior
> + *
> + */

[cut]

> +static int omap8250_probe(struct platform_device *pdev)
> +{
> +	struct resource *regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	struct resource *irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	struct omap8250_priv *priv;
> +	struct uart_8250_port up;
> +	int ret;
> +	void __iomem *membase;
> +
> +	if (!regs || !irq) {
> +		dev_err(&pdev->dev, "missing registers or irq\n");
> +		return -EINVAL;
> +	}
> +
> +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv) {
> +		dev_err(&pdev->dev, "unable to allocate private data\n");
> +		return -ENOMEM;
> +	}
> +	membase = devm_ioremap_nocache(&pdev->dev, regs->start,
> +			resource_size(regs));
> +	if (!membase)
> +		return -ENODEV;
> +
> +	memset(&up, 0, sizeof(up));
> +	up.port.dev = &pdev->dev;
> +	up.port.mapbase = regs->start;
> +	up.port.membase = membase;
> +	up.port.irq = irq->start;
> +	/*
> +	 * It claims to be 16C750 compatible however it is a little different.
> +	 * It has EFR and has no FCR7_64byte bit. The AFE which it claims to
> +	 * have is enabled via EFR instead of MCR.
> +	 */
> +	up.port.type = PORT_OMAP_16750;

Since you are not calling serial8250_do_set_termios, 8250_core.c newer
overrides the FCR set in this driver. However, if the FCR is a
problem, since Yoshihiro added the member for it to struct
uart_8250_port (commit aef9a7bd9), just make it possible for the probe
drivers to provide also it's value:

--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -2829,7 +2829,9 @@ static void serial8250_config_port(struct uart_port *port, int flags)
                port->handle_irq = exar_handle_irq;
 
        register_dev_spec_attr_grp(up);
-       up->fcr = uart_config[up->port.type].fcr;
+
+       if (!up->fcr)
+               up->fcr = uart_config[up->port.type].fcr;
 }
 
 static int

So instead of using PORT_OMAP_16750:
        up.port.type = PORT_16750;
        up.capabilities = UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP;

and the fcr if needed.
        up.fcr = ...

> +	up.port.iotype = UPIO_MEM32;
> +	up.port.flags = UPF_BOOT_AUTOCONF | UPF_FIXED_PORT | UPF_FIXED_TYPE |
> +		UPF_SOFT_FLOW | UPF_HARD_FLOW;
> +	up.port.private_data = priv;
> +
> +	up.port.regshift = 2;
> +	up.port.fifosize = 64;

You don't need to set the fifosize unless you want to replace the
value you get from uart_config array.

> +	up.port.set_termios = omap_8250_set_termios;
> +	up.port.pm = omap_8250_pm;
> +	up.port.startup = omap_8250_startup;
> +	up.port.shutdown = omap_8250_shutdown;
> +	up.port.throttle = omap_8250_throttle;
> +	up.port.unthrottle = omap_8250_unthrottle;
> +
> +	if (pdev->dev.of_node) {
> +		up.port.line = of_alias_get_id(pdev->dev.of_node, "serial");
> +		of_property_read_u32(pdev->dev.of_node, "clock-frequency",
> +				&up.port.uartclk);
> +		priv->wakeirq = irq_of_parse_and_map(pdev->dev.of_node, 1);
> +	} else {
> +		up.port.line = pdev->id;
> +	}
> +
> +	if (up.port.line < 0) {
> +		dev_err(&pdev->dev, "failed to get alias/pdev id, errno %d\n",
> +				up.port.line);
> +		return -ENODEV;
> +	}
> +	if (!up.port.uartclk) {
> +		up.port.uartclk = DEFAULT_CLK_SPEED;
> +		dev_warn(&pdev->dev,
> +				"No clock speed specified: using default: %d\n",
> +				DEFAULT_CLK_SPEED);
> +	}
> +
> +#ifdef CONFIG_PM_RUNTIME
> +	up.capabilities |= UART_CAP_RPM;
> +#endif

By setting this here, you will not get the capabilities from the
uart_config[type].flags if runtime PM is enabled in any case, right?

[cut]

> diff --git a/drivers/tty/serial/8250/Makefile b/drivers/tty/serial/8250/Makefile
> index 36d68d0..4bac392 100644
> --- a/drivers/tty/serial/8250/Makefile
> +++ b/drivers/tty/serial/8250/Makefile
> @@ -20,3 +20,4 @@ obj-$(CONFIG_SERIAL_8250_HUB6)		+= 8250_hub6.o
>  obj-$(CONFIG_SERIAL_8250_FSL)		+= 8250_fsl.o
>  obj-$(CONFIG_SERIAL_8250_DW)		+= 8250_dw.o
>  obj-$(CONFIG_SERIAL_8250_EM)		+= 8250_em.o
> +obj-$(CONFIG_SERIAL_8250_OMAP)		+= 8250_omap.o
> diff --git a/include/uapi/linux/serial_core.h b/include/uapi/linux/serial_core.h
> index 5820269..74f9b11 100644
> --- a/include/uapi/linux/serial_core.h
> +++ b/include/uapi/linux/serial_core.h
> @@ -54,7 +54,8 @@
>  #define PORT_ALTR_16550_F32 26	/* Altera 16550 UART with 32 FIFOs */
>  #define PORT_ALTR_16550_F64 27	/* Altera 16550 UART with 64 FIFOs */
>  #define PORT_ALTR_16550_F128 28 /* Altera 16550 UART with 128 FIFOs */
> -#define PORT_MAX_8250	28	/* max port ID */
> +#define PORT_OMAP_16750	29	/* TI's OMAP internal 16C750 compatible UART */
> +#define PORT_MAX_8250	29	/* max port ID */

So in this case I see no reason for new type.

Cheers,

-- 
heikki
