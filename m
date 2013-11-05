Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab3KESKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 13:10:08 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38871 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab3KESKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 13:10:05 -0500
Message-ID: <52793425.7070008@ti.com>
Date: Tue, 5 Nov 2013 14:08:37 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "wni@nvidia.com" <wni@nvidia.com>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv8 03/18] thermal: introduce device tree parser
References: <1380251605-3804-4-git-send-email-eduardo.valentin@ti.com> <1380595166-13807-1-git-send-email-eduardo.valentin@ti.com> <20131007205120.GA2330@kartoffel>
In-Reply-To: <20131007205120.GA2330@kartoffel>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="xWIpWHQx3x0bsexmvP62FCVkoeGcDWawM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xWIpWHQx3x0bsexmvP62FCVkoeGcDWawM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello device tree maintainers,

On 07-10-2013 16:51, Mark Rutland wrote:
> Hi all,
>=20
> Given that this is a complex new class of binding, I'd appreciate if at=
 least
> one other device tree maintainer could also take a look over this and v=
oice any
> concerns or suggestions. I've left the entire patch context for this.

Here is just a gentle reminder. Looks like no one else has had the time
to provide us a third opinion on this work. Shall we continue
progressing here? Its been about four weeks the series is waiting on
extra feedback.

I was on paternity leave :-) So, getting back to get this one rolling.

>=20
> Apologies for the munged whitespace -- my mail server appears to have h=
elpfully
> and irreparably replaced all tabs with spaces.
>=20
> On Tue, Oct 01, 2013 at 03:39:26AM +0100, Eduardo Valentin wrote:
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
>> Hello Mark, folks,
>>
>> So, here is v8. Pretty small changes. Most are better
>> English phrasing in the binding document. It follows changelog:
>> - Several rephrasing in the binding document, including
>> spelling, grammar and better phrasing.
>> - Removed WiP warning from binding document.
>> - Several spacing and formatting changes in the binding document
>> - Used the '-specifier' nomenclature properly in the binding doc
>> - Removed the optional property 'thermal-sensors-names', because
>> it does not provide useful runtime information
>> - Fixed description of 'polling-delay-passive'
>> - Improved examples by adding comments and better explanation
>> - s/fw/framework/g
>> - Added a WARN when sensors specifiers are greater and 1.
>>
>> All best,
>>
>> Eduardo
>>
>> ---
>>  .../devicetree/bindings/thermal/thermal.txt        | 587 ++++++++++++=
++
>>  drivers/thermal/Kconfig                            |  13 +
>>  drivers/thermal/Makefile                           |   1 +
>>  drivers/thermal/of-thermal.c                       | 849 ++++++++++++=
+++++++++
>>  drivers/thermal/thermal_core.c                     |   9 +-
>>  drivers/thermal/thermal_core.h                     |   9 +
>>  include/dt-bindings/thermal/thermal.h              |  27 +
>>  include/linux/thermal.h                            |  28 +-
>>  8 files changed, 1520 insertions(+), 3 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/thermal/thermal.=
txt
>>  create mode 100644 drivers/thermal/of-thermal.c
>>  create mode 100644 include/dt-bindings/thermal/thermal.h
>>
>> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/D=
ocumentation/devicetree/bindings/thermal/thermal.txt
>> new file mode 100644
>> index 0000000..ad06a8d
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
>> @@ -0,0 +1,587 @@
>> +* Thermal Framework Device Tree descriptor
>> +
>> +This file describes a generic binding to provide a way of
>> +defining hardware thermal structure using device tree.
>=20
> s/defining/describing/
>=20
>> +A thermal structure includes thermal zones and their components,
>> +such as trip points, polling intervals, sensors and cooling devices
>> +binding descriptors.
>> +
>> +The target of device tree thermal descriptors is to describe only
>> +the hardware thermal aspects. The thermal device tree bindings are
>> +not about how the system must control or which algorithm or policy
>> +must be taken in place.
>=20
> I'm not quite sure what this is saying -- it seems to contradict the
> design of the binding where trip points get linked to cooling device
> configuration, and thus we're defining a policy along the lines of "whe=
n
> sensor $W hits temperature $X, configure cooling device $Y with value
> $Z". I don't see how that can't be considered policy.
>=20
> At best, we can say that policy is being defined because describing the=

> physical properties of a device and dealing with this at runtime is not=

> feasible.
>=20
>> +
>> +There are five types of nodes involved to describe thermal bindings:
>> +- sensors: used to describe the device source of temperature sensing;=

>=20
> - thermal sensors: devices which may be used to take temperature
>   measurements.
>=20
>> +- cooling devices: used to describe devices source of power dissipati=
on control;
>=20
> - cooling devices: devices which may be used to dissipate heat.
>=20
>> +- trip points: used to describe points in temperature domain defined =
to
>> +make the system aware of hardware limits;
>=20
> - trip points: describe key temperatures at which cooling is recommende=
d. The
>   set of points should be chosen based on hardware limits.
>=20
>> +- cooling maps: used to describe links between trip points and coolin=
g devices;
>> +- thermal zones: used to describe thermal data within the hardware;
>> +
>> +It follows a description of each type of these device tree nodes.
>=20
> How about:
>=20
> The following is a description of each of these node types.
>=20
>> +
>> +* Thermal sensor devices
>> +
>> +Thermal sensor devices are nodes providing temperature sensing capabi=
lities on
>> +thermal zones. Typical devices are I2C ADC converters and bandgaps. T=
hese are
>> +nodes providing temperature data to thermal zones. Thermal sensor dev=
ices may
>> +control one or more internal sensors.
>> +
>> +Required property:
>> +- #thermal-sensor-cells: Used to provide sensor device specific infor=
mation
>> +  Type: unsigned        while referring to it. Typically 0 on thermal=
 sensor
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
>> +frequency scaling (DVFS), and uses lower frequencies as cooling state=
s.
>> +Second is by means of activating devices in order to remove
>> +the dissipated heat, which is known as active cooling, e.g. regulatin=
g
>> +fan speeds. In both cases, cooling devices shall have a way to determ=
ine
>> +the state of cooling in which the device is.
>=20
> I'd probably say "heat dissipation" rather than "power dissipation", un=
less
> this is a technical term I am not aware of?
>=20
> Why is the determination of the state of the cooling device important?
>=20
>> +
>> +Required properties:
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
>=20
> Is it assumed that all the values between min and max are valid, or mig=
ht this
> be a sparse set of cooling values?
>=20
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
>=20
> What is it relative to?
>=20
> Why is 'temperature' in quotes?
>=20
>> +
>> +- type:                        a string containing the trip type. Sup=
ported values are:
>> +       "active":       A trip point to enable active cooling
>> +       "passive":      A trip point to enable passive cooling
>> +       "hot":          A trip point to notify emergency
>> +       "critical":     Hardware not reliable.
>> +  Type: string
>> +
>> +There are also string constants defined at
>> +include/dt-bindings/thermal/thermal.h.
>=20
> Why?
>=20
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
>> +  Type: phandle of     referring to which cooling device is used in t=
his
>> +    cooling device     binding. In the cooling specifier, the first c=
ell
>> +                       is the minimum cooling state and the second ce=
ll
>> +                       is the maximum cooling state used in this map.=

