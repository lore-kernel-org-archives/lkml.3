Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab3IGAUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 20:20:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52475 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab3IGAUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 20:20:52 -0400
Message-ID: <522A710F.1040504@ti.com>
Date: Fri, 6 Sep 2013 20:19:27 -0400
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
References: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com> <1377299755-5134-3-git-send-email-eduardo.valentin@ti.com> <20130827102205.GC19893@e106331-lin.cambridge.arm.com> <521CAD48.2030306@ti.com> <20130827162309.GR19893@e106331-lin.cambridge.arm.com> <521CED34.2090008@ti.com> <521FD70F.7080104@ti.com> <20130903131554.GE18206@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130903131554.GE18206@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="Fj3Vad5sRKoq8orBFi1qwl85axhxK3euq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Fj3Vad5sRKoq8orBFi1qwl85axhxK3euq
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Mark, Stephen and Pawel,

On 03-09-2013 09:15, Mark Rutland wrote:
> On Fri, Aug 30, 2013 at 12:19:43AM +0100, Eduardo Valentin wrote:

<cut>

> I think that the above can describe that, but I'd like to see a binding=

> document so we can consider it in more detail.

Find below another proposal. It is the updated binding document, with
the your comments applied (at least those I agree :-) ). It is obviously
an work in progress, but I think it is getting closer to what we are
trying to achieve, I believe. And of course, much better after using
your suggestions.

As I stated before, I believe it is crucial to first agree on the
bindings, then I can go ahead and update the corresponding code.

The change from the last binding examples I sent is basically on sensors
and cooling devices. This time, as suggested by Mark, I am adding
cooling device nodes (or at least properties to be embedded into
existing nodes). At some point, I remember that Pawel was not so in
favor on this type of node, but lets discuss on top of the document
below. I also added the #cells properties, as needed.

Hopefully we may end with an agreement. :-)

So, the document would look like this:

-----------------------------------------------------------------------
* Thermal Framework Device Tree descriptor

Generic binding to provide a way of defining hardware thermal
structure using device tree. A thermal structure includes thermal
zones and their components, such as trip points, polling intervals,
sensors and cooling devices binding descriptors.

The target of device tree thermal descriptors is to describe only
the hardware thermal aspects, not how the system must control or which
algorithm or policy must be taken in place.

There are five types of nodes involved to describe thermal bindings:
- sensors: used to describe the device source of temperature sensing;
- cooling devices: used to describe devices source of power dissipation
control;
- trip points: used to describe points in temperature domain defined to
make the system aware of hardware limits;
- cooling attachments: used to describe links between trip points and
cooling devices;
- thermal zones: used to describe thermal data within the hardware;

It follows a description of each type of these device tree nodes.

* Sensor devices

Sensor devices are nodes providing temperature sensing capabilities on
thermal
zones. Typical devices are I2C ADC converters and bandgaps. Theses are no=
des
providing temperature data to thermal zones. Temperature sensor devices m=
ay
control one or more internal sensors.

Required property:
- #sensor-cells:	Used to provide sensor device specific information
			while referring to it. Must be at least 1, in order
			to identify uniquely the sensor instances within
			the IC. See thermal zone binding for more details
			on how consumers refer to sensor devices.

* Cooling device nodes

Cooling devices are nodes providing control on power dissipation. There
are essentially two ways to provide control on power dissipation. First
is by means of regulating device performance, which is known as passive
cooling. Second is by means of activating devices in order to remove
the dissipated heat, which is known as active cooling, e.g. regulating
fan speeds. In both cases, cooling devices shall have a way to determine
the level of cooling.

Required property:
- cooling-min-level:	A unsigned integer indicating the smallest
			cooling level accepted. Typically 0.
- cooling-max-level:	An unsigned integer indicating the largest
			cooling level accepted.
