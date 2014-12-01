Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351AbaLAQN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:13:29 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45193 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120AbaLAQNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:13:24 -0500
Date: Mon, 1 Dec 2014 16:12:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Flora Fu <flora.fu@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Sandeep Nair <sandeep_n@ti.com>, Andy Gross <agross@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, srv_heupstream@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>
Message-ID: <20141201161219.GG7712@sirena.org.uk>
References: <1417146874-5232-1-git-send-email-flora.fu@mediatek.com>
 <1417146874-5232-4-git-send-email-flora.fu@mediatek.com>
 <20141128152247.GR7712@sirena.org.uk>
 <1417402305.30873.78.camel@mtksdaap41>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1uQmAhkvaZVrm9dD"
Content-Disposition: inline
In-Reply-To: <1417402305.30873.78.camel@mtksdaap41>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 3/8] regulator: MT6397: Add support for MT6397
 regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1uQmAhkvaZVrm9dD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 01, 2014 at 10:51:44AM +0800, Flora Fu wrote:
> On Fri, 2014-11-28 at 15:22 +0000, Mark Brown wrote:

> > Why does nothing else in the driver know about this "hw control mode" -
> > what does it actually mean, shouldn't it affect some of the other
> > operations?

> In the regulator, we have two parts of registers to control the output
> in voltage selection. The mode setting is done in boot loader stage
> before kernel.

> The hw control mode is used for external signal to control voltage
> selection. When the hw control mode is chosen, "voselon" register is the
> action register to do voltage selection if consumer make voltage
> selection. Without hw control mode, vsel_reg is the action register.
> To fit all mode selection, we update and sync two parts of registers in
> regulator framework.

There must be more going on in hardware control mode than that, for
example this "external signal to control voltage selection" must be able
to pick between at least different voltages otherwise it wouldn't seem
to make sense.  I'm concerned that this implementation is making some
assumption about the way in which the hardware control is being used in
a particular system and will be broken in other systems, for example if
something does start actively trying to vary the voltage.

> > > +static int mt6397_buck_get_voltage_sel(struct regulator_dev *rdev)
> > > +{

> > > +static int mt6397_regulator_is_enabled(struct regulator_dev *rdev)
> > > +{

> > To repeat my comments on the last version: please use the generic regmap
> > operations rather than copying them.

> The generic helper function does not fit usage of the regulator.=20
> In general function, it considers that the vsel_reg for selection
> voltage is also the register for querying voltage selection. The enable
> bit for enable function is the bit for querying the status.=20

> In the hardware design, the output of voltage selection register is
> different from vsel_reg. Is is located in nivosel. The enable bit is
> locate in the other bit called "qi_mask". =20

Since you've currently got a custom set voltage function there's no
reason not to use this as the register that gets passed to the core and
hence to use the generic operation.  However I am a bit concerned about
this - what is this actually reporting?  Is it just something that
switches between the hardware and software control voltage automatically
or is it doing some kind of measurment of the output and reporting that?
The general idea is that get_voltage() should report the configured
voltage, monitoring of performance should be done via hwmon or similar.

Similarly for the enable state; we're looking for the state requested by
software not the current state of the regulator - that should be
reported via get_status() for use in error handling cases.

> > > +	np =3D of_node_get(pdev->dev.parent->of_node);
> > > +	if (!np)
> > > +		return -EINVAL;

> > > +	regulators =3D of_get_child_by_name(np, "regulators");

> > To further repeat my

> >  previous review comments:

> > | Define regulators_node and of_match in the regulator desc and you can
> > | remove both this table and all your DT matching code in the driver, t=
he
> > | core will handle it for you.

> > Please don't ignore review comments.

> Sure, I think I completely misunderstood what you meant. Could you give
> more details about the comments?
> In this version, the table for DT matching is removed and merged into
> regulator info in table mt6397_regulators. To register every regulator
> by devm_regulator_register(), the of_node is parsed from
> of_regulator_match() by name. Here is to retrieves the device_node
> "regulators" for of_regulator_match() to get all regulator_init_data and
> corresponding of_node.
> Is any other mechanism I can use to achieve these part without
> of_regulstor_match()?

What I'm understanding from the above is that the code currently only
registers regulators that are listed in DT (I've not read it in detail).
This is not what should be happening, the driver should always register
all the regulators for the device regardless of if they are mentioned in
a DT somewhere.  That way people can read what's currently set in the
hardware which is useful for bringup and diagnostics.

--1uQmAhkvaZVrm9dD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUfJNjAAoJECTWi3JdVIfQJ+MH/jbbAjn6BuoEk7u6pGuq/lMG
hZzPC+JZzYXvwWEgLlHNqK1ADmicCdZvKA96Ik7UWzmVacX/6gHIYIY3LVy0Z2z0
dFfba/WCB5oZSeCnDXCqXPiHz8w1ca/mjjqrNdG8jP7bSXz4RkNeHi2DOzgOf4OO
n9q9zseFLnfCVxUmYhTK5NfWphpQfNB2R5Jh4uyrNXwDk45SNqva0TQqJPeWpAVf
iIYiDWOz6O6sMDrWsmoMt4fq1Gg9f22Tf1/5DFZwCM5Slsw2vko5iutgycbD76gX
swtPJ7ux1f4kmzamM3PY3ptjHmcFXg7I2UyaRH4BEofp0MdCM1kBKAxN4zd5p8Y=
=HPmF
-----END PGP SIGNATURE-----

--1uQmAhkvaZVrm9dD--
