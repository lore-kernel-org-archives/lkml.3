Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815Ab3GRNNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 09:13:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43674 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440Ab3GRNNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 09:13:23 -0400
Message-ID: <51E7E9A1.3040800@ti.com>
Date: Thu, 18 Jul 2013 09:12:01 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "l.stach@pengutronix.de" <l.stach@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [RESEND PATCH V1 8/9] hwmon: lm75: expose to thermal fw via DT
 nodes
References: <1374074248-31690-1-git-send-email-eduardo.valentin@ti.com> <1374074248-31690-9-git-send-email-eduardo.valentin@ti.com> <51E77E1D.3000306@nvidia.com>
In-Reply-To: <51E77E1D.3000306@nvidia.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2DFHTTHEQLJEJGTRXNTMD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2DFHTTHEQLJEJGTRXNTMD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Wei,


On 18-07-2013 01:33, Wei Ni wrote:
> On 07/17/2013 11:17 PM, Eduardo Valentin wrote:
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
>>  drivers/hwmon/lm75.c | 29 +++++++++++++++++++++++++++++
>>  1 file changed, 29 insertions(+)
>>
>> diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
>> index c03b490..0aa5e28 100644
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
>> +	return 0;
>> +}
>> +
>>  static ssize_t show_temp(struct device *dev, struct device_attribute =
*da,
>>  			 char *buf)
>>  {
>> @@ -271,11 +287,23 @@ lm75_probe(struct i2c_client *client, const stru=
ct i2c_device_id *id)
>>  		goto exit_remove;
>>  	}
>> =20
>> +	if (of_find_node_by_name(client->dev.of_node, "thermal_zone")) {
>> +		data->tz =3D thermal_zone_of_device_register(&client->dev,
>> +							   &client->dev,
>> +							   lm75_read_temp);
>=20
> Hi, Eduardo
> I have two questions:
> 1. As we know, after register to the thermal framework, it will have
> duplicate hwmon devices. I think lm-sensor maintainer would not like th=
is.

Yes I noticed. You have always the option to disable the
CONFIG_THERMAL_HWMON in your build.

> How about to add a flag to indicate it, which I talk about with
> Durgadoss in your [RFC 1/4]patch.

This would be very much appreciated, but I don't think this is a blocker
for this series. We can of course include this patch on it. Having a
flag to control this thermal fw to hwmon interface is actually a good ide=
a.

>=20
> 2. I'm also trying to use your codes on lm90. The LM90 serial has more
> then one sensors in one chip, local sensor, remote sensor and may have
> remote2 sensor, so it mean there may have more than one thermal_zone
> under the lm90 device node, will you consider it?
>=20

I haven't looked lm90 source code. How do you map it? Do you probe each
sensor or do you probe 1 device and expose 3 sensors?

In first case, you can still reuse what is in this series.

Later case, we need to change it slightly.

That is the case which is pretty similar on OMAP5 for instance, where
the device has three sensors. This patch series does not cover for this
case. But it can be simply modified to get around it.

We would need to allow more than one 'thermal_zone' nodes inside a
single device. But then we would need to have a way to determine which
sensor goes to which zone too.


> Thanks.
> Wei.
>=20
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
>> @@ -285,6 +313,7 @@ static int lm75_remove(struct i2c_client *client)
>>  {
>>  	struct lm75_data *data =3D i2c_get_clientdata(client);
>> =20
>> +	thermal_zone_device_unregister(data->tz);
>>  	hwmon_device_unregister(data->hwmon_dev);
>>  	sysfs_remove_group(&client->dev.kobj, &lm75_group);
>>  	lm75_write_value(client, LM75_REG_CONF, data->orig_conf);
>>
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2DFHTTHEQLJEJGTRXNTMD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHn6aEACgkQCXcVR3XQvP34vgD/ZaXLOFeuPnkvWOHocjD5pBLg
bv7H5yc/3v+Vze7m+dUBAK4iLtiL0/kSUZFPk+lTAU5nGYuiJ84sV6RhCITFb/HY
=IsJL
-----END PGP SIGNATURE-----

------enig2DFHTTHEQLJEJGTRXNTMD--
