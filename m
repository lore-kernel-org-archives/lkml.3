Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaDYJxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:53:48 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35118 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbaDYJxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:53:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140425193412.7d32e429@notabene.brown>
References: <1398265117-11793-1-git-send-email-balbi@ti.com>
 <1398265117-11793-10-git-send-email-balbi@ti.com> <5357DDA8.4040206@ti.com>
 <20140424084305.20c7f301@notabene.brown> <20140423230121.GC10924@saruman.home>
 <20140424101329.02e6a62f@notabene.brown> <20140424012100.GB13374@saruman.home>
 <20140424151914.6bc6463a@alan.etchedpixels.co.uk> <20140425193412.7d32e429@notabene.brown>
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Fri, 25 Apr 2014 11:53:21 +0200
Message-ID: <CAGm1_kvSEcXRGoQrUoJcmFq6gTHkjupzDqesw3cTmL=V74yPOw@mail.gmail.com>
Subject: Re: [PATCH 10/13] tty: serial: omap: remove some dead code
To: NeilBrown <neilb@suse.de>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, balbi@ti.com,
        Nishanth Menon <nm@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>, gustavo@padovan.org,
        johan.hedberg@gmail.com, jslaby@suse.cz,
        Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org, linux-serial@vger.kernel.org,
        devicetree@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 11:34 AM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 24 Apr 2014 15:19:14 +0100 One Thousand Gnomes
> <gnomes@lxorguk.ukuu.org.uk> wrote:
>
>> > > But I don't have discrete hardware.  I have a bunch of stuff soldered onto a
>> > > board with ad-hoc connections chosen to make the life of the hardware builder
>> > > easy rather than chosen to make the life of the software developer easy
>> > > (which I think is the correct choice).
>> > >
>> > > So I need to tell DT "This device is plugged into this UART, and there is no
>> > > DTR line, but when the UARTs DTR line would be asserted (if it had one), then
>> > > I need that regulator of there turned on". or maybe "I need to toggle this
>> > > GPIO  with exactly this pattern, while watching that GPIO to see if it is
>> > > working".
>> > >
>> > > So I thought:
>> > >
>> > >  1/ give the UART a "virtual" DTR so it could drive any GPIO
>> > >  2/ create a "gpio-to-regulator" driver which presented as a (virtual) gpio
>> > >     and responded to state changes on that GPIO by turning on or off the
>> > >     regulator
>> > >  3/ create a dedicated driver which knows how to toggle the magic GPIO while
>> > >     watching the other GPIO to convince the silly device to wakeup, or go to
>> > >     sleep, as required, and have this appear as a (virtual) GPIO.
>>
>> Unless you are using it as a "real' DTR line then I think this is the
>> wrong approach. This problem actually is turning up in both PC class and
>> ARM boxes now all over the place for three reasons I am seeing.
>>
>> 1. We are getting a lot of hardware moving to serial attached
>> bluetooth/gps/etc because of the power win. In addition ACPI can describe
>> power relationships and what is on the other end of a UART embedded in
>> the device
>>
>> 2. We've got cheap hardware with modem lines being "retrofitted" via gpio
>>
>> 3. There are a subset of devices that have extra control lines beyond the
>> usual serial port ones. These range from additional control lines for
>> things like smartcard programmers to port muxing.
>>
>> > I have no problem either way, just that unused code doesn't have to be
>> > sitting in the tree and I'm not entirely sure this GPIO should be
>> > handled by omap-serial.c, perhaps something more generic inside
>> > serial-core so other UART drivers can benefit from it.
>>
>> serial-core provides power hooks. If the goal is that this comes on when
>> you power up the uart and goes away on the last close then the hooks are
>> there already.
>
> Could you be a bit more explicit, or point to an example user of these hooks?
>
> I had a quick look and I guess that uart_change_pm() is the most likely
> candidate for what you are referring to.
> I can see how that interfaces to the specific piece of uart hardware, such as
> omap-serial.c
> But I cannot see how you would plumb that though to the device that was
> plugged in to the serial port.  I guess if that device could be registered as
> a child of the omap_serial device, then power management inheritance might
> come in to play, but I cannot see any way to tell a serial port that it has
> some arbitrary child device.
>
> So maybe I'm missing something.
>
>>                  If its ldisc specific then the tty layer also calls the
>> device on ldisc changes precisely so it can make hardware specific
>> twiddles in such cases.
>>
>> A set of gpios on the tty_port object would not go amiss and would also
>> address the PC case.
>>
>> > considering this is a BTUART device, why didn't you do this at the ldisc
>> > level ? hci_uart_open() sounds like a good choice from a quick thinking.
>>
>> ldiscs are hardware independent. Nothing about hardware belongs in an
>> ldisc. Any ldisc should within reason work on any port.
>>
>> What I propsed when it came up ages ago was to expose some gpio settings
>> in the tty, to provide ways for them to be set by default and also ioctls
>> to configure them. I still think this (but moved into the tty_port as its
>> a persistent hardware property) is a good idea now that we are starting
>> to see more use cases than weird dongles and muxes on pre-production
>> reference boards.
>>
>> With my tty and serial hat on I think a power gpio is a no-brainer even
>> without doing the other work and therefore it should probably be described
>> generically for a serial port in the DT as well as in the ACPI data. If
>> you should also be able to give it a regulator to use as well that also
>> seems to make complete sense.
>
> In one case the "power on" sequence is substantially more complex that just a
> gpio or regulator.  I would need to write a device driver for the (GPS) chip
> which could receive a poweron/poweroff signal from the uart and do the
> required magic.
>
> Having serial-core know about gpios and regulators and random other stuff
> seems wrong.
> I would really like to see the "runtime interpreted power sequences" become a
> real thing.  Then serial-core could activate a "RIPS", and that would have
> the flexibility to do whatever is needed without adding complexity to
> serial-core.
> Using a virtual GPIO was my poor-mans RIPS.  Using gpiolib, and driver can
> pretend to be a gpio so it is a simple "pipe" to send a power-on/power-off
> signal over.
>
> So ... with your "serial" hat on, if I were to write/test a patch to allow
> any serial port to have a "power-gpio" described in DT and the gpio would be
> driven in uart_change_pm(), would you consider accepting that patch, or did I
> misunderstand?

As soon as this patch
(http://www.spinics.net/lists/arm-kernel/msg325197.html) will be
applied, we don't really need this DTR GPIO any more.

DTR_active is the only stuff, that is missing.

Yegor
