Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964930Ab3FSWXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:23:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43115 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934961Ab3FSWXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:23:52 -0400
Message-ID: <51C22F6B.8040807@ti.com>
Date: Wed, 19 Jun 2013 18:23:39 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 11/30] thermal: exynos: Support thermal tripping
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-12-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-12-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2HKSXMLBLFSPAEKSSTEFB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2HKSXMLBLFSPAEKSSTEFB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> TMU urgently sends active-high signal (thermal trip) to PMU, and therma=
l
> tripping by hardware logic. Thermal tripping means that PMU cuts off th=
e
> whole power of SoC by controlling external voltage regulator.
>=20
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

> ---
>  drivers/thermal/samsung/exynos_tmu.c      |   45 +++++++++++++++++++++=
++++---
>  drivers/thermal/samsung/exynos_tmu_data.c |    2 +
>  drivers/thermal/samsung/exynos_tmu_data.h |    2 +
>  3 files changed, 44 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index 6fd776f..33f494e 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -117,7 +117,7 @@ static int exynos_tmu_initialize(struct platform_de=
vice *pdev)
>  	struct exynos_tmu_data *data =3D platform_get_drvdata(pdev);
>  	struct exynos_tmu_platform_data *pdata =3D data->pdata;
>  	const struct exynos_tmu_registers *reg =3D pdata->registers;
> -	unsigned int status, trim_info;
> +	unsigned int status, trim_info =3D 0, con;
>  	unsigned int rising_threshold =3D 0, falling_threshold =3D 0;
>  	int ret =3D 0, threshold_code, i, trigger_levs =3D 0;
> =20
> @@ -144,10 +144,26 @@ static int exynos_tmu_initialize(struct platform_=
device *pdev)
>  			(data->temp_error2 !=3D 0))
>  		data->temp_error1 =3D pdata->efuse_value;
> =20
> -	/* Count trigger levels to be enabled */
> -	for (i =3D 0; i < MAX_THRESHOLD_LEVS; i++)
> -		if (pdata->trigger_levels[i])
> +	if (pdata->max_trigger_level > MAX_THRESHOLD_LEVS) {
> +		dev_err(&pdev->dev, "Invalid max trigger level\n");
> +		goto out;
> +	}
> +
> +	for (i =3D 0; i < pdata->max_trigger_level; i++) {
> +		if (!pdata->trigger_levels[i])
> +			continue;
> +
> +		if ((pdata->trigger_type[i] =3D=3D HW_TRIP) &&
> +		(!pdata->trigger_levels[pdata->max_trigger_level - 1])) {
> +			dev_err(&pdev->dev, "Invalid hw trigger level\n");
> +			ret =3D -EINVAL;
> +			goto out;
> +		}
> +
> +		/* Count trigger levels except the HW trip*/
> +		if (!(pdata->trigger_type[i] =3D=3D HW_TRIP))
>  			trigger_levs++;
> +	}
> =20
>  	if (data->soc =3D=3D SOC_ARCH_EXYNOS4210) {
>  		/* Write temperature code for threshold */
> @@ -165,7 +181,8 @@ static int exynos_tmu_initialize(struct platform_de=
vice *pdev)
>  		writel(reg->inten_rise_mask, data->base + reg->tmu_intclear);
>  	} else if (data->soc =3D=3D SOC_ARCH_EXYNOS) {
>  		/* Write temperature code for rising and falling threshold */
> -		for (i =3D 0; i < trigger_levs; i++) {
> +		for (i =3D 0;
> +		i < trigger_levs && i < EXYNOS_MAX_TRIGGER_PER_REG; i++) {
>  			threshold_code =3D temp_to_code(data,
>  						pdata->trigger_levels[i]);
>  			if (threshold_code < 0) {
> @@ -191,6 +208,24 @@ static int exynos_tmu_initialize(struct platform_d=
evice *pdev)
>  		writel((reg->inten_rise_mask << reg->inten_rise_shift) |
>  			(reg->inten_fall_mask << reg->inten_fall_shift),
>  				data->base + reg->tmu_intclear);
> +
> +		/* if last threshold limit is also present */
> +		i =3D pdata->max_trigger_level - 1;
> +		if (pdata->trigger_levels[i] &&
> +				(pdata->trigger_type[i] =3D=3D HW_TRIP)) {
> +			threshold_code =3D temp_to_code(data,
> +						pdata->trigger_levels[i]);
> +			if (threshold_code < 0) {
> +				ret =3D threshold_code;
> +				goto out;
> +			}
> +			rising_threshold |=3D threshold_code << 8 * i;
> +			writel(rising_threshold,
> +				data->base + reg->threshold_th0);
> +			con =3D readl(data->base + reg->tmu_ctrl);
> +			con |=3D (1 << reg->therm_trip_en_shift);
> +			writel(con, data->base + reg->tmu_ctrl);
> +		}
>  	}
>  out:
>  	clk_disable(data->clk);
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/therma=
l/samsung/exynos_tmu_data.c
> index 589a519..e7cb1cc 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -123,6 +123,7 @@ struct exynos_tmu_platform_data const exynos5250_de=
fault_tmu_data =3D {
>  	.trigger_levels[0] =3D 85,
>  	.trigger_levels[1] =3D 103,
>  	.trigger_levels[2] =3D 110,
> +	.trigger_levels[3] =3D 120,
>  	.trigger_enable[0] =3D 1,
>  	.trigger_enable[1] =3D 1,
>  	.trigger_enable[2] =3D 1,
> @@ -130,6 +131,7 @@ struct exynos_tmu_platform_data const exynos5250_de=
fault_tmu_data =3D {
>  	.trigger_type[0] =3D THROTTLE_ACTIVE,
>  	.trigger_type[1] =3D THROTTLE_ACTIVE,
>  	.trigger_type[2] =3D SW_TRIP,
> +	.trigger_type[3] =3D HW_TRIP,
>  	.max_trigger_level =3D 4,
>  	.gain =3D 8,
>  	.reference_voltage =3D 16,
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/therma=
l/samsung/exynos_tmu_data.h
> index 0e2244f..4acf070 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -91,6 +91,8 @@
>  #define EXYNOS_EMUL_DATA_MASK	0xFF
>  #define EXYNOS_EMUL_ENABLE	0x1
> =20
> +#define EXYNOS_MAX_TRIGGER_PER_REG	4
> +
>  #if defined(CONFIG_CPU_EXYNOS4210)
>  extern struct exynos_tmu_platform_data const exynos4210_default_tmu_da=
ta;
>  #define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2HKSXMLBLFSPAEKSSTEFB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCL2sACgkQCXcVR3XQvP2dnwEA4EwTNF4GSzi8TFPU0fBcXMWa
xwvhkizNHcYMOT4uX84BAIg+KfDhpYnLgSszpsPs/gis7ftE1D0WF/aJUDT3d5Jq
=wRXT
-----END PGP SIGNATURE-----

------enig2HKSXMLBLFSPAEKSSTEFB--
