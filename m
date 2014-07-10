Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaGJOxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:53:17 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40956 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbaGJOxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:53:14 -0400
Date: Thu, 10 Jul 2014 15:52:15 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 5/6] tty: serial: 8250-core: add rs485 support
Message-ID: <20140710155215.3e17ca08@alan.etchedpixels.co.uk>
In-Reply-To: <1404928177-26554-6-git-send-email-bigeasy@linutronix.de>
References: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>
	<1404928177-26554-6-git-send-email-bigeasy@linutronix.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static inline void __stop_tx(struct uart_8250_port *p)
>  {
> +	if (p->rs485.flags & SER_RS485_ENABLED) {
> +		int ret;
> +
> +		ret = (p->rs485.flags & SER_RS485_RTS_AFTER_SEND) ? 1 : 0;
> +		if (gpio_get_value(p->rts_gpio) != ret) {
> +			if (p->rs485.delay_rts_after_send > 0)
> +				mdelay(p->rs485.delay_rts_after_send);
> +			gpio_set_value(p->rts_gpio, ret);
> +		}

RTS is not normally a GPIO. We should be controlling the UART RTS here,
and if the UART has a magic special case RTS wired to a GPIO then really
the hardware specific part should handle that gunge. I don't care whether
the drive does it via serial_out magic or a more explicit hook but it
doesn't belong here in core code.

Likewise the mdelay probably should be in the device specific bits or
controlled by a flag as not all hardware is so braindead.

> @@ -1330,6 +1356,20 @@ static void serial8250_start_tx(struct uart_port *port)
>  	if (up->dma && !serial8250_tx_dma(up)) {

Ditto

> +int serial8250_probe_rs485(struct uart_8250_port *up,
> +		struct device *dev)
> +{
> +	struct serial_rs485 *rs485conf = &up->rs485;
> +	struct device_node *np = dev->of_node;
> +	u32 rs485_delay[2];
> +	enum of_gpio_flags flags;
> +	int ret;
> +
> +	rs485conf->flags = 0;
> +	if (!np)
> +		return 0;
> +
> +	/* check for tx enable gpio */
> +	up->rts_gpio = of_get_named_gpio_flags(np, "rts-gpio", 0, &flags);

No of_ dependencies in core 8250.c either please. That looks a perfectly
good implementation of serial8250_of_probe_rs485 however, just belongs in
the right place.

> +static int serial8250_ioctl(struct uart_port *port, unsigned int cmd,
> +		unsigned long arg)
> +{
> +	struct serial_rs485 rs485conf;
> +	struct uart_8250_port *up;
> +
> +	up = container_of(port, struct uart_8250_port, port);
> +	switch (cmd) {
> +	case TIOCSRS485:
> +		if (!gpio_is_valid(up->rts_gpio))
> +			return -ENODEV;

GPIO assumption again needs to go


> diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
> index 0ec21ec..056a73f 100644
> --- a/include/linux/serial_8250.h
> +++ b/include/linux/serial_8250.h
> @@ -78,6 +78,7 @@ struct uart_8250_port {
>  	unsigned char		acr;
>  	unsigned char		ier;
>  	unsigned char		lcr;
> +	unsigned char		fcr;
>  	unsigned char		mcr;
>  	unsigned char		mcr_mask;	/* mask of user bits */
>  	unsigned char		mcr_force;	/* mask of forced bits */
> @@ -94,6 +95,9 @@ struct uart_8250_port {
>  	unsigned char		msr_saved_flags;
>  
>  	struct uart_8250_dma	*dma;
> +	struct serial_rs485	rs485;
> +	int			rts_gpio;
> +	bool			rts_gpio_valid;

Keeping the gpio here doesn't look unreasonable if one is in use.

Alan
