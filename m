Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbbACMek (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 07:34:40 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49351 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbbACMeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 07:34:37 -0500
Date: Sat, 3 Jan 2015 08:34:30 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: rui.zhang@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com
Subject: Re: [PATCH] thermal: add omap3 support
Message-ID: <20150103123426.GA26069@developer>
References: <20150103111146.GB7065@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20150103111146.GB7065@amd>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Pavel,

Thanks for sending your code.

On Sat, Jan 03, 2015 at 12:11:46PM +0100, Pavel Machek wrote:
> Add support for omap3430 sensor. Tested on Nokia N900.

To my understanding, and as already mentioned by Nishanth Menon
(currently TIer), TI has intentionally avoided adding this support.

There is a hardware accuracy limitation in this sensor, and therefore it
is not advisable to use it, specially in Dynamic Thermal Management,
such as the thermal framework.=20
>=20
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>=20
> diff --git a/drivers/thermal/ti-soc-thermal/Kconfig b/drivers/thermal/ti-=
soc-thermal/Kconfig
> index bd4c7be..a49495f 100644
> --- a/drivers/thermal/ti-soc-thermal/Kconfig
> +++ b/drivers/thermal/ti-soc-thermal/Kconfig
> @@ -21,6 +21,15 @@ config TI_THERMAL
>  	  This includes trip points definitions, extrapolation rules and
>  	  CPU cooling device bindings.
> =20
> +config OMAP3_THERMAL
> +	bool "Texas Instruments OMAP3 thermal support"
> +	depends on TI_SOC_THERMAL
> +	depends on ARCH_OMAP3
> +	help
> +	  If you say yes here you get thermal support for the Texas Instruments
> +	  OMAP3 SoC family. The current chip supported are:
> +	   - OMAP3430

But if you insist :-), I believe the user deserves at least a fair
message saying this is on his / her own risk.

