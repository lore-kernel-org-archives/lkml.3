Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbaI1KR4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 06:17:56 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49981 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaI1KRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 06:17:54 -0400
Date: Sun, 28 Sep 2014 11:16:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: lgirdwood@gmail.com, shawn.guo@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        festevam@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Message-ID: <20140928101650.GL27755@sirena.org.uk>
References: <1411779588-22031-1-git-send-email-stefan.wahren@i2se.com>
 <1411779588-22031-3-git-send-email-stefan.wahren@i2se.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1nVygsiVWPqOX6k"
Content-Disposition: inline
In-Reply-To: <1411779588-22031-3-git-send-email-stefan.wahren@i2se.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.138
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: add mxs regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1nVygsiVWPqOX6k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 27, 2014 at 12:59:48AM +0000, Stefan Wahren wrote:

> +	pr_debug("%s: min_uV %d, max_uV %d, min %d, max %d\n", __func__,
> +		 min_uV, max_uV, con->min_uV, con->max_uV);
> +
> +	if (max_uV < con->min_uV || max_uV > con->max_uV)
> +		return -EINVAL;

This is replicating checks done by the core.

> +	val = (max_uV - con->min_uV) * sreg->rdesc.n_voltages /
> +			(con->max_uV - con->min_uV);

Drivers should never look at their constraints, they should let the core
do that and just do what they're asked.  In this case it is probably
best to implement a get_voltage_sel() operation and have the conversion
to voltage done by regulator_map_voltage_linear(), this will both make
the code look better and mean the driver gets the benefit of all the
error checking done by the core.

> +	writel(val | regs, sreg->base_addr);
> +	for (i = 20; i; i--) {
> +		/* delay for fast mode */
> +		if (readl(power_sts) & BM_POWER_STS_DC_OK)
> +			return 0;
> +
> +		udelay(1);
> +	}
> +
> +	writel(val | regs, sreg->base_addr);
> +	start = jiffies;
> +	while (1) {
> +		/* delay for normal mode */
> +		if (readl(power_sts) & BM_POWER_STS_DC_OK)
> +			return 0;

This really needs a comment to explain what on earth is going on here -
the whole thing with writing the same thing twice with two delays is
more than a little odd.  It looks like the driver is trying to busy wait
in cases where the change happens quickly but the comments about "fast"
and "normal" mode make this unclear.

> +	pr_debug("%s: %s register val %d\n", __func__, sreg->name, val);
> +
> +	switch (sreg->rdesc.id) {
> +	case MXS_VDDA:
> +		val >>= 16;
> +		break;
> +	case MXS_VDDD:
> +		val >>= 20;
> +		break;
> +	}
> +
> +	return val ? 1 : 0;
> +}

This seems buggy - it'll always return true for MXS_VDDD if MXS_VDDA
enabled won't it?

> +static unsigned int mxs_get_mode(struct regulator_dev *reg)
> +{
> +	struct mxs_regulator *sreg = rdev_get_drvdata(reg);
> +	u32 val = readl(sreg->base_addr) & sreg->mode_mask;
> +
> +	return val ? REGULATOR_MODE_FAST : REGULATOR_MODE_NORMAL;
> +}

Please try to avoid the ternery operator, it does nothing for
legibility.

> +	if (of_property_read_string(np, "regulator-name", &name)) {
> +		dev_err(dev, "missing property regulator-name\n");
> +		return -EINVAL;
> +	}

Use different compatibles to identify the regulators, regulator-name
should never be mandatory.

> +	switch (sreg->rdesc.id) {
> +	case MXS_VDDIO:
> +		sreg->mode_mask = BIT(17);
> +		break;
> +	case MXS_VDDA:
> +		sreg->mode_mask = BIT(18);
> +		break;
> +	case MXS_VDDD:
> +		sreg->mode_mask = BIT(22);
> +		break;
> +	}

Why is this not looked up from the data structure like the rest of the
data?

> +	dev_info(dev, "%s found\n", name);

Don't add noise like this to the boot log, it provides no useful
information.

> +	regulator_unregister(rdev);
> +	iounmap(power_addr);
> +	iounmap(base_addr);

Use devm_ versions of functions.

> +static int __init mxs_regulator_init(void)
> +{
> +	return platform_driver_register(&mxs_regulator_driver);
> +}
> +postcore_initcall(mxs_regulator_init);

module_platform_driver().

--X1nVygsiVWPqOX6k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUJ+ANAAoJECTWi3JdVIfQ+cwH/0zGDvnCygy3oI1Gx3QgZdgs
4O4iQRocFHmFrkyEW31UGe96ze3hnLYXWALYJR4iPCXf4Eo1oGHhLm9Hf1GQs50j
KZ94dL27b0JaRfAgH3GvOOG+Gu72/um/I8mD6VvO0TDBU4wPYHvETITnp+Ukm9bx
hVlYlc81T0wiPcUITe6nX95uFQHatE/9qFb07gK/F51peeLg8Gk/4Zb7HwJtWI2C
mIo7TfIIu3EtkwsClCft/VRKcB5Dnf2vNnmuutbrd9hXxEKHxRvbzQRHwxrbkU+a
trNPt+tVefmor/qbK5rKgXDQhV4k4rmge3jSJHMI8a4NbDg6HWAsIt3Vbbbreck=
=oGMv
-----END PGP SIGNATURE-----

--X1nVygsiVWPqOX6k--
