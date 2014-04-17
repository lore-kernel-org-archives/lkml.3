Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbaDQKvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:51:24 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47928 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbaDQKvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 06:51:22 -0400
Date: Thu, 17 Apr 2014 11:50:35 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>,
        "Thomas Schnuerer" <thomas.schnuerer@men.de>
Subject: Re: [PATCH] tty: serial: Add driver for MEN's 16z135 High Speed
 UART.
Message-ID: <20140417115035.745b55c8@alan.etchedpixels.co.uk>
In-Reply-To: <1397727894-10123-1-git-send-email-johannes.thumshirn@men.de>
References: <1397727894-10123-1-git-send-email-johannes.thumshirn@men.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +static inline void men_z135_reg_set(struct men_z135_port *uart,
> +				u32 addr, u32 val)
> +{
> +	struct uart_port *port = &uart->port;
> +	u32 reg;
> +
> +	reg = ioread32(port->membase + addr);
> +	reg |= val;
> +	iowrite32(reg, port->membase + addr);
> +}

It's not clear what the locking model is to avoid multiple parallel reg
sets overlapping ?


> +static void men_z135_handle_rx(struct men_z135_port *uart)
> +{
> +	struct uart_port *port = &uart->port;
> +	struct tty_port *tport = &port->state->port;
> +	int copied;
> +	u16 size;
> +	int room;
> +
> +	size = get_rx_fifo_content(uart);
> +
> +	if (size == 0)
> +		return;
> +
> +	/* Avoid accidently accessing TX FIFO instead of RX FIFO. Last
> +	 * longword in RX FIFO cannot be read.(0x004-0x3FF)
> +	 */
> +	if (size > MEN_Z135_FIFO_WATERMARK)
> +		size = MEN_Z135_FIFO_WATERMARK;
> +
> +	room = tty_buffer_request_room(tport, size);
> +	if (room != size)
> +		pr_err("Not enough room in flip buffer, truncating to %d\n",
> +			room);

dev_err would be better here, also we merely drop a few bytes so perhaps
_warn if anything.

> +	copied = tty_insert_flip_string(tport, uart->rxbuf, room);
> +	if (copied != room)
> +		pr_err("Only copied %d instead of %d bytes\n", copied, room);

ditto (although it can't happen currently)


> +/**
> + * men_z135_set_mctrl() - Set modem control lines
> + * @port: The UART port
> + * @mctrl: The modem control lines
> + *
> + * This function sets the modem control lines for a port described by @port
> + * to the state described by @mctrl
> + */
> +static void men_z135_set_mctrl(struct uart_port *port, unsigned int mctrl)
> +{
> +	struct men_z135_port *uart = to_men_z135(port);
> +	u32 conf_reg = 0;
> +
> +	if (mctrl & TIOCM_RTS)
> +		conf_reg |= MEN_Z135_MCR_RTS;
> +	if (mctrl & TIOCM_DTR)
> +		conf_reg |= MEN_Z135_MCR_DTR;
> +	if (mctrl & TIOCM_OUT1)
> +		conf_reg |= MEN_Z135_MCR_OUT1;
> +	if (mctrl & TIOCM_OUT2)
> +		conf_reg |= MEN_Z135_MCR_OUT2;
> +	if (mctrl & TIOCM_LOOP)
> +		conf_reg |= MEN_Z135_MCR_LOOP;
> +
> +	men_z135_reg_set(uart, MEN_Z135_CONF_REG, conf_reg);

What stops this and the tx thread trying to update CONF_REG at the same
moment ? (or indeed quite a few other cases)

Also for a register that's used a lot it may be much cheaper if you can
simply cache the current value so you never read it. That makes
updating it much cheaper.


> +static void men_z135_set_termios(struct uart_port *port,
> +				struct ktermios *termios,
> +				struct ktermios *old)
> +{

If you don't support CMSPAR (mark/space parity) then clear the
CMSPAR bit in the passed termios so userspace learns it was not accepted.

You've also btw got at least one "prot" where I think you meant "port" 8)

Alan
