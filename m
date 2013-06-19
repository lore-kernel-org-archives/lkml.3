Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935200Ab3FSUwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 16:52:42 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54606 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934971Ab3FSUwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 16:52:40 -0400
Message-ID: <51C21A0B.3080705@ti.com>
Date: Wed, 19 Jun 2013 16:52:27 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 09/30] thermal: exynos: Add extra entries in the tmu
 platform data
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-10-git-send-email-amit.daniel@samsung.com> <51C2125C.80402@ti.com>
In-Reply-To: <51C2125C.80402@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2UPAFCRLNUSDMAAWJFLEA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2UPAFCRLNUSDMAAWJFLEA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 19-06-2013 16:19, Eduardo Valentin wrote:
> On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
>> This patch adds entries min_efuse_value, max_efuse_value, default_temp=
_offset,
>> trigger_type, cal_type, trim_first_point, trim_second_point, max_trigg=
er_level
>> trigger_enable in the TMU platform data structure. Also the driver is =
modified
>> to use the data passed by these new platform memebers instead of the c=
onstant
>> macros. All these changes helps in separating the SOC specific data pa=
rt from
>> the TMU driver.
>>
>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  drivers/thermal/samsung/exynos_thermal_common.h |    7 +++
>>  drivers/thermal/samsung/exynos_tmu.c            |   43 ++++++++++----=
------
>>  drivers/thermal/samsung/exynos_tmu.h            |   49 ++++++++++++++=
--------
>>  drivers/thermal/samsung/exynos_tmu_data.c       |   35 ++++++++++++--=
--
>>  4 files changed, 86 insertions(+), 48 deletions(-)
>>
>> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers=
/thermal/samsung/exynos_thermal_common.h
>> index 068f56c..fd789a5 100644
>> --- a/drivers/thermal/samsung/exynos_thermal_common.h
>> +++ b/drivers/thermal/samsung/exynos_thermal_common.h
>> @@ -44,6 +44,13 @@
>> =20
>>  #define EXYNOS_ZONE_COUNT	3
>> =20
>> +enum trigger_type {
>> +	THROTTLE_ACTIVE =3D 1,
>> +	THROTTLE_PASSIVE,
>> +	SW_TRIP,
>> +	HW_TRIP,
>> +};
>> +
>>  /**
>>   * struct freq_clip_table
>>   * @freq_clip_max: maximum frequency allowed for this cooling state.
>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sa=
msung/exynos_tmu.c
>> index fa33a48..401ec98 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.c
>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>> @@ -49,7 +49,6 @@
>>  #define EXYNOS_TMU_BUF_SLOPE_SEL_MASK	0xf
>>  #define EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT	8
>>  #define EXYNOS_TMU_CORE_EN_SHIFT	0
>> -#define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET	50
>> =20
>>  /* Exynos4210 specific registers */
>>  #define EXYNOS4210_TMU_REG_THRESHOLD_TEMP	0x44
>> @@ -94,9 +93,6 @@
>>  #define EXYNOS_TMU_INTEN_FALL1_SHIFT	20
>>  #define EXYNOS_TMU_INTEN_FALL2_SHIFT	24
>> =20
>> -#define EFUSE_MIN_VALUE 40
>> -#define EFUSE_MAX_VALUE 100
>> -
>>  #ifdef CONFIG_THERMAL_EMULATION
>>  #define EXYNOS_EMUL_TIME	0x57F0
>>  #define EXYNOS_EMUL_TIME_MASK	0xffff
>> @@ -136,15 +132,16 @@ static int temp_to_code(struct exynos_tmu_data *=
data, u8 temp)
>> =20
>>  	switch (pdata->cal_type) {
>>  	case TYPE_TWO_POINT_TRIMMING:
>> -		temp_code =3D (temp - 25) *
>> -		    (data->temp_error2 - data->temp_error1) /
>> -		    (85 - 25) + data->temp_error1;
>> +		temp_code =3D (temp - pdata->first_point_trim) *
>> +			(data->temp_error2 - data->temp_error1) /
>> +			(pdata->second_point_trim - pdata->first_point_trim) +
>> +			data->temp_error1;
>>  		break;
>>  	case TYPE_ONE_POINT_TRIMMING:
>> -		temp_code =3D temp + data->temp_error1 - 25;
>> +		temp_code =3D temp + data->temp_error1 - pdata->first_point_trim;
>>  		break;
>>  	default:
>> -		temp_code =3D temp + EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET;
>> +		temp_code =3D temp + pdata->default_temp_offset;
>>  		break;
>>  	}
>>  out:
>> @@ -169,14 +166,16 @@ static int code_to_temp(struct exynos_tmu_data *=
data, u8 temp_code)
>> =20
>>  	switch (pdata->cal_type) {
>>  	case TYPE_TWO_POINT_TRIMMING:
>> -		temp =3D (temp_code - data->temp_error1) * (85 - 25) /
>> -		    (data->temp_error2 - data->temp_error1) + 25;
>> +		temp =3D (temp_code - data->temp_error1) *
>> +			(pdata->second_point_trim - pdata->first_point_trim) /
>> +			(data->temp_error2 - data->temp_error1) +
>> +			pdata->first_point_trim;
>>  		break;
>>  	case TYPE_ONE_POINT_TRIMMING:
>> -		temp =3D temp_code - data->temp_error1 + 25;
>> +		temp =3D temp_code - data->temp_error1 + pdata->first_point_trim;
>>  		break;
>>  	default:
>> -		temp =3D temp_code - EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET;
>> +		temp =3D temp_code - pdata->default_temp_offset;
>>  		break;
>>  	}
>>  out:
>> @@ -209,8 +208,8 @@ static int exynos_tmu_initialize(struct platform_d=
evice *pdev)
>>  	data->temp_error1 =3D trim_info & EXYNOS_TMU_TRIM_TEMP_MASK;
>>  	data->temp_error2 =3D ((trim_info >> 8) & EXYNOS_TMU_TRIM_TEMP_MASK)=
;
>> =20
>> -	if ((EFUSE_MIN_VALUE > data->temp_error1) ||
>> -			(data->temp_error1 > EFUSE_MAX_VALUE) ||
>> +	if ((pdata->min_efuse_value > data->temp_error1) ||
>> +			(data->temp_error1 > pdata->max_efuse_value) ||
>>  			(data->temp_error2 !=3D 0))
>>  		data->temp_error1 =3D pdata->efuse_value;
>> =20
>> @@ -300,10 +299,10 @@ static void exynos_tmu_control(struct platform_d=
evice *pdev, bool on)
>>  	if (on) {
>>  		con |=3D (1 << EXYNOS_TMU_CORE_EN_SHIFT);
>>  		interrupt_en =3D
>> -		pdata->trigger_level3_en << EXYNOS_TMU_INTEN_RISE3_SHIFT |
>> -		pdata->trigger_level2_en << EXYNOS_TMU_INTEN_RISE2_SHIFT |
>> -		pdata->trigger_level1_en << EXYNOS_TMU_INTEN_RISE1_SHIFT |
>> -		pdata->trigger_level0_en << EXYNOS_TMU_INTEN_RISE0_SHIFT;
>> +		pdata->trigger_enable[3] << EXYNOS_TMU_INTEN_RISE3_SHIFT |
>> +		pdata->trigger_enable[2] << EXYNOS_TMU_INTEN_RISE2_SHIFT |
>> +		pdata->trigger_enable[1] << EXYNOS_TMU_INTEN_RISE1_SHIFT |
>> +		pdata->trigger_enable[0] << EXYNOS_TMU_INTEN_RISE0_SHIFT;
>>  		if (pdata->threshold_falling)
>>  			interrupt_en |=3D
>>  				interrupt_en << EXYNOS_TMU_INTEN_FALL0_SHIFT;
>> @@ -533,9 +532,9 @@ static int exynos_tmu_probe(struct platform_device=
 *pdev)
>> =20
>>  	/* Register the sensor with thermal management interface */
>>  	(&exynos_sensor_conf)->private_data =3D data;
>> -	exynos_sensor_conf.trip_data.trip_count =3D pdata->trigger_level0_en=
 +
>> -			pdata->trigger_level1_en + pdata->trigger_level2_en +
>> -			pdata->trigger_level3_en;
>> +	exynos_sensor_conf.trip_data.trip_count =3D pdata->trigger_enable[0]=
 +
>> +			pdata->trigger_enable[1] + pdata->trigger_enable[2]+
>> +			pdata->trigger_enable[3];
>> =20
>>  	for (i =3D 0; i < exynos_sensor_conf.trip_data.trip_count; i++)
>>  		exynos_sensor_conf.trip_data.trip_val[i] =3D
>> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/sa=
msung/exynos_tmu.h
>> index 9e0f887..45c697d 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.h
>> +++ b/drivers/thermal/samsung/exynos_tmu.h
>> @@ -30,6 +30,11 @@ enum calibration_type {
>>  	TYPE_NONE,
>>  };
>> =20
>> +enum calibration_mode {
>> +	SW_MODE,
>> +	HW_MODE,
>> +};
>> +
>>  enum soc_type {
>>  	SOC_ARCH_EXYNOS4210 =3D 1,
>>  	SOC_ARCH_EXYNOS,
>> @@ -55,18 +60,15 @@ enum soc_type {
>>   *	3: temperature for trigger_level3 interrupt
>>   *	   condition for trigger_level3 interrupt:
>>   *		current temperature > threshold + trigger_levels[3]
>> - * @trigger_level0_en:
>> - *	1 =3D enable trigger_level0 interrupt,
>> - *	0 =3D disable trigger_level0 interrupt
>> - * @trigger_level1_en:
>> - *	1 =3D enable trigger_level1 interrupt,
>> - *	0 =3D disable trigger_level1 interrupt
>> - * @trigger_level2_en:
>> - *	1 =3D enable trigger_level2 interrupt,
>> - *	0 =3D disable trigger_level2 interrupt
>> - * @trigger_level3_en:
>> - *	1 =3D enable trigger_level3 interrupt,
>> - *	0 =3D disable trigger_level3 interrupt
>> + * @trigger_type: defines the type of trigger. Possible values are,
>> + *	THROTTLE_ACTIVE trigger type
>> + *	THROTTLE_PASSIVE trigger type
>> + *	SW_TRIP trigger type
>> + *	HW_TRIP
>> + * @trigger_enable[]: array to denote which trigger levels are enable=
d.
>> + *	1 =3D enable trigger_level[] interrupt,
>> + *	0 =3D disable trigger_level[] interrupt
>> + * @max_trigger_level: max trigger level supported by the TMU
>>   * @gain: gain of amplifier in the positive-TC generator block
>>   *	0 <=3D gain <=3D 15
>>   * @reference_voltage: reference voltage of amplifier
>> @@ -76,7 +78,13 @@ enum soc_type {
>>   *	000, 100, 101, 110 and 111 can be different modes
>>   * @type: determines the type of SOC
>>   * @efuse_value: platform defined fuse value
>> + * @min_efuse_value: minimum valid trimming data
>> + * @max_efuse_value: maximum valid trimming data
>> + * @first_point_trim: temp value of the first point trimming
>> + * @second_point_trim: temp value of the second point trimming
>> + * @default_temp_offset: default temperature offset in case of no tri=
mming
>>   * @cal_type: calibration type for temperature
>> + * @cal_mode: calibration mode for temperature
>>   * @freq_clip_table: Table representing frequency reduction percentag=
e.
>>   * @freq_tab_count: Count of the above table as frequency reduction m=
ay
>>   *	applicable to only some of the trigger levels.
>> @@ -86,18 +94,23 @@ enum soc_type {
>>  struct exynos_tmu_platform_data {
>>  	u8 threshold;
>>  	u8 threshold_falling;
>> -	u8 trigger_levels[4];
>> -	bool trigger_level0_en;
>> -	bool trigger_level1_en;
>> -	bool trigger_level2_en;
>> -	bool trigger_level3_en;
>> -
>> +	u8 trigger_levels[MAX_TRIP_COUNT];
>> +	enum trigger_type trigger_type[MAX_TRIP_COUNT];
>> +	bool trigger_enable[MAX_TRIP_COUNT];
>> +	u8 max_trigger_level;
>>  	u8 gain;
>>  	u8 reference_voltage;
>>  	u8 noise_cancel_mode;
>> +
>>  	u32 efuse_value;
>> +	u32 min_efuse_value;
>> +	u32 max_efuse_value;
>> +	u8 first_point_trim;
>> +	u8 second_point_trim;
>> +	u8 default_temp_offset;
>> =20
>>  	enum calibration_type cal_type;
>> +	enum calibration_mode cal_mode;
>>  	enum soc_type type;
>>  	struct freq_clip_table freq_tab[4];
>>  	unsigned int freq_tab_count;
>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/therm=
al/samsung/exynos_tmu_data.c
>> index 13a60ca..a187043 100644
>> --- a/drivers/thermal/samsung/exynos_tmu_data.c
>> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
>> @@ -22,6 +22,7 @@
>> =20
>>  #include "exynos_thermal_common.h"
>>  #include "exynos_tmu.h"
>> +#include "exynos_tmu_data.h"
>=20
> This change needs to be moved to the patch that you added this file.
> Check comment on patch 07/30.
>> =20
>>  #if defined(CONFIG_CPU_EXYNOS4210)
>>  struct exynos_tmu_platform_data const exynos4210_default_tmu_data =3D=
 {
>> @@ -29,13 +30,22 @@ struct exynos_tmu_platform_data const exynos4210_d=
efault_tmu_data =3D {
>>  	.trigger_levels[0] =3D 5,
>>  	.trigger_levels[1] =3D 20,
>>  	.trigger_levels[2] =3D 30,
>> -	.trigger_level0_en =3D 1,
>> -	.trigger_level1_en =3D 1,
>> -	.trigger_level2_en =3D 1,
>> -	.trigger_level3_en =3D 0,
>> +	.trigger_enable[0] =3D 1,
>> +	.trigger_enable[1] =3D 1,
>> +	.trigger_enable[2] =3D 1,
>> +	.trigger_enable[3] =3D 0,

This change added this sparse warning on your driver:
drivers/thermal/samsung/exynos_tmu_data.c:34:10: warning: Initializer
entry defined twice
drivers/thermal/samsung/exynos_tmu_data.c:35:10:   also defined here


>> +	.trigger_type[0] =3D THROTTLE_ACTIVE,
>> +	.trigger_type[1] =3D THROTTLE_ACTIVE,
>> +	.trigger_type[2] =3D SW_TRIP,
>=20
> is there any issues if trigger_type[3] is 0? there is no defined value
> for 0. (0 means undefined on your enum definition).
>=20
>=20
>> +	.max_trigger_level =3D 4,
>>  	.gain =3D 15,
>>  	.reference_voltage =3D 7,
>>  	.cal_type =3D TYPE_ONE_POINT_TRIMMING,
>> +	.min_efuse_value =3D 40,
>> +	.max_efuse_value =3D 100,
>> +	.first_point_trim =3D 25,
>> +	.second_point_trim =3D 85,
>> +	.default_temp_offset =3D 50,
>>  	.freq_tab[0] =3D {
>>  		.freq_clip_max =3D 800 * 1000,
>>  		.temp_level =3D 85,
>> @@ -55,15 +65,24 @@ struct exynos_tmu_platform_data const exynos5250_d=
efault_tmu_data =3D {
>>  	.trigger_levels[0] =3D 85,
>>  	.trigger_levels[1] =3D 103,
>>  	.trigger_levels[2] =3D 110,
>> -	.trigger_level0_en =3D 1,
>> -	.trigger_level1_en =3D 1,
>> -	.trigger_level2_en =3D 1,
>> -	.trigger_level3_en =3D 0,
>> +	.trigger_enable[0] =3D 1,
>> +	.trigger_enable[1] =3D 1,
>> +	.trigger_enable[2] =3D 1,
>> +	.trigger_enable[3] =3D 0,


This change add this sparse warning on your driver:
drivers/thermal/samsung/exynos_tmu_data.c:69:10: warning: Initializer
entry defined twice
drivers/thermal/samsung/exynos_tmu_data.c:70:10:   also defined here


>> +	.trigger_type[0] =3D THROTTLE_ACTIVE,
>> +	.trigger_type[1] =3D THROTTLE_ACTIVE,
>> +	.trigger_type[2] =3D SW_TRIP,
>> +	.max_trigger_level =3D 4,
>>  	.gain =3D 8,
>>  	.reference_voltage =3D 16,
>>  	.noise_cancel_mode =3D 4,
>>  	.cal_type =3D TYPE_ONE_POINT_TRIMMING,
>>  	.efuse_value =3D 55,
>> +	.min_efuse_value =3D 40,
>> +	.max_efuse_value =3D 100,
>> +	.first_point_trim =3D 25,
>> +	.second_point_trim =3D 85,
>> +	.default_temp_offset =3D 50,
>>  	.freq_tab[0] =3D {
>>  		.freq_clip_max =3D 800 * 1000,
>>  		.temp_level =3D 85,
>>
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2UPAFCRLNUSDMAAWJFLEA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCGgsACgkQCXcVR3XQvP0lAQEApphN4BoXS3DN0uwzkxBJjj7t
7PBveENpTSktpxh8JswBAL1km3nMfgobIhXSo95Vo4QhQaQQER5Tduv40AhJuvFI
=c3MZ
-----END PGP SIGNATURE-----

------enig2UPAFCRLNUSDMAAWJFLEA--
