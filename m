Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab3I3Usz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:48:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48082 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352Ab3I3Usx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:48:53 -0400
Message-ID: <5249E345.8010307@ti.com>
Date: Mon, 30 Sep 2013 16:47:01 -0400
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
        "wni@nvidia.com" <wni@nvidia.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv7 03/18] thermal: introduce device tree parser
References: <1380251605-3804-1-git-send-email-eduardo.valentin@ti.com> <1380251605-3804-4-git-send-email-eduardo.valentin@ti.com> <20130930153614.GA22259@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130930153614.GA22259@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="6T8MGDFDeGXLIQ11OJIbE6skExoefKH3H"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6T8MGDFDeGXLIQ11OJIbE6skExoefKH3H
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Mark

Thanks for another good review round. I am following up your concerns
inline.

On 30-09-2013 11:36, Mark Rutland wrote:
> Hi Eduardo,
>=20
> On Fri, Sep 27, 2013 at 04:13:10AM +0100, Eduardo Valentin wrote:
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
>>
>> Hello folks,
>>
>> For those interested on this work, here is a short changelog from v6:
>> - Reviewed binding documentation and added type and size on all proper=
ties
>> - Described 'thermal-zones' node in binding documentation
>> - Using now cooling state terminology instead of cooling level
>> - Renamed milliCelsius to millicelsius
>> - Renamed cooling-attachments to 'cooling-maps'
>> - Renamed sensor to thermal sensor
>> - Renamed #sensor-cells to #thermal-sensor-cells
>> - #thermal-sensor-cells now is allowed to be 0
>> - Renamed 'sensors' property to 'thermal-sensors'
>> - Changed trip type property to be now string and documented possible =
values
>> - Described better the cooling properties
>> - Now parses 'contribution' instead of 'usage'
>> - Renamed cdev to cooling device
>> - Renamed 'passive-delay' property to 'polling-delay-passive'
>> - Fixed a couple of error messages to match the property name
>> - Fixed a binding issue while using cpufreq as module
>> - Reworked thermal_of_build_thermal_zone function so that it frees
>> requested memory if something goes wrong and checks for sub-nodes
>> with zero children.
>>
>> ---
>>  .../devicetree/bindings/thermal/thermal.txt        | 537 ++++++++++++=
+
>>  drivers/thermal/Kconfig                            |  13 +
>>  drivers/thermal/Makefile                           |   1 +
>>  drivers/thermal/of-thermal.c                       | 845 ++++++++++++=
+++++++++
>>  drivers/thermal/thermal_core.c                     |   9 +-
>>  drivers/thermal/thermal_core.h                     |   9 +
>>  include/dt-bindings/thermal/thermal.h              |  27 +
>>  include/linux/thermal.h                            |  28 +-
>>  8 files changed, 1466 insertions(+), 3 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/thermal/thermal.=
txt
>>  create mode 100644 drivers/thermal/of-thermal.c
>>  create mode 100644 include/dt-bindings/thermal/thermal.h
>>
>> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/D=
ocumentation/devicetree/bindings/thermal/thermal.txt
>> new file mode 100644
>> index 0000000..3dbc017
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
>> @@ -0,0 +1,537 @@
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
>> +- cooling maps: used to describe links between trip points and
>> +cooling devices;
>> +- thermal zones: used to describe thermal data within the hardware;
>> +
>> +It follows a description of each type of these device tree nodes.
>> +
>> +Note: This binding is a working in progress.
>=20
> What does this mean? Is the binding expected to change in incompatible
> ways?

Well, no. The note was more to say we still don't have a final
agreement. But for merging this patch, once we have agreed to get it
merged, I believe this comment can be left out.

>=20
> I see we have similar wording at the top of the clock bindings, which
> should probably go -- it's ABI now...

OK.

