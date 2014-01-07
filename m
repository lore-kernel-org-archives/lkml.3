Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaAGQfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 11:35:24 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50551 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaAGQfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 11:35:18 -0500
Message-ID: <52CC2C58.5080205@ti.com>
Date: Tue, 7 Jan 2014 12:33:28 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Frodo Looijaard <frodol@dds.nl>,
        <lm-sensors@lm-sensors.org>, Zhang Rui <rui.zhang@intel.com>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] hwmon/sensors: fix SENSORS_LM75 dependencies
References: <20140106204020.b47e53cc3ead8f90164ef5b7@canb.auug.org.au> <52CB0948.6030702@infradead.org> <20140106203209.GA21630@roeck-us.net> <52CB53DC.4030901@infradead.org> <52CB65DA.2010103@roeck-us.net> <20140107130401.23bffcd2@endymion.delvare> <52CBF1CF.2000603@ti.com> <20140107152148.36768345@endymion.delvare>
In-Reply-To: <20140107152148.36768345@endymion.delvare>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="m3Mo5vQbTd1BAO3H7ex0KSOLEI0DhJlb1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--m3Mo5vQbTd1BAO3H7ex0KSOLEI0DhJlb1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07-01-2014 10:21, Jean Delvare wrote:
> Hi Eduardo,
>=20
> On Tue, 7 Jan 2014 08:23:43 -0400, Eduardo Valentin wrote:
>> On 07-01-2014 08:04, Jean Delvare wrote:
>>> On Mon, 06 Jan 2014 18:26:34 -0800, Guenter Roeck wrote:
>>>> This needs to be addressed
>>>> in the thermal code, for example with dummy declarations if THERMAL=3D=
m but
>>>> SENSORS_LM75=3Dy. The functions are already declared as dummies if T=
HERMAL_OF=3Dn.
>>>
>>> This won't fly I'm afraid, the number of hwmon drivers affected will
>>> grow in the future and you certainly don't want to have to change the=

>>> generic thermal code every time a new driver is added/converted.
>>
>> Agreed
>>
>>>
>>> I've looked at the problem this morning and I will admit I do not eve=
n
>>> understand what the problem is. In Randy's config, CONFIG_THERMAL_OF=3D=
y
>>> so both thermal_zone_of_sensor_unregister and
>>> thermal_zone_of_sensor_register are built-in. SENSORS_LM75=3Dy so the=

