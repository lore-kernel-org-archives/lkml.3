Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaCUUaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 16:30:06 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:41323 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750799AbaCUU37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 16:29:59 -0400
Message-ID: <532CA142.8060705@hurleysoftware.com>
Date: Fri, 21 Mar 2014 16:29:54 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH 2/2] [RFC] serial_core: Avoid NULL pointer dereference
 in uart_close()
References: <1395061859-15295-1-git-send-email-geert@linux-m68k.org> <1395061859-15295-2-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1395061859-15295-2-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 09:10 AM, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>
> When unbinding a serial driver that's being used as a serial console,
> the kernel may crash with a NULL pointer dereference in a uart_*() function
> called from uart_close () (e.g. uart_flush_buffer() or
> uart_chars_in_buffer()).
>
> To fix this, let uart_close() check for port->count == 0. If this is the
> case, bail out early. Else tty_port_close_start() will make the port
> counts inconsistent, printing out warnings like
>
>      tty_port_close_start: tty->count = 1 port count = 0.
>
> and
>
>      tty_port_close_start: count = -1

As you noted in the patch comments below, the tty core always closes
a failed open.

So the reason for the port->count mismatch is because tty_port_close_start()
only handles the tty hangup condition -- all other failed opens are assumed
to carry a port->count.

A similar mismatch will occur if the mutex_lock in uart_open() is
interrupted.

This means that the port->count mismatch can occur even if port->count != 0;
so the bug here is that uart_open() and uart_close() don't agree on
who does what cleanup under what error conditions.

So with respect to the port count mismatches, the conditions need careful
auditing and fixing, separate from the tty console teardown problem.

> and once uport == NULL, it will also crash.

Ok, but so will basically every serial core function after
uart_remove_one_port() assigns state->uart_port = NULL

IOW, uart_close() is not the only serial core function that could be
using state->uart_port after uart_remove_one_port() finishes.

> Also fix the related crash in pr_debug() by checking for a non-NULL uport
> first.

So my point is that checking for NULL state->uart_port is simply not the fix,
here or anywhere else.

AFAICT, either reference-counting the uart_port structure or RCU
are the only viable solutions to safe ll driver uart_port removal.

Regards,
Peter Hurley

> Detailed description:
>
> On driver unbind, uart_remove_one_port() is called. Basically it;
>    - marks the port dead,
>    - calls tty_vhangup(),
>    - sets state->uart_port = NULL.
>
> What will happen depends on whether the port is just in use by e.g. getty,
> or was also opened as a console.
>
> A. If the tty was not opened as a console:
>
>    - tty_vhangup() will (in __tty_hangup()):
>        - mark all file descriptors for this tty hung up by pointing them to
> 	hung_up_tty_fops,
>        - call uart_hangup(), which sets port->count to 0.
>
>    - A subsequent uart_open() (this may be through /dev/ttyS*, or through
>      /dev/console if this is a serial console) will fail with -ENXIO as the
>      port was marked dead,
>    - uart_close() after the failed uart_open() will return early, as
>      tty_hung_up_p() (called from tty_port_close_start()) will notice it was
>      hung up.
>
> B. If the tty was also opened as a console:
>
>    - tty_vhangup() will (in __tty_hangup()):
>        - mark non-console file descriptors for this tty hung up by pointing
> 	them to hung_up_tty_fops,
>        - NOT call uart_hangup(), but instead call uart_close() for every
>          non-console file descriptor, so port->count will still have a
> 	non-zero value afterwards.
>
>    - A subsequent uart_open() will fail with -ENXIO as the port was
>      marked dead,
>    - uart_close() after the failed uart_open() starts to misbehave:
>        - tty_hung_up_p() will not notice it was hung up,
>        - As port->count is non-zero, tty_port_close_start() will decrease
>          port->count, making the tty and port counts inconsistent. Later,
> 	warnings like these will be printed:
>
> 	    tty_port_close_start: tty->count = 1 port count = 0.
>
> 	and
> 	    tty_port_close_start: count = -1
>
>        - If all of this happens after state->uart_port was set to zero, a
>          NULL pointer dereference will happen.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> ---
> This still doesn't fix everything, but avoids the NULL pointer dereference.
>
> In case B, port->count is still non-zero after tty_vhangup().  Hence when
> uart_close() is called after a failed uart_open(), it will decrement
> port->count, and, on reaching zero, it will close the port for real (incl.
> calling uart_shutdown()).  This doesn't seem to cause any harm, though.
> Besides, if uart_close() wouldn't do that, who else would shut down the
> port?
>
> As tty_open() always calls tty_release() on failure of ->open(),
> ->close() is always called.
> How can uart_close() after a failed uart_open() know it should not do
> anything? Set a (new) flag in its port structure?
> ---
>   drivers/tty/serial/serial_core.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index 21084f0b8ea4..56dda84f82a5 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -1319,9 +1319,9 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
>   	uport = state->uart_port;
>   	port = &state->port;
>
> -	pr_debug("uart_close(%d) called\n", uport->line);
> +	pr_debug("uart_close(%d) called\n", uport ? uport->line : -1);
>
> -	if (tty_port_close_start(port, tty, filp) == 0)
> +	if (!port->count || tty_port_close_start(port, tty, filp) == 0)
>   		return;
>
>   	/*
>

