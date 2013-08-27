Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab3H0NqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:46:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55046 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab3H0Np6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:45:58 -0400
Message-ID: <521CAD48.2030306@ti.com>
Date: Tue, 27 Aug 2013 09:44:40 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "wni@nvidia.com" <wni@nvidia.com>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 02/14] drivers: thermal: introduce device tree parser
References: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com> <1377299755-5134-3-git-send-email-eduardo.valentin@ti.com> <20130827102205.GC19893@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130827102205.GC19893@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="6grSOrNjOiLgIXlU3A1hRSsRHAc4kGbEg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6grSOrNjOiLgIXlU3A1hRSsRHAc4kGbEg
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Mark,


First of all, thanks for taking the time to review in such level of
detail. Lets try to align and have a common understanding. Answers go
inline. Please let me know if I missed something or if I made it more
confusing :-)

On 27-08-2013 06:22, Mark Rutland wrote:
> Hi,
>=20
> On Sat, Aug 24, 2013 at 12:15:43AM +0100, Eduardo Valentin wrote:
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
>> API and how to define tree nodes to use
>> this infrastructure.
>>
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Cc: linux-pm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>  .../devicetree/bindings/thermal/thermal.txt        | 160 +++++++
>>  drivers/thermal/Kconfig                            |  13 +
>>  drivers/thermal/Makefile                           |   1 +
>>  drivers/thermal/thermal_dt.c                       | 473 ++++++++++++=
+++++++++
>>  include/dt-bindings/thermal/thermal.h              |  27 ++
>>  include/linux/thermal.h                            |   3 +
>>  6 files changed, 677 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/thermal/thermal.=
txt
>>  create mode 100644 drivers/thermal/thermal_dt.c
>>  create mode 100644 include/dt-bindings/thermal/thermal.h
>>


General question on device tree documentation. Assuming there is such an
effort to make it Linux independent, is there other places out of Linux
tree that these binding must be documented?


>> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/D=
ocumentation/devicetree/bindings/thermal/thermal.txt
>> new file mode 100644
>> index 0000000..af20ab0
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
>> @@ -0,0 +1,160 @@
>> +----------------------------------------
>> +Thermal Framework Device Tree descriptor
>> +----------------------------------------
>> +
>> +This file describes how to define a thermal structure using device tr=
ee.
>> +A thermal structure includes thermal zones and their components, such=

>> +as name, trip points, polling intervals and cooling devices binding
>> +descriptors. A binding descriptor may contain information on how to
>> +react, with a cooling stepped action or a weight on a fair share.
>> +The target of device tree thermal descriptors is to describe only
>> +the hardware thermal aspects, not how the system must control or whic=
h
>> +algorithm or policy must take place. It follows a description of each=

>> +type of device tree node.
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
>=20
> Presumably this is a single (u32) cell?

Yes, both of them above are a single u32.

>=20
>> +- type: the trip type. Here is the type mapping:
>> +       THERMAL_TRIP_ACTIVE
>> +       THERMAL_TRIP_PASSIVE
>> +       THERMAL_TRIP_HOT
>> +       THERMAL_TRIP_CRITICAL
>=20
> What type is this property?
>=20
> What are these values? Do you need to refer to a header somewhere?

There is a header, introduced in this patch.
include/dt-bindings/thermal/thermal.h

> Symbolic constants should have an associated value for an ABI.

OK. Sounds reasonable to me. Shall we be descriptive and enlist the
values in this doc too or just pointing to header is fine?

>=20
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
>=20
> Please use '-' rather than '_' in bindings. That's the normal devicetre=
e
> convention, and there's no point gonig against it and causing more
> confusion.

Agreed.

>=20
> What are valid values of this string, and what do they mean?

These are the name of the cooling devices to match to.

>=20
> Why not a phandle + cells binding to cooling devices?
>=20

Yeah, this could work too. I am going to check how that would look like
and come back to you.

>> +- weight: The 'influence' of a particular cooling device on this zone=
=2E
>> +             This is on a percentage scale. The sum of all these weig=
hts
>> +             (for a particular zone) cannot exceed 100.
>=20
> This is a bit fuzzy, and certainly needs more guidance.

OK. This property is used to describe the amount of cooling contribution
when activating a cooling device at a certain trip point. I will work on
a better guidance.

