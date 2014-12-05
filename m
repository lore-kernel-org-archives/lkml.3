Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaLETFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:05:32 -0500
Received: from service87.mimecast.com ([91.220.42.44]:38083 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaLETF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:05:28 -0500
From: "Javi Merino" <javi.merino@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: punit.agrawal@arm.com, broonie@kernel.org,
        Javi Merino <javi.merino@arm.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [RFC PATCH v6 7/9] thermal: introduce the Power Allocator governor
Date: Fri,  5 Dec 2014 19:04:18 +0000
Message-Id: <1417806260-9264-8-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
X-OriginalArrivalTime: 05 Dec 2014 19:05:24.0048 (UTC) FILETIME=[6C4BC500:01D010BE]
X-MC-Unique: 114120519052602301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id sB5J5id5013845

The power allocator governor is a thermal governor that controls system
and device power allocation to control temperature.  Conceptually, the
implementation divides the sustainable power of a thermal zone among
all the heat sources in that zone.

This governor relies on "power actors", entities that represent heat
sources.  They can report current and maximum power consumption and
can set a given maximum power consumption, usually via a cooling
device.

The governor uses a Proportional Integral Derivative (PID) controller
driven by the temperature of the thermal zone.  The output of the
controller is a power budget that is then allocated to each power
actor that can have bearing on the temperature we are trying to
control.  It decides how much power to give each cooling device based
on the performance they are requesting.  The PID controller ensures
that the total power budget does not exceed the control temperature.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Signed-off-by: Javi Merino <javi.merino@arm.com>
---
 Documentation/thermal/power_allocator.txt | 196 ++++++++++++
 drivers/thermal/Kconfig                   |  15 +
 drivers/thermal/Makefile                  |   1 +
 drivers/thermal/power_allocator.c         | 511 ++++++++++++++++++++++++++++++
 drivers/thermal/thermal_core.c            |   7 +-
 drivers/thermal/thermal_core.h            |   8 +
 include/linux/thermal.h                   |  40 ++-
 7 files changed, 774 insertions(+), 4 deletions(-)
 create mode 100644 drivers/thermal/power_allocator.c

diff --git a/Documentation/thermal/power_allocator.txt b/Documentation/thermal/power_allocator.txt
index d3bb79050c27..23b684afdc75 100644
--- a/Documentation/thermal/power_allocator.txt
+++ b/Documentation/thermal/power_allocator.txt
@@ -1,3 +1,172 @@
+Power allocator governor tunables
+=================================
+
+Trip points
+-----------
+
+The governor requires the following two passive trip points:
+
+1.  "switch on" trip point: temperature above which the governor
+    control loop starts operating.
+2.  "desired temperature" trip point: it should be higher than the
+    "switch on" trip point. It is the target temperature the governor
+    is controlling for.
+
+PID Controller
+--------------
+
+The power allocator governor implements a
+Proportional-Integral-Derivative controller (PID controller) with
+temperature as the control input and power as the controlled output:
+
+    P_max = k_p * e + k_i * err_integral + k_d * diff_err + sustainable_power
+
+where
+    e = desired_temperature - current_temperature
+    err_integral is the sum of previous errors
+    diff_err = e - previous_error
+
+It is similar to the one depicted below:
+
+                                      k_d
+                                       |
+current_temp                           |
+     |                                 v
+     |                +----------+   +---+
+     |         +----->| diff_err |-->| X |------+
+     |         |      +----------+   +---+      |
+     |         |                                |      tdp        actor
+     |         |                      k_i       |       |    get_actual_power()
+     |         |                       |        |       |        |     |
+     |         |                       |        |       |        |     | ...
+     v         |                       v        v       v        v     v
+   +---+       |      +-------+      +---+    +---+   +---+   +----------+
+   | S |-------+----->| sum e |----->| X |--->| S |-->| S |-->|power     |
+   +---+       |      +-------+      +---+    +---+   +---+   |allocation|
+     ^         |                                ^             +----------+
+     |         |                                |                |     |
+     |         |        +---+                   |                |     |
+     |         +------->| X |-------------------+                v     v
+     |                  +---+                               granted performance
+desired_temperature       ^
+                          |
+                          |
+                      k_po/k_pu
+
+Sustainable power
+-----------------
+
+An estimate of the sustainable dissipatable power (in mW) should be
+provided while registering the thermal zone.  This estimates the
+sustained power that can be dissipated at the desired control
+temperature.  This is the maximum sustained power for allocation at
+the desired maximum temperature.  The actual sustained power can vary
+for a number of reasons.  The closed loop controller will take care of
+variations such as environmental conditions, and some factors related
+to the speed-grade of the silicon.  `sustainable_power` is therefore
+simply an estimate, and may be tuned to affect the aggressiveness of
+the thermal ramp.  For reference, this is 2000mW - 4500mW depending on
+screen size (4" phone - 10" tablet).
+
+If you are using device tree, do add it as a property of the
+thermal-zone.  For example:
+
+	thermal-zones {
+		soc_thermal {
+			polling-delay = <1000>;
+			polling-delay-passive = <100>;
+			sustainable-power = <2500>;
+			...
+
+If you use platform code to register your thermal zone instead, pass a
+`thermal_zone_params` that has a `sustainable_power`.  If you weren't
+passing any `thermal_zone_params`, then something like this will do:
+
+	static const struct thermal_zone_params tz_params = {
+		.sustainable_power = 3500,
+	};
+
+and then pass `tz_params` as the 5th parameter to
+`thermal_zone_device_register()`
+
+k_po and k_pu
+-------------
+
+The implementation of the PID controller in the power allocator
+thermal governor allows the configuration of two proportional term
+constants: `k_po` and `k_pu`.  `k_po` is the proportional term
+constant during temperature overshoot periods (current temperature is
+above "desired temperature" trip point).  Conversely, `k_pu` is the
+proportional term constant during temperature undershoot periods
+(current temperature below "desired temperature" trip point).
+
+These controls are intended as the primary mechanism for configuring
+the permitted thermal "ramp" of the system.  For instance, a lower
+`k_pu` value will provide a slower ramp, at the cost of capping
+available capacity at a low temperature.  On the other hand, a high
+value of `k_pu` will result in the governor granting very high power
+whilst temperature is low, and may lead to temperature overshooting.
+
+The default value for `k_pu` is:
+
+    2 * sustainable_power / (desired_temperature - switch_on_temp)
+
+This means that at `switch_on_temp` the output of the controller's
+proportional term will be 2 * `sustainable_power`.  The default value
+for `k_po` is:
+
+    sustainable_power / (desired_temperature - switch_on_temp)
+
+Focusing on the proportional and feed forward values of the PID
+controller equation we have:
+
+    P_max = k_p * e + sustainable_power
+
+The proportional term is proportional to the difference between the
+desired temperature and the current one.  When the current temperature
+is the desired one, then the proportional component is zero and
+`P_max` = `sustainable_power`.  That is, the system should operate in
+thermal equilibrium under constant load.  `sustainable_power` is only
+an estimate, which is the reason for closed-loop control such as this.
+
+Expanding `k_pu` we get:
+    P_max = 2 * sustainable_power * (T_set - T) / (T_set - T_on) +
+        sustainable_power
+
+where
+    T_set is the desired temperature
+    T is the current temperature
+    T_on is the switch on temperature
+
+When the current temperature is the switch_on temperature, the above
+formula becomes:
+
+    P_max = 2 * sustainable_power * (T_set - T_on) / (T_set - T_on) +
+        sustainable_power = 2 * sustainable_power + sustainable_power = 
+        3 * sustainable_power
+
+Therefore, the proportional term alone linearly decreases power from
+3 * `sustainable_power` to `sustainable_power` as the temperature
+rises from the switch on temperature to the desired temperature.
+
+k_i and integral_cutoff
+-----------------------
+
+`k_i` configures the PID loop's integral term constant.  This term
+allows the PID controller to compensate for long term drift and for
+the quantized nature of the output control: cooling devices can't set
+the exact power that the governor requests.  When the temperature
+error is below `integral_cutoff`, errors are accumulated in the
+integral term.  This term is then multiplied by `k_i` and the result
+added to the output of the controller.  Typically `k_i` is set low (1
+or 2) and `integral_cutoff` is 0.
+
+k_d
+---
+
+`k_d` configures the PID loop's derivative term constant.  It's
+recommended to leave it as the default: 0.
+
 Cooling device power API
 ========================
 
@@ -25,3 +194,30 @@ milliwatts.
 
 Calculate a cooling device state that would make the device consume at
 most @power mW.
+
+Cooling device weights
+----------------------
+
+Weights are a mechanism to bias the allocation between cooling
+devices.  They express the relative power efficiency of different
+cooling devices.  Higher weight can be used to express higher power
+efficiency.  Weighting is relative such that if each cooling device
+has a weight of one they are considered equal.  This is particularly
+useful in heterogeneous systems where two cooling devices may perform
+the same kind of compute, but with different efficiency.  For example,
+a system with two different types of processors.
+
+Weights shall be passed as part of the thermal zone's
+`thermal_bind_parameters`.
+
+Limitations of the power allocator governor
+===========================================
+
+The power allocator governor's PID controller works best if there is a
+periodic tick.  If you have a driver that calls
+`thermal_zone_device_update()` (or anything that ends up calling the
+governor's `throttle()` function) repetitively, the governor response
+won't be very good.  Note that this is not particular to this
+governor, step-wise will also misbehave if you call its throttle()
+faster than the normal thermal framework tick (due to interrupts for
+example) as it will overreact.
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index f554d25b4399..4496fa5e4a33 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -71,6 +71,14 @@ config THERMAL_DEFAULT_GOV_USER_SPACE
 	  Select this if you want to let the user space manage the
 	  platform thermals.
 
+config THERMAL_DEFAULT_GOV_POWER_ALLOCATOR
+	bool "power_allocator"
+	select THERMAL_GOV_POWER_ALLOCATOR
+	help
+	  Select this if you want to control temperature based on
+	  system and device power allocation. This governor relies on
+	  power actors to operate.
+
 endchoice
 
 config THERMAL_GOV_FAIR_SHARE
@@ -99,6 +107,13 @@ config THERMAL_GOV_USER_SPACE
 	help
 	  Enable this to let the user space manage the platform thermals.
 
+config THERMAL_GOV_POWER_ALLOCATOR
+	bool "Power allocator thermal governor"
+	select THERMAL_POWER_ACTOR
+	help
+	  Enable this to manage platform thermals by dynamically
+	  allocating and limiting power to devices.
+
 config CPU_THERMAL
 	bool "generic cpu cooling support"
 	depends on CPU_FREQ
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index 39c4fe87da2f..c33904848c45 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -14,6 +14,7 @@ thermal_sys-$(CONFIG_THERMAL_GOV_FAIR_SHARE)	+= fair_share.o
 thermal_sys-$(CONFIG_THERMAL_GOV_BANG_BANG)	+= gov_bang_bang.o
 thermal_sys-$(CONFIG_THERMAL_GOV_STEP_WISE)	+= step_wise.o
 thermal_sys-$(CONFIG_THERMAL_GOV_USER_SPACE)	+= user_space.o
+thermal_sys-$(CONFIG_THERMAL_GOV_POWER_ALLOCATOR)	+= power_allocator.o
 
 # cpufreq cooling
 thermal_sys-$(CONFIG_CPU_THERMAL)	+= cpu_cooling.o
diff --git a/drivers/thermal/power_allocator.c b/drivers/thermal/power_allocator.c
new file mode 100644
index 000000000000..09e98991efbb
--- /dev/null
+++ b/drivers/thermal/power_allocator.c
@@ -0,0 +1,511 @@
+/*
+ * A power allocator to manage temperature
+ *
+ * Copyright (C) 2014 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt) "Power allocator: " fmt
+
+#include <linux/rculist.h>
+#include <linux/slab.h>
+#include <linux/thermal.h>
+
+#include "thermal_core.h"
+
+#define FRAC_BITS 10
+#define int_to_frac(x) ((x) << FRAC_BITS)
+#define frac_to_int(x) ((x) >> FRAC_BITS)
+
+/**
+ * mul_frac() - multiply two fixed-point numbers
+ * @x:	first multiplicand
+ * @y:	second multiplicand
+ *
+ * Return: the result of multiplying two fixed-point numbers.  The
+ * result is also a fixed-point number.
+ */
+static inline s64 mul_frac(s64 x, s64 y)
+{
+	return (x * y) >> FRAC_BITS;
+}
+
+enum power_allocator_trip_levels {
+	TRIP_SWITCH_ON = 0,	/* Switch on PID controller */
+	TRIP_MAX_DESIRED_TEMPERATURE, /* Temperature we are controlling for */
+
+	THERMAL_TRIP_NUM,
+};
+
+/**
+ * struct power_allocator_params - parameters for the power allocator governor
+ * @k_po:	Proportional parameter of the PID controller when overshooting
+ *		(i.e., when temperature is below the target)
+ * @k_pu:	Proportional parameter of the PID controller when undershooting
+ * @k_i:	Integral parameter of the PID controller
+ * @k_d:	Derivative parameter of the PID controller
+ * @integral_cutoff:	threshold below which the error is no longer accumulated
+			in the PID controller
+ * @err_integral:	accumulated error in the PID controller.
+ * @prev_err:	error in the previous iteration of the PID controller.
+ *		Used to calculate the derivative term.
+ */
+struct power_allocator_params {
+	s32 k_po;
+	s32 k_pu;
+	s32 k_i;
+	s32 k_d;
+	s32 integral_cutoff;
+	s64 err_integral;
+	s32 prev_err;
+};
+
+/**
+ * get_actor_weight() - get the weight for the power actor
+ * @tz:		thermal zone we are operating in
+ * @actor:	the power actor
+ *
+ * Returns: The weight inside the thermal binding parameters of the
+ * thermal zone.  If it could not be found, a default weight of 1 is
+ * assumed.  Weights are expressed as a FRAC_BITS (currently 10-bit)
+ * fixed point integer.
+ */
+static int get_actor_weight(struct thermal_zone_device *tz,
+			struct thermal_cooling_device *cdev)
+{
+	int i;
+
+	for (i = 0; i < tz->tzp->num_tbps; i++)
+		if (tz->tzp->tbp[i].cdev == cdev)
+			return tz->tzp->tbp[i].weight;
+
+	return int_to_frac(1);
+}
+
+/**
+ * pid_controller() - PID controller
+ * @tz:	thermal zone we are operating in
+ * @current_temp:	the current temperature in millicelsius
+ * @control_temp:	the target temperature in millicelsius
+ * @max_allocatable_power:	maximum allocatable power for this thermal zone
+ *
+ * This PID controller increases the available power budget so that the
+ * temperature of the thermal zone gets as close as possible to
+ * @control_temp and limits the power if it exceeds it.  k_po is the
+ * proportional term when we are overshooting, k_pu is the
+ * proportional term when we are undershooting.  integral_cutoff is a
+ * threshold below which we stop accumulating the error.  The
+ * accumulated error is only valid if the requested power will make
+ * the system warmer.  If the system is mostly idle, there's no point
+ * in accumulating positive error.
+ *
+ * Return: The power budget for the next period.
+ */
+static u32 pid_controller(struct thermal_zone_device *tz,
+			unsigned long current_temp, unsigned long control_temp,
+			u32 max_allocatable_power)
+{
+	s64 p, i, d, power_range;
+	s32 err, max_power_frac;
+	struct power_allocator_params *params = tz->governor_data;
+
+	max_power_frac = int_to_frac(max_allocatable_power);
+
+	err = ((s32)control_temp - (s32)current_temp);
+	err = int_to_frac(err);
+
+	/* Calculate the proportional term */
+	p = mul_frac(err < 0 ? params->k_po : params->k_pu, err);
+
+	/*
+	 * Calculate the integral term
+	 *
+	 * if the error is less than cut off allow integration (but
+	 * the integral is limited to max power)
+	 */
+	i = mul_frac(params->k_i, params->err_integral);
+
+	if (err < int_to_frac(params->integral_cutoff)) {
+		s64 i_next = i + mul_frac(params->k_i, err);
+
+		if (abs64(i_next) < max_power_frac) {
+			i = i_next;
+			params->err_integral += err;
+		}
+	}
+
+	/*
+	 * Calculate the derivative term
+	 *
+	 * We do err - prev_err, so with a positive k_d, a decreasing
+	 * error (i.e. driving closer to the line) results in less
+	 * power being applied, slowing down the controller)
+	 */
+	d = mul_frac(params->k_d, err - params->prev_err);
+	params->prev_err = err;
+
+	power_range = p + i + d;
+
+	/* feed-forward the known sustainable dissipatable power */
+	power_range = tz->tzp->sustainable_power + frac_to_int(power_range);
+
+	return clamp(power_range, (s64)0, (s64)max_allocatable_power);
+}
+
+/**
+ * divvy_up_power() - divvy the allocated power between the actors
+ * @req_power:	each actor's requested power
+ * @max_power:	each actor's maximum available power
+ * @num_actors:	size of the @req_power, @max_power and @granted_power's array
+ * @total_req_power: sum of @req_power
+ * @power_range:	total allocated power
+ * @granted_power:	output array: each actor's granted power
+ *
+ * This function divides the total allocated power (@power_range)
+ * fairly between the actors.  It first tries to give each actor a
+ * share of the @power_range according to how much power it requested
+ * compared to the rest of the actors.  For example, if only one actor
+ * requests power, then it receives all the @power_range.  If
+ * three actors each requests 1mW, each receives a third of the
+ * @power_range.
+ *
+ * If any actor received more than their maximum power, then that
+ * surplus is re-divvied among the actors based on how far they are
+ * from their respective maximums.
+ *
+ * Granted power for each actor is written to @granted_power, which
+ * should've been allocated by the calling function.
+ */
+static void divvy_up_power(u32 *req_power, u32 *max_power, int num_actors,
+			u32 total_req_power, u32 power_range,
+			u32 *granted_power)
+{
+	u32 extra_power, capped_extra_power, extra_actor_power[num_actors];
+	int i;
+
+	if (!total_req_power) {
+		/*
+		 * Nobody requested anything, so just give everybody
+		 * the maximum power
+		 */
+		for (i = 0; i < num_actors; i++)
+			granted_power[i] = max_power[i];
+
+		return;
+	}
+
+	capped_extra_power = 0;
+	extra_power = 0;
+	for (i = 0; i < num_actors; i++) {
+		u64 req_range = req_power[i] * power_range;
+
+		granted_power[i] = div_u64(req_range, total_req_power);
+
+		if (granted_power[i] > max_power[i]) {
+			extra_power += granted_power[i] - max_power[i];
+			granted_power[i] = max_power[i];
+		}
+
+		extra_actor_power[i] = max_power[i] - granted_power[i];
+		capped_extra_power += extra_actor_power[i];
+	}
+
+	if (!extra_power)
+		return;
+
+	/*
+	 * Re-divvy the reclaimed extra among actors based on
+	 * how far they are from the max
+	 */
+	extra_power = min(extra_power, capped_extra_power);
+	if (capped_extra_power > 0)
+		for (i = 0; i < num_actors; i++)
+			granted_power[i] += (extra_actor_power[i] *
+					extra_power) / capped_extra_power;
+}
+
+static int allocate_power(struct thermal_zone_device *tz,
+			unsigned long current_temp, unsigned long control_temp)
+{
+	struct thermal_instance *instance;
+	u32 *req_power, *max_power, *granted_power;
+	u32 total_req_power, max_allocatable_power;
+	u32 power_range;
+	int i, num_actors, ret = 0;
+
+	mutex_lock(&tz->lock);
+
+	num_actors = 0;
+	list_for_each_entry(instance, &tz->thermal_instances, tz_node)
+		if ((instance->trip == TRIP_MAX_DESIRED_TEMPERATURE) &&
+			cdev_is_power_actor(instance->cdev))
+			num_actors++;
+
+	req_power = devm_kcalloc(&tz->device, num_actors, sizeof(*req_power),
+				GFP_KERNEL);
+	if (!req_power) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	max_power = devm_kcalloc(&tz->device, num_actors, sizeof(*max_power),
+				GFP_KERNEL);
+	if (!max_power) {
+		ret = -ENOMEM;
+		goto free_req_power;
+	}
+
+	granted_power = devm_kcalloc(&tz->device, num_actors,
+				sizeof(*granted_power), GFP_KERNEL);
+	if (!granted_power) {
+		ret = -ENOMEM;
+		goto free_max_power;
+	}
+
+	i = 0;
+	total_req_power = 0;
+	max_allocatable_power = 0;
+
+	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
+		int weight;
+		struct thermal_cooling_device *cdev = instance->cdev;
+
+		if (instance->trip != TRIP_MAX_DESIRED_TEMPERATURE)
+			continue;
+
+		if (!cdev_is_power_actor(cdev))
+			continue;
+
+		req_power[i] = cdev->ops->get_actual_power(cdev);
+		weight = get_actor_weight(tz, cdev);
+		req_power[i] = frac_to_int(weight * req_power[i]);
+		total_req_power += req_power[i];
+
+		max_power[i] = power_actor_get_max_power(cdev);
+		max_allocatable_power += max_power[i];
+
+		i++;
+	}
+
+	power_range = pid_controller(tz, current_temp, control_temp,
+				max_allocatable_power);
+
+	divvy_up_power(req_power, max_power, num_actors, total_req_power,
+		power_range, granted_power);
+
+	i = 0;
+	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
+		if (instance->trip != TRIP_MAX_DESIRED_TEMPERATURE)
+			continue;
+
+		if (!cdev_is_power_actor(instance->cdev))
+			continue;
+
+		power_actor_set_power(instance->cdev, granted_power[i]);
+
+		i++;
+	}
+
+	devm_kfree(&tz->device, granted_power);
+free_max_power:
+	devm_kfree(&tz->device, max_power);
+free_req_power:
+	devm_kfree(&tz->device, req_power);
+unlock:
+	mutex_unlock(&tz->lock);
+
+	return ret;
+}
+
+static int check_trips(struct thermal_zone_device *tz)
+{
+	int ret;
+	enum thermal_trip_type type;
+
+	if (tz->trips < THERMAL_TRIP_NUM)
+		return -EINVAL;
+
+	ret = tz->ops->get_trip_type(tz, TRIP_SWITCH_ON, &type);
+	if (ret)
+		return ret;
+
+	if (type != THERMAL_TRIP_PASSIVE)
+		return -EINVAL;
+
+	ret = tz->ops->get_trip_type(tz, TRIP_MAX_DESIRED_TEMPERATURE, &type);
+	if (ret)
+		return ret;
+
+	if (type != THERMAL_TRIP_PASSIVE)
+		return -EINVAL;
+
+	return ret;
+}
+
+static void reset_pid_controller(struct power_allocator_params *params)
+{
+	params->err_integral = 0;
+	params->prev_err = 0;
+}
+
+static void allow_maximum_power(struct thermal_zone_device *tz)
+{
+	struct thermal_instance *instance;
+
+	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
+		u32 max_power;
+
+		if ((instance->trip != TRIP_MAX_DESIRED_TEMPERATURE) ||
+			(!cdev_is_power_actor(instance->cdev)))
+			continue;
+
+		max_power = power_actor_get_max_power(instance->cdev);
+		power_actor_set_power(instance->cdev, max_power);
+	}
+}
+
+/**
+ * power_allocator_bind() - bind the power_allocator governor to a thermal zone
+ * @tz:	thermal zone to bind it to
+ *
+ * Check that the thermal zone is valid for this governor, that is, it
+ * has two thermal trips.  If so, initialize the PID controller
+ * parameters and bind it to the thermal zone.
+ *
+ * Return: 0 on success, -EINVAL if the trips were invalid or -ENOMEM
+ * if we ran out of memory.
+ */
+static int power_allocator_bind(struct thermal_zone_device *tz)
+{
+	int ret;
+	struct power_allocator_params *params;
+	unsigned long switch_on_temp, control_temp;
+	u32 temperature_threshold;
+
+	ret = check_trips(tz);
+	if (ret) {
+		dev_err(&tz->device,
+			"thermal zone %s has the wrong number of trips for this governor\n",
+			tz->type);
+		return ret;
+	}
+
+	if (!tz->tzp || !tz->tzp->sustainable_power) {
+		dev_err(&tz->device,
+			"power_allocator: missing sustainable_power\n");
+		return -EINVAL;
+	}
+
+	params = devm_kzalloc(&tz->device, sizeof(*params), GFP_KERNEL);
+	if (!params)
+		return -ENOMEM;
+
+	ret = tz->ops->get_trip_temp(tz, TRIP_SWITCH_ON, &switch_on_temp);
+	if (ret)
+		goto free;
+
+	ret = tz->ops->get_trip_temp(tz, TRIP_MAX_DESIRED_TEMPERATURE,
+				&control_temp);
+	if (ret)
+		goto free;
+
+	temperature_threshold = control_temp - switch_on_temp;
+
+	params->k_po = tz->tzp->k_po ?:
+		int_to_frac(tz->tzp->sustainable_power) / temperature_threshold;
+	params->k_pu = tz->tzp->k_pu ?:
+		int_to_frac(2 * tz->tzp->sustainable_power) /
+		temperature_threshold;
+	params->k_i = tz->tzp->k_i ?: int_to_frac(10) / 1000;
+	params->k_d = tz->tzp->k_d ?: int_to_frac(0);
+	params->integral_cutoff = tz->tzp->integral_cutoff ?: 0;
+
+	reset_pid_controller(params);
+
+	tz->governor_data = params;
+
+	return 0;
+
+free:
+	devm_kfree(&tz->device, params);
+	return ret;
+}
+
+static void power_allocator_unbind(struct thermal_zone_device *tz)
+{
+	dev_dbg(&tz->device, "Unbinding from thermal zone %d\n", tz->id);
+	devm_kfree(&tz->device, tz->governor_data);
+	tz->governor_data = NULL;
+}
+
+static int power_allocator_throttle(struct thermal_zone_device *tz, int trip)
+{
+	int ret;
+	unsigned long switch_on_temp, control_temp, current_temp;
+	struct power_allocator_params *params = tz->governor_data;
+
+	/*
+	 * We get called for every trip point but we only need to do
+	 * our calculations once
+	 */
+	if (trip != TRIP_MAX_DESIRED_TEMPERATURE)
+		return 0;
+
+	ret = thermal_zone_get_temp(tz, &current_temp);
+	if (ret) {
+		dev_warn(&tz->device, "Failed to get temperature: %d\n", ret);
+		return ret;
+	}
+
+	ret = tz->ops->get_trip_temp(tz, TRIP_SWITCH_ON, &switch_on_temp);
+	if (ret) {
+		dev_warn(&tz->device,
+			"Failed to get switch on temperature: %d\n", ret);
+		return ret;
+	}
+
+	if (current_temp < switch_on_temp) {
+		tz->passive = 0;
+		reset_pid_controller(params);
+		allow_maximum_power(tz);
+		return 0;
+	}
+
+	tz->passive = 1;
+
+	ret = tz->ops->get_trip_temp(tz, TRIP_MAX_DESIRED_TEMPERATURE,
+				&control_temp);
+	if (ret) {
+		dev_warn(&tz->device,
+			"Failed to get the maximum desired temperature: %d\n",
+			ret);
+		return ret;
+	}
+
+	return allocate_power(tz, current_temp, control_temp);
+}
+
+static struct thermal_governor thermal_gov_power_allocator = {
+	.name		= "power_allocator",
+	.bind_to_tz	= power_allocator_bind,
+	.unbind_from_tz	= power_allocator_unbind,
+	.throttle	= power_allocator_throttle,
+};
+
+int thermal_gov_power_allocator_register(void)
+{
+	return thermal_register_governor(&thermal_gov_power_allocator);
+}
+
+void thermal_gov_power_allocator_unregister(void)
+{
+	thermal_unregister_governor(&thermal_gov_power_allocator);
+}
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index c490f262ea7f..4921e084c20b 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1905,7 +1905,11 @@ static int __init thermal_register_governors(void)
 	if (result)
 		return result;
 
-	return thermal_gov_user_space_register();
+	result = thermal_gov_user_space_register();
+	if (result)
+		return result;
+
+	return thermal_gov_power_allocator_register();
 }
 
 static void thermal_unregister_governors(void)
