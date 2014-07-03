Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680AbaGCWm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:42:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49798 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbaGCWm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:42:57 -0400
Date: Thu, 3 Jul 2014 17:41:46 -0500
From: Felipe Balbi <balbi@ti.com>
To: Marek Belisko <marek@goldelico.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <tony@atomide.com>, <linux@arm.linux.org.uk>, <balajitk@ti.com>,
        <chris@printf.net>, <ulf.hansson@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mmc@vger.kernel.org>, <hns@goldelico.com>,
        NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] mmc: hsmmc: Add reset gpio configuration option.
Message-ID: <20140703224146.GC2540@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404420564-30245-1-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pk6IbRAofICFmK5e"
Content-Disposition: inline
In-Reply-To: <1404420564-30245-1-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Pk6IbRAofICFmK5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 03, 2014 at 10:49:23PM +0200, Marek Belisko wrote:
> From: NeilBrown <neilb@suse.de>
>=20
> If a 'gpio_reset' is specified, then hold it low while
> turning the power regulator on.
> This is needed for some wi2wi wireless modules, particularly
> when the regulator is held active by some other client.
> The wi2wi needs to be reset if power isn't actually removed, and
> the gpio can be used to do this.
>=20
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  arch/arm/mach-omap2/hsmmc.c            |  7 ++++++-
>  arch/arm/mach-omap2/hsmmc.h            |  3 +++
>  drivers/mmc/host/omap_hsmmc.c          | 26 +++++++++++++++++++++++---
>  include/linux/platform_data/mmc-omap.h |  1 +
>  4 files changed, 33 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/arm/mach-omap2/hsmmc.c b/arch/arm/mach-omap2/hsmmc.c
> index 07d4c7b..046bfdd 100644
> --- a/arch/arm/mach-omap2/hsmmc.c
> +++ b/arch/arm/mach-omap2/hsmmc.c
> @@ -172,6 +172,10 @@ static inline void omap_hsmmc_mux(struct omap_mmc_pl=
atform_data *mmc_controller,
>  		(mmc_controller->slots[0].gpio_wp < OMAP_MAX_GPIO_LINES))
>  		omap_mux_init_gpio(mmc_controller->slots[0].gpio_wp,
>  					OMAP_PIN_INPUT_PULLUP);
> +	if (gpio_is_valid(mmc_controller->slots[0].gpio_reset) &&
> +		(mmc_controller->slots[0].gpio_reset < OMAP_MAX_GPIO_LINES))
> +		omap_mux_init_gpio(mmc_controller->slots[0].gpio_reset,
> +					OMAP_PIN_OUTPUT);
>  	if (cpu_is_omap34xx()) {
>  		if (controller_nr =3D=3D 0) {
>  			omap_mux_init_signal("sdmmc1_clk",
> @@ -270,6 +274,7 @@ static int __init omap_hsmmc_pdata_init(struct omap2_=
hsmmc_info *c,
> =20
>  	mmc->slots[0].switch_pin =3D c->gpio_cd;
>  	mmc->slots[0].gpio_wp =3D c->gpio_wp;
> +	mmc->slots[0].gpio_reset =3D c->gpio_reset;
> =20
>  	mmc->slots[0].remux =3D c->remux;
>  	mmc->slots[0].init_card =3D c->init_card;
> @@ -389,7 +394,7 @@ void omap_hsmmc_late_init(struct omap2_hsmmc_info *c)
>  			continue;
> =20
>  		mmc_pdata->slots[0].switch_pin =3D c->gpio_cd;
> -		mmc_pdata->slots[0].gpio_wp =3D c->gpio_wp;
> +		mmc_pdata->slots[0].gpio_reset =3D c->gpio_reset;
> =20
>  		res =3D omap_device_register(pdev);
>  		if (res)
> diff --git a/arch/arm/mach-omap2/hsmmc.h b/arch/arm/mach-omap2/hsmmc.h
> index 7f2e790..16b2ac5 100644
> --- a/arch/arm/mach-omap2/hsmmc.h
> +++ b/arch/arm/mach-omap2/hsmmc.h
> @@ -24,6 +24,9 @@ struct omap2_hsmmc_info {
>  	bool	deferred;	/* mmc needs a deferred probe */
>  	int	gpio_cd;	/* or -EINVAL */
>  	int	gpio_wp;	/* or -EINVAL */
> +	int	gpio_reset;	/* or -EINVAL - reset is held low during
> +				 * power-on
> +				 */
>  	char	*name;		/* or NULL for default */
>  	struct platform_device *pdev;	/* mmc controller instance */
>  	int	ocr_mask;	/* temporary HACK */
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 9656726..4a264fc 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -300,6 +300,8 @@ static int omap_hsmmc_set_power(struct device *dev, i=
nt slot, int power_on,
>  	if (!host->vcc)
>  		return 0;
> =20
> +	if (gpio_is_valid(mmc_slot(host).gpio_reset))
> +		gpio_set_value_cansleep(mmc_slot(host).gpio_reset, 0);
>  	if (mmc_slot(host).before_set_reg)
>  		mmc_slot(host).before_set_reg(dev, slot, power_on, vdd);
> =20
> @@ -365,6 +367,8 @@ static int omap_hsmmc_set_power(struct device *dev, i=
nt slot, int power_on,
> =20
>  	if (mmc_slot(host).after_set_reg)
>  		mmc_slot(host).after_set_reg(dev, slot, power_on, vdd);
> +	if (gpio_is_valid(mmc_slot(host).gpio_reset))
> +		gpio_set_value_cansleep(mmc_slot(host).gpio_reset, 1);
> =20
>  error_set_power:
>  	return ret;
> @@ -481,10 +485,22 @@ static int omap_hsmmc_gpio_init(struct omap_mmc_pla=
tform_data *pdata)
>  	} else
>  		pdata->slots[0].gpio_wp =3D -EINVAL;
> =20
> -	return 0;
> +	if (gpio_is_valid(pdata->slots[0].gpio_reset)) {
> +		ret =3D gpio_request(pdata->slots[0].gpio_reset, "mmc_reset");
> +		if (ret)
> +			goto err_free_wp;
> +		ret =3D gpio_direction_output(pdata->slots[0].gpio_reset, 1);
> +		if (ret)
> +			goto err_free_reset;
> +	} else
> +		pdata->slots[0].gpio_reset =3D -EINVAL;

looks like this should be implemented as a reset-gpio.c driver. This
piece of code would, then

	reset_assert(slot->reset);
	do_the_magic_dance();
	reset_deassert(slot->reset);

--=20
balbi

--Pk6IbRAofICFmK5e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtdwqAAoJEIaOsuA1yqRE5hIQAJX1keT9fUAe9kHxDskrlxGn
NMrq/uZOKrsuen+8SNZfdGvrPiYKyHSG6apZ6AKvHi6ERjymb//dIlSjHzouzD/x
bhbHX1N0e/tnjFfeW2/zPmJBitR60f7DF9T3bqc2YrB6JDs2PN46LEBaqhzJQ5sV
ixe2sz4ejTf1LQY8i2p+k2GVWG+juSh727tCOOWriE/FxGkdgeb9DIiCRnPOP2Nu
aPrZpCuVFag4sCRP/pE6LyizBRBGzcfaKHK3xT3QjsfAA/SjUA/Zta6fbRaGk3BB
EC/dyjOUe+NuynKZq3ODty2Hsu7qqdBnXURcRjha6NymCfD0taJR25BYaFxtVabs
L1AgeZ8JC4H6CNw0BqEp7bzKmoVRSVJaISbHq1WArcehZG56m0ff7bWQo4wLCsoc
tMNdhaOSlh68KOByZFfuH9GdgGhxalzRHPzASN8dEr95ntGqrbwu/xyllDDsIPJI
/w0takRIeRfRLk8dWoUzylI0N9Dsk04QbUgtg1u7mSA74iQSvXAUDGlep7XcLYzu
fbzBLarAO8/z+ikvV7Ja8Fc46vIWDBwg8q41tS+9sQ9r+4fhRikVWgmXTRDkuc+d
J2kWhu8P8ViuBGpI31TLAVOJCteRMYEAtcSvbX7LOifpiNiPini8GcAvR4Ei4qXD
gz/qrkNngnMnqhcEWNts
=jvA3
-----END PGP SIGNATURE-----

--Pk6IbRAofICFmK5e--
