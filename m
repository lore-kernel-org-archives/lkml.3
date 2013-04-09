Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936708Ab3DIXq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:46:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:39901 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935320Ab3DIXqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:46:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,441,1363158000"; 
   d="scan'208";a="283975870"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v4 1/1] Introduce Intel RAPL cooling device driver
Date: Tue,  9 Apr 2013 16:46:49 -0700
Message-Id: <1365551209-14392-2-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365551209-14392-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1365551209-14392-1-git-send-email-jacob.jun.pan@linux.intel.com>
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

Zhang, Rui's initial RAPL driver was used as a reference and starting
point. Many thanks.
https://lkml.org/lkml/2011/5/26/93

Unlike the patch above, which is mainly for monitoring, this driver
focus on the control and usability by user applications.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/platform/x86/Kconfig      |    9 +
 drivers/platform/x86/Makefile     |    1 +
 drivers/platform/x86/intel_rapl.c |  889 +++++++++++++++++++++++++++++++++++++
 3 files changed, 899 insertions(+)
 create mode 100644 drivers/platform/x86/intel_rapl.c

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 3338437..34585b7 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -781,4 +781,13 @@ config APPLE_GMUX
 	  graphics as well as the backlight. Currently only backlight
 	  control is supported by the driver.
 
+config INTEL_RAPL
+	tristate "Intel RAPL Support"
+	depends on THERMAL
+	default n
+	---help---
+	  RAPL (Running Average Power Limit) provides mechanisms to enforce
+	  and monitor power limits of supported Intel CPUs. Limits can be
+	  set by RAPL domains such as package, core, graphics, etc.
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
index 0000000..7f5e80e
--- /dev/null
+++ b/drivers/platform/x86/intel_rapl.c
@@ -0,0 +1,889 @@
+/************************************************************************
+ *  intel_rapl.c - Intel Running Average Power Limit Driver for MSR based
+ *                 RAPL interface
+ *
+ *  Copyright (c) 2013, Intel Corporation.
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
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ *  USA
+ *
+ ************************************************************************/
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/thermal.h>
+#include <linux/slab.h>
+#include <linux/log2.h>
+#include <linux/bitmap.h>
+#include <linux/delay.h>
+#include <linux/sysfs.h>
+
+#include <asm/processor.h>
+#include <asm/cpu_device_id.h>
+
+
+/* RAPL UNIT BITMASK */
+#define ENERGY_STATUS_MASK      0xffffffff
+
+#define POWER_LIMIT1_MASK       0x7FFF
+#define POWER_LIMIT1_ENABLE     BIT(15)
+#define POWER_LIMIT1_CLAMP      BIT(16)
+
+#define POWER_LIMIT2_MASK       (0x7FFFULL<<32)
+#define POWER_LIMIT2_ENABLE     (0x1ULL<<47)
+#define POWER_LIMIT2_CLAMP      (0x1ULL<<48)
+#define POWER_PKG_LOCK          (0x1ULL<<63)
+#define POWER_PP_LOCK           BIT(31)
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
+
+/* Non HW constants */
+#define RAPL_PRIMITIVE_DERIVED       BIT(1) /* not from raw data */
+#define RAPL_PRIMITIVE_DUMMY         BIT(2)
+#define RAPL_POLLING_FREQ_DEFAULT    1
+
+/* scale RAPL units to avoid floating point math inside kernel */
+#define POWER_UNIT_SCALE     (1000)
+#define ENERGY_UNIT_SCALE    (1000)
+#define TIME_UNIT_SCALE      (1000)
+#define TIME_WINDOW1_DEFAULT  (1000)
+#define TIME_WINDOW2_DEFAULT  (3)
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
+#define	DOMAIN_STATE_INACTIVE           BIT(0)
+#define	DOMAIN_STATE_POWER_LIMIT_SET    BIT(1)
+
+struct rapl_domain {
+	const char *name;
+	enum rapl_domain_id id;
+	int msrs[RAPL_DOMAIN_MSR_MAX];
+	struct thermal_zone_device *tz_dev;
+	struct thermal_cooling_device *cool_dev;
+	struct rapl_domain_data *rdd;
+	unsigned int state;
+};
+
+/* per pkg data */
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
+	average_power,
+	nr_rapl_primitives,
+};
+
+#define NR_RAW_PRIMITIVES (nr_rapl_primitives - 2)
+
+/* REVISIT: to be expanded to include events, etc.*/
+struct rapl_domain_data {
+	unsigned long primitives[nr_rapl_primitives];
+};
+
+#define MAX_PRIM_NAME (32)
+
+struct rapl_primitive_info {
+	const char *name;
+	u64 mask;
+	int shift;
+	enum rapl_domain_msr_id id;
+	enum unit_type unit;
+	u32 flag;
+};
+
+#define PRIMITIVE_INFO_INIT(p, m, s, i, u, f) {	\
+		.name = #p,			\
+		.mask = m,			\
+		.shift = s,			\
+		.id = i,			\
+		.unit = u,			\
+		.flag = f			\
+	}
+
+static void rapl_poll_data(struct work_struct *dummy);
+static DECLARE_DELAYED_WORK(rapl_polling_work, rapl_poll_data);
+static bool polling_started;
+static int start_periodic_polling(void);
+static int stop_periodic_polling(void);
+static void rapl_init_domains(void);
+
+static struct rapl_domain *rapl_domains;
+static struct rapl_data rg_data; /* pkg data, common to all domains */
+static struct rapl_domain_data *rd_data;
+
+static const char * const rapl_domain_names[] = {
+	"package",
+	"power_plane_0",
+	"power_plane_1",
+	"dram",
+};
+
+
+
+/* called after domain detection and global data are set */
+static void rapl_init_domains(void)
+{
+	int i;
+	struct rapl_domain *rd;
+
+	rd = rapl_domains;
+	for (i = 0; i < RAPL_DOMAIN_MAX; i++) {
+		unsigned int mask = rg_data.domain_map & (1 << i);
+		switch (mask) {
+		case 1 << RAPL_DOMAIN_PKG:
+			rd->name = rapl_domain_names[RAPL_DOMAIN_PKG];
+			rd->id = RAPL_DOMAIN_PKG;
+			rd->msrs[0] = MSR_PKG_POWER_LIMIT;
+			rd->msrs[1] = MSR_PKG_ENERGY_STATUS;
+			rd->msrs[2] = MSR_PKG_PERF_STATUS;
+			rd->msrs[3] = 0;
+			rd->msrs[4] = MSR_PKG_POWER_INFO;
+			break;
+		case 1 << RAPL_DOMAIN_PP0:
+			rd->name = rapl_domain_names[RAPL_DOMAIN_PP0];
+			rd->id = RAPL_DOMAIN_PP0;
+			rd->msrs[0] = MSR_PP0_POWER_LIMIT;
+			rd->msrs[1] = MSR_PP0_ENERGY_STATUS;
+			rd->msrs[2] = 0;
+			rd->msrs[3] = MSR_PP0_POLICY;
+			rd->msrs[4] = 0;
+			break;
+		case 1 << RAPL_DOMAIN_PP1:
+			rd->name = rapl_domain_names[RAPL_DOMAIN_PP1];
+			rd->id = RAPL_DOMAIN_PP1;
+			rd->msrs[0] = MSR_PP1_POWER_LIMIT;
+			rd->msrs[1] = MSR_PP1_ENERGY_STATUS;
+			rd->msrs[2] = 0;
+			rd->msrs[3] = MSR_PP1_POLICY;
+			rd->msrs[4] = 0;
+			break;
+		case 1 << RAPL_DOMAIN_DRAM:
+			rd->name = rapl_domain_names[RAPL_DOMAIN_DRAM];
+			rd->id = RAPL_DOMAIN_DRAM;
+			rd->msrs[0] = MSR_DRAM_POWER_LIMIT;
+			rd->msrs[1] = MSR_DRAM_ENERGY_STATUS;
+			rd->msrs[2] = MSR_DRAM_PERF_STATUS;
+			rd->msrs[3] = 0;
+			rd->msrs[4] = MSR_DRAM_POWER_INFO;
+			break;
+		}
+		if (mask)
+			rd++;
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
+			RAPL_DOMAIN_MSR_STATUS, ENERGY_UNIT, 0),
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
+			RAPL_DOMAIN_MSR_PERF, TIME_UNIT, 0),
+	PRIMITIVE_INFO_INIT(prio_level, PP_POLICY_MASK, 0,
+			RAPL_DOMAIN_MSR_POLICY, NA_UNIT, 0),
+	/* non-hardware */
+	PRIMITIVE_INFO_INIT(average_power, 0, 0, 0, POWER_UNIT,
+			RAPL_PRIMITIVE_DERIVED),
+	{NULL, 0, 0, 0},
+};
+
+static int rapl_read_data_raw(struct rapl_domain *domain,
+			enum rapl_primitives prim,
+			bool xlate, u64 *data)
+{
+	u32 msr_l, msr_h;
+	u64 value, final;
+	u32 msr;
+	u32 mask_h, mask_l;
+	struct rapl_primitive_info *rp = &rpi[prim];
+
+	if (!rp->name || rp->flag & RAPL_PRIMITIVE_DUMMY)
+		return -EINVAL;
+
+	msr = domain->msrs[rp->id];
+	if (!msr)
+		return -EINVAL;
+
+	/* special-case pkg lock bit since pkg domain uses a different bit */
+	if (prim == lock && domain->id == RAPL_DOMAIN_PKG) {
+		rp->mask = POWER_PKG_LOCK;
+		rp->shift = 63;
+	}
+	if (rp->flag & RAPL_PRIMITIVE_DERIVED) {
+		*data = domain->rdd->primitives[prim];
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
+	if (xlate)
+		*data = rapl_unit_xlate(rp->unit, final, 0);
+	else
+		*data = final;
+
+	return 0;
+}
+
+static int rapl_write_data_raw(struct rapl_domain *domain,
+			enum rapl_primitives prim,
+			unsigned long long value)
+{
+	u32 msr_l, msr_h;
+	u32 mask_h, val_h;
+	u32 msr;
+	struct rapl_primitive_info *rp = &rpi[prim];
+
+	msr = domain->msrs[rp->id];
+	if (rdmsr_safe(msr, &msr_l, &msr_h)) {
+		pr_debug("failed to read msr 0x%x\n", msr);
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
+		pr_debug("failed to write msr 0x%x\n", msr);
+		return -EIO;
+	}
+
+	return value >> rp->shift;
+}
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
+	/* TDP, thermal design power is the max level rapl can set */
+	ret = rapl_read_data_raw(rd, thermal_spec_power, true, &val);
+	if (ret)
+		goto default_max;
+	if (val)
+		goto done;
+	/* use power limit 1 setting as max if TDP is not available */
+default_max:
+	ret = rapl_read_data_raw(rd, power_limit1, true, &val);
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
+	if (polling_started == false)
+		*state = 0;
+	else
+		*state = rd->rdd->primitives[average_power];
+
+	return 0;
+}
+
+static bool rapl_polling_should_cont(void)
+{
+	int i;
+	unsigned int all_state = 0;
+
+	/* user set power limit will continue polling */
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
+	if (enable == false)
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
+	unsigned long maximum_power = rd->rdd->primitives[max_power];
+	u64 locked;
+
+	if (state) {
+		/* check if the domain is locked by the BIOS */
+		if (rapl_read_data_raw(rd, lock, false, &locked) ||
+			locked) {
+			pr_err("RAPL domain %s locked by BIOS\n", rd->name);
+			return -EIO;
+		}
+
+		/* in some cases, no spec power is provided. just do a basic
+		 * range check between 0 and max bits allowed. also check for
+		 * insane BIOS settings.
+		 */
+		if (minimum_power >= maximum_power)
+			minimum_power = 0;
+		if (!spec_power)
+			spec_power = POWER_UNIT_SCALE*
+				POWER_INFO_THERMAL_SPEC_MASK/
+				rg_data.power_unit_divisor;
+		if (state < minimum_power || state >= spec_power) {
+			pr_err("out of thermal spec power range! %lu- %lu\n",
+				minimum_power, spec_power);
+			state = clamp(state, minimum_power, spec_power);
+		}
+		/* set clamping to allow RAPL lower P/T state below OS requested
+		 * range. Otherwise, the controlled power range is too limited.
+		 */
+		rapl_write_data_raw(rd, pl1_enable, 1);
+		rapl_write_data_raw(rd, pl1_clamp, 1);
+		rapl_write_data_raw(rd, time_window1, TIME_WINDOW1_DEFAULT);
+		rapl_write_data_raw(rd, power_limit1, state);
+#if 0
+		/* REVISIT: set pkg domain short term power limit to 1.25x
+		 * TDP as recommended but observed unwanted results in pl1
+		 */
+		if (RAPL_DOMAIN_PKG == rd->id) {
+			rapl_write_data_raw(rd, pl2_enable, 1);
+			rapl_write_data_raw(rd, pl2_clamp, 1);
+			rapl_write_data_raw(rd, power_limit2, spec_power +
+					(spec_power >> 2));
+		}
+#endif
+		rd->state |= DOMAIN_STATE_POWER_LIMIT_SET;
+		start_periodic_polling();
+		set_pkg_thermal_irq(false);
+	} else {
+		/* signal polling to stop if no pending limits */
+		rapl_write_data_raw(rd, pl1_enable, 0);
+		rapl_write_data_raw(rd, pl2_enable, 0);
+		rapl_write_data_raw(rd, pl1_clamp, 0);
+		rapl_write_data_raw(rd, pl2_clamp, 0);
+		rd->state &= ~DOMAIN_STATE_POWER_LIMIT_SET;
+		smp_wmb();
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
+/* TODO: single socket only. will add support for multiple socket
+ * when we can reprensent hierachy in thermal sysfs.
+ */
+static const struct x86_cpu_id intel_rapl_ids[] = {
+	{ X86_VENDOR_INTEL, 6, 0x2a},/* SNB */
+	{ X86_VENDOR_INTEL, 6, 0x3a},/* IVB */
+	{ X86_VENDOR_INTEL, 6, 0x45},/* HSW */
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, intel_rapl_ids);
+
+static void rapl_update_domain_data(void)
+{
+	int i, j;
+	u64 val;
+
+	for (i = 0; i < rg_data.nr_domains; i++) {
+		/* exclude non-raw primitives */
+		for (j = 0; j < NR_RAW_PRIMITIVES; j++)
+			if (!rapl_read_data_raw(&rapl_domains[i], j,
+							rpi[j].unit,
+							&val))
+				rd_data[i].primitives[j] = val;
+	}
+}
+
+static int intel_rapl_register_thermal(void)
+{
+	int i;
+	int ret = 0;
+	struct thermal_cooling_device *cdev;
+	struct rapl_domain *rd;
+
+	/* read the initial data */
+	rapl_update_domain_data();
+
+	for (i = 0; i < rg_data.nr_domains; i++) {
+		rd = &rapl_domains[i];
+		cdev = thermal_cooling_device_register("rapl",
+						&rapl_domains[i],
+						&rapl_cdev_ops);
+		if (IS_ERR(cdev)) {
+			ret = PTR_ERR(cdev);
+			goto err_cleanup;
+		}
+
+		rd->cool_dev = cdev;
+	}
+
+	return ret;
+
+	/* clean up previously initialized domains if we failed after the
+	 * first domain setup
+	 */
+err_cleanup:
+	while (--i >= 0) {
+		pr_debug("clean up domain %d\n", i);
+		rd = &rapl_domains[i];
+		thermal_cooling_device_unregister(rd->cool_dev);
+	}
+
+	return ret;
+}
+
+static int intel_rapl_unregister_thermal(void)
+{
+	enum rapl_domain_id i;
+	struct rapl_domain *rd;
+
+	stop_periodic_polling();
+	set_pkg_thermal_irq(true);
+
+	for (i = 0; i < rg_data.nr_domains; i++) {
+		rd = &rapl_domains[i];
+
+		pr_debug("remove %s domain, undo power limit\n",
+			rd->name);
+		rapl_write_data_raw(rd, pl1_enable, 0);
+		rapl_write_data_raw(rd, pl2_enable, 0);
+		rapl_write_data_raw(rd, pl1_clamp, 0);
+		rapl_write_data_raw(rd, pl2_clamp, 0);
+		thermal_cooling_device_unregister(rd->cool_dev);
+	}
+
+	return 0;
+}
+
+static int rapl_update_data(void)
+{
+	int i, ret;
+	static u64 energy_last[RAPL_DOMAIN_MAX];
+	u64 energy_now[RAPL_DOMAIN_MAX];
+
+	/* collect raw data for calculation */
+	for (i = 0; i < rg_data.nr_domains; i++) {
+		ret = rapl_read_data_raw(&rapl_domains[i], energy, false,
+					&energy_now[i]);
+		if (ret)
+			return ret;
+	}
+	/* first time reading */
+	if (!energy_last[0])
+		goto exit;
+
+	for (i = 0; i < rg_data.nr_domains; i++) {
+		unsigned long energy_raw = energy_now[i] - energy_last[i];
+		rd_data[i].primitives[average_power] = div64_u64(
+			rapl_unit_xlate(ENERGY_UNIT, energy_raw, 0),
+			rg_data.polling_freq_hz);
+	}
+exit:
+	memcpy(energy_last, energy_now, sizeof(energy_now));
+
+	return 0;
+}
+
+
+/* For time based data, e.g. average power */
+static void rapl_poll_data(struct work_struct *dummy)
+{
+	rapl_update_data();
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
+	if (polling_started)
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
+	if (polling_started) {
+		cancel_delayed_work_sync(&rapl_polling_work);
+		polling_started = false;
+		pr_debug("stop polling rapl data\n");
+	}
+
+	return 0;
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
+	for (i = 0; i < RAPL_DOMAIN_MAX; i++) {
+		if (!rapl_check_energy_cnt(i))
+			rg_data.domain_map |= 1 << i;
+	}
+	rg_data.nr_domains = bitmap_weight(&rg_data.domain_map,
+					RAPL_DOMAIN_MAX);
+	if (!rg_data.nr_domains) {
+		pr_err("no valid rapl domains found\n");
+		ret = -ENODEV;
+		goto done;
+	}
+	rg_data.polling_freq_hz = RAPL_POLLING_FREQ_DEFAULT;
+
+	rapl_domains = kcalloc(rg_data.nr_domains, sizeof(struct rapl_domain),
+			GFP_KERNEL);
+	if (!rapl_domains) {
+		ret = -ENOMEM;
+		goto done;
+	}
+	rapl_init_domains();
+
+done:
+	return ret;
+}
+
+static int __init intel_rapl_init(void)
+{
+	int ret, i;
+
+	if (!x86_match_cpu(intel_rapl_ids)) {
+		pr_err("CPU family %d model %d does not support RAPL\n",
+			boot_cpu_data.x86, boot_cpu_data.x86_model);
+
+		ret = -ENODEV;
+		goto done;
+	}
+
+	ret = rapl_check_unit();
+	if (ret)
+		goto done;
+
+	ret = rapl_detect_domains();
+	if (ret)
+		goto done;
+
+	/* allocate per domain data */
+	rd_data = kcalloc(rg_data.nr_domains, sizeof(struct rapl_domain_data),
+			GFP_KERNEL);
+	if (!rd_data) {
+		ret = -ENOMEM;
+		goto exit_free_domains;
+	}
+
+	for (i = 0; i < rg_data.nr_domains; i++)
+		rapl_domains[i].rdd = &rd_data[i];
+	if (intel_rapl_register_thermal())
+		goto exit_free_rdata;
+
+	return 0;
+
+exit_free_rdata:
+	kfree(rd_data);
+exit_free_domains:
+	kfree(rapl_domains);
+done:
+	return ret;
+}
+
+static void __exit intel_rapl_exit(void)
+{
+	intel_rapl_unregister_thermal();
+	kfree(rd_data);
+	kfree(rapl_domains);
+}
+
+module_init(intel_rapl_init);
+module_exit(intel_rapl_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jacob Pan <jacob.jun.pan@intel.com>");
+
+MODULE_DESCRIPTION("Driver for Intel RAPL (Running Average Power Limit) interface");
+
-- 
1.7.9.5

