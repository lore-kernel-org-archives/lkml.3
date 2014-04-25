Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaDYJed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:34:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39484 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbaDYJe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:34:26 -0400
Date: Fri, 25 Apr 2014 19:34:12 +1000
From: NeilBrown <neilb@suse.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: <balbi@ti.com>, Nishanth Menon <nm@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>, <marcel@holtmann.org>,
        <gustavo@padovan.org>, <johan.hedberg@gmail.com>, <jslaby@suse.cz>,
        <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 10/13] tty: serial: omap: remove some dead code
Message-ID: <20140425193412.7d32e429@notabene.brown>
In-Reply-To: <20140424151914.6bc6463a@alan.etchedpixels.co.uk>
References: <1398265117-11793-1-git-send-email-balbi@ti.com>
	<1398265117-11793-10-git-send-email-balbi@ti.com>
	<5357DDA8.4040206@ti.com>
	<20140424084305.20c7f301@notabene.brown>
	<20140423230121.GC10924@saruman.home>
	<20140424101329.02e6a62f@notabene.brown>
	<20140424012100.GB13374@saruman.home>
	<20140424151914.6bc6463a@alan.etchedpixels.co.uk>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/m+ZgphiZyPLk0G=ZXR0k0qV"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/m+ZgphiZyPLk0G=ZXR0k0qV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Apr 2014 15:19:14 +0100 One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:

> > > But I don't have discrete hardware.  I have a bunch of stuff soldered=
 onto a
> > > board with ad-hoc connections chosen to make the life of the hardware=
 builder
> > > easy rather than chosen to make the life of the software developer ea=
sy
> > > (which I think is the correct choice).
> > >=20
> > > So I need to tell DT "This device is plugged into this UART, and ther=
e is no
> > > DTR line, but when the UARTs DTR line would be asserted (if it had on=
e), then
> > > I need that regulator of there turned on". or maybe "I need to toggle=
 this
> > > GPIO  with exactly this pattern, while watching that GPIO to see if i=
t is
> > > working".
> > >=20
> > > So I thought:
> > >=20
> > >  1/ give the UART a "virtual" DTR so it could drive any GPIO
> > >  2/ create a "gpio-to-regulator" driver which presented as a (virtual=
) gpio
> > >     and responded to state changes on that GPIO by turning on or off =
the
> > >     regulator
> > >  3/ create a dedicated driver which knows how to toggle the magic GPI=
O while
> > >     watching the other GPIO to convince the silly device to wakeup, o=
r go to
> > >     sleep, as required, and have this appear as a (virtual) GPIO.
>=20
> Unless you are using it as a "real' DTR line then I think this is the
> wrong approach. This problem actually is turning up in both PC class and
> ARM boxes now all over the place for three reasons I am seeing.
>=20
> 1. We are getting a lot of hardware moving to serial attached
> bluetooth/gps/etc because of the power win. In addition ACPI can describe
> power relationships and what is on the other end of a UART embedded in
> the device
>=20
> 2. We've got cheap hardware with modem lines being "retrofitted" via gpio
>=20
> 3. There are a subset of devices that have extra control lines beyond the
> usual serial port ones. These range from additional control lines for
> things like smartcard programmers to port muxing.
>=20
> > I have no problem either way, just that unused code doesn't have to be
> > sitting in the tree and I'm not entirely sure this GPIO should be
> > handled by omap-serial.c, perhaps something more generic inside
> > serial-core so other UART drivers can benefit from it.
>=20
> serial-core provides power hooks. If the goal is that this comes on when
> you power up the uart and goes away on the last close then the hooks are
> there already.

Could you be a bit more explicit, or point to an example user of these hook=
s?

I had a quick look and I guess that uart_change_pm() is the most likely
candidate for what you are referring to.
I can see how that interfaces to the specific piece of uart hardware, such =
as
omap-serial.c
But I cannot see how you would plumb that though to the device that was
plugged in to the serial port.  I guess if that device could be registered =
as
a child of the omap_serial device, then power management inheritance might
come in to play, but I cannot see any way to tell a serial port that it has
some arbitrary child device.

