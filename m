Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab3LDOLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:11:18 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37116 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab3LDOLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:11:15 -0500
Message-ID: <529F37EA.9040503@ti.com>
Date: Wed, 4 Dec 2013 10:10:50 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lukasz Majewski <l.majewski@samsung.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zhang Rui <rui.zhang@intel.com>,
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
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com> <1383672411-26324-1-git-send-email-l.majewski@samsung.com> <1383672411-26324-8-git-send-email-l.majewski@samsung.com> <529C9ED2.2060106@ti.com> <20131203083159.35895456@amdc2363> <529DD05E.1050402@ti.com> <20131203164214.3d4730f1@amdc2363>
In-Reply-To: <20131203164214.3d4730f1@amdc2363>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="HuKVE6fG062jc87J1eocaSbdR626hDUNs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HuKVE6fG062jc87J1eocaSbdR626hDUNs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hey Lukasz!,

On 03-12-2013 11:42, Lukasz Majewski wrote:
> Hi Eduardo,
>=20
>> On 03-12-2013 03:31, Lukasz Majewski wrote:
>>> Hi Eduardo,
>>>
>>>> On 05-11-2013 13:26, Lukasz Majewski wrote:
>>>>> This patch provides auto disable/enable operation for boost. It
>>>>> uses already present thermal infrastructure to provide boost
>>>>> hysteresis. A special set of TMU data has been defined for
>>>>> Exynos4412, which is only considered when BOOST is enabled.
>>>>
>>>> Can you please add more description why you need a different set of
>>>> thermal data when boost is enabled?=20
>>>
>>> It turned out that the Thermal subsystem (after rework done for
>>> v3.12) is capable of providing hysteresis for BOOST.
>>>
>>
>> So, the difference is only the hysteresis?
>>
>>> For version of the patch up to v8 I had to modify the thermal core
>>> to provide such functionality. Changes in core weren't accepted by
>>> Zhang Rui.
>>
>> Ok... But still I didn't get what you needed to modify and why..
>> Sorry I jumped in the middle of ongoing discussion.
>>
>>>
>>> Then I've looked again to the code and it turned out that proper
>>> setting of Exynos4x12 data (like trigger levels and freq_clip_max)
>>> can solve the problem in a much better way by using Exynos thermal
>>> interrupts.
>>> Another advantage is that those changes are done per device.
>>>
>>>> This is also important in case you
>>>> (Exynos thermal folks) would like to migrate this driver to have
>>>> thermal data support in DT.
>>>
>>> Some work on this driver is ongoing (mainly done by Bartek
>>> Zolnierkiewicz). This BOOST change doesn't break anything and only
>>> extend the current thermal code. Thereof it will not break anything.
>>
>> Well, good that it does not break anything, right?
>>
>> But, My point, Lukasz, is that I am failing to understand, based on
>> your patch and description why we need a different data definition,
>> one for boost, other for without boost. Can you help me to get your
>> intention with this patch properly?
>=20
> I reduce the trigger_level[0] and set new .freq_table[0] entry.
> It works as follow (for BOOST):
>=20
> 1. Non-boost freq is 1.4 GHz on Exynos4412. BOOST is 1.5GHz. The BOOST
> itself is enabled by CONFIG_CPU_FREQ_BOOST_SW.=20
>=20
> 2. Exynos TMU driver reaches the lower TMU level (70 deg). Then the
> core thermal looks for proper frequency table (.freq_tab[0]). If the
> .temp_level matches the trigger_levels[0], then the frequency is reduce=
d
> to .freq_clip_max =3D 1400 * 1000.=20
>=20
> When the device cools down to 60 deg (trigger_levels[0] -
> threshold_falling), then the max freq is restored to 1.5 GHz. This is
> done automatically by thermal core.
>=20
> For BOOST disabled we only can run with 1.4 GHz freq. For this reason
> the freq_tab[X] entries must be modified. Also the Exynos part of
> thermal requires that trigger_levels[0] is the lowest temperature trip,=

> so I cannot add the "BOOST disable" temp level in the end of
> TMU_DATA_BOOST.

OK. The entire thing is to allow dynamic control on your speedbin
frequencies, I see. What bugs me, is that this themal driver keeps
another table of frequencies. Ideally, it should not care about it, but
about the thermal behavior changes, meaning, say, how fast your
temperature rises, when you jump from lowest opp to 1.4GHz or 1.5GHz, on
host process or cold process samples.

