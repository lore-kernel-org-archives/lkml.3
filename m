Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965695AbaCUNXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:23:53 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:60790 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965502AbaCUNXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:23:50 -0400
MIME-Version: 1.0
In-Reply-To: <532C394A.3050408@hurleysoftware.com>
References: <1395392905-29569-1-git-send-email-geert@linux-m68k.org>
	<532C394A.3050408@hurleysoftware.com>
Date: Fri, 21 Mar 2014 14:23:49 +0100
X-Google-Sender-Auth: ZHd75_Vjx3RoOGb-ODuf2T6ft4I
Message-ID: <CAMuHMdUBiUzpvTzkhaguOQoDc8XJH7NvnNe2Z+jL6UeEitpJPg@mail.gmail.com>
Subject: Re: [PATCH resend] serial_core: Fix pm imbalance on unbind
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, Mar 21, 2014 at 2:06 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
>> @@ -2681,10 +2683,12 @@ int uart_remove_one_port(struct uart_driver *drv,
>> struct uart_port *uport)
>>         }
>>
>>         /*
>> -        * If the port is used as a console, unregister it
>> +        * If the port is used as a console, unregister it, and power it
>> down
>>          */
>> -       if (uart_console(uport))
>> +       if (uart_console(uport)) {
>>                 unregister_console(uport->cons);
>> +               uart_change_pm(state, UART_PM_STATE_OFF);
>
> Won't this power off the port while tty consoles may still be open?

I didn't see that actually happening.

> I think the right thing here is to unregister_console then set uport->cons =
> NULL
>
> [uport->cons is properly reassigned when/if a port is re-added via
> uart_add_one_port()).]

But indeed, for concistency/symmetry uport->state and uport->cons
should be resend, but that's something separate.

> Then, uart_close() will power off the port when all ttys using the port have
> been closed.

uart_close() won't get that far, so uart_change_pm() won't be called.

See also https://lkml.org/lkml/2014/3/10/651, and my workaround for the
crash https://lkml.org/lkml/2014/3/17/231.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
