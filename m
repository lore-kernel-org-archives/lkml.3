Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab3JNOZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:25:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57664 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab3JNOZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:25:06 -0400
Message-ID: <525BFEB0.9080609@ti.com>
Date: Mon, 14 Oct 2013 10:24:48 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lukasz Majewski <l.majewski@samsung.com>
CC: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, <kgene.kim@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, <devicetree@vger.kernel.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] thermal: exynos: Provide initial setting for TMU's
 test MUX address at Exynos4412
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com> <1381300194-13134-1-git-send-email-l.majewski@samsung.com> <1381300194-13134-4-git-send-email-l.majewski@samsung.com>
In-Reply-To: <1381300194-13134-4-git-send-email-l.majewski@samsung.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="kaJwQAgMKePoiALPutGqcHJIBSBNNFdbC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kaJwQAgMKePoiALPutGqcHJIBSBNNFdbC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09-10-2013 02:29, Lukasz Majewski wrote:
> The commit d0a0ce3e77c795258d47f9163e92d5031d0c5221 ("thermal: exynos: =
Add
> missing definations and code cleanup") has removed setting of test MUX =
address
> value at TMU configuration setting.
>=20
> This field is not present on Exynos4210 and Exynos5 SoCs. However on Ex=
ynos4412
> SoC it is required to set this field after reset because without it TMU=
 shows
> maximal available temperature, which causes immediate platform shutdown=
=2E
>=20
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>=20
> ---
> Changes for v2:
> - Define test_mux and test_mux_addr_shift to not use direct register ac=
cess
> - Remove pdata->type =3D=3D SOC_ARCH_EXYNOS4412 check at exynos_tmu_con=
trol() and
>   use only generic code
>=20
>  drivers/thermal/samsung/exynos_tmu.c      |    3 +++
>  drivers/thermal/samsung/exynos_tmu.h      |    4 ++++
>  drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
>  drivers/thermal/samsung/exynos_tmu_data.h |    4 ++++
>  4 files changed, 13 insertions(+)
>=20
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index 1312b34..32f38b9 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -317,6 +317,9 @@ static void exynos_tmu_control(struct platform_devi=
ce *pdev, bool on)
> =20
>  	con =3D readl(data->base + reg->tmu_ctrl);
> =20
> +	if (pdata->test_mux)


test_mux field is in fact an address, correct? Can 0 be a valid address?

Why not using the feature flags to test for capabilities, features and
required configurations instead of assuming obscure domain and address
ranges?


> +		con |=3D (pdata->test_mux << reg->test_mux_addr_shift);
> +
>  	if (pdata->reference_voltage) {
>  		con &=3D ~(reg->buf_vref_sel_mask << reg->buf_vref_sel_shift);
>  		con |=3D pdata->reference_voltage << reg->buf_vref_sel_shift;
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/sam=
sung/exynos_tmu.h
> index b42ece4..3fb6554 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -85,6 +85,7 @@ enum soc_type {
>   * @triminfo_reload_shift: shift of triminfo reload enable bit in trim=
info_ctrl
>  	reg.
>   * @tmu_ctrl: TMU main controller register.
> + * @test_mux_addr_shift: shift bits of test mux address.
>   * @buf_vref_sel_shift: shift bits of reference voltage in tmu_ctrl re=
gister.
>   * @buf_vref_sel_mask: mask bits of reference voltage in tmu_ctrl regi=
ster.
>   * @therm_trip_mode_shift: shift bits of tripping mode in tmu_ctrl reg=
ister.
> @@ -151,6 +152,7 @@ struct exynos_tmu_registers {
>  	u32	triminfo_reload_shift;
> =20
>  	u32	tmu_ctrl;
> +	u32     test_mux_addr_shift;
>  	u32	buf_vref_sel_shift;
>  	u32	buf_vref_sel_mask;
>  	u32	therm_trip_mode_shift;
> @@ -258,6 +260,7 @@ struct exynos_tmu_registers {
>   * @first_point_trim: temp value of the first point trimming
>   * @second_point_trim: temp value of the second point trimming
>   * @default_temp_offset: default temperature offset in case of no trim=
ming
> + * @test_mux; information if SoC supports test MUX
>   * @cal_type: calibration type for temperature
>   * @cal_mode: calibration mode for temperature
>   * @freq_clip_table: Table representing frequency reduction percentage=
=2E
> @@ -287,6 +290,7 @@ struct exynos_tmu_platform_data {
>  	u8 first_point_trim;
>  	u8 second_point_trim;
>  	u8 default_temp_offset;
> +	u8 test_mux;
> =20
>  	enum calibration_type cal_type;
>  	enum calibration_mode cal_mode;
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/therma=
l/samsung/exynos_tmu_data.c
> index d8de5c1..073c292 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -98,6 +98,7 @@ static const struct exynos_tmu_registers exynos4412_t=
mu_registers =3D {
>  	.triminfo_ctrl =3D EXYNOS_TMU_TRIMINFO_CON,
>  	.triminfo_reload_shift =3D EXYNOS_TRIMINFO_RELOAD_SHIFT,
>  	.tmu_ctrl =3D EXYNOS_TMU_REG_CONTROL,
> +	.test_mux_addr_shift =3D EXYNOS4412_MUX_ADDR_SHIFT,
>  	.buf_vref_sel_shift =3D EXYNOS_TMU_REF_VOLTAGE_SHIFT,
>  	.buf_vref_sel_mask =3D EXYNOS_TMU_REF_VOLTAGE_MASK,
>  	.therm_trip_mode_shift =3D EXYNOS_TMU_TRIP_MODE_SHIFT,
> @@ -174,6 +175,7 @@ struct exynos_tmu_init_data const exynos4412_defaul=
t_tmu_data =3D {
>  		{
>  			EXYNOS4412_TMU_DATA,
>  			.type =3D SOC_ARCH_EXYNOS4412,
> +			.test_mux =3D EXYNOS4412_MUX_ADDR_VALUE,
>  		},
>  	},
>  	.tmu_count =3D 1,
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/therma=
l/samsung/exynos_tmu_data.h
> index b130b1e..a1ea19d 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -95,6 +95,10 @@
> =20
>  #define EXYNOS_MAX_TRIGGER_PER_REG	4
> =20
> +/* Exynos4412 specific */
> +#define EXYNOS4412_MUX_ADDR_VALUE          6

> +#define EXYNOS4412_MUX_ADDR_SHIFT          20
> +
>  /*exynos5440 specific registers*/
>  #define EXYNOS5440_TMU_S0_7_TRIM		0x000
>  #define EXYNOS5440_TMU_S0_7_CTRL		0x020
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--kaJwQAgMKePoiALPutGqcHJIBSBNNFdbC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJb/rEACgkQCXcVR3XQvP1NPwEAy/+oc1CMkcEd0d1+0hDFH/kj
wjWGVBkkePaM0gqyLPsA+wVBdxYl0dRD/8G/gCfq4i4jRqb2NMi252EXPC4utCHC
=vJOJ
-----END PGP SIGNATURE-----

--kaJwQAgMKePoiALPutGqcHJIBSBNNFdbC--
