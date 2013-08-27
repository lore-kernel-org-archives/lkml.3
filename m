Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab3H0SSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:18:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44454 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306Ab3H0SSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:18:43 -0400
Message-ID: <521CED34.2090008@ti.com>
Date: Tue, 27 Aug 2013 14:17:24 -0400
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
References: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com> <1377299755-5134-3-git-send-email-eduardo.valentin@ti.com> <20130827102205.GC19893@e106331-lin.cambridge.arm.com> <521CAD48.2030306@ti.com> <20130827162309.GR19893@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130827162309.GR19893@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="4CeOFclk5IsASF2cAMSc2x9iwGLxhhRLb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4CeOFclk5IsASF2cAMSc2x9iwGLxhhRLb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 27-08-2013 12:23, Mark Rutland wrote:
> On Tue, Aug 27, 2013 at 02:44:40PM +0100, Eduardo Valentin wrote:
>> Hello Mark,
>>
>>
>> First of all, thanks for taking the time to review in such level of
>> detail. Lets try to align and have a common understanding. Answers go
>> inline. Please let me know if I missed something or if I made it more
>> confusing :-)
>>
>> On 27-08-2013 06:22, Mark Rutland wrote:
>>> Hi,
>>>
>>> On Sat, Aug 24, 2013 at 12:15:43AM +0100, Eduardo Valentin wrote:
>>>> In order to be able to build thermal policies
>>>> based on generic sensors, like I2C device, that
>>>> can be places in different points on different boards,
>>>> there is a need to have a way to feed board dependent
>>>> data into the thermal framework.
>>>>
>>>> This patch introduces a thermal data parser for device
>>>> tree. The parsed data is used to build thermal zones
>>>> and thermal binding parameters. The output data
>>>> can then be used to deploy thermal policies.
>>>>
>>>> This patch adds also documentation regarding this
>>>> API and how to define tree nodes to use
>>>> this infrastructure.
>>>>
>>>> Cc: Zhang Rui <rui.zhang@intel.com>
>>>> Cc: linux-pm@vger.kernel.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>>>> ---
>>>>  .../devicetree/bindings/thermal/thermal.txt        | 160 +++++++
>>>>  drivers/thermal/Kconfig                            |  13 +
>>>>  drivers/thermal/Makefile                           |   1 +
>>>>  drivers/thermal/thermal_dt.c                       | 473 ++++++++++=
+++++++++++
>>>>  include/dt-bindings/thermal/thermal.h              |  27 ++
>>>>  include/linux/thermal.h                            |   3 +
>>>>  6 files changed, 677 insertions(+)
>>>>  create mode 100644 Documentation/devicetree/bindings/thermal/therma=
l.txt
>>>>  create mode 100644 drivers/thermal/thermal_dt.c
>>>>  create mode 100644 include/dt-bindings/thermal/thermal.h
>>>>
>>
>>
>> General question on device tree documentation. Assuming there is such =
an
>> effort to make it Linux independent, is there other places out of Linu=
x
>> tree that these binding must be documented?
>=20
> At present, no. There is a plan to move the documentation out of the
> kernel, but I'm not sure on how that's currently progressing. Some
> general cleanup needs to occur before we can actually do that.
>=20

OK.

>>
>>
>>>> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b=
/Documentation/devicetree/bindings/thermal/thermal.txt
>>>> new file mode 100644
>>>> index 0000000..af20ab0
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
>>>> @@ -0,0 +1,160 @@
>>>> +----------------------------------------
>>>> +Thermal Framework Device Tree descriptor
>>>> +----------------------------------------
>>>> +
>>>> +This file describes how to define a thermal structure using device =
tree.
>>>> +A thermal structure includes thermal zones and their components, su=
ch
>>>> +as name, trip points, polling intervals and cooling devices binding=

>>>> +descriptors. A binding descriptor may contain information on how to=

>>>> +react, with a cooling stepped action or a weight on a fair share.
>>>> +The target of device tree thermal descriptors is to describe only
>>>> +the hardware thermal aspects, not how the system must control or wh=
ich
>>>> +algorithm or policy must take place. It follows a description of ea=
ch
>>>> +type of device tree node.
>>>> +
>>>> +****
>>>> +trip
>>>> +****
>>>> +
>>>> +The trip node is a node to describe a point in the temperature doma=
in
>>>> +in which the system takes an action. This node describes just the p=
oint,
>>>> +not the action.
>>>> +
>>>> +A node describing a trip must contain:
>>>> +- temperature: the trip temperature level, in milliCelsius.
>>>> +- hysteresis: a (low) hysteresis value on 'temperature'. This is a =
relative
>>>> +value, in milliCelsius.
>>>
>>> Presumably this is a single (u32) cell?
>>
>> Yes, both of them above are a single u32.
>=20
> Ok. This seems to be the default assumption in many bindings, so I
> shan't argue against it here, but in general we should be as precise as=

> possible as to the format of the devicetree.
>=20

Yeah, I followed the default assumption. It does not hurt to be
descriptive though.

