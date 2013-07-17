Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab3GQOwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:52:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32899 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab3GQOwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:52:07 -0400
Message-ID: <51E6AF8B.9020301@ti.com>
Date: Wed, 17 Jul 2013 10:51:55 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "R, Durgadoss" <durgadoss.r@intel.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "amit.daniel@samsung.com" <amit.daniel@samsung.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/4] thermal: introduce device tree parser
References: <1373378414-28086-1-git-send-email-eduardo.valentin@ti.com> <1373378414-28086-3-git-send-email-eduardo.valentin@ti.com> <4D68720C2E767A4AA6A8796D42C8EB59CDBC68@BGSMSX101.gar.corp.intel.com>
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB59CDBC68@BGSMSX101.gar.corp.intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2CHMSRVAQAWOTXVHNNEQS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2CHMSRVAQAWOTXVHNNEQS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09-07-2013 12:14, R, Durgadoss wrote:
> Hi Eduardo,
>=20
>> -----Original Message-----
>> From: Eduardo Valentin [mailto:eduardo.valentin@ti.com]
>> Sent: Tuesday, July 09, 2013 7:30 PM
>> To: linux-pm@vger.kernel.org; R, Durgadoss; amit.daniel@samsung.com
>> Cc: Zhang, Rui; Eduardo Valentin; linux-kernel@vger.kernel.org
>> Subject: [RFC PATCH 2/4] thermal: introduce device tree parser
>>
>> In order to be able to build thermal policies
>> based on generic sensors, like I2C device, that
>> can be places in different points on different boards,
>> there is a need to have a way to feed board dependent
>> data into the thermal framework.
>>
>> This patch introduces a thermal data parser for device
>> tree. The parsed data is used to build thermal zones
>> and thermal binding parameters. The output data
>> can then be used to deploy thermal policies.
>>
>> This patch adds also documentation regarding this
>> API and how to define define tree nodes to use
>> this infrastructure.
>>
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Cc: linux-pm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>=20
> I looked at the Documentation part of this. And it looks good.
>=20
> At some places you are using ERANGE. Technically, this represents
> 'Math result not representable'. May be should be use EINVAL=20
> itself ? I would leave it up to you ;)

I will be using EDOM in next version, tks

>=20
> Thanks,
> Durga
>=20
>>  .../devicetree/bindings/thermal/thermal.txt        |  92 +++++
>>  drivers/thermal/Kconfig                            |  13 +
>>  drivers/thermal/Makefile                           |   1 +
>>  drivers/thermal/thermal_dt.c                       | 412 ++++++++++++=
+++++++++
>>  drivers/thermal/thermal_dt.h                       |  44 +++
>>  include/linux/thermal.h                            |   3 +
>>  6 files changed, 565 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/thermal/thermal.=
txt
>>  create mode 100644 drivers/thermal/thermal_dt.c
>>  create mode 100644 drivers/thermal/thermal_dt.h
>>
>> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt
>> b/Documentation/devicetree/bindings/thermal/thermal.txt
>> new file mode 100644
>> index 0000000..2c25ab2
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
>> @@ -0,0 +1,92 @@
>> +----------------------------------------
>> +Thermal Framework Device Tree descriptor
>> +----------------------------------------
>> +
>> +This file describes how to define a thermal structure using device tr=
ee.
>> +A thermal structure includes thermal zones and their components, such=

>> +as name, governor, trip points, polling intervals and cooling devices=

>> +binding descriptors. A binding descriptor may contain information on
>> +how to react, with a cooling stepped action or a weight on a fair sha=
re.
>> +
>> +****
>> +trip
>> +****
>> +
>> +The trip node is a node to describe a point in the temperature domain=