>=20
>> +
>> +* Thermal sensor devices
>> +
>> +Thermal sensor devices are nodes providing temperature sensing capabi=
lities on
>> +thermal zones. Typical devices are I2C ADC converters and bandgaps. T=
heses are
>> +nodes providing temperature data to thermal zones. Thermal sensor dev=
ices may
>> +control one or more internal sensors.
>> +
>> +Required property:
>> +- #thermal-sensor-cells: Used to provide sensor device specific infor=
mation
>> +  Type: unsigned        while referring to it. Typically 0, on therma=
l sensor
>> +  Size: one cell        nodes with only one sensor, and at least 1 on=
 nodes
>> +                        with several internal sensors, in order
>> +                        to identify uniquely the sensor instances wit=
hin
>> +                        the IC. See thermal zone binding for more det=
ails
>> +                        on how consumers refer to sensor devices.
>> +
>> +* Cooling device nodes
>> +
>> +Cooling devices are nodes providing control on power dissipation. The=
re
>> +are essentially two ways to provide control on power dissipation. Fir=
st
>> +is by means of regulating device performance, which is known as passi=
ve
>> +cooling. A typical passive cooling is a CPU that has dynamic voltage =
and
>> +frequency scaling, and uses lower frequencies as cooling states.
>> +Second is by means of activating devices in order to remove
>> +the dissipated heat, which is known as active cooling, e.g. regulatin=
g
>> +fan speeds. In both cases, cooling devices shall have a way to determ=
ine
>> +the state of cooling in which the device is.
>> +
>> +Required property:
>> +- cooling-min-state:   An integer indicating the smallest
>> +  Type: unsigned       cooling state accepted. Typically 0.
>> +  Size: one cell
>> +
>> +- cooling-max-state:   An integer indicating the largest
>> +  Type: unsigned       cooling state accepted.
>> +  Size: one cell
>> +
>> +- #cooling-cells:      Used to provide cooling device specific inform=
ation
>> +  Type: unsigned       while referring to it. Must be at least 2, in =
order
>> +  Size: one cell       to specify minimum and maximum cooling state u=
sed
>> +                       in the reference. The first cell is the minimu=
m
>> +                       cooling state requested and the second cell is=

>> +                       the maximum cooling state requested in the ref=
erence.
>> +                       See Cooling device maps section below for more=
 details
>> +                       on how consumers refer to cooling devices.
>> +
>> +* Trip points
>> +
>> +The trip node is a node to describe a point in the temperature domain=

>> +in which the system takes an action. This node describes just the poi=
nt,
>> +not the action.
>> +
>> +Required properties:
>> +- temperature:         An integer indicating the trip temperature lev=
el,
>> +  Type: signed         in millicelsius.
>> +  Size: one cell
>> +
>> +- hysteresis:          a (low) hysteresis value on 'temperature'. Thi=
s is a
>> +  Type: unsigned       relative value, in millicelsius.
>> +  Size: one cell
>> +
>> +- type:                        a string containing the trip type. Sup=
ported values are:
>=20
> Odd spacing above.

Do you mean we should remove one \t? While in patch format it looks odd,
but in the ending file it will be aligned to the above descriptions
(from hysteresis and temperature).

>=20
>> +       "active":       A trip point to enable active cooling
>> +       "passive":      A trip point to enable passive cooling
>> +       "hot":          A trip point to notify emergency
>> +       "critical":     Hardware not reliable.
>> +  Type: string
>> +
>> +There are also string constants defined at
>> +include/dt-bindings/thermal/thermal.h.
>> +
>> +* Cooling device maps
>> +
>> +The cooling device maps node is a node to describe how cooling device=
s
>> +get assigned to trip points of the zone. The cooling devices are expe=
cted
>> +to be loaded in the target system.
>> +
>> +Required properties:
>> +- cooling-device:      A phandle of a cooling device with its specifi=
er,
>> +  Type: phandle                referring to which cooling device is u=
sed in this
>=20
> More odd spacing. There's a fair amount later that would be nice to fix=

> up too.

OK. It would be nice to have a suggestion of preferred spacing though.
At least to me, looks pretty good to read.

>=20
>> +                       binding. The required specifiers are: the mini=
mum
>> +                       cooling state and the maximum cooling level us=
ed
>> +                       in this map.
>=20
> There seems to be some confusion as to the word "specifier". Typically,=

