Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaCNME3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 08:04:29 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36309 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaCNME1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 08:04:27 -0400
Date: Fri, 14 Mar 2014 12:04:00 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH V3] serial/uart/8250: Add tunable RX interrupt trigger
 I/F of FIFO buffers
Message-ID: <20140314120400.4e17c47a@alan.etchedpixels.co.uk>
In-Reply-To: <20140314022154.4345.23024.stgit@yunodevel>
References: <20140314022154.4345.23024.stgit@yunodevel>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -2325,10 +2323,19 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
>  		if ((baud < 2400 && !up->dma) || fifo_bug) {
>  			fcr &= ~UART_FCR_TRIGGER_MASK;
>  			fcr |= UART_FCR_TRIGGER_1;
> +			/* Don't use user setting RX trigger */
> +			up->fcr = 0;

This breaks

	set fcr via sysfs
	set baud rate below 2400
	set baud rate higher

If baud < 2400 and the user has set a value then probably we should honour
it. If fifo_bug is set then we should never honour it (and should perhaps
eventually error it in the sysfs set).


> +static unsigned char convert_fcr2val(struct uart_8250_port *up,
> +				     unsigned char fcr)
> +{
> +	unsigned char val = 0, trig_raw = fcr & UART_FCR_TRIGGER_MASK;
> +
> +	switch (up->port.type) {
> +	case PORT_16550A:
> +		if (trig_raw == UART_FCR_R_TRIG_00)
> +			val = 1;
> +		else if (trig_raw == UART_FCR_R_TRIG_01)
> +			val = 4;
> +		else if (trig_raw == UART_FCR_R_TRIG_10)
> +			val = 8;
> +		else if (trig_raw == UART_FCR_R_TRIG_11)
> +			val = 14;
> +		break;

Surely the default case should be returning 1 not 0 ?


> +static int convert_val2rxtrig(struct uart_8250_port *up, unsigned char val)
> +{
> +	switch (up->port.type) {
> +	case PORT_16550A:
> +		if (val == 1)
> +			return UART_FCR_R_TRIG_00;
> +		else if (val == 4)
> +			return UART_FCR_R_TRIG_01;
> +		else if (val == 8)
> +			return UART_FCR_R_TRIG_10;
> +		else if (val == 14)
> +			return UART_FCR_R_TRIG_11;

What happens if you specify a meaningless value. Doing exact matching
means that you have to know the hardware exactly. How about

	if (val < 4)
		return UART_FCR_R_TRIG_00;
	else if (val < 8)
		return UART_FCR_R_TRIG_01;
	else if (val < 14)
		return UART_FCR_R_TRIG_10;
	else
		return UART_FCR_R_TRIG_11;

so you get the nearest lower value that the hardware can provide ?

> +		break;
> +	default:
> +		pr_info("Not support RX-trigger setting for this serial %u\n",
> +			up->port.type);

That lets users spew into the logs. I think actually you just want

	default:
		return -EOPNOTSUPP;

or similar



Otherwise this looks good to me. The interface is sensible, it can be
expanded easily to other devices and device types, and the logic looks
right.

Alan
