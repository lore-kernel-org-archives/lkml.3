Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaBZRvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:51:38 -0500
Received: from ring0.de ([5.45.105.125]:52290 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaBZRvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:51:36 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Wed, 26 Feb 2014 18:51:29 +0100
From: Sebastian Reichel <sre@debian.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Marek Belisko <marek@goldelico.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        linux-iio@vger.kernel.org,
        Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: Re: [PATCHv1 0/2] Convert rx51-battery to IIO API and add DT support
Message-ID: <20140226175128.GA13975@earth.universe>
References: <1393375569-21751-1-git-send-email-sre@debian.org>
 <CAHYPw2EeEnDn2FUYSMWbywprmhJmcRRyaTPn1YZK0xPvuiJQFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <CAHYPw2EeEnDn2FUYSMWbywprmhJmcRRyaTPn1YZK0xPvuiJQFw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pali,

On Wed, Feb 26, 2014 at 08:40:54AM +0100, Pali Roh=E1r wrote:
> I would like to ask other kernel developers what do you think about
> moving ADC channel numbers from rx51_battery.ko driver code to DT.
> Driver rx51_battery.ko is platform specific for Nokia RX-51 (N900) so
> it is usefull only for this one device.
>=20
> Before this patch all driver data (look-up tables, adc channel
> numbers, etc...) were in driver code. Now after this patch adc channel
> numbers were moved to DT. What do you think? It is better to have all
> data in one place (driver code) or some in DT and some in driver code?
>=20
> For me it does not make sense to move these numbers to DT, because
> driver is rx51 device specific and chaning it in DT does not make
> sense. And I think it is better to have add driver data in one place
> and not in two...
>=20
> Sebastian already wrote me that this is normal to have numbers in DT
> and other code in driver. But I think that driver which can be used
> only in one device (so specified only in one DT file) does not need to
> have configuration (via DT or board files).
>
> Or do you think that driver specified only for one device needs to
> have ADC numbers configuration via DT?

I think the problem is, that you think of ADC channel numbers as
configuration data. This means you think of rx51-battery as an
alternative driver for the twl4030-madc.

I think of rx51-battery as its own platform device, which makes use
of the ADC similar to a button making use of a GPIO chip.
For me the ADC channel numbers are not configuration data, but an
inter-device resource reference, like e.g. GPIO references.
This is exactly the data you would put into the device tree.

Now let's take the rx51-audio device as another example for an n900
specific device (not yet in mainline kernel). It does not need ADC
channels, but GPIO lines:

	sound: n900-audio {
		/* ... some more references ... */
		nokia,tvout-selection-gpio =3D <&gpio2 8 GPIO_ACTIVE_HIGH>; /* 40 */
		nokia,jack-detection-gpio =3D <&gpio6 17 GPIO_ACTIVE_HIGH>; /* 177 */
		nokia,eci-switch-gpio =3D <&gpio6 22 GPIO_ACTIVE_HIGH>; /* 182 */
		nokia,speaker-amplifier-gpio =3D <&twl_gpio 7 GPIO_ACTIVE_HIGH>;
	};

Since GPIO numbers are not guaranteed to be consistent in DT boot
mode at least the GPIO chip must be referenced. Do you really think
it's a good idea to leave out the exact GPIO number just because
the driver knows it needs the 8th GPIO from the second GPIO chip?
IMHO this is really ugly, since it splits the information, which
GPIO is used into two parts - one living in the DT and one living
in the driver with no advantage at all. So it does make sense to
specify inter-device resources via DT even for platform specific
devices.

-- Sebastian

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTDimgAAoJENju1/PIO/qa3EgP/ikPuPL6unTNAUKhBP2R2kZj
BRmjdniZyFnlmXh7sjVSr+3hFwPieUIgI3F5BH8u1QiRf1wMP6hQKoYEe2AV8arb
GooOgnnev/MX8tdMdSrnaxH13p7k65yggNIqpMk6A0E+XkZt7KHN1E7VYBBAVOim
PmDU47ICJhMEB/pcGKhd6Iqkiokm6i0x4YZekq97AEN23+/8BLOhjOQwL4T1jbJp
cjvrBQtqWaAUkdtRNGqtF/UWxikAVhn1PMs4Z0B2c8GpZfIsZ+Gh7akOWHtcOp4w
N+w+51tcURxvo0NWfroagD5Xd+pAikaFmYaU5zxIEIjdQrmqD1gIvIvZ1fZHiZZA
db5jNYjDhivZUbCo9YJEqY0BcgNIVTqf4frezvSAeXqxVXbw1xbEVAm0HT0syIjC
Cga/K1bZ+X4o3g9ruSAnGRVnHGgXTHFl2RO6hSVFfN70O3GWA26RxwM/txwW39gD
icdRNVT3xFi4VtUmpr7Qf40Z/cpD1mQS20v5I32DaiWJQQO/vARFvmn/wPZy2/SO
MCJXhno4LHG9pxnR2E8fIV9vwA47LDEvnIadRp7y1vrHdh/la9TA6MP5OgD+FfIs
EHtz04RP2FPX+RE1nwM7nT2TAEHxUEJgQZ8oZXvTQuYMHs9URgSvFqXmqWiUb2aM
4FiHNC5jtWlBPm/3d1mi
=FFGf
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