>>
>>>
>>>> +- type: the trip type. Here is the type mapping:
>>>> +       THERMAL_TRIP_ACTIVE
>>>> +       THERMAL_TRIP_PASSIVE
>>>> +       THERMAL_TRIP_HOT
>>>> +       THERMAL_TRIP_CRITICAL
>>>
>>> What type is this property?
>>>
>>> What are these values? Do you need to refer to a header somewhere?
>>
>> There is a header, introduced in this patch.
>> include/dt-bindings/thermal/thermal.h
>>
>>> Symbolic constants should have an associated value for an ABI.
>>
>> OK. Sounds reasonable to me. Shall we be descriptive and enlist the
>> values in this doc too or just pointing to header is fine?
>=20
> I believe that referring to the header is fine, though personally I'd
> prefer if we were explicit in binding docs. I'll leave Stephen to
> comment on what the preferred way of handling header constants with
> binding documents is.
>=20

OK. I will do both.

>>
>>>
>>>> +
>>>> +**********
>>>> +bind_param
>>>> +**********
>>>> +
>>>> +The bind_param node is a node to describe how cooling devices get a=
ssigned
>>>> +to trip points of the zone. The cooling devices are expected to be =
loaded
>>>> +in the target system.
>>>> +
>>>> +A node describing a bind_param must contain:
>>>> +- cooling_device: A string with the cooling device name.
>>>
>>> Please use '-' rather than '_' in bindings. That's the normal devicet=
ree
>>> convention, and there's no point gonig against it and causing more
>>> confusion.
>>
>> Agreed.
>>
>>>
>>> What are valid values of this string, and what do they mean?
>>
>> These are the name of the cooling devices to match to.
>=20
> Which are what exactly? What constitutes a "cooling device"?
>=20
> Is "black-body radiation" [1] a valid cooling device?
>=20
> How about "copper heat sink"?
>=20

Those are example of cooling devices, yes. But in this context what is
interesting is those devices that allow you to control the amount of
dissipated power, i.e. operating frequency/voltage, lcd brightness,
audio volume, radio transmission power, or if those that you burn power
by turning them on but you remove heat out of your thermal zone, like a
speed controllable fan.

>>
>>>
>>> Why not a phandle + cells binding to cooling devices?
>>>
>>
>> Yeah, this could work too. I am going to check how that would look lik=
e
>> and come back to you.
>=20
> Ok.
>=20
>>
>>>> +- weight: The 'influence' of a particular cooling device on this zo=
ne.
>>>> +             This is on a percentage scale. The sum of all these we=
ights
>>>> +             (for a particular zone) cannot exceed 100.
>>>
>>> This is a bit fuzzy, and certainly needs more guidance.
>>
>> OK. This property is used to describe the amount of cooling contributi=
on
>> when activating a cooling device at a certain trip point. I will work =
on
>> a better guidance.
>>
>>>
>>>> +- trip_mask: This is a bit mask that gives the binding relation bet=
ween
>>>> +               this thermal zone and cdev, for a particular trip po=
int.
>>>> +               If nth bit is set, then the cdev and thermal zone ar=
e bound
>>>> +               for trip point n.
>>>
>>> What type is this?
>>>
>>> The nth bit from which end?
>>>
>>> Could you explain what "bound for trip point n" means?
>>>
>>
>> It is just a way to match a cooling device with a set of trip points.
>> Say you want to match one specific cooling device with trips 0 and 1,
>> you would then create a bind_param with trip_mask =3D 0x3.
>>
>>> Just because this is a bitmask in Linux does not mean it needs to be =
so
>>> in the dt.
>>
>> Indeed.
>>
>> In case we work with phandle + cell binging parameters, the trip and
>> weight could be passed as params.
>>
>>       cooling-devices =3D <&devX tripY weightZ>, <... >;
>=20
> Something like that could certainly work.

I see. I will check that option.

>=20
>>
>>>
>>>> +- limits: An array integers consisting of 2-tuples items, and each =
item means
>>>> +  lower and upper state limits, like <min-state max-state>.
>>>> +
>>>> +**************************
>>>> +temperature sensor devices
>>>> +**************************
>>>> +
>>>> +Temperature sensor devices have to be linked to a specific thermal =
zone.
>>>> +This is done by means of the 'monitored-zones' list.
>>>> +- monitored-zones: A list of thermal zones phandles, identifying wh=
ich
>>>> +thermal zones the temperature sensor device is used to monitor.
>>>
>>> Why does this need to be described that way around?
>>>
>>> Can the zone not have a link to the sensor(s) it needs?
>>>
>>
>> Do you see any issues with it?
>>
>> Idea is that sensor nodes would list which zones they are used.  Same
>> idea goes to cooling devices. It can be the other way around, yes. It
>> depends on what is the best way to describe these relations. Idea woul=
d
>> be so that sensors and cooling devices would be composing a thermal zo=
ne.
>=20
> I think that having a zone refer to the sensors that monitor it would b=
e
> preferable. Otherwise we're encoding that way a devices output is to be=

