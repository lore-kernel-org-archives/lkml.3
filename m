Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935598Ab3FTCap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:30:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42283 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935506Ab3FTCan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:30:43 -0400
Message-ID: <51C26948.1010909@ti.com>
Date: Wed, 19 Jun 2013 22:30:32 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 26/30] thermal: exynos: Add hardware mode thermal calibration
 support
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-27-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-27-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2JFQWQEGOLHXKUVMFXEVT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2JFQWQEGOLHXKUVMFXEVT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> This patch adds support for h/w mode calibration in the TMU controller.=

> soc's like 5440 support this features.
>=20
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu.c      |   15 +++++++++++++++
>  drivers/thermal/samsung/exynos_tmu.h      |    6 ++++++
>  drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
>  drivers/thermal/samsung/exynos_tmu_data.h |    2 ++
>  4 files changed, 25 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index af0e6ca..7a259f4 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -73,6 +73,9 @@ static int temp_to_code(struct exynos_tmu_data *data,=
 u8 temp)
>  	struct exynos_tmu_platform_data *pdata =3D data->pdata;
>  	int temp_code;
> =20
> +	if (pdata->cal_mode =3D=3D HW_MODE)
> +		return temp;
> +
>  	if (data->soc =3D=3D SOC_ARCH_EXYNOS4210)
>  		/* temp should range between 25 and 125 */
>  		if (temp < 25 || temp > 125) {
> @@ -107,6 +110,9 @@ static int code_to_temp(struct exynos_tmu_data *dat=
a, u8 temp_code)
>  	struct exynos_tmu_platform_data *pdata =3D data->pdata;
>  	int temp;
> =20
> +	if (pdata->cal_mode =3D=3D HW_MODE)
> +		return temp_code;
> +
>  	if (data->soc =3D=3D SOC_ARCH_EXYNOS4210)
>  		/* temp_code should range between 75 and 175 */
>  		if (temp_code < 75 || temp_code > 175) {
> @@ -155,6 +161,9 @@ static int exynos_tmu_initialize(struct platform_de=
vice *pdev)
>  	if (TMU_SUPPORTS(pdata, TRIM_RELOAD))
>  		__raw_writel(1, data->base + reg->triminfo_ctrl);
> =20
> +	if (pdata->cal_mode =3D=3D HW_MODE)
> +		goto skip_calib_data;
> +
>  	/* Save trimming info in order to perform calibration */
>  	if (data->soc =3D=3D SOC_ARCH_EXYNOS5440) {
>  		/*
> @@ -190,6 +199,7 @@ static int exynos_tmu_initialize(struct platform_de=
vice *pdev)
>  			(pdata->efuse_value >> reg->triminfo_85_shift) &
>  			EXYNOS_TMU_TEMP_MASK;
> =20
> +skip_calib_data:
>  	if (pdata->max_trigger_level > MAX_THRESHOLD_LEVS) {
>  		dev_err(&pdev->dev, "Invalid max trigger level\n");
>  		goto out;
> @@ -319,6 +329,11 @@ static void exynos_tmu_control(struct platform_dev=
ice *pdev, bool on)
>  		con |=3D (pdata->noise_cancel_mode << reg->therm_trip_mode_shift);
>  	}
> =20
> +	if (pdata->cal_mode =3D=3D HW_MODE) {
> +		con &=3D ~(reg->calib_mode_mask << reg->calib_mode_shift);
> +		con |=3D pdata->cal_type << reg->calib_mode_shift;

cal_type is an enum and you don't set any constant value to those
enumerations. are you sure you want to rely on it for bit field handling?=


> +	}
> +
>  	if (on) {
>  		con |=3D (1 << reg->core_en_shift);
>  		interrupt_en =3D
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/sam=
sung/exynos_tmu.h
> index 73aaed7..abfa1eb 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -88,6 +88,10 @@ enum soc_type {
>   * @buf_slope_sel_shift: shift bits of amplifier gain value in tmu_ctr=
l
>  	register.
>   * @buf_slope_sel_mask: mask bits of amplifier gain value in tmu_ctrl =
register.
> + * @calib_mode_shift: shift bits of calibration mode value in tmu_ctrl=

> +	register.
> + * @calib_mode_mask: mask bits of calibration mode value in tmu_ctrl
> +	register.
>   * @therm_trip_tq_en_shift: shift bits of thermal trip enable by TQ pi=
n in
>  	tmu_ctrl register.
>   * @core_en_shift: shift bits of TMU core enable bit in tmu_ctrl regis=
ter.
> @@ -149,6 +153,8 @@ struct exynos_tmu_registers {
>  	u32	therm_trip_en_shift;
>  	u32	buf_slope_sel_shift;
>  	u32	buf_slope_sel_mask;
> +	u32	calib_mode_shift;
> +	u32	calib_mode_mask;
>  	u32	therm_trip_tq_en_shift;
>  	u32	core_en_shift;
> =20
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/therma=
l/samsung/exynos_tmu_data.c
> index b34e726..47c5d6b 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -189,6 +189,8 @@ static const struct exynos_tmu_registers exynos5440=
_tmu_registers =3D {
>  	.therm_trip_en_shift =3D EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
>  	.buf_slope_sel_shift =3D EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
>  	.buf_slope_sel_mask =3D EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
> +	.calib_mode_shift =3D EXYNOS_TMU_CALIB_MODE_SHIFT,
> +	.calib_mode_mask =3D EXYNOS_TMU_CALIB_MODE_MASK,
>  	.core_en_shift =3D EXYNOS_TMU_CORE_EN_SHIFT,
>  	.tmu_status =3D EXYNOS5440_TMU_S0_7_STATUS,
>  	.tmu_cur_temp =3D EXYNOS5440_TMU_S0_7_TEMP,
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/therma=
l/samsung/exynos_tmu_data.h
> index 43ce5fb..dc7feb5 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -75,6 +75,8 @@
>  #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
>  #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
>  #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
> +#define EXYNOS_TMU_CALIB_MODE_SHIFT	4
> +#define EXYNOS_TMU_CALIB_MODE_MASK	0x3
> =20
>  #define EXYNOS_TMU_INTEN_RISE0_SHIFT	0
>  #define EXYNOS_TMU_INTEN_RISE1_SHIFT	4
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2JFQWQEGOLHXKUVMFXEVT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCaUgACgkQCXcVR3XQvP3eFQD+N08QUgXH+vF9yJVmcimcxwKL
yZm0T84EwFS6QVZAqgoA/3lRdo49rbcXkMWYHldRNETvZaiQjo8cxUagJGKIXGqT
=O7fl
-----END PGP SIGNATURE-----

------enig2JFQWQEGOLHXKUVMFXEVT--
