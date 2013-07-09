Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3GIQyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:54:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48369 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab3GIQyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:54:33 -0400
Message-ID: <51DC402B.2000602@ti.com>
Date: Tue, 9 Jul 2013 12:54:03 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "R, Durgadoss" <durgadoss.r@intel.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "amit.daniel@samsung.com" <amit.daniel@samsung.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/4] thermal: hwmon: move hwmon support to single
 file
References: <1373378414-28086-1-git-send-email-eduardo.valentin@ti.com> <1373378414-28086-2-git-send-email-eduardo.valentin@ti.com> <4D68720C2E767A4AA6A8796D42C8EB59CDAC3D@BGSMSX101.gar.corp.intel.com>
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB59CDAC3D@BGSMSX101.gar.corp.intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2VSRXXIGEHVDBIFPXWRLJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2VSRXXIGEHVDBIFPXWRLJ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09-07-2013 12:04, R, Durgadoss wrote:
> Hi Eduardo,
>=20
>> -----Original Message-----
>> From: linux-pm-owner@vger.kernel.org [mailto:linux-pm-
>> owner@vger.kernel.org] On Behalf Of Eduardo Valentin
>> Sent: Tuesday, July 09, 2013 7:30 PM
>> To: linux-pm@vger.kernel.org; R, Durgadoss; amit.daniel@samsung.com
>> Cc: Zhang, Rui; Eduardo Valentin; linux-kernel@vger.kernel.org
>> Subject: [RFC PATCH 1/4] thermal: hwmon: move hwmon support to single =
file
>>
>> In order to improve code organization, this patch
>> moves the hwmon sysfs support to a file named
>> thermal_hwmon. This helps to add extra support
>> for hwmon without scrambling the code.
>=20
> Nice clean up for thermal_core.c. +1 from me.
>=20
> I am inclined to even remove the hwmon related code completely.
> AFAIK, there are not many users of this config option.
>=20

Hmm. OK. I thought of keeping it as I dont know if there are users.
Besides, if new code comes out of the hwmon2thermalfw exercise, then it
would be a good place to keep all the hwmon code.

> However people are looking for the other option. If they have a
> hwmon driver, how can it use the thermal framework with ease.
> [like what you mentioned about this in 0/5]

yes, problem is that hwmon does not have a standard way of representing
the drivers. So, one cannot simply write a simple wrapper because hwmon
drivers does not have a standard get_temperature operation, for instance.=


We could either propose a way to standardize then or implement the call
to thermal fw driver by driver. Probably the later is desirable, if we
implement it in a need basis.

