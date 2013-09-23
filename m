Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab3IWKkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:40:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37971 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753614Ab3IWKkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:40:11 -0400
Date: Mon, 23 Sep 2013 11:40:03 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
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
Message-ID: <20130923104003.GA16069@e106331-lin.cambridge.arm.com>
References: <1379537849-28425-1-git-send-email-eduardo.valentin@ti.com>
 <1379540136-28378-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379540136-28378-1-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

Apologies for having taken so long to get back you on this.

I have several comments on the binding and the way it's parsed.

On Wed, Sep 18, 2013 at 10:35:36PM +0100, Eduardo Valentin wrote:
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
>  .../devicetree/bindings/thermal/thermal.txt        | 498 +++++++++++++
>  drivers/thermal/Kconfig                            |  13 +
>  drivers/thermal/Makefile                           |   1 +
>  drivers/thermal/of-thermal.c                       | 775 +++++++++++++++++++++
>  drivers/thermal/thermal_core.c                     |   9 +-
>  drivers/thermal/thermal_core.h                     |   9 +
>  include/dt-bindings/thermal/thermal.h              |  27 +
>  include/linux/thermal.h                            |  28 +-
>  8 files changed, 1357 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/thermal/thermal.txt
>  create mode 100644 drivers/thermal/of-thermal.c
>  create mode 100644 include/dt-bindings/thermal/thermal.h
> 
> ---
> 
> Hello all,
> 
> Thanks Joe Perches for the effort of reviewing this code, I really appreciate it.
> 
> Here is a version with a refactored init function without leaks in the failure
> patch. I also added a couple of comments to better understand the intention of
> that function. Besides, when there are no memory available, the function
> rolls back what ever thermal zones have been added.
> 
> Thanks,
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

I think "attachments" sounds a bit odd, though I don't have a better
naming suggestion.

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
> +- #sensor-cells:       Used to provide sensor device specific information
> +                       while referring to it. Must be at least 1, in order
> +                       to identify uniquely the sensor instances within
> +                       the IC. See thermal zone binding for more details
> +                       on how consumers refer to sensor devices.

I don't see why this needs to be at least one cell -- if an IC only has
one temperature sensor it should be fine for this to be zero and have no
ambiguity.

It may make sense to call these thermal sensor devices, there are plenty
of other sensors we might want to describe in the dt for other purposes,
and we can impose some consistency if we remove the ambiguity.

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
> +- cooling-min-level:   A unsigned integer indicating the smallest
> +                       cooling level accepted. Typically 0.
> +- cooling-max-level:   An unsigned integer indicating the largest
> +                       cooling level accepted.

I'm not sure what a "cooling level" means. It seems a bit abstract. Is
this binding specific?

How does this relate to cooling-cells? These seem to be a fixed size.

> +- #cooling-cells:      Used to provide cooling device specific information
> +                       while referring to it. Must be at least 2, in order
> +                       to specify minimum and maximum cooling level used
> +                       in the reference. See Cooling device attachments section
> +                       below for more details on how consumers refer to
> +                       cooling devices.

Are these cooling cells always expected to cover min and max, and are
min and max always expected to take the same number of cells? The above
cooling-*-level properties imply they each take up one cell.

Does #cooling-cells = <3> make sense?. If this covers additional
information (e.g. which fan on a multi-fan controller), how does the OS
determine which cells are min and max, and how do these relate to
cooling-level-min and cooling-level-max?

> +
> +* Trip points
> +
> +The trip node is a node to describe a point in the temperature domain
> +in which the system takes an action. This node describes just the point,
> +not the action.

I'm still not sure on this, as it sounds like embedding policy into the
DT, rather than a description of the hardware. I realise we need to
prevent devices burning out, so describing the max acceptable
temperature and possibly a preferred range makes sense, but do we need
this level of flexibility? Maybe we do.

> +
> +Required properties:
> +- temperature:         the trip temperature level, in milliCelsius.

Preferably, s/milliCelsius/millicelsius/ over the document.

Given that we have signed values elsewhere, is this signed or unsigned?

