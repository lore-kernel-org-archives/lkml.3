Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3IWPko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:40:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52796 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab3IWPkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:40:41 -0400
Message-ID: <524060A5.1010808@ti.com>
Date: Mon, 23 Sep 2013 11:39:17 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "wni@nvidia.com" <wni@nvidia.com>, "joe@perches.com" <joe@perches.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCHv6 02/16] drivers: thermal: introduce device tree parser
References: <1379537849-28425-1-git-send-email-eduardo.valentin@ti.com> <1379540136-28378-1-git-send-email-eduardo.valentin@ti.com> <20130923104003.GA16069@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130923104003.GA16069@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="QcNMjuJbmFunaNC2CmOsaqtsxTTW4SGJS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--QcNMjuJbmFunaNC2CmOsaqtsxTTW4SGJS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable



On 23-09-2013 06:40, Mark Rutland wrote:
> Hi Eduardo,
>=20

Hi Mark,

> Apologies for having taken so long to get back you on this.
>=20

Well, at least we are keeping it up somehow. I just would like to have
an agreement, at least for the binding part, as I mentioned before.

> I have several comments on the binding and the way it's parsed.

OK. I will try to clarify that.

>=20
> On Wed, Sep 18, 2013 at 10:35:36PM +0100, Eduardo Valentin wrote:
>> This patch introduces a device tree bindings for
>> describing the hardware thermal behavior and limits.
>> Also a parser to read and interpret the data and feed
>> it in the thermal framework is presented.
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
>> Note that, in order to be able to have control
>> on the sensor registration on the DT thermal zone,
>> it was required to allow changing the thermal zone
>> .get_temp callback. For this reason, this patch
>> also removes the 'const' modifier from the .ops
>> field of thermal zone devices.
>>
>> Cc: Zhang Rui <rui.zhang@intel.com>
>> Cc: linux-pm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> ---
>>  .../devicetree/bindings/thermal/thermal.txt        | 498 ++++++++++++=
+
>>  drivers/thermal/Kconfig                            |  13 +
>>  drivers/thermal/Makefile                           |   1 +
>>  drivers/thermal/of-thermal.c                       | 775 ++++++++++++=
+++++++++
>>  drivers/thermal/thermal_core.c                     |   9 +-
>>  drivers/thermal/thermal_core.h                     |   9 +
>>  include/dt-bindings/thermal/thermal.h              |  27 +
>>  include/linux/thermal.h                            |  28 +-
>>  8 files changed, 1357 insertions(+), 3 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/thermal/thermal.=
txt
>>  create mode 100644 drivers/thermal/of-thermal.c
>>  create mode 100644 include/dt-bindings/thermal/thermal.h
>>
>> ---
>>
>> Hello all,
>>
>> Thanks Joe Perches for the effort of reviewing this code, I really app=
reciate it.
>>
>> Here is a version with a refactored init function without leaks in the=
 failure
>> patch. I also added a couple of comments to better understand the inte=
ntion of
>> that function. Besides, when there are no memory available, the functi=
on
>> rolls back what ever thermal zones have been added.
>>
>> Thanks,
>>
>> Eduardo
>>
>> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/D=
ocumentation/devicetree/bindings/thermal/thermal.txt
>> new file mode 100644
>> index 0000000..6664533
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
>> @@ -0,0 +1,498 @@
>> +* Thermal Framework Device Tree descriptor
>> +
>> +Generic binding to provide a way of defining hardware thermal
>> +structure using device tree. A thermal structure includes thermal
>> +zones and their components, such as trip points, polling intervals,
>> +sensors and cooling devices binding descriptors.
>> +
>> +The target of device tree thermal descriptors is to describe only
>> +the hardware thermal aspects, not how the system must control or whic=
h
>> +algorithm or policy must be taken in place.
>> +
>> +There are five types of nodes involved to describe thermal bindings:
>> +- sensors: used to describe the device source of temperature sensing;=

>> +- cooling devices: used to describe devices source of power dissipati=
on control;
>> +- trip points: used to describe points in temperature domain defined =
to
>> +make the system aware of hardware limits;
>> +- cooling attachments: used to describe links between trip points and=

>> +cooling devices;
>=20
> I think "attachments" sounds a bit odd, though I don't have a better
> naming suggestion.

I understand. But I also could not find a better naming. We use the term
'cooling binding'. However, while rewriting and rereading this binding
document  I realized that the 'binding' term could be confused between
'cooling binding' and 'device tree binding'. So I chose to use another
name and 'attachments' as the best I could come out with :-). I am open
to suggestions here, if you have something better.

