Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab3KMNN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 08:13:57 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42944 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab3KMNNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 08:13:55 -0500
Date: Wed, 13 Nov 2013 13:13:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20131113131328.GF878@sirena.org.uk>
References: <1384328457-5147-1-git-send-email-k.kozlowski@samsung.com>
 <1384328457-5147-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3yNHWXBV/QO9xKNm"
Content-Disposition: inline
In-Reply-To: <1384328457-5147-2-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.183.27
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] mfd: max14577: Add max14577 MFD driver core
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3yNHWXBV/QO9xKNm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 13, 2013 at 08:40:54AM +0100, Krzysztof Kozlowski wrote:

> +/**
> + * After resuming from suspend it may happen that IRQ is signalled but
> + * IRQ GPIO is not high. Also the interrupt registers won't have any data
> + * (all of them equal to 0x00).
> + *
> + * In such case retry few times reading the interrupt registers.
> + */
> +#define IRQ_READ_REG_RETRY_CNT		5

What is the cause here?  This smells like an unreliable workaround for
some other behaviour.  In general this all looks very like standard
regmap code.

> +	for (i = 0; i < MAX14577_IRQ_REGS_NUM; i++) {
> +		u8 mask_reg = max14577_mask_reg[i];
> +
> +		if (mask_reg == MAX14577_REG_INVALID ||
> +				IS_ERR_OR_NULL(max14577->regmap))
> +			continue;

Why would this code even be running if you don't have a register map?

> +		dev_info(max14577->dev, "Got interrupts [1:0x%02x, 2:0x%02x, 3:0x%02x]\n",
> +			irq_reg[MAX14577_IRQ_INT1], irq_reg[MAX14577_IRQ_INT2],
> +			irq_reg[MAX14577_IRQ_INT3]);

This is far too noisy, dev_dbg() at most.

> +		gpio_val = gpio_get_value(pdata->irq_gpio);
> +
> +		if (gpio_get_value(pdata->irq_gpio) == 0)
> +			dev_warn(max14577->dev, "IRQ GPIO is not high, retry reading interrupt registers\n");
> +	} while (gpio_val == 0 && --retry > 0);

This looks very strange...

> +	max14577->irq = gpio_to_irq(pdata->irq_gpio);
> +	ret = gpio_request(pdata->irq_gpio, "max14577_irq");
> +	if (ret) {
> +		dev_err(max14577->dev, "Failed requesting GPIO %d: %d\n",
> +				pdata->irq_gpio, ret);
> +		goto err;
> +	}
> +	gpio_direction_input(pdata->irq_gpio);
> +	gpio_free(pdata->irq_gpio);

This means the GPIO handling code that was present in the handling is
broken, it's trying to use the GPIO after it was freed.

> +	ret = request_threaded_irq(max14577->irq, NULL, max14577_irq_thread,
> +				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> +				   "max14577-irq", max14577);

Are you *positive* this is a falling triggered IRQ?  All the code to do
with spinning reading the GPIO state during handling makes it look like
this is in fact an active low interrupt and a lot of the code in here is
working around trying to handle that as the wrong kind of IRQ.

> +int max14577_bulk_write(struct regmap *map, u8 reg, u8 *buf, int count)
> +{
> +	return regmap_bulk_write(map, reg, buf, count);
> +}
> +EXPORT_SYMBOL_GPL(max14577_bulk_write);

Given that these are basically all trivial wrappers around regmap they
probably ought to be static inlines in the header.

> +static struct max14577_platform_data *max14577_i2c_parse_dt(struct device *dev)
> +{

There's no DT binding document?

> +const struct dev_pm_ops max14577_pm = {
> +	.suspend = max14577_suspend,
> +	.resume = max14577_resume,
> +};

SET_SYSTEM_SLEEP_PM_OPS().

> +static int __init max14577_i2c_init(void)
> +{
> +	return i2c_add_driver(&max14577_i2c_driver);
> +}
> +subsys_initcall(max14577_i2c_init);

Why not module_i2c_driver?

--3yNHWXBV/QO9xKNm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSg3r1AAoJELSic+t+oim9RMAP/iqgT1ugPF9VXLjnuqbGpcGn
ilpJrGYrBzsdNzrlGjsAcPPpAYdk4+9JzV+iK92qo6cdbLarz2r3V5uQY77s5SZS
rqothoS1KdeL3fSY0kIzGUljQOWRnkStGUw89SoJbQJxK2HscQY3jWSzhmA7fDGz
WA8MEuB0yy80pczrju2/RpTUenFE3S9jjuE29h4K5nO2yFjTuTvFqjU3qJoBDFZ3
f0g4rFSqhrrK2JSbw/Yd+thTb/jKoYOTBUe19BnbIKu83Uuq+1et56nD2jtDL6gJ
gKeMslvOoLiiup/yeGbDEE1uCD8hl2xFPXmNMxkvhdOwnTgpStfTvDmV6Ih72mmi
875bah6KdNlBesPKHv8WTdEacX455VUtLoCLdeeN4AbDKuW5KKfsYDvhQfseZYM1
U/TV9Rh8VHdMAtjtGXFrDuVVxC9FfL2lXs7vLHdel7EIu2FQd2nBk54I1dai0Naa
X+5RaAIQ07okTnTxTU8xF0uZ0+fuUhG8mLS/UY31t95pKucDEVYeErU8R1g91QQs
ZFDLF3aVV3M6OiCFtT9NDcWdLlFnfFpM4cKX1r9etxhbEKr+Iq37d+SMHw133+6K
th4Ql20SX/8EHWYndrNHyIMnsL1bmo9WCFlBxAzcJq28YhVF5l+5x1FICshA7C2W
hxirPq5lhpS8YPxj6CEl
=F8NS
-----END PGP SIGNATURE-----

--3yNHWXBV/QO9xKNm--
