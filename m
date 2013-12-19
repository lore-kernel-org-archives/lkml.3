Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab3LSOvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:51:14 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49463 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab3LSOvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:51:11 -0500
Message-ID: <52B307CC.2020704@ti.com>
Date: Thu, 19 Dec 2013 10:50:52 -0400
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
        <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v11 7/7] thermal:exynos:boost: Automatic enable/disable
 of BOOST feature (at Exynos4412)
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com> <1386952717-30947-1-git-send-email-l.majewski@samsung.com> <1386952717-30947-8-git-send-email-l.majewski@samsung.com>
In-Reply-To: <1386952717-30947-8-git-send-email-l.majewski@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="OuK5HSlsKdmIsMRgfIpauCespVANEeE4a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OuK5HSlsKdmIsMRgfIpauCespVANEeE4a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 13-12-2013 12:38, Lukasz Majewski wrote:
> This patch provides auto disable/enable operation for boost. It uses al=
ready
> present thermal infrastructure to provide boost hysteresis.
> The TMU data has been modified to work properly with or without boost.
>=20
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

Looks better to me now. You might consider refactoring this driver to be
frequency independent, if possible. But that is a different subject
other than this patch.

>=20
> ---
> Changes for v11:
>     - Use only one thermal data set
>     - Adjust Exynos4412 thermal data to work with or without BOOST
>=20
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
>=20
>  drivers/thermal/samsung/exynos_tmu_data.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/therma=
l/samsung/exynos_tmu_data.c
> index 073c292..476b768 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -131,8 +131,8 @@ static const struct exynos_tmu_registers exynos4412=
_tmu_registers =3D {
> =20
>  #define EXYNOS4412_TMU_DATA \
>  	.threshold_falling =3D 10, \
> -	.trigger_levels[0] =3D 85, \
> -	.trigger_levels[1] =3D 103, \
> +	.trigger_levels[0] =3D 70, \
> +	.trigger_levels[1] =3D 95, \
>  	.trigger_levels[2] =3D 110, \
>  	.trigger_levels[3] =3D 120, \
>  	.trigger_enable[0] =3D true, \
> @@ -155,12 +155,12 @@ static const struct exynos_tmu_registers exynos44=
12_tmu_registers =3D {
>  	.second_point_trim =3D 85, \
>  	.default_temp_offset =3D 50, \
>  	.freq_tab[0] =3D { \
> -		.freq_clip_max =3D 800 * 1000, \
> -		.temp_level =3D 85, \
> +		.freq_clip_max =3D 1400 * 1000, \
> +		.temp_level =3D 70, \
>  	}, \
>  	.freq_tab[1] =3D { \
> -		.freq_clip_max =3D 200 * 1000, \
> -		.temp_level =3D 103, \
> +		.freq_clip_max =3D 400 * 1000, \
> +		.temp_level =3D 95, \
>  	}, \
>  	.freq_tab_count =3D 2, \
>  	.registers =3D &exynos4412_tmu_registers, \
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--OuK5HSlsKdmIsMRgfIpauCespVANEeE4a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKzB88ACgkQCXcVR3XQvP1MKQD/XLfPfRu43RY75bep6m2CrUsW
0yyREHxyUNtUr6t5QT0BAJBUCFwXLF1xcT3OFrQZwa2uOY3bx2kqGAb1XYkKsfWc
=Hsi/
-----END PGP SIGNATURE-----

--OuK5HSlsKdmIsMRgfIpauCespVANEeE4a--
