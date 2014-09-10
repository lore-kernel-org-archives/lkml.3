Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaIJTxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:53:06 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:38140 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751044AbaIJTxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:53:03 -0400
Message-ID: <5410AC1B.9000700@hurleysoftware.com>
Date: Wed, 10 Sep 2014 15:52:59 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jiri Slaby <jslaby@suse.cz>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] tty: serial: core: Only invoke ->start_tx() if there
 is data to send
References: <1410377601-26794-1-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1410377601-26794-1-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 03:33 PM, Sebastian Andrzej Siewior wrote:
> I noticed that the serial8250_tx_dma() is invoked sometimes while
> uart_circ_empty() says that the buffer is empty.
> 
> I tracked one occuring down to:
> 
> n_tty_write()
> 	 => O_OPOST(tty))
> 	   => the while loop did something but neither tty's ->write()
> 	      nor its ->uart_put_char() callback was invoked().
> 	   => tty->ops->flush_chars() is invoked with an empty buffer.
> 
> For the 8250 uart driver we end up with:
> - DMA enabled
>   nothing, just return (except there is DMA_TX bug or runtime-PM then we
>   behave like in the no DMA case)
> 
> - no DMA
>   enable THRI interrupt, wait for it, disable THRI interrupt again
>   because there is nothing to be done.
> 
> While I don't know if it safe to drop that flush in n_tty if the buffer
> is empty, it should not do any harm in serial's core part to not invoke
> ->start_tx() if the buffer is empty.

The serial core can't assume that start_tx() does not need invoking
because hardware that can stop_tx() with data in the transmitter
won't restart if the ring buffer is empty but data is still in the
transmitter. [Note that the 16C950 port type does this in the 8250 driver.]

So this has to be handled in the 8250 driver.

What is the actual issue? Are you trying not to unnecessarily wake
the omap hardware if runtime-PM is on?

Regards,
Peter Hurley

> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/tty/serial/serial_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index 5a78f6940760..e55724a911d5 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -90,7 +90,8 @@ static void __uart_start(struct tty_struct *tty)
>  	struct uart_state *state = tty->driver_data;
>  	struct uart_port *port = state->uart_port;
>  
> -	if (!tty->stopped && !tty->hw_stopped)
> +	if (!tty->stopped && !tty->hw_stopped &&
> +			!uart_circ_empty(&port->state->xmit))
>  		port->ops->start_tx(port);
>  }
>  
> 