>> +in which the system takes an action. This node describes just the poi=
nt,
>> +not the action.
>> +
>> +A node describing a trip must contain:
>> +- temperature: the trip temperature level, in milliCelsius.
>> +- hysteresis: a (low) hysteresis value on 'temperature'. This is a re=
lative
>> +value, in milliCelsius.
>> +- type: the trip type. Here is the type mapping:
>> +	THERMAL_TRIP_ACTIVE =3D 0
>> +	THERMAL_TRIP_PASSIVE =3D 1
>> +	THERMAL_TRIP_HOT =3D 2
>> +	THERMAL_TRIP_CRITICAL =3D 3
>> +
>> +**********
>> +bind_param
>> +**********
>> +
>> +The bind_param node is a node to describe how cooling devices get ass=
igned
>> +to trip points of the zone. The cooling devices are expected to be lo=
aded
>> +in the target system.
>> +
>> +A node describing a bind_param must contain:
>> +- cooling_device: A string with the cooling device name.
>> +- weight: The 'influence' of a particular cooling device on this zone=
=2E
>> +             This is on a percentage scale. The sum of all these weig=
hts
>> +             (for a particular zone) cannot exceed 100.
>> +- trip_mask: This is a bit mask that gives the binding relation betwe=
en
>> +               this thermal zone and cdev, for a particular trip poin=
t.
>> +               If nth bit is set, then the cdev and thermal zone are =
bound
>> +               for trip point n.
>> +
>> +************
>> +thermal_zone
>> +************
>> +
>> +The thermal_zone node is the node containing all the required info
>> +for describing a thermal zone, including its cdev bindings. The therm=
al_zone
>> +node must contain, apart from its own properties, one node containing=

>> +trip nodes and one node containing all the zone bind parameters.
>> +
>> +Required properties:
>> +- type: this is a string containing the zone type. Say 'cpu', 'core',=
 'mem', etc.
