Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbaC0JfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 05:35:03 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39777 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaC0Je6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 05:34:58 -0400
MIME-Version: 1.0
In-Reply-To: <53333438.3070107@hurleysoftware.com>
References: <1395061859-15295-1-git-send-email-geert@linux-m68k.org>
	<1395061859-15295-2-git-send-email-geert@linux-m68k.org>
	<532CA142.8060705@hurleysoftware.com>
	<CAMuHMdWZw-_+RVe0RuwfR+smuiDY9HpMq7H9=rseP_XLGytU0A@mail.gmail.com>
	<53333438.3070107@hurleysoftware.com>
Date: Thu, 27 Mar 2014 10:34:58 +0100
X-Google-Sender-Auth: EVj2y2CYkLWUqotY_PwWQvqQfNM
Message-ID: <CAMuHMdWAYe-7rwgZy9mpxvmoW6TJixw6wBOP+GYHfX9PynW0eA@mail.gmail.com>
Subject: Re: [PATCH 2/2] [RFC] serial_core: Avoid NULL pointer dereference in uart_close()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, Mar 26, 2014 at 9:10 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> On 03/26/2014 02:58 PM, Geert Uytterhoeven wrote:
>> Thanks for your comments!
>
> Not a problem; just wanted to save you some time and frustration :)

Much appreciated!

>> On Fri, Mar 21, 2014 at 9:29 PM, Peter Hurley <peter@hurleysoftware.com>
>> wrote:
>>> On 03/17/2014 09:10 AM, Geert Uytterhoeven wrote:
>>>> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>>>> When unbinding a serial driver that's being used as a serial console,
>>>> the kernel may crash with a NULL pointer dereference in a uart_*()
>>>> function
>>>> called from uart_close () (e.g. uart_flush_buffer() or
>>>> uart_chars_in_buffer()).
>>>>
>>>> To fix this, let uart_close() check for port->count == 0. If this is the
>>>> case, bail out early. Else tty_port_close_start() will make the port
>>>> counts inconsistent, printing out warnings like
>>>>
>>>>       tty_port_close_start: tty->count = 1 port count = 0.
>>>>
>>>> and
>>>>
>>>>       tty_port_close_start: count = -1
>>>
>>> As you noted in the patch comments below, the tty core always closes
>>> a failed open.
>>>
>>> So the reason for the port->count mismatch is because
>>> tty_port_close_start()
>>> only handles the tty hangup condition -- all other failed opens are
>>> assumed
>>> to carry a port->count.
>>>
>>> A similar mismatch will occur if the mutex_lock in uart_open() is
>>> interrupted.
>>>
>>> This means that the port->count mismatch can occur even if port->count !=
>>> 0;
>>> so the bug here is that uart_open() and uart_close() don't agree on
>>> who does what cleanup under what error conditions.
>>>
>>> So with respect to the port count mismatches, the conditions need careful
>>> auditing and fixing, separate from the tty console teardown problem.
>>
>> Indeed. Currently uart_open() always decrements port->count again
>> in any error condition, which is clearly wrong.
>
> I started looking at this problem only to realize that the
> tty_hung_up_p() condition in uart_open() can't actually happen.

BTW, generic tty_port_open(), as used by new serial port drivers, also checks
for this condition.

> Which has lead me to a bunch of cleanups and fixes that I'm still
> working on. It's just slow going because tty code audit takes
> forever with legacy intentions that no longer apply and some of
> the bit-rotting tty drivers that I doubt even run.

Sure, I understand.

> What are the circumstances of device removal in your case?

I'm unbinding the driver using:

    echo sh-sci.6 > /sys/bus/platform/drivers/sh-sci/unbind

As long as the serial port is not opened as a console at the time
of unbind, everything is reasonably well. But if it's open as a console,
uart_hangup() is no longer called, and proper cleanup never happens.

I started looking into this when I wanted to verify that the serial hardware's
clock is properly disabled when the hardware is not in use (e.g. on driver
shutdown).

Note that Greg has applied this patch to linux-next, so you may want to
revert it for your investigations (and fix ;-).

Thanks again!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