So maybe I'm missing something.

>                  If its ldisc specific then the tty layer also calls the
> device on ldisc changes precisely so it can make hardware specific
> twiddles in such cases.
>=20
> A set of gpios on the tty_port object would not go amiss and would also
> address the PC case.
>=20
> > considering this is a BTUART device, why didn't you do this at the ldisc
> > level ? hci_uart_open() sounds like a good choice from a quick thinking.
>=20
> ldiscs are hardware independent. Nothing about hardware belongs in an
> ldisc. Any ldisc should within reason work on any port.
>=20
> What I propsed when it came up ages ago was to expose some gpio settings
> in the tty, to provide ways for them to be set by default and also ioctls
> to configure them. I still think this (but moved into the tty_port as its
> a persistent hardware property) is a good idea now that we are starting
> to see more use cases than weird dongles and muxes on pre-production
> reference boards.
>=20
> With my tty and serial hat on I think a power gpio is a no-brainer even
> without doing the other work and therefore it should probably be described
> generically for a serial port in the DT as well as in the ACPI data. If
> you should also be able to give it a regulator to use as well that also
> seems to make complete sense.

In one case the "power on" sequence is substantially more complex that just=
 a
gpio or regulator.  I would need to write a device driver for the (GPS) chip
which could receive a poweron/poweroff signal from the uart and do the
required magic.

Having serial-core know about gpios and regulators and random other stuff
seems wrong.
I would really like to see the "runtime interpreted power sequences" become=
 a
real thing.  Then serial-core could activate a "RIPS", and that would have
the flexibility to do whatever is needed without adding complexity to
serial-core.
Using a virtual GPIO was my poor-mans RIPS.  Using gpiolib, and driver can
pretend to be a gpio so it is a simple "pipe" to send a power-on/power-off
signal over.

So ... with your "serial" hat on, if I were to write/test a patch to allow
any serial port to have a "power-gpio" described in DT and the gpio would be
driven in uart_change_pm(), would you consider accepting that patch, or did=
 I
misunderstand?

Thanks,
NeilBrown

--Sig_/m+ZgphiZyPLk0G=ZXR0k0qV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU1osFDnsnt1WYoG5AQIB/Q//Vs2BMgki7S2oBwveSFrNeCpAyFjXUreB
R6XiZ8KrZf9n3ApGIKlspKAIRGu3ZJLjcYgs2QXmlllJzdoPU5kwsgB4GPsc1kxs
55XaLcFcfPYqi1+IhjIB5233gAbnvxTR5dmqnecvpkeLU/7Rtg9/bmhDfTkXqkp9
PJEomptKjt2MOOfKs03fJiUouy8kzpntE4A5TGSeFmjX+pGiOS99BngmUcakEwRV
86T+XcquXFO4XFPwijnHYNfhDaQjxqM0sfQU8mEIq155KaTgNZge4Q9NueS9htFt
uc0Bx26nDHRf0IYuyc/GpdHBMmRxVQGTIYJRtYevayyw86JZCVRplJ3350FHrFou
v8l9363yFcqMgx380bhVkYa4StEcXvQ2d3P61RfKcbklzYk5iN9636OFJ50Ii/3p
aoON1EqBRKpVVn2J/1bjRwP/+AoyeqmZQFXczUC/+ggAD8XGAWEJxaQ4FZDE7TnK
74NE/jkZIph5GbroR1+YSfiLfoRpEq/KwQKxc4Cv/EJMmwB6emsy2MSCojOySshW
DkAD4lRPGtfaECp/+CjWaCxDSUE+M/l8wDWWANXUf+9nYCDZ2BnEC5vQ6JuopStt
3HDe2+khQ9+U7jRhI9TuLRX6pcQ8yZAFwJd/HgVAFQpHq1m1ivhADf/0dLp6k5yO
Bau013ODwTw=
=EdBs
-----END PGP SIGNATURE-----

--Sig_/m+ZgphiZyPLk0G=ZXR0k0qV--
