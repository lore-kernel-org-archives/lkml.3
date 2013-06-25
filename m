Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab3FYNjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:39:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37173 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab3FYNjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:39:00 -0400
Message-ID: <51C99D65.8090308@ti.com>
Date: Tue, 25 Jun 2013 09:38:45 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH RESEND V7 25/30] thermal: exynos: Add hardware mode thermal
 calibration support
References: <1372071051-3167-26-git-send-email-amit.daniel@samsung.com> <1372160818-14607-1-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1372160818-14607-1-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2OXKPOXKSWQMFLFMIBEJK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2OXKPOXKSWQMFLFMIBEJK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 25-06-2013 07:46, Amit Daniel Kachhap wrote:
> This patch adds support for h/w mode calibration in the TMU controller.=

> Soc's like 5440 support this features. The h/w supports two point calib=
ration
> and one point calibration at 85C and 25C.
>=20
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

> ---
> Changes in this patch fixes a setting up of wrong calibration mode by d=
efining
> trim type for 25 and 85C. This will be only used in H/W based calibrati=
on.
>=20
>  drivers/thermal/samsung/exynos_tmu.c      |   33 +++++++++++++++++++++=
+++++++-
>  drivers/thermal/samsung/exynos_tmu.h      |    8 +++++++
>  drivers/thermal/samsung/exynos_tmu_data.c |    2 +
>  drivers/thermal/samsung/exynos_tmu_data.h |    2 +
>  4 files changed, 44 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index 3fac0f9..a6fc379 100644
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
> @@ -297,7 +307,7 @@ static void exynos_tmu_control(struct platform_devi=
ce *pdev, bool on)
>  	struct exynos_tmu_data *data =3D platform_get_drvdata(pdev);
>  	struct exynos_tmu_platform_data *pdata =3D data->pdata;
>  	const struct exynos_tmu_registers *reg =3D pdata->registers;
> -	unsigned int con, interrupt_en;
> +	unsigned int con, interrupt_en, cal_val;
> =20
>  	mutex_lock(&data->lock);
>  	clk_enable(data->clk);
> @@ -320,6 +330,27 @@ static void exynos_tmu_control(struct platform_dev=
ice *pdev, bool on)
>  		con |=3D (pdata->noise_cancel_mode << reg->therm_trip_mode_shift);
>  	}
> =20
> +	if (pdata->cal_mode =3D=3D HW_MODE) {
> +		con &=3D ~(reg->calib_mode_mask << reg->calib_mode_shift);
> +		cal_val =3D 0;
> +		switch (pdata->cal_type) {
> +		case TYPE_TWO_POINT_TRIMMING:
> +			cal_val =3D 3;
> +			break;
> +		case TYPE_ONE_POINT_TRIMMING_85:
> +			cal_val =3D 2;
> +			break;
> +		case TYPE_ONE_POINT_TRIMMING_25:
> +			cal_val =3D 1;
> +			break;
> +		case TYPE_NONE:
> +			break;
> +		default:
> +			dev_err(&pdev->dev, "Invalid calibration type, using none\n");
> +		}
> +		con |=3D cal_val << reg->calib_mode_shift;
> +	}
> +
>  	if (on) {
>  		con |=3D (1 << reg->core_en_shift);
>  		interrupt_en =3D
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/sam=
sung/exynos_tmu.h
> index 25c48d4..b364c9e 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -28,6 +28,8 @@
> =20
>  enum calibration_type {
>  	TYPE_ONE_POINT_TRIMMING,
> +	TYPE_ONE_POINT_TRIMMING_25,
> +	TYPE_ONE_POINT_TRIMMING_85,
>  	TYPE_TWO_POINT_TRIMMING,
>  	TYPE_NONE,
>  };
> @@ -90,6 +92,10 @@ enum soc_type {
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
> @@ -151,6 +157,8 @@ struct exynos_tmu_registers {
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
> index 5952915..9002499 100644
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


------enig2OXKPOXKSWQMFLFMIBEJK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHJnWUACgkQCXcVR3XQvP2eEwEAuqpvkYC6fKXgHCtMuPhCNyeG
7cNPfN+YGh66sXVCtZgBAOz3hTmbBxCdsWhj8y4EicDjiXXo36+zwYZJ5/wxD9w5
=z8SL
-----END PGP SIGNATURE-----

------enig2OXKPOXKSWQMFLFMIBEJK--
