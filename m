Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbaCJUsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:48:52 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:49543 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbaCJUst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:48:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVV_NrQ3PPJwPNx7MoM9TWLdk02d+10zNipNcC7VC0HAA@mail.gmail.com>
References: <CAMuHMdVV_NrQ3PPJwPNx7MoM9TWLdk02d+10zNipNcC7VC0HAA@mail.gmail.com>
Date: Mon, 10 Mar 2014 21:48:49 +0100
X-Google-Sender-Auth: 1Ecw75kzdKjAfXG8mXWTIbHA_6s
Message-ID: <CAMuHMdVwpQEWAVHA5BO2xXzaNc1DTdteDMWFHQ=MFJoo4Afm_A@mail.gmail.com>
Subject: Re: serial core: crash / race condition on unbind
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 5:55 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> When unbinding a serial driver, uart_remove_one_port() clears
> uart_state.uart_port:
>
>         state->uart_port = NULL;
>
> If the serial port is still in use (e.g. by getty), uart_close() will be
> called later:

After more digging into the code, uart_close() is supposed to be
called "before",
not "later".

uart_remove_one_port() does:

        /*
         * Remove the devices from the tty layer
         */
        tty_unregister_device(drv->tty_driver, uport->line);

i.e. remove the port, so there will be no new users?

        if (port->tty)
                tty_vhangup(port->tty);

tty_vhangup() will:
  - set all relevant filp->f_op to &hung_up_tty_fops, so uart_close()
    will notice the port has been closed,
  - call uart_hangup(),
  - call uart_close().

        [...]

        /*
         * Indicate that there isn't a port here anymore.
         */
        uport->type = PORT_UNKNOWN;

        state->uart_port = NULL;

only here uart_port is set to NULL, after uart_close() has already been called.

