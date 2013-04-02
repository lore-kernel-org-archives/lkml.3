Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976Ab3DBWQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:16:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:62899 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933879Ab3DBWQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:16:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,396,1363158000"; 
   d="scan'208";a="279875737"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 1/1] Introduce Intel RAPL cooling device driver
Date: Tue,  2 Apr 2013 15:15:36 -0700
Message-Id: <1364940936-20846-2-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364940936-20846-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1364940936-20846-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RAPL(Running Average Power Limit) interface provides platform software
with the ability to monitor, control, and get notifications on SOC
power consumptions. Since its first appearance on Sandy Bridge, more
features have being added to extend its usage. In RAPL, platforms are
divided into domains for fine grained control. These domains include
package, DRAM controller, CPU core (Power Plane 0), graphics uncore
(power plane 1), etc.

The purpose of this driver is to expose RAPL for userspace
consumption. Overall, RAPL fits in the generic thermal layer in
that platform level power capping and monitoring are mainly used for
thermal management and thermal layer provides the abstracted interface
needed to have portable applications.

Specifically, userspace is presented with per domain cooling device
with sysfs links to its kobject. Although RAPL domain provides many
parameters for fine tuning, long term power limit is exposed as the
single knob via cooling device state. Whereas the rest of the
parameters are still accessible via the linked kobject. This simplifies
the interface for both simple and advanced use cases.

Eventfd is used to provide notifications to the userspace. At per domain
level, use can choose any event capable parameters to register for
threshold crossing notifications. This is shamelessly "borrowed" from
cgroup with some trimming/fitting.

Zhang, Rui's initial RAPL driver was used as a reference and starting
point. Many thanks.
https://lkml.org/lkml/2011/5/26/93

Unlike the patch above, which is mainly for monitoring, this driver
focus on the control and usability by user applications.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/platform/x86/Kconfig      |    8 +
 drivers/platform/x86/Makefile     |    1 +
 drivers/platform/x86/intel_rapl.c | 1323 +++++++++++++++++++++++++++++++++++++
 drivers/platform/x86/intel_rapl.h |  249 +++++++
 4 files changed, 1581 insertions(+)
 create mode 100644 drivers/platform/x86/intel_rapl.c
 create mode 100644 drivers/platform/x86/intel_rapl.h

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 3338437..34bcd52 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -781,4 +781,12 @@ config APPLE_GMUX
 	  graphics as well as the backlight. Currently only backlight
 	  control is supported by the driver.
 
+config INTEL_RAPL
+	tristate "Intel RAPL Support"
+	depends on X86 && THERMAL
+	default y
+	---help---
+	  RAPL, AKA, Running Average Power Limit provides mechanisms to enforce
+	  and monitor per domain power consumption limits of supported Intel CPUs.
+
 endif # X86_PLATFORM_DEVICES
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index ace2b38..a80c0f4 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -51,3 +51,4 @@ obj-$(CONFIG_INTEL_OAKTRAIL)	+= intel_oaktrail.o
 obj-$(CONFIG_SAMSUNG_Q10)	+= samsung-q10.o
 obj-$(CONFIG_APPLE_GMUX)	+= apple-gmux.o
 obj-$(CONFIG_CHROMEOS_LAPTOP)	+= chromeos_laptop.o
