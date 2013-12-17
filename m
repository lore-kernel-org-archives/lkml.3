Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab3LQNHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:07:04 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36720 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab3LQNHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:07:00 -0500
Date: Tue, 17 Dec 2013 13:06:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-doc@vger.kernel.org,
        vpalatin@chromium.org, nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Message-ID: <20131217130653.GA3185@sirena.org.uk>
References: <1387258597-21866-1-git-send-email-wenyou.yang@atmel.com>
 <1387258597-21866-2-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RDizm8Chn3JVD4e1"
Content-Disposition: inline
In-Reply-To: <1387258597-21866-2-git-send-email-wenyou.yang@atmel.com>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3 v2] regulator: act8865: add PMIC act8865 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RDizm8Chn3JVD4e1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2013 at 01:36:35PM +0800, Wenyou Yang wrote:
>  Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

Much better.  Still a few small issues though.

> +/* ACt8865 voltage table */
> +static const u32 act8865_voltages_table[] = {

This is the wrong type for a voltage table but it looks like it
shouldn't be a voltage table at all - this looks like it should be
mapped as linear ranges.

> +static struct regulator_ops act8865_ops = {
> +	.list_voltage		= regulator_list_voltage_table,
> +	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
> +	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
> +	.enable			= regulator_enable_regmap,
> +	.disable		= regulator_disable_regmap,
> +	.is_enabled		= regulator_is_enabled_regmap,
> +	.set_suspend_voltage	= act8865_set_suspend_voltage,
> +	.set_suspend_enable	= regulator_enable_regmap,
> +	.set_suspend_disable	= regulator_disable_regmap,
> +};

This is missing a map_voltage() operation.

> +#ifdef CONFIG_OF
> +static const struct of_device_id act8865_dt_ids[] = {
> +	{ .compatible = "active-semi,act8865" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, act8865_dt_ids);

active-semi needs adding to vendor-prefixes.txt.

> +	np = of_find_node_by_name(dev->of_node, "regulators");
> +	if (!np) {
> +		dev_err(dev, "missing 'regulators' subnode in DT\n");
> +		return -EINVAL;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(rmatch); i++)
> +		rmatch[i].name = act8865_reg[i].name;
> +
> +	matched = of_regulator_match(dev, np, rmatch, ARRAY_SIZE(rmatch));
> +	if (matched <= 0)
> +		return matched;

You should register all regulators the device has regardless of how many
have parameters configured in the DT so that the settings can be read
back for diagnostic purposes.

> +	if (dev->of_node && !pdata) {
> +		const struct of_device_id *id;
> +		struct act8865_platform_data pdata_of;
> +
> +		id = of_match_device(of_match_ptr(act8865_dt_ids), dev);
> +		if (!id)
> +			return -ENODEV;
> +
> +		ret = act8865_pdata_from_dt(dev, of_node, &pdata_of);
> +		if (ret < 0)
> +			return ret;
> +
> +		pdata = &pdata_of;
> +	} else {
> +		memset(of_node, 0, sizeof(of_node));
> +	}

What's this memset() for?

> +		rdev[i] = devm_regulator_register(&client->dev,
> +						&act8865_reg[i], &config);

> +err_unregister:
> +	while (--i >= 0)
> +		regulator_unregister(rdev[i]);

The whole purpose of devm_ APIs is to avoid the need to explicitly
unregister, you shouldn't need to call regulator_unregister() at all.

--RDizm8Chn3JVD4e1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsExqAAoJELSic+t+oim9uMYP/2byL2Xwf2oP3YFayc3tid/D
bjbab+roy8KWUlLTUzYjTZvdNA04PIe/yikVDMTN/YhtKJsN8RxA9XrO1nGl5wFq
uNKWOOHIpydGT5otZngzLn0FJwBSEdALzg4wihbSTqR0UszaQnOSB2ZefH9aozG+
hsRGIMVulU1VX8vhDeGvGL8fzRMv17WEFqmhGusB5FaaG9kuGIHJ7j60tmhX/9TP
6H2vFyb3+i9ids33cdhNhD4KWBxYr++yF0nVu6daq1iJl+P/lrgL6PzafB3pHbgY
+PhywXTRsG8NJgmhDCyYLwDw0eK/Dw633wck7uC5bgWZN0cY9DJyYNggwbMDvzTO
PC4+EFNmo1w5iCKCieSUDWUr8zwQMJ+T/PKrOS0TyrXHey2XOPDgj4ZJaC06mldg
25qlTi93ZvXByp7IBvTCoruu4Ne0b8qcj3r3emMFwLVwTD/HBFBTc4KfelkpmStS
ZsxVQmR0vaVz9bq/7hWG7rkNbXy7bqvFgAYEHPtj9SMstQbmH3rzgFs2WK+Ks2eP
hjyGu74FjAu9ZN/GUR8WwtzqDeOY7qp8FqASvIGN6Tz5sjhm06iFLsfqq3SlOwj7
OsWMQkAilX8CpVrDkPHQrcyya7qBcVVZM7I72Iatr5nf7o2cBi4r9Tj+yuTuSK1g
qtey7jJI8dw+Z2/MGjte
=5CPN
-----END PGP SIGNATURE-----

--RDizm8Chn3JVD4e1--