>=20
>> +- thermal zones: used to describe thermal data within the hardware;
>> +
>> +It follows a description of each type of these device tree nodes.
>> +
>> +* Sensor devices
>> +
>> +Sensor devices are nodes providing temperature sensing capabilities o=
n thermal
>> +zones. Typical devices are I2C ADC converters and bandgaps. Theses ar=
e nodes
>> +providing temperature data to thermal zones. Temperature sensor devic=
es may
>> +control one or more internal sensors.
>> +
>> +Required property:
>> +- #sensor-cells:       Used to provide sensor device specific informa=
tion
>> +                       while referring to it. Must be at least 1, in =
order
>> +                       to identify uniquely the sensor instances with=
in
>> +                       the IC. See thermal zone binding for more deta=
ils
>> +                       on how consumers refer to sensor devices.
>=20
> I don't see why this needs to be at least one cell -- if an IC only has=

> one temperature sensor it should be fine for this to be zero and have n=
o
> ambiguity.

Well, idea was to have all these entries uniform. Besides, making sure
one has added a #sensor-cells entry to a device tree node seams to be
sign that the writer of that node really wants it to be a temperature
sensor used within this type of binding.

>=20
> It may make sense to call these thermal sensor devices, there are plent=
y
> of other sensors we might want to describe in the dt for other purposes=
,
> and we can impose some consistency if we remove the ambiguity.

Sounds fair to me.

>=20
>> +
>> +* Cooling device nodes
>> +
>> +Cooling devices are nodes providing control on power dissipation. The=
re
>> +are essentially two ways to provide control on power dissipation. Fir=
st
>> +is by means of regulating device performance, which is known as passi=
ve
>> +cooling. Second is by means of activating devices in order to remove
>> +the dissipated heat, which is known as active cooling, e.g. regulatin=
g
>> +fan speeds. In both cases, cooling devices shall have a way to determ=
ine
>> +the level of cooling.
>> +
>> +Required property:
>> +- cooling-min-level:   A unsigned integer indicating the smallest
>> +                       cooling level accepted. Typically 0.
>> +- cooling-max-level:   An unsigned integer indicating the largest
>> +                       cooling level accepted.
>=20
> I'm not sure what a "cooling level" means. It seems a bit abstract. Is
> this binding specific?

It is just a state to describe the level of cooling provided. I tried to
explained it in the above paragraph, but based on your comment, it was
not enough :-).

A fan device may come with three different speeds. Then it would be seen
as having three cooling levels. Similarly, a cpu may come with four
operating points (predefined pairs of voltage and frequency set), then
it would be seen as having four cooling levels. Pretty straight forward.

>=20
> How does this relate to cooling-cells? These seem to be a fixed size.
>=20

The cooling cells was simply to say which levels would be used. E.g. If
a cpu has 10 different operating points, at a certain trip point, the
designer may choose only the 6th until the 10th operating point
available to cool off the thermal zone.

>> +- #cooling-cells:      Used to provide cooling device specific inform=
ation
>> +                       while referring to it. Must be at least 2, in =
order
>> +                       to specify minimum and maximum cooling level u=
sed
>> +                       in the reference. See Cooling device attachmen=
ts section
>> +                       below for more details on how consumers refer =
to
>> +                       cooling devices.
>=20
> Are these cooling cells always expected to cover min and max, and are
> min and max always expected to take the same number of cells? The above=

> cooling-*-level properties imply they each take up one cell.

Yes, they take only one cell. And yes, so far I see only one need so
far, to describe min and max level used while referring to the cooling
device.

>=20
> Does #cooling-cells =3D <3> make sense?. If this covers additional
> information (e.g. which fan on a multi-fan controller), how does the OS=

> determine which cells are min and max, and how do these relate to
> cooling-level-min and cooling-level-max?

Well, I haven't seen such case. But would make sense to me, yes. Not
that we would be using though.

>=20
>> +
>> +* Trip points
>> +
>> +The trip node is a node to describe a point in the temperature domain=

>> +in which the system takes an action. This node describes just the poi=
nt,
>> +not the action.
>=20
> I'm still not sure on this, as it sounds like embedding policy into the=

> DT, rather than a description of the hardware. I realise we need to

Why?

> prevent devices burning out, so describing the max acceptable
> temperature and possibly a preferred range makes sense, but do we need
> this level of flexibility? Maybe we do.
>=20

Can you please be more specific? Any counter example on how to be less
flexible? I believe this shall give a good level of flexibility. Nothing
less than needed, and nothing that can open for abusing the notation.

>> +
>> +Required properties:
>> +- temperature:         the trip temperature level, in milliCelsius.
>=20
> Preferably, s/milliCelsius/millicelsius/ over the document.
>=20