>         static void uart_close(struct tty_struct *tty, struct file *filp)
>         {
>                 struct uart_state *state = tty->driver_data;
>                 struct uart_port *uport;
>
>                 ...
>
>                 if (!state)
>                         return;
>
>                 uport = state->uart_port;
>
> uport is NULL
>
>                 ...
>
>                 pr_debug("uart_close(%d) called\n", uport->line);
>
> If debugging is enabled, it will already crash here while dereferencing uport
> (this one is easily fixed)
>
>                 if (tty_port_close_start(port, tty, filp) == 0)
>                         return;
>
>                 ...
>
>                 uart_flush_buffer(tty);
>
> uart_flush_buffer() will try to obtain the port's spinlock:
>
>         static void uart_flush_buffer(struct tty_struct *tty)
>         {
>                 struct uart_state *state = tty->driver_data;
>                 struct uart_port *port;
>
>                 ...
>
>                 port = state->uart_port;
>
> port is NULL
>
>                 ...
>
>                 spin_lock_irqsave(&port->lock, flags);
>
> Crash!!
>
> It doesn't always crash, though.
>
> Sometimes uart_close() returns after the tty_port_close_start() above,

This is the expected behavior, as filp->f_op == &hung_up_tty_fops
(set from tty_vhangup() et al.).

> without a crash (bypassing e.g. the call to uart_change_pm() :-(

(The bypassing is normal: shutdown of the port is done in uart_hangup()
 (called from tty_vhangup() et al.).
 For the lack of calling uart_change_pm(), see my "[PATCH/RFC] serial_core:
 Fix pm imbalance on unbind", https://lkml.org/lkml/2014/3/10/496))

However, what I'm seeing is that there are several calls to uart_close()
where filp->f_op != &hung_up_tty_fops. Hence uart_close() doesn't abort
after tty_port_close_start(). Shouldn't the call to tty_unregister_device()
prevent these from happening?

I can easily widen the race window by adding an msleep() after the call to
tty_vhangup() in uart_remove_one_port().

Then I start getting the warnings printed by tty_port_close_start():
    tty_port_close_start: tty->count = 1 port count = 2.
    tty_port_close_start: tty->count = 1 port count = 0.

How come there's a port count mismatch?

If any of these happen when state->uart_port is already NULL, the kernel
crashes (fortunately not deadly, as I'm left without a serial console):

tty_port_close_start: tty->count = 1 port count = 2.
console [ttySC6] disabled
tty_port_close_start: tty->count = 1 port count = 0.
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 17 [#1] SMP ARM
Modules linked in:
CPU: 0 PID: 1333 Comm: getty Not tainted
3.14.0-rc5-koelsch-00343-g2fccf32beb8d-dirty #552
task: ee519b40 ti: ee474000 task.ti: ee474000
PC is at _raw_spin_lock_irqsave+0x1c/0x54
LR is at uart_flush_buffer+0x38/0x7c
pc : [<c0349254>]    lr : [<c01ff008>]    psr: a00f0093
sp : ee475e10  ip : ee475e20  fp : ee475e1c
r10: ee808760  r9 : 00000000  r8 : eee3061c
r7 : 00000000  r6 : eee305b8  r5 : 00000000  r4 : ee441c00
r3 : 00000000  r2 : 08000000  r1 : eee3064c  r0 : a00f0013
Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 10c5347d  Table: 6e5a006a  DAC: 00000015
Process getty (pid: 1333, stack limit = 0xee474240)
Stack: (0xee475e10 to 0xee476000)
5e00:                                     ee475e3c ee475e20 c01ff008 c0349244
5e20: eee305b8 eee30654 ee441c00 00000000 ee475e64 ee475e40 c01ff1c4 c01fefdc
5e40: ee441c00 00000000 00000008 00000006 eee61800 ee808760 ee475edc ee475e68
5e60: c01e6c4c c01ff134 ee475e8c ee475e78 ee461c00 eefa6a80 ee97fcd8 ee461400
5e80: ee475eac ee475e90 ee475ea4 ee475e98 c00681a4 c006817c ee475ecc ee475ea8
5ea0: 00000000 ee9a3980 00000000 00000000 eec33ed0 eee61800 eed8fad8 00000008
5ec0: eee61808 00000000 eec33e10 ee808760 ee475f14 ee475ee0 c00bb98c c01e6b30
5ee0: 00000000 00000000 c00d5f04 ee519b40 00000000 c04a97b0 ee643238 c000ee44
5f00: ee474000 00000000 ee475f24 ee475f18 c00bbae8 c00bb8b8 ee475f44 ee475f28
5f20: c003c32c c00bbae4 00000000 ee519b40 ee643200 00000000 ee475f74 ee475f48
5f40: c0025c54 c003c27c 08de8590 00000001 c00414c8 ef1ed2f8 00000000 00000000
5f60: 00000000 000000f8 ee475f94 ee475f78 c00262f0 c00258b0 000712b2 000712c6
5f80: 00000001 000000f8 ee475fa4 ee475f98 c0026334 c0026258 00000000 ee475fa8
5fa0: c000ecc0 c0026328 000712b2 000712c6 00000001 b6ea44c0 00000008 00000001
5fc0: 000712b2 000712c6 00000001 000000f8 00000001 b6f894b8 00000001 00000000
5fe0: 000000f8 bee837ec b6f17de3 b6ebc8e6 600f0030 00000001 c2b00000 00000002
Backtrace:
[<c0349238>] (_raw_spin_lock_irqsave) from [<c01ff008>]
(uart_flush_buffer+0x38/0x7c)
[<c01fefd0>] (uart_flush_buffer) from [<c01ff1c4>] (uart_close+0x9c/0x194)
 r7:00000000 r6:ee441c00 r5:eee30654 r4:eee305b8
[<c01ff128>] (uart_close) from [<c01e6c4c>] (tty_release+0x128/0x4b4)
 r10:ee808760 r8:eee61800 r7:00000006 r6:00000008 r5:00000000 r4:ee441c00
[<c01e6b24>] (tty_release) from [<c00bb98c>] (__fput+0xe0/0x1e0)
 r10:ee808760 r9:eec33e10 r8:00000000 r7:eee61808 r6:00000008 r5:eed8fad8
 r4:eee61800
[<c00bb8ac>] (__fput) from [<c00bbae8>] (____fput+0x10/0x14)
 r10:00000000 r9:ee474000 r8:c000ee44 r7:ee643238 r6:c04a97b0 r5:00000000
 r4:ee519b40
[<c00bbad8>] (____fput) from [<c003c32c>] (task_work_run+0xbc/0xd0)
[<c003c270>] (task_work_run) from [<c0025c54>] (do_exit+0x3b0/0x8bc)
 r6:00000000 r5:ee643200 r4:ee519b40 r3:00000000
[<c00258a4>] (do_exit) from [<c00262f0>] (do_group_exit+0xa4/0xd0)
 r7:000000f8
[<c002624c>] (do_group_exit) from [<c0026334>] (__wake_up_parent+0x0/0x28)
 r7:000000f8 r6:00000001 r5:000712c6 r4:000712b2
[<c002631c>] (SyS_exit_group) from [<c000ecc0>] (ret_fast_syscall+0x0/0x30)
Code: e1a03000 e10f0000 f10c0080 f593f000 (e1932f9f)
---[ end trace ca2990c7ac60181d ]---
Fixing recursive fault but reboot is needed!

> This is with sh-sci, but I don't think the driver matters.

Note that this only happens if the serial port is used as a serial console.
Without a serial console, everything works fine (after "[PATCH/RFC]
serial_core: Fix pm imbalance on unbind", https://lkml.org/lkml/2014/3/10/496)

Thanks again!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
