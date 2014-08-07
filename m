Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbaHGP30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:29:26 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:43181 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932071AbaHGP3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:29:25 -0400
Message-ID: <53E39B44.60406@hurleysoftware.com>
Date: Thu, 07 Aug 2014 11:29:08 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH v2] serial: uart: add hw flow control support configuration
References: <1398971093-17164-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1398971093-17164-1-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 03:04 PM, Murali Karicheri wrote:
> 8250 uart driver currently supports only software assisted hw flow
> control. The software assisted hw flow control maintains a hw_stopped
> flag in the tty structure to stop and start transmission and use modem
> status interrupt for the event to drive the handshake signals. This is
> not needed if hw has flow control capabilities. This patch adds a
> DT attribute for enabling hw flow control for a uart port. Also skip
> stop and start if this flag is present in flag field of the port
> structure.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> 
> CC: Rob Herring <robh+dt@kernel.org>
> CC: Pawel Moll <pawel.moll@arm.com>
> CC: Mark Rutland <mark.rutland@arm.com>
> CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
> CC: Kumar Gala <galak@codeaurora.org>
> CC: Randy Dunlap <rdunlap@infradead.org>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: Jiri Slaby <jslaby@suse.cz>
> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  .../devicetree/bindings/serial/of-serial.txt       |    1 +
>  drivers/tty/serial/8250/8250_core.c                |    6 ++++--
>  drivers/tty/serial/of_serial.c                     |    4 ++++
>  drivers/tty/serial/serial_core.c                   |   12 +++++++++---
>  4 files changed, 18 insertions(+), 5 deletions(-)
> 

[...]

> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index b68550d..851707a 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -174,8 +174,12 @@ static int uart_port_startup(struct tty_struct *tty, struct uart_state *state,
>  			if (tty->termios.c_cflag & CBAUD)
>  				uart_set_mctrl(uport, TIOCM_RTS | TIOCM_DTR);
>  		}
> -
> -		if (tty_port_cts_enabled(port)) {
> +		/*
> +		 * if hw support flow control without software intervention,
> +		 * then skip the below check
> +		 */
> +		if (tty_port_cts_enabled(port) &&
> +		    !(uport->flags & UPF_HARD_FLOW)) {
>  			spin_lock_irq(&uport->lock);
>  			if (!(uport->ops->get_mctrl(uport) & TIOCM_CTS))
>  				tty->hw_stopped = 1;
> @@ -2772,7 +2776,9 @@ void uart_handle_cts_change(struct uart_port *uport, unsigned int status)
>  
>  	uport->icount.cts++;
>  
> -	if (tty_port_cts_enabled(port)) {
> +	/* skip below code if the hw flow control is supported */
> +	if (tty_port_cts_enabled(port) &&
> +	    !(uport->flags & UPF_HARD_FLOW)) {

Why is a modem status interrupt being generated for DCTS
if autoflow control is enabled?

This should be:

	WARN_ON_ONCE(uport->flags & UPF_HARD_FLOW);

to indicate a mis-configured driver/device.

>  		if (tty->hw_stopped) {
>  			if (status) {
>  				tty->hw_stopped = 0;
> 

