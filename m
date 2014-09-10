Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaIJPd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:33:56 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:41620 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaIJPdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:33:54 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Rui Zhang <rui.zhang@intel.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Mike Turquette <mturquette@linaro.org>, Nishanth Menon <nm@ti.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCH v2 1/1] thermal: introduce clock cooling device
Date: Wed, 10 Sep 2014 11:33:36 -0400
Message-Id: <1410363216-24615-1-git-send-email-edubezval@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Valentin <eduardo.valentin@ti.com>

This patch introduces a new thermal cooling device based on common clock
framework. The original motivation to write this cooling device is to be
able to cool down thermal zones using clocks that feed co-processors, such
as GPUs, DSPs, Image Processing Co-processors, etc. But it is written
in a way that it can be used on top of any clock.

The implementation is pretty straight forward. The code creates
a thermal cooling device based on a pair of a struct device and a clock name.
The struct device is assumed to be usable by the OPP layer. The OPP layer
is used as source of the list of possible frequencies. The (cpufreq) frequency
table is then used as a map from frequencies to cooling states. Cooling
states are indexes to the frequency table.

The logic sits on top of common clock framework, specifically on clock
pre notifications. Any PRE_RATE_CHANGE is hijacked, and the transition is
only allowed when the new rate is within the thermal limit (cooling state -> freq).

When a thermal cooling device state transition is requested, the clock
is also checked to verify if the current clock rate is within the new
thermal limit.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Nishanth Menon <nm@ti.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-pm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
---
 drivers/thermal/Kconfig         |  12 +
 drivers/thermal/Makefile        |   3 +
 drivers/thermal/clock_cooling.c | 485 ++++++++++++++++++++++++++++++++++++++++
 include/linux/clock_cooling.h   |  65 ++++++
 4 files changed, 565 insertions(+)
 create mode 100644 drivers/thermal/clock_cooling.c
 create mode 100644 include/linux/clock_cooling.h

---
Changelog:

Differences from V1:
. Fixed comments done by Pavel. Mainly on copyrights and type casting.

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 693208e..1ffede8 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -102,6 +102,18 @@ config CPU_THERMAL
 
 	  If you want this support, you should say Y here.
 
+config CLOCK_THERMAL
+	bool "Generic clock cooling support"
+	depends on COMMON_CLK
+	depends on PM_OPP
+	help
+	  This entry implements the generic clock cooling mechanism through
+	  frequency clipping. Typically used to cool off co-processors. The
+	  device that is configured to use this cooling mechanism will be
+	  controlled to reduce clock frequency whenever temperature is high.
+
+	  If you want this support, you should say Y here.
+
 config THERMAL_EMULATION
 	bool "Thermal emulation mode support"
 	help
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index 31e232f..76840ae 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -17,6 +17,9 @@ thermal_sys-$(CONFIG_THERMAL_GOV_USER_SPACE)	+= user_space.o
 # cpufreq cooling
 thermal_sys-$(CONFIG_CPU_THERMAL)	+= cpu_cooling.o
 
+# clock cooling
+thermal_sys-$(CONFIG_CLOCK_THERMAL)	+= clock_cooling.o
+
 # platform thermal drivers
 obj-$(CONFIG_SPEAR_THERMAL)	+= spear_thermal.o
 obj-$(CONFIG_RCAR_THERMAL)	+= rcar_thermal.o