>=20
>> +- trip_mask: This is a bit mask that gives the binding relation betwe=
en
>> +               this thermal zone and cdev, for a particular trip poin=
t.
>> +               If nth bit is set, then the cdev and thermal zone are =
bound
>> +               for trip point n.
>=20
> What type is this?
>=20
> The nth bit from which end?
>=20
> Could you explain what "bound for trip point n" means?
>=20

It is just a way to match a cooling device with a set of trip points.
Say you want to match one specific cooling device with trips 0 and 1,
you would then create a bind_param with trip_mask =3D 0x3.

> Just because this is a bitmask in Linux does not mean it needs to be so=

> in the dt.

Indeed.

In case we work with phandle + cell binging parameters, the trip and
weight could be passed as params.

	cooling-devices =3D <&devX tripY weightZ>, <... >;



>=20
>> +- limits: An array integers consisting of 2-tuples items, and each it=
em means
>> +  lower and upper state limits, like <min-state max-state>.
>> +
>> +**************************
>> +temperature sensor devices
>> +**************************
>> +
>> +Temperature sensor devices have to be linked to a specific thermal zo=
ne.
>> +This is done by means of the 'monitored-zones' list.
>> +- monitored-zones: A list of thermal zones phandles, identifying whic=
h
>> +thermal zones the temperature sensor device is used to monitor.
>=20
> Why does this need to be described that way around?
>=20
> Can the zone not have a link to the sensor(s) it needs?
>=20

Do you see any issues with it?

Idea is that sensor nodes would list which zones they are used.  Same
idea goes to cooling devices. It can be the other way around, yes. It
depends on what is the best way to describe these relations. Idea would
be so that sensors and cooling devices would be composing a thermal zone.=


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
>> +- mask: Bit string: If 'n'th bit is set, then trip point 'n' is write=
able.
>=20
> What type is a bit string in devicetree? I'm aware of cells and (byte)
> strings, but not bit strings.
>=20
> What does 'writeable' mean in this context?
>=20
> There's presumably a better name than 'mask'.
>=20

This is used to describe if trip points are writeable under sysfs. I
think this is a OS implementation leak. I will be removing this from
device tree and making them RO by default.

>> +
>> +- passive_delay: number of milliseconds to wait between polls when
>> +  performing passive cooling.
>> +
>> +- polling_delay: number of milliseconds to wait between polls when ch=
ecking.
>=20
> These sound very much like configuration of the driver rather than
> hardware description. What if my temperature sensor can generate an
> interrupt at some trigger temperature? Why would I need polling times?
>=20
> Why does this need to be in the dt at all? Surely the OS can choose som=
e
> sensible polling period, possibly dynamically?

Well, let me answer this one with another question. How the OS will
determine how fast is the temperature rise on a thermal zone described
in device tree?

>=20
>> +
>> +- #thermal-cells: An integer that is used to specify how many cells c=
ompose
>> +  sensor ids.
>=20
> I don't see why this is necessary. If the zone itself described its
> related sensors rather than the other way around, we wouldn't need it a=
t
> all. Most bindings so far have consumers link to their providers rather=

> than the other way around.
>=20

I see.


