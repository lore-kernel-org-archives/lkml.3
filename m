Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaIIA3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 20:29:47 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:33964 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754940AbaIIA3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 20:29:44 -0400
Message-ID: <540E49F2.5010909@hurleysoftware.com>
Date: Mon, 08 Sep 2014 20:29:38 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/26] serial: core: Privatize tty->hw_stopped
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com> <1409693975-1028-18-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1409693975-1028-18-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2014 05:39 PM, Peter Hurley wrote:
> tty->hw_stopped is not used by the tty core and is thread-unsafe;
> hw_stopped is a member of a bitfield whose fields are updated
> non-atomically and no lock is suitable for serializing updates.
> 
> Replace serial core usage of tty->hw_stopped with uport->hw_stopped.
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/serial/bfin_uart.c   | 14 +++++++-------
>  drivers/tty/serial/serial_core.c | 28 +++++++++++++---------------
>  include/linux/serial_core.h      |  3 ++-
>  3 files changed, 22 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
> index dec0fd7..fc9fbf3 100644
> --- a/drivers/tty/serial/bfin_uart.c
> +++ b/drivers/tty/serial/bfin_uart.c
> @@ -108,22 +108,22 @@ static void bfin_serial_set_mctrl(struct uart_port *port, unsigned int mctrl)
>  static irqreturn_t bfin_serial_mctrl_cts_int(int irq, void *dev_id)
>  {
>  	struct bfin_serial_port *uart = dev_id;
> -	unsigned int status = bfin_serial_get_mctrl(&uart->port);
> +	struct uart_port *uport = &uart->port;
> +	unsigned int status = bfin_serial_get_mctrl(uport);
>  #ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
> -	struct tty_struct *tty = uart->port.state->port.tty;
>  
>  	UART_CLEAR_SCTS(uart);
> -	if (tty->hw_stopped) {
> +	if (uport->hw_stopped) {
>  		if (status) {
> -			tty->hw_stopped = 0;
> -			uart_write_wakeup(&uart->port);
> +			uport->hw_stopped = 0;
> +			uart_write_wakeup(uport);
>  		}
>  	} else {
>  		if (!status)
> -			tty->hw_stopped = 1;
> +			uport->hw_stopped = 1;
>  	}
>  #endif
> -	uart_handle_cts_change(&uart->port, status & TIOCM_CTS);
> +	uart_handle_cts_change(uport, status & TIOCM_CTS);
>  
>  	return IRQ_HANDLED;
>  }
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index 288dc2e..95277a2 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -94,7 +94,7 @@ static void __uart_start(struct tty_struct *tty)
>  	struct uart_state *state = tty->driver_data;
>  	struct uart_port *port = state->uart_port;
>  
> -	if (!tty->stopped && !tty->hw_stopped)
> +	if (!uart_tx_stopped(port))
>  		port->ops->start_tx(port);
>  }
>  
> @@ -180,10 +180,11 @@ static int uart_port_startup(struct tty_struct *tty, struct uart_state *state,
>  		}
>  
>  		spin_lock_irq(&uport->lock);
> -		if (uart_cts_enabled(uport)) {
> -			if (!(uport->ops->get_mctrl(uport) & TIOCM_CTS))
> -				tty->hw_stopped = 1;
> -		}
> +		if (uart_cts_enabled(uport) &&
> +		    !(uport->ops->get_mctrl(uport) & TIOCM_CTS))
> +			uport->hw_stopped = 1;
> +		else
> +			uport->hw_stopped = 0;
>  		spin_unlock_irq(&uport->lock);
>  	}
>  
> @@ -944,7 +945,7 @@ static int uart_get_lsr_info(struct tty_struct *tty,
>  	 */
>  	if (uport->x_char ||
>  	    ((uart_circ_chars_pending(&state->xmit) > 0) &&
> -	     !tty->stopped && !tty->hw_stopped))
> +	     !uart_tx_stopped(uport)))
>  		result &= ~TIOCSER_TEMT;
>  
>  	return put_user(result, value);
> @@ -1290,7 +1291,7 @@ static void uart_set_termios(struct tty_struct *tty,
>  
>  	/*
>  	 * If the port is doing h/w assisted flow control, do nothing.
> -	 * We assume that tty->hw_stopped has never been set.
> +	 * We assume that port->hw_stopped has never been set.
>  	 */
>  	if (uport->flags & UPF_HARD_FLOW)
>  		return;
> @@ -1298,7 +1299,7 @@ static void uart_set_termios(struct tty_struct *tty,
>  	/* Handle turning off CRTSCTS */
>  	if ((old_termios->c_cflag & CRTSCTS) && !(cflag & CRTSCTS)) {
>  		spin_lock_irqsave(&uport->lock, flags);
> -		tty->hw_stopped = 0;
> +		uport->hw_stopped = 0;
>  		__uart_start(tty);
>  		spin_unlock_irqrestore(&uport->lock, flags);
>  	}
> @@ -1306,7 +1307,7 @@ static void uart_set_termios(struct tty_struct *tty,
>  	else if (!(old_termios->c_cflag & CRTSCTS) && (cflag & CRTSCTS)) {
>  		spin_lock_irqsave(&uport->lock, flags);
>  		if (!(uport->ops->get_mctrl(uport) & TIOCM_CTS)) {
> -			tty->hw_stopped = 1;
> +			uport->hw_stopped = 1;
>  			uport->ops->stop_tx(uport);
>  		}
>  		spin_unlock_irqrestore(&uport->lock, flags);
> @@ -2776,23 +2777,20 @@ EXPORT_SYMBOL_GPL(uart_handle_dcd_change);
>   */
>  void uart_handle_cts_change(struct uart_port *uport, unsigned int status)
>  {
> -	struct tty_port *port = &uport->state->port;
> -	struct tty_struct *tty = port->tty;
> -
>  	warn_not_spin_locked(&uport->lock);
>  
>  	uport->icount.cts++;
>  
>  	if (uart_cts_enabled(uport)) {
> -		if (tty->hw_stopped) {
> +		if (uport->hw_stopped) {
>  			if (status) {
> -				tty->hw_stopped = 0;
> +				uport->hw_stopped = 0;
>  				uport->ops->start_tx(uport);
>  				uart_write_wakeup(uport);
>  			}
>  		} else {
>  			if (!status) {
> -				tty->hw_stopped = 1;
> +				uport->hw_stopped = 1;
>  				uport->ops->stop_tx(uport);
>  			}
>  		}
> diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
> index bc70048..c87aaf8 100644
> --- a/include/linux/serial_core.h
> +++ b/include/linux/serial_core.h
> @@ -195,6 +195,7 @@ struct uart_port {
>  #define UPSTAT_CTS_ENABLE	((__force upstat_t) (1 << 0))
>  #define UPSTAT_DCD_ENABLE	((__force upstat_t) (1 << 1))
>  
> +	bool			hw_stopped;		/* sw-assisted CTS flow state */

This is fragile on Alpha as well (byte storage) in structure with
mixed cpu contexts.

Regards,
Peter Hurley

>  	unsigned int		mctrl;			/* current modem ctrl settings */
>  	unsigned int		timeout;		/* character-based timeout */
>  	unsigned int		type;			/* port type */
> @@ -353,7 +354,7 @@ int uart_resume_port(struct uart_driver *reg, struct uart_port *port);
>  static inline int uart_tx_stopped(struct uart_port *port)
>  {
>  	struct tty_struct *tty = port->state->port.tty;
> -	if(tty->stopped || tty->hw_stopped)
> +	if (tty->stopped || port->hw_stopped)
>  		return 1;
>  	return 0;
>  }
> 