diff --git a/drivers/thermal/clock_cooling.c b/drivers/thermal/clock_cooling.c
new file mode 100644
index 0000000..1b4ff0f
--- /dev/null
+++ b/drivers/thermal/clock_cooling.c
@@ -0,0 +1,485 @@
+/*
+ *  drivers/thermal/clock_cooling.c
+ *
+ *  Copyright (C) 2014 Eduardo Valentin <edubezval@gmail.com>
+ *
+ *  Copyright (C) 2013	Texas Instruments Inc.
+ *  Contact:  Eduardo Valentin <eduardo.valentin@ti.com>
+ *
+ *  Highly based on cpu_cooling.c.
+ *  Copyright (C) 2012	Samsung Electronics Co., Ltd(http://www.samsung.com)
+ *  Copyright (C) 2012  Amit Daniel <amit.kachhap@linaro.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ */
+#include <linux/clk.h>
+#include <linux/cpufreq.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/idr.h>
+#include <linux/mutex.h>
+#include <linux/pm_opp.h>
+#include <linux/slab.h>
+#include <linux/thermal.h>
+#include <linux/clock_cooling.h>
+
+/**
+ * struct clock_cooling_device - data for cooling device with clock
+ * @id: unique integer value corresponding to each clock_cooling_device
+ *	registered.
+ * @dev: struct device pointer to the device being used to cool off using
+ *       clock frequencies.
+ * @cdev: thermal_cooling_device pointer to keep track of the
+ *	registered cooling device.
+ * @clk_rate_change_nb: reference to notifier block used to receive clock
+ *                      rate changes.
+ * @freq_table: frequency table used to keep track of available frequencies.
+ * @clock_state: integer value representing the current state of clock
+ *	cooling	devices.
+ * @clock_val: integer value representing the absolute value of the clipped
+ *	frequency.
+ * @clk: struct clk reference used to enforce clock limits.
+ * @lock: mutex lock to protect this struct.
+ *
+ * This structure is required for keeping information of each
+ * clock_cooling_device registered. In order to prevent corruption of this a
+ * mutex @lock is used.
+ */
+struct clock_cooling_device {
+	int id;
+	struct device *dev;
+	struct thermal_cooling_device *cdev;
+	struct notifier_block clk_rate_change_nb;
+	struct cpufreq_frequency_table *freq_table;
+	unsigned long clock_state;
+	unsigned long clock_val;
+	struct clk *clk;
+	struct mutex lock; /* lock to protect the content of this struct */
+};
+#define to_clock_cooling_device(x) \
+		container_of(x, struct clock_cooling_device, clk_rate_change_nb)
+static DEFINE_IDR(clock_idr);
+static DEFINE_MUTEX(cooling_clock_lock);
+
+/**
+ * clock_cooling_get_idr - function to get an unique id.
+ * @id: int * value generated by this function.
+ *
+ * This function will populate @id with an unique
+ * id, using the idr API.
+ *
+ * Return: 0 on success, an error code on failure.
+ */
+static int clock_cooling_get_idr(int *id)
+{
+	int ret;
+
+	mutex_lock(&cooling_clock_lock);
+	ret = idr_alloc(&clock_idr, NULL, 0, 0, GFP_KERNEL);
+	mutex_unlock(&cooling_clock_lock);
+	if (unlikely(ret < 0))
+		return ret;
+	*id = ret;
+
+	return 0;
+}
+
+/**
+ * release_idr - function to free the unique id.
+ * @id: int value representing the unique id.
+ */
+static void release_idr(int id)
+{
+	mutex_lock(&cooling_clock_lock);
+	idr_remove(&clock_idr, id);
+	mutex_unlock(&cooling_clock_lock);
+}
+
+/* Below code defines functions to be used for clock as cooling device */
+
+enum clock_cooling_property {
+	GET_LEVEL,
+	GET_FREQ,
+	GET_MAXL,
+};
+
+/**
+ * clock_cooling_get_property - fetch a property of interest for a give cpu.
+ * @ccdev: clock cooling device reference
+ * @input: query parameter
+ * @output: query return
+ * @property: type of query (frequency, level, max level)
+ *
+ * This is the common function to
+ * 1. get maximum clock cooling states
+ * 2. translate frequency to cooling state
+ * 3. translate cooling state to frequency
+ * Note that the code may be not in good shape
+ * but it is written in this way in order to:
+ * a) reduce duplicate code as most of the code can be shared.
+ * b) make sure the logic is consistent when translating between
+ *    cooling states and frequencies.
+ *
+ * Return: 0 on success, -EINVAL when invalid parameters are passed.
+ */
+static int clock_cooling_get_property(struct clock_cooling_device *ccdev,
+				      unsigned long input,
+				      unsigned long *output,
+				      enum clock_cooling_property property)
+{
+	int i;
+	unsigned long max_level = 0, level = 0;
+	unsigned int freq = CPUFREQ_ENTRY_INVALID;
+	int descend = -1;
+	struct cpufreq_frequency_table *pos, *table = ccdev->freq_table;
+
+	if (!output)
+		return -EINVAL;
+
+	if (!table)
+		return -EINVAL;
+
+	cpufreq_for_each_valid_entry(pos, table) {
+		/* ignore duplicate entry */
+		if (freq == pos->frequency)
+			continue;
+
+		/* get the frequency order */
+		if (freq != CPUFREQ_ENTRY_INVALID && descend == -1)
+			descend = freq > pos->frequency;
+
+		freq = pos->frequency;
+		max_level++;
+	}
+
+	/* No valid cpu frequency entry */
+	if (max_level == 0)
+		return -EINVAL;
+
+	/* max_level is an index, not a counter */
+	max_level--;
+
+	/* get max level */
+	if (property == GET_MAXL) {
+		*output = max_level;
+		return 0;
+	}
+
+	if (property == GET_FREQ)
+		level = descend ? input : (max_level - input);
+
+	i = 0;
+	cpufreq_for_each_valid_entry(pos, table) {
+		/* ignore duplicate entry */
+		if (freq == pos->frequency)
+			continue;
+
+		/* now we have a valid frequency entry */
+		freq = pos->frequency;
+
+		if (property == GET_LEVEL && (unsigned int)input == freq) {
+			/* get level by frequency */
+			*output = descend ? i : (max_level - i);
+			return 0;
+		}
+		if (property == GET_FREQ && level == i) {
+			/* get frequency by level */
+			*output = freq;
+			return 0;
+		}
+		i++;
+	}
+
+	return -EINVAL;
+}
+
+/**
+ * clock_cooling_get_level - return the cooling level of given clock cooling.
+ * @cdev: reference of a thermal cooling device of used as clock cooling device
+ * @freq: the frequency of interest
+ *
+ * This function will match the cooling level corresponding to the
+ * requested @freq and return it.
+ *
+ * Return: The matched cooling level on success or THERMAL_CSTATE_INVALID
+ * otherwise.
+ */
+unsigned long clock_cooling_get_level(struct thermal_cooling_device *cdev,
+				      unsigned long freq)
+{
+	struct clock_cooling_device *ccdev = cdev->devdata;
+	unsigned long val;
+
+	if (clock_cooling_get_property(ccdev, (unsigned long)freq, &val,
+				       GET_LEVEL))
+		return THERMAL_CSTATE_INVALID;
+
+	return val;
+}
+EXPORT_SYMBOL_GPL(clock_cooling_get_level);
+
+/**
+ * clock_cooling_get_frequency - get the absolute value of frequency from level.
+ * @ccdev: clock cooling device reference
+ * @level: cooling level
+ *
+ * This function matches cooling level with frequency. Based on a cooling level
+ * of frequency, equals cooling state of cpu cooling device, it will return
+ * the corresponding frequency.
+ *	e.g level=0 --> 1st MAX FREQ, level=1 ---> 2nd MAX FREQ, .... etc
+ *
+ * Return: 0 on error, the corresponding frequency otherwise.
+ */
+static unsigned long
+clock_cooling_get_frequency(struct clock_cooling_device *ccdev,
+			    unsigned long level)
+{
+	int ret = 0;
+	unsigned long freq;
+
+	ret = clock_cooling_get_property(ccdev, level, &freq, GET_FREQ);
+	if (ret)
+		return 0;
+
+	return freq;
+}
+
+/**
+ * clock_cooling_apply - function to apply frequency clipping.
+ * @ccdev: clock_cooling_device pointer containing frequency clipping data.
+ * @cooling_state: value of the cooling state.
+ *
+ * Function used to make sure the clock layer is aware of current thermal
+ * limits. The limits are applied by updating the clock rate in case it is
+ * higher than the corresponding frequency based on the requested cooling_state.
+ *
+ * Return: 0 on success, an error code otherwise (-EINVAL in case wrong
+ * cooling state).
+ */
+static int clock_cooling_apply(struct clock_cooling_device *ccdev,
+			       unsigned long cooling_state)
+{
+	unsigned long clip_freq, cur_freq;
+	int ret = 0;
+
+	/* Here we write the clipping */
+	/* Check if the old cooling action is same as new cooling action */
+	if (ccdev->clock_state == cooling_state)
+		return 0;
+
+	clip_freq = clock_cooling_get_frequency(ccdev, cooling_state);
+	if (!clip_freq)
+		return -EINVAL;
+
+	cur_freq = clk_get_rate(ccdev->clk);
+
+	mutex_lock(&ccdev->lock);
+	ccdev->clock_state = cooling_state;
+	ccdev->clock_val = clip_freq;
+	/* enforce clock level */
+	if (cur_freq > clip_freq)
+		ret = clk_set_rate(ccdev->clk, clip_freq);
+	mutex_unlock(&ccdev->lock);
+
+	return ret;
+}
+
+/**
+ * clock_cooling_clock_notifier - notifier callback on clock rate changes.
+ * @nb:	struct notifier_block * with callback info.
+ * @event: value showing clock event for which this function invoked.
+ * @data: callback-specific data
+ *
+ * Callback to hijack the notification on clock transition.
+ * Every time there is a clock change, we intercept all pre change events
+ * and block the transition in case the new rate infringes thermal limits.
+ *
+ * Return: NOTIFY_DONE (success) or NOTIFY_BAD (new_rate > thermal limit).
+ */
+static int clock_cooling_clock_notifier(struct notifier_block *nb,
+					unsigned long event, void *data)
+{
+	struct clk_notifier_data *ndata = data;
+	struct clock_cooling_device *ccdev = to_clock_cooling_device(nb);
+
+	switch (event) {
+	case PRE_RATE_CHANGE:
+		/*
+		 * checks on current state
+		 * TODO: current method is not best we can find as it
+		 * allows possibly voltage transitions, in case DVFS
+		 * layer is also hijacking clock pre notifications.
+		 */
+		if (ndata->new_rate > ccdev->clock_val)
+			return NOTIFY_BAD;
+		/* fall through */
+	case POST_RATE_CHANGE:
+	case ABORT_RATE_CHANGE:
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
+/* clock cooling device thermal callback functions are defined below */
+
+/**
+ * clock_cooling_get_max_state - callback function to get the max cooling state.
+ * @cdev: thermal cooling device pointer.
+ * @state: fill this variable with the max cooling state.
+ *
+ * Callback for the thermal cooling device to return the clock
+ * max cooling state.
+ *
+ * Return: 0 on success, an error code otherwise.
+ */
+static int clock_cooling_get_max_state(struct thermal_cooling_device *cdev,
+				       unsigned long *state)
+{
+	struct clock_cooling_device *ccdev = cdev->devdata;
+	unsigned long count = 0;
+	int ret;
+
+	ret = clock_cooling_get_property(ccdev, 0, &count, GET_MAXL);
+	if (!ret)
+		*state = count;
+
+	return ret;
+}
+
+/**
+ * clock_cooling_get_cur_state - function to get the current cooling state.
+ * @cdev: thermal cooling device pointer.
+ * @state: fill this variable with the current cooling state.
+ *
+ * Callback for the thermal cooling device to return the clock
+ * current cooling state.
+ *
+ * Return: 0 (success)
+ */
+static int clock_cooling_get_cur_state(struct thermal_cooling_device *cdev,
+				       unsigned long *state)
+{
+	struct clock_cooling_device *ccdev = cdev->devdata;
+
+	*state = ccdev->clock_state;
+
+	return 0;
+}
+
+/**
+ * clock_cooling_set_cur_state - function to set the current cooling state.
+ * @cdev: thermal cooling device pointer.
+ * @state: set this variable to the current cooling state.
+ *
+ * Callback for the thermal cooling device to change the clock cooling
+ * current cooling state.
+ *
+ * Return: 0 on success, an error code otherwise.
+ */
+static int clock_cooling_set_cur_state(struct thermal_cooling_device *cdev,
+				       unsigned long state)
+{
+	struct clock_cooling_device *clock_device = cdev->devdata;
+
+	return clock_cooling_apply(clock_device, state);
+}
+
+/* Bind clock callbacks to thermal cooling device ops */
+static struct thermal_cooling_device_ops const clock_cooling_ops = {
+	.get_max_state = clock_cooling_get_max_state,
+	.get_cur_state = clock_cooling_get_cur_state,
+	.set_cur_state = clock_cooling_set_cur_state,
+};
+
+/**
+ * clock_cooling_register - function to create clock cooling device.
+ * @dev: struct device pointer to the device used as clock cooling device.
+ * @clock_name: string containing the clock used as cooling mechanism.
+ *
+ * This interface function registers the clock cooling device with the name
+ * "thermal-clock-%x". The cooling device is based on clock frequencies.
+ * The struct device is assumed to be capable of DVFS transitions.
+ * The OPP layer is used to fetch and fill the available frequencies for
+ * the referred device. The ordered frequency table is used to control
+ * the clock cooling device cooling states and to limit clock transitions
+ * based on the cooling state requested by the thermal framework.
+ *
+ * Return: a valid struct thermal_cooling_device pointer on success,
+ * on failure, it returns a corresponding ERR_PTR().
+ */
+struct thermal_cooling_device *
+clock_cooling_register(struct device *dev, const char *clock_name)
+{
+	struct thermal_cooling_device *cdev;
+	struct clock_cooling_device *ccdev = NULL;
+	char dev_name[THERMAL_NAME_LENGTH];
+	int ret = 0;
+
+	ccdev = devm_kzalloc(dev, sizeof(*ccdev), GFP_KERNEL);
+	if (!ccdev)
+		return ERR_PTR(-ENOMEM);
+
+	ccdev->dev = dev;
+	ccdev->clk = devm_clk_get(dev, clock_name);
+	if (IS_ERR(ccdev->clk))
+		return ERR_CAST(ccdev->clk);
+
+	ret = clock_cooling_get_idr(&ccdev->id);
+	if (ret)
+		return ERR_PTR(-EINVAL);
+
+	snprintf(dev_name, sizeof(dev_name), "thermal-clock-%d", ccdev->id);
+
+	cdev = thermal_cooling_device_register(dev_name, ccdev,
+					       &clock_cooling_ops);
+	if (IS_ERR(cdev)) {
+		release_idr(ccdev->id);
+		return ERR_PTR(-EINVAL);
+	}
+	ccdev->cdev = cdev;
+	ccdev->clk_rate_change_nb.notifier_call = clock_cooling_clock_notifier;
+
+	/* Assuming someone has already filled the opp table for this device */
+	ret = dev_pm_opp_init_cpufreq_table(dev, &ccdev->freq_table);
+	if (ret) {
+		release_idr(ccdev->id);
+		return ERR_PTR(ret);
+	}
+	ccdev->clock_state = 0;
+	ccdev->clock_val = clock_cooling_get_frequency(ccdev, 0);
+
+	clk_notifier_register(ccdev->clk, &ccdev->clk_rate_change_nb);
+
+	return cdev;
+}
+EXPORT_SYMBOL_GPL(clock_cooling_register);
+
+/**
+ * clock_cooling_unregister - function to remove clock cooling device.
+ * @cdev: thermal cooling device pointer.
+ *
+ * This interface function unregisters the "thermal-clock-%x" cooling device.
+ */
+void clock_cooling_unregister(struct thermal_cooling_device *cdev)
+{
+	struct clock_cooling_device *ccdev;
+
+	if (!cdev)
+		return;
+
+	ccdev = cdev->devdata;
+
+	clk_notifier_unregister(ccdev->clk, &ccdev->clk_rate_change_nb);
+	dev_pm_opp_free_cpufreq_table(ccdev->dev, &ccdev->freq_table);
+
+	thermal_cooling_device_unregister(ccdev->cdev);
+	release_idr(ccdev->id);
+}
+EXPORT_SYMBOL_GPL(clock_cooling_unregister);
diff --git a/include/linux/clock_cooling.h b/include/linux/clock_cooling.h
new file mode 100644
index 0000000..4d1019d
--- /dev/null
+++ b/include/linux/clock_cooling.h
@@ -0,0 +1,65 @@
+/*
+ *  linux/include/linux/clock_cooling.h
+ *
+ *  Copyright (C) 2014 Eduardo Valentin <edubezval@gmail.com>
+ *
+ *  Copyright (C) 2013	Texas Instruments Inc.
+ *  Contact:  Eduardo Valentin <eduardo.valentin@ti.com>
+ *
+ *  Highly based on cpu_cooling.c.
+ *  Copyright (C) 2012	Samsung Electronics Co., Ltd(http://www.samsung.com)
+ *  Copyright (C) 2012  Amit Daniel <amit.kachhap@linaro.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ */
+
+#ifndef __CPU_COOLING_H__
+#define __CPU_COOLING_H__
+
+#include <linux/of.h>
+#include <linux/thermal.h>
+#include <linux/cpumask.h>
+
+#ifdef CONFIG_CLOCK_THERMAL
+/**
+ * clock_cooling_register - function to create clock cooling device.
+ * @dev: struct device pointer to the device used as clock cooling device.
+ * @clock_name: string containing the clock used as cooling mechanism.
+ */
+struct thermal_cooling_device *
+clock_cooling_register(struct device *dev, const char *clock_name);
+
+/**
+ * clock_cooling_unregister - function to remove clock cooling device.
+ * @cdev: thermal cooling device pointer.
+ */
+void clock_cooling_unregister(struct thermal_cooling_device *cdev);
+
+unsigned long clock_cooling_get_level(struct thermal_cooling_device *cdev,
+				      unsigned long freq);
+#else /* !CONFIG_CLOCK_THERMAL */
+static inline struct thermal_cooling_device *
+clock_cooling_register(struct device *dev, const char *clock_name)
+{
+	return NULL;
+}
+static inline
+void clock_cooling_unregister(struct thermal_cooling_device *cdev)
+{
+}
+static inline
+unsigned long clock_cooling_get_level(struct thermal_cooling_device *cdev,
+				      unsigned long freq)
+{
+	return THERMAL_CSTATE_INVALID;
+}
+#endif	/* CONFIG_CLOCK_THERMAL */
+
+#endif /* __CPU_COOLING_H__ */
-- 
1.9.1