> consumed on the binding for the device itself, which feels odd (it's
> arguable as to whether it's a property of the device, however).
>=20

I got confused now. How adding a monitored-zones property on sensor's
nodes would imply that device's output is to be consumed on the binding
for the device itself?

>>
>>>> +
>>>> +************
>>>> +thermal_zone
>>>> +************
>>>> +
>>>> +The thermal_zone node is the node containing all the required info
>>>> +for describing a thermal zone, including its cdev bindings. The the=
rmal_zone
>>>> +node must contain, apart from its own properties, one node containi=
ng
>>>> +trip nodes and one node containing all the zone bind parameters.
>>>> +
>>>> +Required properties:
>>>> +- mask: Bit string: If 'n'th bit is set, then trip point 'n' is wri=
teable.
>>>
>>> What type is a bit string in devicetree? I'm aware of cells and (byte=
)
>>> strings, but not bit strings.
>>>
>>> What does 'writeable' mean in this context?
>>>
>>> There's presumably a better name than 'mask'.
>>>
>>
>> This is used to describe if trip points are writeable under sysfs. I
>> think this is a OS implementation leak. I will be removing this from
>> device tree and making them RO by default.
>=20
> Ok.
>=20
>>
>>>> +
>>>> +- passive_delay: number of milliseconds to wait between polls when
>>>> +  performing passive cooling.
>>>> +
>>>> +- polling_delay: number of milliseconds to wait between polls when =
checking.
>>>
>>> These sound very much like configuration of the driver rather than
>>> hardware description. What if my temperature sensor can generate an
>>> interrupt at some trigger temperature? Why would I need polling times=
?
>>>
>>> Why does this need to be in the dt at all? Surely the OS can choose s=
ome
>>> sensible polling period, possibly dynamically?
>>
>> Well, let me answer this one with another question. How the OS will
>> determine how fast is the temperature rise on a thermal zone described=

>> in device tree?
>=20
> How will the devicetree writer determine this?
>=20
> It's possible for the thermal management code to dynamically adjust the=

> rate between some extreme polling intervals based on how big a rise it
> detects between polls or possibly something more complex taking into
> account some metric for load.

It is possible yes, by means of a couple of complex differential
equations implementation.  But still, determining the maximum dT/dt may
require unnecessary polling on low activity use cases. Besides, people
who do transient thermal simulation should have a better estimate on
necessary polling requirement. I don't see why we should not use that
handy info and impose hard software requirements.

>=20
>>
>>>
>>>> +
>>>> +- #thermal-cells: An integer that is used to specify how many cells=
 compose
>>>> +  sensor ids.
>>>
>>> I don't see why this is necessary. If the zone itself described its
>>> related sensors rather than the other way around, we wouldn't need it=
 at
>>> all. Most bindings so far have consumers link to their providers rath=
er
>>> than the other way around.
>>>
>>
>> I see.
>>
>>
>>>> +
>>>> +Below is an example:
>>>> +cpu_thermal: thermal_zone {
>>>> +            #thermal-cells =3D <1>;
>>>> +            mask =3D <0x03>; /* trips writability */
>>>> +            passive_delay =3D <250>; /* milliseconds */
>>>> +            polling_delay =3D <1000>; /* milliseconds */
>>>> +            trips {
>>>> +                    alert@100000{
>>>> +                            temperature =3D <100000>; /* milliCelsi=
us */
>>>> +                            hysteresis =3D <0>; /* milliCelsius */
>>>> +                            type =3D <THERMAL_TRIP_PASSIVE>;
>>>> +                    };
>>>> +                    crit@125000{
>>>> +                            temperature =3D <125000>; /* milliCelsi=
us */
>>>> +                            hysteresis =3D <0>; /* milliCelsius */
>>>> +                            type =3D <THERMAL_TRIP_CRITICAL>;
>>>> +                    };
>=20
> I didn't spot this on my first round, but the trips node will need
> #address-cells and #size-cells, and the sub nodes unit-addresses should=

> match their reg properties.

You mean, thermal zones must have address and size cells to describe trip=
s?

>=20
>>>> +            };
>>>> +            bind_params {
>>>> +                    action@0{
>>>> +                            cooling_device =3D "thermal-cpufreq";
>>>
>>> NAK. That value was not defined anywhere, and represents Linux
>>> infrastructure rather than hardware.
>>>
>>
>> Yes, this was another leak as discussed above in the upper part of the=

>> doc file.
>>
>>> For this case, we could just as easily describe the thermal points, a=
nd
>>> if no physical cooling device (e.g. a fan) is present, assume
>>> cpufreq-base cooling.  Other OSs could choose to do otherwise, and we=

>>> could change later...
>>>
>>
>> The way other specifications do (aka ACPI) is to have trip types. In
>> case a trip type is passive cooling, it means one is supposed to
>> modulate the dissipated power rather than activating a device to remov=
e
>> heat (active cooling).
>>
>> The part of 'assuming' things that bothers me. I would rather have a w=
ay
>> to really say one wants to have passive cooling at a specific trip poi=
nt.
>=20
> I don't see the problem here. If you don't specify a device, your only
> options will be some sort of passive management.

But it does not need to be active all the time. You need to say when (in
temperature domain) that is need. Besides, there are even other means of
managing average power other than cpufreq cooling. idle injections is
another passive cooling device, for instance.

>=20
>>
>>
>>>> +                            weight =3D <100>; /* percentage */
>>>> +                            mask =3D <0x01>;
>>>
>>> This should presumably be trip-mask (assuming my suggested correction=
s).
>>>
>>> What is it supposed to mean here?
>>
>> As stated above, it means the trip points that this binding represents=
=2E
>=20
> If you have more than 32 trip points (which is admittedly unlikely), ho=
w
> do you represent them? I'm not sure a mask is the best representation
> here, as it's difficult for a human to match up with a list of entries.=

>=20
> Additionally, the trip points don't have a logical contiguous numbering=

> from zero, so how do the bits in the mask correspond to entries in the
> list? This seems to rely on the order that the subnodes are in, which
> AFAIK is not guaranteed. It would be far nicer to have an explicit
> linkage.


Do you mean some sort of list of trip points property inside binding
params node?

>=20
>>
>>>
>>>> +                           limits =3D <
>>>> +                             /* lower-state            upper-state =
*/
>>>> +                               1                       THERMAL_NO_L=
IMITS
>>>> +                               THERMAL_NO_LIMITS       THERMAL_NO_L=
IMITS
>>>> +                           >;
>>>> +                    };
>>>> +            };
>>>> +};
>>>> +
>>>> +sensor: adc@0xFFFF {
>>>> +       ...
>>>> +       monitored-zones =3D <&cpu_thermal 0>;
>>>> +};
>>>> +
>>>> +cpu@0 {
>>>> +       ...
>>>> +       cooling-zones =3D <&cpu_thermal>;
>>>> +};
>>>> +
>>>> +In the example above, the ADC sensor at address 0xFFFF is used to m=
onitor
>>>> +the zone 'cpu_thermal' using its the sensor 0. The cpu@0 device is =
also linked
>>>> +to the same thermal zone 'cpu_thermal' as a cooling device.
>>>
>>> Huh? That seems to imply the the '0' in '<&cpu_thermal 0>' on the sen=
sor
>>> node describes a property of the sensor rather than the thermal node,=