- #cooling-cells:	Used to provide cooling device specific information
			while referring to it. Must be at least 2, in order
			to specify minimum and maximum cooling level used
			in the reference. See Cooling device attachments section
			below for more details on how consumers refer to
			cooling devices.

* Trip points

The trip node is a node to describe a point in the temperature domain
in which the system takes an action. This node describes just the point,
not the action.

Required properties:
- temperature:		the trip temperature level, in milliCelsius.
- hysteresis:		a (low) hysteresis value on 'temperature'. This is a
			relative value, in milliCelsius.
- type:			the trip type. Here is the type mapping:
	THERMAL_TRIP_ACTIVE	0:	A trip point to enable active cooling
	THERMAL_TRIP_PASSIVE	1:	A trip point to enable passive cooling
	THERMAL_TRIP_HOT	2:	A trip point to notify emergency
	THERMAL_TRIP_CRITICAL	3:	Hardware not reliable.

Refer to include/dt-bindings/thermal/thermal.h for definition of these
consts.

* Cooling device attachments

The cooling device attachments node is a node to describe how cooling
devices
get assigned to trip points of the zone. The cooling devices are expected=

to be loaded in the target system.

Required properties:
- cooling-device:	A phandle of a cooling device with its parameters,
			referring to which cooling device is used in this
			binding. The required parameters are: the minimum
			cooling level and the maximum cooling level used
			in this attach.
- trip:			A phandle of a trip point node within the same thermal
			zone.

Optional property:
- contribution:		The cooling contribution to the thermal zone of the
			referred cooling device at the referred trip point.
			The contribution is a value from 0 to 100. The sum
			of all cooling contributions within a thermal zone
			must never exceed 100.

Note: Using the THERMAL_NO_LIMIT (-1L) constant in the cooling-device
phandle
limit parameters means:
(i)   - minimum level allowed for minimum cooling level used in the
reference.
(ii)  - maximum level allowed for maximum cooling level used in the
reference.
Refer to include/dt-bindings/thermal/thermal.h for definition of this
constant.

* Thermal zones

The thermal-zone node is the node containing all the required info
for describing a thermal zone, including its cdev bindings. The thermal_z=
one
node must contain, apart from its own properties, one node containing
trip nodes and one node containing all the zone cooling attachments.

Required properties:
- passive-delay:	The maximum number of milliseconds to wait between polls=

			when performing passive cooling.
- polling-delay:	The maximum number of milliseconds to wait between polls=

			when checking this thermal zone.
- sensors:		A list of sensor phandles and their parameters. The
			required parameter is the sensor id, in order to
			identify internal sensors when the sensor IC features
			several sensing units.
- trips:		A sub-node containing several trip point nodes required
			to describe the thermal zone.
- cooling-attachments	A sub-node containing several cooling device attach=
es
			nodes, used to describe the relation between trips
			and cooling devices.

Optional property:
- coefficients:		An array of integers (one signed cell) containing
			coefficients to compose a linear relation between
			the sensors described in the sensors property.
			Coefficients defaults to 1, in case this property
			is not specified. A simple linear polynomial is used:
			Z =3D c0 * x0 + c1 + x1 + ... + c(n-1) * x(n-1) + cn.

			The coefficients are ordered and they match with sensors
			by means of sensor ID. Additional coefficients are
			interpreted as constant offsets.

Note: The delay properties are bound to the maximum dT/dt (temperature
derivative over time) in two situations for a thermal zone:
(i)  - when active cooling is activated (passive-delay); and
(ii) - when the zone just needs to be monitored (polling-delay).
The maximum dT/dt is highly bound to hardware power consumption and
dissipation
capability.

* Examples

Below are several examples on how to use thermal data descriptors
using device tree bindings:

(a) - CPU thermal zone

The CPU thermal zone example below describes how to setup one thermal zon=
e
using one single sensor as temperature source and many cooling devices an=
d
power dissipation control sources.

#include <dt-bindings/thermal/thermal.h>

