Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbaCJOSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:18:48 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58327 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbaCJOSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:18:46 -0400
Date: Mon, 10 Mar 2014 14:17:43 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: jon@ringle.org
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Jon Ringle <jringle@gridpoint.com>
Subject: Re: [PATCH] RFC: WIP: sc16is7xx [v0.4]
Message-ID: <20140310141743.3319acf8@alan.etchedpixels.co.uk>
In-Reply-To: <1394432777-13005-1-git-send-email-jon@ringle.org>
References: <1394432777-13005-1-git-send-email-jon@ringle.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define DRV_NAME	"sc16is7xx"
> +#define DRV_VERSION	"0.4"
> +#define SC16IS7XX_MAJOR	204
> +#define SC16IS7XX_MINOR	8

Use dynamic minors for any new device

> +static inline u8 sc16is7xx_read(struct uart_port *port, u8 reg)

I wouldn't inline this - the compiler will figure it out for you and
you've got a fair bit code there.


> +static void sc16is7xx_handle_rx(struct uart_port *port)

This gets called from handle_events which gets called from the ist
handler with IRQs disabled. I'm surprised it works at all but you
definitely don't want to be doing all this work with interrupts blocked.
That may be part of your problem.

> +static void sc16is7xx_handle_tx(struct uart_port *port)

Ditto


> +static void sc16is7xx_set_termios(struct uart_port *port,
> +				  struct ktermios *termios, struct ktermios *old)
> +{
> +	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
> +	unsigned long flags;
> +	u8 cval;
> +	u8 fcr;
> +	int baud;
> +
> +	spin_lock_irqsave(&s->lock, flags);
> +
> +	/* Mask termios capabilities we don't support */
> +	termios->c_cflag &= ~CMSPAR;
> +
> +	/* Disable RX & TX, reset break condition, status and FIFOs */
> +	fcr = sc16is7xx_read(port, UART_FCR);
> +	fcr |= UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT;
> +	fcr &= ~UART_FCR_ENABLE_FIFO;
> +	sc16is7xx_write(port, UART_FCR, fcr);
> +
> +	/* Word size */
> +	switch (termios->c_cflag & CSIZE) {
> +	case CS5:
> +		cval = UART_LCR_WLEN5;
> +		break;
> +	case CS6:
> +		cval = UART_LCR_WLEN6;
> +		break;
> +	case CS7:
> +		cval = UART_LCR_WLEN7;
> +		break;
> +	case CS8:
> +	default:
> +		cval = UART_LCR_WLEN8;

(for the unknown case you also need to do
		termios->c_cflag &= ~CSIZE;
		termios->c_cflag |= CS8;

so the caller gets informed they didn't get their requested feature

Likewise btw for unsupported features. In this case CMSPAR appears not to
be supported ?)

Reading drivers/tty/serial/max310x.c may be helpful with regards to the
locking. It is SPI based so also has to defer some of the processing from
the IRQ handler. The threaded IRQ support we now have may also help you.

Alan
