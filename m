Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934424AbaDIU7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 16:59:30 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:54818 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbaDIU72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 16:59:28 -0400
MIME-Version: 1.0
In-Reply-To: <5345A7B3.7020005@sr71.net>
References: <5343416F.8010201@sr71.net>
	<20140408122726.227f3da8@alan.etchedpixels.co.uk>
	<5344642A.2020703@sr71.net>
	<53446C57.5000504@intel.com>
	<20140409003648.GB32273@kroah.com>
	<CAMuHMdXSa0Ku2f1CR3j5pGOp_joQomc2Cnz=apGRR1K0Eb2qOQ@mail.gmail.com>
	<5345A7B3.7020005@sr71.net>
Date: Wed, 9 Apr 2014 22:59:27 +0200
X-Google-Sender-Auth: iU8YpIEbBkqlOEyNGmfRqbxC9C0
Message-ID: <CAMuHMdXtz_W7LCJeOG9--ZmmH4js40-urueCTbS98t8oBgnYCw@mail.gmail.com>
Subject: Re: post 3.14 serial regression
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dave Hansen <dave@sr71.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Wed, Apr 9, 2014 at 10:04 PM, Dave Hansen <dave@sr71.net> wrote:
> On 04/09/2014 12:41 PM, Geert Uytterhoeven wrote:
>> Dave: If I understand it correctly, you use console=ttyS2, while the kernel
>> suddenly changed the order of the serial devices, so your port is no
>> longer ttyS2, but ttyS4. Hence the serial port is not found, and
>> uart_remove_one_port() is called on it, taking away your /dev/console for
>> userspace?
>
> Right.

Does it work with console=ttyS4?

>>>From the backtrace, it's the call below to uart_remove_one_port()
>> that removes the port?
>>
>> /**
>>  *      serial8250_register_8250_port - register a serial port
>>  *      @up: serial port template
>>  *
>>  *      Configure the serial port specified by the request. If the
>>  *      port exists and is in use, it is hung up and unregistered
>>  *      first.
>>  *
>>  *      The port is then probed and if necessary the IRQ is autodetected
>>  *      If this fails an error is returned.
>>  *
>>  *      On success the port is ready to use and the line number is returned.
>>  */
>> int serial8250_register_8250_port(struct uart_8250_port *up)
>> {
>>         ...
>>
>>         if (uart && uart->port.type != PORT_8250_CIR) {
>>                 if (uart->port.dev)
>>                         uart_remove_one_port(&serial8250_reg, &uart->port);
>>
>> where was it added before?
>
> Remember, serial8250_find_match_or_unused() will also reuse *EXISTING*
> uart_ports if the port is of 'unknown' type.
>
> I believe that port got added during the addition of the
> serial8250_isa_devs, and now we're trying to reuse it since it is an
> unknown port type.

So it gets added, removed, and added again.

I also noticed that unbinding and rebinding the driver doesn't re-attach it
as a serial console.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