>> +
>> +Below is an example:
>> +cpu_thermal: thermal_zone {
>> +            #thermal-cells =3D <1>;
>> +            mask =3D <0x03>; /* trips writability */
>> +            passive_delay =3D <250>; /* milliseconds */
>> +            polling_delay =3D <1000>; /* milliseconds */
>> +            trips {
>> +                    alert@100000{
>> +                            temperature =3D <100000>; /* milliCelsius=
 */
>> +                            hysteresis =3D <0>; /* milliCelsius */
>> +                            type =3D <THERMAL_TRIP_PASSIVE>;
>> +                    };
>> +                    crit@125000{
>> +                            temperature =3D <125000>; /* milliCelsius=
 */
>> +                            hysteresis =3D <0>; /* milliCelsius */
>> +                            type =3D <THERMAL_TRIP_CRITICAL>;
>> +                    };
>> +            };
>> +            bind_params {
>> +                    action@0{
>> +                            cooling_device =3D "thermal-cpufreq";
>=20
> NAK. That value was not defined anywhere, and represents Linux
> infrastructure rather than hardware.
>=20

Yes, this was another leak as discussed above in the upper part of the
doc file.

> For this case, we could just as easily describe the thermal points, and=

> if no physical cooling device (e.g. a fan) is present, assume
> cpufreq-base cooling.  Other OSs could choose to do otherwise, and we
> could change later...
>=20

The way other specifications do (aka ACPI) is to have trip types. In
case a trip type is passive cooling, it means one is supposed to
modulate the dissipated power rather than activating a device to remove
heat (active cooling).

The part of 'assuming' things that bothers me. I would rather have a way
to really say one wants to have passive cooling at a specific trip point.=



>> +                            weight =3D <100>; /* percentage */
>> +                            mask =3D <0x01>;
>=20
> This should presumably be trip-mask (assuming my suggested corrections)=
=2E
>=20
> What is it supposed to mean here?

As stated above, it means the trip points that this binding represents.

>=20
>> +                           limits =3D <
>> +                             /* lower-state            upper-state */=

>> +                               1                       THERMAL_NO_LIM=
ITS
>> +                               THERMAL_NO_LIMITS       THERMAL_NO_LIM=
ITS
>> +                           >;
>> +                    };
>> +            };
>> +};
>> +
>> +sensor: adc@0xFFFF {
>> +       ...
>> +       monitored-zones =3D <&cpu_thermal 0>;
>> +};
>> +
>> +cpu@0 {
>> +       ...
>> +       cooling-zones =3D <&cpu_thermal>;
>> +};
>> +
>> +In the example above, the ADC sensor at address 0xFFFF is used to mon=
itor
>> +the zone 'cpu_thermal' using its the sensor 0. The cpu@0 device is al=
so linked
>> +to the same thermal zone 'cpu_thermal' as a cooling device.
>=20
> Huh? That seems to imply the the '0' in '<&cpu_thermal 0>' on the senso=
r
> node describes a property of the sensor rather than the thermal node,
> unless I've misunderstood?
>=20

It is essentially which sensor id is used to monitor a specific zone. In
case of sensor IPs that feature several internal sensors, one needs to
have a way to describe which sensor monitors which zone. Example of this
type of IPs: lm90 (up to 3 sensors) and TI bandgap IP (can contain up to
5 internal sensors). The probe happens for the IP device and not for the
internal sensors.


>> +
>> +***************
>> +cpufreq-cooling
>> +***************
>> +
>> +The generic cpu cooling (freq clipping) can be loaded by the
>> +generic cpufreq-cpu0 driver in case the device tree node informs
>> +this need.
>> +
>> +In order to load the cpufreq cooling device, it is possible to
>> +inform that the cpu needs cooling by adding the list of thermal zones=

>> +in the 'cooling-zones' property at the cpu0 phandle.
>=20
> This should be reworded so as to describe the binding rather than the
> Linux behaviour based on the binding.

OK.

>=20
>> +
>> +Example:
>> +       cpus {
>> +               cpu@0 {
>> +                       operating-points =3D <
>> +                               /* kHz    uV */
>> +                               800000  1313000
>> +                               1008000 1375000
>> +                       >;
>> +                       cooling-zones =3D <&cpu_thermal>;
>> +               };
>> +       ...
>> +       };
>> +
>> +The above will cause the cpufreq-cpu0 driver to understand that
>> +the cpu will need passive cooling and while probing that node it will=

>> +also load the cpufreq cpu cooling device in that system.
>=20
> The above describe that the CPU is part of a cooling (thermal?) zone an=
d
> requires cooling.

That says the cpu participates in a thermal zone as a cooling
device/mechanism, thus cpu cooling (passive cooling) is required in
target system.

>=20
>> +
>> +However, be advised that this flag will not describe what needs to
>> +be done or how the cpufreq cooling device will be used. In order to
>> +accomplish this, one needs to write a phandle for a thermal zone, as
>> +described in the section 'thermal_zone'.
>=20
> The above already has a phandle to a thermal (cooling?) zone.
>=20
> Please choose either cooling zone or thermal zone, having the two names=

> makes this more confusing than necessary.

I see. Idea is to have thermal zone as a node. cooling-zone is just a
list of thermal zones that the referred device will be used as cooling
device.