cpus {
	cpu0: cpu@0 {
		...
		cooling-min-level =3D 0;
		cooling-max-level =3D 3;
		#cooling-cells =3D <2>; /* min followed by max */
	};
	...
};

&i2c1 {
	...
	fan0: fan@0x48 {
		...
		cooling-min-level =3D 0;
		cooling-max-level =3D 9;
		#cooling-cells =3D <2>; /* min followed by max */
	};
};

bandgap0: bandgap@0x0000ED00 {
	...
	#sensor-cells =3D <1>;
};

cpu-thermal: cpu-thermal {
	passive-delay =3D <250>; /* milliseconds */
	polling-delay =3D <1000>; /* milliseconds */

		/* sensor       ID */
        sensors =3D <&bandgap0     0>;

        trips {
                cpu-alert0: cpu-alert {
                        temperature =3D <90000>; /* milliCelsius */
                        hysteresis =3D <2000>; /* milliCelsius */
                        type =3D <THERMAL_TRIP_ACTIVE>;
                };
                cpu-alert1: cpu-alert {
                        temperature =3D <100000>; /* milliCelsius */
                        hysteresis =3D <2000>; /* milliCelsius */
                        type =3D <THERMAL_TRIP_PASSIVE>;
                };
                cpu-crit: cpu-crit {
                        temperature =3D <125000>; /* milliCelsius */
                        hysteresis =3D <2000>; /* milliCelsius */
                        type =3D <THERMAL_TRIP_CRITICAL>;
                };
        };

	cooling-attachments {
		attach0 {
			trip =3D <&cpu-alert0>;
			cooling-devices =3D <&fan0 THERMAL_NO_LIMITS 4>;
 		};
		attach1 {
			trip =3D <&cpu-alert1>;
			cooling-device =3D <&fan0 5 THERMAL_NO_LIMITS>;
		};
		attach2 {
			trip =3D <&cpu-alert1>;
			cooling-device =3D
				<&cpu0 THERMAL_NO_LIMITS THERMAL_NO_LIMITS>;
		};
	};
};

In the example above, the ADC sensor at address 0x0000ED00 is used to
monitor
the zone 'cpu-thermal' using its the sensor 0. The fan0, a fan device
controlled
via I2C bus 1, at adress 0x48, is used to remove the heat out of the ther=
mal
zone 'cpu-thermal' using its cooling levels from its minimum to 4, when i=
t
reaches trip point 'cpu-alert0' at 90C, as an example of active cooling. =
The
same cooling device is used at 'cpu-alert1', but from 5 to its maximum
level.
The cpu@0 device is also linked to the same thermal zone, 'cpu-thermal',
as a
passive cooling device, using all its cooling levels at trip point
'cpu-alert1',
which is a trip point at 100C.

(b) - IC with several internal sensors

The example below describes how to deploy several thermal zones based off=
 a
single sensor IC, assuming it has several internal sensors. This is a com=
mon
case on SoC designs with several internal IPs that may need different
thermal
requirements, and thus may have their own sensor to monitor or detect
internal
hotspots in their silicon.

#include <dt-bindings/thermal/thermal.h>

bandgap0: bandgap@0x0000ED00 {
	...
	#sensor-cells =3D <1>;
};

cpu-thermal: cpu-thermal {
	passive-delay =3D <250>; /* milliseconds */
	polling-delay =3D <1000>; /* milliseconds */

		/* sensor       ID */
        sensors =3D <&bandgap0     0>;

        trips {
		/* each zone within the SoC may have its own trips */
                cpu-alert: cpu-alert {
                        temperature =3D <100000>; /* milliCelsius */
                        hysteresis =3D <2000>; /* milliCelsius */
                        type =3D <THERMAL_TRIP_PASSIVE>;
                };
                cpu-crit: cpu-crit {
                        temperature =3D <125000>; /* milliCelsius */
                        hysteresis =3D <2000>; /* milliCelsius */
                        type =3D <THERMAL_TRIP_CRITICAL>;
                };
        };

	cooling-attachments {
		/* each zone within the SoC may have its own cooling */
		...
	};
};