> a specifier is all the cells after the phandle described by the #*-cell=
s
> property for the node pointed to. So here there is one
> cooling-specifier, which describes the min and max values, and possibly=

> some other values.

OK. So specifier is the set of values that describe the reference to a
phandle. I will rephrase the document accordingly.

>=20
>> +- trip:                        A phandle of a trip point node within =
the same thermal
>> +  Type: phandle                zone.
>> +
>> +Optional property:
>> +- contribution:                The cooling contribution to the therma=
l zone of the
>> +  Type: unsigned       referred cooling device at the referred trip p=
oint.
>> +  Size: one cell       The contribution is a ratio of the sum
>> +                       of all cooling contributions within a thermal =
zone.
>> +
>> +Note: Using the THERMAL_NO_LIMIT (-1L) constant in the cooling-device=
 phandle
>> +limit specifier means:
>> +(i)   - minimum state allowed for minimum cooling level used in the r=
eference.
>> +(ii)  - maximum state allowed for maximum cooling level used in the r=
eference.
>> +Refer to include/dt-bindings/thermal/thermal.h for definition of this=
 constant.
>=20
> How does that work with an unsigned value? Does the code check for
> 0xffffffff, or compare against -1?

The code define is -1UL (pasting existing defines):
/* invalid cooling state */
#define THERMAL_CSTATE_INVALID -1UL

/* No upper/lower limit requirement */
#define THERMAL_NO_LIMIT	THERMAL_CSTATE_INVALID


>=20
>> +
>> +* Thermal zone nodes
>> +
>> +The thermal zone node is the node containing all the required info
>> +for describing a thermal zone, including its cooling device bindings.=
 The
>> +thermal zone node must contain, apart from its own properties, one no=
de containing
>> +trip nodes and one node containing all the zone cooling maps.
>> +
>> +Required properties:
>> +- polling-delay-passive:       The maximum number of milliseconds to =
wait
>> +  Type: unsigned               between polls when performing passive =
cooling.
>> +  Size: one cell
>=20
> Is this when performing passive cooling, or any passive or above (i.e.
> any cooling whatsoever)?

No, just when performing passive cooling.

>=20
>> +
>> +- polling-delay:       The maximum number of milliseconds to wait bet=
ween polls
>> +  Type: unsigned       when checking this thermal zone.
>> +  Size: one cell

While polling for this zone, in any other state other than when doing
passive cooling, the above polling value is used. Including for when
doing any other cooling whatsoever.

>> +
>> +- thermal-sensors:             A list of sensor phandles and sensor s=
pecifier
>> +  Type: list of phandles       used while monitoring the thermal zone=
=2E
>=20
> The type and the description don't agree here. The type description can=

> probably be omitted as the description describes the format of the
> property.

OK. I just wanted to follow one single format while describing any
property in this document.

>=20
>> +
>> +- trips:               A sub-node which is a container of only trip p=
oint nodes
>> +  Type: sub-node       required to describe the thermal zone.
>> +
>> +- cooling-maps:                A sub-node which is a container of onl=
y cooling device
>> +  Type: sub-node       map nodes, used to describe the relation betwe=
en trips
>> +                       and cooling devices.
>> +
>> +Optional property:
>> +- thermal-sensors-names:       List of thermal sensor name strings so=
rted
>> +  Type: list of strings                in the same order as the therm=
al-sensors
>> +                               property.
>=20
> Was there a reason for adding this?
>=20

The reason is to describe where (physically) the sensor is, or which
location it represents, when a thermal zone is composed by several sensor=
s.

> There was some confusion over my request for cooling-specifier and
> thermal-sensor-specifier terminology last time [1]. I was simply asking=

> for terminology, not -names properties.

I see. So, answering you question in [1], I believe comments are enough
to describe where each sensor is located, if needed while writing the
binding for a specific thermal zone. At runtime, what would really make
the difference is the usage of the 'coefficients' property below, as
there is no simple way to guess the sensor contribution in the linear
relation just based on the string names provided.  Unless there is a
need to have this information, just for hardware description purposes.