@@ -1914,6 +1918,7 @@ static void thermal_unregister_governors(void)
 	thermal_gov_fair_share_unregister();
 	thermal_gov_bang_bang_unregister();
 	thermal_gov_user_space_unregister();
+	thermal_gov_power_allocator_unregister();
 }
 
 static int __init thermal_init(void)
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index d15d243de27a..b907be823527 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -85,6 +85,14 @@ static inline int thermal_gov_user_space_register(void) { return 0; }
 static inline void thermal_gov_user_space_unregister(void) {}
 #endif /* CONFIG_THERMAL_GOV_USER_SPACE */
 
+#ifdef CONFIG_THERMAL_GOV_POWER_ALLOCATOR
+int thermal_gov_power_allocator_register(void);
+void thermal_gov_power_allocator_unregister(void);
+#else
+static inline int thermal_gov_power_allocator_register(void) { return 0; }
+static inline void thermal_gov_power_allocator_unregister(void) {}
+#endif /* CONFIG_THERMAL_GOV_POWER_ALLOCATOR */
+
 /* device tree support */
 #ifdef CONFIG_THERMAL_OF
 int of_parse_thermal_zones(void);
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 1155457caf52..b23e019b1761 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -61,6 +61,8 @@
 #define DEFAULT_THERMAL_GOVERNOR       "fair_share"
 #elif defined(CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE)
 #define DEFAULT_THERMAL_GOVERNOR       "user_space"
