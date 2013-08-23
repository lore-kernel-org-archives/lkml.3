Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3HWXRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 19:17:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48690 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063Ab3HWXRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 19:17:42 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <linux@roeck-us.net>, <rui.zhang@intel.com>,
        <wni@nvidia.com>
CC: <durgadoss.r@intel.com>, <linux-pm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [RFC PATCH 02/14] drivers: thermal: introduce device tree parser
Date: Fri, 23 Aug 2013 19:15:43 -0400
Message-ID: <1377299755-5134-3-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com>
References: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to be able to build thermal policies
based on generic sensors, like I2C device, that
can be places in different points on different boards,
there is a need to have a way to feed board dependent
data into the thermal framework.

This patch introduces a thermal data parser for device
tree. The parsed data is used to build thermal zones
and thermal binding parameters. The output data
can then be used to deploy thermal policies.

This patch adds also documentation regarding this
API and how to define tree nodes to use
this infrastructure.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 .../devicetree/bindings/thermal/thermal.txt        | 160 +++++++
 drivers/thermal/Kconfig                            |  13 +
 drivers/thermal/Makefile                           |   1 +
 drivers/thermal/thermal_dt.c                       | 473 +++++++++++++++++++++
 include/dt-bindings/thermal/thermal.h              |  27 ++
 include/linux/thermal.h                            |   3 +
 6 files changed, 677 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/thermal/thermal.txt
 create mode 100644 drivers/thermal/thermal_dt.c
 create mode 100644 include/dt-bindings/thermal/thermal.h

diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/Documentation/devicetree/bindings/thermal/thermal.txt
new file mode 100644
index 0000000..af20ab0
--- /dev/null
+++ b/Documentation/devicetree/bindings/thermal/thermal.txt
@@ -0,0 +1,160 @@
+----------------------------------------
+Thermal Framework Device Tree descriptor
+----------------------------------------
+
+This file describes how to define a thermal structure using device tree.
+A thermal structure includes thermal zones and their components, such
+as name, trip points, polling intervals and cooling devices binding
+descriptors. A binding descriptor may contain information on how to
+react, with a cooling stepped action or a weight on a fair share.
+The target of device tree thermal descriptors is to describe only
+the hardware thermal aspects, not how the system must control or which
+algorithm or policy must take place. It follows a description of each
+type of device tree node.
+
+****
+trip
+****
+
+The trip node is a node to describe a point in the temperature domain
+in which the system takes an action. This node describes just the point,
+not the action.
+
+A node describing a trip must contain:
+- temperature: the trip temperature level, in milliCelsius.
+- hysteresis: a (low) hysteresis value on 'temperature'. This is a relative
+value, in milliCelsius.
+- type: the trip type. Here is the type mapping:
+	THERMAL_TRIP_ACTIVE
+	THERMAL_TRIP_PASSIVE
+	THERMAL_TRIP_HOT
+	THERMAL_TRIP_CRITICAL
+
+**********
+bind_param
+**********
+
+The bind_param node is a node to describe how cooling devices get assigned
+to trip points of the zone. The cooling devices are expected to be loaded
+in the target system.
+
+A node describing a bind_param must contain:
+- cooling_device: A string with the cooling device name.
+- weight: The 'influence' of a particular cooling device on this zone.
+             This is on a percentage scale. The sum of all these weights
+             (for a particular zone) cannot exceed 100.
+- trip_mask: This is a bit mask that gives the binding relation between
+               this thermal zone and cdev, for a particular trip point.
+               If nth bit is set, then the cdev and thermal zone are bound
+               for trip point n.
+- limits: An array integers consisting of 2-tuples items, and each item means
+  lower and upper state limits, like <min-state max-state>.
+
+**************************
+temperature sensor devices
+**************************
+
+Temperature sensor devices have to be linked to a specific thermal zone.
+This is done by means of the 'monitored-zones' list.
+- monitored-zones: A list of thermal zones phandles, identifying which
+thermal zones the temperature sensor device is used to monitor.
+
+************
+thermal_zone
+************
+
+The thermal_zone node is the node containing all the required info
+for describing a thermal zone, including its cdev bindings. The thermal_zone
+node must contain, apart from its own properties, one node containing
+trip nodes and one node containing all the zone bind parameters.
+
+Required properties:
+- mask: Bit string: If 'n'th bit is set, then trip point 'n' is writeable.
+
+- passive_delay: number of milliseconds to wait between polls when
+  performing passive cooling.
+
+- polling_delay: number of milliseconds to wait between polls when checking.
+
+- #thermal-cells: An integer that is used to specify how many cells compose
+  sensor ids.
+
+Below is an example:
+cpu_thermal: thermal_zone {
+            #thermal-cells = <1>;
+            mask = <0x03>; /* trips writability */
+            passive_delay = <250>; /* milliseconds */
+            polling_delay = <1000>; /* milliseconds */
+            trips {
+                    alert@100000{
+                            temperature = <100000>; /* milliCelsius */
+                            hysteresis = <0>; /* milliCelsius */
+                            type = <THERMAL_TRIP_PASSIVE>;
+                    };
+                    crit@125000{
+                            temperature = <125000>; /* milliCelsius */
+                            hysteresis = <0>; /* milliCelsius */
+                            type = <THERMAL_TRIP_CRITICAL>;
+                    };
+            };
+            bind_params {
+                    action@0{
+                            cooling_device = "thermal-cpufreq";
+                            weight = <100>; /* percentage */
+                            mask = <0x01>;
+			    limits = <
+			      /* lower-state		upper-state */
+				1			THERMAL_NO_LIMITS
+				THERMAL_NO_LIMITS	THERMAL_NO_LIMITS
+			    >;
+                    };
+            };
+};
+
+sensor: adc@0xFFFF {
+	...
+	monitored-zones = <&cpu_thermal 0>;
+};
+
+cpu@0 {
+	...
+	cooling-zones = <&cpu_thermal>;
+};
+
+In the example above, the ADC sensor at address 0xFFFF is used to monitor
+the zone 'cpu_thermal' using its the sensor 0. The cpu@0 device is also linked
+to the same thermal zone 'cpu_thermal' as a cooling device.
+
+***************
+cpufreq-cooling
+***************
+
+The generic cpu cooling (freq clipping) can be loaded by the
+generic cpufreq-cpu0 driver in case the device tree node informs
+this need.
+
+In order to load the cpufreq cooling device, it is possible to
+inform that the cpu needs cooling by adding the list of thermal zones
+in the 'cooling-zones' property at the cpu0 phandle.
+
+Example:
+	cpus {
+		cpu@0 {
+			operating-points = <
+				/* kHz    uV */
+				800000  1313000
+				1008000 1375000
+			>;
+			cooling-zones = <&cpu_thermal>;
+		};
+	...
+	};
+
+The above will cause the cpufreq-cpu0 driver to understand that
+the cpu will need passive cooling and while probing that node it will
+also load the cpufreq cpu cooling device in that system.
+
+However, be advised that this flag will not describe what needs to
+be done or how the cpufreq cooling device will be used. In order to
+accomplish this, one needs to write a phandle for a thermal zone, as
+described in the section 'thermal_zone'.
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 7fb16bc..753f0dc 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -29,6 +29,19 @@ config THERMAL_HWMON
 	  Say 'Y' here if you want all thermal sensors to
 	  have hwmon sysfs interface too.
 
+config THERMAL_OF
+	bool
+	prompt "APIs to parse thermal data out of device tree"
+	depends on OF
+	default y
+	help
+	  This options provides helpers to add the support to
+	  read and parse thermal data definitions out of the
+	  device tree blob.
+
+	  Say 'Y' here if you need to build thermal infrastructure
+	  based on device tree.
+
 choice
 	prompt "Default Thermal governor"
 	default THERMAL_DEFAULT_GOV_STEP_WISE
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index 24cb894..eedb273 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -7,6 +7,7 @@ thermal_sys-y			+= thermal_core.o
 
 # interface to/from other layers providing sensors
 thermal_sys-$(CONFIG_THERMAL_HWMON)		+= thermal_hwmon.o
+thermal_sys-$(CONFIG_THERMAL_OF)		+= thermal_dt.o
 
 # governors
 thermal_sys-$(CONFIG_THERMAL_GOV_FAIR_SHARE)	+= fair_share.o
