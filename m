Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbaCKBHC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 21:07:02 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:37233 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754665AbaCKBG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 21:06:58 -0400
Message-ID: <531E61AC.6040706@hurleysoftware.com>
Date: Mon, 10 Mar 2014 21:06:52 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-serial@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2] serial_core: Unregister console in uart_remove_one_port()
References: <1393593694-30262-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1393593694-30262-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +cc Alan ]

On 02/28/2014 08:21 AM, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>
> If the serial port being removed is used as a console, it must also be
> unregistered from the console subsystem using unregister_console().
>
> uart_ops.release_port() will release resources (e.g. iounmap() the serial
> port registers), causing a crash on subsequent kernel output if the console
> is still registered.

This brings up an interesting point:  where are the serial_core drivers
indicating to the tty core that the port is bound to a console?
IOW, I cannot find a single 'port->console = 1' anywhere in the serial tree.

It would be bad if the uart port disappears while a console is running
on it...

> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> ---
>   drivers/tty/serial/serial_core.c |    6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
> index ece2049bd270..8ece7f14d89d 100644
> --- a/drivers/tty/serial/serial_core.c
> +++ b/drivers/tty/serial/serial_core.c
> @@ -2677,6 +2677,12 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
>   		tty_vhangup(port->tty);
>
>   	/*
> +	 * If the port is used as a console, unregister it
> +	 */
> +	if (uart_console(uport))
> +		unregister_console(uport->cons);
> +
> +	/*
>   	 * Free the port IO and memory resources, if any.
>   	 */
>   	if (uport->type != PORT_UNKNOWN)
>

