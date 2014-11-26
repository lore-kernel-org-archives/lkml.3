Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaKZMlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:41:09 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:47207 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaKZMlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:41:06 -0500
Date: Wed, 26 Nov 2014 12:33:13 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: <grant.likely@linaro.org>, <robh+dt@kernel.org>, <catalin.marinas@arm.com>,
        <gregkh@linuxfoundation.org>, <ijc+devicetree@hellion.org.uk>,
        <jslaby@suse.cz>, <galak@codeaurora.org>, <broonie@linaro.org>,
        <mark.rutland@arm.com>, <m-karicheri2@ti.com>, <pawel.moll@arm.com>,
        <artagnon@gmail.com>, <rrichter@cavium.com>, <will.deacon@arm.com>,
        <arnd@arndb.de>, <corbet@lwn.net>, <jason@lakedaemon.net>,
        <broonie@kernel.org>, <heiko@sntech.de>, <shawn.guo@freescale.com>,
        <florian.vaussard@epfl.ch>, <andrew@lunn.ch>, <hytszk@gmail.com>,
        <orsonzhai@gmail.com>, <geng.ren@spreadtrum.com>,
        <zhizhou.zhang@spreadtrum.com>, <lanqing.liu@spreadtrum.com>,
        <zhang.lyra@gmail.com>, <wei.qiao@spreadtrum.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <sprdlinux@freelists.org>,
        <linux-doc@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <linux-api@vger.kernel.org>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Message-ID: <20141126123313.520ac83f@lxorguk.ukuu.org.uk>
In-Reply-To: <1416917818-10506-6-git-send-email-chunyan.zhang@spreadtrum.com>
References: <Sharkl64-v3>
	<1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<1416917818-10506-6-git-send-email-chunyan.zhang@spreadtrum.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +		 213 = /dev/ttySPX0		SPRD serial port 0
> +		    ...
> +		 216 = /dev/ttySPX3		SPRD serial port 3

Please use dynamic allocation or give a very very good reason why you
can't

> +config SERIAL_SPRD_NR
> +        int "Maximum number of sprd serial ports"
> +        depends on SERIAL_SPRD
> +        default "4"

If you are doing dynamic allocation this should pretty much go away


> +static int sprd_startup(struct uart_port *port)
> +{
> +	int ret = 0;
> +	unsigned int ien, ctrl1;
> +	struct sprd_uart_port *sp;
> +
> +	serial_out(port, SPRD_CTL2, ((THLD_TX_EMPTY << 8) | THLD_RX_FULL));
> +
> +	/* clear rx fifo */
> +	while (serial_in(port, SPRD_STS1) & 0x00ff)
> +		serial_in(port, SPRD_RXD);
> +
> +	/* clear tx fifo */
> +	while (serial_in(port, SPRD_STS1) & 0xff00)
> +		;

Missing a cpu_relax and I would have thought a timeout on both of these.


> +static void sprd_set_termios(struct uart_port *port,
> +				    struct ktermios *termios,
> +				    struct ktermios *old)
> +{
> +	unsigned int baud, quot;

> +	/* calculate parity */
> +	lcr &= ~SPRD_LCR_PARITY;
> +	if (termios->c_cflag & PARENB) {
> +		lcr |= SPRD_LCR_PARITY_EN;
> +		if (termios->c_cflag & PARODD)
> +			lcr |= SPRD_LCR_ODD_PAR;
> +		else
> +			lcr |= SPRD_LCR_EVEN_PAR;
> +	}

If you don't support mark/space parity then also clear CMSPAR in
termios->c_cflag. If you do then it ought to be handled above.

> +
> +	/* clock divider bit16~bit20 */
> +	serial_out(port, SPRD_CLKD1, (quot & 0x1f0000) >> 16);
> +	serial_out(port, SPRD_LCR, lcr);
> +	fc |= 0x3e00 | THLD_RX_FULL;
> +	serial_out(port, SPRD_CTL1, fc);

Also set the resulting baud back into the termios (see the 8250 termios
for an example)


> +static int __init sprd_console_setup(struct console *co, char *options)
> +{
> +	struct uart_port *port;
> +	int baud = 115200;
> +	int bits = 8;
> +	int parity = 'n';
> +	int flow = 'n';
> +
> +	if (unlikely(co->index >= UART_NR_MAX || co->index < 0))
> +		co->index = 0;
> +
> +	port = (struct uart_port *)sprd_port[co->index];
> +	if (port == NULL) {
> +		pr_info("srial port %d not yet initialized\n", co->index);

Typo

Looks basically sound to me

Alan
