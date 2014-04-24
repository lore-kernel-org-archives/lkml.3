Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaDXANq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 20:13:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbaDXANo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 20:13:44 -0400
Date: Thu, 24 Apr 2014 10:13:29 +1000
From: NeilBrown <neilb@suse.de>
To: <balbi@ti.com>
Cc: Nishanth Menon <nm@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        <marcel@holtmann.org>, <gustavo@padovan.org>,
        <johan.hedberg@gmail.com>, <jslaby@suse.cz>, <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 10/13] tty: serial: omap: remove some dead code
Message-ID: <20140424101329.02e6a62f@notabene.brown>
In-Reply-To: <20140423230121.GC10924@saruman.home>
References: <1398265117-11793-1-git-send-email-balbi@ti.com>
	<1398265117-11793-10-git-send-email-balbi@ti.com>
	<5357DDA8.4040206@ti.com>
	<20140424084305.20c7f301@notabene.brown>
	<20140423230121.GC10924@saruman.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3o3JF0SUzTrvuVU1E.zWyqc"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3o3JF0SUzTrvuVU1E.zWyqc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Apr 2014 18:01:21 -0500 Felipe Balbi <balbi@ti.com> wrote:

> Hi,
>=20
> On Thu, Apr 24, 2014 at 08:43:05AM +1000, NeilBrown wrote:
> > On Wed, 23 Apr 2014 10:35:04 -0500 Nishanth Menon <nm@ti.com> wrote:
> >=20
> > > On 04/23/2014 09:58 AM, Felipe Balbi wrote:
> > > > nobody passes a DTR_gpio to this driver, so
> > > > this code is not necessary.
> > > >=20
> > > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > > ---
> > >=20
> > > Niel,
> > > this seems to revert the functionality introduced in
> > > commit 9574f36fb801035f6ab0fbb1b53ce2c12c17d100
> > > (OMAP/serial: Add support for driving a GPIO as DTR.)
> > >=20
> > > would you like to Ack this change?
> >=20
> > I have a couple of out-of-tree drivers that use this support.
> >=20
> > I hope to get back to working on that code one day and even get those d=
rivers
> > upstream.  So I would really prefer this code to remain if it isn't cau=
sing
> > any actual problems.
>=20
> it causes problem with DT (not really). That suport is only available on
> legacy platform_data-based boot, it's not available on DT. I hear Tony
> is pretty close to turning OMAP3 DT-only.
>=20
> > Of course, I can always re-submit it when I need it again, but that it =
just
> > extra work all around.
>=20
> I wonder how you will pass those attributes through DT considering they
> are *really* SW configuration. Why can't you use the real DTR pin, btw ?
>=20

This myth that DT is only about hardware is probably one of the reasons tha=
t I
haven't got these out-of-tree drivers upstream yet.

There is no "real" DTR pin.

When I open /dev/ttyWHATEVER, I need the driver for the device that is
permanently connected to that serial port to be told that the serial-device
has been opened so that it can "power on" or "wake up" the device.

I don't much care how that happens, or how I tell DT that it has to happen.
I just need it to happen.

In discrete hardware devices, the DTR line is what you would use.  The RS232
port would raise (or lower or whatever) DTR when /dev/ttyWHATEVER was open,
and  the device that was plugged in would detect the level change and do
stuff.

But I don't have discrete hardware.  I have a bunch of stuff soldered onto a
board with ad-hoc connections chosen to make the life of the hardware build=
er
easy rather than chosen to make the life of the software developer easy
(which I think is the correct choice).

So I need to tell DT "This device is plugged into this UART, and there is no
DTR line, but when the UARTs DTR line would be asserted (if it had one), th=
en
I need that regulator of there turned on". or maybe "I need to toggle this
GPIO  with exactly this pattern, while watching that GPIO to see if it is
working".

So I thought:

 1/ give the UART a "virtual" DTR so it could drive any GPIO
 2/ create a "gpio-to-regulator" driver which presented as a (virtual) gpio
    and responded to state changes on that GPIO by turning on or off the
    regulator
 3/ create a dedicated driver which knows how to toggle the magic GPIO while
    watching the other GPIO to convince the silly device to wakeup, or go to
    sleep, as required, and have this appear as a (virtual) GPIO.

Then I can just tell DT that these (virtual) GPIOs are connected together,
and it will all just work.  And it does.

But given the whole "no no, DT is for describing hardware, and you are
describing software" attitude,  it seems that I lost motivation for a while
(that wasn't the only reason, but it didn't help).

I have a patch which converts the OMAP serial driver to use DT to configure
these virtual DTR lines.  I'm very happy to submit that if there is some
chance it might be accepted and will keep the current DTR code in place.

On the other hand, if you can point out to me what I'm missing, and how I c=
an
solve my problem with any virtual GPIOs, I'm all ears.

To make my problem simple and explicit:  I have a device attached to a UART
which has a separate regulator.  The regulator should be powered on if and
only if the /dev/ttyXX interface to the UART is open.  The device is a
bluetooth transceiver.
(I have another device which is a GPS receiver which has similar
but more complicated requirements)

Thanks,
NeilBrown


--Sig_/3o3JF0SUzTrvuVU1E.zWyqc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU1hXKTnsnt1WYoG5AQKbQBAAqIJymgkITkPEb42Wdl/WAc5Tupcga6dW
v4WP3SGhNOZJBtB+EctQlhX9Tq1lLRqr2N+ZOrLP2BeClESyBldwljsxPh50uKrm
kNytSB1OKTxaVWTCR3IpKHuCXau76UnRgEtTV8lB3eOVx2hjjjcufddqfAjBWd4L
7ANcOxYieQyhIOJjkdBTQI5lH8WP7hEJ/gYH6S8HiDt8HvDlRKFDmWu2pxrAF22v
YssPN/n/B3WZh96D9X2XKNWIrzSfaGHMNYJrjBXQCHyRlAUuFjRtNIP0MDa0lmpS
7uqB+wzW3HQ/LcNBbmaM1vdmvvnbPVslFQQuNZZott+18OmpMsTOMv+eJSv0SGkt
/m0YDZoMCIG4/fDhYEJMJOKYSWWBY0d4tYQBXOM++T2gC4zpxPlHsBEP5GtxMqre
aNFNhIZzU6PuEZjPBEwQz/R8iwDVP5et+DxB7GT5kpXi07m89jh3m8txLfuNr9Np
qDL8jxge6r7+QSWkfsKjt9KT+MBlaq7ag9TRyQ3ZjO73XR/yzP3Hbf65sf+jwE+P
clIvFMo/FomQp5PyMzgVMPdl0Fjrp+BeeaMHR20d6yHzS3vwJNnC8tBSs92jFvo2
hccNg2iunqHNlqXkPc4P5PMaLsZU3/HW1vSO00qAqAndmC7ILwrVcdaZxsenxf+u
yXkavL4drUw=
=E12t
-----END PGP SIGNATURE-----

--Sig_/3o3JF0SUzTrvuVU1E.zWyqc--
