Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab3KROqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:46:31 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59099 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab3KROqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:46:23 -0500
Message-ID: <528A27EE.9090604@ti.com>
Date: Mon, 18 Nov 2013 10:45:02 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>, <swarren@wwwdotorg.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <devicetree@vger.kernel.org>, <wni@nvidia.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <grant.likely@linaro.org>
Subject: Re: [lm-sensors] [PATCHv9 02/20] thermal: introduce device tree parser
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>  <1384285582-16933-3-git-send-email-eduardo.valentin@ti.com>  <20131115090736.4f360dc8@endymion.delvare> <1384754650.2316.32.camel@rzhang-lenovo>
In-Reply-To: <1384754650.2316.32.camel@rzhang-lenovo>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="cS4dWoBMcPp72AHaaoV2xdAjjHbVefF7C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cS4dWoBMcPp72AHaaoV2xdAjjHbVefF7C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello Jean,

I will try to complement what Rui's already commented.

On 18-11-2013 02:04, Zhang Rui wrote:
> On =E4=BA=94, 2013-11-15 at 09:07 +0100, Jean Delvare wrote:
>> Hi Eduardo,
>>
>> On Tue, 12 Nov 2013 15:46:04 -0400, Eduardo Valentin wrote:
>>> This patch introduces a device tree bindings for
>>> describing the hardware thermal behavior and limits.
>>> Also a parser to read and interpret the data and feed
>>> it in the thermal framework is presented.
>>>
>>> This patch introduces a thermal data parser for device
>>> tree. The parsed data is used to build thermal zones
>>> and thermal binding parameters. The output data
>>> can then be used to deploy thermal policies.
>>>
>>> This patch adds also documentation regarding this
>>> API and how to define tree nodes to use
>>> this infrastructure.
>>>
>>> Note that, in order to be able to have control
>>> on the sensor registration on the DT thermal zone,
>>> it was required to allow changing the thermal zone
>>> .get_temp callback. For this reason, this patch
>>> also removes the 'const' modifier from the .ops
>>> field of thermal zone devices.
>>>
>>> Cc: Zhang Rui <rui.zhang@intel.com>
>>> Cc: linux-pm@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>>> ---
>>> (...)
>>> +static int of_thermal_get_trend(struct thermal_zone_device *tz, int =
trip,
>>> +				enum thermal_trend *trend)
>>> +{
>>> +	struct __thermal_zone *data =3D tz->devdata;
>>> +	long dev_trend;
>>> +	int r;
>>> +
>>> +	if (!data->get_trend)
>>> +		return -EINVAL;
>>> +
>>> +	r =3D data->get_trend(data->sensor_data, &dev_trend);
>>> +	if (r)
>>> +		return r;
>>> +
>>> +	/* TODO: These intervals might have some thresholds, but in core co=
de */
>>> +	if (dev_trend > 0)
>>> +		*trend =3D THERMAL_TREND_RAISING;
>>> +	else if (dev_trend < 0)
>>> +		*trend =3D THERMAL_TREND_DROPPING;
>>> +	else
>>> +		*trend =3D THERMAL_TREND_STABLE;
>>> +
>>> +	return 0;
>>> +}
>>
>> I don't like the whole trend thing.
>>
>> I've been writing hwmon drivers for the past decade and I've never see=
n
>> a thermal sensor device being able to report trends. And as a rule of
>> thumb, if the hardware can't do it then the (hardware-specific) driver=
s
>> should not report it.

In fact, I would agree with you that it is not common to see such
devices. What I've already seen is that HW provides is usually artifacts
that may help on computing such statistic data. And in that case it may
be the case that the data coming from the HW may have less noise, such
as system overhead, than that computed by the caller.

However, it is also the case that such artifacts do not work without a
proper platform dependent configuration step, such as update interval
and size of the history window.

>=20
> I agree that a sensor device should not be able to report trends. But
> currently, the thermal zone driver is not only a sensor driver, it also=

