Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935325Ab3FSXgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 19:36:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34053 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934170Ab3FSXgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 19:36:04 -0400
Message-ID: <51C24058.6040401@ti.com>
Date: Wed, 19 Jun 2013 19:35:52 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 19/30] thermal: exynos: Add TMU features to check instead
 of using SOC type
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-20-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-20-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2XOOAGWXWOBKHMNLBRTMB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2XOOAGWXWOBKHMNLBRTMB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> This patch adds several features supported by TMU as bitfields.
> This features varies across different SOC type and comparing
> the features present in the TMU is more logical than comparing
> the soc itself.
>=20
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

> ---
>  drivers/thermal/samsung/exynos_tmu.c      |   26 +++++++++++++++------=
---
>  drivers/thermal/samsung/exynos_tmu.h      |   31 +++++++++++++++++++++=
++++++++
>  drivers/thermal/samsung/exynos_tmu_data.c |    6 ++++-
>  3 files changed, 52 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index 1880c4e..877dab8 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -142,13 +142,15 @@ static int exynos_tmu_initialize(struct platform_=
device *pdev)
>  	mutex_lock(&data->lock);
>  	clk_enable(data->clk);
> =20
> -	status =3D readb(data->base + reg->tmu_status);
> -	if (!status) {
> -		ret =3D -EBUSY;
> -		goto out;
> +	if (TMU_SUPPORTS(pdata, READY_STATUS)) {
> +		status =3D readb(data->base + reg->tmu_status);
> +		if (!status) {
> +			ret =3D -EBUSY;
> +			goto out;
> +		}
>  	}
> =20
> -	if (data->soc =3D=3D SOC_ARCH_EXYNOS)
> +	if (TMU_SUPPORTS(pdata, TRIM_RELOAD))
>  		__raw_writel(1, data->base + reg->triminfo_ctrl);
> =20
>  	/* Save trimming info in order to perform calibration */
> @@ -287,7 +289,7 @@ static void exynos_tmu_control(struct platform_devi=
ce *pdev, bool on)
>  			pdata->trigger_enable[2] << reg->inten_rise2_shift |
>  			pdata->trigger_enable[1] << reg->inten_rise1_shift |
>  			pdata->trigger_enable[0] << reg->inten_rise0_shift;
> -		if (pdata->threshold_falling)
> +		if (TMU_SUPPORTS(pdata, FALLING_TRIP))
>  			interrupt_en |=3D
>  				interrupt_en << reg->inten_fall0_shift;
>  	} else {
> @@ -329,7 +331,7 @@ static int exynos_tmu_set_emulation(void *drv_data,=
 unsigned long temp)
>  	unsigned int val;
>  	int ret =3D -EINVAL;
> =20
> -	if (data->soc =3D=3D SOC_ARCH_EXYNOS4210)
> +	if (!TMU_SUPPORTS(pdata, EMULATION))
>  		goto out;
> =20
>  	if (temp && temp < MCELSIUS)
> @@ -343,9 +345,13 @@ static int exynos_tmu_set_emulation(void *drv_data=
, unsigned long temp)
>  	if (temp) {
>  		temp /=3D MCELSIUS;
> =20
> -		val =3D (EXYNOS_EMUL_TIME << reg->emul_time_shift) |
> -			(temp_to_code(data, temp)
> -			 << reg->emul_temp_shift) | EXYNOS_EMUL_ENABLE;
> +		if (TMU_SUPPORTS(pdata, EMUL_TIME)) {
> +			val &=3D ~(EXYNOS_EMUL_TIME_MASK << reg->emul_time_shift);
> +			val |=3D (EXYNOS_EMUL_TIME << reg->emul_time_shift);
> +		}
> +		val &=3D ~(EXYNOS_EMUL_DATA_MASK << reg->emul_temp_shift);
> +		val |=3D (temp_to_code(data, temp) << reg->emul_temp_shift) |
> +			EXYNOS_EMUL_ENABLE;
>  	} else {
>  		val &=3D ~EXYNOS_EMUL_ENABLE;
>  	}
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/sam=
sung/exynos_tmu.h
> index b614407..6f55673 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -41,6 +41,34 @@ enum soc_type {
>  };
> =20
>  /**
> + * EXYNOS TMU supported features.
> + * TMU_SUPPORT_EMULATION - This features is used to set user defined
> + *			temperature to the TMU controller.
> + * TMU_SUPPORT_MULTI_INST - This features denotes that the soc
> + *			has many instances of TMU.
> + * TMU_SUPPORT_TRIM_RELOAD - This features shows that trimming can
> + *			be reloaded.
> + * TMU_SUPPORT_FALLING_TRIP - This features shows that interrupt can
> + *			be registered for falling trips also.
> + * TMU_SUPPORT_READY_STATUS - This feature tells that the TMU current
> + *			state(active/idle) can be checked.
> + * TMU_SUPPORT_EMUL_TIME - This features allows to set next temp emula=
tion
> + *			sample time.
> + * TMU_SUPPORT_SHARED_MEMORY - This feature tells that the different T=
MU
> + *			sensors shares some common registers.
> + * TMU_SUPPORT - macro to compare the above features with the supplied=
=2E
> + */
> +#define TMU_SUPPORT_EMULATION			BIT(0)
> +#define TMU_SUPPORT_MULTI_INST			BIT(1)
> +#define TMU_SUPPORT_TRIM_RELOAD			BIT(2)
> +#define TMU_SUPPORT_FALLING_TRIP		BIT(3)
> +#define TMU_SUPPORT_READY_STATUS		BIT(4)
> +#define TMU_SUPPORT_EMUL_TIME			BIT(5)
> +#define TMU_SUPPORT_SHARED_MEMORY		BIT(6)
> +
> +#define TMU_SUPPORTS(a, b)	(a->features & TMU_SUPPORT_ ## b)
> +
> +/**
>   * struct exynos_tmu_register - register descriptors to access registe=
rs and
>   * bitfields. The register validity, offsets and bitfield values may v=
ary
>   * slightly across different exynos SOC's.
> @@ -220,6 +248,8 @@ struct exynos_tmu_registers {
>   *	applicable to only some of the trigger levels.
>   * @registers: Pointer to structure containing all the TMU controller =
registers
>   *	and bitfields shifts and masks.
> + * @features: a bitfield value indicating the features supported in SO=
C like
> + *	emulation, multi instance etc
>   *
>   * This structure is required for configuration of exynos_tmu driver.
>   */
> @@ -247,6 +277,7 @@ struct exynos_tmu_platform_data {
>  	struct freq_clip_table freq_tab[4];
>  	unsigned int freq_tab_count;
>  	const struct exynos_tmu_registers *registers;
> +	unsigned int features;
>  };
> =20
>  /**
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/therma=
l/samsung/exynos_tmu_data.c
> index 06ecfb0..694557e 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -83,6 +83,7 @@ struct exynos_tmu_init_data const exynos4210_default_=
tmu_data =3D {
>  		.freq_tab_count =3D 2,
>  		.type =3D SOC_ARCH_EXYNOS4210,
>  		.registers =3D &exynos4210_tmu_registers,
> +		.features =3D TMU_SUPPORT_READY_STATUS,
>  		},
>  	},
>  	.tmu_count =3D 1,
> @@ -162,7 +163,10 @@ static const struct exynos_tmu_registers exynos525=
0_tmu_registers =3D {
>  	}, \
>  	.freq_tab_count =3D 2, \
>  	.type =3D SOC_ARCH_EXYNOS, \
> -	.registers =3D &exynos5250_tmu_registers,
> +	.registers =3D &exynos5250_tmu_registers, \
> +	.features =3D (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
> +			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
> +			TMU_SUPPORT_EMUL_TIME)
> =20
>  struct exynos_tmu_init_data const exynos5250_default_tmu_data =3D {
>  	.tmu_data =3D {
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2XOOAGWXWOBKHMNLBRTMB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCQFgACgkQCXcVR3XQvP1ejAD8DTmov1cxDvNAgq+k9gH21YBt
vFNS49woU8zvETeUKIkA/0B7DyCMfpCPhkWqYjetVmSd0GTBbw61UDnKLkcryK17
=5aHH
-----END PGP SIGNATURE-----

------enig2XOOAGWXWOBKHMNLBRTMB--