>>> unless I've misunderstood?
>>>
>>
>> It is essentially which sensor id is used to monitor a specific zone. =
In
>> case of sensor IPs that feature several internal sensors, one needs to=

>> have a way to describe which sensor monitors which zone. Example of th=
is
>> type of IPs: lm90 (up to 3 sensors) and TI bandgap IP (can contain up =
to
>> 5 internal sensors). The probe happens for the IP device and not for t=
he
>> internal sensors.
>=20
> Which is exactly why this should be the opposite way round, with therma=
l
> zones referring to sensors in this fashion.
>=20
> The way you're suggesting means that the phandle+cells specifier refers=

> half to the consumer and half to the producer. Having thermal zones
> refer to sensors would make this refer solely to the producer (the
> sensor).
>=20

Are you suggesting having inside thermal zone node:

	sensors =3D <&sensor0 Y>, ...., <&sensorN Z> ;

Where sensor0 and sensorN are sensor IPs nodes and Y and Z represent
their internal sensor instances?

>>
>>
>>>> +
>>>> +***************
>>>> +cpufreq-cooling
>>>> +***************
>>>> +
>>>> +The generic cpu cooling (freq clipping) can be loaded by the
>>>> +generic cpufreq-cpu0 driver in case the device tree node informs
>>>> +this need.
>>>> +
>>>> +In order to load the cpufreq cooling device, it is possible to
>>>> +inform that the cpu needs cooling by adding the list of thermal zon=
es
>>>> +in the 'cooling-zones' property at the cpu0 phandle.
>>>
>>> This should be reworded so as to describe the binding rather than the=

>>> Linux behaviour based on the binding.
>>
>> OK.
>>
>>>
>>>> +
>>>> +Example:
>>>> +       cpus {
>>>> +               cpu@0 {
>>>> +                       operating-points =3D <
>>>> +                               /* kHz    uV */
>>>> +                               800000  1313000
>>>> +                               1008000 1375000
>>>> +                       >;
>>>> +                       cooling-zones =3D <&cpu_thermal>;
>>>> +               };
>>>> +       ...
>>>> +       };
>>>> +
>>>> +The above will cause the cpufreq-cpu0 driver to understand that
>>>> +the cpu will need passive cooling and while probing that node it wi=
ll
>>>> +also load the cpufreq cpu cooling device in that system.
>>>
>>> The above describe that the CPU is part of a cooling (thermal?) zone =
and
>>> requires cooling.
>>
>> That says the cpu participates in a thermal zone as a cooling
>> device/mechanism, thus cpu cooling (passive cooling) is required in
>> target system.
>=20
> I think you need the rest of the nodes in this example. You don't show
> whether or not there's a cooling-device, so it's not clear that the CPU=

> is required to be passively cooled...

The property states the cpu is used as cooling device for those thermal
zones in the list 'cooling-zones'

>=20
>>
>>>
>>>> +
>>>> +However, be advised that this flag will not describe what needs to
>>>> +be done or how the cpufreq cooling device will be used. In order to=

>>>> +accomplish this, one needs to write a phandle for a thermal zone, a=
s
>>>> +described in the section 'thermal_zone'.
>>>
>>> The above already has a phandle to a thermal (cooling?) zone.
>>>
>>> Please choose either cooling zone or thermal zone, having the two nam=
es
>>> makes this more confusing than necessary.
>>
>> I see. Idea is to have thermal zone as a node. cooling-zone is just a
>> list of thermal zones that the referred device will be used as cooling=