No issues.

> Given that we have signed values elsewhere, is this signed or unsigned?=



Signed. But withing the current code implementation, and design too, we
are concerned with high positive temperatures, not low negative
temperatures.

>=20
>> +- hysteresis:          a (low) hysteresis value on 'temperature'. Thi=
s is a
>> +                       relative value, in milliCelsius.
>> +- type:                        the trip type. Here is the type mappin=
g:
>> +       THERMAL_TRIP_ACTIVE     0:      A trip point to enable active =
cooling
>> +       THERMAL_TRIP_PASSIVE    1:      A trip point to enable passive=
 cooling
>> +       THERMAL_TRIP_HOT        2:      A trip point to notify emergen=
cy
>> +       THERMAL_TRIP_CRITICAL   3:      Hardware not reliable.
>> +
>> +Refer to include/dt-bindings/thermal/thermal.h for definition of thes=
e consts.
>=20
> Why not use a string for this? We do so for other type parameters in
> other bindings (see dr_mode in
> Documentation/devicetree/bindings/usb/generic.txt, phy-mode for etherne=
t
> PHYs, etc).

I think this is a matter of taste. I am not sure I see the advantage of
changing this to string constants. If it is the case of having better
readability, I would say we do not loose readability while using macros,
that is descriptive enough.

>=20
>> +
>> +* Cooling device attachments
>> +
>> +The cooling device attachments node is a node to describe how cooling=
 devices
>> +get assigned to trip points of the zone. The cooling devices are expe=
cted
>> +to be loaded in the target system.
>> +
>> +Required properties:
>> +- cooling-device:      A phandle of a cooling device with its paramet=
ers,
>> +                       referring to which cooling device is used in t=
his
>> +                       binding. The required parameters are: the mini=
mum
>> +                       cooling level and the maximum cooling level us=
ed
>> +                       in this attach.
>=20
> Might this be a list in general? The code doesn't have to support that
> yet.

Well, I thought of having a list at first, but then we would loose the
'contribution' property, which is specific to a cooling device, not to a
list of cooling devices.

>=20
> It would be nice to have a name for the cells after a phandle which
> describe the cooling device's configuration. You've called them
> parameters here, but it probably makes sense to call them a
> cooling-specifier (following clock-specifier and interrupt-specifier).

I think I do not follow this suggestion properly. Can you please give an
example? The parameters I was referring to was just the min and max
cooling levels.

>=20
>> +- trip:                        A phandle of a trip point node within =
the same thermal
>> +                       zone.
>> +
>> +Optional property:
>> +- contribution:                The cooling contribution to the therma=
l zone of the
>> +                       referred cooling device at the referred trip p=
oint.
>> +                       The contribution is a value from 0 to 100. The=
 sum
>> +                       of all cooling contributions within a thermal =
zone
>> +                       must never exceed 100.
>=20
> This is a bit arbitrary. Couldn't we sum all contributions to find the
> total automatically, so this could be a simpler ratio?

Well, both representations do the job. I fail to see the advantage
between one and another.

>=20
>> +
>> +Note: Using the THERMAL_NO_LIMIT (-1L) constant in the cooling-device=
 phandle
>> +limit parameters means:
>> +(i)   - minimum level allowed for minimum cooling level used in the r=
eference.
>> +(ii)  - maximum level allowed for maximum cooling level used in the r=
eference.
>> +Refer to include/dt-bindings/thermal/thermal.h for definition of this=
 constant.
>> +
>> +* Thermal zones
>> +
>> +The thermal-zone node is the node containing all the required info
>> +for describing a thermal zone, including its cdev bindings. The therm=
al_zone
>> +node must contain, apart from its own properties, one node containing=

>> +trip nodes and one node containing all the zone cooling attachments.
>=20
> s/cdev/cooling device/ ?

Yes.

>=20
>> +
>> +Required properties:
>> +- passive-delay:       The maximum number of milliseconds to wait bet=
ween polls
>> +                       when performing passive cooling.
>> +- polling-delay:       The maximum number of milliseconds to wait bet=
ween polls
>> +                       when checking this thermal zone.
>=20
> How about polling-delay-passive, polling-delay-active? I'm still not

I am ok with the name suggestion

>=20
>> +- sensors:             A list of sensor phandles and their parameters=
=2E The
>> +                       required parameter is the sensor id, in order =
to
>> +                       identify internal sensors when the sensor IC f=
eatures
>> +                       several sensing units.
>=20
> As mentioned above, I'm not sure you even need that one cell.

To make then uniform, as mentioned. Can you please give an example of
existing similar case, in which we simply avoid using #.*-cells?