>=20
>>
>> Side question is what happens in runtime if user echo 0 > boost?
>=20
> As we had agreed with Rafael and Viresh, we are here mimic the HW CPUs
> behaviour (like Intel CPU).

Which is fine and expected.

> When user writes 'echo 0 > boost' then at cpufreq core we switch to max=

> freq to 1.4 GHz.

OK.

>=20
> Thermal here is only for safety reasons. =20
>=20
>> Should we switch the data within the driver?=20
>=20
> No. When one decides to enable CONFIG_CPU_FREQ_BOOST_SW, then
> corresponding Exynos data are persistent.=20
>=20
>> Would we be penalizing
>> performance with strict hysteresis while we could be allowing longer
>> periods of high frequency usage?=20
>=20
> But the hysteresis shows up only for emergency - when we go out from
> allowed power envelope.
>=20
> The BOOST is a component of LAB governor, which takes into account the
> number of running cores. The "normal" BOOST use case is a situation
> when at most two cores are running and other are down.
> In this situation we can use BOOST to finish work faster.
>=20
>> See what I am missing? Maybe we
>> actually need something else a part from defining one data structure
>> for boost other for non-boost systems.
>=20
> I'm open for suggestions.
>=20
> The current proposal aims to change TMU data only for target SoC -
> Exynos4412 in this case. I deliberately don't touch the thermal core
> code.


In fact, I see.

I am just wondering if it makes sense to simply use the data that
represents BOOST always. Wouldn't be same as in the situation where user
echo 0 > boost?