> owns the platform thermal cooling strategy.
> And some platforms do have this kind of knowledge, right?
> e.g. ACPI spec provides an equation for processor passive cooling (ACPI=

> Spec 5.0 11.1.5).
>=20

Just a complementary point here, The design of current thermal framework
is so that get_trend is zone specific, and thus, it has to consider the
cooling strategy owned by the driver, like the update interval. And
besides, in case the driver does not know how to compute the trend, the
framework, the caller of that callback, also provides default behavior.

The purpose of this series is to split the data that is platform
dependent and allow designers to write those data points in device tree.
That is why the "glue layer" still keeps the get_trend.


>>
>> Hwmon devices (and drivers) report temperature values, and sometimes
>> historical min/max. They can do that because these are facts that need=

>> no interpretation.
>>
>> Defining a trend, however, requires care and, more importantly,
>> decisions.


Maybe your concern is the fact that it would be very hard to provide a
trend from a hwmon driver? And that I agree, unless the device provides
artifacts. But that is not the case for all users of this API. For
instance, some versions of TI SoC bandgap sensors may have historical
buffers and cumulative values. But obviously, these features would work
only if proper configuration is agreed.

>=20
> We had the assumption that we will get an interrupt when the firmware
> thinks there is an temperature change that should be noticed by OS.
>=20
>>  For example, consider a thermal sensor which reports 50=C2=B0C at
>> time t, then 47=C2=B0C at time t+3s,
>=20
> does firmware thinks this should be noticed by OS?
> If no, there is no interrupt and this temperature change is totally
> transparent to the OS at all.
> If yes, the thermal core will check if the system is overheating, if
> yes, it throttles the devices, and if no, do nothing.
>=20
>>  then 48=C2=B0C at time t+6s. At t+7s someone
>> asks for the trend,
>=20
> the trend is needed when platform thermal driver calls
> thermal_zone_device_update(), and mostly following a temperature change=

> interrupt.
>=20
>>  what should the driver reply?
>>  If you consider only
>> the last 5 seconds, temperature is raising. If you consider the last 1=
0
>> seconds instead, temperature is dropping. How would the driver know
>> what time frame the caller is interested in?
>>
>> Another example: "small" temperature variations. If temperatures varie=
s
>> by 1=C2=B0C in my kitchen's oven, I'd call it stable. If my body tempe=
rature
>> varies by 1=C2=B0C, I'd call it non-stable, and my doctor for an appoi=
ntment
>> also ;-)
>>
>=20
>> My point is that only the caller, and not the driver, knows how to
>> convert a series of measurements into a trend. So I don't think driver=
s

Agreed here. However, the caller can also instruct the device to help on
the computation based on historical values. And historical values can be
configured also by the caller.

>> should implement anything like get_trend(). Whatever piece of code
>> needs to establish a trend should call get_temp() repeatedly, store th=
e
>> results and do its own analysis of the data.
>>
> I think the key problem is that,
> the thermal subsystem just provides a basic/minimum thermal control
> framework in kernel, and it is totally platform independent. And any
> platform driver can use this framework to do some basic thermal control=

> easily but just telling thermal core if the thermal core should take
> some cooling actions (trip points + trend + current temperature) and ho=
w
> (by choosing thermal governors).
>=20
> So if you want to do more precise thermal control, you'd better disable=

> kernel thermal control and do it in userspace. In this case,
> the .get_trend() will never be invoked at all.
> Further more, I'm indeed considering introduce platform specific therma=
l
> governors, so that platform thermal driver can tell thermal core what t=
o
> do at a certain point.
>=20
> thanks,
> rui
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--cS4dWoBMcPp72AHaaoV2xdAjjHbVefF7C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKKJ+4ACgkQCXcVR3XQvP0CNwD/dmNlvLGSoMdyDQ1gn6cEotoG
u6UjjKJQYeqeyWgrbgQA/Avo7zGbLvfoKphA0m6+XVAQC5fZkKKIw00IBCgOIGJz
=hUNh
-----END PGP SIGNATURE-----

--cS4dWoBMcPp72AHaaoV2xdAjjHbVefF7C--