>=20
> - sensors:                A list of sensor phandle + thermal-sensor-spe=
cifier
>                           cells describing the sensors monitoring the t=
hermal
> 			  zone.

I see your suggestion.

>=20
>> +- trips:               A sub-node containing several trip point nodes=
 required
>> +                       to describe the thermal zone.
>> +- cooling-attachments  A sub-node containing several cooling device a=
ttaches
>> +                       nodes, used to describe the relation between t=
rips
>> +                       and cooling devices.
>> +
>> +Optional property:
>> +- coefficients:                An array of integers (one signed cell)=
 containing
>> +                       coefficients to compose a linear relation betw=
een
>> +                       the sensors described in the sensors property.=

>> +                       Coefficients defaults to 1, in case this prope=
rty
>> +                       is not specified. A simple linear polynomial i=
s used:
>> +                       Z =3D c0 * x0 + c1 + x1 + ... + c(n-1) * x(n-1=
) + cn.
>> +
>> +                       The coefficients are ordered and they match wi=
th sensors
>> +                       by means of sensor ID. Additional coefficients=
 are
>> +                       interpreted as constant offsets.
>=20
> What is the end result of this? Presumably this is meant to result in a=
n
> estimate of the average temperature of the thermal zone, rather than an=

> arbitrary value? This should be mentioned.

Well not exactly an average, but at least a linear relation, as already
mentioned. Not only that, but with the above property, one can use also
one single sensor + offset, which is a very common use case.

>=20
> This doesn't seem to be used the in the code below...

It is in the TODO list. But you are right, it is not implemented.

>=20
>> +
>> +Note: The delay properties are bound to the maximum dT/dt (temperatur=
e
>> +derivative over time) in two situations for a thermal zone:
>> +(i)  - when active cooling is activated (passive-delay); and
>> +(ii) - when the zone just needs to be monitored (polling-delay).
>> +The maximum dT/dt is highly bound to hardware power consumption and d=
issipation
>> +capability.
>=20
> I'm not sure what you mean by this, could you elaborate?
>=20
> I guess you mean that the delays should be chosen to account for said
> max dT/dt, such that a device can't unexpectedly cross several trip
> boundaries between polls?

Yes, that is exactly what I meant. And that is why I have been saying
that I see these polling values are part of hardware description. Worst
case is when device unexpectedly cross several trip boundaries between
polls without the system seeing, but also reaches temperature ranges
that compromise silicon lifetime or internal structures.

These is highly bound to maximum power delta that the circuitry may be
exposed to.

>=20
>> +
>> +* Examples
>> +
>> +Below are several examples on how to use thermal data descriptors
>> +using device tree bindings:
>> +
>> +(a) - CPU thermal zone
>> +
>> +The CPU thermal zone example below describes how to setup one thermal=
 zone