>=20
>> +
>> +- coefficients:                An array of integers (one signed cell)=
 containing
>> +  Type: array          coefficients to compose a linear relation betw=
een
>> +  Elem size: one cell  the sensors described in the thermal-sensors p=
roperty.
>> +  Elem type: signed    Coefficients defaults to 1, in case this prope=
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
>> +
>> +Note: The delay properties are bound to the maximum dT/dt (temperatur=
e
>> +derivative over time) in two situations for a thermal zone:
>> +(i)  - when active cooling is activated (polling-delay-passive); and
>=20
> Ah, so any coolnig implies the passive polling delay. That makes teh
> naming confusing (active cooling means we're polling for the passive
> delay). Sorry for the poor suggestion.
>=20

No, that was a very mistake in my phrasing. The above sentence must be:
+(i)  - when *passive* cooling is activated (polling-delay-passive); and

> How about having polling-delay-cooled instead. That better describes
> when it applies.
>=20
>> +(ii) - when the zone just needs to be monitored (polling-delay).
>> +The maximum dT/dt is highly bound to hardware power consumption and d=
issipation
>> +capability.
>=20
> It would be nice to have another line break here.

OK.

>=20
>> +The delays are chosen to account for said max dT/dt, such that a devi=
ce
>=20
> s/are/should be/

indeed.

>=20
>> +does not cross several trip boundaries unexpectedly between polls. Ch=
oosing
>> +the right polling delays shall avoid having the device in temperature=
 ranges
>> +that may damage the silicon structures and reduce silicon lifetime.
>> +
>> +* The thermal-zones node
>> +
>> +The "thermal-zones" node is a container for all thermal zone nodes. I=
t shall
>> +contain only sub-nodes describing thermal zones as in the section
>> +"Thermal zone nodes".
>=20
> I assume thermal-zones appears under /, rather than under a subnode? It=

> might be worth mentioning.

