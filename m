Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaAQH7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 02:59:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:42490 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbaAQH66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 02:58:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,670,1384329600"; 
   d="scan'208";a="466568140"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hongbo.zhang@freescale.com, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCHv5 RESEND 08/10] Thermal: Add Documentation to new APIs
Date: Fri, 17 Jan 2014 18:57:01 +0530
Message-Id: <1389965222-2537-2-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389965222-2537-1-git-send-email-durgadoss.r@intel.com>
References: <1389965222-2537-1-git-send-email-durgadoss.r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Documentation for the new APIs
introduced in this patch set. The documentation
also has a model sysfs structure for reference.

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
---
 Documentation/thermal/sysfs-api2.txt |  240 ++++++++++++++++++++++++++++++++++
 1 file changed, 240 insertions(+)
 create mode 100644 Documentation/thermal/sysfs-api2.txt

diff --git a/Documentation/thermal/sysfs-api2.txt b/Documentation/thermal/sysfs-api2.txt
new file mode 100644
index 0000000..1045dfc
--- /dev/null
+++ b/Documentation/thermal/sysfs-api2.txt
@@ -0,0 +1,240 @@
+Thermal Framework
+-----------------
+
+Written by Durgadoss R <durgadoss.r@intel.com>
+Copyright (c) 2014 Intel Corporation
+
+Created on: 15 January 2014
+
+0. Introduction
+---------------
+The Linux thermal framework provides a set of interfaces for thermal
+sensors and thermal cooling devices (fan, processor...) to register
+with the thermal management solution and to be a part of it.
+
+This document focuses on how to enable new thermal sensors and cooling
+devices to participate in thermal management. This solution is intended
+to be 'light-weight' and platform/architecture independent. Any thermal
+sensor/cooling device should be able to use the infrastructure easily.
+
+The goal of thermal framework is to expose the thermal sensor/zone and
+cooling device attributes in a consistent way. This will help the
+thermal governors to make use of the information to manage platform
+thermals efficiently.
+
+The thermal sensor source file can be generic (can be any sensor driver,
+in any subsystem). This driver will use the sensor APIs and register with
+thermal framework to participate in platform Thermal management. This
+does not (and should not) know about which zone it belongs to, or any
+other information about platform thermals. A sensor driver is a standalone
+piece of code, which can optionally register with thermal framework.
+
+However, for any platform, there should be a platformX_thermal.c file,
+which will know about the platform thermal characteristics (e.g how many
+sensors, zones, cooling devices, etc.. And how they are related to each other
+i.e the mapping information). Only in this file, the zone level APIs should
+be used, in which case the file will have all information required to attach
+various sensors to a particular zone.
+
+This way, we can have one platform level thermal file, which can support
+multiple platforms (may be)using the same set of sensors (but)binded in
+a different way. This file can get the platform thermal information
+through Firmware, ACPI tables, device tree etc.
+
+Unfortunately, today we don't have many drivers that can be clearly
+differentiated as 'sensor_file.c' and 'platform_thermal_file.c'.
+But very soon we will need/have. We see a lot of chip drivers,
+starting to use thermal framework; we should keep it really
+light-weight for them to do so but at the same time provide all
+the necessary features to participate in platform thermal management.
+
+An Example: drivers/hwmon/emc1403.c - a generic thermal chip driver
+In one platform this sensor can belong to 'ZoneA' and in another the
+same can belong to 'ZoneB'. But, emc1403.c does not really care about
+where does it belong. It just reports temperature.
+
+1. Terminology
+--------------
+This section describes the terminology used in the rest of this
+document as well as the thermal framework code.
+
+thermal_sensor: Hardware that can report temperature of a particular
+		spot in the platform, where it is placed. The temperature
+		reported by the sensor is the 'real' temperature reported
+		by the hardware.
+thermal_zone:	A virtual area on the device, that gets heated up. It may
+		have one or more thermal sensors attached to it.
+cooling_device:	Any component that can help in reducing the temperature of
+		a 'hot spot' either by reducing its performance (passive
+		cooling) or by other means(Active cooling E.g. Fan)
+
+trip_points:	Various temperature levels for each sensor. As of now, we
+		have four levels namely active, passive, hot and critical.
+		Hot and critical trip point support only one value whereas
+		active and passive can have any number of values. These
+		temperature values can come from platform data, and are
+		exposed through sysfs in a consistent manner. Stand-alone
+		thermal sensor drivers are not expected to know these values.
+		These values are RO.
+thresholds:	These are programmable temperature limits, on reaching which
+		the thermal sensor generates an interrupt. The framework is
+		notified about this interrupt to take appropriate action.
+		There can be as many number of thresholds as that of the
+		hardware supports. These values are RW.
+
+thermal_map:	This provides the mapping (aka binding) information between
+		various sensors and cooling devices in a particular zone.
+		Typically, this also comes from platform data; Stand-alone
+		sensor drivers or cooling device drivers are not expected
+		to know these mapping information.
+
+2. Thermal framework APIs
+-------------------------
+2.1: For Thermal Sensors
+2.1.1 thermal_sensor_register:
+	This function creates a new sensor directory under /sys/class/thermal/
+	as sensor[0-*]. This API is expected to be called by thermal sensor
+	drivers. These drivers may or may not be in thermal subsystem. This
+	function returns a thermal_sensor structure on success and appropriate
+	error on failure.
+
+	name: Name of the sensor
+	count: Number of programmable thresholds associated with this sensor
+	devdata: Device private data
+	ops: Thermal sensor callbacks
+		.get_temp: obtain the current temperature of the sensor
+		.get_trend: obtain the trend of the sensor
+		.get_threshold: get a particular threshold temperature
+		.set_threshold: set a particular threshold temperature
+		.get_hyst: get hysteresis value associated with a threshold
+		.set_hyst: set hysteresis value associated with a threshold
+
+2.1.2 thermal_sensor_unregister:
+	This function deletes the sensor directory under /sys/class/thermal/
+	for the given sensor. Thermal sensor drivers may call this API
+	during the driver's 'exit' routine.
+
+	ts: Thermal sensor that has to be unregistered
+
+2.2: For Cooling Devices
+2.2.1 thermal_cdev_register:
+	This function adds a new thermal cooling device (fan/processor/...)
+	to /sys/class/thermal/ folder as cdev[0-*]. This function
+	is expected to be called by cooling device drivers that may be
+	present in other subsystems also.
+
+	name: the cooling device name
+	devdata: device private data
+	ops: thermal cooling devices callbacks
+	.get_max_state: get the Maximum throttle state of the cooling device
+	.get_cur_state: get the Current throttle state of the cooling device
+	.set_cur_state: set the Current throttle state of the cooling device
+
+2.2.2 thermal_cdev_unregister:
+	This function deletes the given cdev entry form /sys/class/thermal;
+	and also cleans all the symlinks referred from various zones.
+
+	cdev: Cooling device to be unregistered
+
+2.3: For Thermal Zones
+2.3.1 thermal_create_thermal_zone:
+	This function adds a new 'zone' under /sys/class/thermal/
+	directory as zone[0-*]. This zone has at least one thermal
+	sensor and at most MAX_SENSORS_PER_ZONE number of sensors
+	attached to it. Similarly, this zone has at least one cdev
+	and at most MAX_CDEVS_PER_ZONE number of cdevs attached to it.
+	As of now, MAX_*_PER_ZONE values are hard-coded to 5. We can
+	make them configurable, through Kconfig option(during 'menuconfig').
+
+	name: Name of the thermal zone
+	devdata: Device private data
+
+2.3.2 thermal_add_sensor_to_zone
+	This function adds a 'sensorX' entry under /sys/class/thermal/
+	zoneY/ directory. This 'sensorX' is a symlink to the actual
+	sensor entry under /sys/class/thermal/. Correspondingly, the
+	method remove_sensor_from_zone deletes the symlink.
+
+	tz: thermal zone structure
+	ts: thermal sensor structure
+
+2.3.3 thermal_add_cdev_to_zone
+	This function adds a 'cdevX' entry under /sys/class/thermal/
+	zoneY/ directory. This 'cdevX' is a symlink to the actual
+	cdev entry under /sys/class/thermal/. Correspondingly, the
+	method remove_cdev_from_zone deletes the symlink.
+
+	tz: thermal zone structure
+	cdev: thermal cooling device structure
+
+2.4 For Thermal Trip
+2.4.1 thermal_add_sensor_trip_info
+	This function adds trip point information for the given sensor,
+	(under a given zone) under /sys/class/thermal/zoneX/.
+	This API creates sysfs attributes namely:
+	sensorX_trip_activeY, sensorX_trip_passiveY, sensorX_trip_hot,
+	sensorX_trip_critical. Each of these hold one trip point temperature
+	(in mC) values, as provided from platform data. As of now, we
+	support many Active and Passive trip points but only one hot
+	one critical trip point.
+
+	tz: thermal zone structure
+	ts: thermal sensor to which the trip points are attached
+	trip: trip point structure. Usually obtained from platform data
+
+2.5 For Thermal Map
+2.5.1 thermal_add_map_entry
+	This function adds a 'map[0-*]' sysfs attribute under
+	/sys/class/thermal/zoneX/mapY_*. Each map attribute helps
+	to describe the binding relationship between a sensor and
+	a cdev in the given zone. The map structure is typically
+	obtained as platform data. For example, through ACPI tables,
+	SFI tables, Device tree etc. The trip mask is a hex value;
+	if 'n' th bit (from LSB) is set, then for trip point 'n' this
+	cdev is throttled with the given weight[n].
+
+	tz: thermal zone to which a 'map' is being added
+	map: thermal_map structure
+
+3. Sysfs attributes structure
+-----------------------------
+Thermal sysfs attributes will be represented under /sys/class/thermal.
+
+3.1: For Thermal Sensors
+	/sys/class/thermal/sensor[0-*]:
+		|---type:		Name of the thermal sensor
+		|---temp_input:		Current temperature in mC
+		|---threshold[0-*]:	Threshold temperature in mC
+		|---threshold[0-*]_hyst:Optional hysteresis value in mC
+
+3.2: For Thermal Cooling Devices
+	/sys/class/thermal/cdev[0-*]:
+		|---type:		Type of the cooling device
+		|---max_state:		Maximum throttle state of the cdev
+		|---cur_state:		Current throttle state of the cdev
+
+3.3: For Thermal Zones
+	/sys/class/thermal/zone[0-*]:
+		|---zone_name:			Name of the thermal zone
+		|---sensorX:			Symlink to ../sensorX
+		|---cdevY:			Symlink to ../cdevY
+		|---sensorX_trip_activeM:	Active trip point for sensorX
+		|---sensorX_trip_passiveN:	Passive trip point for sensorX
+		|---sensorX_trip_hot:		Hot trip point for sensorX
+		|---sensorX_trip_critical:	Critical trip point for sensorX
+		|---mapX_sensor_name:		Sensor Name
+		|---mapX_cdev_name:		Cooling device Name
+		|---mapX_trip_type:		Trip point type
+		|---mapX_trip_mask:		Trip point mask
+		|---mapX_weightY:		Weights (used by governors)
+
+3.5: For Thermal Map
+	Each attribute represents the mapping/binding information between
+	a sensor and a cdev, together with a trip type.
+	/sys/class/thermal/zoneX/:
+		|---mapY_trip_type:		active/passive
+		|---mapY_sensor_name:		cpu
+		|---mapY_cdev_name:		proc
+		|---mapY_trip_mask:		0x03
+		|---mapY_weight0:		50
+		|---mapY_weight1:		30
-- 
1.7.9.5