>=20
>>
>>>
>>>>
>>>>
>>>>>
>>>>> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
>>>>> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>>>>>
>>>>> ---
>>>>> Changes for v10:
>>>>>     - Remove boost related code from thermal_core.c
>>>>>     - Use already present thermal infrastructure to provide
>>>>> thermal hysteresis
>>>>>     - Introduce special set of TMU data for BOOST
>>>>>
>>>>> Changes for v9:
>>>>>     - None
>>>>>
>>>>> Changes for v8:
>>>>>     - Move cpufreq_boost_* stub functions definition (needed when
>>>>> cpufreq is not compiled in) to cpufreq.h at cpufreq core support
>>>>> commit
>>>>>
>>>>> Changes for v7:
>>>>>     - None
>>>>>
>>>>> Changes for v6:
>>>>>     - Disable boost only when supported and enabled
>>>>>     - Protect boost related thermal_zone_device struct fields with
>>>>> mutex
>>>>>     - Evaluate temperature trend during boost enable decision
>>>>>     - Create separate methods to handle boost enable/disable
>>>>>       (thermal_boost_{enable|disable}) operations
>>>>>     - Boost is disabled at any trip point passage (not only the
>>>>> non critical one)
>>>>>     - Add stub definitions for cpufreq boost functions used when
>>>>>       CONFIG_CPU_FREQ is NOT defined.
>>>>>
>>>>> Changes for v5:
>>>>>     - Move boost disable code from cpu_cooling.c to thermal_core.c
>>>>>       (to handle_non_critical_trips)
>>>>>     - Extent struct thermal_zone_device by adding overheated bool
>>>>> flag
>>>>>     - Implement auto enable of boost after device cools down
>>>>>     - Introduce boost_polling flag, which indicates if thermal
>>>>> uses it's predefined pool delay or has woken up thermal workqueue
>>>>> only to wait until device cools down.
>>>>>
>>>>> Changes for v4:
>>>>>     - New patch
>>>>
>>>>
>>>> Might be interesting to see the changelog for this patch only.
>>>
>>> The above list presents the development state of this particular
>>> patch (thermal).=20
>>> Up to v8 I had modified the thermal core. For v10 I've decided to
>>> use proper Exynos data setting.
>>>
>>> If in any doubt, please ask.=20
>>>
>>> This last thermal patch of the series hinders this code to be
>>> applied to cpufreq subsystem (Viresh had acked it some time ago and
>>> I hope that he hasn't changed his mind :-) ).
>>>
>>>
>>>>
>>>>>
>>>>>  drivers/thermal/samsung/exynos_tmu_data.c |   47
>>>>> +++++++++++++++++++++++++++++ 1 file changed, 47 insertions(+)
>>>>>
>>>>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c
>>>>> b/drivers/thermal/samsung/exynos_tmu_data.c index 073c292..9346926
>>>>> 100644 --- a/drivers/thermal/samsung/exynos_tmu_data.c
>>>>> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
>>>>> @@ -167,13 +167,60 @@ static const struct exynos_tmu_registers
>>>>> exynos4412_tmu_registers =3D { .features =3D (TMU_SUPPORT_EMULATION=
 |
>>>>> TMU_SUPPORT_TRIM_RELOAD | \ TMU_SUPPORT_FALLING_TRIP |
>>>>> TMU_SUPPORT_READY_STATUS | \ TMU_SUPPORT_EMUL_TIME)
>>>>> +
>>>>> +#define EXYNOS4412_TMU_DATA_BOOST \
>>>>> +	.threshold_falling =3D 10, \
>>>>> +	.trigger_levels[0] =3D 70, \
>>>>> +	.trigger_levels[1] =3D 85, \
>>>>> +	.trigger_levels[2] =3D 103, \
>>>>> +	.trigger_levels[3] =3D 110, \
>>>>> +	.trigger_enable[0] =3D true, \
>>>>> +	.trigger_enable[1] =3D true, \
>>>>> +	.trigger_enable[2] =3D true, \
>>>>> +	.trigger_enable[3] =3D true, \
>>>>> +	.trigger_type[0] =3D THROTTLE_ACTIVE, \
>>>>> +	.trigger_type[1] =3D THROTTLE_ACTIVE, \
>>>>> +	.trigger_type[2] =3D THROTTLE_ACTIVE, \
>>>>> +	.trigger_type[3] =3D SW_TRIP, \
>>>>> +	.max_trigger_level =3D 4, \
>>>>> +	.gain =3D 8, \
>>>>> +	.reference_voltage =3D 16, \
>>>>> +	.noise_cancel_mode =3D 4, \
>>>>> +	.cal_type =3D TYPE_ONE_POINT_TRIMMING, \
>>>>> +	.efuse_value =3D 55, \
>>>>> +	.min_efuse_value =3D 40, \
>>>>> +	.max_efuse_value =3D 100, \
>>>>> +	.first_point_trim =3D 25, \
>>>>> +	.second_point_trim =3D 85, \
>>>>> +	.default_temp_offset =3D 50, \
>>>>> +	.freq_tab[0] =3D { \
>>>>> +		.freq_clip_max =3D 1400 * 1000, \
>>>>> +		.temp_level =3D 70, \
>>>>> +	}, \
>>>>> +	.freq_tab[1] =3D { \
>>>>> +		.freq_clip_max =3D 800 * 1000, \
>>>>> +		.temp_level =3D 85, \
>>>>> +	}, \
>>>>> +	.freq_tab[2] =3D { \
>>>>> +		.freq_clip_max =3D 200 * 1000, \
>>>>> +		.temp_level =3D 103, \
>>>>> +	}, \
>>>>> +	.freq_tab_count =3D 3, \
>>>>> +	.registers =3D &exynos4412_tmu_registers, \
>>>>> +	.features =3D (TMU_SUPPORT_EMULATION |
>>>>> TMU_SUPPORT_TRIM_RELOAD | \
>>>>> +			TMU_SUPPORT_FALLING_TRIP |
>>>>> TMU_SUPPORT_READY_STATUS | \
>>>>> +			TMU_SUPPORT_EMUL_TIME)
>>>>>  #endif
>>>>> =20
>>>>>  #if defined(CONFIG_SOC_EXYNOS4412)
>>>>>  struct exynos_tmu_init_data const exynos4412_default_tmu_data =3D =
{
>>>>>  	.tmu_data =3D {
>>>>>  		{
>>>>> +#ifdef CONFIG_CPU_FREQ_BOOST_SW
>>>>> +			EXYNOS4412_TMU_DATA_BOOST,
>>>>> +#else
>>>>>  			EXYNOS4412_TMU_DATA,
>>>>> +#endif
>>>>>  			.type =3D SOC_ARCH_EXYNOS4412,
>>>>>  			.test_mux =3D EXYNOS4412_MUX_ADDR_VALUE,
>>>>>  		},
>>>>>
>>>>
>>>>
>>>
>>
>>
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--HuKVE6fG062jc87J1eocaSbdR626hDUNs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKfN+0ACgkQCXcVR3XQvP3VrQD8C0wrPIG+SSNnnfOBRi78SBbI
jvuCroqf3Z9Lpg2Yr5UA/Az4pkX+e4jMQP/PxmOhllRixr+opk+PMDTvMS4F02GF
=Q5Aq
-----END PGP SIGNATURE-----

--HuKVE6fG062jc87J1eocaSbdR626hDUNs--
