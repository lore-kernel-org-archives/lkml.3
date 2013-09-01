Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3IAUN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 16:13:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39732 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab3IAUN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 16:13:28 -0400
Date: Sun, 1 Sep 2013 21:13:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Message-ID: <20130901201321.GB23687@sirena.org.uk>
References: <1378065659-18135-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline
In-Reply-To: <1378065659-18135-1-git-send-email-linus.walleij@linaro.org>
X-Cookie: You may be recognized soon.  Hide.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] regulator: add STw481x VMMC driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 01, 2013 at 10:00:59PM +0200, Linus Walleij wrote:

> Hi Mark, I'm seeking an ACK for this driver eventually, to
> take it through the ARM SoC tree with the dependency MFD
> driver and the enablement patches.

I can put it on a branch so it can be pulled into arm-soc - it makes
life easier for framework refactorings to have the driver in the
regulator tree as well.  Would that be OK?

> +static int stw481x_vmmc_enable(struct regulator_dev *reg)
> +{
> +	struct stw481x *stw481x = rdev_get_drvdata(reg);
> +	int ret;
> +
> +	/* First disable the external VMMC if it's active */
> +	ret = regmap_update_bits(stw481x->map, STW_CONF2,
> +				 STW_CONF2_VMMC_EXT, 0);
> +	if (ret)
> +		return ret;

This is a bit unusual - is there some definite relationship between the
two?

> +static int stw481x_vmmc_disable(struct regulator_dev *reg)
> +{
> +	struct stw481x *stw481x = rdev_get_drvdata(reg);
> +
> +	return regmap_update_bits(stw481x->map, STW_CONF1,
> +				  STW_CONF1_PDN_VMMC, 0);
> +}

Should use regulator_disable_regmap().

> +static int stw481x_vmmc_is_enabled(struct regulator_dev *reg)
> +{
> +	struct stw481x *stw481x = rdev_get_drvdata(reg);
> +	int ret;
> +	unsigned int val;
> +
> +	ret = regmap_read(stw481x->map, STW_CONF1, &val);
> +	if (ret)
> +		return ret;
> +	return !!(val & STW_CONF1_PDN_VMMC);
> +}

Should use regulator_is_enabled_regmap().

> +static int stw481x_vmmc_get_voltage_sel(struct regulator_dev *reg)
> +static int stw481x_vmmc_set_voltage_sel(struct regulator_dev *reg,
> +					unsigned selector)

Should use regulator_get/set_voltage_sel_regmap().

> +static ssize_t show_ctrl1(struct device *dev,
> +			  struct device_attribute *attr, char *buf)
> +{
> +	int ret;
> +	unsigned int val;
> +	struct stw481x *stw481x = dev_get_platdata(dev);
> +
> +	ret = regmap_read(stw481x->map, STW_CONF1, &val);
> +	if (ret)
> +		return ret;
> +
> +	return sprintf(buf, "%#x\n", val);
> +};
> +
> +static DEVICE_ATTR(ctrl1, S_IRUGO, show_ctrl1, NULL);

I'd suggest setting max_register (and possibly readable_reg()) in the
regmap config rather than adding specific sysfs files.  Unless there's
some pressing reason for this beyond debug?

> +	stw481x->vmmc_regulator = regulator_register(&vmmc_regulator, &config);
> +	if (IS_ERR(stw481x->vmmc_regulator)) {
> +		dev_err(&pdev->dev,
> +			"error initializing STw481x VMMC regulator\n");
> +		return PTR_ERR(stw481x->vmmc_regulator);
> +	}

I sent patches for a devm_regulator_register() yesterday - it'll be
going into -next after the merge window, though the conversion can
always happen later (I didn't convert most of the drivers yet anyway).

> +static __init int stw481x_vmmc_regulator_init(void)
> +{
> +	return platform_driver_register(&stw481x_vmmc_regulator_driver);
> +}
> +
> +static __exit void stw481x_vmmc_regulator_exit(void)
> +{
> +	platform_driver_unregister(&stw481x_vmmc_regulator_driver);
> +}
> +
> +subsys_initcall(stw481x_vmmc_regulator_init);
> +module_exit(stw481x_vmmc_regulator_exit);

You should be able to use module_platform_driver() with modern systems,
deferred probing should cope with most uses of subsys_initcall().  Not
the end of the world though.

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSI5/eAAoJELSic+t+oim9zvQP/2r3TzB8dJKxzA55NfvFTXWk
MNHY7/0Siv3DscG8yjbAOARaAjnXBScIBTPpnGldeV9fFjHnf98ABOq0ax3xxOZF
YlnCHlHwWEsmK4qzWp5/I4kr/fS01dtTyN4mYhaaNp3cDrSGZ5SyA5b/57rqvAsM
9gN/RNFS3Ewpd2gQQPMibkbOyqL4/P/Q12mXnjDGkTCcOJaNbsMvXeQNQDjBvCi+
WdxFeEPsZde7zHjudh/t3GTZA8V+q84Lykm2DZI8kUwqP5pzgY/6PDFlSsrFmhJz
M4eYbWwmPohXikSVJMteq0WY4L3wb8bD6Fdk9q1YJgJOKl/7JorsydH8KLgs/kdO
X5MzVmYcaQIxVjoat8j3QTNknpi8IiEWBDh/4LbaYivAguseo+cxRp1C7sKeueSu
HcTGF1s2i0c9uod7mwtXRjMXSVVqEjGpcQw1wthkesfL/UDkbWmMwFd20MEtVoRU
XwSMm3LLQEfvOfzg1Z5p9/HNKHB6qP67trbHQ7G1MjlvIqiw7LELNqOz/ADIjLdc
3IPi9j0K+omV3wF6gY/yYvzm9vO/PrEYD6IwpeeldwnsbafEBcZxfXujUC/gyK6C
JedO0LcW4CDU6GdYpr2BOH5sA+PnqnJOBX3ytQ0Vylt3gyixB21YYB0eGNiq/s8m
JsNmO+gOjmzOboeOb7k3
=oY0E
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
