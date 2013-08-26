Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab3HZMRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:17:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38321 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab3HZMRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:17:09 -0400
Message-ID: <521B46F4.7080507@ti.com>
Date: Mon, 26 Aug 2013 08:15:48 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <swarren@wwwdotorg.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <rui.zhang@intel.com>, <wni@nvidia.com>,
        <durgadoss.r@intel.com>, <linux-pm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [RFC PATCH 03/14] hwmon: lm75: expose to thermal fw via DT nodes
References: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com> <1377299755-5134-4-git-send-email-eduardo.valentin@ti.com> <20130823235049.GB14810@roeck-us.net>
In-Reply-To: <20130823235049.GB14810@roeck-us.net>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="hHcUpEbjGd9gJcRXvHj1dmn4V3UXS2TEE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hHcUpEbjGd9gJcRXvHj1dmn4V3UXS2TEE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 23-08-2013 19:50, Guenter Roeck wrote:
> On Fri, Aug 23, 2013 at 07:15:44PM -0400, Eduardo Valentin wrote:
>> This patch adds to lm75 temperature sensor the possibility
>> to expose itself as thermal zone device, registered on the
>> thermal framework.
>>
>> The thermal zone is built only if a device tree node
>> describing a thermal zone for this sensor is present
>> inside the lm75 DT node. Otherwise, the driver behavior
>> will be the same.
>>
>> Cc: Jean Delvare <khali@linux-fr.org>
>> Cc: Guenter Roeck <linux@roeck-us.net>
>> Cc: lm-sensors@lm-sensors.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>  drivers/hwmon/lm75.c | 31 +++++++++++++++++++++++++++++++
>>  1 file changed, 31 insertions(+)
>>
>> diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
>> index c03b490..dc55908 100644
>> --- a/drivers/hwmon/lm75.c
>> +++ b/drivers/hwmon/lm75.c
>> @@ -27,6 +27,8 @@
>>  #include <linux/hwmon-sysfs.h>
>>  #include <linux/err.h>
>>  #include <linux/mutex.h>
>> +#include <linux/thermal.h>
>> +#include <linux/of.h>
>>  #include "lm75.h"
>> =20
>> =20
>> @@ -70,6 +72,7 @@ static const u8 LM75_REG_TEMP[3] =3D {
>>  /* Each client has this additional data */
>>  struct lm75_data {
>>  	struct device		*hwmon_dev;
>> +	struct thermal_zone_device	*tz;
>>  	struct mutex		update_lock;
>>  	u8			orig_conf;
>>  	u8			resolution;	/* In bits, between 9 and 12 */
>> @@ -92,6 +95,19 @@ static struct lm75_data *lm75_update_device(struct =
device *dev);
>> =20
>>  /* sysfs attributes for hwmon */
>> =20
>> +static int lm75_read_temp(void *dev, unsigned long *temp)
>> +{
>> +	struct lm75_data *data =3D lm75_update_device(dev);
>> +
>> +	if (IS_ERR(data))
>> +		return PTR_ERR(data);
>> +
>> +	*temp =3D ((data->temp[0] >> (16 - data->resolution)) * 1000) >>
>> +			(data->resolution - 8);
>> +
> The reported temperature can be negative, which would result in reporti=
ng a very
> high temperature (note this applies to the tmp102 driver patch as well)=
=2E
>=20

Good point.

> The computation is quite complex and matches the computation done in sh=
ow_temp().
> Given that, it would make sense to declare an inline function to conver=
t the
> register value to the temperature. This function can take the register =
value
> and the resolution as argument.

Sounds reasonable. Modifying accordingly in next version.

>=20
> Guenter
>=20
>> +	return 0;
>> +}
>> +
>>  static ssize_t show_temp(struct device *dev, struct device_attribute =
*da,
>>  			 char *buf)
>>  {
>> @@ -271,11 +287,25 @@ lm75_probe(struct i2c_client *client, const stru=
ct i2c_device_id *id)
>>  		goto exit_remove;
>>  	}
>> =20
>> +	if (of_find_property(client->dev.of_node, "monitored-zones", NULL)) =
{
>> +		data->tz =3D thermal_zone_of_device_register(&client->dev,
>> +							   0,
>> +							   false, /* -hwmon */
>> +							   &client->dev,
>> +							   lm75_read_temp);
>> +		if (IS_ERR(data->tz)) {
>> +			status =3D PTR_ERR(data->tz);
>> +			goto exit_hwmon;
>> +		}
>> +	}
>> +
>>  	dev_info(&client->dev, "%s: sensor '%s'\n",
>>  		 dev_name(data->hwmon_dev), client->name);
>> =20
>>  	return 0;
>> =20
>> +exit_hwmon:
>> +	hwmon_device_unregister(data->hwmon_dev);
>>  exit_remove:
>>  	sysfs_remove_group(&client->dev.kobj, &lm75_group);
>>  	return status;
>> @@ -285,6 +315,7 @@ static int lm75_remove(struct i2c_client *client)
>>  {
>>  	struct lm75_data *data =3D i2c_get_clientdata(client);
>> =20
>> +	thermal_zone_device_unregister(data->tz);
>>  	hwmon_device_unregister(data->hwmon_dev);
>>  	sysfs_remove_group(&client->dev.kobj, &lm75_group);
>>  	lm75_write_value(client, LM75_REG_CONF, data->orig_conf);
>> --=20
>> 1.8.2.1.342.gfa7285d
>>
>>
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--hHcUpEbjGd9gJcRXvHj1dmn4V3UXS2TEE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlIbRvQACgkQCXcVR3XQvP2uNwD+PyexTyWQze8fjI1aByceQ2ex
7LRBNuAXvuG86GkP6RoA/0xTQ6J/pCNxnYjTe9vHNmclH8wbXxxC6qJLEyMeCKOb
=U8XP
-----END PGP SIGNATURE-----

--hHcUpEbjGd9gJcRXvHj1dmn4V3UXS2TEE--
