Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935182Ab3FSTf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:35:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41668 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934566Ab3FSTf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:35:56 -0400
Message-ID: <51C20810.5070601@ti.com>
Date: Wed, 19 Jun 2013 15:35:44 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 07/30] thermal: exynos: Bifurcate exynos tmu driver
 and configuration data
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-8-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-8-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2VXSIUFLODXIEMFDQUDBT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2VXSIUFLODXIEMFDQUDBT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Rui,

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> This code splits the exynos tmu driver code into SOC specific data part=
s.
> This will simplify adding new SOC specific data to the same TMU control=
ler.
>=20
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

This patch looks good to me, you may want to add my:

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

> ---
>  drivers/thermal/samsung/Kconfig           |    3 +-
>  drivers/thermal/samsung/Makefile          |    1 +
>  drivers/thermal/samsung/exynos_tmu.c      |   67 ++-------------------=
----
>  drivers/thermal/samsung/exynos_tmu_data.c |   78 +++++++++++++++++++++=
++++++++
>  drivers/thermal/samsung/exynos_tmu_data.h |   40 +++++++++++++++
>  5 files changed, 125 insertions(+), 64 deletions(-)
>  create mode 100644 drivers/thermal/samsung/exynos_tmu_data.c
>  create mode 100644 drivers/thermal/samsung/exynos_tmu_data.h
>=20
> diff --git a/drivers/thermal/samsung/Kconfig b/drivers/thermal/samsung/=
Kconfig
> index f8100b1..b653f15 100644
> --- a/drivers/thermal/samsung/Kconfig
> +++ b/drivers/thermal/samsung/Kconfig
> @@ -5,7 +5,8 @@ config EXYNOS_THERMAL
>  	  If you say yes here you get support for the TMU (Thermal Management=

>  	  Unit) driver for SAMSUNG EXYNOS series of soc. This driver initiali=
ses
>  	  the TMU, reports temperature and handles cooling action if defined.=

