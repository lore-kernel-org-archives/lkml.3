Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaGHIEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:04:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52270 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaGHID7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:03:59 -0400
Date: Tue, 8 Jul 2014 09:36:19 +0200
From: Mark Brown <broonie@kernel.org>
To: James Ban <james.ban.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20140708073619.GO30458@sirena.org.uk>
References: <201407030730.s637UuCh011846@krsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E+IgQzR66AIOcbjA"
Content-Disposition: inline
In-Reply-To: <201407030730.s637UuCh011846@krsrvapps-01.diasemi.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V4] regulator: DA9211 : new regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E+IgQzR66AIOcbjA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 03, 2014 at 04:29:03PM +0900, James Ban wrote:

This is greatly improved, thanks, however there are still a few issues
which should be addressed:

> +static irqreturn_t da9211_irq_handler(int irq, void *data)
> +{
> +	struct da9211 *chip = data;
> +	int reg_val, ret;
> +
> +	ret = regmap_read(chip->regmap, DA9211_REG_EVENT_B, &reg_val);
> +	if (ret < 0)
> +		goto error_i2c;
> +
> +	if (reg_val & DA9211_E_OV_CURR_A) {

> +	if (reg_val & DA9211_E_OV_CURR_B) {

> +
> +	return IRQ_HANDLED;

This is buggy - the driver should only return IRQ_HANDLED if it handled
the interrupt somehow, otherwise it should return IRQ_NONE and let the
interrupt core handle things.  This is especially important since the
device appears to require that interrupts are explicitly acknoweldged so
if something is flagged but not handled the interrupt will just sit
constantly asserted.

> +static int da9211_regulator_init(struct da9211 *chip)
> +{
> +	struct regulator_config config = { };
> +	int i, ret;
> +	unsigned int data;
> +
> +	ret = regmap_update_bits(chip->regmap, DA9211_REG_PAGE_CON,
> +			DA9211_REG_PAGE_MASK, DA9211_REG_PAGE2);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "Failed to update PAGE reg: %d\n", ret);
> +		goto err;
> +	}

It would be better to model the paging in the register map in the regmap
- the API has support for this, it's going to be more robust to use it.

> +		dev_info(chip->dev, "# IRQ configured [%d]\n", chip->chip_irq);

> +	for (i = 0; i < chip->num_regulator; i++)
> +		regulator_unregister(chip->rdev[i]);

Use devm_regulator_register().

> +	if (chip->chip_irq != 0)
> +		free_irq(chip->chip_irq, chip);

devm_request_threaded_irq().

--E+IgQzR66AIOcbjA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTu59qAAoJELSic+t+oim9mNsP/jZa1qJwOirrpaJSowjCWH4F
X5HqIiJg208ofAQsfgD6KdZAiL7oLBWcrMPoZZh0xV58AQ5tn4sbm/EoOvMHVc9p
N7I+FttlFp+Lvs0WF7a52oqZ37xt/71jSQ5jH/sT13z5bZjSY7S16x65ouGlmIwS
V0DNDwJhDpmUkEHbIUjAgSBUDxdLpFR9VaZEn3E1DIdr5z4us7mV7NK0+4MS0fSZ
tJlObhvZntI4KK+D4YFqOpryvz+KpNeV2i75nHO341ftuWILtiL7GSLyL6nMak6b
2FhBl75ZNlaS/5tnUxdqNeY7ARytcyEGeKRnUHUWkVLCHjn2eMH7SiN/SJ0jVyHS
PseZpyTKAZhHtNwA6dC+6Z8Ge8gKi2FyzsVodAm/sqmxmBR2AZAQgvZxKH0BG0ue
aVqhwNnc/yMSbhMly5qB/uwYku7nEsj8f8B9eOCD4TCPe55vShPpu3hMIbstfYvz
zHWxpPNSoowvXG6JBlBcozggTTwyQGD08+neLQ6sG+mPeQthVBXSSUrD0e5DmidC
5V8kLPZBBKADzeMJ93rV/cMHouY7tieWRW+Jh2LQYihLwByT66J4kmjbwzDvSmYE
d7zVPfBu9nYPe+EGAOqFwasECYzIWfCr2u/PheVHQARuSn7sVmSnTQzwzxdglXxL
oGpuqpXzaULhcKwZQTNm
=rS9D
-----END PGP SIGNATURE-----

--E+IgQzR66AIOcbjA--