>=20
> Thanks,
> Durga
>=20
>>
>> In order to do this move, the hwmon list head is now
>> using its own locking. Before, the list used
>> the global thermal locking.
>>
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Cc: linux-pm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>  drivers/thermal/Kconfig         |   9 ++
>>  drivers/thermal/Makefile        |   3 +
>>  drivers/thermal/thermal_core.c  | 255 +------------------------------=
-------
>>  drivers/thermal/thermal_hwmon.c | 268
>> ++++++++++++++++++++++++++++++++++++++++
>>  drivers/thermal/thermal_hwmon.h |  49 ++++++++
>>  5 files changed, 330 insertions(+), 254 deletions(-)
>>  create mode 100644 drivers/thermal/thermal_hwmon.c
>>  create mode 100644 drivers/thermal/thermal_hwmon.h
>>
>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>> index e988c81..7fb16bc 100644
>> --- a/drivers/thermal/Kconfig
>> +++ b/drivers/thermal/Kconfig
>> @@ -17,8 +17,17 @@ if THERMAL
>>
>>  config THERMAL_HWMON
>>  	bool
>> +	prompt "Expose thermal sensors as hwmon device"
>>  	depends on HWMON=3Dy || HWMON=3DTHERMAL
>>  	default y
>> +	help
>> +	  In case a sensor is registered with the thermal
>> +	  framework, this option will also register it
>> +	  as a hwmon. The sensor will then have the common
>> +	  hwmon sysfs interface.
>> +
>> +	  Say 'Y' here if you want all thermal sensors to
>> +	  have hwmon sysfs interface too.
>>
>>  choice
>>  	prompt "Default Thermal governor"
>> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
>> index 67184a2..24cb894 100644
>> --- a/drivers/thermal/Makefile
>> +++ b/drivers/thermal/Makefile
>> @@ -5,6 +5,9 @@
>>  obj-$(CONFIG_THERMAL)		+=3D thermal_sys.o
>>  thermal_sys-y			+=3D thermal_core.o
>>
>> +# interface to/from other layers providing sensors
>> +thermal_sys-$(CONFIG_THERMAL_HWMON)		+=3D thermal_hwmon.o
>> +
>>  # governors
>>  thermal_sys-$(CONFIG_THERMAL_GOV_FAIR_SHARE)	+=3D fair_share.o
>>  thermal_sys-$(CONFIG_THERMAL_GOV_STEP_WISE)	+=3D step_wise.o
>> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_=
core.c
>> index 1f02e8e..247528b 100644
>> --- a/drivers/thermal/thermal_core.c
>> +++ b/drivers/thermal/thermal_core.c
>> @@ -38,6 +38,7 @@
>>  #include <net/genetlink.h>
>>
>>  #include "thermal_core.h"
>> +#include "thermal_hwmon.h"
>>
>>  MODULE_AUTHOR("Zhang Rui");
>>  MODULE_DESCRIPTION("Generic thermal management sysfs support");
>> @@ -859,260 +860,6 @@ thermal_cooling_device_trip_point_show(struct de=
vice
>> *dev,
>>
>>  /* Device management */
>>
>> -#if defined(CONFIG_THERMAL_HWMON)
>> -
>> -/* hwmon sys I/F */
>> -#include <linux/hwmon.h>
>> -
>> -/* thermal zone devices with the same type share one hwmon device */
>> -struct thermal_hwmon_device {
>> -	char type[THERMAL_NAME_LENGTH];
>> -	struct device *device;
>> -	int count;
>> -	struct list_head tz_list;
>> -	struct list_head node;
>> -};
>> -
>> -struct thermal_hwmon_attr {
>> -	struct device_attribute attr;
>> -	char name[16];
>> -};
>> -
>> -/* one temperature input for each thermal zone */
>> -struct thermal_hwmon_temp {
>> -	struct list_head hwmon_node;
>> -	struct thermal_zone_device *tz;
>> -	struct thermal_hwmon_attr temp_input;	/* hwmon sys attr */
>> -	struct thermal_hwmon_attr temp_crit;	/* hwmon sys attr */
>> -};
>> -
>> -static LIST_HEAD(thermal_hwmon_list);
>> -
>> -static ssize_t
>> -name_show(struct device *dev, struct device_attribute *attr, char *bu=
f)
>> -{
>> -	struct thermal_hwmon_device *hwmon =3D dev_get_drvdata(dev);
>> -	return sprintf(buf, "%s\n", hwmon->type);
>> -}
>> -static DEVICE_ATTR(name, 0444, name_show, NULL);
>> -
>> -static ssize_t
>> -temp_input_show(struct device *dev, struct device_attribute *attr, ch=
ar *buf)
>> -{
>> -	long temperature;
>> -	int ret;
>> -	struct thermal_hwmon_attr *hwmon_attr
>> -			=3D container_of(attr, struct thermal_hwmon_attr, attr);
>> -	struct thermal_hwmon_temp *temp
>> -			=3D container_of(hwmon_attr, struct
>> thermal_hwmon_temp,
>> -				       temp_input);
>> -	struct thermal_zone_device *tz =3D temp->tz;
>> -
>> -	ret =3D thermal_zone_get_temp(tz, &temperature);
>> -
>> -	if (ret)
>> -		return ret;
>> -
>> -	return sprintf(buf, "%ld\n", temperature);
>> -}
>> -
>> -static ssize_t
>> -temp_crit_show(struct device *dev, struct device_attribute *attr,
>> -		char *buf)
>> -{
>> -	struct thermal_hwmon_attr *hwmon_attr
>> -			=3D container_of(attr, struct thermal_hwmon_attr, attr);
>> -	struct thermal_hwmon_temp *temp
>> -			=3D container_of(hwmon_attr, struct
>> thermal_hwmon_temp,
>> -				       temp_crit);
>> -	struct thermal_zone_device *tz =3D temp->tz;
>> -	long temperature;
>> -	int ret;
>> -
>> -	ret =3D tz->ops->get_trip_temp(tz, 0, &temperature);
>> -	if (ret)
>> -		return ret;
>> -
>> -	return sprintf(buf, "%ld\n", temperature);
>> -}
>> -
>> -
>> -static struct thermal_hwmon_device *
>> -thermal_hwmon_lookup_by_type(const struct thermal_zone_device *tz)
>> -{
>> -	struct thermal_hwmon_device *hwmon;
>> -
>> -	mutex_lock(&thermal_list_lock);
>> -	list_for_each_entry(hwmon, &thermal_hwmon_list, node)
>> -		if (!strcmp(hwmon->type, tz->type)) {
>> -			mutex_unlock(&thermal_list_lock);
>> -			return hwmon;
>> -		}
>> -	mutex_unlock(&thermal_list_lock);
>> -
>> -	return NULL;
>> -}
>> -
>> -/* Find the temperature input matching a given thermal zone */
>> -static struct thermal_hwmon_temp *
>> -thermal_hwmon_lookup_temp(const struct thermal_hwmon_device *hwmon,
>> -			  const struct thermal_zone_device *tz)
>> -{
>> -	struct thermal_hwmon_temp *temp;
>> -
>> -	mutex_lock(&thermal_list_lock);
>> -	list_for_each_entry(temp, &hwmon->tz_list, hwmon_node)
>> -		if (temp->tz =3D=3D tz) {
>> -			mutex_unlock(&thermal_list_lock);
>> -			return temp;
>> -		}
>> -	mutex_unlock(&thermal_list_lock);
>> -
>> -	return NULL;
>> -}
>> -
>> -static int
>> -thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
>> -{
>> -	struct thermal_hwmon_device *hwmon;
>> -	struct thermal_hwmon_temp *temp;
>> -	int new_hwmon_device =3D 1;
>> -	int result;
>> -
>> -	hwmon =3D thermal_hwmon_lookup_by_type(tz);
>> -	if (hwmon) {
>> -		new_hwmon_device =3D 0;
>> -		goto register_sys_interface;
>> -	}
>> -
>> -	hwmon =3D kzalloc(sizeof(struct thermal_hwmon_device), GFP_KERNEL);
>> -	if (!hwmon)
>> -		return -ENOMEM;
>> -
>> -	INIT_LIST_HEAD(&hwmon->tz_list);
>> -	strlcpy(hwmon->type, tz->type, THERMAL_NAME_LENGTH);
>> -	hwmon->device =3D hwmon_device_register(NULL);
>> -	if (IS_ERR(hwmon->device)) {
>> -		result =3D PTR_ERR(hwmon->device);
>> -		goto free_mem;
>> -	}
>> -	dev_set_drvdata(hwmon->device, hwmon);
>> -	result =3D device_create_file(hwmon->device, &dev_attr_name);
>> -	if (result)
>> -		goto free_mem;
>> -
>> - register_sys_interface:
>> -	temp =3D kzalloc(sizeof(struct thermal_hwmon_temp), GFP_KERNEL);
>> -	if (!temp) {
>> -		result =3D -ENOMEM;
>> -		goto unregister_name;
>> -	}
>> -
>> -	temp->tz =3D tz;
>> -	hwmon->count++;
>> -
>> -	snprintf(temp->temp_input.name, sizeof(temp->temp_input.name),
>> -		 "temp%d_input", hwmon->count);
>> -	temp->temp_input.attr.attr.name =3D temp->temp_input.name;
>> -	temp->temp_input.attr.attr.mode =3D 0444;
>> -	temp->temp_input.attr.show =3D temp_input_show;
>> -	sysfs_attr_init(&temp->temp_input.attr.attr);
>> -	result =3D device_create_file(hwmon->device, &temp->temp_input.attr)=
;
>> -	if (result)
>> -		goto free_temp_mem;
>> -
>> -	if (tz->ops->get_crit_temp) {
>> -		unsigned long temperature;
>> -		if (!tz->ops->get_crit_temp(tz, &temperature)) {
>> -			snprintf(temp->temp_crit.name,
>> -				 sizeof(temp->temp_crit.name),
>> -				"temp%d_crit", hwmon->count);
>> -			temp->temp_crit.attr.attr.name =3D temp-
>>> temp_crit.name;
>> -			temp->temp_crit.attr.attr.mode =3D 0444;
>> -			temp->temp_crit.attr.show =3D temp_crit_show;
>> -			sysfs_attr_init(&temp->temp_crit.attr.attr);
>> -			result =3D device_create_file(hwmon->device,
>> -						    &temp->temp_crit.attr);
>> -			if (result)
>> -				goto unregister_input;
>> -		}
>> -	}
>> -
>> -	mutex_lock(&thermal_list_lock);
>> -	if (new_hwmon_device)
>> -		list_add_tail(&hwmon->node, &thermal_hwmon_list);
>> -	list_add_tail(&temp->hwmon_node, &hwmon->tz_list);
>> -	mutex_unlock(&thermal_list_lock);
>> -
>> -	return 0;
>> -
>> - unregister_input:
>> -	device_remove_file(hwmon->device, &temp->temp_input.attr);
>> - free_temp_mem:
>> -	kfree(temp);
>> - unregister_name:
>> -	if (new_hwmon_device) {
>> -		device_remove_file(hwmon->device, &dev_attr_name);
>> -		hwmon_device_unregister(hwmon->device);
>> -	}
>> - free_mem:
>> -	if (new_hwmon_device)
>> -		kfree(hwmon);
>> -
>> -	return result;
>> -}
>> -
>> -static void
>> -thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
>> -{
>> -	struct thermal_hwmon_device *hwmon;
>> -	struct thermal_hwmon_temp *temp;
>> -
>> -	hwmon =3D thermal_hwmon_lookup_by_type(tz);
>> -	if (unlikely(!hwmon)) {
>> -		/* Should never happen... */
>> -		dev_dbg(&tz->device, "hwmon device lookup failed!\n");
>> -		return;
>> -	}
>> -
>> -	temp =3D thermal_hwmon_lookup_temp(hwmon, tz);
>> -	if (unlikely(!temp)) {
>> -		/* Should never happen... */
>> -		dev_dbg(&tz->device, "temperature input lookup failed!\n");
>> -		return;
>> -	}
>> -
>> -	device_remove_file(hwmon->device, &temp->temp_input.attr);
>> -	if (tz->ops->get_crit_temp)
>> -		device_remove_file(hwmon->device, &temp->temp_crit.attr);
>> -
>> -	mutex_lock(&thermal_list_lock);
>> -	list_del(&temp->hwmon_node);
>> -	kfree(temp);
>> -	if (!list_empty(&hwmon->tz_list)) {
>> -		mutex_unlock(&thermal_list_lock);
>> -		return;
>> -	}
>> -	list_del(&hwmon->node);
>> -	mutex_unlock(&thermal_list_lock);
>> -
>> -	device_remove_file(hwmon->device, &dev_attr_name);
>> -	hwmon_device_unregister(hwmon->device);
>> -	kfree(hwmon);
>> -}
>> -#else
>> -static int
>> -thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
>> -{
>> -	return 0;
>> -}
>> -
>> -static void
>> -thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
>> -{
>> -}
>> -#endif
>> -
>>  /**
>>   * thermal_zone_bind_cooling_device() - bind a cooling device to a th=
ermal zone
>>   * @tz:		pointer to struct thermal_zone_device
>> diff --git a/drivers/thermal/thermal_hwmon.c
>> b/drivers/thermal/thermal_hwmon.c
>> new file mode 100644
>> index 0000000..7c665c8
>> --- /dev/null
>> +++ b/drivers/thermal/thermal_hwmon.c
>> @@ -0,0 +1,268 @@
>> +/*
>> + *  thermal_hwmon.c - Generic Thermal Management hwmon support.
>> + *
>> + *  Code based on Intel thermal_core.c. Copyrights of the original co=
de:
>> + *  Copyright (C) 2008 Intel Corp
>> + *  Copyright (C) 2008 Zhang Rui <rui.zhang@intel.com>
>> + *  Copyright (C) 2008 Sujith Thomas <sujith.thomas@intel.com>
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
>> +#include <linux/hwmon.h>
>> +#include <linux/thermal.h>
>> +#include <linux/slab.h>
>> +#include <linux/err.h>
>> +
>> +/* hwmon sys I/F */
>> +/* thermal zone devices with the same type share one hwmon device */
>> +struct thermal_hwmon_device {
>> +	char type[THERMAL_NAME_LENGTH];
>> +	struct device *device;
>> +	int count;
>> +	struct list_head tz_list;
>> +	struct list_head node;
>> +};
>> +
>> +struct thermal_hwmon_attr {
>> +	struct device_attribute attr;
>> +	char name[16];
>> +};
>> +
>> +/* one temperature input for each thermal zone */
>> +struct thermal_hwmon_temp {
>> +	struct list_head hwmon_node;
>> +	struct thermal_zone_device *tz;
>> +	struct thermal_hwmon_attr temp_input;	/* hwmon sys attr */
>> +	struct thermal_hwmon_attr temp_crit;	/* hwmon sys attr */
>> +};
>> +
>> +static LIST_HEAD(thermal_hwmon_list);
>> +
>> +static DEFINE_MUTEX(thermal_hwmon_list_lock);
>> +
>> +static ssize_t
>> +name_show(struct device *dev, struct device_attribute *attr, char *bu=
f)
>> +{
>> +	struct thermal_hwmon_device *hwmon =3D dev_get_drvdata(dev);
>> +	return sprintf(buf, "%s\n", hwmon->type);
>> +}
>> +static DEVICE_ATTR(name, 0444, name_show, NULL);
>> +
>> +static ssize_t
>> +temp_input_show(struct device *dev, struct device_attribute *attr, ch=
ar *buf)
>> +{
>> +	long temperature;
>> +	int ret;
>> +	struct thermal_hwmon_attr *hwmon_attr
>> +			=3D container_of(attr, struct thermal_hwmon_attr, attr);
>> +	struct thermal_hwmon_temp *temp
>> +			=3D container_of(hwmon_attr, struct
>> thermal_hwmon_temp,
>> +				       temp_input);
>> +	struct thermal_zone_device *tz =3D temp->tz;
>> +
>> +	ret =3D thermal_zone_get_temp(tz, &temperature);
>> +
>> +	if (ret)
>> +		return ret;
>> +
>> +	return sprintf(buf, "%ld\n", temperature);
>> +}
>> +
>> +static ssize_t
>> +temp_crit_show(struct device *dev, struct device_attribute *attr, cha=
r *buf)
>> +{
>> +	struct thermal_hwmon_attr *hwmon_attr
>> +			=3D container_of(attr, struct thermal_hwmon_attr, attr);
>> +	struct thermal_hwmon_temp *temp
>> +			=3D container_of(hwmon_attr, struct
>> thermal_hwmon_temp,
>> +				       temp_crit);
>> +	struct thermal_zone_device *tz =3D temp->tz;
>> +	long temperature;
>> +	int ret;
>> +
>> +	ret =3D tz->ops->get_trip_temp(tz, 0, &temperature);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return sprintf(buf, "%ld\n", temperature);
>> +}
>> +
>> +
>> +static struct thermal_hwmon_device *
>> +thermal_hwmon_lookup_by_type(const struct thermal_zone_device *tz)
>> +{
>> +	struct thermal_hwmon_device *hwmon;
>> +
>> +	mutex_lock(&thermal_hwmon_list_lock);
>> +	list_for_each_entry(hwmon, &thermal_hwmon_list, node)
>> +		if (!strcmp(hwmon->type, tz->type)) {
>> +			mutex_unlock(&thermal_hwmon_list_lock);
>> +			return hwmon;
>> +		}
>> +	mutex_unlock(&thermal_hwmon_list_lock);
>> +
>> +	return NULL;
>> +}
>> +
>> +/* Find the temperature input matching a given thermal zone */
>> +static struct thermal_hwmon_temp *
>> +thermal_hwmon_lookup_temp(const struct thermal_hwmon_device *hwmon,
>> +			  const struct thermal_zone_device *tz)
>> +{
>> +	struct thermal_hwmon_temp *temp;
>> +
>> +	mutex_lock(&thermal_hwmon_list_lock);
>> +	list_for_each_entry(temp, &hwmon->tz_list, hwmon_node)
>> +		if (temp->tz =3D=3D tz) {
>> +			mutex_unlock(&thermal_hwmon_list_lock);
>> +			return temp;
>> +		}
>> +	mutex_unlock(&thermal_hwmon_list_lock);
>> +
>> +	return NULL;
>> +}
>> +
>> +int thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
>> +{
>> +	struct thermal_hwmon_device *hwmon;
>> +	struct thermal_hwmon_temp *temp;
>> +	int new_hwmon_device =3D 1;
>> +	int result;
>> +
>> +	hwmon =3D thermal_hwmon_lookup_by_type(tz);
>> +	if (hwmon) {
>> +		new_hwmon_device =3D 0;
>> +		goto register_sys_interface;
>> +	}
>> +
>> +	hwmon =3D kzalloc(sizeof(struct thermal_hwmon_device), GFP_KERNEL);
>> +	if (!hwmon)
>> +		return -ENOMEM;
>> +
>> +	INIT_LIST_HEAD(&hwmon->tz_list);
>> +	strlcpy(hwmon->type, tz->type, THERMAL_NAME_LENGTH);
>> +	hwmon->device =3D hwmon_device_register(NULL);
>> +	if (IS_ERR(hwmon->device)) {
>> +		result =3D PTR_ERR(hwmon->device);
>> +		goto free_mem;
>> +	}
>> +	dev_set_drvdata(hwmon->device, hwmon);
>> +	result =3D device_create_file(hwmon->device, &dev_attr_name);
>> +	if (result)
>> +		goto free_mem;
>> +
>> + register_sys_interface:
>> +	temp =3D kzalloc(sizeof(struct thermal_hwmon_temp), GFP_KERNEL);
>> +	if (!temp) {
>> +		result =3D -ENOMEM;
>> +		goto unregister_name;
>> +	}
>> +
>> +	temp->tz =3D tz;
>> +	hwmon->count++;
>> +
>> +	snprintf(temp->temp_input.name, sizeof(temp->temp_input.name),
>> +		 "temp%d_input", hwmon->count);
>> +	temp->temp_input.attr.attr.name =3D temp->temp_input.name;
>> +	temp->temp_input.attr.attr.mode =3D 0444;
>> +	temp->temp_input.attr.show =3D temp_input_show;
>> +	sysfs_attr_init(&temp->temp_input.attr.attr);
>> +	result =3D device_create_file(hwmon->device, &temp->temp_input.attr)=
;
>> +	if (result)
>> +		goto free_temp_mem;
>> +
>> +	if (tz->ops->get_crit_temp) {
>> +		unsigned long temperature;
>> +		if (!tz->ops->get_crit_temp(tz, &temperature)) {
>> +			snprintf(temp->temp_crit.name,
>> +				 sizeof(temp->temp_crit.name),
>> +				"temp%d_crit", hwmon->count);
>> +			temp->temp_crit.attr.attr.name =3D temp-
>>> temp_crit.name;
>> +			temp->temp_crit.attr.attr.mode =3D 0444;
>> +			temp->temp_crit.attr.show =3D temp_crit_show;
>> +			sysfs_attr_init(&temp->temp_crit.attr.attr);
>> +			result =3D device_create_file(hwmon->device,
>> +						    &temp->temp_crit.attr);
>> +			if (result)
>> +				goto unregister_input;
>> +		}
>> +	}
>> +
>> +	mutex_lock(&thermal_hwmon_list_lock);
>> +	if (new_hwmon_device)
>> +		list_add_tail(&hwmon->node, &thermal_hwmon_list);
>> +	list_add_tail(&temp->hwmon_node, &hwmon->tz_list);
>> +	mutex_unlock(&thermal_hwmon_list_lock);
>> +
>> +	return 0;
>> +
>> + unregister_input:
>> +	device_remove_file(hwmon->device, &temp->temp_input.attr);
>> + free_temp_mem:
>> +	kfree(temp);
>> + unregister_name:
>> +	if (new_hwmon_device) {
>> +		device_remove_file(hwmon->device, &dev_attr_name);
>> +		hwmon_device_unregister(hwmon->device);
>> +	}
>> + free_mem:
>> +	if (new_hwmon_device)
>> +		kfree(hwmon);
>> +
>> +	return result;
>> +}
>> +
>> +void thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
>> +{
>> +	struct thermal_hwmon_device *hwmon;
>> +	struct thermal_hwmon_temp *temp;
>> +
>> +	hwmon =3D thermal_hwmon_lookup_by_type(tz);
>> +	if (unlikely(!hwmon)) {
>> +		/* Should never happen... */
>> +		dev_dbg(&tz->device, "hwmon device lookup failed!\n");
>> +		return;
>> +	}
>> +
>> +	temp =3D thermal_hwmon_lookup_temp(hwmon, tz);
>> +	if (unlikely(!temp)) {
>> +		/* Should never happen... */
>> +		dev_dbg(&tz->device, "temperature input lookup failed!\n");
>> +		return;
>> +	}
>> +
>> +	device_remove_file(hwmon->device, &temp->temp_input.attr);
>> +	if (tz->ops->get_crit_temp)
>> +		device_remove_file(hwmon->device, &temp->temp_crit.attr);
>> +
>> +	mutex_lock(&thermal_hwmon_list_lock);
>> +	list_del(&temp->hwmon_node);
>> +	kfree(temp);
>> +	if (!list_empty(&hwmon->tz_list)) {
>> +		mutex_unlock(&thermal_hwmon_list_lock);
>> +		return;
>> +	}
>> +	list_del(&hwmon->node);
>> +	mutex_unlock(&thermal_hwmon_list_lock);
>> +
>> +	device_remove_file(hwmon->device, &dev_attr_name);
>> +	hwmon_device_unregister(hwmon->device);
>> +	kfree(hwmon);
>> +}
>> diff --git a/drivers/thermal/thermal_hwmon.h
>> b/drivers/thermal/thermal_hwmon.h
>> new file mode 100644
>> index 0000000..c798fdb
>> --- /dev/null
>> +++ b/drivers/thermal/thermal_hwmon.h
>> @@ -0,0 +1,49 @@
>> +/*
>> + *  thermal_hwmon.h - Generic Thermal Management hwmon support.
>> + *
>> + *  Code based on Intel thermal_core.c. Copyrights of the original co=
de:
>> + *  Copyright (C) 2008 Intel Corp
>> + *  Copyright (C) 2008 Zhang Rui <rui.zhang@intel.com>
>> + *  Copyright (C) 2008 Sujith Thomas <sujith.thomas@intel.com>
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
>> +#ifndef __THERMAL_HWMON_H__
>> +#define __THERMAL_HWMON_H__
>> +
>> +#include <linux/thermal.h>
>> +
>> +#ifdef CONFIG_THERMAL_HWMON
>> +int thermal_add_hwmon_sysfs(struct thermal_zone_device *tz);
>> +void thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz);
>> +#else
>> +static int
>> +thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
>> +{
>> +	return 0;
>> +}
>> +
>> +static void
>> +thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
>> +{
>> +}
>> +#endif
>> +
>> +#endif /* __THERMAL_HWMON_H__ */
>> --
>> 1.8.2.1.342.gfa7285d
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pm" in=

>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2VSRXXIGEHVDBIFPXWRLJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHcQCwACgkQCXcVR3XQvP3o6QD/YjwkkmjrjGbpCjZBPwu7oJeC
ZYPimXlhs+5BSjLd0aMBAKlc7G4oNFU1y2PzjblQWxUX6LSvfJ1PUPAs7DjZVemP
=EZr2
-----END PGP SIGNATURE-----

------enig2VSRXXIGEHVDBIFPXWRLJ--
