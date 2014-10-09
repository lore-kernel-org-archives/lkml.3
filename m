Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbaJIMkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 08:40:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60915 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757212AbaJIMkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 08:40:05 -0400
Date: Thu, 9 Oct 2014 14:36:07 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: wsa@the-dreams.de, jdelvare@suse.de, arnd@arndb.de, dianders@chromium.org,
        u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, maxime.coquelin@st.com,
        andrew@lunn.ch, sjg@chromium.org, markus.mayer@linaro.org,
        ch.naveen@samsung.com, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, mika.westerberg@linux.intel.com,
        skuribay@pobox.com, Romain.Baeriswyl@abilis.com, wenkai.du@intel.com,
        =?ISO-8859-1?Q?=20=22=1Bchristian.rupp?=.=?ISO-8859-1?Q?ert=22@abilis.com?=.=?ISO-8859-1?Q?,
        ?=.alan@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Illegal-Object: Syntax error in Cc: addresses found on vger.kernel.org:
	Cc:	=?ISO-8859-1?Q?=20=22=1Bchristian.rupp?==?ISO-8859-1?Q?ert=22@abilis.com?= =?ISO-8859-1?Q?
								^-missing end of address
Subject: Re: [PATCH V2] i2c-designware: Add Intel Baytrail PMIC I2C bus
 support
Message-ID: <20141009123607.GE19438@lukather>
References: <1410543367-6565-1-git-send-email-david.e.box@linux.intel.com>
 <1411497626-7984-1-git-send-email-david.e.box@linux.intel.com>
 <20140923190057.GN15315@lukather>
 <20140923195854.GA9921@pathfinder>
 <20140925094752.GY15315@lukather>
 <20141007191420.GA25126@pathfinder>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6v9BRtpmy+umdQlo"
Content-Disposition: inline
In-Reply-To: <20141007191420.GA25126@pathfinder>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6v9BRtpmy+umdQlo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Tue, Oct 07, 2014 at 12:14:20PM -0700, David E. Box wrote:
> Hi Maxime,
>=20
> On Thu, Sep 25, 2014 at 11:47:52AM +0200, Maxime Ripard wrote:
> > Hi David,
> >=20
> > On Tue, Sep 23, 2014 at 12:58:54PM -0700, David E. Box wrote:
> > > Hi Maxime,
> > >=20
> > > On Tue, Sep 23, 2014 at 09:00:57PM +0200, Maxime Ripard wrote:
> > > > Hi David,
> > > >=20
> > > > On Tue, Sep 23, 2014 at 11:40:26AM -0700, David E. Box wrote:
> > > > > This patch implements an I2C bus sharing mechanism between the ho=
st and platform
> > > > > hardware on select Intel BayTrail SoC platforms using the X-Power=
s AXP288 PMIC.
> > > > >=20
> > > > > On these platforms access to the PMIC must be shared with platfor=
m hardware. The
> > > > > hardware unit assumes full control of the I2C bus and the host mu=
st request
> > > > > access through a special semaphore. Hardware control of the bus a=
lso makes it
> > > > > necessary to disable runtime pm to avoid interfering with hardwar=
e transactions.
> > > > >=20
> > > > > Signed-off-by: David E. Box <david.e.box@linux.intel.com>
> > > >=20
> > > > Sorry for stepping in like this without really knowing your platfor=
m,
> > > > but wouldn't using the hwspinlock framework make more sense than
> > > > hardcoding your own internal functions here?
> > >=20
> > > I looked into this but didn't see a clear way on our platform to iden=
tify the
> > > semaphore seperately from doing it in the designware platform driver.=
 The way
> > > we can find it now is through evaluating an ACPI _SEM object on every=
 i2c device
> > > that gets probed by the dw driver since at probe time we can get the =
acpi handle.
> >=20
> > And you have no way to turn it around and identify which semaphore is
> > associated to which i2c bus?
> >=20
> > If so, there is probably some way to associate a given instance of the
> > i2c driver to one semaphore.
> >=20
> > > Without this handle however there isn't a clear way of evaluating the=
 _SEM
> > > object which would be needed to register a hwspinlock in separate cod=
e.
> > >=20
> > > Plus it would still require changes to the designware i2c core, thoug=
h admittedly
> > > having a generic hwspinlock pointer added to the struct is cleaner.
> >=20
> > Not only cleaner, but that could also be used by other platforms that
> > are using this I2C driver (and since it's a designware IP, there must
> > be quite a lot) together with hardware locking.
> >=20
>=20
> After again considering a way to make this work I don't think this api ca=
n fit
> well with our platform. Acquisition of this semaphore is through a mailbox
> sequence where we set one register and then poll another for a value that
> confirms we have the lock. For best performance we need to be able to
> periodically sleep while waiting for that confirmation. This time can vary
> widely as it's dependent on the component we are requesting the semaphore=
 from
> which is itself a user of that bus.
>=20
> While we could simply fail after a short time, reattempts would still need
> to happen in the i2c-designware driver and the timing would be completely
> dependent on our hardware, making it less clean for reuse. In addition,
> if we timed out, we would have to immediately call unlock to cancel the
> mailbox transaction. This may not fit well with reuse either.

Ok, if Wolfram is ok with it, and if it makes your life much easier,
I'm ok :)

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--6v9BRtpmy+umdQlo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNoE3AAoJEBx+YmzsjxAgOugQAKNDTPzU7kJU6NvYyWt5a2LY
e6FE6lS2kUhZFUXPXqxs9blYgrJkflqexHtwK7sS4wpv3cBsqWbiEqs5N+KCWoTN
Gg130vaYFYlckaEAB3emIfDwuEeBm0q8RpG8r6sErgEwI6C08mgZwLJKHKQIrw8O
l6nlhG/Lu5lx/lKRiTj5bFqtTieQi+9iqjTbxOvfP4kY2NuCO4QKykgGpVU1IO4q
0wVPYRkQi7sF3VFwkAqycXW8FV40g0Q5MlxlUI8whk4YiORhv9e5N/c/BjGmbdX+
schArPU8F+NuCNkEdlnhKDCXE9UFYhXPe55wEKcLYfVgBg72Gw3BMwkqleAGsgzA
QPCGD4GcjaXKk4PMeMenoxKDOtlVCA3kR/ZXwu/Io0nOzfn9v8qjIp5YZLbcDh9X
+HSL7cNDg/xSTH/eahl/qxed2CcKOOWIR0MgM8QRnmdPLNwoiu0x6/Sl9nxiWLSr
SexV0RV5gU5IsQ1jNm28ysj6Mb34CAm1GyonpNegkS12GktbZgLX4YVuuxz5Mtj0
TuWFmCTRu5UzlH8NhTjZf7f1aeiQ9tihhYWP3kgzl6F5VwsV4WHcKMFCUYC+RVM1
V9N2wIYMDNsEncwGSfE3KdvDZN99Om0fGl8tvHvs2k3rwkc86RKlPjik6C2+eCpm
waVVmdPRPJhMKXnM2TQG
=PhXP
-----END PGP SIGNATURE-----

--6v9BRtpmy+umdQlo--