> +- hysteresis:          a (low) hysteresis value on 'temperature'. This is a
> +                       relative value, in milliCelsius.
> +- type:                        the trip type. Here is the type mapping:
> +       THERMAL_TRIP_ACTIVE     0:      A trip point to enable active cooling
> +       THERMAL_TRIP_PASSIVE    1:      A trip point to enable passive cooling
> +       THERMAL_TRIP_HOT        2:      A trip point to notify emergency
> +       THERMAL_TRIP_CRITICAL   3:      Hardware not reliable.
> +
> +Refer to include/dt-bindings/thermal/thermal.h for definition of these consts.

Why not use a string for this? We do so for other type parameters in
other bindings (see dr_mode in
Documentation/devicetree/bindings/usb/generic.txt, phy-mode for ethernet
PHYs, etc).

> +
> +* Cooling device attachments
> +
> +The cooling device attachments node is a node to describe how cooling devices
> +get assigned to trip points of the zone. The cooling devices are expected
> +to be loaded in the target system.
> +
> +Required properties:
> +- cooling-device:      A phandle of a cooling device with its parameters,
> +                       referring to which cooling device is used in this
> +                       binding. The required parameters are: the minimum
> +                       cooling level and the maximum cooling level used
> +                       in this attach.

Might this be a list in general? The code doesn't have to support that
yet.

It would be nice to have a name for the cells after a phandle which
describe the cooling device's configuration. You've called them
parameters here, but it probably makes sense to call them a
cooling-specifier (following clock-specifier and interrupt-specifier).

> +- trip:                        A phandle of a trip point node within the same thermal
> +                       zone.
> +
> +Optional property:
> +- contribution:                The cooling contribution to the thermal zone of the
> +                       referred cooling device at the referred trip point.
> +                       The contribution is a value from 0 to 100. The sum
> +                       of all cooling contributions within a thermal zone
> +                       must never exceed 100.

This is a bit arbitrary. Couldn't we sum all contributions to find the
total automatically, so this could be a simpler ratio?

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

s/cdev/cooling device/ ?

> +
> +Required properties:
> +- passive-delay:       The maximum number of milliseconds to wait between polls
> +                       when performing passive cooling.
> +- polling-delay:       The maximum number of milliseconds to wait between polls
> +                       when checking this thermal zone.

How about polling-delay-passive, polling-delay-active? I'm still not

> +- sensors:             A list of sensor phandles and their parameters. The
> +                       required parameter is the sensor id, in order to
> +                       identify internal sensors when the sensor IC features
> +                       several sensing units.

As mentioned above, I'm not sure you even need that one cell.

- sensors:                A list of sensor phandle + thermal-sensor-specifier
                          cells describing the sensors monitoring the thermal
			  zone.

> +- trips:               A sub-node containing several trip point nodes required
> +                       to describe the thermal zone.
> +- cooling-attachments  A sub-node containing several cooling device attaches
> +                       nodes, used to describe the relation between trips
> +                       and cooling devices.
> +
> +Optional property:
> +- coefficients:                An array of integers (one signed cell) containing
> +                       coefficients to compose a linear relation between
> +                       the sensors described in the sensors property.
> +                       Coefficients defaults to 1, in case this property
> +                       is not specified. A simple linear polynomial is used:
> +                       Z = c0 * x0 + c1 + x1 + ... + c(n-1) * x(n-1) + cn.
> +
> +                       The coefficients are ordered and they match with sensors
> +                       by means of sensor ID. Additional coefficients are
> +                       interpreted as constant offsets.

What is the end result of this? Presumably this is meant to result in an
estimate of the average temperature of the thermal zone, rather than an
arbitrary value? This should be mentioned.

This doesn't seem to be used the in the code below...

> +
> +Note: The delay properties are bound to the maximum dT/dt (temperature
> +derivative over time) in two situations for a thermal zone:
> +(i)  - when active cooling is activated (passive-delay); and
> +(ii) - when the zone just needs to be monitored (polling-delay).
> +The maximum dT/dt is highly bound to hardware power consumption and dissipation
> +capability.

I'm not sure what you mean by this, could you elaborate?

I guess you mean that the delays should be chosen to account for said
max dT/dt, such that a device can't unexpectedly cross several trip
boundaries between polls?

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
> +       cpu0: cpu@0 {
> +               ...
> +               cooling-min-level = <0>;
> +               cooling-max-level = <3>;
> +               #cooling-cells = <2>; /* min followed by max */
> +       };

