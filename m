Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbaC0Iim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 04:38:42 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:37314 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaC0Iih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 04:38:37 -0400
MIME-Version: 1.0
In-Reply-To: <532C394A.3050408@hurleysoftware.com>
References: <1395392905-29569-1-git-send-email-geert@linux-m68k.org>
	<532C394A.3050408@hurleysoftware.com>
Date: Thu, 27 Mar 2014 09:38:36 +0100
X-Google-Sender-Auth: zy8QgaxNP9Iy_XWwtWAcdbyKXAE
Message-ID: <CAMuHMdVQBTiZDdY_2Y+uaYUiAA9jVOCOf5okZuKj1QxVSMZVyQ@mail.gmail.com>
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

On Fri, Mar 21, 2014 at 2:06 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
>> When a serial port is closed, uart_close() takes care of shutting down the
>> hardware, and powering it down.
>>
>> When a serial port is unbound while in use, uart_close() bypasses all of
>> this, as this is supposed to be done through uart_hangup() (invoked via
>> tty_vhangup() in uart_remove_one_port()).
>>
>> However, uart_hangup() does not set the hardware's power state, leaving it
>> powered up.  This may also lead to unbounded nesting counts in clock and
>> power management, depending on their internal implementation.
>>
>> Make sure to power down the port in uart_hangup(), except when the port is
>> used as a serial console. For serial consoles, this must be postponed
>> until
>> after their deregistration in uart_remove_one_port() (symmetry with
>> registration in uart_configure_port(), invoked from uart_add_one_port()).
>>
>> After this, the module clock used by the sh-sci driver is disabled on
>> unbind while the serial port is in use.
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>> ---
>>   drivers/tty/serial/serial_core.c |    8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/tty/serial/serial_core.c
>> b/drivers/tty/serial/serial_core.c
>> index 2cf5649a6dc0..56dda84f82a5 100644
>> --- a/drivers/tty/serial/serial_core.c
>> +++ b/drivers/tty/serial/serial_core.c
>> @@ -1452,6 +1452,8 @@ static void uart_hangup(struct tty_struct *tty)
>>                 clear_bit(ASYNCB_NORMAL_ACTIVE, &port->flags);
>>                 spin_unlock_irqrestore(&port->lock, flags);
>>                 tty_port_tty_set(port, NULL);
>> +               if (!uart_console(state->uart_port))
>> +                       uart_change_pm(state, UART_PM_STATE_OFF);
>
>
> Ok.

Thanks, I'll send an updated patch handling the non-serial console case only.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