diff --git a/drivers/thermal/thermal_dt.c b/drivers/thermal/thermal_dt.c
new file mode 100644
index 0000000..cc35485
--- /dev/null
+++ b/drivers/thermal/thermal_dt.c
@@ -0,0 +1,473 @@
+/*
+ *  thermal_dt.c - Generic Thermal Management device tree support.
+ *
+ *  Copyright (C) 2013 Texas Instruments
+ *  Copyright (C) 2013 Eduardo Valentin <eduardo.valentin@ti.com>
+ *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#include <linux/thermal.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#include <linux/err.h>
+#include <linux/export.h>
+#include <linux/string.h>
+
+struct __thermal_bind_params {
+	char cooling_device[THERMAL_NAME_LENGTH];
+};
+
+static
+int thermal_of_match(struct thermal_zone_device *tz,
+		     struct thermal_cooling_device *cdev);
+
+static int thermal_of_populate_bind_params(struct device *dev,
+					   struct device_node *node,
+					   struct __thermal_bind_params *__tbp,
+					   struct thermal_bind_params *tbp,
+					   int ntrips)
+{
+	const char *cdev_name;
+	u32 *limits;
+	int ret;
+	u32 prop;
+
+	ret = of_property_read_u32(node, "weight", &prop);
+	if (ret < 0) {
+		dev_err(dev, "missing weight property\n");
+		return ret;
+	}
+	tbp->weight = prop;
+
+	ret = of_property_read_u32(node, "mask", &prop);
+	if (ret < 0) {
+		dev_err(dev, "missing mask property\n");
+		return ret;
+	}
+	tbp->trip_mask = prop;
+
+	/* this will allow us to bind with cooling devices */
+	tbp->match = thermal_of_match;
+
+	ret = of_property_read_string(node, "cooling_device", &cdev_name);
+	if (ret < 0) {
+		dev_err(dev, "missing cooling_device property\n");
+		return ret;
+	}
+	strncpy(__tbp->cooling_device, cdev_name,
+		sizeof(__tbp->cooling_device));
+
+	limits = kzalloc(ntrips * sizeof(*limits) * 2, GFP_KERNEL);
+	if (!limits) {
+		dev_err(dev, "not enough mem for reading limits\n");
+		return -ENOMEM;
+	}
+	ret = of_property_read_u32_array(node, "limits", limits, 2 * ntrips);
+	if (!ret) {
+		int i = ntrips;
+
+		tbp->binding_limits = devm_kzalloc(dev,
+						   ntrips * 2 *
+						   sizeof(*tbp->binding_limits),
+						   GFP_KERNEL);
+		if (!tbp->binding_limits) {
+			dev_err(dev, "not enough mem for storing limits\n");
+			return -ENOMEM;
+		}
+		while (i--)
+			tbp->binding_limits[i] = limits[i];
+	}
+	kfree(limits);
+
+	return 0;
+}
+
+struct __thermal_trip {
+	unsigned long int temperature;
+	unsigned long int hysteresis;
+	enum thermal_trip_type type;
+};
+
+static
+int thermal_of_populate_trip(struct device *dev,
+			     struct device_node *node,
+			     struct __thermal_trip *trip)
+{
+	int ret;
+	int prop;
+
+	ret = of_property_read_u32(node, "temperature", &prop);
+	if (ret < 0) {
+		dev_err(dev, "missing temperature property\n");
+		return ret;
+	}
+	trip->temperature = prop;
+
+	ret = of_property_read_u32(node, "hysteresis", &prop);
+	if (ret < 0) {
+		dev_err(dev, "missing hysteresis property\n");
+		return ret;
+	}
+	trip->hysteresis = prop;
+
+	ret = of_property_read_u32(node, "type", &prop);
+	if (ret < 0) {
+		dev_err(dev, "missing type property\n");
+		return ret;
+	}
+	trip->type = prop;
+
+	return 0;
+}
+
+struct __thermal_zone_device {
+	enum thermal_device_mode mode;
+	int passive_delay;
+	int polling_delay;
+	int mask;
+	int ntrips;
+	char type[THERMAL_NAME_LENGTH];
+	struct __thermal_trip *trips;
+	struct __thermal_bind_params *bind_params;
+	struct thermal_bind_params *tbps;
+	struct thermal_zone_params zone_params;
+	int (*get_temp)(void *, unsigned long *);
+	void *devdata;
+};
+
+static struct __thermal_zone_device *
+thermal_of_build_thermal_zone(struct device *dev, struct device_node *node)
+{
+	struct device_node *child, *gchild;
+	struct __thermal_zone_device *tz;
+	int ret, i;
+	u32 prop;
+
+	if (!node) {
+		dev_err(dev, "no thermal zone node\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	tz = devm_kzalloc(dev, sizeof(*tz), GFP_KERNEL);
+	if (!tz) {
+		dev_err(dev, "not enough memory for thermal of zone\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	ret = of_property_read_u32(node, "passive_delay", &prop);
+	if (ret < 0) {
+		dev_err(dev, "missing passive_delay property\n");
+		return ERR_PTR(ret);
+	}
+	tz->passive_delay = prop;
+
+	ret = of_property_read_u32(node, "polling_delay", &prop);
+	if (ret < 0) {
+		dev_err(dev, "missing polling_delay property\n");
+		return ERR_PTR(ret);
+	}
+	tz->polling_delay = prop;
+
+	ret = of_property_read_u32(node, "mask", &prop);
+	if (ret < 0) {
+		dev_err(dev, "missing mask property\n");
+		return ERR_PTR(ret);
+	}
+	tz->mask = prop;
+
+	/* assume node name as our zone type */
+	strncpy(tz->type, node->name, sizeof(tz->type));
+
+	/* default policy */
+	strncpy(tz->zone_params.governor_name, "step_wise",
+		sizeof(tz->zone_params.governor_name));
+
+	/* trips */
+	child = of_find_node_by_name(node, "trips");
+
+	/* No trips provided */
+	if (!child)
+		goto finish;
+
+	tz->ntrips = of_get_child_count(child);
+	tz->trips = devm_kzalloc(dev, tz->ntrips * sizeof(*tz->trips),
+				 GFP_KERNEL);
+	if (!tz->trips)
+		return ERR_PTR(-ENOMEM);
+	i = 0;
+	for_each_child_of_node(child, gchild)
+		thermal_of_populate_trip(dev, gchild, &tz->trips[i++]);
+
+	/* bind_params */
+	child = of_find_node_by_name(node, "bind_params");
+
+	/* No binding info */
+	if (!child)
+		goto finish;
+
+	tz->zone_params.num_tbps = of_get_child_count(child);
+	tz->bind_params = devm_kzalloc(dev,
+				       tz->zone_params.num_tbps *
+						sizeof(*tz->bind_params),
+				       GFP_KERNEL);
+	if (!tz->bind_params)
+		return ERR_PTR(-ENOMEM);
+	tz->zone_params.tbp = devm_kzalloc(dev,
+					   tz->zone_params.num_tbps *
+						sizeof(*tz->zone_params.tbp),
+					   GFP_KERNEL);
+	if (!tz->zone_params.tbp)
+		return ERR_PTR(-ENOMEM);
+	i = 0;
+	for_each_child_of_node(child, gchild) {
+		thermal_of_populate_bind_params(dev, gchild,
+						&tz->bind_params[i],
+						&tz->zone_params.tbp[i],
+						tz->ntrips);
+		i++;
+	}
+
+finish:
+	tz->mode = THERMAL_DEVICE_ENABLED;
+
+	return tz;
+}
+
+static
+int thermal_of_match(struct thermal_zone_device *tz,
+		     struct thermal_cooling_device *cdev)
+{
+	struct __thermal_zone_device *data = tz->devdata;
+	int i;
+
+	for (i = 0; i < data->zone_params.num_tbps; i++) {
+		if (!strncmp(data->bind_params[i].cooling_device,
+			     cdev->type,
+			     strlen(data->bind_params[i].cooling_device)) &&
+		    (data->zone_params.tbp[i].trip_mask & (1 << i)))
+			return 0;
+	}
+
+	return -EINVAL;
+}
+
+static
+int of_thermal_get_temp(struct thermal_zone_device *tz,
+			unsigned long *temp)
+{
+	struct __thermal_zone_device *data = tz->devdata;
+
+	return data->get_temp(data->devdata, temp);
+}
+
+static
+int of_thermal_get_mode(struct thermal_zone_device *tz,
+			enum thermal_device_mode *mode)
+{
+	struct __thermal_zone_device *data = tz->devdata;
+
+	*mode = data->mode;
+
+	return 0;
+}
+
+static
+int of_thermal_set_mode(struct thermal_zone_device *tz,
+			enum thermal_device_mode mode)
+{
+	struct __thermal_zone_device *data = tz->devdata;
+
+	mutex_lock(&tz->lock);
+
+	if (mode == THERMAL_DEVICE_ENABLED)
+		tz->polling_delay = data->polling_delay;
+	else
+		tz->polling_delay = 0;
+
+	mutex_unlock(&tz->lock);
+
+	data->mode = mode;
+	thermal_zone_device_update(tz);
+
+	return 0;
+}
+
+static
+int of_thermal_get_trip_type(struct thermal_zone_device *tz, int trip,
+			     enum thermal_trip_type *type)
+{
+	struct __thermal_zone_device *data = tz->devdata;
+
+	if (trip >= data->ntrips || trip < 0)
+		return -EDOM;
+
+	*type = data->trips[trip].type;
+
+	return 0;
+}
+
+static
+int of_thermal_get_trip_temp(struct thermal_zone_device *tz, int trip,
+			     unsigned long *temp)
+{
+	struct __thermal_zone_device *data = tz->devdata;
+
+	if (trip >= data->ntrips || trip < 0)
+		return -EDOM;
+
+	*temp = data->trips[trip].temperature;
+
+	return 0;
+}
+
+static
+int of_thermal_set_trip_temp(struct thermal_zone_device *tz, int trip,
+			     unsigned long temp)
+{
+	struct __thermal_zone_device *data = tz->devdata;
+
+	if (trip >= data->ntrips || trip < 0)
+		return -EDOM;
+
+	/* thermal fw should take care of data->mask & (1 << trip) */
+	data->trips[trip].temperature = temp;
+
+	return 0;
+}
+
+static
+int of_thermal_get_trip_hyst(struct thermal_zone_device *tz, int trip,
+			     unsigned long *hyst)
+{
+	struct __thermal_zone_device *data = tz->devdata;
+
+	if (trip >= data->ntrips || trip < 0)
+		return -EDOM;
+
+	*hyst = data->trips[trip].hysteresis;
+
+	return 0;
+}
+
+static
+int of_thermal_set_trip_hyst(struct thermal_zone_device *tz, int trip,
+			     unsigned long hyst)
+{
+	struct __thermal_zone_device *data = tz->devdata;
+
+	if (trip >= data->ntrips || trip < 0)
+		return -EDOM;
+
+	/* thermal fw should take care of data->mask & (1 << trip) */
+	data->trips[trip].hysteresis = hyst;
+
+	return 0;
+}
+
+static int
+of_thermal_get_crit_temp(struct thermal_zone_device *tz, unsigned long *temp)
+{
+	struct __thermal_zone_device *data = tz->devdata;
+	int i;
+
+	for (i = 0; i < data->ntrips; i++)
+		if (data->trips[i].type == THERMAL_TRIP_CRITICAL) {
+			*temp = data->trips[i].temperature;
+			return 0;
+		}
+
+	return -EINVAL;
+}
+
+static const
+struct thermal_zone_device_ops of_thermal_ops = {
+	.get_temp = of_thermal_get_temp,
+	.get_mode = of_thermal_get_mode,
+	.set_mode = of_thermal_set_mode,
+	.get_trip_type = of_thermal_get_trip_type,
+	.get_trip_temp = of_thermal_get_trip_temp,
+	.set_trip_temp = of_thermal_set_trip_temp,
+	.get_trip_hyst = of_thermal_get_trip_hyst,
+	.set_trip_hyst = of_thermal_set_trip_hyst,
+	.get_crit_temp = of_thermal_get_crit_temp,
+};
+
+/**
+ * thermal_zone_of_device_register() - registers a thermal zone based on DT
+ * @device: a valid struct device pointer containing device tree node
+ *          with thermal_zone descriptor.
+ * @data: a private pointer (owned by the caller) that will be passed
+ *        back, when a temperature reading is needed.
+ * @get_temp: a pointer to a function that returns the thermal zone
+ *            temperature.
+ * @add_hwmon:	a boolean to indicate if the thermal to hwmon sysfs interface
+ *		is required. When add_hwmon == true, a hwmon sysfs interface
+ *		will be created. When add_hwmon == false, nothing will be done
+ *
+ * This function will parse the device tree node associated with the
+ * @dev struct and will attempt to build a thermal zone device based
+ * upon the thermal data provided and described by DT.
+ *
+ * The thermal zone temperature is provided by the @get_temp function
+ * pointer. When called, it will have the private pointer @data back.
+ *
+ * Return: On success returns a valid struct thermal_zone_device,
+ * otherwise, it returns a corresponding ERR_PTR(). Caller must
+ * check the return value with help of IS_ERR() helper.
+ */
+struct thermal_zone_device *
+thermal_zone_of_device_register(struct device *dev, int id, bool add_hwmon,
+			void *data, int (*get_temp)(void *, unsigned long *))
+{
+	struct __thermal_zone_device *tz;
+	struct thermal_zone_device_ops *ops;
+	struct of_phandle_args thermal_spec;
+	int ret;
+
+	ret = of_parse_phandle_with_args(dev->of_node,
+					 "monitored-zones",
+					 "#thermal-cells",
+					 id,
+					 &thermal_spec);
+	if (ret) {
+		dev_err(dev, "unable to find desired monitored zone %d\n", id);
+		return ERR_PTR(ret);
+	}
+
+	tz = thermal_of_build_thermal_zone(dev, thermal_spec.np);
+	if (IS_ERR(tz)) {
+		dev_err(dev, "failed to build thermal zone\n");
+		return ERR_CAST(tz);
+	}
+	ops = devm_kzalloc(dev, sizeof(*ops), GFP_KERNEL);
+	if (!ops) {
+		dev_err(dev, "no memory available for thermal ops\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	memcpy(ops, &of_thermal_ops, sizeof(*ops));
+	tz->get_temp = get_temp;
+	tz->devdata = data;
+
+	return thermal_zone_device_register(tz->type, tz->ntrips, tz->mask, tz,
+					    ops, &tz->zone_params,
+					    tz->passive_delay,
+					    tz->polling_delay,
+					    add_hwmon);
+}
+EXPORT_SYMBOL_GPL(thermal_zone_of_device_register);
diff --git a/include/dt-bindings/thermal/thermal.h b/include/dt-bindings/thermal/thermal.h
new file mode 100644
index 0000000..6dd6ccd
--- /dev/null
+++ b/include/dt-bindings/thermal/thermal.h
@@ -0,0 +1,27 @@
+/*
+ * This header provides constants for most thermal bindings.
+ *
+ * Copyright (C) 2013 Texas Instruments
+ *	Eduardo Valentin <eduardo.valentin@ti.com>
+ *
+ * GPLv2 only
+ */
+
+#ifndef _DT_BINDINGS_THERMAL_THERMAL_H
+#define _DT_BINDINGS_THERMAL_THERMAL_H
+
+/*
+ * Here are the thermal trip types. This must
+ * match with enum thermal_trip_type at
+ * include/linux/thermal.h
+ */
+#define THERMAL_TRIP_ACTIVE		0
+#define THERMAL_TRIP_PASSIVE		1
+#define THERMAL_TRIP_HOT		2
+#define THERMAL_TRIP_CRITICAL		3
+
+/* On cooling devices upper and lower limits */
+#define THERMAL_NO_LIMIT		(-1UL)
+
+#endif
+
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 7c2769c..501b2fe 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -234,6 +234,9 @@ struct thermal_genl_event {
 };
 
 /* Function declarations */
+struct thermal_zone_device
+*thermal_zone_of_device_register(struct device *, int id, bool add_hwmon,
+	void *data, int (*get_temp) (void *, unsigned long *));
 struct thermal_zone_device *thermal_zone_device_register(const char *, int, int,
 		void *, const struct thermal_zone_device_ops *,
 		const struct thermal_zone_params *, int, int, bool);
-- 
1.8.2.1.342.gfa7285d