>=20
> The type is wrong here -- it's a phandle + cooling-cells, not just a ph=
andle.
>=20
>> +- trip:                        A phandle of a trip point node within =
the same thermal
>> +  Type: phandle of     zone.
>> +   trip point node
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
>> +Note: Using the THERMAL_NO_LIMIT (-1UL) constant in the cooling-devic=
e phandle
>> +limit specifier means:
>> +(i)   - minimum state allowed for minimum cooling state used in the r=
eference.
>> +(ii)  - maximum state allowed for maximum cooling state used in the r=
eference.
>> +Refer to include/dt-bindings/thermal/thermal.h for definition of this=
 constant.
>> +
>> +* Thermal zone nodes
>> +
>> +The thermal zone node is the node containing all the required info
>> +for describing a thermal zone, including its cooling device bindings.=
 The
>> +thermal zone node must contain, apart from its own properties, one su=
b-node
>> +containing trip nodes and one sub-node containing all the zone coolin=
g maps.
>> +
>> +Required properties:
>> +- polling-delay:       The maximum number of milliseconds to wait bet=
ween polls
>> +  Type: unsigned       when checking this thermal zone.
>> +  Size: one cell
>> +
>> +- polling-delay-passive: The maximum number of milliseconds to wait
>> +  Type: unsigned       between polls when performing passive cooling.=

>> +  Size: one cell
>> +
>> +- thermal-sensors:     A list of thermal sensor phandles and sensor s=
pecifier
>> +  Type: list of        used while monitoring the thermal zone.
>> +  sensor phandles
>=20
> The type is wrong here. A list of phandle + sensor specifiers.
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
>> +- coefficients:                An array of integers (one signed cell)=
 containing
>> +  Type: array          coefficients to compose a linear relation betw=
een
>> +  Elem size: one cell  the sensors listed in the thermal-sensors prop=
erty.
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
>> +                       interpreted as constant offset.
>> +
>> +Note: The delay properties are bound to the maximum dT/dt (temperatur=
e
>> +derivative over time) in two situations for a thermal zone:
>> +(i)  - when passive cooling is activated (polling-delay-passive); and=

>> +(ii) - when the zone just needs to be monitored (polling-delay) or
>> +when active cooling is activated.
>> +
>> +The maximum dT/dt is highly bound to hardware power consumption and d=
issipation
>> +capability. The delays should be chosen to account for said max dT/dt=
,
>> +such that a device does not cross several trip boundaries unexpectedl=
y
>> +between polls. Choosing the right polling delays shall avoid having t=
he
>> +device in temperature ranges that may damage the silicon structures a=
nd
>> +reduce silicon lifetime.
>> +
>> +* The thermal-zones node
>> +
>> +The "thermal-zones" node is a container for all thermal zone nodes. I=
t shall
>> +contain only sub-nodes describing thermal zones as in the section
>> +"Thermal zone nodes". The "thermal-zones" node appears under "/".
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
>> +       /*
>> +        * Here is an example of describing a cooling device for a DVF=
S
>> +        * capable CPU. The CPU node describes its four OPPs.
>> +        * The cooling states possible are 0..3, and they are
>> +        * used as OPP indexes. The minimum cooling state is 0, which =
means
>> +        * all four OPPs can be available to the system. The maximum
>> +        * cooling state is 3, which means only the lowest OPPs (198MH=
z@0.85V)
>> +        * can be available in the system.
>> +        */
>> +       cpu0: cpu@0 {
>> +               ...
>> +               operating-points =3D <
>> +                       /* kHz    uV */
>> +                       970000  1200000
>> +                       792000  1100000
>> +                       396000  950000
>> +                       198000  850000
>> +               >;
>> +               cooling-min-state =3D <0>;
>> +               cooling-max-state =3D <3>;
>> +               #cooling-cells =3D <2>; /* min followed by max */
>> +       };
>> +       ...
>> +};
>> +
>> +&i2c1 {
>> +       ...
>> +       /*
>> +        * A simple fan controller which supports 10 speeds of operati=
on
>> +        * (represented as 0-9).
>> +        */
>> +       fan0: fan@0x48 {
>> +               ...
>> +               cooling-min-state =3D <0>;
>> +               cooling-max-state =3D <9>;
>> +               #cooling-cells =3D <2>; /* min followed by max */
>> +       };
>> +};
>> +
>> +ocp {
>> +       ...
>> +       /*
>> +        * A simple IC with a single bandgap temperature sensor.
>> +        */
>> +       bandgap0: bandgap@0x0000ED00 {
>> +               ...
>> +               #thermal-sensor-cells =3D <0>;
>> +       };
>> +};
>> +
>> +thermal-zones {
>> +       cpu-thermal: cpu-thermal {
>> +               polling-delay-passive =3D <250>; /* milliseconds */
>> +               polling-delay =3D <1000>; /* milliseconds */
>> +
>> +               thermal-sensors =3D <&bandgap0>;
>> +
>> +               trips {
>> +                       cpu-alert0: cpu-alert {
>> +                               temperature =3D <90000>; /* millicelsi=
us */
>> +                               hysteresis =3D <2000>; /* millicelsius=
 */
>> +                               type =3D "active";
>> +                       };
>> +                       cpu-alert1: cpu-alert {
>> +                               temperature =3D <100000>; /* millicels=
ius */
>> +                               hysteresis =3D <2000>; /* millicelsius=
 */
>> +                               type =3D "passive";
>> +                       };
>> +                       cpu-crit: cpu-crit {
>> +                               temperature =3D <125000>; /* millicels=
ius */
>> +                               hysteresis =3D <2000>; /* millicelsius=
 */
>> +                               type =3D "critical";
>> +                       };
>> +               };
>> +
>> +               cooling-maps {
>> +                       map0 {
>> +                               trip =3D <&cpu-alert0>;
>> +                               cooling-device =3D <&fan0 THERMAL_NO_L=
IMITS 4>;
>> +                       };
>> +                       map1 {
>> +                               trip =3D <&cpu-alert1>;
>> +                               cooling-device =3D <&fan0 5 THERMAL_NO=
_LIMITS>;
>> +                       };
>> +                       map2 {
>> +                               trip =3D <&cpu-alert1>;
>> +                               cooling-device =3D
>> +                                   <&cpu0 THERMAL_NO_LIMITS THERMAL_N=
O_LIMITS>;
>> +                       };
>> +               };
>> +       };
>> +};
>> +
>> +In the example above, the ADC sensor (bandgap0) at address 0x0000ED00=
 is