>> +using one single sensor as temperature source and many cooling device=
s and
>> +power dissipation control sources.
>> +
>> +#include <dt-bindings/thermal/thermal.h>
>> +
>> +cpus {
>> +       cpu0: cpu@0 {
>> +               ...
>> +               cooling-min-level =3D <0>;
>> +               cooling-max-level =3D <3>;
>> +               #cooling-cells =3D <2>; /* min followed by max */
>> +       };
>=20
> What do those min and max mean in this context? What do the values in
> the range [0,3] correspond to?

In the case the CPU is DVFS-capable, which is pretty common case these
days, they represent that the referred cpu has four possible operating
points. In this case, 0 means the maximum operating point, 3 means the
minimum operating point.

>=20
> I'm not sure it makes sense to describe passive cooling in this way --
> the precise way an OS does less work on a device is fundamentally tied
> to the design of the OS (it might be able to rate-limit requests, it
> might be able to clock the device down, it might only be able to turn
> the device off).

No, this is not about the work the OS capability of doing work on a CPU.
This is more tied to the frequency and voltage available on a CPU. That
is, the hardware capability of cooling itself, in this case.

>=20
> I'm not sure there is anything we can describe for passive cooling
> (beyond the thermal limits the OS should attempt to stick to).
>=20

I am not sure what you mean here, same level of cooling applies for a
cpu capable of doing dvfs, for instance.

>> +       ...
>> +};
>> +
>> +&i2c1 {
>> +       ...
>> +       fan0: fan@0x48 {
>> +               ...
>> +               cooling-min-level =3D <0>;
>> +               cooling-max-level =3D <9>;
>> +               #cooling-cells =3D <2>; /* min followed by max */
>> +       };
>=20
> What do min and max mean here for the fan?

speeds

>=20
>> +};
>> +
>> +bandgap0: bandgap@0x0000ED00 {
>> +       ...
>> +       #sensor-cells =3D <1>;
>> +};
>> +
>> +cpu-thermal: cpu-thermal {
>=20
> How do the thermal zones get probed?

Regarding the implementation for Linux, I proposed a function that
parses all of them, when the thermal framework is initialized. They will
be represented as thermal zone devices in the thermal framework. But
they will only be enabled when the sensor drivers register themselves to
the framework.

>=20
>> +       passive-delay =3D <250>; /* milliseconds */
>> +       polling-delay =3D <1000>; /* milliseconds */
>> +
>> +               /* sensor       ID */
>> +        sensors =3D <&bandgap0     0>;
>> +
>> +        trips {
>> +                cpu-alert0: cpu-alert {
>> +                        temperature =3D <90000>; /* milliCelsius */
>> +                        hysteresis =3D <2000>; /* milliCelsius */
>> +                        type =3D <THERMAL_TRIP_ACTIVE>;
>> +                };
>> +                cpu-alert1: cpu-alert {
>> +                        temperature =3D <100000>; /* milliCelsius */
>> +                        hysteresis =3D <2000>; /* milliCelsius */
>> +                        type =3D <THERMAL_TRIP_PASSIVE>;
>> +                };
>> +                cpu-crit: cpu-crit {
>> +                        temperature =3D <125000>; /* milliCelsius */
>> +                        hysteresis =3D <2000>; /* milliCelsius */
>> +                        type =3D <THERMAL_TRIP_CRITICAL>;
>> +                };
>> +        };
>> +
>> +       cooling-attachments {
>> +               attach0 {
>> +                       trip =3D <&cpu-alert0>;
>> +                       cooling-device =3D <&fan0 THERMAL_NO_LIMITS 4>=
;
>> +               };
>> +               attach1 {
>> +                       trip =3D <&cpu-alert1>;
>> +                       cooling-device =3D <&fan0 5 THERMAL_NO_LIMITS>=
;
>> +               };
>> +               attach2 {
>> +                       trip =3D <&cpu-alert1>;
>> +                       cooling-device =3D
>> +                               <&cpu0 THERMAL_NO_LIMITS THERMAL_NO_LI=
MITS>;
>> +               };
>> +       };
>=20
> Was there a good reason for splitting trips and attachment?

Same reason I mentioned for not having a list of cooling devices in each
attachment, we could loose information specific to the attachment trip,
cooling device.

>=20
>> +};
>> +
>> +In the example above, the ADC sensor at address 0x0000ED00 is used to=
 monitor
>> +the zone 'cpu-thermal' using its the sensor 0. The fan0, a fan device=
 controlled