What do those min and max mean in this context? What do the values in
the range [0,3] correspond to?

I'm not sure it makes sense to describe passive cooling in this way --
the precise way an OS does less work on a device is fundamentally tied
to the design of the OS (it might be able to rate-limit requests, it
might be able to clock the device down, it might only be able to turn
the device off).

I'm not sure there is anything we can describe for passive cooling
(beyond the thermal limits the OS should attempt to stick to).

> +       ...
> +};
> +
> +&i2c1 {
> +       ...
> +       fan0: fan@0x48 {
> +               ...
> +               cooling-min-level = <0>;
> +               cooling-max-level = <9>;
> +               #cooling-cells = <2>; /* min followed by max */
> +       };

What do min and max mean here for the fan?

> +};
> +
> +bandgap0: bandgap@0x0000ED00 {
> +       ...
> +       #sensor-cells = <1>;
> +};
> +
> +cpu-thermal: cpu-thermal {

How do the thermal zones get probed?

> +       passive-delay = <250>; /* milliseconds */
> +       polling-delay = <1000>; /* milliseconds */
> +
> +               /* sensor       ID */
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
> +       cooling-attachments {
> +               attach0 {
> +                       trip = <&cpu-alert0>;
> +                       cooling-device = <&fan0 THERMAL_NO_LIMITS 4>;
> +               };
> +               attach1 {
> +                       trip = <&cpu-alert1>;
> +                       cooling-device = <&fan0 5 THERMAL_NO_LIMITS>;
> +               };
> +               attach2 {
> +                       trip = <&cpu-alert1>;
> +                       cooling-device =
> +                               <&cpu0 THERMAL_NO_LIMITS THERMAL_NO_LIMITS>;
> +               };
> +       };

Was there a good reason for splitting trips and attachment?

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

[...]

> +(c) - Several sensors within one single thermal zone
> +
> +The example below illustrates how to use more than one sensor within
> +one thermal zone.
> +
> +#include <dt-bindings/thermal/thermal.h>
> +
> +&i2c1 {
> +       ...
> +       adc: sensor@0x49 {
> +               ...
> +               #sensor-cells = <1>;
> +       };
> +};
> +
> +bandgap0: bandgap@0x0000ED00 {
> +       ...
> +       #sensor-cells = <1>;
> +};
> +
> +cpu-thermal: cpu-thermal {
> +       passive-delay = <250>; /* milliseconds */
> +       polling-delay = <1000>; /* milliseconds */
> +
> +               /* sensor       ID */
> +        sensors = <&bandgap0   0>,
> +                 <&adc         0>;
> +
> +               /* hotspot = 100 * bandgap - 120 * adc + 484 */
> +       coefficients =          <100    -120    484>;

Aha, so these are signed. This *must* be mentioned in the documentation.
The types of all properties should be described in their definition.

[...]

> +struct thermal_zone_device *
> +thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
> +                               void *data, int (*get_temp)(void *, long *),
> +                               int (*get_trend)(void *, long *))
> +{
> +       struct device_node *np, *child, *sensor_np;
> +
> +       np = of_find_node_by_name(NULL, "thermal-zones");

This is the first instance of "thermal-zones" in this patch. Presumably
this is the container for thermal zones that allows them to be probed
(answering my question above). This *must* be described in the binding.

> +       if (!np)
> +               return ERR_PTR(-ENODEV);
> +
> +       if (!dev || !dev->of_node)
> +               return ERR_PTR(-EINVAL);
> +
> +       sensor_np = dev->of_node;
> +
> +       for_each_child_of_node(np, child) {
> +               struct of_phandle_args sensor_specs;
> +               int ret;
> +
> +               /* For now, thermal framework supports only 1 sensor per zone */
> +               ret = of_parse_phandle_with_args(child, "sensors",
> +                                                "#sensor-cells",
> +                                                0, &sensor_specs);
> +               if (ret)
> +                       continue;
> +
> +               if (sensor_specs.args_count < 1)
> +                       continue;

Why? I fail to see why a single sensor *must* have some configuration cells.

> +
> +               if (sensor_specs.np == sensor_np &&
> +                   sensor_specs.args[0] == sensor_id) {
> +                       of_node_put(np);
> +                       return thermal_zone_of_add_sensor(child, sensor_np,
> +                                                         data,
> +                                                         get_temp,
> +                                                         get_trend);
> +               }
> +       }
> +       of_node_put(np);
> +
> +       return ERR_PTR(-ENODEV);
> +}
> +EXPORT_SYMBOL_GPL(thermal_zone_of_sensor_register);

[...]

> +static int thermal_of_populate_bind_params(struct device_node *np,
> +                                          struct __thermal_bind_params *__tbp,
> +                                          struct __thermal_trip *trips,
> +                                          int ntrips)
> +{
> +       struct of_phandle_args cooling_spec;
> +       struct device_node *trip;
> +       int ret, i;
> +       u32 prop;
> +
> +       /* Default weight. Usage is optional */
> +       __tbp->usage = 0;
> +       ret = of_property_read_u32(np, "usage", &prop);

That wasn't described in the binding. Should this be reading the
"contribution" property?

> +       if (ret == 0)
> +               __tbp->usage = prop;
> +
> +       trip = of_parse_phandle(np, "trip", 0);
> +       if (!trip) {
> +               pr_err("missing trip property\n");
> +               return -ENODEV;
> +       }
> +
> +       /* match using device_node */
> +       for (i = 0; i < ntrips; i++)
> +               if (trip == trips[i].np) {
> +                       __tbp->trip_id = i;
> +                       break;
> +               }
> +
> +       if (i == ntrips) {
> +               ret = -ENODEV;
> +               goto end;
> +       }
> +
> +       ret = of_parse_phandle_with_args(np, "cooling-device", "#cooling-cells",
> +                                        0, &cooling_spec);
> +       if (ret < 0) {
> +               pr_err("missing cooling_device property\n");
> +               goto end;
> +       }
> +       __tbp->cooling_device = cooling_spec.np;
> +       if (cooling_spec.args_count >= 2) { /* at least min and max */
> +               __tbp->min = cooling_spec.args[0];
> +               __tbp->max = cooling_spec.args[1];

Ah, so the first two cells are meant to be min and max, not any
arbitrary cells. Why is this necessary?

> +       } else {
> +               pr_err("wrong reference to cooling device, missing limits\n");
> +       }
> +
> +end:
> +       of_node_put(trip);
> +
> +       return ret;
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
> +                                   struct __thermal_trip *trip)
> +{
> +       int prop;
> +       int ret;
> +
> +       ret = of_property_read_u32(np, "temperature", &prop);
> +       if (ret < 0) {
> +               pr_err("missing temperature property\n");
> +               return ret;
> +       }
> +       trip->temperature = prop;
> +
> +       ret = of_property_read_u32(np, "hysteresis", &prop);
> +       if (ret < 0) {
> +               pr_err("missing hysteresis property\n");
> +               return ret;
> +       }
> +       trip->hysteresis = prop;
> +
> +       ret = of_property_read_u32(np, "type", &prop);
> +       if (ret < 0) {
> +               pr_err("missing type property\n");
> +               return ret;
> +       }
> +       trip->type = prop;

No sanity checking?

I'd prefer a string and a table from string to Linux internal ID. Others
may have differing opinions.

> +
> +       /* Required for cooling attachment matching */
> +       trip->np = np;
> +
> +       return 0;
> +}

[...]

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
> +       struct device_node *child, *gchild;
> +       struct __thermal_zone *tz;
> +       int ret, i;
> +       u32 prop;
> +
> +       if (!np) {
> +               pr_err("no thermal zone np\n");
> +               return ERR_PTR(-EINVAL);
> +       }
> +
> +       tz = kzalloc(sizeof(*tz), GFP_KERNEL);
> +       if (!tz)
> +               return ERR_PTR(-ENOMEM);
> +
> +       ret = of_property_read_u32(np, "passive-delay", &prop);
> +       if (ret < 0) {
> +               pr_err("missing passive_delay property\n");

Inconsistent '-' and '_' between the parsing and the error.

> +               return ERR_PTR(ret);
> +       }
> +       tz->passive_delay = prop;
> +
> +       ret = of_property_read_u32(np, "polling-delay", &prop);
> +       if (ret < 0) {
> +               pr_err("missing polling_delay property\n");

Same here.

> +               return ERR_PTR(ret);
> +       }
> +       tz->polling_delay = prop;
> +
> +       /* trips */
> +       child = of_get_child_by_name(np, "trips");
> +
> +       /* No trips provided */
> +       if (!child)
> +               goto finish;
> +
> +       tz->ntrips = of_get_child_count(child);

What if there are no children, or this fails (returning zero)?

> +       tz->trips = kzalloc(tz->ntrips * sizeof(*tz->trips), GFP_KERNEL);

Here kzalloc could return ZERO_SIZE_PTR ((void*) 16). So the check below
isn't sufficient to stop us continuing if the node has no children. We
should check tz->ntrips above before calling kzalloc.

> +       if (!tz->trips)
> +               return ERR_PTR(-ENOMEM);
> +       i = 0;
> +       for_each_child_of_node(child, gchild)
> +               thermal_of_populate_trip(gchild, &tz->trips[i++]);

What if this fails for a child node?

> +
> +       of_node_put(child);
> +
> +       /* cooling-attachments */
> +       child = of_get_child_by_name(np, "cooling-attachments");
> +
> +       /* cooling-attachments provided */
> +       if (!child)
> +               goto finish;
> +
> +       tz->num_tbps = of_get_child_count(child);
> +       tz->tbps = kzalloc(tz->num_tbps * sizeof(*tz->tbps), GFP_KERNEL);
> +       if (!tz->tbps)
> +               return ERR_PTR(-ENOMEM);
> +       i = 0;
> +       for_each_child_of_node(child, gchild)
> +               thermal_of_populate_bind_params(gchild, &tz->tbps[i++],
> +                                               tz->trips, tz->ntrips);
> +
> +finish:
> +       tz->mode = THERMAL_DEVICE_DISABLED;
> +
> +       return tz;
> +}