>> +used to monitor the zone 'cpu-thermal' using its sole sensor. A fan
>> +device (fan0) is controlled via I2C bus 1, at address 0x48, and has t=
en
>> +different cooling states 0-9. It is used to remove the heat out of
>> +the thermal zone 'cpu-thermal' using its cooling states
>> +from its minimum to 4, when it reaches trip point 'cpu-alert0'
>> +at 90C, as an example of active cooling. The same cooling device is u=
sed at
>> +'cpu-alert1', but from 5 to its maximum state. The cpu@0 device is al=
so
>> +linked to the same thermal zone, 'cpu-thermal', as a passive cooling =
device,
>> +using all its cooling states at trip point 'cpu-alert1',
>> +which is a trip point at 100C. On the thermal zone 'cpu-thermal', at =
the
>> +temperature of 125C, represented by the trip point 'cpu-crit', the si=
licon
>> +is not reliable anymore.
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
>> +ocp {
>> +       ...
>> +       /*
>> +        * A simple IC with several bandgap temperature sensors.
>> +        */
>> +       bandgap0: bandgap@0x0000ED00 {
>> +               ...
>> +               #thermal-sensor-cells =3D <1>;
>> +       };
>> +};
>> +
>> +thermal-zones {
>> +       cpu-thermal: cpu-thermal {
>> +               polling-delay-passive =3D <250>; /* milliseconds */
>> +               polling-delay =3D <1000>; /* milliseconds */
>> +
>> +                               /* sensor       ID */
>> +               thermal-sensors =3D <&bandgap0     0>;
>> +
>> +               trips {
>> +                       /* each zone within the SoC may have its own t=
rips */
>> +                       cpu-alert: cpu-alert {
>> +                               temperature =3D <100000>; /* millicels=
ius */
>> +                               hysteresis =3D <2000>; /* millicelsius=
 */
>> +                               type =3D "passive";
>> +                       };
>> +                       cpu-crit: cpu-crit {
>> +                               temperature =3D <125000>; /* millicels=
ius */
>> +                               hysteresis =3D <2000>; /* millicelsius=
 */
>> +                               type =3D "critical";
>> +                       };
>> +               };
>> +
>> +               cooling-maps {
>> +                       /* each zone within the SoC may have its own c=
ooling */
>> +                       ...
>> +               };
>> +       };
>> +
>> +       gpu-thermal: gpu-thermal {
>> +               polling-delay-passive =3D <120>; /* milliseconds */
>> +               polling-delay =3D <1000>; /* milliseconds */
>> +
>> +                               /* sensor       ID */
>> +               thermal-sensors =3D <&bandgap0     1>;
>> +
>> +               trips {
>> +                       /* each zone within the SoC may have its own t=
rips */
>> +                       gpu-alert: gpu-alert {
>> +                               temperature =3D <90000>; /* millicelsi=
us */
>> +                               hysteresis =3D <2000>; /* millicelsius=
 */
>> +                               type =3D "passive";
>> +                       };
>> +                       gpu-crit: gpu-crit {
>> +                               temperature =3D <105000>; /* millicels=
ius */
>> +                               hysteresis =3D <2000>; /* millicelsius=
 */
>> +                               type =3D "critical";
>> +                       };
>> +               };
>> +
>> +               cooling-maps {
>> +                       /* each zone within the SoC may have its own c=
ooling */
>> +                       ...
>> +               };
>> +       };
>> +
>> +       dsp-thermal: dsp-thermal {
>> +               polling-delay-passive =3D <50>; /* milliseconds */
>> +               polling-delay =3D <1000>; /* milliseconds */
>> +
>> +                               /* sensor       ID */
>> +               thermal-sensors =3D <&bandgap0     2>;
>> +
>> +               trips {
>> +                       /* each zone within the SoC may have its own t=
rips */
>> +                       dsp-alert: gpu-alert {
>> +                               temperature =3D <90000>; /* millicelsi=
us */
>> +                               hysteresis =3D <2000>; /* millicelsius=
 */
>> +                               type =3D "passive";
>> +                       };
>> +                       dsp-crit: gpu-crit {
>> +                               temperature =3D <135000>; /* millicels=
ius */
>> +                               hysteresis =3D <2000>; /* millicelsius=
 */
>> +                               type =3D "critical";
>> +                       };
>> +               };
>> +
>> +               cooling-maps {
>> +                       /* each zone within the SoC may have its own c=
ooling */
>> +                       ...
>> +               };
>> +       };
>> +};
>> +
>> +In the example above, there is one bandgap IC which has the capabilit=
y to
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
>> +#thermal-sensor-cells property and using the first cell of the sensor=

>> +specifier as sensor ID. In the example, then, <bandgap 0> is used to
>> +monitor CPU thermal zone, <bandgap 1> is used to monitor GPU thermal
>> +zone and <bandgap 2> is used to monitor DSP thermal zone. Each zone
>> +may be uncorrelated, having its own dT/dt requirements, trips
>> +and cooling maps.
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
>> +       /*
>> +        * A simple IC with a single temperature sensor.
>> +        */
>> +       adc: sensor@0x49 {
>> +               ...
>> +               #thermal-sensor-cells =3D <0>;
>> +       };
>> +};
>> +
>> +ocp {
>> +       ...
>> +       /*
>> +        * A simple IC with a single bandgap temperature sensor.
>> +        */
>> +       bandgap0: bandgap@0x0000ED00 {
>> +               ...
>> +               #thermal-sensor-cells =3D <0>;
>> +       };
>> +};
>> +
>> +thermal-zones {
>> +       cpu-thermal: cpu-thermal {
>> +               polling-delay-passive =3D <250>; /* milliseconds */
>> +               polling-delay =3D <1000>; /* milliseconds */
>> +
>> +               thermal-sensors =3D <&bandgap0>,  /* cpu */
>> +                                 <&adc>;       /* pcb north */
>> +
>> +               /* hotspot =3D 100 * bandgap - 120 * adc + 484 */
>> +               coefficients =3D          <100    -120    484>;
>> +
>> +               trips {
>> +                       ...
>> +               };
>> +
>> +               cooling-maps {
>> +                       ...
>> +               };
>> +       };
>> +};
>> +
>> +In some cases, there is a need to use more than one sensor to extrapo=
late
>> +a thermal hotspot in the silicon. The above example illustrates this =
situation.
>> +For instance, it may be the case that a sensor external to CPU IP may=
 be placed
