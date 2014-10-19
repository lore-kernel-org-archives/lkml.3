Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaJSU3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 16:29:42 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:13981 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaJSU3k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 16:29:40 -0400
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat9hNPrwo0=
X-RZG-CLASS-ID: mo00
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 1/2] misc: Add Wi2Wi w2sc0004 gps driver
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <9266107.dnSTmzxRsf@wuerfel>
Date: Sun, 19 Oct 2014 22:29:27 +0200
Cc: Marek Belisko <marek@goldelico.com>, gregkh@linuxfoundation.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <849A3D5F-6A8A-4DA3-9D33-3357E3447B7F@goldelico.com>
References: <1413491183-15018-1-git-send-email-marek@goldelico.com> <9266107.dnSTmzxRsf@wuerfel>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 19.10.2014 um 21:51 schrieb Arnd Bergmann <arnd@arndb.de>:

> On Thursday 16 October 2014 22:26:22 Marek Belisko wrote:
>> This is a driver for the Wi2Wi GPS modules connected through an UART.
>> The tricky part is that the module is turned on or off by an impulse
>> on the control line - but it is only possible to get the real state by monitoring
>> the UART RX input. Since the kernel can't know in which status the module
>> is brought e.g. by a boot loader or after suspend, we need some logic to handle
>> this.
>> 
>> The driver allows two different methods to enable (and power up) GPS:
>> a) through rfkill
>> b) as a GPIO
>> 
>> The GPIO enable can be plumbed to other drivers that expect to be able to control
>> a GPIO. On the GTA04 board this is the DTR-gpio of the connected UART so that
>> opening the UART device enables the receiver and closing it shuts the receiver down.
>> 
>> Original implementation by Neil Brown, fixes + DT bindings by H. Nikolaus Schaller
> 
> I’m not sure if this is a good way to model the device.

It is the easiest way we have found after ca. 2 years of working on it :)

> You say that it's
> connected to a UART, but the code itself has no reference to the tty layer
> at all.

Yes.

> I assume the actual driver is in user space and it would open the
> UART and this control device as separate instances handles and then try
> to coordinate them. Is that right?

Yes, it is called gpsd.

> 
> What is the protocol for the GPS driver itself? Is it standardized?

Yes, NMEA records. Like most GPS receivers provide them.

> Would it help to have a TTY line discipline for the GPS mode instead
> so the power management and startup could be integrated into the serial
> port management instead?

I don’t think line disciplines (as far as I understand them) are helpful and
this chip is not special at all regarding the serial interface data. So it needs no
“GPS mode”.

It is very similar to connecting some external handheld GPS receiver by a
RS232 cable or RS232-USB adapter. Or GPS “mouse” receivers through
bluetooth.

They all create/show some /dev/tty that you simply open/read/close. And
there is no special processing of the serial data involved.

The only thing this driver needs to solve is to properly power up/down
the chip on demand.

The DTR line of the tty can enable/disable power of a connected device
(being an external modem or this GPS chip). This is what we have made
the driver compatible to by providing a virtual GPIO to enable/disable.

This is done by a patch to the tty driver that already was in the kernel
but removed in 3.15 because the w2sg driver wasn’t submitted at that
time.

Commit: 985bfd54c826c0ba873ca0adfd5589263e0c6ee2

Basically, if our CPU would have a real RS232 interface and we would
put the chip into an external device, it should look exactly the same if
we look at the serial interface part. Since soldering it on the same PCB
or connecting through a connector should not need different serial drivers.
Just different device tree files.

Therefore we have decided not to touch any serial driver code at all,
because it is not needed (except allowing DTR to control some GPIO)
and keeps it simple and manageable.

BR,
Nikolaus


