Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaCNOQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:16:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:16835 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbaCNOQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:16:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,655,1389772800"; 
   d="scan'208";a="498552570"
Date: Fri, 14 Mar 2014 16:16:02 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan <gnomes@lxorguk.ukuu.org.uk>, Stephen Warren <swarren@nvidia.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH V3] serial/uart/8250: Add tunable RX interrupt trigger
 I/F of FIFO buffers
Message-ID: <20140314141602.GA11603@xps8300>
References: <20140314022154.4345.23024.stgit@yunodevel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314022154.4345.23024.stgit@yunodevel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Mar 14, 2014 at 11:21:54AM +0900, Yoshihiro YUNOMAE wrote:
>  void serial8250_clear_and_reinit_fifos(struct uart_8250_port *p)
>  {
> -	unsigned char fcr;
> -
>  	serial8250_clear_fifos(p);
> -	fcr = uart_config[p->port.type].fcr;
> -	serial_out(p, UART_FCR, fcr);
> +	p->fcr = uart_config[p->port.type].fcr;
> +	serial_out(p, UART_FCR, p->fcr);

You should allow also the probe drivers to set this..

        if (!p->fcr)
                p->fcr = uart_config[p->port.type].fcr;

>  }
>  EXPORT_SYMBOL_GPL(serial8250_clear_and_reinit_fifos);
>  
> @@ -2325,10 +2323,19 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
>  		if ((baud < 2400 && !up->dma) || fifo_bug) {
>  			fcr &= ~UART_FCR_TRIGGER_MASK;
>  			fcr |= UART_FCR_TRIGGER_1;
> +			/* Don't use user setting RX trigger */
> +			up->fcr = 0;

I don't know about this but..

>  		}
>  	}
>  
>  	/*
> +	 * If up->fcr exists, a user has opened this port, changed RX trigger,
> +	 * or read RX trigger before. So, we don't need to change up->fcr here.
> +	 */
> +	if (!up->fcr)
> +		up->fcr = fcr;

Why not just set fcr = up->fcr in the beginning of the function?

<snip>

> +static int do_set_rx_int_trig(struct tty_port *port, unsigned char val)
> +{
> +	struct uart_state *state = container_of(port, struct uart_state, port);
> +	struct uart_port *uport = state->uart_port;
> +	struct uart_8250_port *up =
> +		container_of(uport, struct uart_8250_port, port);
> +	unsigned char fcr;
> +	int rx_trig;
> +
> +	if (!(up->capabilities & UART_CAP_FIFO) || uport->fifosize <= 1)
> +		return -EINVAL;
> +
> +	rx_trig = convert_val2rxtrig(up, val);
> +	if (rx_trig < 0)
> +		return rx_trig;
> +
> +	serial8250_clear_fifos(up);
> +	if (!up->fcr)
> +		/* termios is not set yet */
> +		fcr = uart_config[up->port.type].fcr;
> +	else
> +		fcr = up->fcr;
> +	fcr &= ~UART_FCR_TRIGGER_MASK;
> +	fcr |= (unsigned char)rx_trig;
> +	up->fcr = fcr;
> +	serial_out(up, UART_FCR, up->fcr);
> +	return 0;
> +}

Where are you setting UART_FCR_ENABLE_FIFO bit? Am I missing
something?

> diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
> index af47a8a..2ce1152 100644
> --- a/include/linux/serial_8250.h
> +++ b/include/linux/serial_8250.h
> @@ -76,6 +76,7 @@ struct uart_8250_port {
>  	unsigned short		bugs;		/* port bugs */
>  	unsigned int		tx_loadsz;	/* transmit fifo load size */
>  	unsigned char		acr;
> +	unsigned char		fcr;

I do like to see fcr being added here, but because of a different
reason. I want to be able to set it from the probe drivers.

Br,

-- 
heikki
