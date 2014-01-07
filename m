Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaAGM0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:26:12 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40869 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaAGM0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:26:10 -0500
Message-ID: <52CBF1CF.2000603@ti.com>
Date: Tue, 7 Jan 2014 08:23:43 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Guenter Roeck <linux@roeck-us.net>, Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Frodo Looijaard <frodol@dds.nl>,
        <lm-sensors@lm-sensors.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] hwmon/sensors: fix SENSORS_LM75 dependencies
References: <20140106204020.b47e53cc3ead8f90164ef5b7@canb.auug.org.au> <52CB0948.6030702@infradead.org> <20140106203209.GA21630@roeck-us.net> <52CB53DC.4030901@infradead.org> <52CB65DA.2010103@roeck-us.net> <20140107130401.23bffcd2@endymion.delvare>
In-Reply-To: <20140107130401.23bffcd2@endymion.delvare>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="HGSOnBcoscsGv9svVom5ixLpIiJ302ORT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HGSOnBcoscsGv9svVom5ixLpIiJ302ORT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07-01-2014 08:04, Jean Delvare wrote:
> Hi Guenter, Randy,
>=20
> On Mon, 06 Jan 2014 18:26:34 -0800, Guenter Roeck wrote:
>> On 01/06/2014 05:09 PM, Randy Dunlap wrote:
>>> From: Randy Dunlap <rdunlap@infradead.org>
>>>
>>> Fix SENSORS_LM75 dependencies to eliminate build errors:
>>>
>>> drivers/built-in.o: In function `lm75_remove':
>>> lm75.c:(.text+0x12bd8c): undefined reference to `thermal_zone_of_sens=
or_unregister'
>>> drivers/built-in.o: In function `lm75_probe':
>>> lm75.c:(.text+0x12c123): undefined reference to `thermal_zone_of_sens=
or_register'
>>>
>>> Add depends on THERMAL_OF since that is what provides the
>>> register/unregister functions above.
>>>
>>> Add depends on THERMAL since THERMAL is a tristate (while THERMAL_OF
>>> is a bool) and SENSORS_LM75 (tristate) needs to be limited to modular=

>>> builds when THERMAL=3Dm.
>>>
>>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>>> ---
>>>   drivers/hwmon/Kconfig |    2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> --- linux-next-20140106.orig/drivers/hwmon/Kconfig
>>> +++ linux-next-20140106/drivers/hwmon/Kconfig
>>> @@ -650,6 +650,8 @@ config SENSORS_LM73
>>>   config SENSORS_LM75
>>>   	tristate "National Semiconductor LM75 and compatibles"
>>>   	depends on I2C
>>> +	depends on THERMAL
>>> +	depends on THERMAL_OF
>>>   	help
>>>   	  If you say yes here you get support for one common type of
>>>   	  temperature sensor chip, with models including:
>>>
>>>
>> NACK. The driver does not and must not depend on THERMAL.
>=20
> Correct.
>=20
>> This needs to be addressed
>> in the thermal code, for example with dummy declarations if THERMAL=3D=
m but
>> SENSORS_LM75=3Dy. The functions are already declared as dummies if THE=
RMAL_OF=3Dn.
>=20
> This won't fly I'm afraid, the number of hwmon drivers affected will
> grow in the future and you certainly don't want to have to change the
> generic thermal code every time a new driver is added/converted.

Agreed

>=20
> I've looked at the problem this morning and I will admit I do not even
> understand what the problem is. In Randy's config, CONFIG_THERMAL_OF=3D=
y
> so both thermal_zone_of_sensor_unregister and
> thermal_zone_of_sensor_register are built-in. SENSORS_LM75=3Dy so the
> calls to these functions are built-in too. I just can't see how this
> can be a problem at link time. Can anyone enlighten me?
>=20


I believe the problem is more in the fact that THERMAL_OF is a bool, but
the way it is in thermal Kconfig, it will link to the thermal module, in
case CONFIG_THERMAL=3Dm. Thus I am proposing the following,
which limits the user to have THERMAL_OF only as builtin and whenever
is selected, it will select THERMAL too. That is:


=46rom b643aa260ed4f3514d1ca51b1ecbe4be7652a8d0 Mon Sep 17 00:00:00 2001
From: Eduardo Valentin <eduardo.valentin@ti.com>
Date: Tue, 7 Jan 2014 08:04:02 -0400
Subject: [PATCH 1/1] thermal: fix compilation issue on CONFIG_THERMAL_OF
 dependencies

Users of API provided by THERMAL_OF config may suffer when
CONFIG_THERMAL=3Dy, causing linking issues, such as:

drivers/built-in.o: In function `lm75_remove':
lm75.c:(.text+0x12bd8c): undefined reference to
`thermal_zone_of_sensor_unregister'
drivers/built-in.o: In function `lm75_probe':
lm75.c:(.text+0x12c123): undefined reference to
`thermal_zone_of_sensor_register'

Therefore, this patch limits the compilation build to always
have THERMAL=3Dy, whenever THERMAL_OF=3Dy. In this way, whenever
the API user is built, if THERMAL_OF=3Dy, the build shall have
the full thermal support, otherwise, the thermal API will provide
stubs.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/Kconfig | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 58f98bd..dc315e9 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -29,19 +29,6 @@ config THERMAL_HWMON
 	  Say 'Y' here if you want all thermal sensors to
 	  have hwmon sysfs interface too.

-config THERMAL_OF
-	bool
-	prompt "APIs to parse thermal data out of device tree"
-	depends on OF
-	default y
-	help
-	  This options provides helpers to add the support to
-	  read and parse thermal data definitions out of the
-	  device tree blob.
-
-	  Say 'Y' here if you need to build thermal infrastructure
-	  based on device tree.
-
 choice
 	prompt "Default Thermal governor"
 	default THERMAL_DEFAULT_GOV_STEP_WISE
@@ -235,3 +222,19 @@ source "drivers/thermal/samsung/Kconfig"
 endmenu

 endif
+
+menuconfig THERMAL_OF
+	bool
+	prompt "APIs to parse thermal data out of device tree"
+	depends on OF
+	select THERMAL
+	default y
+	help
+	  This options enables DT thermal API which adds support to
+	  read and parse thermal data definitions out of the
+	  device tree blob. This option is mostly used by embedded
+	  thermal drivers.
+
+	  Say 'Y' here if you need to build thermal infrastructure
+	  based on device tree.
+
--=20
1.8.2.1.342.gfa7285d

Randy, can you please confirm if this fix the issue for you?

--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--HGSOnBcoscsGv9svVom5ixLpIiJ302ORT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLL8c8ACgkQCXcVR3XQvP1C/AEA1DYSLiZwOHP7O+PP/aSvYFNm
IvvpDaTPyRwi+pibEnEBALG87unbSNEkd48jkJKtr+7YUbFh5JE8JwG67K4YKRtB
=Tw96
-----END PGP SIGNATURE-----

--HGSOnBcoscsGv9svVom5ixLpIiJ302ORT--