>> device.
>=20
> While I can see a distinction, the nomenclature is horrendously
> confusing.


OK. I will try harder to improve it.

>=20
>>
>>>
>>>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>>>> index 7fb16bc..753f0dc 100644
>>>> --- a/drivers/thermal/Kconfig
>>>> +++ b/drivers/thermal/Kconfig
>>>> @@ -29,6 +29,19 @@ config THERMAL_HWMON
>>>>           Say 'Y' here if you want all thermal sensors to
>>>>           have hwmon sysfs interface too.
>>>>
>>>> +config THERMAL_OF
>>>> +       bool
>>>> +       prompt "APIs to parse thermal data out of device tree"
>>>> +       depends on OF
>>>> +       default y
>>>> +       help
>>>> +         This options provides helpers to add the support to
>>>> +         read and parse thermal data definitions out of the
>>>> +         device tree blob.
>>>> +
>>>> +         Say 'Y' here if you need to build thermal infrastructure
>>>> +         based on device tree.
>>>> +
>>>>  choice
>>>>         prompt "Default Thermal governor"
>>>>         default THERMAL_DEFAULT_GOV_STEP_WISE
>>>> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
>>>> index 24cb894..eedb273 100644
>>>> --- a/drivers/thermal/Makefile
>>>> +++ b/drivers/thermal/Makefile
>>>> @@ -7,6 +7,7 @@ thermal_sys-y                   +=3D thermal_core.o
>>>>
>>>>  # interface to/from other layers providing sensors
>>>>  thermal_sys-$(CONFIG_THERMAL_HWMON)            +=3D thermal_hwmon.o=