>> +- mask: Bit string: If 'n'th bit is set, then trip point 'n' is write=
able.
>> +
>> +- passive_delay: number of milliseconds to wait between polls when
>> +	performing passive cooling.
>> +- polling_delay: number of milliseconds to wait between polls when ch=
ecking
>> +
>> +- governor: A string containing the default governor for this zone.
>> +
>> +Below is an example:
>> +thermal_zone {
>> +            type =3D "CPU";
>> +            mask =3D <0x03>; /* trips writability */
>> +            passive_delay =3D <250>; /* milliseconds */
>> +            polling_delay =3D <1000>; /* milliseconds */
>> +            governor =3D "step_wise";
>> +            trips {
>> +                    alert@100000{
>> +                            temperature =3D <100000>; /* milliCelsius=
 */
>> +                            hysteresis =3D <0>; /* milliCelsius */
>> +                            type =3D <1>;
>> +                    };
>> +                    crit@125000{
>> +                            temperature =3D <125000>; /* milliCelsius=
 */
>> +                            hysteresis =3D <0>; /* milliCelsius */
>> +                            type =3D <3>;
>> +                    };
>> +            };
>> +            bind_params {
>> +                    action@0{
>> +                            cooling_device =3D "thermal-cpufreq";
>> +                            weight =3D <100>; /* percentage */
>> +                            mask =3D <0x01>;
>> +                    };
>> +            };
>> +};
>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>> index 7fb16bc..753f0dc 100644
>> --- a/drivers/thermal/Kconfig
>> +++ b/drivers/thermal/Kconfig
>> @@ -29,6 +29,19 @@ config THERMAL_HWMON
>>  	  Say 'Y' here if you want all thermal sensors to
>>  	  have hwmon sysfs interface too.
>>
>> +config THERMAL_OF
>> +	bool
>> +	prompt "APIs to parse thermal data out of device tree"
>> +	depends on OF
>> +	default y
>> +	help
>> +	  This options provides helpers to add the support to
>> +	  read and parse thermal data definitions out of the
>> +	  device tree blob.
>> +
>> +	  Say 'Y' here if you need to build thermal infrastructure
>> +	  based on device tree.
>> +
>>  choice
>>  	prompt "Default Thermal governor"
>>  	default THERMAL_DEFAULT_GOV_STEP_WISE
>> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
>> index 24cb894..eedb273 100644
>> --- a/drivers/thermal/Makefile
>> +++ b/drivers/thermal/Makefile
>> @@ -7,6 +7,7 @@ thermal_sys-y			+=3D thermal_core.o
>>
>>  # interface to/from other layers providing sensors
>>  thermal_sys-$(CONFIG_THERMAL_HWMON)		+=3D thermal_hwmon.o
>> +thermal_sys-$(CONFIG_THERMAL_OF)		+=3D thermal_dt.o
>>
>>  # governors
>>  thermal_sys-$(CONFIG_THERMAL_GOV_FAIR_SHARE)	+=3D fair_share.o
>> diff --git a/drivers/thermal/thermal_dt.c b/drivers/thermal/thermal_dt=
=2Ec
>> new file mode 100644
>> index 0000000..6553582
>> --- /dev/null
>> +++ b/drivers/thermal/thermal_dt.c
>> @@ -0,0 +1,412 @@
>> +/*
>> + *  thermal_dt.c - Generic Thermal Management device tree support.
>> + *
>> + *  Copyright (C) 2013 Texas Instruments
>> + *  Copyright (C) 2013 Eduardo Valentin <eduardo.valentin@ti.com>
>> + *
>> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> ~~~~~~~~~~~~
>> + *
>> + *  This program is free software; you can redistribute it and/or mod=
ify
>> + *  it under the terms of the GNU General Public License as published=
 by
>> + *  the Free Software Foundation; version 2 of the License.
>> + *
>> + *  This program is distributed in the hope that it will be useful, b=
ut
>> + *  WITHOUT ANY WARRANTY; without even the implied warranty of
>> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU=

>> + *  General Public License for more details.
>> + *
>> + *  You should have received a copy of the GNU General Public License=
 along
>> + *  with this program; if not, write to the Free Software Foundation,=
 Inc.,
>> + *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
>> + *
>> + *
>> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> ~~~~~~~~~~~~
>> + */
>> +#include <linux/thermal.h>
>> +#include <linux/slab.h>
>> +#include <linux/of_device.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/err.h>
>> +#include <linux/export.h>
>> +#include <linux/string.h>
>> +
>> +struct __thermal_bind_params {
>> +	char cooling_device[THERMAL_NAME_LENGTH];
>> +};
>> +
>> +static
>> +int thermal_of_match(struct thermal_zone_device *tz,
>> +		     struct thermal_cooling_device *cdev);
>> +
>> +static int thermal_of_populate_bind_params(struct device *dev,
>> +					   struct device_node *node,
>> +					   struct __thermal_bind_params *__tbp,
>> +					   struct thermal_bind_params *tbp)
>> +{
>> +	const char *cdev_name;
>> +	int ret;
>> +	u32 prop;
>> +
>> +	ret =3D of_property_read_u32(node, "weight", &prop);
>> +	if (ret < 0) {
>> +		dev_err(dev, "missing weight property\n");
>> +		return ret;
>> +	}
>> +	tbp->weight =3D prop;
>> +
>> +	ret =3D of_property_read_u32(node, "mask", &prop);
>> +	if (ret < 0) {
>> +		dev_err(dev, "missing mask property\n");
>> +		return ret;
>> +	}
>> +	tbp->trip_mask =3D prop;
>> +
>> +	/* this will allow us to bind with cooling devices */
>> +	tbp->match =3D thermal_of_match;
>> +
>> +	ret =3D of_property_read_string(node, "cooling_device", &cdev_name);=

>> +	if (ret < 0) {
>> +		dev_err(dev, "missing cooling_device property\n");
>> +		return ret;
>> +	}
>> +	strncpy(__tbp->cooling_device, cdev_name,
>> +		sizeof(__tbp->cooling_device));
>> +
>> +	return 0;
>> +}
>> +
>> +struct __thermal_trip {
>> +	unsigned long int temperature;
>> +	unsigned long int hysteresis;
>> +	enum thermal_trip_type type;
>> +};
>> +
>> +static
>> +int thermal_of_populate_trip(struct device *dev,
>> +			     struct device_node *node,
>> +			     struct __thermal_trip *trip)
>> +{
>> +	int ret;
>> +	int prop;
>> +
>> +	ret =3D of_property_read_u32(node, "temperature", &prop);
>> +	if (ret < 0) {
>> +		dev_err(dev, "missing temperature property\n");
>> +		return ret;
>> +	}
>> +	trip->temperature =3D prop;
>> +
>> +	ret =3D of_property_read_u32(node, "hysteresis", &prop);
>> +	if (ret < 0) {
>> +		dev_err(dev, "missing hysteresis property\n");
>> +		return ret;
>> +	}
>> +	trip->hysteresis =3D prop;
>> +
>> +	ret =3D of_property_read_u32(node, "type", &prop);
>> +	if (ret < 0) {
>> +		dev_err(dev, "missing type property\n");
>> +		return ret;
>> +	}
>> +	trip->type =3D prop;
>> +
>> +	return 0;
>> +}
>> +
>> +struct __thermal_zone_device {
>> +	enum thermal_device_mode mode;
>> +	int passive_delay;
>> +	int polling_delay;
>> +	int mask;
>> +	int ntrips;
>> +	char type[THERMAL_NAME_LENGTH];
>> +	struct __thermal_trip *trips;
>> +	struct __thermal_bind_params *bind_params;
>> +	struct thermal_bind_params *tbps;
>> +	struct thermal_zone_params zone_params;
>> +	int (*get_temp)(void *, unsigned long *);
>> +	void *devdata;
>> +};
>> +
>> +static
>> +struct __thermal_zone_device *thermal_of_build_thermal_zone(struct de=
vice
>> *dev)
>> +{
>> +	struct device_node *child, *gchild, *node;
>> +	struct __thermal_zone_device *tz;
>> +	const char *name;
>> +	int ret, i;
>> +	u32 prop;
>> +
>> +	node =3D dev->of_node;
>> +	if (!node)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	node =3D of_find_node_by_name(node, "thermal_zone");
>> +	if (!node) {
>> +		dev_err(dev, "no thermal_zone node found\n");
>> +		return ERR_PTR(-EINVAL);
>> +	}
>> +
>> +	tz =3D devm_kzalloc(dev, sizeof(*tz), GFP_KERNEL);
>> +	if (!tz) {
>> +		dev_err(dev, "not enough memory for thermal of zone\n");
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +
>> +	ret =3D of_property_read_u32(node, "passive_delay", &prop);
>> +	if (ret < 0) {
>> +		dev_err(dev, "missing passive_delay property\n");
>> +		return ERR_PTR(ret);
>> +	}
>> +	tz->passive_delay =3D prop;
>> +
>> +	ret =3D of_property_read_u32(node, "polling_delay", &prop);
>> +	if (ret < 0) {
>> +		dev_err(dev, "missing polling_delay property\n");
>> +		return ERR_PTR(ret);
>> +	}
>> +	tz->polling_delay =3D prop;
>> +
>> +	ret =3D of_property_read_u32(node, "mask", &prop);
>> +	if (ret < 0) {
>> +		dev_err(dev, "missing mask property\n");
>> +		return ERR_PTR(ret);
>> +	}
>> +	tz->mask =3D prop;
>> +
>> +	ret =3D of_property_read_string(node, "type", &name);
>> +	if (ret < 0) {
>> +		dev_err(dev, "missing type property\n");
>> +		return ERR_PTR(ret);
>> +	}
>> +	strncpy(tz->type, name, sizeof(tz->type));
>> +
>> +	ret =3D of_property_read_string(node, "governor", &name);
>> +	if (ret < 0) {
>> +		dev_err(dev, "missing governor property\n");
>> +		return ERR_PTR(ret);
>> +	}
>> +	strncpy(tz->zone_params.governor_name, name,
>> +		sizeof(tz->zone_params.governor_name));
>> +
>> +	/* trips */
>> +	child =3D of_find_node_by_name(node, "trips");
>> +	tz->ntrips =3D of_get_child_count(child);
>> +	tz->trips =3D devm_kzalloc(dev, tz->ntrips * sizeof(*tz->trips),
>> +				 GFP_KERNEL);
>> +	if (!tz->trips)
>> +		return ERR_PTR(-ENOMEM);
>> +	i =3D 0;
>> +	for_each_child_of_node(child, gchild)
>> +		thermal_of_populate_trip(dev, gchild, &tz->trips[i++]);
>> +
>> +	/* bind_params */
>> +	child =3D of_find_node_by_name(node, "bind_params");
>> +	tz->zone_params.num_tbps =3D of_get_child_count(child);
>> +	tz->bind_params =3D devm_kzalloc(dev,
>> +				       tz->zone_params.num_tbps *
>> +						sizeof(*tz->bind_params),
>> +				       GFP_KERNEL);
>> +	if (!tz->bind_params)
>> +		return ERR_PTR(-ENOMEM);
>> +	tz->zone_params.tbp =3D devm_kzalloc(dev,
>> +					   tz->zone_params.num_tbps *
>> +						sizeof(*tz->zone_params.tbp),
>> +					   GFP_KERNEL);
>> +	if (!tz->zone_params.tbp)
>> +		return ERR_PTR(-ENOMEM);
>> +	i =3D 0;
>> +	for_each_child_of_node(child, gchild) {
>> +		thermal_of_populate_bind_params(dev, gchild,
>> +						&tz->bind_params[i],
>> +						&tz->zone_params.tbp[i]);
>> +		i++;
>> +	}
>> +	tz->mode =3D THERMAL_DEVICE_ENABLED;
>> +
>> +	return tz;
>> +}
>> +
>> +static
>> +int thermal_of_match(struct thermal_zone_device *tz,
>> +		     struct thermal_cooling_device *cdev)
>> +{
>> +	struct __thermal_zone_device *data =3D tz->devdata;
>> +	int i;
>> +
>> +	for (i =3D 0; i < data->zone_params.num_tbps; i++) {
>> +		if (!strncmp(data->bind_params[i].cooling_device,
>> +			     cdev->type,
>> +			     strlen(data->bind_params[i].cooling_device)) &&
>> +		    (data->zone_params.tbp[i].trip_mask & (1 << i)))
>> +			return 0;
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static
>> +int of_thermal_get_temp(struct thermal_zone_device *tz,
>> +			unsigned long *temp)
>> +{
>> +	struct __thermal_zone_device *data =3D tz->devdata;
>> +
>> +	return data->get_temp(data->devdata, temp);
>> +}
>> +
>> +static
>> +int of_thermal_get_mode(struct thermal_zone_device *tz,
>> +			enum thermal_device_mode *mode)
>> +{
>> +	struct __thermal_zone_device *data =3D tz->devdata;
>> +
>> +	*mode =3D data->mode;
>> +
>> +	return 0;
>> +}
>> +
>> +static
>> +int of_thermal_set_mode(struct thermal_zone_device *tz,
>> +			enum thermal_device_mode mode)
>> +{
>> +	struct __thermal_zone_device *data =3D tz->devdata;
>> +
>> +	mutex_lock(&tz->lock);
>> +
>> +	if (mode =3D=3D THERMAL_DEVICE_ENABLED)
>> +		tz->polling_delay =3D data->polling_delay;
>> +	else
>> +		tz->polling_delay =3D 0;
>> +
>> +	mutex_unlock(&tz->lock);
>> +
>> +	data->mode =3D mode;
>> +	thermal_zone_device_update(tz);
>> +
>> +	return 0;
>> +}
>> +
>> +static
>> +int of_thermal_get_trip_type(struct thermal_zone_device *tz, int trip=
,
>> +			     enum thermal_trip_type *type)
>> +{
>> +	struct __thermal_zone_device *data =3D tz->devdata;
>> +
>> +	if (trip >=3D data->ntrips || trip < 0)
>> +		return -ERANGE;
>> +
>> +	*type =3D data->trips[trip].type;
>> +
>> +	return 0;
>> +}
>> +
>> +static
>> +int of_thermal_get_trip_temp(struct thermal_zone_device *tz, int trip=
,
>> +			     unsigned long *temp)
>> +{
>> +	struct __thermal_zone_device *data =3D tz->devdata;
>> +
>> +	if (trip >=3D data->ntrips || trip < 0)
>> +		return -ERANGE;
>> +
>> +	*temp =3D data->trips[trip].temperature;
>> +
>> +	return 0;
>> +}
>> +
>> +static
>> +int of_thermal_set_trip_temp(struct thermal_zone_device *tz, int trip=
,
>> +			     unsigned long temp)
>> +{
>> +	struct __thermal_zone_device *data =3D tz->devdata;
>> +
>> +	if (trip >=3D data->ntrips || trip < 0)
>> +		return -ERANGE;
>> +
>> +	/* thermal fw should take care of data->mask & (1 << trip) */
>> +	data->trips[trip].temperature =3D temp;
>> +
>> +	return 0;
>> +}
>> +
>> +static
>> +int of_thermal_get_trip_hyst(struct thermal_zone_device *tz, int trip=
,
>> +			     unsigned long *hyst)
>> +{
>> +	struct __thermal_zone_device *data =3D tz->devdata;
>> +
>> +	if (trip >=3D data->ntrips || trip < 0)
>> +		return -ERANGE;
>> +
>> +	*hyst =3D data->trips[trip].hysteresis;
>> +
>> +	return 0;
>> +}
>> +
>> +static
>> +int of_thermal_set_trip_hyst(struct thermal_zone_device *tz, int trip=
,
>> +			     unsigned long hyst)
>> +{
>> +	struct __thermal_zone_device *data =3D tz->devdata;
>> +
>> +	if (trip >=3D data->ntrips || trip < 0)
>> +		return -ERANGE;
>> +
>> +	/* thermal fw should take care of data->mask & (1 << trip) */
>> +	data->trips[trip].hysteresis =3D hyst;
>> +
>> +	return 0;
>> +}
>> +
>> +static int
>> +of_thermal_get_crit_temp(struct thermal_zone_device *tz, unsigned lon=
g
>> *temp)
>> +{
>> +	struct __thermal_zone_device *data =3D tz->devdata;
>> +	int i;
>> +
>> +	for (i =3D 0; i < data->ntrips; i++)
>> +		if (data->trips[i].type =3D=3D THERMAL_TRIP_CRITICAL) {
>> +			*temp =3D data->trips[i].temperature;
>> +			return 0;
>> +		}
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static const
>> +struct thermal_zone_device_ops of_thermal_ops =3D {
>> +	.get_temp =3D of_thermal_get_temp,
>> +	.get_mode =3D of_thermal_get_mode,
>> +	.set_mode =3D of_thermal_set_mode,
>> +	.get_trip_type =3D of_thermal_get_trip_type,
>> +	.get_trip_temp =3D of_thermal_get_trip_temp,
>> +	.set_trip_temp =3D of_thermal_set_trip_temp,
>> +	.get_trip_hyst =3D of_thermal_get_trip_hyst,
>> +	.set_trip_hyst =3D of_thermal_set_trip_hyst,
>> +	.get_crit_temp =3D of_thermal_get_crit_temp,
>> +};
>> +
>> +struct thermal_zone_device *thermal_zone_of_device_register(struct de=
vice
>> *dev,
>> +		void *data, int (*get_temp)(void *, unsigned long *))
>> +{
>> +	struct __thermal_zone_device *tz;
>> +	struct thermal_zone_device_ops *ops;
>> +
>> +	tz =3D thermal_of_build_thermal_zone(dev);
>> +	if (IS_ERR(tz)) {
>> +		dev_err(dev, "failed to build thermal zone\n");
>> +		return NULL;
>> +	}
>> +	ops =3D devm_kzalloc(dev, sizeof(*ops), GFP_KERNEL);
>> +	if (!ops) {
>> +		dev_err(dev, "no memory available for thermal ops\n");
>> +		return NULL;
>> +	}
>> +	memcpy(ops, &of_thermal_ops, sizeof(*ops));
>> +	tz->get_temp =3D get_temp;
>> +	tz->devdata =3D data;
>> +
>> +	return thermal_zone_device_register(tz->type, tz->ntrips, tz->mask, =
tz,
>> +					    ops, &tz->zone_params,
>> +					    tz->passive_delay,
>> +					    tz->polling_delay);
>> +}
>> +EXPORT_SYMBOL_GPL(thermal_zone_of_device_register);
>> diff --git a/drivers/thermal/thermal_dt.h b/drivers/thermal/thermal_dt=
=2Eh
>> new file mode 100644
>> index 0000000..5491d19
>> --- /dev/null
>> +++ b/drivers/thermal/thermal_dt.h
>> @@ -0,0 +1,44 @@
>> +/*
>> + *  thermal_dt.h - Generic Thermal Management device tree support.
>> + *
>> + *  Copyright (C) 2013 Texas Instruments
>> + *  Copyright (C) 2013 Eduardo Valentin <eduardo.valentin@ti.com>
>> + *
>> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> ~~~~~~~~~~~~
>> + *
>> + *  This program is free software; you can redistribute it and/or mod=
ify
>> + *  it under the terms of the GNU General Public License as published=
 by
>> + *  the Free Software Foundation; version 2 of the License.
>> + *
>> + *  This program is distributed in the hope that it will be useful, b=
ut
>> + *  WITHOUT ANY WARRANTY; without even the implied warranty of
>> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU=

>> + *  General Public License for more details.
>> + *
>> + *  You should have received a copy of the GNU General Public License=
 along
>> + *  with this program; if not, write to the Free Software Foundation,=
 Inc.,
>> + *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
>> + *
>> + *
>> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> ~~~~~~~~~~~~
>> + */
>> +#ifndef __THERMAL_DT_H__
>> +#define __THERMAL_DT_H__
>> +#include <linux/device.h>
>> +
>> +#ifdef CONFIG_THERMAL_OF
>> +struct thermal_bind_params *thermal_of_build_bind_params(struct devic=
e
>> *dev);
>> +struct thermal_zone_device *thermal_of_build_thermal_zone(struct devi=
ce
>> *dev);
>> +#else
>> +static
>> +struct thermal_bind_params *thermal_of_build_bind_params(struct devic=
e
>> *dev)
>> +{
>> +	return NULL;
>> +}
>> +
>> +static
>> +struct thermal_zone_device *thermal_of_build_thermal_zone(struct devi=
ce
>> *dev)
>> +{
>> +	return NULL;
>> +}
>> +#endif
>> +
>> +#endif /* __THERMAL_DT_H__ */
>> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
>> index a386a1c..a62ada0 100644
>> --- a/include/linux/thermal.h
>> +++ b/include/linux/thermal.h
>> @@ -224,6 +224,9 @@ struct thermal_genl_event {
>>  };
>>
>>  /* Function declarations */
>> +struct thermal_zone_device
>> +*thermal_zone_of_device_register(struct device *, void *data,
>> +	int (*get_temp) (void *, unsigned long *));
>>  struct thermal_zone_device *thermal_zone_device_register(const char *=
, int,
>> int,
>>  		void *, const struct thermal_zone_device_ops *,
>>  		const struct thermal_zone_params *, int, int);
>> --
>> 1.8.2.1.342.gfa7285d
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2CHMSRVAQAWOTXVHNNEQS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHmr4sACgkQCXcVR3XQvP0cJQEAnWiL5iCmrX5dv0X4dA5gU3rM
yW0Dwd7xqGuBVweyvlkBAN+/rjFqg7mWIpFXcOnrj9KrHclzYJkmYLWmF9vr/Qu1
=UM8q
-----END PGP SIGNATURE-----

------enig2CHMSRVAQAWOTXVHNNEQS--
