Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaIOPje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:39:34 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:48009 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753074AbaIOPjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:39:32 -0400
Message-ID: <54170823.7040801@hurleysoftware.com>
Date: Mon, 15 Sep 2014 11:39:15 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Frans Klaver <frans.klaver@xsens.com>, Tony Lindgren <tony@atomide.com>
CC: Felipe Balbi <balbi@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Pelykh <alexey.pelykh@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] tty: omap-serial: use threaded interrupt handler
References: <1410789610-23059-1-git-send-email-frans.klaver@xsens.com> <1410789610-23059-4-git-send-email-frans.klaver@xsens.com>
In-Reply-To: <1410789610-23059-4-git-send-email-frans.klaver@xsens.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 10:00 AM, Frans Klaver wrote:
> At 3.6Mbaud, with slightly over 2Mbit/s data coming in, we see 1600 uart
> rx buffer overflows within 30 seconds. Threading the interrupt handling reduces
> this to about 170 overflows in 10 minutes.

Why is the threadirqs kernel boot option not sufficient?
Or conversely, shouldn't this be selectable?

Regards,
Peter Hurley

PS - To overflow the 64 byte RX FIFO at those data rates means interrupt
latency in excess of 250us?

> In practice this therefore reduces the need for hardware flow control,
> meaning the sending side doesn't have to buffer as much either.
> 
> Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
> ---
>  drivers/tty/serial/omap-serial.c | 30 +++++++++++++++++++++++-------
>  1 file changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
> index 7d3f557..398139a 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -575,6 +575,20 @@ static void serial_omap_rdi(struct uart_omap_port *up, unsigned int lsr)
>  }
>  
>  /**
> + * serial_omap_fast_irq() - schedule interrupt handling
> + */
> +static irqreturn_t serial_omap_fast_irq(int irq, void *dev_id)
> +{
> +	struct uart_omap_port *up = dev_id;
> +	unsigned int iir = serial_in(up, UART_IIR);
> +
> +	if (iir & UART_IIR_NO_INT)
> +		return IRQ_NONE;
> +
> +	return IRQ_WAKE_THREAD;
> +}
> +
> +/**
>   * serial_omap_irq() - This handles the interrupt from one port
>   * @irq: uart port irq number
>   * @dev_id: uart port info
> @@ -584,7 +598,6 @@ static irqreturn_t serial_omap_irq(int irq, void *dev_id)
>  	struct uart_omap_port *up = dev_id;
>  	unsigned int iir, lsr;
>  	unsigned int type;
> -	irqreturn_t ret = IRQ_NONE;
>  	int max_count = 256;
>  
>  	spin_lock(&up->port.lock);
> @@ -595,7 +608,6 @@ static irqreturn_t serial_omap_irq(int irq, void *dev_id)
>  		if (iir & UART_IIR_NO_INT)
>  			break;
>  
> -		ret = IRQ_HANDLED;
>  		lsr = serial_in(up, UART_LSR);
>  
>  		/* extract IRQ type from IIR register */
> @@ -634,7 +646,7 @@ static irqreturn_t serial_omap_irq(int irq, void *dev_id)
>  	pm_runtime_put_autosuspend(up->dev);
>  	up->port_activity = jiffies;
>  
> -	return ret;
> +	return IRQ_HANDLED;
>  }
>  
>  static unsigned int serial_omap_tx_empty(struct uart_port *port)
> @@ -731,15 +743,19 @@ static int serial_omap_startup(struct uart_port *port)
>  	/*
>  	 * Allocate the IRQ
>  	 */
> -	retval = request_irq(up->port.irq, serial_omap_irq, up->port.irqflags,
> -				up->name, up);
> +	retval = request_threaded_irq(up->port.irq, serial_omap_fast_irq,
> +						serial_omap_irq,
> +						IRQF_ONESHOT | up->port.irqflags,
> +						up->name, up);
>  	if (retval)
>  		return retval;
>  
>  	/* Optional wake-up IRQ */
>  	if (up->wakeirq) {
> -		retval = request_irq(up->wakeirq, serial_omap_irq,
> -				     up->port.irqflags, up->name, up);
> +		retval = request_threaded_irq(up->wakeirq, serial_omap_fast_irq,
> +						serial_omap_irq,
> +						IRQF_ONESHOT | up->port.irqflags,
> +						up->name, up);
>  		if (retval) {
>  			free_irq(up->port.irq, up);
>  			return retval;
> 