+obj-$(CONFIG_INTEL_RAPL)	+= intel_rapl.o
diff --git a/drivers/platform/x86/intel_rapl.c b/drivers/platform/x86/intel_rapl.c
new file mode 100644
index 0000000..56ee928
--- /dev/null
+++ b/drivers/platform/x86/intel_rapl.c
@@ -0,0 +1,1323 @@
+/*
+ *  intel_rapl.c - Intel Running Average Power Limit Driver for MSR based
+ *                 RAPL interface
+ *
+ *  Copyright (c) 2013, Intel Corporation.
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or (at
+ *  your option) any later version.
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
+
+/* #define DEBUG */
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/thermal.h>
+#include <linux/slab.h>
+#include <linux/eventfd.h>
+#include <linux/poll.h>
+#include <linux/log2.h>
+#include <linux/bitmap.h>
+#include <linux/delay.h>
+#include <linux/sysfs.h>
+
+#include <asm/processor.h>
+#include <asm/cpu_device_id.h>
+
+#include "intel_rapl.h"
+#include "../../../fs/sysfs/sysfs.h"
+#define DRIVER_NAME "intel_rapl"
+
+static void rapl_poll_data(struct work_struct *dummy);
+static DECLARE_DELAYED_WORK(rapl_polling_work, rapl_poll_data);
+static bool polling_started;
+static int start_periodic_polling(void);
+static int stop_periodic_polling(void);
+static struct kset *rapl_kset;
+
+static void rapl_init_domains(void);
+
+static struct rapl_domain *rapl_domains;
+static struct rapl_data rg_data; /* global data */
+static struct rapl_domain_data *rd_data;
+
+#define kobj_to_rapl_domain(k) container_of(k, struct rapl_domain, kobj)
+#define to_rapl_attr(a) container_of(a, struct rapl_attr, attr)
+
+static struct platform_device intel_rapl_device = {
+	.name		   = DRIVER_NAME,
+	.id		   = -1,
+};
+
+static char *rapl_domain_names[] = {
+	"package",
+	"power_plane_0",
+	"power_plane_1",
+	"dram",
+};
+
+/* called after domain detection and global data are set */
+static void rapl_init_domains(void)
+{
+	int i, j = 0;
+
+	for (i = 0; i < RAPL_DOMAIN_MAX; i++) {
+		unsigned int mask = rg_data.domain_map & (1 << i);
+
+		switch (mask) {
+		case 1 << RAPL_DOMAIN_PKG:
+			rapl_domains[j].name =
+				rapl_domain_names[RAPL_DOMAIN_PKG];
+			rapl_domains[j].id = RAPL_DOMAIN_PKG;
+			rapl_domains[j].msrs[0] = MSR_PKG_POWER_LIMIT;
+			rapl_domains[j].msrs[1] = MSR_PKG_ENERGY_STATUS;
+			rapl_domains[j].msrs[2] = MSR_PKG_PERF_STATUS;
+			rapl_domains[j].msrs[3] = 0;
+			rapl_domains[j].msrs[4] = MSR_PKG_POWER_INFO;
+			rapl_domains[j].attr_map = RAPL_STANDARD_ATTRS |
+				RAPL_ATTR_PL2 |
+				RAPL_ATTR_PL2_ENABLE | RAPL_ATTR_PL2_CLAMP |
+				RAPL_ATTR_THROTTLE_TIME |
+				RAPL_ATTR_TIME_WINDOW2 |
+				RAPL_ATTR_MAX_POWER | RAPL_ATTR_MIN_POWER |
+				RAPL_ATTR_MAX_WINDOW |
+				RAPL_ATTR_THERMAL_SPEC_POWER;
+			break;
+		case 1 << RAPL_DOMAIN_PP0:
+			rapl_domains[j].name =
+				rapl_domain_names[RAPL_DOMAIN_PP0];
+			rapl_domains[j].id = RAPL_DOMAIN_PP0;
+			rapl_domains[j].msrs[0] = MSR_PP0_POWER_LIMIT;
+			rapl_domains[j].msrs[1] = MSR_PP0_ENERGY_STATUS;
+			rapl_domains[j].msrs[2] = 0;
+			rapl_domains[j].msrs[3] = MSR_PP0_POLICY;
+			rapl_domains[j].msrs[4] = 0;
+			rapl_domains[j].attr_map = RAPL_STANDARD_ATTRS |
+				RAPL_ATTR_PRIO_LEVEL |
+				RAPL_ATTR_THROTTLE_TIME;
+			break;
+		case 1 << RAPL_DOMAIN_PP1:
+			rapl_domains[j].name =
+				rapl_domain_names[RAPL_DOMAIN_PP1];
+			rapl_domains[j].id = RAPL_DOMAIN_PP1;
+			rapl_domains[j].msrs[0] = MSR_PP1_POWER_LIMIT;
+			rapl_domains[j].msrs[1] = MSR_PP1_ENERGY_STATUS;
+			rapl_domains[j].msrs[2] = 0;
+			rapl_domains[j].msrs[3] = MSR_PP1_POLICY;
+			rapl_domains[j].msrs[4] = 0;
+			rapl_domains[j].attr_map = RAPL_STANDARD_ATTRS |
+				RAPL_ATTR_PRIO_LEVEL |
+				RAPL_ATTR_THROTTLE_TIME;
+			break;
+		case 1 << RAPL_DOMAIN_DRAM:
+			rapl_domains[j].name =
+				rapl_domain_names[RAPL_DOMAIN_DRAM];
+			rapl_domains[j].id = RAPL_DOMAIN_DRAM;
+			rapl_domains[j].msrs[0] = MSR_DRAM_POWER_LIMIT;
+			rapl_domains[j].msrs[1] = MSR_DRAM_ENERGY_STATUS;
+			rapl_domains[j].msrs[2] = MSR_DRAM_PERF_STATUS;
+			rapl_domains[j].msrs[3] = 0;
+			rapl_domains[j].msrs[4] = MSR_DRAM_POWER_INFO;
+			rapl_domains[j].attr_map = RAPL_STANDARD_ATTRS |
+				RAPL_ATTR_THROTTLE_TIME |
+				RAPL_ATTR_TIME_WINDOW2 |
+				RAPL_ATTR_MAX_POWER | RAPL_ATTR_MIN_POWER |
+				RAPL_ATTR_MAX_WINDOW |
+				RAPL_ATTR_THERMAL_SPEC_POWER;
+			break;
+		default:
+			pr_info("No rapl domain %s on this platform\n",
+				rapl_domain_names[i]);
+		}
+		if (mask)
+			j++;
+	}
+}
+
+static u64 rapl_unit_xlate(enum unit_type type, u64 value, int to_raw)
+{
+	u64 divisor = 1;
+	int scale = 1; /* scale to user friendly data without floating point */
+	int f, y; /* fraction and exp. used for time unit */
+
+	switch (type) {
+	case POWER_UNIT:
+		divisor = rg_data.power_unit_divisor;
+		scale = POWER_UNIT_SCALE;
+		break;
+	case ENERGY_UNIT:
+		scale = ENERGY_UNIT_SCALE;
+		divisor = rg_data.energy_unit_divisor;
+		break;
+	case TIME_UNIT:
+		divisor = rg_data.time_unit_divisor;
+		scale = TIME_UNIT_SCALE;
+		/* special processing based on 2^Y*(1+F)/4 = val/divisor */
+		if (!to_raw) {
+			f = (value & 0x60) >> 5;
+			y = value & 0x1f;
+			value = (1<<y)*(4+f)*scale/4;
+			return div64_u64(value, divisor);
+		} else {
+			do_div(value, scale);
+			value *= divisor;
+			y = ilog2(value);
+			f = div64_u64(4 * (value-(1<<y)), 1<<y);
+			value = (y & 0x1f) | ((f&0x3)<<5);
+			return value;
+		}
+		break;
+	case NA_UNIT:
+	default:
+		return value;
+	};
+
+	if (to_raw)
+		return div64_u64(value * divisor, scale);
+	else
+		return div64_u64(value * scale, divisor);
+}
+
+/* in the order of enum rapl_primitives */
+static struct rapl_primitive_info rpi[] = {
+	/* name, mask, shift, msr index, unit divisor*/
+	PRIMITIVE_INFO_INIT(energy, ENERGY_STATUS_MASK, 0,
+			RAPL_DOMAIN_MSR_STATUS, ENERGY_UNIT,
+			RAPL_PRIMITIVE_EVENT_CAP),
+	PRIMITIVE_INFO_INIT(power_limit1, POWER_LIMIT1_MASK, 0,
+			RAPL_DOMAIN_MSR_LIMIT, POWER_UNIT, 0),
+	PRIMITIVE_INFO_INIT(power_limit2, POWER_LIMIT2_MASK, 32,
+			RAPL_DOMAIN_MSR_LIMIT, POWER_UNIT, 0),
+	PRIMITIVE_INFO_INIT(lock, POWER_PP_LOCK, 31,
+			RAPL_DOMAIN_MSR_LIMIT, NA_UNIT, 0),
+	PRIMITIVE_INFO_INIT(pl1_enable, POWER_LIMIT1_ENABLE, 15,
+			RAPL_DOMAIN_MSR_LIMIT, NA_UNIT, 0),
+	PRIMITIVE_INFO_INIT(pl1_clamp, POWER_LIMIT1_CLAMP, 16,
+			RAPL_DOMAIN_MSR_LIMIT, NA_UNIT, 0),
+	PRIMITIVE_INFO_INIT(pl2_enable, POWER_LIMIT2_ENABLE, 47,
+			RAPL_DOMAIN_MSR_LIMIT, NA_UNIT, 0),
+	PRIMITIVE_INFO_INIT(pl2_clamp, POWER_LIMIT2_CLAMP, 48,
+			RAPL_DOMAIN_MSR_LIMIT, NA_UNIT, 0),
+	PRIMITIVE_INFO_INIT(time_window1, TIME_WINDOW1_MASK, 17,
+			RAPL_DOMAIN_MSR_LIMIT, TIME_UNIT, 0),
+	PRIMITIVE_INFO_INIT(time_window2, TIME_WINDOW2_MASK, 49,
+			RAPL_DOMAIN_MSR_LIMIT, TIME_UNIT, 0),
+	PRIMITIVE_INFO_INIT(thermal_spec_power, POWER_INFO_THERMAL_SPEC_MASK, 0,
+			RAPL_DOMAIN_MSR_INFO, POWER_UNIT, 0),
+	PRIMITIVE_INFO_INIT(max_power, POWER_INFO_MAX_MASK, 32,
+			RAPL_DOMAIN_MSR_INFO, POWER_UNIT, 0),
+	PRIMITIVE_INFO_INIT(min_power, POWER_INFO_MIN_MASK, 16,
+			RAPL_DOMAIN_MSR_INFO, POWER_UNIT, 0),
+	PRIMITIVE_INFO_INIT(max_window, POWER_INFO_MAX_TIME_WIN_MASK, 48,
+			RAPL_DOMAIN_MSR_INFO, TIME_UNIT, 0),
+	PRIMITIVE_INFO_INIT(throttle_time, PERF_STATUS_THROTTLE_TIME_MASK, 0,
+			RAPL_DOMAIN_MSR_PERF, TIME_UNIT,
+			RAPL_PRIMITIVE_EVENT_CAP),
+	PRIMITIVE_INFO_INIT(prio_level, PP_POLICY_MASK, 0,
+			RAPL_DOMAIN_MSR_POLICY, NA_UNIT, 0),
+	PRIMITIVE_INFO_INIT(power, 0, 0, 0, POWER_UNIT,
+			RAPL_PRIMITIVE_DERIVED|RAPL_PRIMITIVE_EVENT_CAP),
+	/* non-hardware, used for sysfs attr */
+	PRIMITIVE_INFO_INIT(event_control, 0, 0, 0, 0, RAPL_PRIMITIVE_DUMMY),
+	PRIMITIVE_INFO_INIT(domain_name, 0, 0, 0, 0, RAPL_PRIMITIVE_DUMMY),
+	{NULL, 0, 0, 0},
+};
+
+static int primitive_name_to_entry(const char *name)
+{
+	int i;
+
+	for (i = 0; i < nr_rapl_primitives; i++) {
+		if (!strcmp(rpi[i].name, name))
+			return i;
+	}
+
+	return -EINVAL;
+}
+
+static int rapl_read_data_raw(struct rapl_domain *domain,
+			struct rapl_primitive_info *rp, bool xlate, u64 *data)
+{
+	u32 msr_l, msr_h;
+	u64 value, final;
+	u32 msr;
+	u32 mask_h, mask_l;
+
+	if (NULL == rp->name || rp->flag & RAPL_PRIMITIVE_DUMMY)
+		return -EINVAL;
+
+	msr = domain->msrs[rp->id];
+	if (!msr)
+		return -EINVAL;
+
+	/* specical-case pkg lock bit since pkg domain uses a different bit */
+	if (rp->pm_id == lock && domain->id == RAPL_DOMAIN_PKG) {
+		rp->mask = POWER_PKG_LOCK;
+		rp->shift = 63;
+	}
+	if (rp->flag & RAPL_PRIMITIVE_DERIVED) {
+		*data = domain->rdd->primitives[rp->pm_id];
+		return 0;
+	}
+
+	if (rdmsr_safe(msr, &msr_l, &msr_h)) {
+		pr_debug("failed to read msr 0x%x\n", msr);
+		return -EIO;
+	}
+
+	mask_h = rp->mask >> 32;
+	mask_l = rp->mask & 0xffffffff;
+
+	value = (u64)msr_h<<32 | (u64)msr_l;
+
+	final = value & rp->mask;
+	final = final >> rp->shift;
+	if (true == xlate)
+		*data = rapl_unit_xlate(rp->unit, final, 0);
+	else
+		*data = final;
+
+	return 0;
+}
+
+static int rapl_write_data_raw(struct rapl_domain *domain,
+			struct rapl_primitive_info *rp,
+			unsigned long long value)
+{
+	u32 msr_l, msr_h;
+	u32 mask_h, val_h;
+	u32 msr = domain->msrs[rp->id];
+
+	if (rdmsr_safe(msr, &msr_l, &msr_h)) {
+		pr_err("failed to read msr 0x%x\n", msr);
+		return -EIO;
+	}
+	value = rapl_unit_xlate(rp->unit, value, 1);
+	mask_h = rp->mask >> 32;
+	if (mask_h) {
+		msr_h &= ~mask_h;
+		val_h = (value << rp->shift) >> 32;
+		msr_h |= val_h;
+	}
+	msr_l &= ~(u32)rp->mask;
+	msr_l |= (u32)value << rp->shift;
+	if (wrmsr_safe(msr, msr_l, msr_h)) {
+		pr_err("failed to read msr 0x%x\n", msr);
+		return -EIO;
+	}
+
+	return value >> rp->shift;
+}
+
+#define SHOW_PRIMITIVE(n)						\
+	static ssize_t show_ ## n(struct rapl_domain *rd, char *buf)	\
+	{								\
+		u64 val;						\
+		int ret;						\
+		int i = primitive_name_to_entry(#n);			\
+		if (i >= 0) {						\
+			ret = rapl_read_data_raw(rd, &rpi[i], true, &val); \
+			if (ret)					\
+				return ret;				\
+			return sprintf(buf, "%llu\n", val);		\
+		}							\
+		return i;						\
+	}
+
+static int rapl_check_unit(void)
+{
+	u64 output;
+	u32 value;
+
+	if (rdmsrl_safe(MSR_RAPL_POWER_UNIT, &output)) {
+		pr_err("Failed to read power unit MSR 0x%x, exit.\n",
+			MSR_RAPL_POWER_UNIT);
+		return -ENODEV;
+	}
+	/* energy unit: 1/enery_unit_divisor Joules */
+	value = (output & ENERGY_UNIT_MASK) >> ENERGY_UNIT_OFFSET;
+	rg_data.energy_unit_divisor = 1 << value;
+
+	/* power unit: 1/power_unit_divisor Watts */
+	value = (output & POWER_UNIT_MASK) >> POWER_UNIT_OFFSET;
+	rg_data.power_unit_divisor = 1 << value;
+
+	/* time unit: 1/time_unit_divisor Seconds */
+	value = (output & TIME_UNIT_MASK) >> TIME_UNIT_OFFSET;
+	rg_data.time_unit_divisor = 1 << value;
+
+	return 0;
+}
+
+static int rapl_get_max_state(struct thermal_cooling_device *cdev,
+			unsigned long *state)
+{
+	int ret;
+	u64 val;
+
+	struct rapl_domain *rd = (struct rapl_domain *)cdev->devdata;
+
+	/* TDP aka thermal design power is the max level rapl can set */
+	ret = rapl_read_data_raw(rd, &rpi[thermal_spec_power], true, &val);
+	if (ret)
+		goto default_max;
+	if (val)
+		goto done;
+	/* use pl1 setting as max if tdp is not available */
+default_max:
+	ret = rapl_read_data_raw(rd, &rpi[power_limit1], true, &val);
+	if (ret)
+		return ret;
+done:
+	*state = val;
+
+	return 0;
+}
+
+static int rapl_get_cur_state(struct thermal_cooling_device *cdev, unsigned long
+			     *state)
+{
+	struct rapl_domain *rd = (struct rapl_domain *)cdev->devdata;
+
+	if (false == polling_started)
+		*state = 0;
+	else
+		*state = rd->rdd->primitives[power];
+
+	return 0;
+}
+
+static bool rapl_polling_should_cont(void)
+{
+	int i;
+	unsigned int all_state = 0;
+
+	/* remaining events or user set power limit will continue polling */
+	for (i = 0; i < rg_data.nr_domains; i++)
+		all_state += rapl_domains[i].state;
+
+	return !!all_state;
+}
+
+
+static void set_pkg_thermal_irq(bool enable)
+{
+	u32 l, h;
+
+	/* REVISIT:
+	 * When package power limit is set artificially low by RAPL, LVT
+	 * thermal interrupt for package power limit should be ignored
+	 * since we are not really exceeding the real limit. The intention
+	 * is to avoid interrupt storms while we are power limiting.
+	 * A useful feature will be routing the pkg_power_limit interrupt
+	 * to userspace via eventfd. once we have a usecase, this is simple
+	 * to do by adding an atomic notifier.
+	 */
+	if (boot_cpu_has(X86_FEATURE_PTS))
+		rdmsr(MSR_IA32_PACKAGE_THERM_INTERRUPT, l, h);
+	else
+		return;
+
+	if (false == enable)
+		l &= ~PACKAGE_THERM_INT_PLN_ENABLE;
+	else
+		l |= PACKAGE_THERM_INT_PLN_ENABLE;
+
+	if (boot_cpu_has(X86_FEATURE_PLN))
+		wrmsr(MSR_IA32_PACKAGE_THERM_INTERRUPT, l, h);
+
+}
+
+static int rapl_set_cur_state(struct thermal_cooling_device *cdev,
+			unsigned long state)
+{
+	struct rapl_domain *rd = (struct rapl_domain *)cdev->devdata;
+	unsigned long spec_power = rd->rdd->primitives[thermal_spec_power];
+	unsigned long minimum_power = rd->rdd->primitives[min_power];
+
+	if (state) {
+		/* in some cases, no spec power is provided. just do a basic
+		 * range check between 0 and max bits allowed.
+		 */
+		if (!spec_power || !minimum_power) {
+			minimum_power = 0;
+			spec_power = POWER_UNIT_SCALE*
+				POWER_INFO_THERMAL_SPEC_MASK/
+				rg_data.power_unit_divisor;
+		}
+		if (state < minimum_power || state >= spec_power) {
+			pr_err("Out of thermal spec power range! %lu- %lu\n",
+				minimum_power, spec_power);
+			state = clamp(state, minimum_power, spec_power);
+		}
+		/* REVISIT: there are correlations between RAPL parameters.
+		 * 1) set proportional pl2, e.g. 1.2xpl1
+		 * 2) use a short default tw1 such as 1 sec. some system has
+		 *    a very long default time window (20sec+) which results in
+		 *    slow response.
+		 * user can set these parameters via the device sysfs files, or
+		 * we can assign the best guessed value here.
+		 */
+		rapl_write_data_raw(rd, &rpi[pl1_enable], 1);
+		rapl_write_data_raw(rd, &rpi[pl1_clamp], 1);
+		rapl_write_data_raw(rd, &rpi[power_limit1], state);
+		rd->state |= DOMAIN_STATE_POWER_LIMIT_SET;
+		start_periodic_polling();
+		set_pkg_thermal_irq(false);
+	} else {
+		/* may stop polling if no pending events */
+		rapl_write_data_raw(rd, &rpi[pl1_enable], 0);
+		rapl_write_data_raw(rd, &rpi[pl1_clamp], 0);
+		rd->state &= ~DOMAIN_STATE_POWER_LIMIT_SET;
+		set_pkg_thermal_irq(true);
+	}
+
+	return 0;
+}
+
+static const struct thermal_cooling_device_ops rapl_cdev_ops = {
+	.get_max_state = rapl_get_max_state,
+	.get_cur_state = rapl_get_cur_state,
+	.set_cur_state = rapl_set_cur_state,
+};
+
+static const struct x86_cpu_id intel_rapl_ids[] = {
+	{ X86_VENDOR_INTEL, 6, 0x2a},/* SNB */
+	{ X86_VENDOR_INTEL, 6, 0x2d},
+	{ X86_VENDOR_INTEL, 6, 0x3a},/* IVB */
+	{ X86_VENDOR_INTEL, 6, 0x45},/* HSW */
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, intel_rapl_ids);
+
+static ssize_t show_domain_name(struct rapl_domain *rd, char *buf)
+{
+	return sprintf(buf, "%s\n", rd->name);
+}
+
+static ssize_t show_power(struct rapl_domain *rd, char *buf)
+{
+	return sprintf(buf, "%lu\n", rd->rdd->primitives[power]);
+}
+
+static ssize_t show_event_control(struct rapl_domain *rd, char *buf)
+{
+	struct rapl_event *event;
+	struct rapl_event *tmp;
+	int ret = 0;
+	int i = 0;
+
+	/* show a list of active event name, threshold, counter */
+	list_for_each_entry_safe(event, tmp, &rd->event_list, list) {
+		ret += sprintf(buf, "%s%.16s %lu %lu\n",
+			buf, rpi[event->prim].name, event->thresholds.value,
+			event->counter);
+		if (++i > MAX_RAPL_THRESHOLDS)
+			break;
+	}
+
+	return ret;
+}
+
+/* Gets called on POLLHUP on eventfd when user closes it. */
+static int rapl_event_wake(wait_queue_t *wait, unsigned mode,
+			int sync, void *key)
+{
+	struct rapl_event *event = container_of(wait, struct rapl_event, wait);
+	unsigned long flags = (unsigned long)key;
+
+	if (flags & POLLHUP) {
+		pr_debug("user closed efd, remove event\n");
+		spin_lock(&event->rd->event_lock);
+		if (!list_empty(&event->list)) {
+			list_del_init(&event->list);
+			schedule_work(&event->remove);
+			event->rd->rdd->events[event->prim] = NULL;
+		}
+		spin_unlock(&event->rd->event_lock);
+	}
+
+	return 0;
+}
+
+static void rapl_event_ptable_queue(struct file *file,
+		wait_queue_head_t *wqh, poll_table *pt)
+{
+	struct rapl_event *event = container_of(pt, struct rapl_event, pt);
+
+	event->wqh = wqh;
+	add_wait_queue(wqh, &event->wait);
+}
+
+static void rapl_event_remove(struct work_struct *work)
+{
+	struct rapl_event *event = container_of(work, struct rapl_event,
+						remove);
+
+	remove_wait_queue(event->wqh, &event->wait);
+	eventfd_signal(event->thresholds.eventfd, 1);
+	eventfd_ctx_put(event->thresholds.eventfd);
+	kfree(event);
+}
+
+
+/*
+ * Handles userspace writes to event_control file. For a given domain, the
+ * format is  <eventfd> <command file fd> <threshold value> in the buffer.
+ */
+static ssize_t store_event_control(struct rapl_domain *rd, const char *buf,
+				size_t size)
+{
+	unsigned int efd, cfd, new_threshold;
+	struct file *efile = NULL;
+	struct file *cfile = NULL;
+	int ret = 0;
+	int prim;
+	struct rapl_event *ep;
+	u64 val;
+
+	if (sscanf(buf, "%u %u %u", &efd, &cfd, &new_threshold) != 3)
+		return -EINVAL;
+
+	efile = eventfd_fget(efd);
+	if (IS_ERR(efile)) {
+		ret = PTR_ERR(efile);
+		pr_err("failed to get eventfd file %d\n", efd);
+		goto done;
+	}
+	cfile = fget(cfd);
+	if (!cfile) {
+		ret = -EBADF;
+		fput(efile);
+		goto done;
+	}
+	/* check if the cfile belongs to the same rapl domain */
+	if (strcmp(rd->kobj.sd->s_name,
+			cfile->f_dentry->d_parent->d_name.name)) {
+		pr_debug("cfile does not belong to domain %s\n",
+			rd->kobj.sd->s_name);
+		ret = -EINVAL;
+		goto exit_cleanup_fds;
+	}
+	prim = primitive_name_to_entry(
+		(const char *)cfile->f_dentry->d_name.name);
+	if (prim < 0) {
+		pr_err("failed lookup primitive id for control file %s\n",
+			cfile->f_dentry->d_name.name);
+		ret = -EINVAL;
+		goto exit_cleanup_fds;
+	}
+	if (!(rpi[prim].flag & RAPL_PRIMITIVE_EVENT_CAP)) {
+		pr_info("Invalid control file %d\n", prim);
+		ret = -EINVAL;
+		goto exit_cleanup_fds;
+	}
+
+	/*
+	 * Check if there is already an event registered to this control file.
+	 * If yes, we notify the current efd then replace the event with the
+	 * new efd/cfd/threshold. If new threshold value is 0, we delete the
+	 * event after the user gets notified.
+	 */
+	ep = rd->rdd->events[prim];
+	if (!new_threshold || ep) {
+		if (!ep) {
+			ret = -EINVAL;
+			goto exit_cleanup_fds;
+		}
+		pr_debug("delete: d:%s e:%d c:%d thrd:%s prim:%d val %lu\n",
+			rd->name, efd, cfd, cfile->f_dentry->d_name.name, prim,
+			ep->thresholds.value);
+		spin_lock(&rd->event_lock);
+		list_del_init(&ep->list);
+		spin_unlock(&rd->event_lock);
+
+		/* Notify user event is deleted, user has to figure out the
+		 * current state. i.e. check event_control file to see if
+		 * its threshold is in the active event list.
+		 */
+		rapl_event_remove(&ep->remove);
+		if (list_empty(&rd->event_list))
+			rd->state &= ~DOMAIN_STATE_EVENT_SET;
+		rd->rdd->events[prim] = NULL;
+
+		if (!new_threshold)
+			goto done;
+	}
+
+	ep = kzalloc(sizeof(struct rapl_event), GFP_KERNEL);
+	if (!ep) {
+		ret = -ENOMEM;
+		goto exit_cleanup_fds;
+	}
+	rd->rdd->events[prim] = ep;
+	ep->prim = prim;
+	ep->thresholds.eventfd = eventfd_ctx_fileget(efile);
+	if (IS_ERR(ep->thresholds.eventfd)) {
+		pr_err("failed to get eventfd ctx %d\n", efd);
+		ret = PTR_ERR(ep->thresholds.eventfd);
+		kfree(ep);
+		goto exit_cleanup_fds;
+	}
+
+	ret = rapl_read_data_raw(rd, &rpi[prim], true, &val);
+	if (ret) {
+		pr_debug(" failed to read event.\n");
+		rd->rdd->events[prim] = NULL;
+		kfree(ep);
+		goto exit_cleanup_fds;
+	}
+	init_poll_funcptr(&ep->pt, rapl_event_ptable_queue);
+	init_waitqueue_func_entry(&ep->wait, rapl_event_wake);
+	INIT_WORK(&ep->remove, rapl_event_remove);
+	if (efile->f_op->poll(efile, &ep->pt) & POLLHUP) {
+		schedule_work(&ep->remove);
+		goto exit_cleanup_fds;
+	}
+
+	ep->last_val = val;
+	ep->rd = rd;
+	INIT_LIST_HEAD(&ep->list);
+	spin_lock(&rd->event_lock);
+	list_add(&ep->list, &rd->event_list);
+	spin_unlock(&rd->event_lock);
+
+	ep->thresholds.value = new_threshold;
+	pr_debug("domain:%s efd:%d cfd:%d threshold:%s, prim:%d val %lu\n",
+		rd->name, efd, cfd, cfile->f_dentry->d_name.name, prim,
+		ep->thresholds.value);
+
+	/* start update all data */
+	rd->state |= DOMAIN_STATE_EVENT_SET;
+	smp_wmb();
+	start_periodic_polling();
+
+exit_cleanup_fds:
+	fput(cfile);
+	fput(efile);
+
+done:
+	if (ret)
+		return ret;
+
+	return size;
+}
+
+#define STORE_PRIMITIVE(n)						\
+	static ssize_t store_ ## n(struct rapl_domain *rd,		\
+				const char *buf, size_t size)		\
+	{								\
+	unsigned long long new;						\
+	int i = primitive_name_to_entry(#n);				\
+	if (i < 0)							\
+		return -EIO;						\
+	if (kstrtoull(buf, 0, &new) < 0)				\
+		return -EINVAL;						\
+	rapl_write_data_raw(rd, &rpi[i], new);				\
+	return size;							\
+}
+
+static ssize_t intel_rapl_show(struct kobject *kobj,
+			struct attribute *attr, char *buf)
+{
+	struct rapl_domain *rd = kobj_to_rapl_domain(kobj);
+	struct rapl_attr *ra = to_rapl_attr(attr);
+
+	return ra->show ? ra->show(rd, buf) : -EIO;
+}
+
+static ssize_t intel_rapl_store(struct kobject *kobj,
+	struct attribute *attr, const char *buf, size_t size)
+{
+	struct rapl_domain *rd = kobj_to_rapl_domain(kobj);
+	struct rapl_attr *ra = to_rapl_attr(attr);
+
+	return ra->store ? ra->store(rd, buf, size) : -EIO;
+}
+
+static const struct sysfs_ops intel_rapl_sysfs_ops = {
+	.show = intel_rapl_show,
+	.store = intel_rapl_store,
+};
+
+SHOW_PRIMITIVE(energy)
+SHOW_PRIMITIVE(power_limit1)
+SHOW_PRIMITIVE(power_limit2)
+SHOW_PRIMITIVE(lock)
+SHOW_PRIMITIVE(pl1_enable)
+SHOW_PRIMITIVE(pl2_enable)
+SHOW_PRIMITIVE(pl1_clamp)
+SHOW_PRIMITIVE(pl2_clamp)
+SHOW_PRIMITIVE(time_window1)
+SHOW_PRIMITIVE(time_window2)
+SHOW_PRIMITIVE(thermal_spec_power)
+SHOW_PRIMITIVE(max_power)
+SHOW_PRIMITIVE(min_power)
+SHOW_PRIMITIVE(max_window)
+SHOW_PRIMITIVE(throttle_time)
+SHOW_PRIMITIVE(prio_level)
+
+STORE_PRIMITIVE(power_limit1)
+STORE_PRIMITIVE(power_limit2)
+STORE_PRIMITIVE(time_window1)
+STORE_PRIMITIVE(time_window2)
+STORE_PRIMITIVE(pl1_enable)
+STORE_PRIMITIVE(pl2_enable)
+STORE_PRIMITIVE(pl1_clamp)
+STORE_PRIMITIVE(pl2_clamp)
+
+#define RW_ATTR(val)							\
+	static struct rapl_attr attr_## val = {				\
+		.attr	= {.name = __stringify(val), .mode = 0644 },	\
+		.show	= show_## val,					\
+		.store	= store_## val,					\
+	};
+
+#define RO_ATTR(val)							\
+	static struct rapl_attr attr_## val = {				\
+		.attr	= {.name = __stringify(val), .mode = 0444 },	\
+		.show	= show_## val,					\
+		.store	= NULL,						\
+	};
+
+RO_ATTR(energy);
+RO_ATTR(power);
+RO_ATTR(domain_name);
+RO_ATTR(lock);
+RO_ATTR(thermal_spec_power);
+RO_ATTR(max_power);
+RO_ATTR(min_power);
+RO_ATTR(max_window);
+RO_ATTR(throttle_time);
+RO_ATTR(prio_level);
+
+RW_ATTR(power_limit1);
+RW_ATTR(power_limit2);
+RW_ATTR(time_window1);
+RW_ATTR(time_window2);
+RW_ATTR(pl1_enable);
+RW_ATTR(pl2_enable);
+RW_ATTR(pl1_clamp);
+RW_ATTR(pl2_clamp);
+RW_ATTR(event_control);
+
+/* listed in the order of rapl_primitives such that attrs can be indexed and
+ * assigned to per domain attrs based on its availability.
+ */
+static struct attribute *all_attrs[] = {
+	&attr_energy.attr,
+	&attr_power_limit1.attr,
+	&attr_power_limit2.attr,
+	&attr_lock.attr,
+
+	&attr_pl1_enable.attr,
+	&attr_pl1_clamp.attr,
+	&attr_pl2_enable.attr,
+	&attr_pl2_clamp.attr,
+
+	&attr_time_window1.attr,
+	&attr_time_window2.attr,
+	&attr_thermal_spec_power.attr,
+	&attr_max_power.attr,
+
+	&attr_min_power.attr,
+	&attr_max_window.attr,
+	&attr_throttle_time.attr,
+	&attr_prio_level.attr,
+
+	&attr_power.attr,
+	&attr_event_control.attr,
+	&attr_domain_name.attr,
+	NULL,
+};
+
+#define SHOW_GLOBAL_DATA(n)						\
+	static ssize_t show_ ## n(struct kobject *s,			\
+				struct kobj_attribute *a,		\
+				char *buf)				\
+	{								\
+		return sprintf(buf, "%d\n", rg_data.n);			\
+	}
+
+#define STORE_GLOBAL_DATA(n)						\
+	static ssize_t store_ ## n(struct kobject *s,			\
+					struct kobj_attribute *a,	\
+					const char *buf, size_t size)	\
+	{								\
+		unsigned long new;					\
+		if (kstrtoul(buf, 0, &new) < 0)				\
+			return -EINVAL;					\
+		rg_data.n = new;					\
+		return size;						\
+	}
+
+SHOW_GLOBAL_DATA(polling_freq_hz)
+SHOW_GLOBAL_DATA(energy_unit_divisor)
+SHOW_GLOBAL_DATA(power_unit_divisor)
+SHOW_GLOBAL_DATA(time_unit_divisor)
+
+STORE_GLOBAL_DATA(polling_freq_hz)
+STORE_GLOBAL_DATA(energy_unit_divisor)
+STORE_GLOBAL_DATA(power_unit_divisor)
+STORE_GLOBAL_DATA(time_unit_divisor)
+
+#define GLOBAL_ATTR(n)				\
+	static struct kobj_attribute n =	\
+		__ATTR(n, 0644,			\
+			show_ ##n,		\
+			store_ ##n		\
+			);
+
+GLOBAL_ATTR(energy_unit_divisor);
+GLOBAL_ATTR(power_unit_divisor);
+GLOBAL_ATTR(time_unit_divisor);
+GLOBAL_ATTR(polling_freq_hz);
+
+static const struct attribute *global_attrs[] = {
+	&energy_unit_divisor.attr,
+	&power_unit_divisor.attr,
+	&time_unit_divisor.attr,
+	&polling_freq_hz.attr,
+	NULL,
+};
+
+static void rapl_domain_kobj_release(struct kobject *kobj)
+{
+	struct rapl_domain *rd = kobj_to_rapl_domain(kobj);
+
+	complete(&rd->kobj_unregister);
+}
+
+static struct kobj_type ktype_intel_rapl = {
+	.sysfs_ops = &intel_rapl_sysfs_ops,
+	.release = rapl_domain_kobj_release,
+};
+
+static void rapl_update_domain_data(void)
+{
+	int i, j;
+	u64 val;
+	bool xlate;
+
+	for (i = 0; i < rg_data.nr_domains; i++) {
+		/* exclude non-raw primitives */
+		for (j = 0; j < NR_RAW_PRIMITIVES; j++)
+			xlate = !!(rpi[j].unit);
+			if (!rapl_read_data_raw(&rapl_domains[i], &rpi[j],
+							xlate, &val))
+				rd_data[i].primitives[j] = val;
+	}
+}
+
+static struct attribute **rapl_domain_attrs(int id)
+{
+	struct attribute **attrs;
+	int i = 0, j = 0, n;
+	unsigned long map;
+
+	map = rapl_domains[id].attr_map;
+	n = bitmap_weight(&map, nr_rapl_primitives);
+	/* allocate an extra entry for NULL */
+	attrs = kzalloc((n + 1) * sizeof(struct attribute *), GFP_KERNEL);
+	if (NULL == attrs)
+		return NULL;
+
+	/* fill in attrs with bitmap selected entries from all attrs */
+	do {
+		if (map & 1)
+			attrs[i++] = all_attrs[j];
+		j++;
+		map = map >> 1;
+	} while (map && i < n);
+	rapl_domains[id].attrs = attrs;
+
+	return attrs;
+}
+
+static int intel_rapl_probe(struct platform_device *pdev)
+{
+	int id = 0;
+	int ret = 0;
+	struct thermal_cooling_device *cdev;
+
+	rapl_update_domain_data();
+	for (id = 0; id < rg_data.nr_domains; id++) {
+		/*
+		 * create kobj for each rapl domain then link them with
+		 * generic thermal sysfs
+		 */
+		init_completion(&rapl_domains[id].kobj_unregister);
+		if (rapl_kset)
+			rapl_domains[id].kobj.kset = rapl_kset;
+
+		ktype_intel_rapl.default_attrs = rapl_domain_attrs(id);
+		ret = kobject_init_and_add(&rapl_domains[id].kobj,
+					&ktype_intel_rapl, NULL,
+					"%.32s", rapl_domains[id].name);
+		if (ret) {
+			pr_err("unable to create kobj for domain %s\n",
+				rapl_domains[id].name);
+			goto end;
+		}
+		cdev = thermal_cooling_device_register(DRIVER_NAME,
+						&rapl_domains[id],
+						&rapl_cdev_ops);
+		if (IS_ERR(cdev)) {
+			kobject_del(&rapl_domains[id].kobj);
+			ret = PTR_ERR(cdev);
+			goto end;
+		}
+		kobject_uevent(&rapl_domains[id].kobj, KOBJ_ADD);
+
+		rapl_domains[id].cool_dev = cdev;
+		pr_info("registered RAPL domain %s as cooling device\n",
+			rapl_domains[id].name);
+
+		ret = sysfs_create_link(&rapl_domains[id].kobj,
+					&cdev->device.kobj, "thermal_cooling");
+		if (ret)
+			dev_err(&intel_rapl_device.dev,
+				"Failed to create thermal_cooling link for domain %d %s\n",
+				id, rapl_domains[id].name);
+
+		ret = sysfs_create_link(&cdev->device.kobj,
+					&rapl_domains[id].kobj,
+					"device");
+		if (ret)
+			dev_err(&intel_rapl_device.dev,
+				"Failed to create device link for domain %d %s\n",
+				id, rapl_domains[id].name);
+	}
+
+	if (rapl_kset)
+		ret = sysfs_create_files(&rapl_kset->kobj, global_attrs);
+
+end:
+
+	return ret;
+}
+
+static int intel_rapl_remove(struct platform_device *pdev)
+{
+	enum rapl_domain_id id;
+	struct rapl_event *event;
+	struct rapl_event *tmp;
+	struct rapl_domain *rd;
+
+	stop_periodic_polling();
+	set_pkg_thermal_irq(true);
+
+	for (id = 0; id < rg_data.nr_domains; id++) {
+		pr_debug("Remove %s device\n", rapl_domains[id].name);
+		rd = &rapl_domains[id];
+		rapl_write_data_raw(rd, &rpi[pl1_enable], 0);
+		sysfs_remove_files(&rd->kobj,
+				(const struct attribute **)rd->attrs);
+		list_for_each_entry_safe(event, tmp, &rd->event_list, list) {
+			pr_debug("free event %s, threshold %lu\n",
+				rd->name, event->thresholds.value);
+			spin_lock(&rd->event_lock);
+			schedule_work(&event->remove);
+			list_del(&event->list);
+			spin_unlock(&rd->event_lock);
+		}
+
+		sysfs_remove_link(&rd->cool_dev->device.kobj, "device");
+		sysfs_remove_link(&rd->kobj, "thermal_cooling");
+		thermal_cooling_device_unregister(rd->cool_dev);
+
+		kobject_uevent(&rd->kobj, KOBJ_REMOVE);
+		kobject_del(&rd->kobj);
+		kobject_put(&rd->kobj);
+		wait_for_completion(&rapl_domains[id].kobj_unregister);
+		kfree(rd->attrs);
+	}
+	sysfs_remove_files(&rapl_kset->kobj, global_attrs);
+
+	return 0;
+}
+
+static struct platform_driver intel_rapl_driver = {
+	.driver = {
+		.name = DRIVER_NAME,
+		.owner = THIS_MODULE,
+	},
+	.probe = intel_rapl_probe,
+	.remove = intel_rapl_remove,
+};
+
+static int rapl_update_data(void)
+{
+	int i, ret;
+	static u64 energy_last[RAPL_DOMAIN_MAX];
+	u64 energy_now[RAPL_DOMAIN_MAX];
+
+	/* collect raw data for calculation */
+	for (i = 0; i < rg_data.nr_domains; i++) {
+		ret = rapl_read_data_raw(&rapl_domains[i], &rpi[energy], false,
+					&energy_now[i]);
+		if (ret)
+			return ret;
+	}
+	/* first time reading */
+	if (energy_last[0] == 0)
+		goto exit;
+
+	for (i = 0; i < rg_data.nr_domains; i++) {
+		unsigned long energy_raw = energy_now[i] - energy_last[i];
+		rd_data[i].primitives[power] = div64_u64(
+			rapl_unit_xlate(ENERGY_UNIT, energy_raw, 0),
+			rg_data.polling_freq_hz);
+	}
+exit:
+	memcpy(energy_last, energy_now, sizeof(energy_now));
+
+	return 0;
+}
+
+/* check and send eventfd notifications to the userspace for all domains
+ */
+static void rapl_check_events(void)
+{
+	struct rapl_event *event, *tmp;
+	struct rapl_domain *rd;
+	int i;
+	u64 cur;
+
+	/* run through per domain, per primitive thresholds */
+	for (i = 0; i < rg_data.nr_domains; i++) {
+		rd = &rapl_domains[i];
+		if (!(rd->state & DOMAIN_STATE_EVENT_SET))
+			continue;
+		list_for_each_entry_safe(event, tmp, &rd->event_list, list) {
+			if (rapl_read_data_raw(rd, &rpi[event->prim],
+						true, &cur)) {
+				pr_err("efd failed dmn:%s prim %d\n", rd->name,
+					event->prim);
+				continue;
+			}
+
+			/* check if we crossed threshold in both direction */
+			if ((event->thresholds.value > event->last_val &&
+					event->thresholds.value < cur) ||
+				(event->thresholds.value < event->last_val &&
+					event->thresholds.value > cur)) {
+				eventfd_signal(event->thresholds.eventfd, 1);
+				event->counter++;
+			}
+			event->last_val = cur;
+		}
+	}
+}
+
+/* For time based data, e.g. average power */
+static void rapl_poll_data(struct work_struct *dummy)
+{
+	rapl_update_data();
+	rapl_check_events();
+	if (!rapl_polling_should_cont()) {
+		polling_started = false;
+		return;
+	}
+	schedule_delayed_work(&rapl_polling_work,
+			round_jiffies_relative(rg_data.polling_freq_hz*HZ));
+}
+
+static int start_periodic_polling(void)
+{
+	if (true == polling_started)
+		goto out;
+	schedule_delayed_work(&rapl_polling_work, 0);
+	polling_started = true;
+
+out:
+	return 0;
+}
+
+static int stop_periodic_polling(void)
+{
+	if (true == polling_started) {
+		cancel_delayed_work_sync(&rapl_polling_work);
+		polling_started = false;
+		pr_debug("stop polling rapl data\n");
+	}
+
+	return 0;
+}
+
+static void intel_rapl_dev_release(struct device *dev)
+{
+	return;
+}
+
+static int rapl_check_energy_cnt(enum rapl_domain_id id)
+{
+	unsigned msr;
+	unsigned long long val1, val2;
+	int retry = 0;
+
+	switch (id) {
+	case RAPL_DOMAIN_PKG:
+		msr = MSR_PKG_ENERGY_STATUS;
+		break;
+	case RAPL_DOMAIN_PP0:
+		msr = MSR_PP0_ENERGY_STATUS;
+		break;
+	case RAPL_DOMAIN_PP1:
+		msr = MSR_PP1_ENERGY_STATUS;
+		break;
+	case RAPL_DOMAIN_DRAM:
+		msr = MSR_DRAM_ENERGY_STATUS;
+		break;
+	default:
+		pr_err("invalid domain id %d\n", id);
+		return -EINVAL;
+	}
+	if (rdmsrl_safe(msr, &val1))
+		return -ENODEV;
+again:
+	/* energy counters roll slowly on some domains, do a few retries */
+	msleep(100);
+	rdmsrl_safe(msr, &val2);
+
+	/* if energy counter does not change, report as bad domain */
+	if ((val1 & ENERGY_STATUS_MASK) == (val2 & ENERGY_STATUS_MASK)) {
+		if (retry++ < 10)
+			goto again;
+		pr_info("domain %s exists but energy ctr %llu:%llu not working, skip\n",
+			rapl_domain_names[id], val1, val2);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int rapl_detect_domains(void)
+{
+	int i;
+	int ret = 0;
+
+	if (!x86_match_cpu(intel_rapl_ids)) {
+		ret = -ENODEV;
+		goto done;
+	}
+
+	for (i = 0; i < RAPL_DOMAIN_MAX; i++) {
+		if (!rapl_check_energy_cnt(i))
+			rg_data.domain_map |= 1 << i;
+	}
+
+	rg_data.nr_domains = bitmap_weight(&rg_data.domain_map,
+					RAPL_DOMAIN_MAX);
+	if (!rg_data.nr_domains) {
+		pr_err("no valid rapl domains found\n");
+		ret = -ENODEV;
+		goto done;
+	}
+	rg_data.polling_freq_hz = RAPL_POLLING_FREQ_DEFAULT;
+
+	pr_info("Found %d vaild RAPL domains\n", rg_data.nr_domains);
+	rapl_domains = kzalloc(sizeof(struct rapl_domain) * rg_data.nr_domains,
+			GFP_KERNEL);
+	if (NULL == rapl_domains) {
+		pr_err("Failed to allocate memory for rapl domain\n");
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	rapl_init_domains();
+
+done:
+	return ret;
+}
+
+static int __init intel_rapl_init(void)
+{
+	int i, ret;
+
+	ret = rapl_check_unit();
+	if (ret)
+		return ret;
+
+	ret = rapl_detect_domains();
+	if (ret)
+		return ret;
+	/* allocate per domain data */
+	rd_data = kzalloc(sizeof(struct rapl_domain_data) * rg_data.nr_domains,
+			GFP_KERNEL);
+	if (NULL == rd_data) {
+		pr_err("Failed to allocate memory for rapl domain data\n");
+		ret = -ENOMEM;
+		goto exit_free_domains;
+	}
+	for (i = 0; i < rg_data.nr_domains; i++) {
+		rapl_domains[i].rdd = &rd_data[i];
+		INIT_LIST_HEAD(&rapl_domains[i].event_list);
+		spin_lock_init(&rapl_domains[i].event_lock);
+	}
+	intel_rapl_device.dev.release = intel_rapl_dev_release;
+	intel_rapl_device.dev.platform_data = rapl_domains;
+
+	platform_device_register(&intel_rapl_device);
+	/* rapl kset used as base class to abstract common attrs */
+	rapl_kset = kset_create_and_add("rapl_domains", NULL,
+					&intel_rapl_device.dev.kobj);
+	if (!rapl_kset) {
+		ret = -ENOMEM;
+		goto exit_free_rdata;
+	}
+	ret = platform_driver_register(&intel_rapl_driver);
+	if (ret)
+		goto exit_unregister_device;
+
+	return 0;
+
+exit_unregister_device:
+	kset_unregister(rapl_kset);
+	platform_device_unregister(&intel_rapl_device);
+exit_free_rdata:
+	kfree(rd_data);
+exit_free_domains:
+	kfree(rapl_domains);
+
+	return ret;
+}
+
+static void __exit intel_rapl_exit(void)
+{
+	platform_device_unregister(&intel_rapl_device);
+	platform_driver_unregister(&intel_rapl_driver);
+	kfree(rd_data);
+	kfree(rapl_domains);
+	kset_unregister(rapl_kset);
+}
+
+
+module_init(intel_rapl_init);
+module_exit(intel_rapl_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jacob Pan <jacob.jun.pan@intel.com>");
+
+MODULE_DESCRIPTION("Driver for Intel RAPL (Running Average Power Limit) interface");
+MODULE_VERSION("0.1");
diff --git a/drivers/platform/x86/intel_rapl.h b/drivers/platform/x86/intel_rapl.h
new file mode 100644
index 0000000..e0a5125
--- /dev/null
+++ b/drivers/platform/x86/intel_rapl.h
@@ -0,0 +1,249 @@
+/*
+ *  Intel RAPL driver
+ *
+ *  intel_rapl.h
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or (at
+ *  your option) any later version.
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
+#ifndef INTEL_RAPL_H
+#define INTEL_RAPL_H
+
+#define DRIVER_NAME "intel_rapl"
+
+/* RAPL UNIT BITMASK */
+#define ENERGY_STATUS_MASK      0xffffffff
+
+#define POWER_LIMIT1_MASK       0x7FFF
+#define POWER_LIMIT1_ENABLE     (0x1<<15)
+#define POWER_LIMIT1_CLAMP      (0x1<<16)
+
+#define POWER_LIMIT2_MASK       (0x7FFFULL<<32)
+#define POWER_LIMIT2_ENABLE     (0x1ULL<<47)
+#define POWER_LIMIT2_CLAMP      (0x1ULL<<48)
+#define POWER_PKG_LOCK          (0x1ULL<<63)
+#define POWER_PP_LOCK           (0x1<<31)
+
+#define TIME_WINDOW1_MASK       (0x7F<<17)
+#define TIME_WINDOW2_MASK       (0x7FULL<<49)
+
+#define POWER_UNIT_OFFSET	0
+#define POWER_UNIT_MASK		0x0F
+
+#define ENERGY_UNIT_OFFSET	0x08
+#define ENERGY_UNIT_MASK	0x1F00
+
+#define TIME_UNIT_OFFSET	0x10
+#define TIME_UNIT_MASK		0xF0000
+
+#define POWER_INFO_MAX_MASK     (0x7fffULL<<32)
+#define POWER_INFO_MIN_MASK     (0x7fffULL<<16)
+#define POWER_INFO_MAX_TIME_WIN_MASK     (0x3fULL<<48)
+#define POWER_INFO_THERMAL_SPEC_MASK     0x7fff
+
+#define PERF_STATUS_THROTTLE_TIME_MASK 0xffffffff
+#define PP_POLICY_MASK         0x1F
+/* Non HW constants */
+
+/* Event capable, allow assigning thresholds */
+#define RAPL_PRIMITIVE_EVENT_CAP     (1<<0)
+#define RAPL_PRIMITIVE_DERIVED       (1<<1) /* not from raw data */
+#define RAPL_PRIMITIVE_DUMMY         (1<<2)
+#define RAPL_POLLING_FREQ_DEFAULT    1
+
+/* scale RAPL units to avoid floating point math inside kernel */
+#define POWER_UNIT_SCALE  (1000)
+#define ENERGY_UNIT_SCALE (1000)
+#define TIME_UNIT_SCALE   (1000)
+
+enum unit_type {
+	NA_UNIT, /* no translation */
+	POWER_UNIT,
+	ENERGY_UNIT,
+	TIME_UNIT,
+};
+
+enum rapl_domain_id {
+	RAPL_DOMAIN_PKG,
+	RAPL_DOMAIN_PP0,
+	RAPL_DOMAIN_PP1,
+	RAPL_DOMAIN_DRAM,
+	RAPL_DOMAIN_MAX,
+};
+
+enum rapl_domain_msr_id {
+	RAPL_DOMAIN_MSR_LIMIT,
+	RAPL_DOMAIN_MSR_STATUS,
+	RAPL_DOMAIN_MSR_PERF,
+	RAPL_DOMAIN_MSR_POLICY,
+	RAPL_DOMAIN_MSR_INFO,
+	RAPL_DOMAIN_MSR_MAX,
+};
+
+struct rapl_domain_msr {
+	int	limit;
+	int	status;
+	/* optional msrs below */
+	int	perf;
+	int     policy;
+	int     info; /* power info */
+};
+
+
+#define	DOMAIN_STATE_INACTIVE           (0)
+#define	DOMAIN_STATE_POWER_LIMIT_SET    (1<<1)
+#define	DOMAIN_STATE_EVENT_SET          (1<<2)
+
+struct rapl_domain {
+	char *name;
+	enum rapl_domain_id id;
+	int msrs[RAPL_DOMAIN_MSR_MAX];
+	struct thermal_zone_device *tz_dev;
+	struct thermal_cooling_device *cool_dev;
+	struct completion kobj_unregister;
+	struct kobject kobj;
+	struct rapl_domain_data *rdd;
+	struct list_head event_list;
+	unsigned long attr_map; /* bitmap for per domain features */
+	struct attribute **attrs;
+	spinlock_t event_lock; /* protect event queue */
+	unsigned int state;
+};
+
+/*  global data */
+struct rapl_data {
+	unsigned int nr_domains;
+	unsigned long domain_map; /* bit map of active domains */
+	unsigned int power_unit_divisor;
+	unsigned int energy_unit_divisor;
+	unsigned int time_unit_divisor;
+	unsigned int polling_freq_hz;
+};
+
+enum rapl_primitives {
+	energy,
+	power_limit1,
+	power_limit2,
+	lock,
+
+	pl1_enable,
+	pl1_clamp,
+	pl2_enable,
+	pl2_clamp,
+
+	time_window1,
+	time_window2,
+	thermal_spec_power,
+	max_power,
+
+	min_power,
+	max_window,
+	throttle_time,
+	prio_level,
+
+	/* below are not raw primitive data */
+	power,
+	event_control,
+	domain_name,
+	nr_rapl_primitives,
+};
+
+#define NR_RAW_PRIMITIVES (nr_rapl_primitives - 3)
+/*
+ * RAPL domains have a base set of attrs then on top of that each domain
+ * may have optional attrs. We need to expose only relavent sysfs nodes
+ * for each attr per supported domain. Use ULL bit mask to represent both
+ * standard and optional features.
+ */
+
+/* standard attrs */
+#define RAPL_ATTR_ENERGY_CTR             BIT(energy)
+#define RAPL_ATTR_PL1                    BIT(power_limit1)
+#define RAPL_ATTR_LOCK                   BIT(lock)
+
+#define RAPL_ATTR_PL1_ENABLE             BIT(pl1_enable)
+#define RAPL_ATTR_PL1_CLAMP              BIT(pl1_clamp)
+#define RAPL_ATTR_DOMAIN_NAME            BIT(domain_name)
+#define RAPL_ATTR_EVENT_CONTROL          BIT(event_control)
+#define RAPL_ATTR_POWER                  BIT(power)
+#define RAPL_ATTR_TIME_WINDOW1           BIT(time_window1)
+
+/* optional attrs */
+#define RAPL_ATTR_PL2                    BIT(power_limit2)
+#define RAPL_ATTR_PL2_ENABLE             BIT(pl2_enable)
+#define RAPL_ATTR_PL2_CLAMP              BIT(pl2_clamp)
+#define RAPL_ATTR_TIME_WINDOW2           BIT(time_window2)
+#define RAPL_ATTR_THERMAL_SPEC_POWER     BIT(thermal_spec_power)
+#define RAPL_ATTR_MAX_POWER              BIT(max_power)
+#define RAPL_ATTR_MIN_POWER              BIT(min_power)
+#define RAPL_ATTR_MAX_WINDOW             BIT(max_window)
+#define RAPL_ATTR_THROTTLE_TIME          BIT(throttle_time)
+#define RAPL_ATTR_PRIO_LEVEL             BIT(prio_level)
+
+#define RAPL_STANDARD_ATTRS (RAPL_ATTR_ENERGY_CTR |		\
+				RAPL_ATTR_PL1 |			\
+				RAPL_ATTR_LOCK |		\
+				RAPL_ATTR_PL1_ENABLE |		\
+				RAPL_ATTR_PL1_CLAMP |		\
+				RAPL_ATTR_TIME_WINDOW1 |	\
+				RAPL_ATTR_POWER |		\
+				RAPL_ATTR_DOMAIN_NAME |		\
+				RAPL_ATTR_EVENT_CONTROL)
+
+struct rapl_attr {
+	struct attribute attr;
+	ssize_t (*show) (struct rapl_domain *, char *);
+	ssize_t (*store) (struct rapl_domain *, const char *, size_t count);
+};
+
+struct rapl_threshold {
+	unsigned long value;
+	struct eventfd_ctx *eventfd;
+};
+
+#define MAX_RAPL_THRESHOLDS 3
+
+struct rapl_event {
+	struct list_head list;
+	struct rapl_domain *rd;
+	struct rapl_threshold thresholds;
+	unsigned long counter; /* # of times threshold crossed */
+	unsigned long last_val;
+	enum rapl_primitives prim;
+	poll_table pt;
+	wait_queue_head_t *wqh;
+	wait_queue_t wait;
+	struct work_struct remove;
+};
+
+struct rapl_domain_data {
+	unsigned long primitives[nr_rapl_primitives];
+	struct rapl_event *events[nr_rapl_primitives];
+};
+
+struct rapl_primitive_info {
+	const char *name;
+	u64 mask;
+	int shift;
+	enum rapl_domain_msr_id id;
+	enum unit_type unit;
+	enum rapl_primitives pm_id;
+	u32 flag;
+};
+
+#define PRIMITIVE_INFO_INIT(p, m, s, i, u, f) {#p, m, s, i, u, p, f}
+#endif  /* INTEL_RAPL_H */
-- 
1.7.9.5

