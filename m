Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbaELJdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:33:21 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:64382 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbaELJdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:33:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140510053734.AF4E9E0692@canberra.localdomain>
References: <20140510053734.AF4E9E0692@canberra.localdomain>
Date: Mon, 12 May 2014 11:33:17 +0200
X-Google-Sender-Auth: cgYxywnOMkMIIk4DTwSFYlRwN0k
Message-ID: <CAMuHMdXQaOewxwe4UoiWj4KoT2Lybug2Spg4TzXd5g_Mfi-1Dg@mail.gmail.com>
Subject: Re: [PATCH] printk/of_serial: fix serial console cessation part way
 through boot.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Chivers <schivers@csc.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Greg KH <gregkh@linuxfoundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        rob+dt@kernel.org, Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Proctor <cproctor@csc.com>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Sat, May 10, 2014 at 7:37 AM, Stephen Chivers <schivers@csc.com> wrote:
> Commit 5f5c9ae56c38942623f69c3e6dc6ec78e4da2076
> "serial_core: Unregister console in uart_remove_one_port()"
> fixed a crash where a serial port was removed but
> not deregistered as a console.
>
> There is a side effect of that commit for platforms having serial consoles
> and of_serial configured (CONFIG_SERIAL_OF_PLATFORM). The serial console
> is disabled midway through the boot process.
>
> This cessation of the serial console affects PowerPC computers
> such as the MVME5100 and SAM440EP.
>
> The sequence is:
>
>         bootconsole [udbg0] enabled
>         ....
>         serial8250/16550 driver initialises and registers its UARTS,
>         one of these is the serial console.
>         console [ttyS0] enabled
>         ....
>         of_serial probes "platform" devices, registering them as it goes.
>         One of these is the serial console.
>         console [ttyS0] disabled.
>
> The disabling of the serial console is due to:
>
>         a.  unregister_console in printk not clearing the
>             CONS_ENABLED bit in the console flags,
>             even though it has announced that the console is disabled; and

This part re-attaches the serial console on unbind/bind with the sh-sci driver,
too, which didn't work before. Cool, thanks!

>         b.  of_platform_serial_probe in of_serial not setting the port type
>             before it registers with serial8250_register_8250_port.

This part I couldn't test.

> This patch ensures that the serial console is re-enabled when of_serial
> registers a serial port that corresponds to the designated console.
>
> Signed-off-by: Stephen Chivers <schivers@csc.com>
> Tested-by: Stephen Chivers <schivers@csc.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> [unregister_console]

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
