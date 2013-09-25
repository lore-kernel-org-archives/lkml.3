Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab3IYLm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 07:42:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:34380 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684Ab3IYLmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 07:42:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,978,1371106800"; 
   d="scan'208";a="383311189"
Date: Wed, 25 Sep 2013 14:42:32 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org
Subject: Re: [PATCH] serial: 8250_dw: Improve unwritable LCR workaround
Message-ID: <20130925114232.GA26259@xps8300>
References: <1380069549-9176-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380069549-9176-1-git-send-email-tim.kryger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

On Tue, Sep 24, 2013 at 05:39:09PM -0700, Tim Kryger wrote:
> The Designware UART has a limitation where it ignores writes into the
> LCR if the UART is busy.  The current workaround stashes a copy of the
> last written LCR and writes it back down to the hardware if it receives
> a special busy interrupt which is raised when a write was ignored.
> 
> Unfortunately, interrupts are typically disabled prior to performing a
> sequence of register writes that include the LCR so the point at which
> the retry occurs is too late.  An example is serial8250_do_set_termios()
> where an ignored LCR write results in the baud divisor not being set and
> instead a garbage character is sent out the transmitter.
> 
> Furthermore, since serial_port_out() offers no way to indicate failure,
> a serious effort must be made to ensure that the LCR is actually updated
> before returning back to the caller.  This is difficult, however, as a
> UART that was busy during the first attempt is likely to still be busy
> when a subsequent attempt is made unless some extra action is taken.
> 
> This updated workaround takes the extreme action of clearing the TX/RX
> FIFOs and reading the receive buffer before writing down the LCR in the
> hope that doing so will force the UART into an idle state.  While this
> may seem unnecessarily aggressive, writes to the LCR are used to change
> the baud rate, parity, stop bit, or data length so the data that may be
> lost is likely not important.  Admittedly, this is far from ideal but it
> seems to be the best that can be done given the hardware limitations.

<snip>

> @@ -76,17 +75,35 @@ static inline int dw8250_modify_msr(struct uart_port *p, int offset, int value)
>  	return value;
>  }
>  
> +/* The UART will ignore writes to LCR when busy we take aggressive steps
> + * to ensure that it is idle before attempting to write to LCR */
> +static void dw8250_force_idle(struct uart_port *p)
> +{
> +	serial8250_clear_and_reinit_fifos(container_of
> +					  (p, struct uart_8250_port, port));
> +	(void)p->serial_in(p, UART_LSR);
> +	(void)p->serial_in(p, UART_MSR);
> +	(void)p->serial_in(p, UART_RX);
> +}

This looks pretty brutal. Is it really necessary?

>  static void dw8250_serial_out(struct uart_port *p, int offset, int value)
>  {
>  	struct dw8250_data *d = p->private_data;
>  
> -	if (offset == UART_LCR)
> -		d->last_lcr = value;
> -
> -	if (offset == UART_MCR)
> -		d->last_mcr = value;
> -
> -	writeb(value, p->membase + (offset << p->regshift));
> +	if (offset == UART_LCR) {
> +		int tries = 1000;
> +		while (tries--) {
> +			if (value == p->serial_in(p, UART_LCR))
> +				return;
> +			dw8250_force_idle(p);
> +			writeb(value, p->membase + (UART_LCR << p->regshift));
> +		}
> +		dev_err(p->dev, "Couldn't set LCR to %d\n", value);

Is it not enough to simply poll USR[0] to see when the UART becomes
free?


-- 
heikki
