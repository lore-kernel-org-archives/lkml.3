Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3IRRIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:08:48 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:40191 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab3IRRIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:08:45 -0400
Date: Wed, 18 Sep 2013 10:08:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: swarren@wwwdotorg.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ian.campbell@citrix.com, rob.herring@calxeda.com, rui.zhang@intel.com,
        wni@nvidia.com, grant.likely@linaro.org, durgadoss.r@intel.com,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 02/16] drivers: thermal: introduce device tree parser
Message-ID: <20130918170840.GA14830@roeck-us.net>
References: <1379282563-14650-3-git-send-email-eduardo.valentin@ti.com>
 <1379520189-11328-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379520189-11328-1-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 12:03:09PM -0400, Eduardo Valentin wrote:
> This patch introduces a device tree bindings for
> describing the hardware thermal behavior and limits.
> Also a parser to read and interpret the data and feed
> it in the thermal framework is presented.
> 
> This patch introduces a thermal data parser for device
> tree. The parsed data is used to build thermal zones
> and thermal binding parameters. The output data
> can then be used to deploy thermal policies.
> 
> This patch adds also documentation regarding this
> API and how to define tree nodes to use
> this infrastructure.
> 
> Note that, in order to be able to have control
> on the sensor registration on the DT thermal zone,
> it was required to allow changing the thermal zone
> .get_temp callback. For this reason, this patch
> also removes the 'const' modifier from the .ops
> field of thermal zone devices.
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  .../devicetree/bindings/thermal/thermal.txt        | 498 ++++++++++++++
>  drivers/thermal/Kconfig                            |  13 +
>  drivers/thermal/Makefile                           |   1 +
>  drivers/thermal/of-thermal.c                       | 753 +++++++++++++++++++++
>  drivers/thermal/thermal_core.c                     |   9 +-
>  drivers/thermal/thermal_core.h                     |   9 +
>  include/dt-bindings/thermal/thermal.h              |  27 +
>  include/linux/thermal.h                            |  28 +-
>  8 files changed, 1335 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/thermal/thermal.txt
>  create mode 100644 drivers/thermal/of-thermal.c
>  create mode 100644 include/dt-bindings/thermal/thermal.h
> ---
> 
> Hi all,
> 
> As per Guenter's request, I changed this code to fail silently while
> registering sensor drivers.
> 
> Cheers,
> 
> Eduardo
> 
> diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/Documentation/devicetree/bindings/thermal/thermal.txt
> new file mode 100644
> index 0000000..6664533
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/thermal/thermal.txt
> @@ -0,0 +1,498 @@
> +* Thermal Framework Device Tree descriptor
> +
> +Generic binding to provide a way of defining hardware thermal
> +structure using device tree. A thermal structure includes thermal
> +zones and their components, such as trip points, polling intervals,
> +sensors and cooling devices binding descriptors.
> +
> +The target of device tree thermal descriptors is to describe only
> +the hardware thermal aspects, not how the system must control or which
> +algorithm or policy must be taken in place.
> +
> +There are five types of nodes involved to describe thermal bindings:
> +- sensors: used to describe the device source of temperature sensing;
> +- cooling devices: used to describe devices source of power dissipation control;
> +- trip points: used to describe points in temperature domain defined to
> +make the system aware of hardware limits;
> +- cooling attachments: used to describe links between trip points and
> +cooling devices;
> +- thermal zones: used to describe thermal data within the hardware;
> +
> +It follows a description of each type of these device tree nodes.
> +
> +* Sensor devices
> +
> +Sensor devices are nodes providing temperature sensing capabilities on thermal
> +zones. Typical devices are I2C ADC converters and bandgaps. Theses are nodes
> +providing temperature data to thermal zones. Temperature sensor devices may
> +control one or more internal sensors.
> +
> +Required property:
> +- #sensor-cells:	Used to provide sensor device specific information
> +			while referring to it. Must be at least 1, in order
> +			to identify uniquely the sensor instances within
> +			the IC. See thermal zone binding for more details
> +			on how consumers refer to sensor devices.
> +
> +* Cooling device nodes
> +
> +Cooling devices are nodes providing control on power dissipation. There
> +are essentially two ways to provide control on power dissipation. First
> +is by means of regulating device performance, which is known as passive
> +cooling. Second is by means of activating devices in order to remove
> +the dissipated heat, which is known as active cooling, e.g. regulating
> +fan speeds. In both cases, cooling devices shall have a way to determine
> +the level of cooling.
> +
> +Required property:
> +- cooling-min-level:	A unsigned integer indicating the smallest
> +			cooling level accepted. Typically 0.
> +- cooling-max-level:	An unsigned integer indicating the largest
> +			cooling level accepted.
> +- #cooling-cells:	Used to provide cooling device specific information
> +			while referring to it. Must be at least 2, in order
> +			to specify minimum and maximum cooling level used
> +			in the reference. See Cooling device attachments section
> +			below for more details on how consumers refer to
> +			cooling devices.
> +
> +* Trip points
> +
> +The trip node is a node to describe a point in the temperature domain
> +in which the system takes an action. This node describes just the point,
> +not the action.
> +
> +Required properties:
> +- temperature:		the trip temperature level, in milliCelsius.
> +- hysteresis:		a (low) hysteresis value on 'temperature'. This is a
> +			relative value, in milliCelsius.
> +- type:			the trip type. Here is the type mapping:
> +	THERMAL_TRIP_ACTIVE	0:	A trip point to enable active cooling
> +	THERMAL_TRIP_PASSIVE	1:	A trip point to enable passive cooling
> +	THERMAL_TRIP_HOT	2:	A trip point to notify emergency
> +	THERMAL_TRIP_CRITICAL	3:	Hardware not reliable.
> +
> +Refer to include/dt-bindings/thermal/thermal.h for definition of these consts.
> +
> +* Cooling device attachments
> +
> +The cooling device attachments node is a node to describe how cooling devices
> +get assigned to trip points of the zone. The cooling devices are expected
> +to be loaded in the target system.
> +
> +Required properties:
> +- cooling-device:	A phandle of a cooling device with its parameters,
> +			referring to which cooling device is used in this
> +			binding. The required parameters are: the minimum
> +			cooling level and the maximum cooling level used
> +			in this attach.
> +- trip:			A phandle of a trip point node within the same thermal
> +			zone.
> +
> +Optional property:
> +- contribution:		The cooling contribution to the thermal zone of the
> +			referred cooling device at the referred trip point.
> +			The contribution is a value from 0 to 100. The sum
> +			of all cooling contributions within a thermal zone
> +			must never exceed 100.
> +
> +Note: Using the THERMAL_NO_LIMIT (-1L) constant in the cooling-device phandle
> +limit parameters means:
> +(i)   - minimum level allowed for minimum cooling level used in the reference.
> +(ii)  - maximum level allowed for maximum cooling level used in the reference.
> +Refer to include/dt-bindings/thermal/thermal.h for definition of this constant.
> +
> +* Thermal zones
> +
> +The thermal-zone node is the node containing all the required info
> +for describing a thermal zone, including its cdev bindings. The thermal_zone
> +node must contain, apart from its own properties, one node containing
> +trip nodes and one node containing all the zone cooling attachments.
> +
> +Required properties:
> +- passive-delay:	The maximum number of milliseconds to wait between polls
> +			when performing passive cooling.
> +- polling-delay:	The maximum number of milliseconds to wait between polls
> +			when checking this thermal zone.
> +- sensors:		A list of sensor phandles and their parameters. The
> +			required parameter is the sensor id, in order to
> +			identify internal sensors when the sensor IC features
> +			several sensing units.
> +- trips:		A sub-node containing several trip point nodes required
> +			to describe the thermal zone.
> +- cooling-attachments	A sub-node containing several cooling device attaches
> +			nodes, used to describe the relation between trips
> +			and cooling devices.
> +
> +Optional property:
> +- coefficients:		An array of integers (one signed cell) containing
> +			coefficients to compose a linear relation between
> +			the sensors described in the sensors property.
> +			Coefficients defaults to 1, in case this property
> +			is not specified. A simple linear polynomial is used:
> +			Z = c0 * x0 + c1 + x1 + ... + c(n-1) * x(n-1) + cn.
> +
> +			The coefficients are ordered and they match with sensors
> +			by means of sensor ID. Additional coefficients are
> +			interpreted as constant offsets.
> +
> +Note: The delay properties are bound to the maximum dT/dt (temperature
> +derivative over time) in two situations for a thermal zone:
> +(i)  - when active cooling is activated (passive-delay); and
> +(ii) - when the zone just needs to be monitored (polling-delay).
> +The maximum dT/dt is highly bound to hardware power consumption and dissipation
> +capability.
> +
> +* Examples
> +
> +Below are several examples on how to use thermal data descriptors
> +using device tree bindings:
> +
> +(a) - CPU thermal zone
> +
> +The CPU thermal zone example below describes how to setup one thermal zone
> +using one single sensor as temperature source and many cooling devices and
> +power dissipation control sources.
> +
> +#include <dt-bindings/thermal/thermal.h>
> +
> +cpus {
> +	cpu0: cpu@0 {
> +		...
> +		cooling-min-level = <0>;
> +		cooling-max-level = <3>;
> +		#cooling-cells = <2>; /* min followed by max */
> +	};
> +	...
> +};
> +
> +&i2c1 {
> +	...
> +	fan0: fan@0x48 {
> +		...
> +		cooling-min-level = <0>;
> +		cooling-max-level = <9>;
> +		#cooling-cells = <2>; /* min followed by max */
> +	};
> +};
> +
> +bandgap0: bandgap@0x0000ED00 {
> +	...
> +	#sensor-cells = <1>;
> +};
> +
> +cpu-thermal: cpu-thermal {
> +	passive-delay = <250>; /* milliseconds */
> +	polling-delay = <1000>; /* milliseconds */
> +
> +		/* sensor       ID */
> +        sensors = <&bandgap0     0>;
> +
> +        trips {
> +                cpu-alert0: cpu-alert {
> +                        temperature = <90000>; /* milliCelsius */
> +                        hysteresis = <2000>; /* milliCelsius */
> +                        type = <THERMAL_TRIP_ACTIVE>;
> +                };
> +                cpu-alert1: cpu-alert {
> +                        temperature = <100000>; /* milliCelsius */
> +                        hysteresis = <2000>; /* milliCelsius */
> +                        type = <THERMAL_TRIP_PASSIVE>;
> +                };
> +                cpu-crit: cpu-crit {
> +                        temperature = <125000>; /* milliCelsius */
> +                        hysteresis = <2000>; /* milliCelsius */
> +                        type = <THERMAL_TRIP_CRITICAL>;
> +                };
> +        };
> +
> +	cooling-attachments {
> +		attach0 {
> +			trip = <&cpu-alert0>;
> +			cooling-device = <&fan0 THERMAL_NO_LIMITS 4>;
> +		};
> +		attach1 {
> +			trip = <&cpu-alert1>;
> +			cooling-device = <&fan0 5 THERMAL_NO_LIMITS>;
> +		};
> +		attach2 {
> +			trip = <&cpu-alert1>;
> +			cooling-device =
> +				<&cpu0 THERMAL_NO_LIMITS THERMAL_NO_LIMITS>;
> +		};
> +	};
> +};
> +
> +In the example above, the ADC sensor at address 0x0000ED00 is used to monitor
> +the zone 'cpu-thermal' using its the sensor 0. The fan0, a fan device controlled
> +via I2C bus 1, at adress 0x48, is used to remove the heat out of the thermal
> +zone 'cpu-thermal' using its cooling levels from its minimum to 4, when it
> +reaches trip point 'cpu-alert0' at 90C, as an example of active cooling. The
> +same cooling device is used at 'cpu-alert1', but from 5 to its maximum level.
> +The cpu@0 device is also linked to the same thermal zone, 'cpu-thermal', as a
> +passive cooling device, using all its cooling levels at trip point 'cpu-alert1',
> +which is a trip point at 100C.
> +
> +(b) - IC with several internal sensors
> +
> +The example below describes how to deploy several thermal zones based off a
> +single sensor IC, assuming it has several internal sensors. This is a common
> +case on SoC designs with several internal IPs that may need different thermal
> +requirements, and thus may have their own sensor to monitor or detect internal
> +hotspots in their silicon.
> +
> +#include <dt-bindings/thermal/thermal.h>
> +
> +bandgap0: bandgap@0x0000ED00 {
> +	...
> +	#sensor-cells = <1>;
> +};
> +
> +cpu-thermal: cpu-thermal {
> +	passive-delay = <250>; /* milliseconds */
> +	polling-delay = <1000>; /* milliseconds */
> +
> +		/* sensor       ID */
> +        sensors = <&bandgap0     0>;
> +
> +        trips {
> +		/* each zone within the SoC may have its own trips */
> +                cpu-alert: cpu-alert {
> +                        temperature = <100000>; /* milliCelsius */
> +                        hysteresis = <2000>; /* milliCelsius */
> +                        type = <THERMAL_TRIP_PASSIVE>;
> +                };
> +                cpu-crit: cpu-crit {
> +                        temperature = <125000>; /* milliCelsius */
> +                        hysteresis = <2000>; /* milliCelsius */
> +                        type = <THERMAL_TRIP_CRITICAL>;
> +                };
> +        };
> +
> +	cooling-attachments {
> +		/* each zone within the SoC may have its own cooling */
> +		...
> +	};
> +};
> +
> +gpu-thermal: gpu-thermal {
> +	passive-delay = <120>; /* milliseconds */
> +	polling-delay = <1000>; /* milliseconds */
> +
> +		/* sensor       ID */
> +        sensors = <&bandgap0     1>;
> +
> +        trips {
> +		/* each zone within the SoC may have its own trips */
> +                gpu-alert: gpu-alert {
> +                        temperature = <90000>; /* milliCelsius */
> +                        hysteresis = <2000>; /* milliCelsius */
> +                        type = <THERMAL_TRIP_PASSIVE>;
> +                };
> +                gpu-crit: gpu-crit {
> +                        temperature = <105000>; /* milliCelsius */
> +                        hysteresis = <2000>; /* milliCelsius */
> +                        type = <THERMAL_TRIP_CRITICAL>;
> +                };
> +        };
> +
> +	cooling-attachments {
> +		/* each zone within the SoC may have its own cooling */
> +		...
> +	};
> +};
> +
> +dsp-thermal: dsp-thermal {
> +	passive-delay = <50>; /* milliseconds */
> +	polling-delay = <1000>; /* milliseconds */
> +
> +		/* sensor       ID */
> +        sensors = <&bandgap0     2>;
> +
> +        trips {
> +		/* each zone within the SoC may have its own trips */
> +                dsp-alert: gpu-alert {
> +                        temperature = <90000>; /* milliCelsius */
> +                        hysteresis = <2000>; /* milliCelsius */
> +                        type = <THERMAL_TRIP_PASSIVE>;
> +                };
> +                dsp-crit: gpu-crit {
> +                        temperature = <135000>; /* milliCelsius */
> +                        hysteresis = <2000>; /* milliCelsius */
> +                        type = <THERMAL_TRIP_CRITICAL>;
> +                };
> +        };
> +
> +	cooling-attachments {
> +		/* each zone within the SoC may have its own cooling */
> +		...
> +	};
> +};
> +
> +In the example above there is one bandgap IC which has the capability to
> +monitor three sensors. The hardware has been designed so that sensors are
> +placed on different places in the DIE to monitor different temperature
> +hotspots: one for CPU thermal zone, one for GPU thermal zone and the
> +other to monitor a DSP thermal zone.
> +
> +Thus, there is a need to assign each sensor provided by the bandgap IC
> +to different thermal zones. This is achieved by means of using the
> +#sensor-cells property and using the first parameter as sensor ID.
> +In the example, then, bandgap.sensor0 is used to monitor CPU thermal zone,
> +bandgap.sensor1 is used to monitor GPU thermal zone and bandgap.sensor2
> +is used to monitor DSP thermal zone. Each zone may be uncorrelated,
> +having its own dT/dt requirements, trips and cooling attachments.
> +
> +
> +(c) - Several sensors within one single thermal zone
> +
> +The example below illustrates how to use more than one sensor within
> +one thermal zone.
> +
> +#include <dt-bindings/thermal/thermal.h>
> +
> +&i2c1 {
> +	...
> +	adc: sensor@0x49 {
> +		...
> +		#sensor-cells = <1>;
> +	};
> +};
> +
> +bandgap0: bandgap@0x0000ED00 {
> +	...
> +	#sensor-cells = <1>;
> +};
> +
> +cpu-thermal: cpu-thermal {
> +	passive-delay = <250>; /* milliseconds */
> +	polling-delay = <1000>; /* milliseconds */
> +
> +		/* sensor       ID */
> +        sensors = <&bandgap0	0>,
> +		  <&adc		0>;
> +
> +		/* hotspot = 100 * bandgap - 120 * adc + 484 */
> +	coefficients = 		<100	-120	484>;
> +
> +        trips {
> +		...
> +        };
> +
> +	cooling-attachments {
> +		...
> +	};
> +};
> +
> +In some cases, there is a need to use more than one sensor to extrapolate
> +a thermal hotspot in the silicon. The above example illustrate this situation.
> +For instance, it may be the case that a sensor external to CPU IP may be place
> +close to CPU hotspot and together with internal CPU sensor, it is used
> +to determine the hotspot. The hyppotetical extrapolation rule would be:
> +		hotspot = 100 * bandgap - 120 * adc + 484
> +
> +The same idea can be used to add fixed offset:
> +	passive-delay = <1000>; /* milliseconds */
> +	polling-delay = <2500>; /* milliseconds */
> +		hotspot = 1 * adc + 6000
> +
> +In the above equation, the hotspot is always 6C higher than what is read
> +from the sensor ADC. The binding would be then:
> +		/* sensor       ID */
> +        sensors =  <&adc	0>;
> +
> +		/* hotspot = 1 * adc + 6000 */
> +	coefficients = 		<1	6000>;
> +
> +(d) - Board thermal
> +
> +The board thermal example below illustrates how to setup one thermal zone
> +with many sensors and many cooling devices.
> +
> +#include <dt-bindings/thermal/thermal.h>
> +
> +&i2c1 {
> +	...
> +	adc-dummy: sensor@0x50 {
> +		...
> +		#sensor-cells = <1>; /* sensor internal ID */
> +	};
> +};
> +
> +batt-thermal {
> +	passive-delay = <500>; /* milliseconds */
> +	polling-delay = <2500>; /* milliseconds */
> +
> +	/* sensor       ID */
> +	sensors = <&adc-dummy     4>;
> +
> +	trips {
> +		...
> +	};
> +
> +	cooling-attachments {
> +		...
> +	};
> +};
> +
> +board-thermal: board-thermal {
> +	passive-delay = <1000>; /* milliseconds */
> +	polling-delay = <2500>; /* milliseconds */
> +
> +		/* sensor       ID */
> +	sensors = <&adc-dummy     0>,
> +		  <&adc-dummy     1>,
> +		  <&adc-dymmy     2>;
> +			/*
> +			 * An array of coefficients describing the sensor
> +			 * linear relation. E.g.:
> +			 * z = c1*x1 + c2*x2 + c3*x3
> +			 */
> +	coefficients =		<1200	-345	890>;
> +
> +	trips {
> +		/* Trips are based on resulting linear equation */
> +		cpu-trip: cpu-trip {
> +			temperature = <60000>; /* milliCelsius */
> +			hysteresis = <2000>; /* milliCelsius */
> +			type = <THERMAL_TRIP_PASSIVE>;
> +		};
> +		gpu-trip: gpu-trip {
> +			temperature = <55000>; /* milliCelsius */
> +			hysteresis = <2000>; /* milliCelsius */
> +			type = <THERMAL_TRIP_PASSIVE>;
> +		}
> +		lcd-trip: lcp-trip {
> +			temperature = <53000>; /* milliCelsius */
> +			hysteresis = <2000>; /* milliCelsius */
> +			type = <THERMAL_TRIP_PASSIVE>;
> +		};
> +		crit-trip: crit-trip {
> +			temperature = <68000>; /* milliCelsius */
> +			hysteresis = <2000>; /* milliCelsius */
> +			type = <THERMAL_TRIP_CRITICAL>;
> +		};
> +	};
> +
> +	cooling-attachments {
> +		attach0 {
> +			trip = <&cpu-trip>;
> +			cooling-device = <&cpu0 0 2>;
> +			contribution = <55>;
> +		};
> +		attach1 {
> +			trip = <&gpu-trip>;
> +			cooling-device = <&gpu0 0 2>;
> +			contribution = <20>;
> +		};
> +		attach2 {
> +			trip = <&lcd-trip>;
> +			cooling-device = <&lcd0 5 10>;
> +			contribution = <15>;
> +		};
> +	};
> +};
> +
> +The above example is a mix of previous examples, a sensor IP with several internal
> +sensors used to monitor different zones, one of them is composed by several sensors and
> +with different cooling devices.
> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index dbfc390..dd81eb8 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -29,6 +29,19 @@ config THERMAL_HWMON
>  	  Say 'Y' here if you want all thermal sensors to
>  	  have hwmon sysfs interface too.
>  
> +config THERMAL_OF
> +	bool
> +	prompt "APIs to parse thermal data out of device tree"
> +	depends on OF
> +	default y
> +	help
> +	  This options provides helpers to add the support to
> +	  read and parse thermal data definitions out of the
> +	  device tree blob.
> +
> +	  Say 'Y' here if you need to build thermal infrastructure
> +	  based on device tree.
> +
>  choice
>  	prompt "Default Thermal governor"
>  	default THERMAL_DEFAULT_GOV_STEP_WISE
> diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> index 584b363..4b03956 100644
> --- a/drivers/thermal/Makefile
> +++ b/drivers/thermal/Makefile
> @@ -7,6 +7,7 @@ thermal_sys-y			+= thermal_core.o
>  
>  # interface to/from other layers providing sensors
>  thermal_sys-$(CONFIG_THERMAL_HWMON)		+= thermal_hwmon.o
> +thermal_sys-$(CONFIG_THERMAL_OF)		+= of-thermal.o
>  
>  # governors
>  thermal_sys-$(CONFIG_THERMAL_GOV_FAIR_SHARE)	+= fair_share.o
> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> new file mode 100644
> index 0000000..857d40c
> --- /dev/null
> +++ b/drivers/thermal/of-thermal.c
> @@ -0,0 +1,753 @@
> +/*
> + *  of-thermal.c - Generic Thermal Management device tree support.
> + *
> + *  Copyright (C) 2013 Texas Instruments
> + *  Copyright (C) 2013 Eduardo Valentin <eduardo.valentin@ti.com>
> + *
> + *
> + *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; version 2 of the License.
> + *
> + *  This program is distributed in the hope that it will be useful, but
> + *  WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + *  General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License along
> + *  with this program; if not, write to the Free Software Foundation, Inc.,
> + *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + */
> +#include <linux/thermal.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/of_device.h>
> +#include <linux/of_platform.h>
> +#include <linux/err.h>
> +#include <linux/export.h>
> +#include <linux/string.h>
> +
> +/***   Private data structures to represent thermal device tree data ***/
> +
> +/**
> + * struct __thermal_trip - representation of a point in temperature domain
> + * @np: pointer to struct device_node that this trip point was created from
> + * @temperature: temperature value in miliCelsius
> + * @hysteresis: relative hysteresis in miliCelsius
> + * @type: trip point type
> + */
> +
> +struct __thermal_trip {
> +	struct device_node *np;
> +	unsigned long int temperature;
> +	unsigned long int hysteresis;
> +	enum thermal_trip_type type;
> +};
> +
> +/**
> + * struct __thermal_bind_param - a match between trip and cooling device
> + * @cooling_device: a pointer to identify the referred cooling device
> + * @trip_id: the trip point index
> + * @usage: the percentage (from 0 to 100) of cooling contribution
> + * @min: minimum cooling level used at this trip point
> + * @max: maximum cooling level used at this trip point
> + */
> +
> +struct __thermal_bind_params {
> +	struct device_node *cooling_device;
> +	unsigned int trip_id;
> +	unsigned int usage;
> +	unsigned long min;
> +	unsigned long max;
> +};
> +
> +/**
> + * struct __thermal_zone - internal representation of a thermal zone
> + * @mode: current thermal zone device mode (enabled/disabled)
> + * @passive_delay: polling interval while passive cooling is activated
> + * @polling_delay: zone polling interval
> + * @ntrips: number of trip points
> + * @trips: an array of trip points (0..ntrips - 1)
> + * @num_tbps: number of thermal bind params
> + * @tbps: an array of thermal bind params (0..num_tbps - 1)
> + * @sensor_data: sensor private data used while reading temperature and trend
> + * @get_temp: sensor callback to read temperature
> + * @get_trend: sensor callback to read temperature trend
> + */
> +
> +struct __thermal_zone {
> +	enum thermal_device_mode mode;
> +	int passive_delay;
> +	int polling_delay;
> +
> +	/* trip data */
> +	int ntrips;
> +	struct __thermal_trip *trips;
> +
> +	/* cooling binding data */
> +	int num_tbps;
> +	struct __thermal_bind_params *tbps;
> +
> +	/* sensor interface */
> +	void *sensor_data;
> +	int (*get_temp)(void *, long *);
> +	int (*get_trend)(void *, long *);
> +};
> +
> +/***   DT thermal zone device callbacks   ***/
> +
> +static int of_thermal_get_temp(struct thermal_zone_device *tz,
> +			       unsigned long *temp)
> +{
> +	struct __thermal_zone *data = tz->devdata;
> +
> +	if (!data->get_temp)
> +		return -EINVAL;
> +
> +	return data->get_temp(data->sensor_data, temp);
> +}
> +
> +static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
> +				enum thermal_trend *trend)
> +{
> +	struct __thermal_zone *data = tz->devdata;
> +	long dev_trend;
> +	int r;
> +
> +	if (!data->get_trend)
> +		return -EINVAL;
> +
> +	r = data->get_trend(data->sensor_data, &dev_trend);
> +	if (r)
> +		return r;
> +
> +	if (dev_trend > 0)
> +		*trend = THERMAL_TREND_RAISING;
> +	else if (dev_trend < 0)
> +		*trend = THERMAL_TREND_DROPPING;
> +	else
> +		*trend = THERMAL_TREND_STABLE;
> +
> +	return 0;
> +}
> +
> +static int of_thermal_bind(struct thermal_zone_device *thermal,
> +			   struct thermal_cooling_device *cdev)
> +{
> +	struct __thermal_zone *data = thermal->devdata;
> +	int i;
> +
> +	if (!data || IS_ERR(data))
> +		return -ENODEV;
> +
> +	/* find where to bind */
> +	for (i = 0; i < data->num_tbps; i++) {
> +		struct __thermal_bind_params *tbp = data->tbps + i;
> +
> +		if (tbp->cooling_device == cdev->np) {
> +			int ret;
> +
> +			ret = thermal_zone_bind_cooling_device(thermal,
> +						tbp->trip_id, cdev,
> +						tbp->min,
> +						tbp->max);
> +			if (ret)
> +				return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int of_thermal_unbind(struct thermal_zone_device *thermal,
> +			     struct thermal_cooling_device *cdev)
> +{
> +	struct __thermal_zone *data = thermal->devdata;
> +	int i;
> +
> +	if (!data || IS_ERR(data))
> +		return -ENODEV;
> +
> +	/* find where to unbind */
> +	for (i = 0; i < data->num_tbps; i++) {
> +		struct __thermal_bind_params *tbp = data->tbps + i;
> +
> +		if (tbp->cooling_device == cdev->np) {
> +			int ret;
> +
> +			ret = thermal_zone_unbind_cooling_device(thermal,
> +						tbp->trip_id, cdev);
> +			if (ret)
> +				return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int of_thermal_get_mode(struct thermal_zone_device *tz,
> +			       enum thermal_device_mode *mode)
> +{
> +	struct __thermal_zone *data = tz->devdata;
> +
> +	*mode = data->mode;
> +
> +	return 0;
> +}
> +
> +static int of_thermal_set_mode(struct thermal_zone_device *tz,
> +			       enum thermal_device_mode mode)
> +{
> +	struct __thermal_zone *data = tz->devdata;
> +
> +	mutex_lock(&tz->lock);
> +
> +	if (mode == THERMAL_DEVICE_ENABLED)
> +		tz->polling_delay = data->polling_delay;
> +	else
> +		tz->polling_delay = 0;
> +
> +	mutex_unlock(&tz->lock);
> +
> +	data->mode = mode;
> +	thermal_zone_device_update(tz);
> +
> +	return 0;
> +}
> +
> +static int of_thermal_get_trip_type(struct thermal_zone_device *tz, int trip,
> +				    enum thermal_trip_type *type)
> +{
> +	struct __thermal_zone *data = tz->devdata;
> +
> +	if (trip >= data->ntrips || trip < 0)
> +		return -EDOM;
> +
> +	*type = data->trips[trip].type;
> +
> +	return 0;
> +}
> +
> +static int of_thermal_get_trip_temp(struct thermal_zone_device *tz, int trip,
> +				    unsigned long *temp)
> +{
> +	struct __thermal_zone *data = tz->devdata;
> +
> +	if (trip >= data->ntrips || trip < 0)
> +		return -EDOM;
> +
> +	*temp = data->trips[trip].temperature;
> +
> +	return 0;
> +}
> +
> +static int of_thermal_set_trip_temp(struct thermal_zone_device *tz, int trip,
> +				    unsigned long temp)
> +{
> +	struct __thermal_zone *data = tz->devdata;
> +
> +	if (trip >= data->ntrips || trip < 0)
> +		return -EDOM;
> +
> +	/* thermal fw should take care of data->mask & (1 << trip) */
> +	data->trips[trip].temperature = temp;
> +
> +	return 0;
> +}
> +
> +static int of_thermal_get_trip_hyst(struct thermal_zone_device *tz, int trip,
> +				    unsigned long *hyst)
> +{
> +	struct __thermal_zone *data = tz->devdata;
> +
> +	if (trip >= data->ntrips || trip < 0)
> +		return -EDOM;
> +
> +	*hyst = data->trips[trip].hysteresis;
> +
> +	return 0;
> +}
> +
> +static int of_thermal_set_trip_hyst(struct thermal_zone_device *tz, int trip,
> +				    unsigned long hyst)
> +{
> +	struct __thermal_zone *data = tz->devdata;
> +
> +	if (trip >= data->ntrips || trip < 0)
> +		return -EDOM;
> +
> +	/* thermal fw should take care of data->mask & (1 << trip) */
> +	data->trips[trip].hysteresis = hyst;
> +
> +	return 0;
> +}
> +
> +static int of_thermal_get_crit_temp(struct thermal_zone_device *tz,
> +				    unsigned long *temp)
> +{
> +	struct __thermal_zone *data = tz->devdata;
> +	int i;
> +
> +	for (i = 0; i < data->ntrips; i++)
> +		if (data->trips[i].type == THERMAL_TRIP_CRITICAL) {
> +			*temp = data->trips[i].temperature;
> +			return 0;
> +		}
> +
> +	return -EINVAL;
> +}
> +
> +static struct thermal_zone_device_ops of_thermal_ops = {
> +	.get_mode = of_thermal_get_mode,
> +	.set_mode = of_thermal_set_mode,
> +
> +	.get_trip_type = of_thermal_get_trip_type,
> +	.get_trip_temp = of_thermal_get_trip_temp,
> +	.set_trip_temp = of_thermal_set_trip_temp,
> +	.get_trip_hyst = of_thermal_get_trip_hyst,
> +	.set_trip_hyst = of_thermal_set_trip_hyst,
> +	.get_crit_temp = of_thermal_get_crit_temp,
> +
> +	.bind = of_thermal_bind,
> +	.unbind = of_thermal_unbind,
> +};
> +
> +/***   sensor API   ***/
> +
> +static struct thermal_zone_device *
> +thermal_zone_of_add_sensor(struct device_node *zone,
> +			   struct device_node *sensor, void *data,
> +			   int (*get_temp)(void *, long *),
> +			   int (*get_trend)(void *, long *))
> +{
> +	struct thermal_zone_device *tzd;
> +	struct __thermal_zone *tz;
> +
> +	tzd = thermal_zone_get_zone_by_name(zone->name);
> +	if (IS_ERR(tzd))
> +		return ERR_PTR(-EPROBE_DEFER);
> +
> +	tz = tzd->devdata;
> +
> +	mutex_lock(&tzd->lock);
> +	tz->get_temp = get_temp;
> +	tz->get_trend = get_trend;
> +	tz->sensor_data = data;
> +
> +	tzd->ops->get_temp = of_thermal_get_temp;
> +	tzd->ops->get_trend = of_thermal_get_trend;
> +	mutex_unlock(&tzd->lock);
> +
> +	return tzd;
> +}
> +
> +/**
> + * thermal_zone_of_sensor_register - registers a sensor to a DT thermal zone
> + * @dev: a valid struct device pointer of a sensor device. Must contain
> + *       a valid .of_node, for the sensor node.
> + * @sensor_id: a sensor identifier, in case the sensor IP has more
> + *             than one sensors
> + * @data: a private pointer (owned by the caller) that will be passed
> + *        back, when a temperature reading is needed.
> + * @get_temp: a pointer to a function that reads the sensor temperature.
> + * @get_trend: a pointer to a function that reads the sensor temperature trend.
> + *
> + * This function will search the list of thermal zones described in device
> + * tree and look for the zone that refer to the sensor device pointed by
> + * @dev->of_node as temperature providers. For the zone pointing to the
> + * sensor node, the sensor will be added to the DT thermal zone device.
> + *
> + * The thermal zone temperature is provided by the @get_temp function
> + * pointer. When called, it will have the private pointer @data back.
> + *
> + * The thermal zone temperature trend is provided by the @get_trend function
> + * pointer. When called, it will have the private pointer @data back.
> + *
> + * TODO:
> + * 01 - This function must enqueue the new sensor instead of using
> + * it as the only source of temperature values.
> + *
> + * 02 - There must be a way to match the sensor with all thermal zones
> + * that refer to it.
> + *
> + * Return: On success returns a valid struct thermal_zone_device,
> + * otherwise, it returns a corresponding ERR_PTR(). Caller must
> + * check the return value with help of IS_ERR() helper.
> + */
> +struct thermal_zone_device *
> +thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
> +				void *data, int (*get_temp)(void *, long *),
> +				int (*get_trend)(void *, long *))
> +{
> +	struct device_node *np, *child, *sensor_np;
> +
> +	np = of_find_node_by_name(NULL, "thermal-zones");
> +	if (!np)
> +		return ERR_PTR(-ENODEV);
> +
> +	if (!dev || !dev->of_node)
> +		return ERR_PTR(-EINVAL);
> +
> +	sensor_np = dev->of_node;
> +
> +	for_each_child_of_node(np, child) {
> +		struct of_phandle_args sensor_specs;
> +		int ret;
> +
> +		/* For now, thermal framework supports only 1 sensor per zone */
> +		ret = of_parse_phandle_with_args(child, "sensors",
> +						 "#sensor-cells",
> +						 0, &sensor_specs);
> +		if (ret)
> +			continue;
> +
> +		if (sensor_specs.args_count < 1)
> +			continue;
> +
> +		if (sensor_specs.np == sensor_np &&
> +		    sensor_specs.args[0] == sensor_id) {
> +			of_node_put(np);
> +			return thermal_zone_of_add_sensor(child, sensor_np,
> +							  data,
> +							  get_temp,
> +							  get_trend);
> +		}
> +	}
> +	of_node_put(np);
> +
> +	return ERR_PTR(-ENODEV);
> +}
> +EXPORT_SYMBOL_GPL(thermal_zone_of_sensor_register);
> +
> +/**
> + * thermal_zone_of_sensor_unregister - unregisters a sensor from a DT thermal zone
> + * @dev: a valid struct device pointer of a sensor device. Must contain
> + *       a valid .of_node, for the sensor node.
> + * @tzd: a pointer to struct thermal_zone_device where the sensor is registered.
> + *
> + * This function removes the sensor callbacks and private data from the
> + * thermal zone device registered with thermal_zone_of_sensor_register()
> + * API. It will also silent the zone by remove the .get_temp() and .get_trend()
> + * thermal zone device callbacks.
> + *
> + * TODO: When the support to several sensors per zone is added, this
> + * function must search the sensor list based on @dev parameter.
> + *
> + */
> +void thermal_zone_of_sensor_unregister(struct device *dev,
> +				       struct thermal_zone_device *tzd)
> +{
> +	struct __thermal_zone *tz = tzd->devdata;
> +

You might want to check for a NULL thermal zone device before dereferencing it.

Guenter

> +	/* no __thermal_zone, nothing to be done */
> +	if (!tz)
> +		return;
> +
> +	mutex_lock(&tzd->lock);
> +	tzd->ops->get_temp = NULL;
> +	tzd->ops->get_trend = NULL;
> +
> +	tz->get_temp = NULL;
> +	tz->get_trend = NULL;
> +	tz->sensor_data = NULL;
> +	mutex_unlock(&tzd->lock);
> +}
> +EXPORT_SYMBOL_GPL(thermal_zone_of_sensor_unregister);
> +
> +/***   functions parsing device tree nodes   ***/
> +
> +/**
> + * thermal_of_populate_bind_params - parse and fill cooling attachment data
> + * @np: DT node containing a cooling-attachment node
> + * @__tbp: data structure to be filled with cooling attachment info
> + * @trips: array of thermal zone trip points
> + * @ntrips: number of trip points inside trips.
> + *
> + * This function parses a cooling-attachment type of node represented by
> + * @np parameter and fills the read data into @__tbp data structure.
> + * It needs the already parsed array of trip points of the thermal zone
> + * in consideration.
> + *
> + * Return: 0 on success, proper error code otherwise
> + */
> +static int thermal_of_populate_bind_params(struct device_node *np,
> +					   struct __thermal_bind_params *__tbp,
> +					   struct __thermal_trip *trips,
> +					   int ntrips)
> +{
> +	struct of_phandle_args cooling_spec;
> +	struct device_node *trip;
> +	int ret, i;
> +	u32 prop;
> +
> +	/* Default weight. Usage is optional */
> +	__tbp->usage = 0;
> +	ret = of_property_read_u32(np, "usage", &prop);
> +	if (ret == 0)
> +		__tbp->usage = prop;
> +
> +	trip = of_parse_phandle(np, "trip", 0);
> +	if (!trip) {
> +		pr_err("missing trip property\n");
> +		return -ENODEV;
> +	}
> +
> +	/* match using device_node */
> +	for (i = 0; i < ntrips; i++)
> +		if (trip == trips[i].np) {
> +			__tbp->trip_id = i;
> +			break;
> +		}
> +
> +	if (i == ntrips) {
> +		ret = -ENODEV;
> +		goto end;
> +	}
> +
> +	ret = of_parse_phandle_with_args(np, "cooling-device", "#cooling-cells",
> +					 0, &cooling_spec);
> +	if (ret < 0) {
> +		pr_err("missing cooling_device property\n");
> +		goto end;
> +	}
> +	__tbp->cooling_device = cooling_spec.np;
> +	if (cooling_spec.args_count >= 2) { /* at least min and max */
> +		__tbp->min = cooling_spec.args[0];
> +		__tbp->max = cooling_spec.args[1];
> +	} else {
> +		pr_err("wrong reference to cooling device, missing limits\n");
> +	}
> +
> +end:
> +	of_node_put(trip);
> +
> +	return ret;
> +}
> +
> +/**
> + * thermal_of_populate_trip - parse and fill one trip point data
> + * @np: DT node containing a trip point node
> + * @trip: trip point data structure to be filled up
> + *
> + * This function parses a trip point type of node represented by
> + * @np parameter and fills the read data into @trip data structure.
> + *
> + * Return: 0 on success, proper error code otherwise
> + */
> +static int thermal_of_populate_trip(struct device_node *np,
> +				    struct __thermal_trip *trip)
> +{
> +	int prop;
> +	int ret;
> +
> +	ret = of_property_read_u32(np, "temperature", &prop);
> +	if (ret < 0) {
> +		pr_err("missing temperature property\n");
> +		return ret;
> +	}
> +	trip->temperature = prop;
> +
> +	ret = of_property_read_u32(np, "hysteresis", &prop);
> +	if (ret < 0) {
> +		pr_err("missing hysteresis property\n");
> +		return ret;
> +	}
> +	trip->hysteresis = prop;
> +
> +	ret = of_property_read_u32(np, "type", &prop);
> +	if (ret < 0) {
> +		pr_err("missing type property\n");
> +		return ret;
> +	}
> +	trip->type = prop;
> +
> +	/* Required for cooling attachment matching */
> +	trip->np = np;
> +
> +	return 0;
> +}
> +
> +/**
> + * thermal_of_build_thermal_zone - parse and fill one thermal zone data
> + * @np: DT node containing a thermal zone node
> + *
> + * This function parses a thermal zone type of node represented by
> + * @np parameter and fills the read data into a __thermal_zone data structure
> + * and return this pointer.
> + *
> + * Return: On success returns a valid struct __thermal_zone,
> + * otherwise, it returns a corresponding ERR_PTR(). Caller must
> + * check the return value with help of IS_ERR() helper.
> + */
> +static struct __thermal_zone *
> +thermal_of_build_thermal_zone(struct device_node *np)
> +{
> +	struct device_node *child, *gchild;
> +	struct __thermal_zone *tz;
> +	int ret, i;
> +	u32 prop;
> +
> +	if (!np) {
> +		pr_err("no thermal zone np\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	tz = kzalloc(sizeof(*tz), GFP_KERNEL);
> +	if (!tz) {
> +		pr_err("not enough memory for thermal of zone\n");
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	ret = of_property_read_u32(np, "passive-delay", &prop);
> +	if (ret < 0) {
> +		pr_err("missing passive_delay property\n");
> +		return ERR_PTR(ret);
> +	}
> +	tz->passive_delay = prop;
> +
> +	ret = of_property_read_u32(np, "polling-delay", &prop);
> +	if (ret < 0) {
> +		pr_err("missing polling_delay property\n");
> +		return ERR_PTR(ret);
> +	}
> +	tz->polling_delay = prop;
> +
> +	/* trips */
> +	child = of_get_child_by_name(np, "trips");
> +
> +	/* No trips provided */
> +	if (!child)
> +		goto finish;
> +
> +	tz->ntrips = of_get_child_count(child);
> +	tz->trips = kzalloc(tz->ntrips * sizeof(*tz->trips), GFP_KERNEL);
> +	if (!tz->trips)
> +		return ERR_PTR(-ENOMEM);
> +	i = 0;
> +	for_each_child_of_node(child, gchild)
> +		thermal_of_populate_trip(gchild, &tz->trips[i++]);
> +
> +	of_node_put(child);
> +
> +	/* cooling-attachments */
> +	child = of_get_child_by_name(np, "cooling-attachments");
> +
> +	/* cooling-attachments provided */
> +	if (!child)
> +		goto finish;
> +
> +	tz->num_tbps = of_get_child_count(child);
> +	tz->tbps = kzalloc(tz->num_tbps * sizeof(*tz->tbps), GFP_KERNEL);
> +	if (!tz->tbps)
> +		return ERR_PTR(-ENOMEM);
> +	i = 0;
> +	for_each_child_of_node(child, gchild)
> +		thermal_of_populate_bind_params(gchild, &tz->tbps[i++],
> +						tz->trips, tz->ntrips);
> +
> +finish:
> +	tz->mode = THERMAL_DEVICE_DISABLED;
> +
> +	return tz;
> +}
> +
> +/**
> + * of_parse_thermal_zones - parse device tree thermal data
> + *
> + * Initialization function that can be called by machine initialization
> + * code to parse thermal data and populate the thermal framework
> + * with hardware thermal zones info. This function only parses thermal zones.
> + * Cooling devices and sensor devices nodes are supposed to be parsed
> + * by their respective drivers.
> + *
> + * Return: 0 on success, proper error code otherwise
> + *
> + */
> +int __init of_parse_thermal_zones(void)
> +{
> +	struct device_node *np, *child;
> +	struct __thermal_zone *tz;
> +	struct thermal_zone_device_ops *ops;
> +
> +	np = of_find_node_by_name(NULL, "thermal-zones");
> +	if (!np) {
> +		pr_err("unable to find thermal zones\n");
> +		return 0;
> +	}
> +
> +	for_each_child_of_node(np, child) {
> +		struct thermal_zone_device *zone;
> +		struct thermal_zone_params *tzp;
> +
> +		tz = thermal_of_build_thermal_zone(child);
> +		if (IS_ERR(tz)) {
> +			pr_err("failed to build thermal zone %ld\n",
> +			       PTR_ERR(tz));
> +			return 0;
> +		}
> +
> +		ops = kzalloc(sizeof(*ops), GFP_KERNEL);
> +		if (!ops) {
> +			pr_err("no memory available for thermal ops\n");
> +			return 0;
> +		}
> +		memcpy(ops, &of_thermal_ops, sizeof(*ops));
> +
> +		tzp = kzalloc(sizeof(*tzp), GFP_KERNEL);
> +		if (!ops) {
> +			pr_err("no memory available for thermal zone params\n");
> +			return 0;
> +		}
> +		/* No hwmon because there might be hwmon drivers registering */
> +		tzp->no_hwmon = true;
> +
> +		zone = thermal_zone_device_register(child->name, tz->ntrips,
> +						    0, tz,
> +						    ops, tzp,
> +						    tz->passive_delay,
> +						    tz->polling_delay);
> +		if (IS_ERR(zone))
> +			pr_err("Failed to build %s zone %ld\n", child->name,
> +			       PTR_ERR(zone));
> +	}
> +	return 0;
> +}
> +
> +/**
> + * of_thermal_destroy_zones - remove all zones parsed and allocated resources
> + *
> + * Finds all zones parsed and added to the thermal framework and remove them
> + * from the system, together with their resources.
> + *
> + */
> +void __exit of_thermal_destroy_zones(void)
> +{
> +	struct device_node *np, *child;
> +	struct __thermal_zone *tz;
> +
> +	np = of_find_node_by_name(NULL, "thermal-zones");
> +	if (!np) {
> +		pr_err("unable to find thermal zones\n");
> +		return;
> +	}
> +
> +	for_each_child_of_node(np, child) {
> +		struct thermal_zone_device *zone;
> +
> +		zone = thermal_zone_get_zone_by_name(child->name);
> +		if (IS_ERR(zone))
> +			continue;
> +
> +		thermal_zone_device_unregister(zone);
> +		kfree(zone->tzp);
> +		kfree(zone->ops);
> +		tz = zone->devdata;
> +		kfree(tz->tbps);
> +		kfree(tz->trips);
> +		kfree(tz);
> +	}
> +}
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 8a94300..a733241 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1371,7 +1371,7 @@ static void remove_trip_attrs(struct thermal_zone_device *tz)
>   */
>  struct thermal_zone_device *thermal_zone_device_register(const char *type,
>  	int trips, int mask, void *devdata,
> -	const struct thermal_zone_device_ops *ops,
> +	struct thermal_zone_device_ops *ops,
>  	const struct thermal_zone_params *tzp,
>  	int passive_delay, int polling_delay)
>  {
> @@ -1751,8 +1751,14 @@ static int __init thermal_init(void)
>  	if (result)
>  		goto unregister_class;
>  
> +	result = of_parse_thermal_zones();
> +	if (result)
> +		goto exit_netlink;
> +
>  	return 0;
>  
> +exit_netlink:
> +	genetlink_exit();
>  unregister_governors:
>  	thermal_unregister_governors();
>  unregister_class:
> @@ -1768,6 +1774,7 @@ error:
>  
>  static void __exit thermal_exit(void)
>  {
> +	of_thermal_destroy_zones();
>  	genetlink_exit();
>  	class_unregister(&thermal_class);
>  	thermal_unregister_governors();
> diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
> index 7cf2f66..3db339f 100644
> --- a/drivers/thermal/thermal_core.h
> +++ b/drivers/thermal/thermal_core.h
> @@ -77,4 +77,13 @@ static inline int thermal_gov_user_space_register(void) { return 0; }
>  static inline void thermal_gov_user_space_unregister(void) {}
>  #endif /* CONFIG_THERMAL_GOV_USER_SPACE */
>  
> +/* device tree support */
> +#ifdef CONFIG_THERMAL_OF
> +int of_parse_thermal_zones(void);
> +void of_thermal_destroy_zones(void);
> +#else
> +static inline int of_parse_thermal_zones(void) { return 0; }
> +static inline void of_thermal_destroy_zones(void) { }
> +#endif
> +
>  #endif /* __THERMAL_CORE_H__ */
> diff --git a/include/dt-bindings/thermal/thermal.h b/include/dt-bindings/thermal/thermal.h
> new file mode 100644
> index 0000000..6dd6ccd
> --- /dev/null
> +++ b/include/dt-bindings/thermal/thermal.h
> @@ -0,0 +1,27 @@
> +/*
> + * This header provides constants for most thermal bindings.
> + *
> + * Copyright (C) 2013 Texas Instruments
> + *	Eduardo Valentin <eduardo.valentin@ti.com>
> + *
> + * GPLv2 only
> + */
> +
> +#ifndef _DT_BINDINGS_THERMAL_THERMAL_H
> +#define _DT_BINDINGS_THERMAL_THERMAL_H
> +
> +/*
> + * Here are the thermal trip types. This must
> + * match with enum thermal_trip_type at
> + * include/linux/thermal.h
> + */
> +#define THERMAL_TRIP_ACTIVE		0
> +#define THERMAL_TRIP_PASSIVE		1
> +#define THERMAL_TRIP_HOT		2
> +#define THERMAL_TRIP_CRITICAL		3
> +
> +/* On cooling devices upper and lower limits */
> +#define THERMAL_NO_LIMIT		(-1UL)
> +
> +#endif
> +
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index b268d3c..b780c5b 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -143,6 +143,7 @@ struct thermal_cooling_device {
>  	int id;
>  	char type[THERMAL_NAME_LENGTH];
>  	struct device device;
> +	struct device_node *np;
>  	void *devdata;
>  	const struct thermal_cooling_device_ops *ops;
>  	bool updated; /* true if the cooling device does not need update */
> @@ -172,7 +173,7 @@ struct thermal_zone_device {
>  	int emul_temperature;
>  	int passive;
>  	unsigned int forced_passive;
> -	const struct thermal_zone_device_ops *ops;
> +	struct thermal_zone_device_ops *ops;
>  	const struct thermal_zone_params *tzp;
>  	struct thermal_governor *governor;
>  	struct list_head thermal_instances;
> @@ -242,8 +243,31 @@ struct thermal_genl_event {
>  };
>  
>  /* Function declarations */
> +#ifdef CONFIG_THERMAL_OF
> +struct thermal_zone_device *
> +thermal_zone_of_sensor_register(struct device *dev, int id,
> +				void *data, int (*get_temp)(void *, long *),
> +				int (*get_trend)(void *, long *));
> +void thermal_zone_of_sensor_unregister(struct device *dev,
> +				       struct thermal_zone_device *tz);
> +#else
> +static inline struct thermal_zone_device *
> +thermal_zone_of_sensor_register(struct device *dev, int id,
> +				void *data, int (*get_temp)(void *, long *),
> +				int (*get_trend)(void *, long *))
> +{
> +	return NULL;
> +}
> +
> +static inline
> +void thermal_zone_of_sensor_unregister(struct device *dev,
> +				       struct thermal_zone_device *tz)
> +{
> +}
> +
> +#endif
>  struct thermal_zone_device *thermal_zone_device_register(const char *, int, int,
> -		void *, const struct thermal_zone_device_ops *,
> +		void *, struct thermal_zone_device_ops *,
>  		const struct thermal_zone_params *, int, int);
>  void thermal_zone_device_unregister(struct thermal_zone_device *);
>  
> -- 
> 1.8.2.1.342.gfa7285d
> 
> 
