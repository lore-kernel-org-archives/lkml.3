Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaCGQzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:55:22 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63562 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaCGQzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:55:20 -0500
MIME-Version: 1.0
Date: Fri, 7 Mar 2014 17:55:19 +0100
X-Google-Sender-Auth: -WgZfBpYhfDi2JdGmKZBkVeAveM
Message-ID: <CAMuHMdVV_NrQ3PPJwPNx7MoM9TWLdk02d+10zNipNcC7VC0HAA@mail.gmail.com>
Subject: serial core: crash / race condition on unbind
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When unbinding a serial driver, uart_remove_one_port() clears
uart_state.uart_port:

        state->uart_port = NULL;

If the serial port is still in use (e.g. by getty), uart_close() will be
called later:

        static void uart_close(struct tty_struct *tty, struct file *filp)
        {
                struct uart_state *state = tty->driver_data;
                struct uart_port *uport;

                ...

                if (!state)
                        return;

                uport = state->uart_port;

uport is NULL

                ...

                pr_debug("uart_close(%d) called\n", uport->line);

If debugging is enabled, it will already crash here while dereferencing uport
(this one is easily fixed)

                if (tty_port_close_start(port, tty, filp) == 0)
                        return;

                ...

                uart_flush_buffer(tty);

uart_flush_buffer() will try to obtain the port's spinlock:

        static void uart_flush_buffer(struct tty_struct *tty)
        {
                struct uart_state *state = tty->driver_data;
                struct uart_port *port;

                ...

                port = state->uart_port;

port is NULL

                ...

                spin_lock_irqsave(&port->lock, flags);

Crash!!

It doesn't always crash, though.

Sometimes uart_close() returns after the tty_port_close_start() above,
without a crash (bypassing e.g. the call to uart_change_pm() :-(
Sometimes it crashs in uart_chars_in_buffer(), which also tries to take the
spinlock:
    tty_port_close_start()
        tty_wait_until_sent_from_close()
            tty_wait_until_sent()
                tty_chars_in_buffer()
                    uart_chars_in_buffer()
                        spin_lock_irqsave(&state->uart_port->lock, flags);

I'm not that familiar with the internals of the serial core. Perhaps
uart_close()
should return early if uport is NULL, just like if state is NULL?
However, that means the uart_change_pm(state, UART_PM_STATE_OFF)
is bypassed again.

This is with sh-sci, but I don't think the driver matters.

Thanks for your comments and suggestions!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
