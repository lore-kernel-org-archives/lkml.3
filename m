Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929AbaCUNG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:06:27 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:39138 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760098AbaCUNGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:06:23 -0400
Message-ID: <532C394A.3050408@hurleysoftware.com>
Date: Fri, 21 Mar 2014 09:06:18 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH resend] serial_core: Fix pm imbalance on unbind
References: <1395392905-29569-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1395392905-29569-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 05:08 AM, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>
> When a serial port is closed, uart_close() takes care of shutting down the
> hardware, and powering it down.
>
> When a serial port is unbound while in use, uart_close() bypasses all of
> this, as this is supposed to be done through uart_hangup() (invoked via
> tty_vhangup() in uart_remove_one_port()).
>
> However, uart_hangup() does not set the hardware's power state, leaving it
> powered up.  This may also lead to unbounded nesting counts in clock and
> power management, depending on their internal implementation.
>
> Make sure to power down the port in uart_hangup(), except when the port is
> used as a serial console. For serial consoles, this must be postponed until
> after their deregistration in uart_remove_one_port() (symmetry with
> registration in uart_configure_port(), invoked from uart_add_one_port()).
>
> After this, the module clock used by the sh-sci driver is disabled on
> unbind while the serial port is in use.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> ---
>   drivers/tty/serial/serial_core.c |    8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index 2cf5649a6dc0..56dda84f82a5 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -1452,6 +1452,8 @@ static void uart_hangup(struct tty_struct *tty)
>   		clear_bit(ASYNCB_NORMAL_ACTIVE, &port->flags);
>   		spin_unlock_irqrestore(&port->lock, flags);
>   		tty_port_tty_set(port, NULL);
> +		if (!uart_console(state->uart_port))
> +			uart_change_pm(state, UART_PM_STATE_OFF);

Ok.

>   		wake_up_interruptible(&port->open_wait);
>   		wake_up_interruptible(&port->delta_msr_wait);
>   	}
> @@ -2681,10 +2683,12 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
>   	}
>
>   	/*
> -	 * If the port is used as a console, unregister it
> +	 * If the port is used as a console, unregister it, and power it down
>   	 */
> -	if (uart_console(uport))
> +	if (uart_console(uport)) {
>   		unregister_console(uport->cons);
> +		uart_change_pm(state, UART_PM_STATE_OFF);

Won't this power off the port while tty consoles may still be open?
I think the right thing here is to unregister_console then set uport->cons = NULL

[uport->cons is properly reassigned when/if a port is re-added via
uart_add_one_port()).]

Then, uart_close() will power off the port when all ttys using the port have
been closed.

> +	}
>
>   	/*
>   	 * Free the port IO and memory resources, if any.
>

