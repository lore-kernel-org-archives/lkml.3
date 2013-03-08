Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab3CHH71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:59:27 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61812 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab3CHH70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:59:26 -0500
MIME-Version: 1.0
In-Reply-To: <1362658360-26629-8-git-send-email-jslaby@suse.cz>
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
	<1362658360-26629-8-git-send-email-jslaby@suse.cz>
Date: Fri, 8 Mar 2013 15:59:25 +0800
Message-ID: <CAJxxZ0OmBstKTes181ovji_mh2jdJTQzzDvYqXHdWNd7wqno4A@mail.gmail.com>
Subject: Re: [PATCH 08/16] TTY: serial/bfin_uart, unbreak build with KGDB enabled
From: Sonic Zhang <sonic.adi@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@linuxfoundation.org, peter@hurleysoftware.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Sonic Zhang <sonic.zhang@analog.com>

On Thu, Mar 7, 2013 at 8:12 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> There are no (and never were any) kgdb fields in uart_ops. Setting
> them produces a build error:
> drivers/tty/serial/bfin_uart.c:1054:2: error: unknown field 'kgdboc_port_startup' specified in initializer
> drivers/tty/serial/bfin_uart.c:1054:2: warning: initialization from incompatible pointer type [enabled by default]
> drivers/tty/serial/bfin_uart.c:1054:2: warning: (near initialization for 'bfin_serial_pops.ioctl') [enabled by default]
> drivers/tty/serial/bfin_uart.c:1055:2: error: unknown field 'kgdboc_port_shutdown' specified in initializer
> drivers/tty/serial/bfin_uart.c:1055:2: warning: initialization from incompatible pointer type [enabled by default]
> drivers/tty/serial/bfin_uart.c:1055:2: warning: (near initialization for 'bfin_serial_pops.poll_init') [enabled by default]
>
> Remove them.
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Sonic Zhang <sonic.zhang@analog.com>
> Cc: uclinux-dist-devel@blackfin.uclinux.org
> ---
>  drivers/tty/serial/bfin_uart.c | 23 -----------------------
>  1 file changed, 23 deletions(-)
>
> diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
> index 12dceda..26a3be7 100644
> --- a/drivers/tty/serial/bfin_uart.c
> +++ b/drivers/tty/serial/bfin_uart.c
> @@ -1011,24 +1011,6 @@ static int bfin_serial_poll_get_char(struct uart_port *port)
>  }
>  #endif
>
> -#if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
> -       defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
> -static void bfin_kgdboc_port_shutdown(struct uart_port *port)
> -{
> -       if (kgdboc_break_enabled) {
> -               kgdboc_break_enabled = 0;
> -               bfin_serial_shutdown(port);
> -       }
> -}
> -
> -static int bfin_kgdboc_port_startup(struct uart_port *port)
> -{
> -       kgdboc_port_line = port->line;
> -       kgdboc_break_enabled = !bfin_serial_startup(port);
> -       return 0;
> -}
> -#endif
> -
>  static struct uart_ops bfin_serial_pops = {
>         .tx_empty       = bfin_serial_tx_empty,
>         .set_mctrl      = bfin_serial_set_mctrl,
> @@ -1047,11 +1029,6 @@ static struct uart_ops bfin_serial_pops = {
>         .request_port   = bfin_serial_request_port,
>         .config_port    = bfin_serial_config_port,
>         .verify_port    = bfin_serial_verify_port,
> -#if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
> -       defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
> -       .kgdboc_port_startup    = bfin_kgdboc_port_startup,
> -       .kgdboc_port_shutdown   = bfin_kgdboc_port_shutdown,
> -#endif
>  #ifdef CONFIG_CONSOLE_POLL
>         .poll_put_char  = bfin_serial_poll_put_char,
>         .poll_get_char  = bfin_serial_poll_get_char,
> --
> 1.8.1.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