> -	  This driver uses the exynos core thermal API's.
> +	  This driver uses the exynos core thermal API's and TMU configuratio=
n
> +	  data from the supported soc's.
> =20
>  config EXYNOS_THERMAL_CORE
>  	bool "Core thermal framework support for EXYNOS SOC's"
> diff --git a/drivers/thermal/samsung/Makefile b/drivers/thermal/samsung=
/Makefile
> index 22528d6..c09d830 100644
> --- a/drivers/thermal/samsung/Makefile
> +++ b/drivers/thermal/samsung/Makefile
> @@ -3,4 +3,5 @@
>  #
>  obj-$(CONFIG_EXYNOS_THERMAL)			+=3D exynos_thermal.o
>  exynos_thermal-y				:=3D exynos_tmu.o
> +exynos_thermal-y				+=3D exynos_tmu_data.o
>  exynos_thermal-$(CONFIG_EXYNOS_THERMAL_CORE)	+=3D exynos_thermal_commo=
n.o
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index 6aa2fd2..5df04a1 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -30,6 +30,7 @@
> =20
>  #include "exynos_thermal_common.h"
>  #include "exynos_tmu.h"
> +#include "exynos_tmu_data.h"
> =20
>  /* Exynos generic registers */
>  #define EXYNOS_TMU_REG_TRIMINFO		0x0
> @@ -381,66 +382,6 @@ static struct thermal_sensor_conf exynos_sensor_co=
nf =3D {
>  	.write_emul_temp	=3D exynos_tmu_set_emulation,
>  };
> =20
> -#if defined(CONFIG_CPU_EXYNOS4210)
> -static struct exynos_tmu_platform_data const exynos4210_default_tmu_da=
ta =3D {
> -	.threshold =3D 80,
> -	.trigger_levels[0] =3D 5,
> -	.trigger_levels[1] =3D 20,
> -	.trigger_levels[2] =3D 30,
> -	.trigger_level0_en =3D 1,
> -	.trigger_level1_en =3D 1,
> -	.trigger_level2_en =3D 1,
> -	.trigger_level3_en =3D 0,
> -	.gain =3D 15,
> -	.reference_voltage =3D 7,
> -	.cal_type =3D TYPE_ONE_POINT_TRIMMING,
> -	.freq_tab[0] =3D {
> -		.freq_clip_max =3D 800 * 1000,
> -		.temp_level =3D 85,
> -	},
> -	.freq_tab[1] =3D {
> -		.freq_clip_max =3D 200 * 1000,
> -		.temp_level =3D 100,
> -	},
> -	.freq_tab_count =3D 2,
> -	.type =3D SOC_ARCH_EXYNOS4210,
> -};
> -#define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
> -#else
> -#define EXYNOS4210_TMU_DRV_DATA (NULL)
> -#endif
> -
> -#if defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4412)
> -static struct exynos_tmu_platform_data const exynos_default_tmu_data =3D=
 {
> -	.threshold_falling =3D 10,
> -	.trigger_levels[0] =3D 85,
> -	.trigger_levels[1] =3D 103,
> -	.trigger_levels[2] =3D 110,
> -	.trigger_level0_en =3D 1,
> -	.trigger_level1_en =3D 1,
> -	.trigger_level2_en =3D 1,
> -	.trigger_level3_en =3D 0,
> -	.gain =3D 8,
> -	.reference_voltage =3D 16,
> -	.noise_cancel_mode =3D 4,
> -	.cal_type =3D TYPE_ONE_POINT_TRIMMING,
> -	.efuse_value =3D 55,
> -	.freq_tab[0] =3D {
> -		.freq_clip_max =3D 800 * 1000,
> -		.temp_level =3D 85,
> -	},
> -	.freq_tab[1] =3D {
> -		.freq_clip_max =3D 200 * 1000,
> -		.temp_level =3D 103,
> -	},
> -	.freq_tab_count =3D 2,
> -	.type =3D SOC_ARCH_EXYNOS,
> -};
> -#define EXYNOS_TMU_DRV_DATA (&exynos_default_tmu_data)
> -#else
> -#define EXYNOS_TMU_DRV_DATA (NULL)
> -#endif
> -
>  #ifdef CONFIG_OF
>  static const struct of_device_id exynos_tmu_match[] =3D {
>  	{
> @@ -449,11 +390,11 @@ static const struct of_device_id exynos_tmu_match=
[] =3D {
>  	},
>  	{
>  		.compatible =3D "samsung,exynos4412-tmu",
> -		.data =3D (void *)EXYNOS_TMU_DRV_DATA,
> +		.data =3D (void *)EXYNOS5250_TMU_DRV_DATA,
>  	},
>  	{
>  		.compatible =3D "samsung,exynos5250-tmu",
> -		.data =3D (void *)EXYNOS_TMU_DRV_DATA,
> +		.data =3D (void *)EXYNOS5250_TMU_DRV_DATA,
>  	},
>  	{},
>  };
> @@ -467,7 +408,7 @@ static struct platform_device_id exynos_tmu_driver_=
ids[] =3D {
>  	},
>  	{
>  		.name		=3D "exynos5250-tmu",
> -		.driver_data    =3D (kernel_ulong_t)EXYNOS_TMU_DRV_DATA,
> +		.driver_data    =3D (kernel_ulong_t)EXYNOS5250_TMU_DRV_DATA,
>  	},
>  	{ },
>  };
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/therma=
l/samsung/exynos_tmu_data.c
> new file mode 100644
> index 0000000..13a60ca
> --- /dev/null
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -0,0 +1,78 @@
> +/*
> + * exynos_tmu_data.c - Samsung EXYNOS tmu data file
> + *
> + *  Copyright (C) 2013 Samsung Electronics
> + *  Amit Daniel Kachhap <amit.daniel@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modif=
y
> + * it under the terms of the GNU General Public License as published b=
y
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7  USA
> + *
> + */
> +
> +#include "exynos_thermal_common.h"
> +#include "exynos_tmu.h"
> +
> +#if defined(CONFIG_CPU_EXYNOS4210)
> +struct exynos_tmu_platform_data const exynos4210_default_tmu_data =3D =
{
> +	.threshold =3D 80,
> +	.trigger_levels[0] =3D 5,
> +	.trigger_levels[1] =3D 20,
> +	.trigger_levels[2] =3D 30,
> +	.trigger_level0_en =3D 1,
> +	.trigger_level1_en =3D 1,
> +	.trigger_level2_en =3D 1,
> +	.trigger_level3_en =3D 0,
> +	.gain =3D 15,
> +	.reference_voltage =3D 7,
> +	.cal_type =3D TYPE_ONE_POINT_TRIMMING,
> +	.freq_tab[0] =3D {
> +		.freq_clip_max =3D 800 * 1000,
> +		.temp_level =3D 85,
> +	},
> +	.freq_tab[1] =3D {
> +		.freq_clip_max =3D 200 * 1000,
> +		.temp_level =3D 100,
> +	},
> +	.freq_tab_count =3D 2,
> +	.type =3D SOC_ARCH_EXYNOS4210,
> +};
> +#endif
> +
> +#if defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4412)
> +struct exynos_tmu_platform_data const exynos5250_default_tmu_data =3D =
{
> +	.threshold_falling =3D 10,
> +	.trigger_levels[0] =3D 85,
> +	.trigger_levels[1] =3D 103,
> +	.trigger_levels[2] =3D 110,
> +	.trigger_level0_en =3D 1,
> +	.trigger_level1_en =3D 1,
> +	.trigger_level2_en =3D 1,
> +	.trigger_level3_en =3D 0,
> +	.gain =3D 8,
> +	.reference_voltage =3D 16,
> +	.noise_cancel_mode =3D 4,
> +	.cal_type =3D TYPE_ONE_POINT_TRIMMING,
> +	.efuse_value =3D 55,
> +	.freq_tab[0] =3D {
> +		.freq_clip_max =3D 800 * 1000,
> +		.temp_level =3D 85,
> +	},
> +	.freq_tab[1] =3D {
> +		.freq_clip_max =3D 200 * 1000,
> +		.temp_level =3D 103,
> +	},
> +	.freq_tab_count =3D 2,
> +	.type =3D SOC_ARCH_EXYNOS,
> +};
> +#endif
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/therma=
l/samsung/exynos_tmu_data.h
> new file mode 100644
> index 0000000..b7835fe
> --- /dev/null
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -0,0 +1,40 @@
> +/*
> + * exynos_tmu_data.h - Samsung EXYNOS tmu data header file
> + *
> + *  Copyright (C) 2013 Samsung Electronics
> + *  Amit Daniel Kachhap <amit.daniel@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modif=
y
> + * it under the terms of the GNU General Public License as published b=
y
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7  USA
> + *
> + */
> +
> +#ifndef _EXYNOS_TMU_DATA_H
> +#define _EXYNOS_TMU_DATA_H
> +
> +#if defined(CONFIG_CPU_EXYNOS4210)
> +extern struct exynos_tmu_platform_data const exynos4210_default_tmu_da=
ta;
> +#define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
> +#else
> +#define EXYNOS4210_TMU_DRV_DATA (NULL)
> +#endif
> +
> +#if (defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4412))=

> +extern struct exynos_tmu_platform_data const exynos5250_default_tmu_da=
ta;
> +#define EXYNOS5250_TMU_DRV_DATA (&exynos5250_default_tmu_data)
> +#else
> +#define EXYNOS5250_TMU_DRV_DATA (NULL)
> +#endif
> +
> +#endif /*_EXYNOS_TMU_DATA_H*/
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2VXSIUFLODXIEMFDQUDBT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCCBAACgkQCXcVR3XQvP1z/gEA1LqwLhSeVI4yhsNjG6aM/tL+
uLDOb4s2nU5/+xCUhikA/29Pmh9nLJ4uPC54S/25o08Nln1YQfoCYK5XAy3jpw9b
=ljiX
-----END PGP SIGNATURE-----

------enig2VXSIUFLODXIEMFDQUDBT--
