Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab3IQLlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 07:41:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43167 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab3IQLlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 07:41:39 -0400
Date: Tue, 17 Sep 2013 12:41:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com, linus.walleij@linaro.org,
        akpm@linux-foundation.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, rtc-linux@googlegroups.com,
        rob.herring@calxeda.com, mark.rutland@arm.com, pawel.moll@arm.com,
        swarren@wwwdotorg.org, rob@landley.net, ijc+devicetree@hellion.org.uk,
        grant.likely@linaro.org, florian.lobmaier@ams.com
Message-ID: <20130917114133.GV21013@sirena.org.uk>
References: <1379400338-20704-1-git-send-email-ldewangan@nvidia.com>
 <1379400338-20704-4-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ipiAXJWFVZGVDOzf"
Content-Disposition: inline
In-Reply-To: <1379400338-20704-4-git-send-email-ldewangan@nvidia.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] regulator: as3722: add regulator driver for AMS
 AS3722
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ipiAXJWFVZGVDOzf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 17, 2013 at 12:15:37PM +0530, Laxman Dewangan wrote:

> +               ams,enable-oc-config: Enable overcurrent configuration of the
> +               ams,oc-trip-threshold-perphase: Overcurrent trip threshold
> +               ams,oc-alarm-threshold-perphase: Overcurrent alarm threshold

These look like you should be implementing the current setting
operations in the framework, probably mapping to the alarm limit if
nothing else.

> +static int as3722_ldo_get_voltage_sel(struct regulator_dev *rdev)
> +{
> +	int ret;
> +
> +	ret = regulator_get_voltage_sel_regmap(rdev);
> +	if (ret >= 0x40)
> +		ret -= 0x1B;
> +	return ret;
> +}

This looks very strange.  What's going on here?  A gap in the selectors?
If that's the case you probably want to be using linear ranges.

> +static struct regulator_ops as3722_ldo_extcntrl_ops = {
> +	.get_voltage_sel = as3722_ldo_get_voltage_sel,
> +	.set_voltage_sel = as3722_ldo_set_voltage_sel,
> +	.list_voltage = regulator_list_voltage_linear,
> +};

You ought to be providing map_voltage() too, same for some if not all of
the other regulators.

> +static unsigned int as3722_sd_get_mode(struct regulator_dev *dev)
> +{
> +	struct as3722_regulators *as3722_regs = rdev_get_drvdata(dev);
> +	struct as3722 *as3722 = as3722_regs->as3722;
> +	int id = rdev_get_id(dev);
> +	u32 val;
> +	int ret;
> +
> +	if (!as3722_reg_lookup[id].control_reg)
> +		return -ERANGE;

That seems a bit of a random error code.  -ENOTSUPP?

> +static int as3722_sd_list_voltage(struct regulator_dev *rdev, unsigned selector)
> +{
> +	if (selector >= AS3722_SD2_VSEL_MAX)
> +		return -EINVAL;
> +
> +	selector++;
> +	if (selector <= 0x40)
> +		return 600000 + selector * 12500;
> +	if (selector <= 0x70)
> +		return 1400000 + (selector - 0x40) * 25000;
> +	if (selector <= 0x7F)
> +		return 2600000 + (selector - 0x70) * 50000;
> +	return -EINVAL;
> +}

Use linear ranges.

> +static struct of_regulator_match as3722_regulator_matches[] = {
> +	{.name = "sd0", },

	{ .name = "sd0", },

> +		config.of_node = as3722_regulator_matches[id].of_node;
> +		rdev = regulator_register(&as3722_regs->desc[id], &config);
> +		if (IS_ERR(rdev)) {

devm_regualtor_register().

> +		if (reg_config->ext_control) {
> +			ret = regulator_enable_regmap(rdev);
> +			if (ret < 0) {
> +				dev_err(&pdev->dev,
> +					"Regulator %d enable failed: %d\n",
> +					id, ret);
> +				goto scrub;
> +			}

This looks wrong...  why is the regualtor being enabled by something
other than the core?

> +static int __init as3722_regulator_init(void)
> +{
> +	return platform_driver_register(&as3722_regulator_driver);
> +}
> +subsys_initcall(as3722_regulator_init);
> +
> +static void __exit as3722_regulator_exit(void)
> +{
> +	platform_driver_unregister(&as3722_regulator_driver);
> +}
> +module_exit(as3722_regulator_exit);

module_platform_driver().

--ipiAXJWFVZGVDOzf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOD/qAAoJELSic+t+oim9DqcQAIBbKCBKPeK8AlIDAhHLT89S
yn6317kv6wFizBhyDwBOFAX2S92Cyniyuhk8859QdXag4fAh0kVTDmz+qZuwxr1e
7hwUmh25DhnPniwHkSwNRKx+DOWCq1/ZQ5L0suwgqNbGb67/uWjzETtLWDrvbVOf
Xt/q6ZRtgc0JaWIHI4oMkZh4n/n+NRzzCgVDIiHiHFEsNdsxL6IgAeS0otWOpajN
YvDbkym7fespZPUij3wRGGExbpRzNgRh489MjbDJI/IJrzMggHvRSPDaOXMyYVOi
9yQL6RDCjF0tNqTK+vWQ5jPYcv60/TjclDEVLoKWTrcSHbwNVLNKNXVzMUdvZkFo
ETaqBrb7Inih8sxqJp+r5LsJYye97Mnc92cNFS9+z/hwbNeGOxEtidJee/0pLFFj
x9LMbXQpmV52KoRsbqlxbWwOzGGr+OeIhvBC7LPqrPqcZ3NXzQ8jbOWZaAtrzzh5
FJbyGVNOQti/MZ7gMcF2e4bG5pT/SWWzo1G7ilauclDT67ctg9JC3noGzXifh4iy
1W9e2XNBpXzQ1kCXwCv87uNFvKVv3oILLRxHwSyA0paWU+wxg9AsD6+V1TnBkruJ
FamdR0Ev6/2qWZQHj3krG6bkycJZxdkX23egp3M5dc58ROCViVmFcIh7NuJ0KMl6
NiGJD7iXahNKD/86JLRV
=cozY
-----END PGP SIGNATURE-----

--ipiAXJWFVZGVDOzf--
