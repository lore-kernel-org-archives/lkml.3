Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbaJ3La6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:30:58 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44024 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759280AbaJ3Lay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:30:54 -0400
Message-ID: <54522163.8030408@linaro.org>
Date: Thu, 30 Oct 2014 11:30:43 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Frank Rowand <frank.rowand@sonymobile.com>
Subject: Re: [PATCH 2/2] tty: serial: msm: Support sysrq on uartDM devices
References: <1414606478-13709-1-git-send-email-sboyd@codeaurora.org> <1414606478-13709-3-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1414606478-13709-3-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/10/14 18:14, Stephen Boyd wrote:
> To properly support sysrq on uartDM hardware we need to properly
> handle break characters. With the DM hardware the fifo can pack 4
> characters at a time, where a break is indicated by an all zero
> byte. Unfortunately, we can't differentiate between an all zero
> byte for a break and an all zero byte of data, so try and do as
> best we can. First unmask the RX break start interrupt and record
> the interrupt when it arrives. Then while processing the fifo,
> detect the break by searching for an all zero character as long
> as we recently received an RX break start interrupt. This should
> make sysrq work fairly well.
> 
> Cc: Frank Rowand <frank.rowand@sonymobile.com>
> Cc: Daniel Thompson <daniel.thompson@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/tty/serial/msm_serial.c | 41 +++++++++++++++++++++++++++++++----------
>  drivers/tty/serial/msm_serial.h |  2 ++
>  2 files changed, 33 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
> index cedcc36762a2..d44c04976f7a 100644
> --- a/drivers/tty/serial/msm_serial.c
> +++ b/drivers/tty/serial/msm_serial.c
> @@ -54,6 +54,7 @@ struct msm_port {
>  	unsigned int		imr;
>  	int			is_uartdm;
>  	unsigned int		old_snap_state;
> +	bool			break_detected;
>  };
>  
>  static inline void wait_for_xmitr(struct uart_port *port)
> @@ -126,23 +127,38 @@ static void handle_rx_dm(struct uart_port *port, unsigned int misr)
>  
>  	while (count > 0) {
>  		unsigned char buf[4];
> +		int sysrq, r_count, i;
>  
>  		sr = msm_read(port, UART_SR);
>  		if ((sr & UART_SR_RX_READY) == 0) {
>  			msm_port->old_snap_state -= count;
>  			break;
>  		}
> +
>  		ioread32_rep(port->membase + UARTDM_RF, buf, 1);
> -		if (sr & UART_SR_RX_BREAK) {
> -			port->icount.brk++;
> -			if (uart_handle_break(port))
> -				continue;
> -		} else if (sr & UART_SR_PAR_FRAME_ERR)
> -			port->icount.frame++;
> +		r_count = min_t(int, count, sizeof(buf));
> +
> +		for (i = 0; i < r_count; i++) {
> +			char flag = TTY_NORMAL;
>  
> -		/* TODO: handle sysrq */
> -		tty_insert_flip_string(tport, buf, min(count, 4));
> -		count -= 4;
> +			if (msm_port->break_detected && buf[i] == 0) {
> +				port->icount.brk++;
> +				flag = TTY_BREAK;
> +				msm_port->break_detected = false;
> +				if (uart_handle_break(port))
> +					continue;
> +			}
> +
> +			if (!(port->read_status_mask & UART_SR_RX_BREAK))
> +				flag = TTY_NORMAL;

flag is already known to be TTY_NORMAL.


> +
> +			spin_unlock(&port->lock);

Is it safe to unlock at this point? count may no longer be valid when we
return.


> +			sysrq = uart_handle_sysrq_char(port, buf[i]);
> +			spin_lock(&port->lock);
> +			if (!sysrq)
> +				tty_insert_flip_char(tport, buf[i], flag);

flag has a constant value here.


> +		}
> +		count -= r_count;
>  	}
>  
>  	spin_unlock(&port->lock);
> @@ -291,6 +307,11 @@ static irqreturn_t msm_irq(int irq, void *dev_id)
>  	misr = msm_read(port, UART_MISR);
>  	msm_write(port, 0, UART_IMR); /* disable interrupt */
>  
> +	if (misr & UART_IMR_RXBREAK_START) {
> +		msm_port->break_detected = true;
> +		msm_write(port, UART_CR_CMD_RESET_RXBREAK_START, UART_CR);
> +	}
> +
>  	if (misr & (UART_IMR_RXLEV | UART_IMR_RXSTALE)) {
>  		if (msm_port->is_uartdm)
>  			handle_rx_dm(port, misr);
> @@ -496,7 +517,7 @@ static int msm_startup(struct uart_port *port)
>  
>  	/* turn on RX and CTS interrupts */
>  	msm_port->imr = UART_IMR_RXLEV | UART_IMR_RXSTALE |
> -			UART_IMR_CURRENT_CTS;
> +			UART_IMR_CURRENT_CTS | UART_IMR_RXBREAK_START;
>  
>  	if (msm_port->is_uartdm) {
>  		msm_write(port, 0xFFFFFF, UARTDM_DMRX);
> diff --git a/drivers/tty/serial/msm_serial.h b/drivers/tty/serial/msm_serial.h
> index 73d3abe71e79..3e1c7138d8cd 100644
> --- a/drivers/tty/serial/msm_serial.h
> +++ b/drivers/tty/serial/msm_serial.h
> @@ -65,6 +65,7 @@
>  #define UART_CR_TX_ENABLE		(1 << 2)
>  #define UART_CR_RX_DISABLE		(1 << 1)
>  #define UART_CR_RX_ENABLE		(1 << 0)
> +#define UART_CR_CMD_RESET_RXBREAK_START	((1 << 11) | (2 << 4))
>  
>  #define UART_IMR		0x0014
>  #define UART_IMR_TXLEV		(1 << 0)
> @@ -72,6 +73,7 @@
>  #define UART_IMR_RXLEV		(1 << 4)
>  #define UART_IMR_DELTA_CTS	(1 << 5)
>  #define UART_IMR_CURRENT_CTS	(1 << 6)
> +#define UART_IMR_RXBREAK_START	(1 << 10)
>  
>  #define UART_IPR_RXSTALE_LAST		0x20
>  #define UART_IPR_STALE_LSB		0x1F
> 