>> +close to CPU hotspot and together with internal CPU sensor, it is use=
d
>> +to determine the hotspot. Assuming this is the case for the above exa=
mple,
>> +the hypothetical extrapolation rule would be:
>> +               hotspot =3D 100 * bandgap - 120 * adc + 484
>> +
>> +In other context, the same idea can be used to add fixed offset. For =
instance,
>> +consider the hotspot extrapolation rule below:
>> +               hotspot =3D 1 * adc + 6000
>> +
>> +In the above equation, the hotspot is always 6C higher than what is r=
ead
>> +from the ADC sensor. The binding would be then:
>> +        thermal-sensors =3D  <&adc>;
>> +
>> +               /* hotspot =3D 1 * adc + 6000 */
>> +       coefficients =3D          <1      6000>;
>> +
>> +(d) - Board thermal
>> +
>> +The board thermal example below illustrates how to setup one thermal =
zone
>> +with many sensors and many cooling devices.
>> +
>> +#include <dt-bindings/thermal/thermal.h>
>> +
>> +&i2c1 {
>> +       ...
>> +       /*
>> +        * An IC with several temperature sensor.
>> +        */
>> +       adc-dummy: sensor@0x50 {
>> +               ...
>> +               #thermal-sensor-cells =3D <1>; /* sensor internal ID *=
/
>> +       };
>> +};
>> +
>> +thermal-zones {
>> +       batt-thermal {
>> +               polling-delay-passive =3D <500>; /* milliseconds */
>> +               polling-delay =3D <2500>; /* milliseconds */
>> +
>> +                               /* sensor       ID */
>> +               thermal-sensors =3D <&adc-dummy     4>;
>> +
>> +               trips {
>> +                       ...
>> +               };
>> +
>> +               cooling-maps {
>> +                       ...
>> +               };
>> +       };
>> +
>> +       board-thermal: board-thermal {
>> +               polling-delay-passive =3D <1000>; /* milliseconds */
>> +               polling-delay =3D <2500>; /* milliseconds */
>> +
>> +                               /* sensor       ID */
>> +               thermal-sensors =3D <&adc-dummy     0>, /* pcb top edg=
e */
>> +                                 <&adc-dummy     1>, /* lcd */
>> +                                 <&adc-dymmy     2>; /* back cover */=

>> +               /*
>> +                * An array of coefficients describing the sensor
>> +                * linear relation. E.g.:
>> +                * z =3D c1*x1 + c2*x2 + c3*x3
>> +                */
>> +               coefficients =3D          <1200   -345    890>;
>> +
>> +               trips {
>> +                       /* Trips are based on resulting linear equatio=
n */
>> +                       cpu-trip: cpu-trip {
>> +                               temperature =3D <60000>; /* millicelsi=
us */
>> +                               hysteresis =3D <2000>; /* millicelsius=
 */
>> +                               type =3D "passive";
>> +                       };
>> +                       gpu-trip: gpu-trip {
>> +                               temperature =3D <55000>; /* millicelsi=
us */
>> +                               hysteresis =3D <2000>; /* millicelsius=
 */
>> +                               type =3D "passive";
>> +                       }
>> +                       lcd-trip: lcp-trip {
>> +                               temperature =3D <53000>; /* millicelsi=
us */
>> +                               hysteresis =3D <2000>; /* millicelsius=
 */
>> +                               type =3D "passive";
>> +                       };
>> +                       crit-trip: crit-trip {
>> +                               temperature =3D <68000>; /* millicelsi=
us */
>> +                               hysteresis =3D <2000>; /* millicelsius=
 */
>> +                               type =3D "critical";
>> +                       };
>> +               };
>> +
>> +               cooling-maps {
>> +                       map0 {
>> +                               trip =3D <&cpu-trip>;
>> +                               cooling-device =3D <&cpu0 0 2>;
>> +                               contribution =3D <55>;
>> +                       };
>> +                       map1 {
>> +                               trip =3D <&gpu-trip>;
>> +                               cooling-device =3D <&gpu0 0 2>;
>> +                               contribution =3D <20>;
>> +                       };
>> +                       map2 {
>> +                               trip =3D <&lcd-trip>;
>> +                               cooling-device =3D <&lcd0 5 10>;
>> +                               contribution =3D <15>;
>> +                       };
>> +               };
>> +       };
>> +};
>> +
>> +The above example is a mix of previous examples, a sensor IP with sev=
eral internal
>> +sensors used to monitor different zones, one of them is composed by s=
everal sensors and
>> +with different cooling devices.
>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>> index dbfc390..dd81eb8 100644
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
>> index 584b363..4b03956 100644
>> --- a/drivers/thermal/Makefile
>> +++ b/drivers/thermal/Makefile
>> @@ -7,6 +7,7 @@ thermal_sys-y                   +=3D thermal_core.o
>>
>>  # interface to/from other layers providing sensors
>>  thermal_sys-$(CONFIG_THERMAL_HWMON)            +=3D thermal_hwmon.o
>> +thermal_sys-$(CONFIG_THERMAL_OF)               +=3D of-thermal.o
>>
>>  # governors
>>  thermal_sys-$(CONFIG_THERMAL_GOV_FAIR_SHARE)   +=3D fair_share.o
>> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal=
=2Ec
>> new file mode 100644
>> index 0000000..66f9eb2
>> --- /dev/null
>> +++ b/drivers/thermal/of-thermal.c
>> @@ -0,0 +1,849 @@
>> +/*
>> + *  of-thermal.c - Generic Thermal Management device tree support.
>> + *
>> + *  Copyright (C) 2013 Texas Instruments
>> + *  Copyright (C) 2013 Eduardo Valentin <eduardo.valentin@ti.com>
>> + *
>> + *
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
>> +#include "thermal_core.h"
>> +
>> +/***   Private data structures to represent thermal device tree data =
***/
>> +
>> +/**
>> + * struct __thermal_trip - representation of a point in temperature d=
omain
>> + * @np: pointer to struct device_node that this trip point was create=
d from
>> + * @temperature: temperature value in miliCelsius
>> + * @hysteresis: relative hysteresis in miliCelsius
>> + * @type: trip point type
>> + */
>> +
>> +struct __thermal_trip {
>> +       struct device_node *np;
>> +       unsigned long int temperature;
>> +       unsigned long int hysteresis;
>> +       enum thermal_trip_type type;
>> +};
>> +
>> +/**
>> + * struct __thermal_bind_param - a match between trip and cooling dev=
ice
>> + * @cooling_device: a pointer to identify the referred cooling device=

>> + * @trip_id: the trip point index
>> + * @usage: the percentage (from 0 to 100) of cooling contribution
>> + * @min: minimum cooling state used at this trip point
>> + * @max: maximum cooling state used at this trip point
>> + */
>> +
>> +struct __thermal_bind_params {
>> +       struct device_node *cooling_device;
>> +       unsigned int trip_id;
>> +       unsigned int usage;
>> +       unsigned long min;
>> +       unsigned long max;
>> +};
>> +
>> +/**
>> + * struct __thermal_zone - internal representation of a thermal zone
>> + * @mode: current thermal zone device mode (enabled/disabled)
>> + * @passive_delay: polling interval while passive cooling is activate=
d
>> + * @polling_delay: zone polling interval
>> + * @ntrips: number of trip points
>> + * @trips: an array of trip points (0..ntrips - 1)
>> + * @num_tbps: number of thermal bind params
>> + * @tbps: an array of thermal bind params (0..num_tbps - 1)
>> + * @sensor_data: sensor private data used while reading temperature a=
nd trend
>> + * @get_temp: sensor callback to read temperature
>> + * @get_trend: sensor callback to read temperature trend
>> + */
>> +
>> +struct __thermal_zone {
>> +       enum thermal_device_mode mode;
>> +       int passive_delay;
>> +       int polling_delay;
>> +
>> +       /* trip data */
>> +       int ntrips;
>> +       struct __thermal_trip *trips;
>> +
>> +       /* cooling binding data */
>> +       int num_tbps;
>> +       struct __thermal_bind_params *tbps;
>> +
>> +       /* sensor interface */
>> +       void *sensor_data;
>> +       int (*get_temp)(void *, long *);
>> +       int (*get_trend)(void *, long *);
>> +};
>> +
>> +/***   DT thermal zone device callbacks   ***/
>> +
>> +static int of_thermal_get_temp(struct thermal_zone_device *tz,
>> +                              unsigned long *temp)
>> +{
>> +       struct __thermal_zone *data =3D tz->devdata;
>> +
>> +       if (!data->get_temp)
>> +               return -EINVAL;
>> +
>> +       return data->get_temp(data->sensor_data, temp);
>> +}
>> +
>> +static int of_thermal_get_trend(struct thermal_zone_device *tz, int t=
rip,
>> +                               enum thermal_trend *trend)
>> +{
>> +       struct __thermal_zone *data =3D tz->devdata;
>> +       long dev_trend;
>> +       int r;
>> +
>> +       if (!data->get_trend)
>> +               return -EINVAL;
>> +
>> +       r =3D data->get_trend(data->sensor_data, &dev_trend);
>> +       if (r)
>> +               return r;
>> +
>> +       /* TODO: These intervals might have some thresholds, but in co=
re code */
>> +       if (dev_trend > 0)
>> +               *trend =3D THERMAL_TREND_RAISING;
>> +       else if (dev_trend < 0)
>> +               *trend =3D THERMAL_TREND_DROPPING;
>> +       else
>> +               *trend =3D THERMAL_TREND_STABLE;
>> +
>> +       return 0;
>> +}
>> +
>> +static int of_thermal_bind(struct thermal_zone_device *thermal,
>> +                          struct thermal_cooling_device *cdev)
>> +{
>> +       struct __thermal_zone *data =3D thermal->devdata;
>> +       int i;
>> +
>> +       if (!data || IS_ERR(data))
>> +               return -ENODEV;
>> +
>> +       /* find where to bind */
>> +       for (i =3D 0; i < data->num_tbps; i++) {
>> +               struct __thermal_bind_params *tbp =3D data->tbps + i;
>> +
>> +               if (tbp->cooling_device =3D=3D cdev->np) {
>> +                       int ret;
>> +
>> +                       ret =3D thermal_zone_bind_cooling_device(therm=
al,
>> +                                               tbp->trip_id, cdev,
>> +                                               tbp->min,
>> +                                               tbp->max);
>> +                       if (ret)
>> +                               return ret;
>> +               }
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int of_thermal_unbind(struct thermal_zone_device *thermal,
>> +                            struct thermal_cooling_device *cdev)
>> +{
>> +       struct __thermal_zone *data =3D thermal->devdata;
>> +       int i;
>> +
>> +       if (!data || IS_ERR(data))
>> +               return -ENODEV;
>> +
>> +       /* find where to unbind */
>> +       for (i =3D 0; i < data->num_tbps; i++) {
>> +               struct __thermal_bind_params *tbp =3D data->tbps + i;
>> +
>> +               if (tbp->cooling_device =3D=3D cdev->np) {
>> +                       int ret;
>> +
>> +                       ret =3D thermal_zone_unbind_cooling_device(the=
rmal,
>> +                                               tbp->trip_id, cdev);
>> +                       if (ret)
>> +                               return ret;
>> +               }
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int of_thermal_get_mode(struct thermal_zone_device *tz,
>> +                              enum thermal_device_mode *mode)
>> +{
>> +       struct __thermal_zone *data =3D tz->devdata;
>> +
>> +       *mode =3D data->mode;
>> +
>> +       return 0;
>> +}
>> +
>> +static int of_thermal_set_mode(struct thermal_zone_device *tz,
>> +                              enum thermal_device_mode mode)
>> +{
>> +       struct __thermal_zone *data =3D tz->devdata;
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
>> +static int of_thermal_get_trip_type(struct thermal_zone_device *tz, i=
nt trip,
>> +                                   enum thermal_trip_type *type)
>> +{
>> +       struct __thermal_zone *data =3D tz->devdata;
>> +
>> +       if (trip >=3D data->ntrips || trip < 0)
>> +               return -EDOM;
>> +
>> +       *type =3D data->trips[trip].type;
>> +
>> +       return 0;
>> +}
>> +
>> +static int of_thermal_get_trip_temp(struct thermal_zone_device *tz, i=
nt trip,
>> +                                   unsigned long *temp)
>> +{
>> +       struct __thermal_zone *data =3D tz->devdata;
>> +
>> +       if (trip >=3D data->ntrips || trip < 0)
>> +               return -EDOM;
>> +
>> +       *temp =3D data->trips[trip].temperature;
>> +
>> +       return 0;
>> +}
>> +
>> +static int of_thermal_set_trip_temp(struct thermal_zone_device *tz, i=
nt trip,
>> +                                   unsigned long temp)
>> +{
>> +       struct __thermal_zone *data =3D tz->devdata;
>> +
>> +       if (trip >=3D data->ntrips || trip < 0)
>> +               return -EDOM;
>> +
>> +       /* thermal framework should take care of data->mask & (1 << tr=
ip) */
>> +       data->trips[trip].temperature =3D temp;
>> +
>> +       return 0;
>> +}
>> +
>> +static int of_thermal_get_trip_hyst(struct thermal_zone_device *tz, i=
nt trip,
>> +                                   unsigned long *hyst)
>> +{
>> +       struct __thermal_zone *data =3D tz->devdata;
>> +
>> +       if (trip >=3D data->ntrips || trip < 0)
>> +               return -EDOM;
>> +
>> +       *hyst =3D data->trips[trip].hysteresis;
>> +
>> +       return 0;
>> +}
>> +
>> +static int of_thermal_set_trip_hyst(struct thermal_zone_device *tz, i=
nt trip,
>> +                                   unsigned long hyst)
>> +{
>> +       struct __thermal_zone *data =3D tz->devdata;
>> +
>> +       if (trip >=3D data->ntrips || trip < 0)
>> +               return -EDOM;
>> +
>> +       /* thermal framework should take care of data->mask & (1 << tr=
ip) */
>> +       data->trips[trip].hysteresis =3D hyst;
>> +
>> +       return 0;
>> +}
>> +
>> +static int of_thermal_get_crit_temp(struct thermal_zone_device *tz,
>> +                                   unsigned long *temp)
>> +{
>> +       struct __thermal_zone *data =3D tz->devdata;
>> +       int i;
>> +
>> +       for (i =3D 0; i < data->ntrips; i++)
>> +               if (data->trips[i].type =3D=3D THERMAL_TRIP_CRITICAL) =
{
>> +                       *temp =3D data->trips[i].temperature;
>> +                       return 0;
>> +               }
>> +
>> +       return -EINVAL;
>> +}
>> +
>> +static struct thermal_zone_device_ops of_thermal_ops =3D {
>> +       .get_mode =3D of_thermal_get_mode,
>> +       .set_mode =3D of_thermal_set_mode,
>> +
>> +       .get_trip_type =3D of_thermal_get_trip_type,
>> +       .get_trip_temp =3D of_thermal_get_trip_temp,
>> +       .set_trip_temp =3D of_thermal_set_trip_temp,
>> +       .get_trip_hyst =3D of_thermal_get_trip_hyst,
>> +       .set_trip_hyst =3D of_thermal_set_trip_hyst,
>> +       .get_crit_temp =3D of_thermal_get_crit_temp,
>> +
>> +       .bind =3D of_thermal_bind,
>> +       .unbind =3D of_thermal_unbind,
>> +};
>> +
>> +/***   sensor API   ***/
>> +
>> +static struct thermal_zone_device *
>> +thermal_zone_of_add_sensor(struct device_node *zone,
>> +                          struct device_node *sensor, void *data,
>> +                          int (*get_temp)(void *, long *),
>> +                          int (*get_trend)(void *, long *))
>> +{
>> +       struct thermal_zone_device *tzd;
>> +       struct __thermal_zone *tz;
>> +
>> +       tzd =3D thermal_zone_get_zone_by_name(zone->name);
>> +       if (IS_ERR(tzd))
>> +               return ERR_PTR(-EPROBE_DEFER);
>> +
>> +       tz =3D tzd->devdata;
>> +
>> +       mutex_lock(&tzd->lock);
>> +       tz->get_temp =3D get_temp;
>> +       tz->get_trend =3D get_trend;
>> +       tz->sensor_data =3D data;
>> +
>> +       tzd->ops->get_temp =3D of_thermal_get_temp;
>> +       tzd->ops->get_trend =3D of_thermal_get_trend;
>> +       mutex_unlock(&tzd->lock);
>> +
>> +       return tzd;
>> +}
>> +
>> +/**
>> + * thermal_zone_of_sensor_register - registers a sensor to a DT therm=
al zone
>> + * @dev: a valid struct device pointer of a sensor device. Must conta=
in
>> + *       a valid .of_node, for the sensor node.
>> + * @sensor_id: a sensor identifier, in case the sensor IP has more
>> + *             than one sensors
>> + * @data: a private pointer (owned by the caller) that will be passed=

>> + *        back, when a temperature reading is needed.
>> + * @get_temp: a pointer to a function that reads the sensor temperatu=
re.
>> + * @get_trend: a pointer to a function that reads the sensor temperat=
ure trend.
>> + *
>> + * This function will search the list of thermal zones described in d=
evice
>> + * tree and look for the zone that refer to the sensor device pointed=
 by
>> + * @dev->of_node as temperature providers. For the zone pointing to t=
he
>> + * sensor node, the sensor will be added to the DT thermal zone devic=
e.
>> + *
>> + * The thermal zone temperature is provided by the @get_temp function=

>> + * pointer. When called, it will have the private pointer @data back.=

>> + *
>> + * The thermal zone temperature trend is provided by the @get_trend f=
unction
>> + * pointer. When called, it will have the private pointer @data back.=

>> + *
>> + * TODO:
>> + * 01 - This function must enqueue the new sensor instead of using
>> + * it as the only source of temperature values.
>> + *
>> + * 02 - There must be a way to match the sensor with all thermal zone=
s
>> + * that refer to it.
>> + *
>> + * Return: On success returns a valid struct thermal_zone_device,
>> + * otherwise, it returns a corresponding ERR_PTR(). Caller must
>> + * check the return value with help of IS_ERR() helper.
>> + */
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
>> +               if (sensor_specs.args_count >=3D 1) {
>> +                       id =3D sensor_specs.args[0];
>> +                       WARN(sensor_specs.args_count > 1,
>> +                            "%s: too many cells in sensor specifier %=
d\n",
>> +                            sensor_specs.np->name, sensor_specs.args_=
count);
>> +               } else {
>> +                       id =3D 0;
>> +               }
>> +
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
>> +
>> +/**
>> + * thermal_zone_of_sensor_unregister - unregisters a sensor from a DT=
 thermal zone
>> + * @dev: a valid struct device pointer of a sensor device. Must conta=
in
>> + *       a valid .of_node, for the sensor node.
>> + * @tzd: a pointer to struct thermal_zone_device where the sensor is =
registered.
>> + *
>> + * This function removes the sensor callbacks and private data from t=
he
>> + * thermal zone device registered with thermal_zone_of_sensor_registe=
r()
>> + * API. It will also silent the zone by remove the .get_temp() and .g=
et_trend()
>> + * thermal zone device callbacks.
>> + *
>> + * TODO: When the support to several sensors per zone is added, this
>> + * function must search the sensor list based on @dev parameter.
>> + *
>> + */
>> +void thermal_zone_of_sensor_unregister(struct device *dev,
>> +                                      struct thermal_zone_device *tzd=
)
>> +{
>> +       struct __thermal_zone *tz;
>> +
>> +       if (!dev || !tzd || !tzd->devdata)
>> +               return;
>> +
>> +       tz =3D tzd->devdata;
>> +
>> +       /* no __thermal_zone, nothing to be done */
>> +       if (!tz)
>> +               return;
>> +
>> +       mutex_lock(&tzd->lock);
>> +       tzd->ops->get_temp =3D NULL;
>> +       tzd->ops->get_trend =3D NULL;
>> +
>> +       tz->get_temp =3D NULL;
>> +       tz->get_trend =3D NULL;
>> +       tz->sensor_data =3D NULL;
>> +       mutex_unlock(&tzd->lock);
>> +}
>> +EXPORT_SYMBOL_GPL(thermal_zone_of_sensor_unregister);
>> +
>> +/***   functions parsing device tree nodes   ***/
>> +
>> +/**
>> + * thermal_of_populate_bind_params - parse and fill cooling map data
>> + * @np: DT node containing a cooling-map node
>> + * @__tbp: data structure to be filled with cooling map info
>> + * @trips: array of thermal zone trip points
>> + * @ntrips: number of trip points inside trips.
>> + *
>> + * This function parses a cooling-map type of node represented by
>> + * @np parameter and fills the read data into @__tbp data structure.
>> + * It needs the already parsed array of trip points of the thermal zo=
ne
>> + * in consideration.
>> + *
>> + * Return: 0 on success, proper error code otherwise
>> + */
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
>> +       ret =3D of_property_read_u32(np, "contribution", &prop);
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
>> + * It maps 'enum thermal_trip_type' found in include/linux/thermal.h
>> + * into the device tree binding of 'trip', property type.
>> + */
>> +static const char * const trip_types[] =3D {
>> +       [THERMAL_TRIP_ACTIVE]   =3D "active",
>> +       [THERMAL_TRIP_PASSIVE]  =3D "passive",
>> +       [THERMAL_TRIP_HOT]      =3D "hot",
>> +       [THERMAL_TRIP_CRITICAL] =3D "critical",
>> +};
>> +
>> +/**
>> + * thermal_of_get_trip_type - Get phy mode for given device_node
>> + * @np:        Pointer to the given device_node
>> + * @type: Pointer to resulting trip type
>> + *
>> + * The function gets trip type string from property 'type',
>> + * and store its index in trip_types table in @type,
>> + *
>> + * Return: 0 on success, or errno in error case.
>> + */
>> +static int thermal_of_get_trip_type(struct device_node *np,
>> +                                   enum thermal_trip_type *type)
>> +{
>> +       const char *t;
>> +       int err, i;
>> +
>> +       err =3D of_property_read_string(np, "type", &t);
>> +       if (err < 0)
>> +               return err;
>> +
>> +       for (i =3D 0; i < ARRAY_SIZE(trip_types); i++)
>> +               if (!strcasecmp(t, trip_types[i])) {
>> +                       *type =3D i;
>> +                       return 0;
>> +               }
>> +
>> +       return -ENODEV;
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
>> +       ret =3D thermal_of_get_trip_type(np, &trip->type);
>> +       if (ret < 0) {
>> +               pr_err("wrong trip type property\n");
>> +               return ret;
>> +       }
>> +
>> +       /* Required for cooling map matching */
>> +       trip->np =3D np;
>> +
>> +       return 0;
>> +}
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
>> + * TODO: Missing properties to parse: thermal-sensor-names and coeffi=
cients
>> + *
>> + * Return: On success returns a valid struct __thermal_zone,
>> + * otherwise, it returns a corresponding ERR_PTR(). Caller must
>> + * check the return value with help of IS_ERR() helper.
>> + */
>> +static struct __thermal_zone *
>> +thermal_of_build_thermal_zone(struct device_node *np)
>> +{
>> +       struct device_node *child =3D NULL, *gchild;
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
>> +       ret =3D of_property_read_u32(np, "polling-delay-passive", &pro=
p);
>> +       if (ret < 0) {
>> +               pr_err("missing polling-delay-passive property\n");
>> +               goto free_tz;
>> +       }
>> +       tz->passive_delay =3D prop;
>> +
>> +       ret =3D of_property_read_u32(np, "polling-delay", &prop);
>> +       if (ret < 0) {
>> +               pr_err("missing polling-delay property\n");
>> +               goto free_tz;
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
>> +       if (tz->ntrips =3D=3D 0) /* must have at least one child */
>> +               goto finish;
>> +
>> +       tz->trips =3D kzalloc(tz->ntrips * sizeof(*tz->trips), GFP_KER=
NEL);
>> +       if (!tz->trips) {
>> +               ret =3D -ENOMEM;
>> +               goto free_tz;
>> +       }
>> +
>> +       i =3D 0;
>> +       for_each_child_of_node(child, gchild) {
>> +               ret =3D thermal_of_populate_trip(gchild, &tz->trips[i+=
+]);
>> +               if (ret)
>> +                       goto free_trips;
>> +       }
>> +
>> +       of_node_put(child);
>> +
>> +       /* cooling-maps */
>> +       child =3D of_get_child_by_name(np, "cooling-maps");
>> +
>> +       /* cooling-maps not provided */
>> +       if (!child)
>> +               goto finish;
>> +
>> +       tz->num_tbps =3D of_get_child_count(child);
>> +       if (tz->num_tbps =3D=3D 0)
>> +               goto finish;
>> +
>> +       tz->tbps =3D kzalloc(tz->num_tbps * sizeof(*tz->tbps), GFP_KER=
NEL);
>> +       if (!tz->tbps) {
>> +               ret =3D -ENOMEM;
>> +               goto free_trips;
>> +       }
>> +
>> +       i =3D 0;
>> +       for_each_child_of_node(child, gchild)
>> +               ret =3D thermal_of_populate_bind_params(gchild, &tz->t=
bps[i++],
>> +                                                     tz->trips, tz->n=
trips);
>> +               if (ret)
>> +                       goto free_tbps;
>> +
>> +finish:
>> +       of_node_put(child);
>> +       tz->mode =3D THERMAL_DEVICE_DISABLED;
>> +
>> +       return tz;
>> +
>> +free_tbps:
>> +       kfree(tz->tbps);
>> +free_trips:
>> +       kfree(tz->trips);
>> +free_tz:
>> +       kfree(tz);
>> +       of_node_put(child);
>> +
>> +       return ERR_PTR(ret);
>> +}
>> +
>> +static inline void of_thermal_free_zone(struct __thermal_zone *tz)
>> +{
>> +       kfree(tz->tbps);
>> +       kfree(tz->trips);
>> +       kfree(tz);
>> +}
>> +
>> +/**
>> + * of_parse_thermal_zones - parse device tree thermal data
>> + *
>> + * Initialization function that can be called by machine initializati=
on
>> + * code to parse thermal data and populate the thermal framework
>> + * with hardware thermal zones info. This function only parses therma=
l zones.
>> + * Cooling devices and sensor devices nodes are supposed to be parsed=

>> + * by their respective drivers.
>> + *
>> + * Return: 0 on success, proper error code otherwise
>> + *
>> + */
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
>> +
>> +/**
>> + * of_thermal_destroy_zones - remove all zones parsed and allocated r=
esources
>> + *
>> + * Finds all zones parsed and added to the thermal framework and remo=
ve them
>> + * from the system, together with their resources.
>> + *
>> + */
>> +void __exit of_thermal_destroy_zones(void)
>> +{
>> +       struct device_node *np, *child;
>> +
>> +       np =3D of_find_node_by_name(NULL, "thermal-zones");
>> +       if (!np) {
>> +               pr_err("unable to find thermal zones\n");
>> +               return;
>> +       }
>> +
>> +       for_each_child_of_node(np, child) {
>> +               struct thermal_zone_device *zone;
>> +
>> +               zone =3D thermal_zone_get_zone_by_name(child->name);
>> +               if (IS_ERR(zone))
>> +                       continue;
>> +
>> +               thermal_zone_device_unregister(zone);
>> +               kfree(zone->tzp);
>> +               kfree(zone->ops);
>> +               of_thermal_free_zone(zone->devdata);
>> +       }
>> +}
>> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_=
core.c
>> index f7a9f4f..fec3351 100644
>> --- a/drivers/thermal/thermal_core.c
>> +++ b/drivers/thermal/thermal_core.c
>> @@ -1371,7 +1371,7 @@ static void remove_trip_attrs(struct thermal_zon=
e_device *tz)
>>   */
>>  struct thermal_zone_device *thermal_zone_device_register(const char *=
type,
>>         int trips, int mask, void *devdata,
>> -       const struct thermal_zone_device_ops *ops,
>> +       struct thermal_zone_device_ops *ops,
>>         const struct thermal_zone_params *tzp,
>>         int passive_delay, int polling_delay)
>>  {
>> @@ -1751,8 +1751,14 @@ static int __init thermal_init(void)
>>         if (result)
>>                 goto unregister_class;
>>
>> +       result =3D of_parse_thermal_zones();
>> +       if (result)
>> +               goto exit_netlink;
>> +
>>         return 0;
>>
>> +exit_netlink:
>> +       genetlink_exit();
>>  unregister_governors:
>>         thermal_unregister_governors();
>>  unregister_class:
>> @@ -1768,6 +1774,7 @@ error:
>>
>>  static void __exit thermal_exit(void)
>>  {
>> +       of_thermal_destroy_zones();
>>         genetlink_exit();
>>         class_unregister(&thermal_class);
>>         thermal_unregister_governors();
>> diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_=
core.h
>> index 7cf2f66..3db339f 100644
>> --- a/drivers/thermal/thermal_core.h
>> +++ b/drivers/thermal/thermal_core.h
>> @@ -77,4 +77,13 @@ static inline int thermal_gov_user_space_register(v=
oid) { return 0; }
>>  static inline void thermal_gov_user_space_unregister(void) {}
>>  #endif /* CONFIG_THERMAL_GOV_USER_SPACE */
>>
>> +/* device tree support */
>> +#ifdef CONFIG_THERMAL_OF
>> +int of_parse_thermal_zones(void);
>> +void of_thermal_destroy_zones(void);
>> +#else
>> +static inline int of_parse_thermal_zones(void) { return 0; }
>> +static inline void of_thermal_destroy_zones(void) { }
>> +#endif
>> +
>>  #endif /* __THERMAL_CORE_H__ */
>> diff --git a/include/dt-bindings/thermal/thermal.h b/include/dt-bindin=
gs/thermal/thermal.h
>> new file mode 100644
>> index 0000000..59c4581
>> --- /dev/null
>> +++ b/include/dt-bindings/thermal/thermal.h
>> @@ -0,0 +1,27 @@
>> +/*
>> + * This header provides constants for most thermal bindings.
>> + *
>> + * Copyright (C) 2013 Texas Instruments
>> + *     Eduardo Valentin <eduardo.valentin@ti.com>
>> + *
>> + * GPLv2 only
>> + */
>> +
>> +#ifndef _DT_BINDINGS_THERMAL_THERMAL_H
>> +#define _DT_BINDINGS_THERMAL_THERMAL_H
>> +
>> +/*
>> + * Here are the thermal trip types. This must
>> + * match with enum thermal_trip_type at
>> + * include/linux/thermal.h
>> + */
>> +#define THERMAL_TRIP_ACTIVE            "active"
>> +#define THERMAL_TRIP_PASSIVE           "passive"
>> +#define THERMAL_TRIP_HOT               "hot"
>> +#define THERMAL_TRIP_CRITICAL          "critical"
>=20
> I don't like this. If someone wants to include this in a C file they ca=
n't do so
> at the same time as include/linux/thermal.h. The defined names are long=
er than
> the actual string values, and the comment makes it sound like these cou=
ld be
> modified rather than being a fixed ABI.
>=20
> I do not see the point of these constants.
>=20
> Thanks,
> Mark.
>=20
>> +
>> +/* On cooling devices upper and lower limits */
>> +#define THERMAL_NO_LIMIT               (-1UL)
>> +
>> +#endif
>> +
>> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
>> index b268d3c..b780c5b 100644
>> --- a/include/linux/thermal.h
>> +++ b/include/linux/thermal.h
>> @@ -143,6 +143,7 @@ struct thermal_cooling_device {
>>         int id;
>>         char type[THERMAL_NAME_LENGTH];
>>         struct device device;
>> +       struct device_node *np;
>>         void *devdata;
>>         const struct thermal_cooling_device_ops *ops;
>>         bool updated; /* true if the cooling device does not need upda=
te */
>> @@ -172,7 +173,7 @@ struct thermal_zone_device {
>>         int emul_temperature;
>>         int passive;
>>         unsigned int forced_passive;
>> -       const struct thermal_zone_device_ops *ops;
>> +       struct thermal_zone_device_ops *ops;
>>         const struct thermal_zone_params *tzp;
>>         struct thermal_governor *governor;
>>         struct list_head thermal_instances;
>> @@ -242,8 +243,31 @@ struct thermal_genl_event {
>>  };
>>
>>  /* Function declarations */
>> +#ifdef CONFIG_THERMAL_OF
>> +struct thermal_zone_device *
>> +thermal_zone_of_sensor_register(struct device *dev, int id,
>> +                               void *data, int (*get_temp)(void *, lo=
ng *),
>> +                               int (*get_trend)(void *, long *));
>> +void thermal_zone_of_sensor_unregister(struct device *dev,
>> +                                      struct thermal_zone_device *tz)=
;
>> +#else
>> +static inline struct thermal_zone_device *
>> +thermal_zone_of_sensor_register(struct device *dev, int id,
>> +                               void *data, int (*get_temp)(void *, lo=
ng *),
>> +                               int (*get_trend)(void *, long *))
>> +{
>> +       return NULL;
>> +}
>> +
>> +static inline
>> +void thermal_zone_of_sensor_unregister(struct device *dev,
>> +                                      struct thermal_zone_device *tz)=

>> +{
>> +}
>> +
>> +#endif
>>  struct thermal_zone_device *thermal_zone_device_register(const char *=
, int, int,
>> -               void *, const struct thermal_zone_device_ops *,
>> +               void *, struct thermal_zone_device_ops *,
>>                 const struct thermal_zone_params *, int, int);
>>  void thermal_zone_device_unregister(struct thermal_zone_device *);
>>
>> --
>> 1.8.2.1.342.gfa7285d
>>
>>
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--xWIpWHQx3x0bsexmvP62FCVkoeGcDWawM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJ5NCkACgkQCXcVR3XQvP0f8AD9FvGjPNSJs+SDSv9kCeG8ssas
hd6/SeZCjp6bdzwWJqQA/jHRa76w+emGhUvhN/l5loXHoAvvQClEfYZC6MlJPKSS
=2hd7
-----END PGP SIGNATURE-----

--xWIpWHQx3x0bsexmvP62FCVkoeGcDWawM--
