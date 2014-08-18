Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaHRSbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:31:41 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:37256 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751852AbaHRSbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:31:39 -0400
Message-ID: <53F24660.2030404@hurleysoftware.com>
Date: Mon, 18 Aug 2014 14:30:56 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Daniel Thompson <daniel.thompson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: Re: [PATCH v9 12/16] serial: amba-pl011: Pass FIQ information to
 KGDB.
References: <1404979427-12943-1-git-send-email-daniel.thompson@linaro.org> <1408372091-12689-13-git-send-email-daniel.thompson@linaro.org>
In-Reply-To: <1408372091-12689-13-git-send-email-daniel.thompson@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 08/18/2014 10:28 AM, Daniel Thompson wrote:
> Speculatively register a FIQ resource with KGDB. KGDB will only
> accept it if the kgdb/fiq feature is enabled (both with compile time and
> runtime switches) and the interrupt controller supports FIQ.
> 
> By providing this information to KGDB the serial driver offers
> "permission" for KGDB to route the UART interrupt signal from the
> drivers own handler to KGDBs FIQ handler (which will eventually use the
> UART's polled I/O callbacks to interact with the user). This permission
> also implies the amba-pl011 driver has already unmasked RX interrupts
> (otherwise the FIQ handler will never trigger).
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: linux-serial@vger.kernel.org
> ---
>  drivers/tty/serial/amba-pl011.c | 94 ++++++++++++++++++++++++-----------------
>  1 file changed, 55 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
> index 8572f2a..ec8ddc7 100644
> --- a/drivers/tty/serial/amba-pl011.c
> +++ b/drivers/tty/serial/amba-pl011.c
> @@ -58,6 +58,7 @@
>  #include <linux/pinctrl/consumer.h>
>  #include <linux/sizes.h>
>  #include <linux/io.h>
> +#include <linux/kgdb.h>
>  
>  #define UART_NR			14
>  
> @@ -1416,8 +1417,61 @@ static void pl011_break_ctl(struct uart_port *port, int break_state)
>  	spin_unlock_irqrestore(&uap->port.lock, flags);
>  }
>  

Is pl011_hwinit() just being relocated in source to avoid the forward
declaration? If so, this is usually split into its own commit.

> +static int pl011_hwinit(struct uart_port *port)
> +{
> +	struct uart_amba_port *uap = (struct uart_amba_port *)port;
> +	int retval;
> +
> +	/* Optionaly enable pins to be muxed in and configured */
> +	pinctrl_pm_select_default_state(port->dev);
> +
> +	/*
> +	 * Try to enable the clock producer.
> +	 */
> +	retval = clk_prepare_enable(uap->clk);
> +	if (retval)
> +		return retval;
> +
> +	uap->port.uartclk = clk_get_rate(uap->clk);
> +
> +	/* Clear pending error and receive interrupts */
> +	writew(UART011_OEIS | UART011_BEIS | UART011_PEIS | UART011_FEIS |
> +	       UART011_RTIS | UART011_RXIS, uap->port.membase + UART011_ICR);
> +
> +	/*
> +	 * Save interrupts enable mask, and enable RX interrupts in case if
> +	 * the interrupt is used for NMI entry.
> +	 */
> +	uap->im = readw(uap->port.membase + UART011_IMSC);
> +	writew(UART011_RTIM | UART011_RXIM, uap->port.membase + UART011_IMSC);
> +
> +	if (dev_get_platdata(uap->port.dev)) {
> +		struct amba_pl011_data *plat;
> +
> +		plat = dev_get_platdata(uap->port.dev);
> +		if (plat->init)
> +			plat->init();
> +	}
> +	return 0;
> +}
> +
>  #ifdef CONFIG_CONSOLE_POLL
>  
> +static int pl011_poll_init(struct uart_port *port)
> +{
> +	struct uart_amba_port *uap = (struct uart_amba_port *)port;

Please use container_of() in new code.

> +	int retval;
> +
> +	retval = pl011_hwinit(port);
> +
> +#ifdef CONFIG_KGDB_FIQ
> +	if (retval == 0)
> +		kgdb_register_fiq(uap->port.irq);

The uap->port dereference is unnecessary since the port parameter
is the same thing.

		kgdb_register_fiq(port->irq);

Regards,
Peter Hurley

> +#endif
> +
> +	return retval;
> +}
> +
>  static void pl011_quiesce_irqs(struct uart_port *port)
>  {
>  	struct uart_amba_port *uap = (struct uart_amba_port *)port;
> @@ -1471,44 +1525,6 @@ static void pl011_put_poll_char(struct uart_port *port,
>  
>  #endif /* CONFIG_CONSOLE_POLL */
>  
> -static int pl011_hwinit(struct uart_port *port)
> -{
> -	struct uart_amba_port *uap = (struct uart_amba_port *)port;
> -	int retval;
> -
> -	/* Optionaly enable pins to be muxed in and configured */
> -	pinctrl_pm_select_default_state(port->dev);
> -
> -	/*
> -	 * Try to enable the clock producer.
> -	 */
> -	retval = clk_prepare_enable(uap->clk);
> -	if (retval)
> -		return retval;
> -
> -	uap->port.uartclk = clk_get_rate(uap->clk);
> -
> -	/* Clear pending error and receive interrupts */
> -	writew(UART011_OEIS | UART011_BEIS | UART011_PEIS | UART011_FEIS |
> -	       UART011_RTIS | UART011_RXIS, uap->port.membase + UART011_ICR);
> -
> -	/*
> -	 * Save interrupts enable mask, and enable RX interrupts in case if
> -	 * the interrupt is used for NMI entry.
> -	 */
> -	uap->im = readw(uap->port.membase + UART011_IMSC);
> -	writew(UART011_RTIM | UART011_RXIM, uap->port.membase + UART011_IMSC);
> -
> -	if (dev_get_platdata(uap->port.dev)) {
> -		struct amba_pl011_data *plat;
> -
> -		plat = dev_get_platdata(uap->port.dev);
> -		if (plat->init)
> -			plat->init();
> -	}
> -	return 0;
> -}
> -
>  static void pl011_write_lcr_h(struct uart_amba_port *uap, unsigned int lcr_h)
>  {
>  	writew(lcr_h, uap->port.membase + uap->lcrh_rx);
> @@ -1888,7 +1904,7 @@ static struct uart_ops amba_pl011_pops = {
>  	.config_port	= pl011_config_port,
>  	.verify_port	= pl011_verify_port,
>  #ifdef CONFIG_CONSOLE_POLL
> -	.poll_init     = pl011_hwinit,
> +	.poll_init     = pl011_poll_init,
>  	.poll_get_char = pl011_get_poll_char,
>  	.poll_put_char = pl011_put_poll_char,
>  #endif
> 