What about all that useless data we may have just allocated memory for?

[...]

> +int __init of_parse_thermal_zones(void)
> +{
> +       struct device_node *np, *child;
> +       struct __thermal_zone *tz;
> +       struct thermal_zone_device_ops *ops;
> +
> +       np = of_find_node_by_name(NULL, "thermal-zones");
> +       if (!np) {
> +               pr_debug("unable to find thermal zones\n");
> +               return 0; /* Run successfully on systems without thermal DT */
> +       }
> +
> +       for_each_child_of_node(np, child) {
> +               struct thermal_zone_device *zone;
> +               struct thermal_zone_params *tzp;

So each child of thermal-zones must be a thermal zone (we can't embed
other nodes of information)?

> +
> +               tz = thermal_of_build_thermal_zone(child);
> +               if (IS_ERR(tz)) {
> +                       pr_err("failed to build thermal zone %s: %ld\n",
> +                              child->name,
> +                              PTR_ERR(tz));
> +                       continue;
> +               }
> +
> +               ops = kmemdup(&of_thermal_ops, sizeof(*ops), GFP_KERNEL);
> +               if (!ops)
> +                       goto exit_free;
> +
> +               tzp = kzalloc(sizeof(*tzp), GFP_KERNEL);
> +               if (!tzp) {
> +                       kfree(ops);
> +                       goto exit_free;
> +               }
> +
> +               /* No hwmon because there might be hwmon drivers registering */
> +               tzp->no_hwmon = true;
> +
> +               zone = thermal_zone_device_register(child->name, tz->ntrips,
> +                                                   0, tz,
> +                                                   ops, tzp,
> +                                                   tz->passive_delay,
> +                                                   tz->polling_delay);
> +               if (IS_ERR(zone)) {
> +                       pr_err("Failed to build %s zone %ld\n", child->name,
> +                              PTR_ERR(zone));
> +                       kfree(tzp);
> +                       kfree(ops);
> +                       of_thermal_free_zone(tz);
> +                       /* attempting to build remaining zones still */
> +               }
> +       }
> +
> +       return 0;
> +
> +exit_free:
> +       of_thermal_free_zone(tz);
> +
> +       /* no memory available, so free what we have built */
> +       of_thermal_destroy_zones();
> +
> +       return -ENOMEM;
> +}

Cheers,
Mark.
