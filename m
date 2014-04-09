Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492AbaDITlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:41:19 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48042 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279AbaDITlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:41:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140409003648.GB32273@kroah.com>
References: <5343416F.8010201@sr71.net>
	<20140408122726.227f3da8@alan.etchedpixels.co.uk>
	<5344642A.2020703@sr71.net>
	<53446C57.5000504@intel.com>
	<20140409003648.GB32273@kroah.com>
Date: Wed, 9 Apr 2014 21:41:16 +0200
X-Google-Sender-Auth: 4396q5kFnnSdVN_EuKM3t5knVNU
Message-ID: <CAMuHMdXSa0Ku2f1CR3j5pGOp_joQomc2Cnz=apGRR1K0Eb2qOQ@mail.gmail.com>
Subject: Re: post 3.14 serial regression
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Dave Hansen <dave@sr71.net>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, Apr 9, 2014 at 2:36 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Apr 08, 2014 at 02:38:31PM -0700, Dave Hansen wrote:
>> On 04/08/2014 02:03 PM, Dave Hansen wrote:
>> > On 04/08/2014 04:27 AM, One Thousand Gnomes wrote:
>> >>> At the end, you can see that init is somehow dying.  If I revert this
>> >>> patch, init is happy again and doesn't die, and the serial console works
>> >>> like before.
>> >>
>> >> Can you check if init is getting a SIGHUP - possibly its opening the
>> >> device and when it goes away gets a hangup which it isn't catching ?
>> >
>> > I do see plenty of SIGCHLDs and a heap of SIGTERMs to 'systemd-udevd',
>> > but no SIGHUP.  I do see a "Warning: unable to open an initial console."
>> > now, though.  (details far below)
>> >
>> > I instrumented uart_remove_one_port().  It *looks* like while searching
>> > for a uart_port for 0x1008 (my actual port),
>> > serial8250_find_match_or_unused() finds 0x3e8 since 0x3e8 is
>> > PORT_UNKNOWN.  The new code unregisters the 0x1008 console since it
>> > _thinks_ it is about to re-register it.
>>
>> <sigh>
>>
>> Looks like this just changed the detection order so my device went from
>> ttyS2 to ttyS4:
>>
>> # cat /proc/tty/driver/serial
>> serinfo:1.0 driver revision:
>> 0: uart:16550A port:000003F8 irq:4 tx:0 rx:0 CTS|DSR|CD
>> 1: uart:16550A port:000002F8 irq:3 tx:0 rx:0
>> 2: uart:unknown port:000003E8 irq:4
>> 3: uart:unknown port:000002E8 irq:3
>> 4: uart:ST16650V2 port:00001008 irq:18 tx:0 rx:0
>> 5: uart:ST16650V2 port:00001000 irq:19 tx:0 rx:0
>
> That's not good.
>
> Geert, any idea how to fix this?  Or should I just revert your change to
> get back to the "working" behavior?

Sorry, no idea. Reverting the change will bring back the crash on
unbind for me.

When I read Dave's first email, my first though was "why is
uart_remove_one_port() called on an active port?". But this doesn't
seem to be the case?

Dave: If I understand it correctly, you use console=ttyS2, while the kernel
suddenly changed the order of the serial devices, so your port is no
longer ttyS2, but ttyS4. Hence the serial port is not found, and
uart_remove_one_port() is called on it, taking away your /dev/console for
userspace?

Why does the serial port driver call uart_add_one_port() for ports that
don't exist?
Or if it does exist ("inaccessible and buried inside the system somewhere"),
how is it removed again?

>From the backtrace, it's the call below to uart_remove_one_port()
that removes the port?

/**
 *      serial8250_register_8250_port - register a serial port
 *      @up: serial port template
 *
 *      Configure the serial port specified by the request. If the
 *      port exists and is in use, it is hung up and unregistered
 *      first.
 *
 *      The port is then probed and if necessary the IRQ is autodetected
 *      If this fails an error is returned.
 *
 *      On success the port is ready to use and the line number is returned.
 */
int serial8250_register_8250_port(struct uart_8250_port *up)
{
        ...

        if (uart && uart->port.type != PORT_8250_CIR) {
                if (uart->port.dev)
                        uart_remove_one_port(&serial8250_reg, &uart->port);

where was it added before?

I'm a bit confused...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
