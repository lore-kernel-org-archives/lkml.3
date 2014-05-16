Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbaEPOUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:20:21 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:62536 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbaEPOUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:20:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140516134904.GW618@waldemar-brodkorb.de>
References: <20140516134904.GW618@waldemar-brodkorb.de>
Date: Fri, 16 May 2014 16:20:18 +0200
X-Google-Sender-Auth: oadzfgtYzCIG03pt5q7MpCftjtE
Message-ID: <CAMuHMdVPSzYkUumqMY78zxVcoQ6=W9Vfm_tyM_T3W8DFzCztVw@mail.gmail.com>
Subject: Re: serial console on rb532 disabled on boot (linux 3.15rc5)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Waldemar Brodkorb <wbx@openadk.org>
Cc: Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Waldemar,

On Fri, May 16, 2014 at 3:49 PM, Waldemar Brodkorb <wbx@openadk.org> wrote:
> I am trying to bootup my Mikrotik RB532 board with the latest
> kernel, but my serial console is disabled after boot:
> ..
> Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> serial8250: ttyS0 at MMIO 0x0 (irq = 104, base_baud = 12499875) is a
> 16550A
> console [ttyS0] enabled
> console [ttyS0] disabled
>
> I used git bisect to find the problematic commit:
> commit 5f5c9ae56c38942623f69c3e6dc6ec78e4da2076
> Author: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> Date:   Fri Feb 28 14:21:32 2014 +0100
>
>     serial_core: Unregister console in uart_remove_one_port()
>
>     If the serial port being removed is used as a console, it must
> also be
>     unregistered from the console subsystem using
> unregister_console().
>
>     uart_ops.release_port() will release resources (e.g. iounmap()
> the serial
>     port registers), causing a crash on subsequent kernel output if
> the console
>     is still registered.
>
>     Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> After reverting the change, everything is fine.

Does this patch help? https://lkml.org/lkml/2014/5/10/9

I guess you're not using of_serial?
Your serial driver may need to set port.type too, if it doesn't already do so
and the type is PORT_UNKNOWN on re-registration.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