> +
>  config OMAP4_THERMAL
>  	bool "Texas Instruments OMAP4 thermal support"
>  	depends on TI_SOC_THERMAL
> diff --git a/drivers/thermal/ti-soc-thermal/Makefile b/drivers/thermal/ti=
-soc-thermal/Makefile
> index 1226b24..2b5b220 100644
> --- a/drivers/thermal/ti-soc-thermal/Makefile
> +++ b/drivers/thermal/ti-soc-thermal/Makefile
> @@ -2,5 +2,6 @@ obj-$(CONFIG_TI_SOC_THERMAL)		+=3D ti-soc-thermal.o
>  ti-soc-thermal-y			:=3D ti-bandgap.o
>  ti-soc-thermal-$(CONFIG_TI_THERMAL)	+=3D ti-thermal-common.o
>  ti-soc-thermal-$(CONFIG_DRA752_THERMAL)	+=3D dra752-thermal-data.o
> +ti-soc-thermal-$(CONFIG_OMAP3_THERMAL)	+=3D omap3-thermal-data.o
>  ti-soc-thermal-$(CONFIG_OMAP4_THERMAL)	+=3D omap4-thermal-data.o
>  ti-soc-thermal-$(CONFIG_OMAP5_THERMAL)	+=3D omap5-thermal-data.o
> diff --git a/drivers/thermal/ti-soc-thermal/omap3-thermal-data.c b/driver=
s/thermal/ti-soc-thermal/omap3-thermal-data.c
> new file mode 100644
> index 0000000..7c18766
> --- /dev/null
> +++ b/drivers/thermal/ti-soc-thermal/omap3-thermal-data.c
> @@ -0,0 +1,95 @@
> +/*
> + * OMAP3 thermal driver.
> + *
> + * Copyright (C) 2011-2012 Texas Instruments Inc.
> + * Copyright (C) 2014 Pavel Machek <pavel@ucw.cz>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include "ti-thermal.h"
> +#include "ti-bandgap.h"
> +
> +/*
> + * OMAP34XX has one instance of thermal sensor for MPU
> + * need to describe the individual bit fields
> + */
> +static struct temp_sensor_registers
> +omap34xx_mpu_temp_sensor_registers =3D {
> +	.temp_sensor_ctrl =3D 0,
> +	.bgap_tempsoff_mask =3D 0, /* Unused, we don't have POWER_SWITCH */
> +	.bgap_soc_mask =3D BIT(8),
> +	.bgap_eocz_mask =3D BIT(7),
> +	.bgap_dtemp_mask =3D 0x7f,
> +
> +	.bgap_mode_ctrl =3D 0,
> +	.mode_ctrl_mask =3D BIT(9),
> +
> +	.bgap_efuse =3D 0,

The 0'ed filed may be removed here.

> +};
> +
> +/* Thresholds and limits for OMAP34XX MPU temperature sensor */
> +static struct temp_sensor_data omap34xx_mpu_temp_sensor_data =3D {
> +	.min_freq =3D 32768,
> +	.max_freq =3D 32768,
> +	.max_temp =3D -99000,
> +	.min_temp =3D 99000,
> +	.hyst_val =3D 5000,
> +};
> +
> +/*
> + * Temperature values in milli degree celsius
> + */
> +static const int
> +omap34xx_adc_to_temp[128] =3D {
> +	-40000, -40000, -40000, -40000, -40000, -39000, -38000, -36000,
> +	-34000, -32000, -31000,	-29000, -28000, -26000, -25000, -24000,
> +	-22000, -21000, -19000, -18000, -17000, -15000,	-14000, -12000,
> +	-11000, -9000, -8000, -7000, -5000, -4000, -2000, -1000, 0000,
> +	1000, 3000, 4000, 5000, 7000, 8000, 10000, 11000, 13000, 14000,
> +	15000, 17000, 18000, 20000, 21000, 22000, 24000, 25000, 27000,
> +	28000, 30000, 31000, 32000, 34000, 35000, 37000, 38000, 39000,
> +	41000, 42000, 44000, 45000, 47000, 48000, 49000, 51000, 52000,
> +	53000, 55000, 56000, 58000, 59000, 60000, 62000, 63000, 65000,
> +	66000, 67000, 69000, 70000, 72000, 73000, 74000, 76000, 77000,
> +	79000, 80000, 81000, 83000, 84000, 85000, 87000, 88000, 89000,
> +	91000, 92000, 94000, 95000, 96000, 98000, 99000, 100000,
> +	102000, 103000, 105000, 106000, 107000, 109000, 110000, 111000,
> +	113000, 114000, 116000, 117000, 118000, 120000, 121000, 122000,
> +	124000, 124000, 125000, 125000, 125000, 125000,	125000
> +};
> +
> +/* OMAP34XX data */
> +const struct ti_bandgap_data omap34xx_data =3D {
> +	.features =3D TI_BANDGAP_FEATURE_CLK_CTRL /* | TI_BANDGAP_FEATURE_MODE_=
CONFIG */,
> +	.fclock_name =3D "ts_fck",
> +	.div_ck_name =3D "ts_fck",
> +	.conv_table =3D omap34xx_adc_to_temp,
> +	.adc_start_val =3D 0,
> +	.adc_end_val =3D 127,
> +	.expose_sensor =3D ti_thermal_expose_sensor,
> +	.remove_sensor =3D ti_thermal_remove_sensor,
> +
> +	.sensors =3D {
> +		{
> +		.registers =3D &omap34xx_mpu_temp_sensor_registers,
> +		.ts_data =3D &omap34xx_mpu_temp_sensor_data,
> +		.domain =3D "cpu",
> +		.slope =3D 0,
> +		.constant =3D 20000,
> +		.slope_pcb =3D 0,
> +		.constant_pcb =3D 20000,
> +		.register_cooling =3D NULL,
> +		.unregister_cooling =3D NULL,
> +		},
> +	},
> +	.sensor_count =3D 1,
> +};
> diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/therma=
l/ti-soc-thermal/ti-bandgap.c
> index 634b6ce..3b4e72f 100644
> --- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> +++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> @@ -1509,6 +1531,12 @@ static SIMPLE_DEV_PM_OPS(ti_bandgap_dev_pm_ops, ti=
_bandgap_suspend,
>  #endif
> =20
>  static const struct of_device_id of_ti_bandgap_match[] =3D {
> +#ifdef CONFIG_OMAP3_THERMAL
> +	{
> +		.compatible =3D "ti,omap34xx-bandgap",

This needs to be updated in the binding documentation.
Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt


> +		.data =3D (void *)&omap34xx_data,


Having a run time message intentionally advising users of the risk of
using this sensor is also required.




> +	},
> +#endif
>  #ifdef CONFIG_OMAP4_THERMAL
>  	{
>  		.compatible =3D "ti,omap4430-bandgap",
> diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.h b/drivers/therma=
l/ti-soc-thermal/ti-bandgap.h
> index b3adf72..3f05386 100644
> --- a/drivers/thermal/ti-soc-thermal/ti-bandgap.h
> +++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.h
> @@ -384,6 +384,8 @@ int ti_bandgap_set_sensor_data(struct ti_bandgap *bgp=
, int id, void *data);
>  void *ti_bandgap_get_sensor_data(struct ti_bandgap *bgp, int id);
>  int ti_bandgap_get_trend(struct ti_bandgap *bgp, int id, int *trend);
> =20
> +extern const struct ti_bandgap_data omap34xx_data;
> +
>  #ifdef CONFIG_OMAP4_THERMAL
>  extern const struct ti_bandgap_data omap4430_data;
>  extern const struct ti_bandgap_data omap4460_data;
>=20
> --=20
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/b=
log.html

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUp+HJAAoJEMLUO4d9pOJW3d0H/3pYaAnANMU9bxENr3yLIjFA
qcbzFXI+zZh4IHWxh3NflaLTe1HT+Q/WbPbZsOe7PgnLIxVD+O0yzMeULxzX4Kic
7fG+xhruqTXgu1AX8efLw7hjYa+NlVyRgKCGFClNoaoyZ4rMyImxMifGDvB1EmVE
lrOD/kJX20tBQTLANMcJZ6gGCBUOmeN1/eLfbGD55hGKSwX8wboLO6kkYinDNLcX
uQS5W1v2vA8tMNSl/8V/aeB4DAcConr3lXWh0J0Y729ySs3vA/BYohTIeq4Eym+/
4GUy0A9keEp7ZzRlZHSKbQMt+61EtCTakoQ1+8URX0sbF/FOhHFgCjRRCnU5QHY=
=zTlM
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