>>> calls to these functions are built-in too. I just can't see how this
>>> can be a problem at link time. Can anyone enlighten me?
>>
>> I believe the problem is more in the fact that THERMAL_OF is a bool, b=
ut
>> the way it is in thermal Kconfig, it will link to the thermal module, =
in
>> case CONFIG_THERMAL=3Dm.
>=20
> Doh. I've been looking at this for an hour and managed to miss
> that :( Thanks for explaining.
>=20
>> Thus I am proposing the following,
>> which limits the user to have THERMAL_OF only as builtin and whenever
>> is selected, it will select THERMAL too. That is:
>>
>>
>> From b643aa260ed4f3514d1ca51b1ecbe4be7652a8d0 Mon Sep 17 00:00:00 2001=

>> From: Eduardo Valentin <eduardo.valentin@ti.com>
>> Date: Tue, 7 Jan 2014 08:04:02 -0400
>> Subject: [PATCH 1/1] thermal: fix compilation issue on CONFIG_THERMAL_=
OF
>>  dependencies
>>
>> Users of API provided by THERMAL_OF config may suffer when
>> CONFIG_THERMAL=3Dy, causing linking issues, such as:
>>
>> drivers/built-in.o: In function `lm75_remove':
>> lm75.c:(.text+0x12bd8c): undefined reference to
>> `thermal_zone_of_sensor_unregister'
>> drivers/built-in.o: In function `lm75_probe':
>> lm75.c:(.text+0x12c123): undefined reference to
>> `thermal_zone_of_sensor_register'
>>
>> Therefore, this patch limits the compilation build to always
>> have THERMAL=3Dy, whenever THERMAL_OF=3Dy. In this way, whenever
>> the API user is built, if THERMAL_OF=3Dy, the build shall have
>> the full thermal support, otherwise, the thermal API will provide
>> stubs.
>>
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Cc: linux-pm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>  drivers/thermal/Kconfig | 29 ++++++++++++++++-------------
>>  1 file changed, 16 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>> index 58f98bd..dc315e9 100644
>> --- a/drivers/thermal/Kconfig
>> +++ b/drivers/thermal/Kconfig
>> @@ -29,19 +29,6 @@ config THERMAL_HWMON
>>  	  Say 'Y' here if you want all thermal sensors to
>>  	  have hwmon sysfs interface too.
>>
>> -config THERMAL_OF
>> -	bool
>> -	prompt "APIs to parse thermal data out of device tree"
>> -	depends on OF
>> -	default y
>> -	help
>> -	  This options provides helpers to add the support to
>> -	  read and parse thermal data definitions out of the
>> -	  device tree blob.
>> -
>> -	  Say 'Y' here if you need to build thermal infrastructure
>> -	  based on device tree.
>> -
>>  choice
>>  	prompt "Default Thermal governor"
>>  	default THERMAL_DEFAULT_GOV_STEP_WISE
>> @@ -235,3 +222,19 @@ source "drivers/thermal/samsung/Kconfig"
>>  endmenu
>>
>>  endif
>> +
>> +menuconfig THERMAL_OF
>> +	bool
>> +	prompt "APIs to parse thermal data out of device tree"
>> +	depends on OF
>> +	select THERMAL
>> +	default y
>> +	help
>> +	  This options enables DT thermal API which adds support to
>> +	  read and parse thermal data definitions out of the
>> +	  device tree blob. This option is mostly used by embedded
>> +	  thermal drivers.
>> +
>> +	  Say 'Y' here if you need to build thermal infrastructure
>> +	  based on device tree.
>> +
>=20
> I suppose this works, however I believe there is value in allowing for
> modular building of as much code as possible.
>=20
> I have an alternative proposal, which lets thermal be built as module,
> and hopefully also addresses the issue (I can't test...) The only
> drawback is that the same dependency must be added for every other
> hwmon driver which optionally uses THERMAL_OF.
>=20
> From: Jean Delvare <khali@linux-fr.org>
>=20
> Based on an earlier attempt by Randy Dunlap.
>=20
> Fix SENSORS_LM75 dependencies to eliminate build errors:
>=20
> drivers/built-in.o: In function `lm75_remove':
> lm75.c:(.text+0x12bd8c): undefined reference to `thermal_zone_of_sensor=
_unregister'
> drivers/built-in.o: In function `lm75_probe':
> lm75.c:(.text+0x12c123): undefined reference to `thermal_zone_of_sensor=
_register'
>=20
> Add depends on THERMAL since that is what provides the
> register/unregister functions above, but only if THERMAL_OF was
> selected as this is an optional feature of the driver.
>=20
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Eduardo Valentin <eduardo.valentin@ti.com>

I agree with this approach, as it can properly serve the purpose of
fixing this specific issue. The only drawback here is the fact that we
need to add this change to every possible user of this API. If you want
to push this fix via hwmon, you can add my
Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

and I request Rui to drop the patch I sent earlier.

Now, other issue is the fact that the thermal framework config entry
needs to be revisited, despite the link to this issue. As I mentioned in
other email thread, there are other system requirements that may prevent
proper usage of the thermal framework as a module. This is, I know,
another topic, and it shall be discussed in a different thread.

> ---
>  drivers/hwmon/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>=20
> --- linux-3.13-rc7.orig/drivers/hwmon/Kconfig	2014-01-07 09:01:24.81284=
8091 +0100
> +++ linux-3.13-rc7/drivers/hwmon/Kconfig	2014-01-07 15:19:11.039472329 =
+0100
> @@ -650,6 +650,7 @@ config SENSORS_LM73
>  config SENSORS_LM75
>  	tristate "National Semiconductor LM75 and compatibles"
>  	depends on I2C
> +	depends on THERMAL || !THERMAL_OF
>  	help
>  	  If you say yes here you get support for one common type of
>  	  temperature sensor chip, with models including:
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--m3Mo5vQbTd1BAO3H7ex0KSOLEI0DhJlb1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLMLFgACgkQCXcVR3XQvP3BiwEAypIWI1EdAWVLLMwN3mcV7LM5
OuIxvtLhSTc50vGxAocA/jsuWRBFCA1Tza5+Jg5ipFbkmpI5vlLa1btH0zxg6BJE
=G5v/
-----END PGP SIGNATURE-----

--m3Mo5vQbTd1BAO3H7ex0KSOLEI0DhJlb1--