>>>> +thermal_sys-$(CONFIG_THERMAL_OF)               +=3D thermal_dt.o
>>>>
>>>>  # governors
>>>>  thermal_sys-$(CONFIG_THERMAL_GOV_FAIR_SHARE)   +=3D fair_share.o
>>>> diff --git a/drivers/thermal/thermal_dt.c b/drivers/thermal/thermal_=
dt.c
>>>> new file mode 100644
>>>> index 0000000..cc35485
>>>> --- /dev/null
>>>> +++ b/drivers/thermal/thermal_dt.c
>>>> @@ -0,0 +1,473 @@
>>>> +/*
>>>> + *  thermal_dt.c - Generic Thermal Management device tree support.
>>>> + *
>>>> + *  Copyright (C) 2013 Texas Instruments
>>>> + *  Copyright (C) 2013 Eduardo Valentin <eduardo.valentin@ti.com>
>>>> + *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~
>>>> + *
>>>> + *  This program is free software; you can redistribute it and/or m=
odify
>>>> + *  it under the terms of the GNU General Public License as publish=
ed by
>>>> + *  the Free Software Foundation; version 2 of the License.
>>>> + *
>>>> + *  This program is distributed in the hope that it will be useful,=
 but
>>>> + *  WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the G=
NU
>>>> + *  General Public License for more details.
>>>> + *
>>>> + *  You should have received a copy of the GNU General Public Licen=
se along
>>>> + *  with this program; if not, write to the Free Software Foundatio=
n, Inc.,
>>>> + *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
>>>> + *
>>>> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~
>>>> + */
>>>> +#include <linux/thermal.h>
>>>> +#include <linux/slab.h>
>>>> +#include <linux/types.h>
>>>> +#include <linux/of_device.h>
>>>> +#include <linux/of_platform.h>
>>>> +#include <linux/err.h>
>>>> +#include <linux/export.h>
>>>> +#include <linux/string.h>
>>>> +
>>>> +struct __thermal_bind_params {
>>>> +       char cooling_device[THERMAL_NAME_LENGTH];
>>>> +};
>>>> +
>>>> +static
>>>> +int thermal_of_match(struct thermal_zone_device *tz,
>>>> +                    struct thermal_cooling_device *cdev);
>>>> +
>>>> +static int thermal_of_populate_bind_params(struct device *dev,
>>>> +                                          struct device_node *node,=

>>>> +                                          struct __thermal_bind_par=
ams *__tbp,
>>>> +                                          struct thermal_bind_param=
s *tbp,
>>>> +                                          int ntrips)
>>>> +{
>>>> +       const char *cdev_name;
>>>> +       u32 *limits;
>>>> +       int ret;
>>>> +       u32 prop;
>>>> +
>>>> +       ret =3D of_property_read_u32(node, "weight", &prop);
>>>> +       if (ret < 0) {
>>>> +               dev_err(dev, "missing weight property\n");
>>>> +               return ret;
>>>> +       }
>>>> +       tbp->weight =3D prop;
>>>> +
>>>> +       ret =3D of_property_read_u32(node, "mask", &prop);
>>>> +       if (ret < 0) {
>>>> +               dev_err(dev, "missing mask property\n");
>>>> +               return ret;
>>>> +       }
>>>> +       tbp->trip_mask =3D prop;
>>>> +
>>>> +       /* this will allow us to bind with cooling devices */
>>>> +       tbp->match =3D thermal_of_match;
>>>> +
>>>> +       ret =3D of_property_read_string(node, "cooling_device", &cde=
v_name);
>>>> +       if (ret < 0) {
>>>> +               dev_err(dev, "missing cooling_device property\n");
>>>> +               return ret;
>>>> +       }
>>>> +       strncpy(__tbp->cooling_device, cdev_name,
>>>> +               sizeof(__tbp->cooling_device));
>>>> +
>>>> +       limits =3D kzalloc(ntrips * sizeof(*limits) * 2, GFP_KERNEL)=
;
>>>
>>> Why do you use kzalloc here, but devm_kzalloc elsewhere? That'll lead=
 to
>>> problems as the driver gets refactored over time.
>>
>> Because this memory is used only  within this function and thus releas=
ed
>> at the bottom of it.
>>
>>>
>>>> +       if (!limits) {
>>>> +               dev_err(dev, "not enough mem for reading limits\n");=

>>>> +               return -ENOMEM;
>>>> +       }
>>>> +       ret =3D of_property_read_u32_array(node, "limits", limits, 2=
 * ntrips);
>>>> +       if (!ret) {
>>>> +               int i =3D ntrips;
>>>> +
>>>> +               tbp->binding_limits =3D devm_kzalloc(dev,
>>>> +                                                  ntrips * 2 *
>>>> +                                                  sizeof(*tbp->bind=
ing_limits),
>>>> +                                                  GFP_KERNEL);
>>>> +               if (!tbp->binding_limits) {
>>>> +                       dev_err(dev, "not enough mem for storing lim=
its\n");
>>>> +                       return -ENOMEM;
>>>> +               }
>>>> +               while (i--)
>>>> +                       tbp->binding_limits[i] =3D limits[i];
>>>> +       }
>>>> +       kfree(limits);
>>
>> here.
>=20
> I saw that, I did say that this may lead to problems in future if the
> function's reorganised, not now. :)

Ahh.. OK. I just didnt want o let the memory be managed and freed only
when the struct device is release.

>=20
>>
>>>> +
>>>> +       return 0;
>>>
>>> What if you failed to read the array? Surely you should return an err=
or?
>>
>> Attempting to make this property not mandatory.
>=20
> That wasn't clear from the binding, and now I've re-read it, I'm still
> not entirely clear on what the limits represent, and why you may have
> multiple sets of pairs.

Because you may assign cooling state limits to specific trip points,
e.g., a fan with 5 different speeds would operate from speed 0 to 2 in
the first trip point, while from speed 3 to 4 on last trip point.

>=20
>>
>>>
>>>> +}
>>>> +
>>>> +struct __thermal_trip {
>>>> +       unsigned long int temperature;
>>>> +       unsigned long int hysteresis;
>>>> +       enum thermal_trip_type type;
>>>> +};
>>>> +
>>>> +static
>>>> +int thermal_of_populate_trip(struct device *dev,
>>>> +                            struct device_node *node,
>>>> +                            struct __thermal_trip *trip)
>>>> +{
>>>> +       int ret;
>>>> +       int prop;
>>>> +
>>>> +       ret =3D of_property_read_u32(node, "temperature", &prop);
>>>> +       if (ret < 0) {
>>>> +               dev_err(dev, "missing temperature property\n");
>>>> +               return ret;
>>>> +       }
>>>> +       trip->temperature =3D prop;
>>>> +
>>>> +       ret =3D of_property_read_u32(node, "hysteresis", &prop);
>>>> +       if (ret < 0) {
>>>> +               dev_err(dev, "missing hysteresis property\n");
>>>> +               return ret;
>>>> +       }
>>>> +       trip->hysteresis =3D prop;
>>>> +
>>>> +       ret =3D of_property_read_u32(node, "type", &prop);
>>>> +       if (ret < 0) {
>>>> +               dev_err(dev, "missing type property\n");
>>>> +               return ret;
>>>> +       }
>>>> +       trip->type =3D prop;
>>>
>>> This will require sanity checking.
>>
>> OK.
>>
>>>
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +struct __thermal_zone_device {
>>>> +       enum thermal_device_mode mode;
>>>> +       int passive_delay;
>>>> +       int polling_delay;
>>>> +       int mask;
>>>> +       int ntrips;
>>>> +       char type[THERMAL_NAME_LENGTH];
>>>> +       struct __thermal_trip *trips;
>>>> +       struct __thermal_bind_params *bind_params;
>>>> +       struct thermal_bind_params *tbps;
>>>> +       struct thermal_zone_params zone_params;
>>>> +       int (*get_temp)(void *, unsigned long *);
>>>> +       void *devdata;
>>>> +};
>>>> +
>>>> +static struct __thermal_zone_device *
>>>> +thermal_of_build_thermal_zone(struct device *dev, struct device_nod=
e *node)
>>>> +{
>>>> +       struct device_node *child, *gchild;
>>>> +       struct __thermal_zone_device *tz;
>>>> +       int ret, i;
>>>> +       u32 prop;
>>>> +
>>>> +       if (!node) {
>>>> +               dev_err(dev, "no thermal zone node\n");
>>>> +               return ERR_PTR(-EINVAL);
>>>> +       }
>>>> +
>>>> +       tz =3D devm_kzalloc(dev, sizeof(*tz), GFP_KERNEL);
>>>> +       if (!tz) {
>>>> +               dev_err(dev, "not enough memory for thermal of zone\=
n");
>>>> +               return ERR_PTR(-ENOMEM);
>>>> +       }
>>>> +
>>>> +       ret =3D of_property_read_u32(node, "passive_delay", &prop);
>>>> +       if (ret < 0) {
>>>> +               dev_err(dev, "missing passive_delay property\n");
>>>> +               return ERR_PTR(ret);
>>>> +       }
>>>> +       tz->passive_delay =3D prop;
>>>> +
>>>> +       ret =3D of_property_read_u32(node, "polling_delay", &prop);
>>>> +       if (ret < 0) {
>>>> +               dev_err(dev, "missing polling_delay property\n");
>>>> +               return ERR_PTR(ret);
>>>> +       }
>>>> +       tz->polling_delay =3D prop;
>>>> +
>>>> +       ret =3D of_property_read_u32(node, "mask", &prop);
>>>> +       if (ret < 0) {
>>>> +               dev_err(dev, "missing mask property\n");
>>>> +               return ERR_PTR(ret);
>>>> +       }
>>>> +       tz->mask =3D prop;
>>>> +
>>>> +       /* assume node name as our zone type */
>>>> +       strncpy(tz->type, node->name, sizeof(tz->type));
>>>> +
>>>> +       /* default policy */
>>>> +       strncpy(tz->zone_params.governor_name, "step_wise",
>>>> +               sizeof(tz->zone_params.governor_name));
>>>> +
>>>> +       /* trips */
>>>> +       child =3D of_find_node_by_name(node, "trips");
>>>
>>> That might not be a child node, as of_find_node_by_name walks over th=
e
>>> list of all nodes. Use of_get_child_by_name.
>>
>> Right! This is a bug.
>>
>>>
>>>> +
>>>> +       /* No trips provided */
>>>> +       if (!child)
>>>> +               goto finish;
>>>> +
>>>> +       tz->ntrips =3D of_get_child_count(child);
>>>> +       tz->trips =3D devm_kzalloc(dev, tz->ntrips * sizeof(*tz->tri=
ps),
>>>> +                                GFP_KERNEL);
>>>> +       if (!tz->trips)
>>>> +               return ERR_PTR(-ENOMEM);
>>>> +       i =3D 0;
>>>> +       for_each_child_of_node(child, gchild)
>>>> +               thermal_of_populate_trip(dev, gchild, &tz->trips[i++=
]);
>>>
>>> What if a child node was not a valid trip node? It seems
>>> thermal_of_populate_trip returns errors you're ignoring.
>>
>> OK. Adding proper treatment.
>>
>>>
>>>> +
>>>> +       /* bind_params */
>>>> +       child =3D of_find_node_by_name(node, "bind_params");
>>>
>>> Another of_get_child_by_name candidate.
>>
>> OK.
>>
>>>
>>>> +
>>>> +       /* No binding info */
>>>> +       if (!child)
>>>> +               goto finish;
>>>> +
>>>> +       tz->zone_params.num_tbps =3D of_get_child_count(child);
>>>> +       tz->bind_params =3D devm_kzalloc(dev,
>>>> +                                      tz->zone_params.num_tbps *
>>>> +                                               sizeof(*tz->bind_par=
ams),
>>>> +                                      GFP_KERNEL);
>>>> +       if (!tz->bind_params)
>>>> +               return ERR_PTR(-ENOMEM);
>>>> +       tz->zone_params.tbp =3D devm_kzalloc(dev,
>>>> +                                          tz->zone_params.num_tbps =
*
>>>> +                                               sizeof(*tz->zone_par=
ams.tbp),
>>>> +                                          GFP_KERNEL);
>>>> +       if (!tz->zone_params.tbp)
>>>> +               return ERR_PTR(-ENOMEM);
>>>> +       i =3D 0;
>>>> +       for_each_child_of_node(child, gchild) {
>>>> +               thermal_of_populate_bind_params(dev, gchild,
>>>> +                                               &tz->bind_params[i],=

>>>> +                                               &tz->zone_params.tbp=
[i],
>>>> +                                               tz->ntrips);
>>>
>>> Similarly, you're ignoring error conditions here. What if a bind_para=
ms
>>> node was malformed?
>>
>>
>> Adding proper error handling.
>>
>>>
>>>> +               i++;
>>>> +       }
>>>> +
>>>> +finish:
>>>> +       tz->mode =3D THERMAL_DEVICE_ENABLED;
>>>> +
>>>> +       return tz;
>>>> +}
>>>> +
>>>> +static
>>>> +int thermal_of_match(struct thermal_zone_device *tz,
>>>> +                    struct thermal_cooling_device *cdev)
>>>> +{
>>>> +       struct __thermal_zone_device *data =3D tz->devdata;
>>>> +       int i;
>>>> +
>>>> +       for (i =3D 0; i < data->zone_params.num_tbps; i++) {
>>>> +               if (!strncmp(data->bind_params[i].cooling_device,
>>>> +                            cdev->type,
>>>> +                            strlen(data->bind_params[i].cooling_dev=
ice)) &&
>>>> +                   (data->zone_params.tbp[i].trip_mask & (1 << i)))=

>>>> +                       return 0;
>>>> +       }
>>>> +
>>>> +       return -EINVAL;
>>>> +}
>>>
>>> I'm not keen on binding to cooling devices using a string, as suddenl=
y a
>>> name to allow humans to inspect the system is turned into an ABI.
>>
>> OK. We need to align on how we describe the binding then.
>=20
> Definitely. We need to ensure that we fully define the relationship too=

> cooling devices, and don't suddenly expose some piece of internal Linux=

> infrastructure to the world.
>=20

Yeah, agreed, any suggestions?

>>
>>>
>>>> +
>>>> +static
>>>> +int of_thermal_get_temp(struct thermal_zone_device *tz,
>>>> +                       unsigned long *temp)
>>>> +{
>>>> +       struct __thermal_zone_device *data =3D tz->devdata;
>>>> +
>>>> +       return data->get_temp(data->devdata, temp);
>>>> +}
>>>> +
>>>> +static
>>>> +int of_thermal_get_mode(struct thermal_zone_device *tz,
>>>> +                       enum thermal_device_mode *mode)
>>>> +{
>>>> +       struct __thermal_zone_device *data =3D tz->devdata;
>>>> +
>>>> +       *mode =3D data->mode;
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static
>>>> +int of_thermal_set_mode(struct thermal_zone_device *tz,
>>>> +                       enum thermal_device_mode mode)
>>>> +{
>>>> +       struct __thermal_zone_device *data =3D tz->devdata;
>>>> +
>>>> +       mutex_lock(&tz->lock);
>>>> +
>>>> +       if (mode =3D=3D THERMAL_DEVICE_ENABLED)
>>>> +               tz->polling_delay =3D data->polling_delay;
>>>> +       else
>>>> +               tz->polling_delay =3D 0;
>>>> +
>>>> +       mutex_unlock(&tz->lock);
>>>> +
>>>> +       data->mode =3D mode;
>>>> +       thermal_zone_device_update(tz);
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static
>>>> +int of_thermal_get_trip_type(struct thermal_zone_device *tz, int tr=
ip,
>>>> +                            enum thermal_trip_type *type)
>>>> +{
>>>> +       struct __thermal_zone_device *data =3D tz->devdata;
>>>> +
>>>> +       if (trip >=3D data->ntrips || trip < 0)
>>>> +               return -EDOM;
>>>
>>> It's far more common to use -EINVAL.
>>
>> hmm.. OK.
>>
>>>
>>>> +
>>>> +       *type =3D data->trips[trip].type;
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static
>>>> +int of_thermal_get_trip_temp(struct thermal_zone_device *tz, int tr=
ip,
>>>> +                            unsigned long *temp)
>>>> +{
>>>> +       struct __thermal_zone_device *data =3D tz->devdata;
>>>> +
>>>> +       if (trip >=3D data->ntrips || trip < 0)
>>>> +               return -EDOM;
>>>> +
>>>> +       *temp =3D data->trips[trip].temperature;
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static
>>>> +int of_thermal_set_trip_temp(struct thermal_zone_device *tz, int tr=
ip,
>>>> +                            unsigned long temp)
>>>> +{
>>>> +       struct __thermal_zone_device *data =3D tz->devdata;
>>>> +
>>>> +       if (trip >=3D data->ntrips || trip < 0)
>>>> +               return -EDOM;
>>>> +
>>>> +       /* thermal fw should take care of data->mask & (1 << trip) *=
/
>>>> +       data->trips[trip].temperature =3D temp;
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static
>>>> +int of_thermal_get_trip_hyst(struct thermal_zone_device *tz, int tr=
ip,
>>>> +                            unsigned long *hyst)
>>>> +{
>>>> +       struct __thermal_zone_device *data =3D tz->devdata;
>>>> +
>>>> +       if (trip >=3D data->ntrips || trip < 0)
>>>> +               return -EDOM;
>>>> +
>>>> +       *hyst =3D data->trips[trip].hysteresis;
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static
>>>> +int of_thermal_set_trip_hyst(struct thermal_zone_device *tz, int tr=
ip,
>>>> +                            unsigned long hyst)
>>>> +{
>>>> +       struct __thermal_zone_device *data =3D tz->devdata;
>>>> +
>>>> +       if (trip >=3D data->ntrips || trip < 0)
>>>> +               return -EDOM;
>>>> +
>>>> +       /* thermal fw should take care of data->mask & (1 << trip) *=
/
>>>
>>> Could you elaborate on that comment?
>>
>> In  case the trip is not assigned to be writable, this function won't =
be
>> called.
>=20
> Ah. I misunderstood "fw" as "firmware", rather than "framework", and go=
t
> confused. It would be nice if you could expand "fw" to make this
> clearer. :)

Sorry for that :-)

>=20
> Thanks,
> Mark.
>=20
> [1] http://en.wikipedia.org/wiki/Black-body_radiation
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--4CeOFclk5IsASF2cAMSc2x9iwGLxhhRLb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlIc7TcACgkQCXcVR3XQvP1pxwEAjKhS56wCnI/rkZd9bDxsuguV
cuKIXcOqRLVOou/OIqAA/2l+pXrZMyR0pmMMqv7xdPXgrmOlYZLfpoad9OUmlrVN
=q8ZE
-----END PGP SIGNATURE-----

--4CeOFclk5IsASF2cAMSc2x9iwGLxhhRLb--