>> +via I2C bus 1, at adress 0x48, is used to remove the heat out of the =
thermal
>> +zone 'cpu-thermal' using its cooling levels from its minimum to 4, wh=
en it
>> +reaches trip point 'cpu-alert0' at 90C, as an example of active cooli=
ng. The
>> +same cooling device is used at 'cpu-alert1', but from 5 to its maximu=
m level.
>> +The cpu@0 device is also linked to the same thermal zone, 'cpu-therma=
l', as a
>> +passive cooling device, using all its cooling levels at trip point 'c=
pu-alert1',
>> +which is a trip point at 100C.
>> +
>=20
> [...]
>=20
>> +(c) - Several sensors within one single thermal zone
>> +
>> +The example below illustrates how to use more than one sensor within
>> +one thermal zone.
>> +
>> +#include <dt-bindings/thermal/thermal.h>
>> +
>> +&i2c1 {
>> +       ...
>> +       adc: sensor@0x49 {
>> +               ...
>> +               #sensor-cells =3D <1>;
>> +       };
>> +};
>> +
>> +bandgap0: bandgap@0x0000ED00 {
>> +       ...
>> +       #sensor-cells =3D <1>;
>> +};
>> +
>> +cpu-thermal: cpu-thermal {
>> +       passive-delay =3D <250>; /* milliseconds */
>> +       polling-delay =3D <1000>; /* milliseconds */
>> +
>> +               /* sensor       ID */
>> +        sensors =3D <&bandgap0   0>,
>> +                 <&adc         0>;
>> +
>> +               /* hotspot =3D 100 * bandgap - 120 * adc + 484 */
>> +       coefficients =3D          <100    -120    484>;
>=20
> Aha, so these are signed. This *must* be mentioned in the documentation=
=2E
> The types of all properties should be described in their definition.
>=20

OK.


> [...]
>=20
>> +struct thermal_zone_device *
>> +thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
>> +                               void *data, int (*get_temp)(void *, lo=
ng *),
>> +                               int (*get_trend)(void *, long *))
>> +{
>> +       struct device_node *np, *child, *sensor_np;
>> +
>> +       np =3D of_find_node_by_name(NULL, "thermal-zones");
>=20
> This is the first instance of "thermal-zones" in this patch. Presumably=

> this is the container for thermal zones that allows them to be probed
> (answering my question above). This *must* be described in the binding.=


Hmm.. I am not sure I follow you properly. Are you asking me to mention
implementation details in the binding document (how thermal zones are
probed)?

>=20
>> +       if (!np)
>> +               return ERR_PTR(-ENODEV);
>> +
>> +       if (!dev || !dev->of_node)
>> +               return ERR_PTR(-EINVAL);
>> +
>> +       sensor_np =3D dev->of_node;
>> +
>> +       for_each_child_of_node(np, child) {
>> +               struct of_phandle_args sensor_specs;
>> +               int ret;
>> +
>> +               /* For now, thermal framework supports only 1 sensor p=
er zone */
>> +               ret =3D of_parse_phandle_with_args(child, "sensors",
>> +                                                "#sensor-cells",
>> +                                                0, &sensor_specs);
>> +               if (ret)
>> +                       continue;
>> +
>> +               if (sensor_specs.args_count < 1)
>> +                       continue;
>=20
> Why? I fail to see why a single sensor *must* have some configuration c=
ells.

I guess by now you know my answer :-). Idea was to have all of them
uniform, but if you have an existing example that have this property
optional, then I can consider it.

>=20
>> +
>> +               if (sensor_specs.np =3D=3D sensor_np &&
>> +                   sensor_specs.args[0] =3D=3D sensor_id) {
>> +                       of_node_put(np);
>> +                       return thermal_zone_of_add_sensor(child, senso=
r_np,
>> +                                                         data,
>> +                                                         get_temp,
>> +                                                         get_trend);
>> +               }
>> +       }
>> +       of_node_put(np);
>> +
>> +       return ERR_PTR(-ENODEV);
>> +}
>> +EXPORT_SYMBOL_GPL(thermal_zone_of_sensor_register);
>=20
> [...]
>=20
>> +static int thermal_of_populate_bind_params(struct device_node *np,
>> +                                          struct __thermal_bind_param=
s *__tbp,
>> +                                          struct __thermal_trip *trip=
s,
>> +                                          int ntrips)
>> +{
>> +       struct of_phandle_args cooling_spec;
>> +       struct device_node *trip;
>> +       int ret, i;
>> +       u32 prop;
>> +
>> +       /* Default weight. Usage is optional */
>> +       __tbp->usage =3D 0;
>> +       ret =3D of_property_read_u32(np, "usage", &prop);
>=20
> That wasn't described in the binding. Should this be reading the
> "contribution" property?

Yes, this is my bad, it is supposed to be 'contribution'.

>=20
>> +       if (ret =3D=3D 0)
>> +               __tbp->usage =3D prop;
>> +
>> +       trip =3D of_parse_phandle(np, "trip", 0);
>> +       if (!trip) {
>> +               pr_err("missing trip property\n");
>> +               return -ENODEV;
>> +       }
>> +
>> +       /* match using device_node */
>> +       for (i =3D 0; i < ntrips; i++)
>> +               if (trip =3D=3D trips[i].np) {
>> +                       __tbp->trip_id =3D i;
>> +                       break;
>> +               }
>> +
>> +       if (i =3D=3D ntrips) {
>> +               ret =3D -ENODEV;
>> +               goto end;
>> +       }
>> +
>> +       ret =3D of_parse_phandle_with_args(np, "cooling-device", "#coo=
ling-cells",
>> +                                        0, &cooling_spec);
>> +       if (ret < 0) {
>> +               pr_err("missing cooling_device property\n");
>> +               goto end;
>> +       }
>> +       __tbp->cooling_device =3D cooling_spec.np;
>> +       if (cooling_spec.args_count >=3D 2) { /* at least min and max =
*/
>> +               __tbp->min =3D cooling_spec.args[0];
>> +               __tbp->max =3D cooling_spec.args[1];
>=20
> Ah, so the first two cells are meant to be min and max, not any
> arbitrary cells. Why is this necessary?

Same example I answered above, one cooling device that has 10 levels of
cooling can be used at trip point at 100C only from 6th to 10th cooling
level. And on different trip point, from 4th to 5th, and so on so forth..=
=2E

>=20
>> +       } else {
>> +               pr_err("wrong reference to cooling device, missing lim=
its\n");
>> +       }
>> +
>> +end:
>> +       of_node_put(trip);
>> +
>> +       return ret;
>> +}
>> +
>> +/**
>> + * thermal_of_populate_trip - parse and fill one trip point data
>> + * @np: DT node containing a trip point node
>> + * @trip: trip point data structure to be filled up
>> + *
>> + * This function parses a trip point type of node represented by
>> + * @np parameter and fills the read data into @trip data structure.
>> + *
>> + * Return: 0 on success, proper error code otherwise
>> + */
>> +static int thermal_of_populate_trip(struct device_node *np,
>> +                                   struct __thermal_trip *trip)
>> +{
>> +       int prop;
>> +       int ret;
>> +
>> +       ret =3D of_property_read_u32(np, "temperature", &prop);
>> +       if (ret < 0) {
>> +               pr_err("missing temperature property\n");
>> +               return ret;
>> +       }
>> +       trip->temperature =3D prop;
>> +
>> +       ret =3D of_property_read_u32(np, "hysteresis", &prop);
>> +       if (ret < 0) {
>> +               pr_err("missing hysteresis property\n");
>> +               return ret;
>> +       }
>> +       trip->hysteresis =3D prop;
>> +
>> +       ret =3D of_property_read_u32(np, "type", &prop);
>> +       if (ret < 0) {
>> +               pr_err("missing type property\n");
>> +               return ret;
>> +       }
>> +       trip->type =3D prop;
>=20
> No sanity checking?
>=20

Yes, I can added it.

> I'd prefer a string and a table from string to Linux internal ID. Other=
s
> may have differing opinions.

I just fail to see any advantage of using string constants, as I already
mentioned.

>=20
>> +
>> +       /* Required for cooling attachment matching */
>> +       trip->np =3D np;
>> +
>> +       return 0;
>> +}
>=20
> [...]
>=20
>> +
>> +/**
>> + * thermal_of_build_thermal_zone - parse and fill one thermal zone da=
ta
>> + * @np: DT node containing a thermal zone node
>> + *
>> + * This function parses a thermal zone type of node represented by
>> + * @np parameter and fills the read data into a __thermal_zone data s=
tructure
>> + * and return this pointer.
>> + *
>> + * Return: On success returns a valid struct __thermal_zone,
>> + * otherwise, it returns a corresponding ERR_PTR(). Caller must
>> + * check the return value with help of IS_ERR() helper.
>> + */
>> +static struct __thermal_zone *
>> +thermal_of_build_thermal_zone(struct device_node *np)
>> +{
>> +       struct device_node *child, *gchild;
>> +       struct __thermal_zone *tz;
>> +       int ret, i;
>> +       u32 prop;
>> +
>> +       if (!np) {
>> +               pr_err("no thermal zone np\n");
>> +               return ERR_PTR(-EINVAL);
>> +       }
>> +
>> +       tz =3D kzalloc(sizeof(*tz), GFP_KERNEL);
>> +       if (!tz)
>> +               return ERR_PTR(-ENOMEM);
>> +
>> +       ret =3D of_property_read_u32(np, "passive-delay", &prop);
>> +       if (ret < 0) {
>> +               pr_err("missing passive_delay property\n");
>=20
> Inconsistent '-' and '_' between the parsing and the error.

Right! I will fix the message errors.

>=20
>> +               return ERR_PTR(ret);
>> +       }
>> +       tz->passive_delay =3D prop;
>> +
>> +       ret =3D of_property_read_u32(np, "polling-delay", &prop);
>> +       if (ret < 0) {
>> +               pr_err("missing polling_delay property\n");
>=20
> Same here.


ok.

>=20
>> +               return ERR_PTR(ret);
>> +       }
>> +       tz->polling_delay =3D prop;
>> +
>> +       /* trips */
>> +       child =3D of_get_child_by_name(np, "trips");
>> +
>> +       /* No trips provided */
>> +       if (!child)
>> +               goto finish;
>> +
>> +       tz->ntrips =3D of_get_child_count(child);
>=20
> What if there are no children, or this fails (returning zero)?

OK. I can add the check for zero children.

>=20
>> +       tz->trips =3D kzalloc(tz->ntrips * sizeof(*tz->trips), GFP_KER=
NEL);
>=20
> Here kzalloc could return ZERO_SIZE_PTR ((void*) 16). So the check belo=
w
> isn't sufficient to stop us continuing if the node has no children. We
> should check tz->ntrips above before calling kzalloc.

got it. adding the check for zero children above.

>=20
>> +       if (!tz->trips)
>> +               return ERR_PTR(-ENOMEM);
>> +       i =3D 0;
>> +       for_each_child_of_node(child, gchild)
>> +               thermal_of_populate_trip(gchild, &tz->trips[i++]);
>=20
> What if this fails for a child node?

I will add a check to avoid continuing. There is no sense to me to
continue with a child that is wrongly described.

>=20
>> +
>> +       of_node_put(child);
>> +
>> +       /* cooling-attachments */
>> +       child =3D of_get_child_by_name(np, "cooling-attachments");
>> +
>> +       /* cooling-attachments provided */
>> +       if (!child)
>> +               goto finish;
>> +
>> +       tz->num_tbps =3D of_get_child_count(child);
>> +       tz->tbps =3D kzalloc(tz->num_tbps * sizeof(*tz->tbps), GFP_KER=
NEL);
>> +       if (!tz->tbps)
>> +               return ERR_PTR(-ENOMEM);
>> +       i =3D 0;
>> +       for_each_child_of_node(child, gchild)
>> +               thermal_of_populate_bind_params(gchild, &tz->tbps[i++]=
,
>> +                                               tz->trips, tz->ntrips)=
;
>> +
>> +finish:
>> +       tz->mode =3D THERMAL_DEVICE_DISABLED;
>> +
>> +       return tz;
>> +}
>=20
> What about all that useless data we may have just allocated memory for?=


Which useless data? The allocated data is used to hold the parsed data
which in turn is used to make the thermal zone device work properly.
They are freed when the thermal framework is unloaded, in which each
thermal zone device is unregistered and all related data is freed, see
the end of the file.

>=20
> [...]
>=20
>> +int __init of_parse_thermal_zones(void)
>> +{
>> +       struct device_node *np, *child;
>> +       struct __thermal_zone *tz;
>> +       struct thermal_zone_device_ops *ops;
>> +
>> +       np =3D of_find_node_by_name(NULL, "thermal-zones");
>> +       if (!np) {
>> +               pr_debug("unable to find thermal zones\n");
>> +               return 0; /* Run successfully on systems without therm=
al DT */
>> +       }
>> +
>> +       for_each_child_of_node(np, child) {
>> +               struct thermal_zone_device *zone;
>> +               struct thermal_zone_params *tzp;
>=20
> So each child of thermal-zones must be a thermal zone (we can't embed
> other nodes of information)?

Yes, each child is a thermal zone. Well, I don't see which other
information you would embed in it.

>=20
>> +
>> +               tz =3D thermal_of_build_thermal_zone(child);
>> +               if (IS_ERR(tz)) {
>> +                       pr_err("failed to build thermal zone %s: %ld\n=
",
>> +                              child->name,
>> +                              PTR_ERR(tz));
>> +                       continue;
>> +               }
>> +
>> +               ops =3D kmemdup(&of_thermal_ops, sizeof(*ops), GFP_KER=
NEL);
>> +               if (!ops)
>> +                       goto exit_free;
>> +
>> +               tzp =3D kzalloc(sizeof(*tzp), GFP_KERNEL);
>> +               if (!tzp) {
>> +                       kfree(ops);
>> +                       goto exit_free;
>> +               }
>> +
>> +               /* No hwmon because there might be hwmon drivers regis=
tering */
>> +               tzp->no_hwmon =3D true;
>> +
>> +               zone =3D thermal_zone_device_register(child->name, tz-=
>ntrips,
>> +                                                   0, tz,
>> +                                                   ops, tzp,
>> +                                                   tz->passive_delay,=

>> +                                                   tz->polling_delay)=
;
>> +               if (IS_ERR(zone)) {
>> +                       pr_err("Failed to build %s zone %ld\n", child-=
>name,
>> +                              PTR_ERR(zone));
>> +                       kfree(tzp);
>> +                       kfree(ops);
>> +                       of_thermal_free_zone(tz);
>> +                       /* attempting to build remaining zones still *=
/
>> +               }
>> +       }
>> +
>> +       return 0;
>> +
>> +exit_free:
>> +       of_thermal_free_zone(tz);
>> +
>> +       /* no memory available, so free what we have built */
>> +       of_thermal_destroy_zones();
>> +
>> +       return -ENOMEM;
>> +}
>=20
> Cheers,
> Mark.


All best,

Eduardo
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--QcNMjuJbmFunaNC2CmOsaqtsxTTW4SGJS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJAYKsACgkQCXcVR3XQvP0ongEAjfCb77Z5M2NPBIyxfA2A3OFx
F99PMxxOz8jKK1KxpWIBAOOP0Wc9zCdHLwe+hYax6Qnzt6cDRH4pKI5zDrU1SSoI
=vG8J
-----END PGP SIGNATURE-----

--QcNMjuJbmFunaNC2CmOsaqtsxTTW4SGJS--