gpu-thermal: gpu-thermal {
	passive-delay =3D <120>; /* milliseconds */
	polling-delay =3D <1000>; /* milliseconds */

		/* sensor       ID */
        sensors =3D <&bandgap0     1>;

        trips {
		/* each zone within the SoC may have its own trips */
                gpu-alert: gpu-alert {
                        temperature =3D <90000>; /* milliCelsius */
                        hysteresis =3D <2000>; /* milliCelsius */
                        type =3D <THERMAL_TRIP_PASSIVE>;
                };
                gpu-crit: gpu-crit {
                        temperature =3D <105000>; /* milliCelsius */
                        hysteresis =3D <2000>; /* milliCelsius */
                        type =3D <THERMAL_TRIP_CRITICAL>;
                };
        };

	cooling-attachments {
		/* each zone within the SoC may have its own cooling */
		...
	};
};

dsp-thermal: dsp-thermal {
	passive-delay =3D <50>; /* milliseconds */
	polling-delay =3D <1000>; /* milliseconds */

		/* sensor       ID */
        sensors =3D <&bandgap0     2>;

        trips {
		/* each zone within the SoC may have its own trips */
                dsp-alert: gpu-alert {
                        temperature =3D <90000>; /* milliCelsius */
                        hysteresis =3D <2000>; /* milliCelsius */
                        type =3D <THERMAL_TRIP_PASSIVE>;
                };
                dsp-crit: gpu-crit {
                        temperature =3D <135000>; /* milliCelsius */
                        hysteresis =3D <2000>; /* milliCelsius */
                        type =3D <THERMAL_TRIP_CRITICAL>;
                };
        };

	cooling-attachments {
		/* each zone within the SoC may have its own cooling */
		...
	};
};

In the example above there is one bandgap IC which has the capability to
monitor three sensors. The hardware has been designed so that sensors are=

placed on different places in the DIE to monitor different temperature
hotspots: one for CPU thermal zone, one for GPU thermal zone and the
other to monitor a DSP thermal zone.

Thus, there is a need to assign each sensor provided by the bandgap IC
to different thermal zones. This is achieved by means of using the
#sensor-cells property and using the first parameter as sensor ID.
In the example, then, bandgap.sensor0 is used to monitor CPU thermal zone=
,
bandgap.sensor1 is used to monitor GPU thermal zone and bandgap.sensor2
is used to monitor DSP thermal zone. Each zone may be uncorrelated,
having its own dT/dt requirements, trips and cooling attachments.

(c) - Several sensors within one single thermal zone

The example below illustrates how to use more than one sensor within
one thermal zone.

#include <dt-bindings/thermal/thermal.h>

&i2c1 {
	...
	adc: sensor@0x49 {
		...
		#sensor-cells =3D <1>;
	};
};

bandgap0: bandgap@0x0000ED00 {
	...
	#sensor-cells =3D <1>;
};

cpu-thermal: cpu-thermal {
	passive-delay =3D <250>; /* milliseconds */
	polling-delay =3D <1000>; /* milliseconds */

		/* sensor       ID */
        sensors =3D <&bandgap0	0>,
		  <&adc		0>;

		/* hotspot =3D 100 * bandgap - 120 * adc + 484 */
 	coefficients =3D 		<100	-120	484>;

        trips {
		...
        };

	cooling-attachments {
		...
	};
};

In some cases, there is a need to use more than one sensor to extrapolate=

a thermal hotspot in the silicon. The above example illustrate this
situation.
For instance, it may be the case that a sensor external to CPU IP may be
place
close to CPU hotspot and together with internal CPU sensor, it is used
to determine the hotspot. The hyppotetical extrapolation rule would be:
		hotspot =3D 100 * bandgap - 120 * adc + 484