+#elif defined(CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR)
+#define DEFAULT_THERMAL_GOVERNOR       "power_allocator"
 #endif
 
 struct thermal_zone_device;
@@ -255,9 +257,14 @@ struct thermal_bind_params {
 
 	/*
 	 * This is a measure of 'how effectively these devices can
-	 * cool 'this' thermal zone. The shall be determined by platform
-	 * characterization. This is on a 'percentage' scale.
-	 * See Documentation/thermal/sysfs-api.txt for more information.
+	 * cool 'this' thermal zone. The shall be determined by
+	 * platform characterization. For the fair-share governor,
+	 * this is on a 'percentage' scale.  See
+	 * Documentation/thermal/sysfs-api.txt for more
+	 * information. For the power_allocator governor, they are
+	 * relative to each other, see
+	 * Documentation/thermal/power_allocator.txt for more
+	 * information.
 	 */
 	int weight;
 
@@ -294,6 +301,33 @@ struct thermal_zone_params {
 
 	int num_tbps;	/* Number of tbp entries */
 	struct thermal_bind_params *tbp;
+
+	/*
+	 * Sustainable power (heat) that this thermal zone can dissipate in
+	 * mW
+	 */
+	u32 sustainable_power;
+
+	/*
+	 * Proportional parameter of the PID controller when
+	 * overshooting (i.e., when temperature is below the target)
+	 */
+	s32 k_po;
+
+	/*
+	 * Proportional parameter of the PID controller when
+	 * undershooting
+	 */
+	s32 k_pu;
+
+	/* Integral parameter of the PID controller */
+	s32 k_i;
+
+	/* Derivative parameter of the PID controller */
+	s32 k_d;
+
+	/* threshold below which the error is no longer accumulated */
+	s32 integral_cutoff;
 };
 
 struct thermal_genl_event {
-- 
1.9.1


