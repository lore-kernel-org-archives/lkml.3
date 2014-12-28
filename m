Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbaL1KSF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 05:18:05 -0500
Received: from mail.kernel.org ([198.145.29.136]:39732 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbaL1KR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 05:17:59 -0500
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Dec 2014 05:17:59 EST
Date: Sun, 28 Dec 2014 11:07:29 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Pavel Machek <pavel@ucw.cz>, Pali Rohar <pali.rohar@gmail.com>,
        Jean Delvare <jdelvare@suse.de>, Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, lm-sensors@lm-sensors.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 2/3] hwmon: Driver for OMAP3 temperature sensor
Message-ID: <20141228100716.GA5581@earth.universe>
References: <20141226102933.GA28778@amd>
 <1419597294-21487-1-git-send-email-sre@kernel.org>
 <1419597294-21487-3-git-send-email-sre@kernel.org>
 <20141227195825.GF10007@amd>
 <20141227223516.GA18455@amd>
 <20141228082447.GA31346@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <20141228082447.GA31346@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 28, 2014 at 12:24:47AM -0800, Guenter Roeck wrote:
> On Sat, Dec 27, 2014 at 11:35:16PM +0100, Pavel Machek wrote:
> > On Sat 2014-12-27 20:58:25, Pavel Machek wrote:
> > > On Fri 2014-12-26 13:34:53, Sebastian Reichel wrote:
> > > > OMAP34xx and OMAP36xx processors contain a register in the syscon a=
rea,
> > > > which can be used to determine the SoCs temperature. This patch pro=
vides
> > > > a DT based driver for the temperature sensor based on an older driv=
er
> > > > written by Peter De Schrijver for the Nokia N900 and N9.
> > > >=20
> > > > Signed-off-by: Sebastian Reichel <sre@kernel.org>
> > > > ---
> > > >  drivers/hwmon/Kconfig      |   8 ++
> > > >  drivers/hwmon/Makefile     |   1 +
> > > >  drivers/hwmon/omap3-temp.c | 307 +++++++++++++++++++++++++++++++++=
++++++++++++
> > > >  3 files changed, 316 insertions(+)
> > > >  create mode 100644 drivers/hwmon/omap3-temp.c
> > >=20
> > > When it hangs, it loops here:
> > >=20
> > > do {
> > > regmap_read(data->syscon, SYSCON_TEMP_REG,&temp_sensor_reg);
> > > if ((temp_sensor_reg & eocz_mask) =3D=3D level)
> > >    return true;
> > > printk("=3D");
> > > }
> > > while (ktime_us_delta(expire, ktime_get()) > 0);
> >=20
> > And this fixes the hang, and makes level handling more readable.
> >=20
> > Fix the timeout code, now it actually works. Driver still fails after
> > a while.
> >=20
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> >=20
> > diff --git a/drivers/hwmon/omap3-temp.c b/drivers/hwmon/omap3-temp.c
> > index 8a69604..1b8c768 100644
> > --- a/drivers/hwmon/omap3-temp.c
> > +++ b/drivers/hwmon/omap3-temp.c
> > @@ -130,9 +130,7 @@ static inline bool wait_for_eocz(struct omap3_temp_=
data *data,
> >  	ktime_t timeout, expire;
> >  	u32 temp_sensor_reg, eocz_mask;
> > =20
> >  	eocz_mask =3D BIT(data->hwdata->eocz_bit);
> > -	level &=3D 1;
> > -	level *=3D eocz_mask;
> > =20
> >  	expire =3D ktime_add_ns(ktime_get(), max_delay);
> >  	timeout =3D ktime_set(0, min_delay);
> > @@ -140,9 +141,9 @@ static inline bool wait_for_eocz(struct omap3_temp_=
data *data,
> >  	schedule_hrtimeout(&timeout, HRTIMER_MODE_REL);
> >  	do {
> >  		regmap_read(data->syscon, SYSCON_TEMP_REG, &temp_sensor_reg);
> > -		if ((temp_sensor_reg & eocz_mask) =3D=3D level)
> > +		if (!!(temp_sensor_reg & eocz_mask) =3D=3D level)
> >  			return true;
> > -	} while (ktime_us_delta(expire, ktime_get()) > 0);
> > +	} while (ktime_after(expire, ktime_get()));
> > =20
> Does this have to be a hard loop, without sleep ? I am a bit concerned th=
at it
> may loop for more than a ms.
>=20
> Other than that, I assume we'll see an updated version with the coding st=
yle
> issues and hang-up problems fixed.

I will send a v2 patchset with Pavels change requests. It may take a
few days though, since I'm currently at a conference (31C3).

-- Sebastian

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUn9ZRAAoJENju1/PIO/qaeZQP/jEjABne9+ymh3zDYNP5i8bO
tbnsRthwdlFCwxBD2rxR0PgbBU0NnhNMTwy0wekMDsQrlRFVSI56ixO0iudcyyiD
6A9IRJKGf0t8T9TrPJztG6hMuBfJMxqNfY7aDM2lsKWmhn1l1XLPyStvPkW1uFLl
jm8qvBY9jS3ckkh2yaT9Z7QVdd7FjtaxDiqAZ7RvHPiIEKDTyjfv7y4KB3DHqdvg
SajlLw5HsqYa296HYC/x/rFybtzeJX1iAolH3h4RK+1B0yuFUK59O5Mn2IHE3or2
yumnjjviZOazj/mKuOpTAuTSc7z3zGLGZ5/pnOxfWT2nX7zw7vzHXT0wVYfpJC3E
wpcyjL9aibTxUo1pTNq5ZFh9jWYPu+ld7nSnyB6XHag6TRkpMHfp+gLZPsLYuSKc
quwSYjzTFJ9JpPy5BDm0FWtxFuYQsCa4G07rUoaWMXcYG+W9UlrhSV0pPPm97CX5
wUAJdOvPH2zvhk6Faaa3KQ0z2iBAvgGY7CVh02cuPHId17FvwM3nEPM/4OS0a6GM
nTrWwhCPdbKjJpMmU3BFaeN+Zd4NjAkL8v/uUrR6q7lj0UqS0jXNaiPzsWPaAUMJ
JED8KKwz8Q0krwGJuHwcZ9a3E52OkbIeQUviagE2dCIbDMgojLCSpSKWtYA4AVVm
QKV3kiXxlcXuawTBT9Xw
=VMkA
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
