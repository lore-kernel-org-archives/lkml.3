Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3FJJgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:36:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40639 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3FJJgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:36:13 -0400
Date: Mon, 10 Jun 2013 10:35:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Prisk <linux@prisktech.co.nz>
Subject: Re: [PATCH v2 01/11] serial:st-asc: Add ST ASC driver.
Message-ID: <20130610093511.GT18614@n2100.arm.linux.org.uk>
References: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com> <1370856060-6403-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370856060-6403-1-git-send-email-srinivas.kandagatla@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 10:21:00AM +0100, Srinivas KANDAGATLA wrote:
> This patch adds support to ASC (asynchronous serial controller)
> driver, which is basically a standard serial driver. This IP is common
> across all the ST parts for settop box platforms.
> 
> ASC is embedded in ST COMMS IP block. It supports Rx & Tx functionality.
> It support all industry standard baud rates.

Your driver is not POSIX compliant.

> +		for (; count != 0; count--) {
> +			c = asc_in(port, ASC_RXBUF);
> +			flag = TTY_NORMAL;
> +			port->icount.rx++;
> +
> +			if (unlikely(c & ASC_RXBUF_FE)) {
> +				if (c == ASC_RXBUF_FE) {
> +					port->icount.brk++;
> +					if (uart_handle_break(port))
> +						continue;
> +					flag = TTY_BREAK;
> +				} else {
> +					port->icount.frame++;
> +					flag = TTY_FRAME;
> +				}
> +			} else if (ascport->check_parity &&
> +				   unlikely(c & ASC_RXBUF_PE)) {
> +				port->icount.parity++;
> +				flag = TTY_PARITY;
> +			}
> +
> +			if (uart_handle_sysrq_char(port, c))
> +				continue;
> +			tty_insert_flip_char(tport, c & 0xff, flag);
> +		}
> +		if (overrun) {
> +			port->icount.overrun++;
> +			tty_insert_flip_char(tport, 0, TTY_OVERRUN);
> +		}

No support for ignoring error conditions.  No support for ignoring all
input... and:

> +static void asc_set_termios(struct uart_port *port, struct ktermios *termios,
> +			    struct ktermios *old)
> +{
> +	struct asc_port *ascport = to_asc_port(port);
> +	unsigned int baud;
> +	u32 ctrl_val;
> +	tcflag_t cflag;
> +	unsigned long flags;
> +
> +	port->uartclk = clk_get_rate(ascport->clk);
> +
> +	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16);
> +	cflag = termios->c_cflag;
> +
> +	spin_lock_irqsave(&port->lock, flags);
> +
> +	/* read control register */
> +	ctrl_val = asc_in(port, ASC_CTL);
> +
> +	/* stop serial port and reset value */
> +	asc_out(port, ASC_CTL, (ctrl_val & ~ASC_CTL_RUN));
> +	ctrl_val = ASC_CTL_RXENABLE | ASC_CTL_FIFOENABLE;
> +
> +	/* reset fifo rx & tx */
> +	asc_out(port, ASC_TXRESET, 1);
> +	asc_out(port, ASC_RXRESET, 1);
> +
> +	/* set character length */
> +	if ((cflag & CSIZE) == CS7) {
> +		ctrl_val |= ASC_CTL_MODE_7BIT_PAR;
> +	} else {
> +		ctrl_val |= (cflag & PARENB) ?  ASC_CTL_MODE_8BIT_PAR :
> +						ASC_CTL_MODE_8BIT;
> +	}
> +
> +	ascport->check_parity = (cflag & PARENB) ? 1 : 0;
> +
> +	/* set stop bit */
> +	ctrl_val |= (cflag & CSTOPB) ? ASC_CTL_STOP_2BIT : ASC_CTL_STOP_1BIT;
> +
> +	/* odd parity */
> +	if (cflag & PARODD)
> +		ctrl_val |= ASC_CTL_PARITYODD;
> +
> +	/* hardware flow control */
> +	if ((cflag & CRTSCTS) && ascport->hw_flow_control)
> +		ctrl_val |= ASC_CTL_CTSENABLE;

This doesn't reflect those facts back into the termios structure to
indicate that they aren't supported.

Consider using uart_port's ignore and read status masks to implement
the break, framing, parity and overrun checking in your interrupt
handler using the same methodology as drivers like 8250, amba-pl011
etc.  That will help you get these code sequences correct.