>=20
>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>> index 7fb16bc..753f0dc 100644
>> --- a/drivers/thermal/Kconfig
>> +++ b/drivers/thermal/Kconfig
>> @@ -29,6 +29,19 @@ config THERMAL_HWMON
>>           Say 'Y' here if you want all thermal sensors to
>>           have hwmon sysfs interface too.
>>
>> +config THERMAL_OF
>> +       bool
>> +       prompt "APIs to parse thermal data out of device tree"
>> +       depends on OF
>> +       default y
>> +       help
>> +         This options provides helpers to add the support to
>> +         read and parse thermal data definitions out of the
>> +         device tree blob.
>> +
>> +         Say 'Y' here if you need to build thermal infrastructure
>> +         based on device tree.
>> +
>>  choice
>>         prompt "Default Thermal governor"
>>         default THERMAL_DEFAULT_GOV_STEP_WISE
>> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
>> index 24cb894..eedb273 100644
>> --- a/drivers/thermal/Makefile
>> +++ b/drivers/thermal/Makefile
>> @@ -7,6 +7,7 @@ thermal_sys-y                   +=3D thermal_core.o
>>
>>  # interface to/from other layers providing sensors
>>  thermal_sys-$(CONFIG_THERMAL_HWMON)            +=3D thermal_hwmon.o
>> +thermal_sys-$(CONFIG_THERMAL_OF)               +=3D thermal_dt.o
>>
>>  # governors
>>  thermal_sys-$(CONFIG_THERMAL_GOV_FAIR_SHARE)   +=3D fair_share.o
>> diff --git a/drivers/thermal/thermal_dt.c b/drivers/thermal/thermal_dt=
=2Ec
>> new file mode 100644
>> index 0000000..cc35485
>> --- /dev/null
>> +++ b/drivers/thermal/thermal_dt.c
>> @@ -0,0 +1,473 @@
>> +/*
>> + *  thermal_dt.c - Generic Thermal Management device tree support.
>> + *
>> + *  Copyright (C) 2013 Texas Instruments
>> + *  Copyright (C) 2013 Eduardo Valentin <eduardo.valentin@ti.com>
>> + *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~
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
>> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~
>> + */
>> +#include <linux/thermal.h>
>> +#include <linux/slab.h>
>> +#include <linux/types.h>
>> +#include <linux/of_device.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/err.h>
>> +#include <linux/export.h>
>> +#include <linux/string.h>
>> +
>> +struct __thermal_bind_params {
>> +       char cooling_device[THERMAL_NAME_LENGTH];
>> +};
>> +
>> +static
>> +int thermal_of_match(struct thermal_zone_device *tz,
>> +                    struct thermal_cooling_device *cdev);
>> +
>> +static int thermal_of_populate_bind_params(struct device *dev,
>> +                                          struct device_node *node,
>> +                                          struct __thermal_bind_param=
s *__tbp,
>> +                                          struct thermal_bind_params =
*tbp,
>> +                                          int ntrips)
>> +{
>> +       const char *cdev_name;
>> +       u32 *limits;
>> +       int ret;
>> +       u32 prop;
>> +
>> +       ret =3D of_property_read_u32(node, "weight", &prop);
>> +       if (ret < 0) {
>> +               dev_err(dev, "missing weight property\n");
>> +               return ret;
>> +       }
>> +       tbp->weight =3D prop;
>> +
>> +       ret =3D of_property_read_u32(node, "mask", &prop);
>> +       if (ret < 0) {
>> +               dev_err(dev, "missing mask property\n");
>> +               return ret;
>> +       }
>> +       tbp->trip_mask =3D prop;
>> +
>> +       /* this will allow us to bind with cooling devices */
>> +       tbp->match =3D thermal_of_match;
>> +
>> +       ret =3D of_property_read_string(node, "cooling_device", &cdev_=
name);
>> +       if (ret < 0) {
>> +               dev_err(dev, "missing cooling_device property\n");
>> +               return ret;
>> +       }
>> +       strncpy(__tbp->cooling_device, cdev_name,
>> +               sizeof(__tbp->cooling_device));
>> +
>> +       limits =3D kzalloc(ntrips * sizeof(*limits) * 2, GFP_KERNEL);
>=20
> Why do you use kzalloc here, but devm_kzalloc elsewhere? That'll lead t=
o
> problems as the driver gets refactored over time.

Because this memory is used only  within this function and thus released
at the bottom of it.

>=20
>> +       if (!limits) {
>> +               dev_err(dev, "not enough mem for reading limits\n");
>> +               return -ENOMEM;
>> +       }
>> +       ret =3D of_property_read_u32_array(node, "limits", limits, 2 *=
 ntrips);
>> +       if (!ret) {
>> +               int i =3D ntrips;
>> +
>> +               tbp->binding_limits =3D devm_kzalloc(dev,
>> +                                                  ntrips * 2 *
>> +                                                  sizeof(*tbp->bindin=
g_limits),
>> +                                                  GFP_KERNEL);
>> +               if (!tbp->binding_limits) {
>> +                       dev_err(dev, "not enough mem for storing limit=
s\n");
>> +                       return -ENOMEM;
>> +               }
>> +               while (i--)
>> +                       tbp->binding_limits[i] =3D limits[i];
>> +       }
>> +       kfree(limits);

here.

>> +
>> +       return 0;
>=20
> What if you failed to read the array? Surely you should return an error=
?

Attempting to make this property not mandatory.

>=20
>> +}
>> +
>> +struct __thermal_trip {
>> +       unsigned long int temperature;
>> +       unsigned long int hysteresis;
>> +       enum thermal_trip_type type;
>> +};
>> +
>> +static
>> +int thermal_of_populate_trip(struct device *dev,
>> +                            struct device_node *node,
>> +                            struct __thermal_trip *trip)
>> +{
>> +       int ret;
>> +       int prop;
>> +
>> +       ret =3D of_property_read_u32(node, "temperature", &prop);
>> +       if (ret < 0) {
>> +               dev_err(dev, "missing temperature property\n");
>> +               return ret;
>> +       }
>> +       trip->temperature =3D prop;
>> +
>> +       ret =3D of_property_read_u32(node, "hysteresis", &prop);
>> +       if (ret < 0) {
>> +               dev_err(dev, "missing hysteresis property\n");
>> +               return ret;
>> +       }
>> +       trip->hysteresis =3D prop;
>> +
>> +       ret =3D of_property_read_u32(node, "type", &prop);
>> +       if (ret < 0) {
>> +               dev_err(dev, "missing type property\n");
>> +               return ret;
>> +       }
>> +       trip->type =3D prop;
>=20
> This will require sanity checking.

OK.

>=20
>> +
>> +       return 0;
>> +}
>> +
>> +struct __thermal_zone_device {
>> +       enum thermal_device_mode mode;
>> +       int passive_delay;
>> +       int polling_delay;
>> +       int mask;
>> +       int ntrips;
>> +       char type[THERMAL_NAME_LENGTH];
>> +       struct __thermal_trip *trips;
>> +       struct __thermal_bind_params *bind_params;
>> +       struct thermal_bind_params *tbps;
>> +       struct thermal_zone_params zone_params;
>> +       int (*get_temp)(void *, unsigned long *);
>> +       void *devdata;
>> +};
>> +
>> +static struct __thermal_zone_device *
>> +thermal_of_build_thermal_zone(struct device *dev, struct device_node =
*node)
>> +{
>> +       struct device_node *child, *gchild;
>> +       struct __thermal_zone_device *tz;
>> +       int ret, i;
>> +       u32 prop;
>> +
>> +       if (!node) {
>> +               dev_err(dev, "no thermal zone node\n");
>> +               return ERR_PTR(-EINVAL);
>> +       }
>> +
>> +       tz =3D devm_kzalloc(dev, sizeof(*tz), GFP_KERNEL);
>> +       if (!tz) {
>> +               dev_err(dev, "not enough memory for thermal of zone\n"=
);
>> +               return ERR_PTR(-ENOMEM);
>> +       }
>> +
>> +       ret =3D of_property_read_u32(node, "passive_delay", &prop);
>> +       if (ret < 0) {
>> +               dev_err(dev, "missing passive_delay property\n");
>> +               return ERR_PTR(ret);
>> +       }
>> +       tz->passive_delay =3D prop;
>> +
>> +       ret =3D of_property_read_u32(node, "polling_delay", &prop);
>> +       if (ret < 0) {
>> +               dev_err(dev, "missing polling_delay property\n");
>> +               return ERR_PTR(ret);
>> +       }
>> +       tz->polling_delay =3D prop;
>> +
>> +       ret =3D of_property_read_u32(node, "mask", &prop);
>> +       if (ret < 0) {
>> +               dev_err(dev, "missing mask property\n");
>> +               return ERR_PTR(ret);
>> +       }
>> +       tz->mask =3D prop;
>> +
>> +       /* assume node name as our zone type */
>> +       strncpy(tz->type, node->name, sizeof(tz->type));
>> +
>> +       /* default policy */
>> +       strncpy(tz->zone_params.governor_name, "step_wise",
>> +               sizeof(tz->zone_params.governor_name));
>> +
>> +       /* trips */
>> +       child =3D of_find_node_by_name(node, "trips");
>=20
> That might not be a child node, as of_find_node_by_name walks over the
> list of all nodes. Use of_get_child_by_name.

Right! This is a bug.

>=20
>> +
>> +       /* No trips provided */
>> +       if (!child)
>> +               goto finish;
>> +
>> +       tz->ntrips =3D of_get_child_count(child);
>> +       tz->trips =3D devm_kzalloc(dev, tz->ntrips * sizeof(*tz->trips=
),
>> +                                GFP_KERNEL);
>> +       if (!tz->trips)
>> +               return ERR_PTR(-ENOMEM);
>> +       i =3D 0;
>> +       for_each_child_of_node(child, gchild)
>> +               thermal_of_populate_trip(dev, gchild, &tz->trips[i++])=
;
>=20
> What if a child node was not a valid trip node? It seems
> thermal_of_populate_trip returns errors you're ignoring.

OK. Adding proper treatment.

>=20
>> +
>> +       /* bind_params */
>> +       child =3D of_find_node_by_name(node, "bind_params");
>=20
> Another of_get_child_by_name candidate.

OK.

>=20
>> +
>> +       /* No binding info */
>> +       if (!child)
>> +               goto finish;
>> +
>> +       tz->zone_params.num_tbps =3D of_get_child_count(child);
>> +       tz->bind_params =3D devm_kzalloc(dev,
>> +                                      tz->zone_params.num_tbps *
>> +                                               sizeof(*tz->bind_param=
s),
>> +                                      GFP_KERNEL);
>> +       if (!tz->bind_params)
>> +               return ERR_PTR(-ENOMEM);
>> +       tz->zone_params.tbp =3D devm_kzalloc(dev,
>> +                                          tz->zone_params.num_tbps *
>> +                                               sizeof(*tz->zone_param=
s.tbp),
>> +                                          GFP_KERNEL);
>> +       if (!tz->zone_params.tbp)
>> +               return ERR_PTR(-ENOMEM);
>> +       i =3D 0;
>> +       for_each_child_of_node(child, gchild) {
>> +               thermal_of_populate_bind_params(dev, gchild,
>> +                                               &tz->bind_params[i],
>> +                                               &tz->zone_params.tbp[i=
],
>> +                                               tz->ntrips);
>=20
> Similarly, you're ignoring error conditions here. What if a bind_params=

> node was malformed?


Adding proper error handling.

>=20
>> +               i++;
>> +       }
>> +
>> +finish:
>> +       tz->mode =3D THERMAL_DEVICE_ENABLED;
>> +
>> +       return tz;
>> +}
>> +
>> +static
>> +int thermal_of_match(struct thermal_zone_device *tz,
>> +                    struct thermal_cooling_device *cdev)
>> +{
>> +       struct __thermal_zone_device *data =3D tz->devdata;
>> +       int i;
>> +
>> +       for (i =3D 0; i < data->zone_params.num_tbps; i++) {
>> +               if (!strncmp(data->bind_params[i].cooling_device,
>> +                            cdev->type,
>> +                            strlen(data->bind_params[i].cooling_devic=
e)) &&
>> +                   (data->zone_params.tbp[i].trip_mask & (1 << i)))
>> +                       return 0;
>> +       }
>> +
>> +       return -EINVAL;
>> +}
>=20
> I'm not keen on binding to cooling devices using a string, as suddenly =
a
> name to allow humans to inspect the system is turned into an ABI.

OK. We need to align on how we describe the binding then.

>=20
>> +
>> +static
>> +int of_thermal_get_temp(struct thermal_zone_device *tz,
>> +                       unsigned long *temp)
>> +{
>> +       struct __thermal_zone_device *data =3D tz->devdata;
>> +
>> +       return data->get_temp(data->devdata, temp);
>> +}
>> +
>> +static
>> +int of_thermal_get_mode(struct thermal_zone_device *tz,
>> +                       enum thermal_device_mode *mode)
>> +{
>> +       struct __thermal_zone_device *data =3D tz->devdata;
>> +
>> +       *mode =3D data->mode;
>> +
>> +       return 0;
>> +}
>> +
>> +static
>> +int of_thermal_set_mode(struct thermal_zone_device *tz,
>> +                       enum thermal_device_mode mode)
>> +{
>> +       struct __thermal_zone_device *data =3D tz->devdata;
>> +
>> +       mutex_lock(&tz->lock);
>> +
>> +       if (mode =3D=3D THERMAL_DEVICE_ENABLED)
>> +               tz->polling_delay =3D data->polling_delay;
>> +       else
>> +               tz->polling_delay =3D 0;
>> +
>> +       mutex_unlock(&tz->lock);
>> +
>> +       data->mode =3D mode;
>> +       thermal_zone_device_update(tz);
>> +
>> +       return 0;
>> +}
>> +
>> +static
>> +int of_thermal_get_trip_type(struct thermal_zone_device *tz, int trip=
,
>> +                            enum thermal_trip_type *type)
>> +{
>> +       struct __thermal_zone_device *data =3D tz->devdata;
>> +
>> +       if (trip >=3D data->ntrips || trip < 0)
>> +               return -EDOM;
>=20
> It's far more common to use -EINVAL.

hmm.. OK.

>=20
>> +
>> +       *type =3D data->trips[trip].type;
>> +
>> +       return 0;
>> +}
>> +
>> +static
>> +int of_thermal_get_trip_temp(struct thermal_zone_device *tz, int trip=
,
>> +                            unsigned long *temp)
>> +{
>> +       struct __thermal_zone_device *data =3D tz->devdata;
>> +
>> +       if (trip >=3D data->ntrips || trip < 0)
>> +               return -EDOM;
>> +
>> +       *temp =3D data->trips[trip].temperature;
>> +
>> +       return 0;
>> +}
>> +
>> +static
>> +int of_thermal_set_trip_temp(struct thermal_zone_device *tz, int trip=
,
>> +                            unsigned long temp)
>> +{
>> +       struct __thermal_zone_device *data =3D tz->devdata;
>> +
>> +       if (trip >=3D data->ntrips || trip < 0)
>> +               return -EDOM;
>> +
>> +       /* thermal fw should take care of data->mask & (1 << trip) */
>> +       data->trips[trip].temperature =3D temp;
>> +
>> +       return 0;
>> +}
>> +
>> +static
>> +int of_thermal_get_trip_hyst(struct thermal_zone_device *tz, int trip=
,
>> +                            unsigned long *hyst)
>> +{
>> +       struct __thermal_zone_device *data =3D tz->devdata;
>> +
>> +       if (trip >=3D data->ntrips || trip < 0)
>> +               return -EDOM;
>> +
>> +       *hyst =3D data->trips[trip].hysteresis;
>> +
>> +       return 0;
>> +}
>> +
>> +static
>> +int of_thermal_set_trip_hyst(struct thermal_zone_device *tz, int trip=
,
>> +                            unsigned long hyst)
>> +{
>> +       struct __thermal_zone_device *data =3D tz->devdata;
>> +
>> +       if (trip >=3D data->ntrips || trip < 0)
>> +               return -EDOM;
>> +
>> +       /* thermal fw should take care of data->mask & (1 << trip) */
>=20
> Could you elaborate on that comment?

In  case the trip is not assigned to be writable, this function won't be
called.


>=20
>> +       data->trips[trip].hysteresis =3D hyst;
>> +
>> +       return 0;
>> +}
>=20
> [...]
>=20
> Thanks,
> Mark.
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--6grSOrNjOiLgIXlU3A1hRSsRHAc4kGbEg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlIcrUsACgkQCXcVR3XQvP3eCwEA6M33yQv93+CfRk3yq94jG3/N
PeqBnzCfCcGafiA7+jEA/2pXahfw5Oicf3h4dnkM5/wMwMES+CRHxJdlG9TnUgix
=9Thi
-----END PGP SIGNATURE-----

--6grSOrNjOiLgIXlU3A1hRSsRHAc4kGbEg--