The same idea can be used to add fixed offset:
	passive-delay =3D <1000>; /* milliseconds */
	polling-delay =3D <2500>; /* milliseconds */
		hotspot =3D 1 * adc + 6000

In the above equation, the hotspot is always 6C higher than what is read
from the sensor ADC. The binding would be then:
		/* sensor       ID */
        sensors =3D  <&adc	0>;

		/* hotspot =3D 1 * adc + 6000 */
	coefficients =3D 		<1	6000>;

(d) - Board thermal

The board thermal example below illustrates how to setup one thermal zone=

with many sensors and many cooling devices.

#include <dt-bindings/thermal/thermal.h>

&i2c1 {
 	...
	adc-dummy: sensor@0x50 {
		...
		#sensor-cells =3D <1>; /* sensor internal ID */
	};
};

batt-thermal {
	passive-delay =3D <500>; /* milliseconds */
	polling-delay =3D <2500>; /* milliseconds */

	/* sensor       ID */
	sensors =3D <&adc-dummy     4>;

	trips {
		...
	};

	cooling-attachments {
		...
	};
};

board-thermal: board-thermal {
	passive-delay =3D <1000>; /* milliseconds */
	polling-delay =3D <2500>; /* milliseconds */

		/* sensor       ID */
	sensors =3D <&adc-dummy     0>,
		  <&adc-dummy     1>,
		  <&adc-dymmy     2>;
			/*
			 * An array of coefficients describing the sensor
			 * linear relation. E.g.:
			 * z =3D c1*x1 + c2*x2 + c3*x3
			 */
	coefficients =3D		<1200	-345	890>;

	trips {
		/* Trips are based on resulting linear equation */
		cpu-trip: cpu-trip {
			temperature =3D <60000>; /* milliCelsius */
			hysteresis =3D <2000>; /* milliCelsius */
			type =3D <THERMAL_TRIP_PASSIVE>;
		};
		gpu-trip: gpu-trip {
			temperature =3D <55000>; /* milliCelsius */
			hysteresis =3D <2000>; /* milliCelsius */
			type =3D <THERMAL_TRIP_PASSIVE>;
		}
		lcd-trip: lcp-trip {
			temperature =3D <53000>; /* milliCelsius */
			hysteresis =3D <2000>; /* milliCelsius */
			type =3D <THERMAL_TRIP_PASSIVE>;
		};
		crit-trip: crit-trip {
			temperature =3D <68000>; /* milliCelsius */
			hysteresis =3D <2000>; /* milliCelsius */
 			type =3D <THERMAL_TRIP_CRITICAL>;
		};
	};

	cooling-attachments {
		attach0 {
			trip =3D <&cpu-trip>;
			cooling-device =3D <&cpu0 0 2>;
			contribution =3D <55>;
		};
		attach1 {
			trip =3D <&gpu-trip>;
			cooling-device =3D <&gpu0 0 2>;
			contribution =3D <20>;
		};
 		attach2 {
			trip =3D <&lcd-trip>;
			cooling-device =3D <&lcd0 5 10>;
			contribution =3D <15>;
		};
	};
};

The above example is a mix of previous examples, a sensor IP with
several internal
sensors used to monitor different zones, one of them is composed by
several sensors and
with different cooling devices.
-----------------------------------------------------------------------

All best,


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--Fj3Vad5sRKoq8orBFi1qwl85axhxK3euq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlIqcRYACgkQCXcVR3XQvP1KSAEA6WbiAVjNjO5WmpZO74HxM/0e
1Vzw4memD5pdBETiemQBAMYni3CS4hL3UUQOjVIJ9fdZoetgldnkE7yACotewNme
=HpyI
-----END PGP SIGNATURE-----

--Fj3Vad5sRKoq8orBFi1qwl85axhxK3euq--
