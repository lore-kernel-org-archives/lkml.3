Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaLMRfc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 12:35:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:43510 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbaLMRfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 12:35:30 -0500
Date: Sat, 13 Dec 2014 18:35:24 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, khilman@kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<ivo.g.dimitrov.75@gmail.com>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: Re: __hci_cmd_sync() not suitable for nokia h4p
Message-ID: <20141213173523.GA17570@earth.universe>
References: <20141209190210.GA15641@amd>
 <304050AD-DB11-4A2B-A1F7-8B1BBB5F04F0@holtmann.org>
 <20141209201328.GA18003@amd>
 <7EFD3C33-E503-4FB6-BCCF-52836080ABD6@holtmann.org>
 <20141210131519.GA14748@amd>
 <EE1A4B9D-30D5-4BD9-9A43-532619494A0C@holtmann.org>
 <20141211221306.GA2905@amd>
 <20141212011504.GA16599@earth.universe>
 <20141212121453.GA31659@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <20141212121453.GA31659@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 12, 2014 at 01:14:53PM +0100, Pavel Machek wrote:
> > > I have created provisional device tree binding, and the driver still
> > > works.
> >=20
> > I don't have time to look at the code now, but I have some comments
> > regarding the binding.
>=20
> > > =20
> > >  &uart2 {
> > > +        compatible =3D "brcm,uart,bcm2048";
> >=20
> > This does not look correct. The uart should not be overwritten. The
> > current h4p driver indeed implements a driver for the serial port,
> > but that's a) linux specific and does not belong in the DT and b)
> > should probably be changed in the mainline kernel.
>=20
> Yes, bettter solution is needed here. But see the code, I don't see
> how b) would be implemented.

I think it's probably a good idea to start from scratch. The h4p
driver in its current state does not fit to the current kernel's
style at all.

My suggestion would be to have a driver, which implements a hci_dev.
The driver would mostly look like the standard uart hci_dev driver,
but additionally handles the wakeup and reset gpios. Power
Management for the uart device is done via runtime pm, which is
supported by OMAP's uart driver.

Then there should be a second driver, which implements the h4
protocol extensions from Nokia as hci_uart_proto. It could be put
into something like drivers/bluetooth/hci_h4p.c and have support for
the additional packet types (namely H4_EVT_PKT, H4_NEG_PKT,
H4_ALIVE_PKT and H4_RADIO_PKT).

> > >  	interrupts-extended =3D <&intc 73 &omap3_pmx_core OMAP3_UART2_RX>;
> > >  	pinctrl-names =3D "default";
> > >  	pinctrl-0 =3D <&uart2_pins>;
> > > +	device {
> > > +		  compatible =3D "brcm,bcm2048";
> > > +		  uart =3D <&uart2>;
> >=20
> > You don't need a phandle to the parent device.
>=20
> Ok.
>=20
> > > +		  reset-gpios =3D <&gpio3 27 GPIO_ACTIVE_HIGH>; /* want 91 */
> > > +		  host-wakeup-gpios =3D <&gpio4 5 GPIO_ACTIVE_HIGH>; /* want 101 */
> >=20
> > The host-wakeup should be mapped as irq, gpio2irq conversion
> > will happen ;)
>=20
> Why? It is accessed as gpio, too.

Ok. I only did a quick look and saw, that the gpio was converted to
irq.

> > > +		  chip-type =3D <3>;
> >=20
> > This should be set in the driver based on the compatible
> > value and not via DT data.
>=20
> Ok
>=20
> > > +		  clocks =3D <&uart2_fck>, <&uart2_ick>;
> > > +		  clock-names =3D "fck", "ick";
> >=20
> > These clocks you defined belong to the uart device and not to the
> > uart slave (bluetooth) device.
>=20
> Ok. Why are they only needed in the bluetooth case?

A quick guess (without a deeper look at the code) is, that the ttys
use hwmod provided clock information (which is available from the
kernel). btw, h4p not using hwmod would be another problem, if it is
ok to reimplement a full serial driver.

I guess the clock data should be added to the uart devices in DT,
though. This is btw. true for almost all omap internal devices
described in DT, since the clock data has only been available in DT
for 1 or 2 kernel releases.

> > > +		  bt-sysclk =3D <2>;
> >=20
> > I think this should be mapped cleanly in DT by adding a new clock
> > to the DTS file:
> >=20
> > vctcxo_clock: clock  {
> >     compatible =3D "fixed-clock";
> >     #clock-cells =3D <0>;
> >     clock-frequency =3D <38400000>;
> > };
>=20
> No. It seems that this selects baud rate during the chip init. I guess
> I can just remove that one.

you can see, that its a descriptor for the speed of the bcm2048's
system clock.

(from h4p driver)
bt-sysclk =3D 1 =3D> sysclk =3D 12000;
bt-sysclk =3D 2 =3D> sysclk =3D 38400;

and incidentally there is a 38.4 MHz clock connected to the bcm2048
and the wl1251 in the N900 :)

> > Then the bluetooth device can reference its clock device:
> >=20
> > clocks =3D <&vctcxo_clock>;
> >=20
> > The same clock reference should be added to the wl1251 DT node :)
>=20
> Feel free to do that, but I don't see how this one helps...?

The clock is not enabled via the CPU, instead wl1251 and bcm2048
enable it themselfes, so it's not strictly needed. But it means,
that

a) DT represents the hardware correctly
b) one can acquire the sysclk speed from the referenced clock
   [ using devm_clk_get() and clk_get_rate() ]

-- Sebastian

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUjHi3AAoJENju1/PIO/qa30YP/j6LddU62rbINuSKg1ugbBoC
9zm7QhQLYNvbRC5Vq3/N0KnSbiTQRcvp2lfiOjfkcfT+VOnirZ1JwRH/rd9EYTLQ
5e9Y3lSOO+unQbwT4mvd02IOL38JyzbsuagRSyhceCL+Clv4/TDaa4JuT94Xscqd
CUsAaXyQBH/MEhgsrchMqSz3sXckpH5XlrHJHdXelGYLUHS40WUfCIS159TPJe8/
vwQGxZ0fsWtOwPSzSLAQo5yqGDcSQzjF/z+bhubpPwzewlV/X7ZqxvncKKqm+7OB
ZdZH8MjhXSkcBB/6JgdqR8EjQH8kWGF0oXMUxZyXi5ax3zM6gHIu5as0Lf3byQ3Q
UMffYJyakxAm2Y4PhMLoejOSvqvWFwDsfP3DL7c8iEPTWNIJ/GiD0j8PF9H3L9Mc
xtt6rMZbu7dHIojwQ3BAd96XvefJZClLrOOGGjlKGYj5hm+47HWF+jrB+zqUt7R+
KNArMx127j0EAj5pSTmvKCYtTOXlcgLg+Qq6o5UodTKBmTbuz6nUBWXDhlCWUcJK
bl9tVKDO9rvZRn7d3gJ0D8pX0UuAcLn6+bbTLX3piAu+3XxyctZ5B7WbqKU/r0pJ
sYDvz6oR/uxlLtY1in7E2Cidjmav1TotnjYGXTVbyMqP2vw4EBhuYjcPUP1J8d2v
up5eBEU+OoXYeP5VapUB
=cSJV
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