OK. I am adding this info.

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
>> +               cooling-min-state =3D <0>;
>> +               cooling-max-state =3D <3>;
>> +               #cooling-cells =3D <2>; /* min followed by max */
>> +       };
>> +       ...
>> +};
>=20
> If we're going to give an example of cpu nodes with cooling-cells, we
> should have a binding for cpu nodes explaining what the abstract coolin=
g
> properties mean for them.
>=20
> What _specifically_ do each of the values 0,1,2,3 mean here? Are they
> indexes of OPPs to use (which aren't shown in the example)? Are they
> specific to a particular CPU (the compatible string for which is not
> shown in the example)? Are they generic and applicable to all CPUs
> somehow?

OK. They are indexes of OPPs, yes, but in reverse order. That is, in the
case the CPU has 4 OPPs, 0 means all for OPPs are allowed to be used, 1
means only 3 lower OPPs are allowed, 2 means only 2 lower OPPs are
allowed to be used and 1 means only the lowest is allowed. I will add a
more detailed example.

>=20
>> +
>> +&i2c1 {
>> +       ...
>=20
> Having a comment inline describing this fictional sensor would be
> useful, something like:
>=20
> 	/*
> 	 * A simple fan controlller. Supports 10 speeds of operation
> 	 * (represented as 0-9).
> 	 */
>=20
> I didn't notice the block below until already having tried to comprehen=
d
> the example. Inline comments would help in that regard.
>=20

OK. I will add comments to describe them briefly.

>> +       fan0: fan@0x48 {
>> +               ...
>> +               cooling-min-state =3D <0>;
>> +               cooling-max-state =3D <9>;
>> +               #cooling-cells =3D <2>; /* min followed by max */
>> +       };
>> +};
>> +
>=20
> Similarly, it would be nice to have something here like:
>=20
> 	/*
> 	 * A simple IC with a single bandgap temperature sensor.
> 	 */
>=20
>> +bandgap0: bandgap@0x0000ED00 {
>> +       ...
>> +       #thermal-sensor-cells =3D <0>;
>> +};
>> +
>> +cpu-thermal: cpu-thermal {
>=20
> This should be under a thermal-zones node. Similarly for the other
> examples, they should have all relevant context.

OK. I agree  to add the thermal-zones container.

>=20
>> +       polling-delay-passive =3D <250>; /* milliseconds */
>> +       polling-delay =3D <1000>; /* milliseconds */
>> +
>=20
> The comment below is no longer relevant.

Indeed.

>=20
>> +                       /* sensor       ID */
>> +        thermal-sensors =3D <&bandgap0>;
>> +
>> +        trips {
>> +                cpu-alert0: cpu-alert {
>> +                        temperature =3D <90000>; /* millicelsius */
>> +                        hysteresis =3D <2000>; /* millicelsius */
>> +                        type =3D THERMAL_TRIP_ACTIVE;
>=20
> This got changed to a string in the binding, but is a CPP value here.
> Similarly in many other places below.

I am not sure I follow you here. What do you mean it is a CPP value? It
is simply a macro to a string.

>=20
>> +                };
>> +                cpu-alert1: cpu-alert {
>> +                        temperature =3D <100000>; /* millicelsius */
>> +                        hysteresis =3D <2000>; /* millicelsius */
>> +                        type =3D THERMAL_TRIP_PASSIVE;
>> +                };
>> +                cpu-crit: cpu-crit {
>> +                        temperature =3D <125000>; /* millicelsius */
>> +                        hysteresis =3D <2000>; /* millicelsius */
>> +                        type =3D THERMAL_TRIP_CRITICAL;
>> +                };
>> +        };
>> +
>> +       cooling-maps {
>> +               map0 {
>> +                       trip =3D <&cpu-alert0>;
>> +                       cooling-device =3D <&fan0 THERMAL_NO_LIMITS 4>=
;
>> +               };
>> +               map1 {
>> +                       trip =3D <&cpu-alert1>;
>> +                       cooling-device =3D <&fan0 5 THERMAL_NO_LIMITS>=
;
>> +               };
>> +               map2 {
>> +                       trip =3D <&cpu-alert1>;
>> +                       cooling-device =3D
>> +                               <&cpu0 THERMAL_NO_LIMITS THERMAL_NO_LI=
MITS>;
>> +               };
>> +       };
>> +};
>> +
>> +In the example above, the ADC sensor at address 0x0000ED00 is used to=
 monitor
>> +the zone 'cpu-thermal' using its the sensor 0. The fan0, a fan device=
 controlled
>> +via I2C bus 1, at adress 0x48, which has ten different cooling states=
=2E
>=20
> This is a little difficult to understand. How about:
>=20
> In the example above, the ADC sensor (bandgap0) at address 0x0000ED00 i=
s
> used to monitor the zone 'cpu-thermal' using its sole sensor. A fan
> device (fan0) is controlled via I2C bus 1, at address 0x48, and has ten=

> different cooling states 0-9.

Yes, it is a better phrasing. Thanks.

>=20
>> +It is used to remove the heat out of the thermal zone 'cpu-thermal' u=
sing its
>> +cooling states from its minimum to 4, when it reaches trip point 'cpu=
-alert0'
>> +at 90C, as an example of active cooling. The same cooling device is u=
sed at
>> +'cpu-alert1', but from 5 to its maximum state. The cpu@0 device is al=
so
>> +linked to the same thermal zone, 'cpu-thermal', as a passive cooling =
device,
>> +using all its cooling states at trip point 'cpu-alert1',
>> +which is a trip point at 100C.
>> +
>> +(b) - IC with several internal sensors
>> +
>> +The example below describes how to deploy several thermal zones based=
 off a
>> +single sensor IC, assuming it has several internal sensors. This is a=
 common
>> +case on SoC designs with several internal IPs that may need different=
 thermal
>> +requirements, and thus may have their own sensor to monitor or detect=
 internal
>> +hotspots in their silicon.
>> +
>> +#include <dt-bindings/thermal/thermal.h>
>> +
>> +bandgap0: bandgap@0x0000ED00 {
>> +       ...
>> +       #thermal-sensor-cells =3D <1>;
>> +};
>> +
>> +cpu-thermal: cpu-thermal {
>> +       polling-delay-passive =3D <250>; /* milliseconds */
>> +       polling-delay =3D <1000>; /* milliseconds */
>> +
>> +               /* sensor       ID */
>> +        thermal-sensors =3D <&bandgap0     0>;
>> +
>> +        trips {
>> +               /* each zone within the SoC may have its own trips */
>> +                cpu-alert: cpu-alert {
>> +                        temperature =3D <100000>; /* millicelsius */
>> +                        hysteresis =3D <2000>; /* millicelsius */
>> +                        type =3D THERMAL_TRIP_PASSIVE;
>> +                };
>> +                cpu-crit: cpu-crit {
>> +                        temperature =3D <125000>; /* millicelsius */
>> +                        hysteresis =3D <2000>; /* millicelsius */
>> +                        type =3D THERMAL_TRIP_CRITICAL;
>> +                };
>> +        };
>> +
>> +       cooling-maps {
>> +               /* each zone within the SoC may have its own cooling *=
/
>> +               ...
>> +       };
>> +};
>> +
>> +gpu-thermal: gpu-thermal {
>> +       polling-delay-passive =3D <120>; /* milliseconds */
>> +       polling-delay =3D <1000>; /* milliseconds */
>> +
>> +                       /* sensor       ID */
>> +        thermal-sensors =3D <&bandgap0     1>;
>> +
>> +        trips {
>> +               /* each zone within the SoC may have its own trips */
>> +                gpu-alert: gpu-alert {
>> +                        temperature =3D <90000>; /* millicelsius */
>> +                        hysteresis =3D <2000>; /* millicelsius */
>> +                        type =3D THERMAL_TRIP_PASSIVE;
>> +                };
>> +                gpu-crit: gpu-crit {
>> +                        temperature =3D <105000>; /* millicelsius */
>> +                        hysteresis =3D <2000>; /* millicelsius */
>> +                        type =3D THERMAL_TRIP_CRITICAL;
>> +                };
>> +        };
>> +
>> +       cooling-maps {
>> +               /* each zone within the SoC may have its own cooling *=
/
>> +               ...
>> +       };
>> +};
>> +
>> +dsp-thermal: dsp-thermal {
>> +       polling-delay-passive =3D <50>; /* milliseconds */
>> +       polling-delay =3D <1000>; /* milliseconds */
>> +
>> +               /* sensor       ID */
>> +        thermal-sensors =3D <&bandgap0     2>;
>> +
>> +        trips {
>> +               /* each zone within the SoC may have its own trips */
>> +                dsp-alert: gpu-alert {
>> +                        temperature =3D <90000>; /* millicelsius */
>> +                        hysteresis =3D <2000>; /* millicelsius */
>> +                        type =3D THERMAL_TRIP_PASSIVE;
>> +                };
>> +                dsp-crit: gpu-crit {
>> +                        temperature =3D <135000>; /* millicelsius */
>> +                        hysteresis =3D <2000>; /* millicelsius */
>> +                        type =3D THERMAL_TRIP_CRITICAL;
>> +                };
>> +        };
>> +
>> +       cooling-maps {
>> +               /* each zone within the SoC may have its own cooling *=
/
>> +               ...
>> +       };
>> +};
>> +
>> +In the example above there is one bandgap IC which has the capability=
 to
>> +monitor three sensors. The hardware has been designed so that sensors=
 are
>> +placed on different places in the DIE to monitor different temperatur=
e
>> +hotspots: one for CPU thermal zone, one for GPU thermal zone and the
>> +other to monitor a DSP thermal zone.
>> +
>> +Thus, there is a need to assign each sensor provided by the bandgap I=
C
>> +to different thermal zones. This is achieved by means of using the
>> +#thermal-sensor-cells property and using the first specifier as senso=
r ID.
>> +In the example, then, bandgap.sensor0 is used to monitor CPU thermal =
zone,
>=20
> The reference to bandgap.sensor0 is confusing. How about saying
> <&bandgap 0> instead? It makes it far easier to see correspondence
> between the text and the dt. Similarly for the other instances below.

Agreed.

>=20
>> +bandgap.sensor1 is used to monitor GPU thermal zone and bandgap.senso=
r2
>> +is used to monitor DSP thermal zone. Each zone may be uncorrelated,
>> +having its own dT/dt requirements, trips and cooling maps.
>> +
>> +
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
>> +               #thermal-sensor-cells =3D <0>;
>> +       };
>> +};
>> +
>> +bandgap0: bandgap@0x0000ED00 {
>> +       ...
>> +       #thermal-sensor-cells =3D <0>;
>> +};
>> +
>> +cpu-thermal: cpu-thermal {
>> +       polling-delay-passive =3D <250>; /* milliseconds */
>> +       polling-delay =3D <1000>; /* milliseconds */
>> +
>> +                       /* sensor       ID */
>> +        thermal-sensors =3D <&bandgap0>,
>> +                         <&adc>;
>> +       thermal-sensors-names =3D "cpu", "pcb north";
>> +
>> +               /* hotspot =3D 100 * bandgap - 120 * adc + 484 */
>> +       coefficients =3D          <100    -120    484>;
>> +
>> +        trips {
>> +               ...
>> +        };
>> +
>> +       cooling-maps {
>> +               ...
>> +       };
>> +};
>> +
>> +In some cases, there is a need to use more than one sensor to extrapo=
late
>> +a thermal hotspot in the silicon. The above example illustrate this s=
ituation.
>=20
> s/illustrate/illustrates/

OK.

>=20
>> +For instance, it may be the case that a sensor external to CPU IP may=
 be place
>=20
> s/place/placed/

OK.

>=20
>> +close to CPU hotspot and together with internal CPU sensor, it is use=
d
>> +to determine the hotspot. The hyppotetical extrapolation rule would b=
e:
>=20
> s/hyppotetical/hypothetical/

OK.

>=20
> [...]
>=20
>> +static int of_thermal_set_trip_temp(struct thermal_zone_device *tz, i=
nt trip,
>> +                                   unsigned long temp)
>> +{
>> +       struct __thermal_zone *data =3D tz->devdata;
>> +
>> +       if (trip >=3D data->ntrips || trip < 0)
>> +               return -EDOM;
>> +
>> +       /* thermal fw should take care of data->mask & (1 << trip) */
>=20
> I mentioned this last time, and it's tripped me up again while reading:=

> It's rather too easy to read "fw" as "firmware" and get confused.
>=20
> s/fw/framework/ please. :)

OK.

>=20
>> +       data->trips[trip].temperature =3D temp;
>> +
>> +       return 0;
>> +}
>=20
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
>> +               int ret, id;
>> +
>> +               /* For now, thermal framework supports only 1 sensor p=
er zone */
>> +               ret =3D of_parse_phandle_with_args(child, "thermal-sen=
sors",
>> +                                                "#thermal-sensor-cell=
s",
>> +                                                0, &sensor_specs);
>> +               if (ret)
>> +                       continue;
>> +
>> +               if (sensor_specs.args_count < 1)
>> +                       id =3D 0;
>> +               else
>> +                       id =3D sensor_specs.args[0];
>> +
>=20
> For the moment it might be worth printing a warning if args_count > 1,
> as thermal management might not function correctly.

Agreed. Adding this warning.

>=20
>> +               if (sensor_specs.np =3D=3D sensor_np && id =3D=3D sens=
or_id) {
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
> Cheers,
> Mark.
>=20
> [1] https://lkml.org/lkml/2013/9/24/501
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--6T8MGDFDeGXLIQ11OJIbE6skExoefKH3H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJJ40kACgkQCXcVR3XQvP1WLAD9GE+POg/webDTLhVqTsMg8Rzr
4eYGaRMVgKiHJp3rkeEA/iKlIO/Nyby9W9UmIXStDERyKuFG+PQj6JSkFyAfHMvA
=RSll
-----END PGP SIGNATURE-----

--6T8MGDFDeGXLIQ11OJIbE6skExoefKH3H--
