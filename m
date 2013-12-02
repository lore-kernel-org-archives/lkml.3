Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab3LBOx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:53:29 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49023 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab3LBOxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:53:25 -0500
Message-ID: <529C9ED2.2060106@ti.com>
Date: Mon, 2 Dec 2013 10:53:06 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lukasz Majewski <l.majewski@samsung.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, <durgadoss.r@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH v10 7/7] thermal:exynos:boost: Automatic enable/disable
 of BOOST feature (at Exynos4412)
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com> <1383672411-26324-1-git-send-email-l.majewski@samsung.com> <1383672411-26324-8-git-send-email-l.majewski@samsung.com>
In-Reply-To: <1383672411-26324-8-git-send-email-l.majewski@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="Kh5LiP33daJRIV2bov45pGrinPmqUkKBC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Kh5LiP33daJRIV2bov45pGrinPmqUkKBC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05-11-2013 13:26, Lukasz Majewski wrote:
> This patch provides auto disable/enable operation for boost. It uses al=
ready
> present thermal infrastructure to provide boost hysteresis.
> A special set of TMU data has been defined for Exynos4412, which is onl=
y
> considered when BOOST is enabled.

Can you please add more description why you need a different set of
thermal data when boost is enabled? This is also important in case you
(Exynos thermal folks) would like to migrate this driver to have thermal
data support in DT.


>=20
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>=20
> ---
> Changes for v10:
>     - Remove boost related code from thermal_core.c
>     - Use already present thermal infrastructure to provide thermal hys=
teresis
>     - Introduce special set of TMU data for BOOST
>=20
> Changes for v9:
>     - None
>=20
> Changes for v8:
>     - Move cpufreq_boost_* stub functions definition (needed when cpufr=
eq
>       is not compiled in) to cpufreq.h at cpufreq core support commit
>=20
> Changes for v7:
>     - None
>=20
> Changes for v6:
>     - Disable boost only when supported and enabled
>     - Protect boost related thermal_zone_device struct fields with mute=
x
>     - Evaluate temperature trend during boost enable decision
>     - Create separate methods to handle boost enable/disable
>       (thermal_boost_{enable|disable}) operations
>     - Boost is disabled at any trip point passage (not only the non cri=
tical one)
>     - Add stub definitions for cpufreq boost functions used when
>       CONFIG_CPU_FREQ is NOT defined.
>=20
> Changes for v5:
>     - Move boost disable code from cpu_cooling.c to thermal_core.c
>       (to handle_non_critical_trips)
>     - Extent struct thermal_zone_device by adding overheated bool flag
>     - Implement auto enable of boost after device cools down
>     - Introduce boost_polling flag, which indicates if thermal uses it'=
s predefined
>       pool delay or has woken up thermal workqueue only to wait until d=
evice
>       cools down.
>=20
> Changes for v4:
>     - New patch


Might be interesting to see the changelog for this patch only.

>=20
>  drivers/thermal/samsung/exynos_tmu_data.c |   47 +++++++++++++++++++++=
++++++++
>  1 file changed, 47 insertions(+)
>=20
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/therma=
l/samsung/exynos_tmu_data.c
> index 073c292..9346926 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -167,13 +167,60 @@ static const struct exynos_tmu_registers exynos44=
12_tmu_registers =3D {
>  	.features =3D (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
>  			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
>  			TMU_SUPPORT_EMUL_TIME)
> +
> +#define EXYNOS4412_TMU_DATA_BOOST \
> +	.threshold_falling =3D 10, \
> +	.trigger_levels[0] =3D 70, \
> +	.trigger_levels[1] =3D 85, \
> +	.trigger_levels[2] =3D 103, \
> +	.trigger_levels[3] =3D 110, \
> +	.trigger_enable[0] =3D true, \
> +	.trigger_enable[1] =3D true, \
> +	.trigger_enable[2] =3D true, \
> +	.trigger_enable[3] =3D true, \
> +	.trigger_type[0] =3D THROTTLE_ACTIVE, \
> +	.trigger_type[1] =3D THROTTLE_ACTIVE, \
> +	.trigger_type[2] =3D THROTTLE_ACTIVE, \
> +	.trigger_type[3] =3D SW_TRIP, \
> +	.max_trigger_level =3D 4, \
> +	.gain =3D 8, \
> +	.reference_voltage =3D 16, \
> +	.noise_cancel_mode =3D 4, \
> +	.cal_type =3D TYPE_ONE_POINT_TRIMMING, \
> +	.efuse_value =3D 55, \
> +	.min_efuse_value =3D 40, \
> +	.max_efuse_value =3D 100, \
> +	.first_point_trim =3D 25, \
> +	.second_point_trim =3D 85, \
> +	.default_temp_offset =3D 50, \
> +	.freq_tab[0] =3D { \
> +		.freq_clip_max =3D 1400 * 1000, \
> +		.temp_level =3D 70, \
> +	}, \
> +	.freq_tab[1] =3D { \
> +		.freq_clip_max =3D 800 * 1000, \
> +		.temp_level =3D 85, \
> +	}, \
> +	.freq_tab[2] =3D { \
> +		.freq_clip_max =3D 200 * 1000, \
> +		.temp_level =3D 103, \
> +	}, \
> +	.freq_tab_count =3D 3, \
> +	.registers =3D &exynos4412_tmu_registers, \
> +	.features =3D (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
> +			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
> +			TMU_SUPPORT_EMUL_TIME)
>  #endif
> =20
>  #if defined(CONFIG_SOC_EXYNOS4412)
>  struct exynos_tmu_init_data const exynos4412_default_tmu_data =3D {
>  	.tmu_data =3D {
>  		{
> +#ifdef CONFIG_CPU_FREQ_BOOST_SW
> +			EXYNOS4412_TMU_DATA_BOOST,
> +#else
>  			EXYNOS4412_TMU_DATA,
> +#endif
>  			.type =3D SOC_ARCH_EXYNOS4412,
>  			.test_mux =3D EXYNOS4412_MUX_ADDR_VALUE,
>  		},
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--Kh5LiP33daJRIV2bov45pGrinPmqUkKBC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKcntUACgkQCXcVR3XQvP1pnwEA7u+J4Yhhud74uSTMdinJ7Hqv
fcy6XiqJMCXUCQ/nltoBAMDsV/mrwGFWzXHkBb8mxs4xzNtYaTDEllkhN7WLhXXt
=4vOk
-----END PGP SIGNATURE-----

--Kh5LiP33daJRIV2bov45pGrinPmqUkKBC--
