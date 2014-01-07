Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaAGO5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:57:25 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45979 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbaAGO5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:57:06 -0500
Message-ID: <52CC158C.8010801@ti.com>
Date: Tue, 7 Jan 2014 10:56:12 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <rui.zhang@intel.com>,
        <rdunlap@infradead.org>, Jean Delvare <khali@linux-fr.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] thermal: fix compilation issue on CONFIG_THERMAL_OF
 dependencies
References: <52CBF1CF.2000603@ti.com> <1389098667-9826-1-git-send-email-eduardo.valentin@ti.com> <52CC104A.6010805@roeck-us.net>
In-Reply-To: <52CC104A.6010805@roeck-us.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="GAIDSdhPJLbUrCeroHBIumENnVsHFS661"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GAIDSdhPJLbUrCeroHBIumENnVsHFS661
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07-01-2014 10:33, Guenter Roeck wrote:
> On 01/07/2014 04:44 AM, Eduardo Valentin wrote:
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
>> Cc: Jean Delvare <khali@linux-fr.org>
>> Cc: Guenter Roeck <linux@roeck-us.net>
>> Cc: linux-pm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Reported-by: Randy Dunlap <rdunlap@infradead.org>
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>   drivers/thermal/Kconfig | 29 ++++++++++++++++-------------
>>   1 file changed, 16 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>> index 58f98bd..dc315e9 100644
>> --- a/drivers/thermal/Kconfig
>> +++ b/drivers/thermal/Kconfig
>> @@ -29,19 +29,6 @@ config THERMAL_HWMON
>>         Say 'Y' here if you want all thermal sensors to
>>         have hwmon sysfs interface too.
>>
>> -config THERMAL_OF
>> -    bool
>> -    prompt "APIs to parse thermal data out of device tree"
>> -    depends on OF
>> -    default y
>> -    help
>> -      This options provides helpers to add the support to
>> -      read and parse thermal data definitions out of the
>> -      device tree blob.
>> -
>> -      Say 'Y' here if you need to build thermal infrastructure
>> -      based on device tree.
>> -
>>   choice
>>       prompt "Default Thermal governor"
>>       default THERMAL_DEFAULT_GOV_STEP_WISE
>> @@ -235,3 +222,19 @@ source "drivers/thermal/samsung/Kconfig"
>>   endmenu
>>
>>   endif
>> +
>> +menuconfig THERMAL_OF
>> +    bool
>> +    prompt "APIs to parse thermal data out of device tree"
>> +    depends on OF
>> +    select THERMAL
>> +    default y
>> +    help
>> +      This options enables DT thermal API which adds support to
>> +      read and parse thermal data definitions out of the
>> +      device tree blob. This option is mostly used by embedded
>> +      thermal drivers.
>> +
>> +      Say 'Y' here if you need to build thermal infrastructure
>> +      based on device tree.
>> +
>>
>=20
> Alternative would be something like
>=20
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index f7e11c7..156bb4d 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -244,7 +244,7 @@ struct thermal_genl_event {
>  };
>=20
>  /* Function declarations */
> -#ifdef CONFIG_THERMAL_OF
> +#if defined(CONFIG_THERMAL_OF) && (defined(CONFIG_THERMAL) ||
> (defined(MODULE) && defined(CONFIG_THERMAL_MODULE)))

I think this is a weak fix, as it would mean that we would providing
stubs if thermal is compiled as module.

>  struct thermal_zone_device *
>  thermal_zone_of_sensor_register(struct device *dev, int id,
>                                 void *data, int (*get_temp)(void *, lon=
g
> *),
>=20
> but your patch should work as well (or even better as it won't cause
> confusion).
>=20
> Guenter
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--GAIDSdhPJLbUrCeroHBIumENnVsHFS661
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLMFYwACgkQCXcVR3XQvP3ACgEAuF2ml2AqiuUOzLqqZcNmbt0k
SCQbUoPQLKeOYgFaFBQA/ROFkSIUEvG8lQd23LBQrzWKW29c1CUwM+bPQLvUUU1X
=3IBt
-----END PGP SIGNATURE-----

--GAIDSdhPJLbUrCeroHBIumENnVsHFS661--
