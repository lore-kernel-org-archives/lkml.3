Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162601Ab3DEVDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 17:03:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:40523 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162097Ab3DEVDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 17:03:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,416,1363158000"; 
   d="scan'208";a="223402322"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, Randy Dunlap <rdunlap@infradead.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v2] Introduce Intel RAPL cooling device driver
Date: Fri,  5 Apr 2013 14:02:04 -0700
Message-Id: <1365195724-8945-2-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365195724-8945-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1365195724-8945-1-git-send-email-jacob.jun.pan@linux.intel.com>
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
with sysfs links to its true device. Although RAPL domain provides many
parameters for fine tuning, long term power limit is exposed as the
single knob via cooling device state. Whereas the rest of the
parameters are still accessible via the linked RAPL class devices.
This interface allows both simple and advanced use cases.

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
 Documentation/ABI/testing/sysfs-class-intel-rapl |  121 ++
 drivers/platform/x86/Kconfig                     |    9 +
 drivers/platform/x86/Makefile                    |    1 +
 drivers/platform/x86/intel_rapl.c                | 1285 ++++++++++++++++++++++
 drivers/platform/x86/intel_rapl.h                |  244 ++++
 5 files changed, 1660 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-intel-rapl
 create mode 100644 drivers/platform/x86/intel_rapl.c
 create mode 100644 drivers/platform/x86/intel_rapl.h

diff --git a/Documentation/ABI/testing/sysfs-class-intel-rapl b/Documentation/ABI/testing/sysfs-class-intel-rapl
new file mode 100644
index 0000000..5d2dded
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-intel-rapl
@@ -0,0 +1,121 @@
+What:		/sys/class/rapl/polling_freq_hz
+Date:		April 2013
+KernelVersion:	3.10
+Contact:	Jacob Pan <jacob.jun.pan@linux.intel.com>
+Description:
+		Frequency in HZ used to poll RAPL date. Only activated when
+		user selects an event that need to be polled or power limit
+		is set for one of the RAPL domains.
+Users:		Any thermal/power management applications want to do power capping
+		and battery life management on modern Intel SOCs.
+
+What:		/sys/class/rapl/time_unit_divisor
+Date:		April 2013
+KernelVersion:	3.10
+Contact:	Jacob Pan <jacob.jun.pan@linux.intel.com>
+Description:    Indicating time increment size
+
+What:		/sys/class/rapl/energy_unit_divisor
+Date:		April 2013
+KernelVersion:	3.10
+Contact:	Jacob Pan <jacob.jun.pan@linux.intel.com>
+Description:    Indicating energy counter increment size
+
+What:		/sys/class/rapl/power_unit_divisor
+Date:		April 2013
+KernelVersion:	3.10
+Contact:	Jacob Pan <jacob.jun.pan@linux.intel.com>
+Description:    Indicating power unit increment size, used in power limits
+
+What:		/sys/class/rapl/xxx_domain/average_power
+Date:		April 2013
+KernelVersion:	3.10
+Contact:	Jacob Pan <jacob.jun.pan@linux.intel.com>
+Description:    Average power over the current sampling period in milliwatts
+
+What:		/sys/class/rapl/xxx_domain/energy
+Date:		April 2013
+KernelVersion:	3.10
+Contact:	Jacob Pan <jacob.jun.pan@linux.intel.com>
+Description:    Total amount of energy consumed (in jules) since that last time
+		this counter is cleared.
+
+What:		/sys/class/rapl/xxx_domain/event_control
+Date:		April 2013
+KernelVersion:	3.10
+Contact:	Jacob Pan <jacob.jun.pan@linux.intel.com>
+Description:    For arm event thresholds on selected data. Write to this file
+		in the format of <eventfd> <command> <threshold value>
+		where command must be one of the event capable file names such
+		as average_power. e.g. if user creates and eventfd=3, the write:
+		   "3 average_power 12000"
+		eventfd will be notified when average_power of this domain crosses
+		12000mW on either directions.
+
+What:		/sys/class/rapl/xxx_domain/max_power
+Date:		April 2013
+KernelVersion:	3.10
+Contact:	Jacob Pan <jacob.jun.pan@linux.intel.com>
+Description:    Maximum power (mwatt) derived from the electrical spec of
+		this domain
+
+What:		/sys/class/rapl/xxx_domain/min_power
+Date:		April 2013
+KernelVersion:	3.10
+Contact:	Jacob Pan <jacob.jun.pan@linux.intel.com>
+Description:    Minimum power (mwatt) derived from the electrical spec of
+		this domain
+
+What:		/sys/class/rapl/xxx_domain/lock
+Date:		April 2013
+KernelVersion:	3.10
+Contact:	Jacob Pan <jacob.jun.pan@linux.intel.com>
+Description:    Indicates whether power limit control is locked by FW.
+		0:unlocked; 1:locked
+
+What:		/sys/class/rapl/xxx_domain/pl1_enable
+Date:		April 2013
+KernelVersion:	3.10
+Contact:	Jacob Pan <jacob.jun.pan@linux.intel.com>
+Description:    Indicates whether long term power_limit_1 is enabled
+		0:disabled; 1:enabled
+
+What:		/sys/class/rapl/xxx_domain/pl2_enable
+Date:		April 2013
+KernelVersion:	3.10
+Contact:	Jacob Pan <jacob.jun.pan@linux.intel.com>
+Description:    Indicates whether short term power_limit_2 is enabled
+		0:disabled; 1:enabled
+
+What:		/sys/class/rapl/xxx_domain/thermal_spec_power
+Date:		April 2013
+KernelVersion:	3.10
+Contact:	Jacob Pan <jacob.jun.pan@linux.intel.com>
+Description:    Thermal specification power(mw) of the domain which is the
+		upper limit of what user can assign to power_limit1
+
+What:		/sys/class/rapl/xxx_domain/time_windowX
+Date:		April 2013
+KernelVersion:	3.10
+Contact:	Jacob Pan <jacob.jun.pan@linux.intel.com>
+Description:    RAPL algorithm controlled time window(msec), similar to RC
+		circuit discharge time.
+
+What:		/sys/class/rapl/xxx_domain/power_limitX
+Date:		April 2013
+KernelVersion:	3.10
+Contact:	Jacob Pan <jacob.jun.pan@linux.intel.com>
+Description:    Target power limit in mwatt
+
+What:		/sys/class/rapl/xxx_domain/plX_clamp
+Date:		April 2013
+KernelVersion:	3.10
+Contact:	Jacob Pan <jacob.jun.pan@linux.intel.com>
+Description:    Whether allow going below OS-requested P/T state
+		0:disabled; 1:enabled
+
+What:		/sys/class/rapl/xxx_domain/throttle_time
+Date:		April 2013
+KernelVersion:	3.10
+Contact:	Jacob Pan <jacob.jun.pan@linux.intel.com>
+Description:    Accumulated throttle time (msec) done by RAPL control
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 3338437..7c537e5 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -781,4 +781,13 @@ config APPLE_GMUX
 	  graphics as well as the backlight. Currently only backlight
 	  control is supported by the driver.
 
+config INTEL_RAPL
+	tristate "Intel RAPL Support"
+	depends on THERMAL
+	default y
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
index 0000000..4f03a45
--- /dev/null
+++ b/drivers/platform/x86/intel_rapl.c
@@ -0,0 +1,1285 @@
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
+#define DRIVER_NAME "intel_rapl"
+
+static void rapl_poll_data(struct work_struct *dummy);
+static DECLARE_DELAYED_WORK(rapl_polling_work, rapl_poll_data);
+static bool polling_started;
+static int start_periodic_polling(void);
+static int stop_periodic_polling(void);
+static void rapl_init_domains(void);
+
+static struct rapl_domain *rapl_domains;
+static struct rapl_data rg_data; /* global data */
+static struct rapl_domain_data *rd_data;
+
+static struct platform_device intel_rapl_device = {
+	.name		   = DRIVER_NAME,
+	.id		   = -1,
+};
+
+static const char * const rapl_domain_names[] = {
+	"package",
+	"power_plane_0",
+	"power_plane_1",
+	"dram",
+};
+
+/* called after domain detection and global data are set */
+static void rapl_init_domains(void)
+{
+	int i;
+	struct rapl_domain *rd;
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
+			rd->attr_map = RAPL_STANDARD_ATTRS |
+				RAPL_ATTR_PL2 |
+				RAPL_ATTR_PL2_ENABLE | RAPL_ATTR_PL2_CLAMP |
+				RAPL_ATTR_THROTTLE_TIME |
+				RAPL_ATTR_TIME_WINDOW2 |
+				RAPL_ATTR_MAX_POWER | RAPL_ATTR_MIN_POWER |
+				RAPL_ATTR_MAX_WINDOW |
+				RAPL_ATTR_THERMAL_SPEC_POWER;
+			break;
+		case 1 << RAPL_DOMAIN_PP0:
+			rd->name = rapl_domain_names[RAPL_DOMAIN_PP0];
+			rd->id = RAPL_DOMAIN_PP0;
+			rd->msrs[0] = MSR_PP0_POWER_LIMIT;
+			rd->msrs[1] = MSR_PP0_ENERGY_STATUS;
+			rd->msrs[2] = 0;
+			rd->msrs[3] = MSR_PP0_POLICY;
+			rd->msrs[4] = 0;
+			rd->attr_map = RAPL_STANDARD_ATTRS |
+				RAPL_ATTR_PRIO_LEVEL |
+				RAPL_ATTR_THROTTLE_TIME;
+			break;
+		case 1 << RAPL_DOMAIN_PP1:
+			rd->name = rapl_domain_names[RAPL_DOMAIN_PP1];
+			rd->id = RAPL_DOMAIN_PP1;
+			rd->msrs[0] = MSR_PP1_POWER_LIMIT;
+			rd->msrs[1] = MSR_PP1_ENERGY_STATUS;
+			rd->msrs[2] = 0;
+			rd->msrs[3] = MSR_PP1_POLICY;
+			rd->msrs[4] = 0;
+			rd->attr_map = RAPL_STANDARD_ATTRS |
+				RAPL_ATTR_PRIO_LEVEL |
+				RAPL_ATTR_THROTTLE_TIME;
+			break;
+		case 1 << RAPL_DOMAIN_DRAM:
+			rd->name = rapl_domain_names[RAPL_DOMAIN_DRAM];
+			rd->id = RAPL_DOMAIN_DRAM;
+			rd->msrs[0] = MSR_DRAM_POWER_LIMIT;
+			rd->msrs[1] = MSR_DRAM_ENERGY_STATUS;
+			rd->msrs[2] = MSR_DRAM_PERF_STATUS;
+			rd->msrs[3] = 0;
+			rd->msrs[4] = MSR_DRAM_POWER_INFO;
+			rd->attr_map = RAPL_STANDARD_ATTRS |
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
+	PRIMITIVE_INFO_INIT(average_power, 0, 0, 0, POWER_UNIT,
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
+		if (!strncmp(rpi[i].name, name, MAX_PRIM_NAME))
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
+	BUG_ON(!domain || !rp);
+	if (NULL == rp->name || rp->flag & RAPL_PRIMITIVE_DUMMY)
+		return -EINVAL;
+
+	msr = domain->msrs[rp->id];
+	if (!msr)
+		return -EINVAL;
+
+	/* special-case pkg lock bit since pkg domain uses a different bit */
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
+	if (xlate)
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
+	ret = rapl_read_data_raw(rd, &rpi[thermal_spec_power], true, &val);
+	if (ret)
+		goto default_max;
+	if (val)
+		goto done;
+	/* use power limit 1 setting as max if tdp is not available */
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
+		/* signal polling to stop if no pending events */
+		rapl_write_data_raw(rd, &rpi[pl1_enable], 0);
+		rapl_write_data_raw(rd, &rpi[pl1_clamp], 0);
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
+static const struct x86_cpu_id intel_rapl_ids[] = {
+	{ X86_VENDOR_INTEL, 6, 0x2a},/* SNB */
+	{ X86_VENDOR_INTEL, 6, 0x2d},
+	{ X86_VENDOR_INTEL, 6, 0x3a},/* IVB */
+	{ X86_VENDOR_INTEL, 6, 0x45},/* HSW */
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, intel_rapl_ids);
+
+static ssize_t show_domain_name(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct rapl_domain *rd = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s\n", rd->name);
+}
+
+static ssize_t show_average_power(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct rapl_domain *rd = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%lu\n", rd->rdd->primitives[average_power]);
+}
+
+static ssize_t show_event_control(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct rapl_event *event;
+	struct rapl_event *tmp;
+	int ret = 0;
+	int i = 0;
+	struct rapl_domain *rd = dev_get_drvdata(dev);
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
+ * format is  <eventfd> <command> <threshold value> in the buffer.
+ * command must be one of the event capable primitive file names.
+ */
+static ssize_t store_event_control(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf,
+				size_t size)
+{
+	struct rapl_domain *rd = dev_get_drvdata(dev);
+	unsigned int efd, new_threshold;
+	struct file *efile = NULL;
+	int ret = 0;
+	int prim;
+	struct rapl_event *ep;
+	u64 val;
+	char cmd[MAX_PRIM_NAME];
+
+	if (sscanf(buf, "%u %s %u", &efd, cmd, &new_threshold) != 3)
+		return -EINVAL;
+
+	efile = eventfd_fget(efd);
+	if (IS_ERR(efile)) {
+		ret = PTR_ERR(efile);
+		pr_err("failed to get eventfd file %d\n", efd);
+		goto done;
+	}
+
+	prim = primitive_name_to_entry(cmd);
+	if (prim < 0) {
+		pr_err("failed lookup primitive id for control file %s\n",
+			cmd);
+		ret = -EINVAL;
+		goto exit_cleanup_fds;
+	}
+	if (!(rpi[prim].flag & RAPL_PRIMITIVE_EVENT_CAP)) {
+		pr_err("Invalid control file %d\n", prim);
+		ret = -EINVAL;
+		goto exit_cleanup_fds;
+	}
+
+	/*
+	 * Check if there is already an event registered to this control file.
+	 * If yes, we notify the current efd then replace the event with the
+	 * new efd/cmd/threshold. If new threshold value is 0, we delete the
+	 * event after the user gets notified.
+	 */
+	ep = rd->rdd->events[prim];
+	if (!new_threshold || ep) {
+		if (!ep) {
+			ret = -EINVAL;
+			goto exit_cleanup_fds;
+		}
+		pr_debug("delete: d:%s e:%d c:%s prim:%d val %lu\n",
+			rd->name, efd, cmd, prim,
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
+	pr_debug("domain:%s efd:%d cmd:%s, prim:%d val %lu\n",
+		rd->name, efd, cmd, prim, ep->thresholds.value);
+
+	/* start update all data */
+	rd->state |= DOMAIN_STATE_EVENT_SET;
+	smp_wmb();
+	start_periodic_polling();
+
+exit_cleanup_fds:
+	fput(efile);
+done:
+	if (ret)
+		return ret;
+
+	return size;
+}
+
+#define primitive_show_fn(n)						\
+	static ssize_t show_ ## n(struct device *dev,			\
+				struct device_attribute *attr,		\
+				char *buf)				\
+	{								\
+		struct rapl_domain *rd = dev_get_drvdata(dev);		\
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
+	}								\
+
+#define primitive_store_fn(n)						\
+	static ssize_t store_ ## n(struct device *dev,			\
+				struct device_attribute *attr,		\
+				const char *buf, size_t size)		\
+	{								\
+		struct rapl_domain *rd = dev_get_drvdata(dev);		\
+		unsigned long long new;					\
+		int i = primitive_name_to_entry(#n);			\
+		if (i < 0)						\
+			return -EIO;					\
+		if (kstrtoull(buf, 0, &new) < 0)			\
+			return -EINVAL;					\
+		rapl_write_data_raw(rd, &rpi[i], new);			\
+		return size;						\
+	}								\
+
+
+#define RO_PRIMITIVE(name)						\
+	primitive_show_fn(name)						\
+	static DEVICE_ATTR(name, S_IRUGO, show_##name, NULL)
+
+#define RW_PRIMITIVE(n)							\
+	primitive_show_fn(n)						\
+	primitive_store_fn(n)						\
+	static DEVICE_ATTR(n, S_IRUGO | S_IWUSR, show_##n, store_##n)
+
+
+RO_PRIMITIVE(energy);
+RO_PRIMITIVE(lock);
+RO_PRIMITIVE(thermal_spec_power);
+RO_PRIMITIVE(max_power);
+RO_PRIMITIVE(min_power);
+RO_PRIMITIVE(max_window);
+RO_PRIMITIVE(throttle_time);
+RO_PRIMITIVE(prio_level);
+
+RW_PRIMITIVE(power_limit1);
+RW_PRIMITIVE(power_limit2);
+RW_PRIMITIVE(time_window1);
+RW_PRIMITIVE(time_window2);
+RW_PRIMITIVE(pl1_enable);
+RW_PRIMITIVE(pl2_enable);
+RW_PRIMITIVE(pl1_clamp);
+RW_PRIMITIVE(pl2_clamp);
+
+/* non-hardware attributes */
+static DEVICE_ATTR(average_power, S_IRUGO, show_average_power, NULL);
+static DEVICE_ATTR(domain_name, S_IRUGO, show_domain_name, NULL);
+static DEVICE_ATTR(event_control, S_IRUGO|S_IWUSR, show_event_control, store_event_control);
+
+/* listed in the order of rapl_primitives such that attrs can be indexed and
+ * assigned to per domain attrs based on its availability.
+ */
+static struct attribute *all_attrs[] = {
+	&dev_attr_energy.attr,
+	&dev_attr_power_limit1.attr,
+	&dev_attr_power_limit2.attr,
+	&dev_attr_lock.attr,
+
+	&dev_attr_pl1_enable.attr,
+	&dev_attr_pl1_clamp.attr,
+	&dev_attr_pl2_enable.attr,
+	&dev_attr_pl2_clamp.attr,
+
+	&dev_attr_time_window1.attr,
+	&dev_attr_time_window2.attr,
+	&dev_attr_thermal_spec_power.attr,
+	&dev_attr_max_power.attr,
+
+	&dev_attr_min_power.attr,
+	&dev_attr_max_window.attr,
+	&dev_attr_throttle_time.attr,
+	&dev_attr_prio_level.attr,
+
+	&dev_attr_average_power.attr,
+	&dev_attr_event_control.attr,
+	&dev_attr_domain_name.attr,
+	NULL,
+};
+
+#define RW_GLOBAL_CLASS_DATA(n)						\
+	static ssize_t store_ ## n(struct class *s,			\
+					struct class_attribute *a,	\
+					const char *buf, size_t size)	\
+	{								\
+		unsigned long new;					\
+		if (kstrtoul(buf, 0, &new) < 0)				\
+			return -EINVAL;					\
+		rg_data.n = new;					\
+		return size;						\
+	}								\
+	static ssize_t show_ ## n(struct class *s,			\
+				struct class_attribute *a,		\
+				char *buf)				\
+	{								\
+		return sprintf(buf, "%d\n", rg_data.n);			\
+	}
+
+#define RO_GLOBAL_CLASS_DATA(n)						\
+	static ssize_t show_ ## n(struct class *s,			\
+				struct class_attribute *a,		\
+				char *buf)				\
+	{								\
+		return sprintf(buf, "%d\n", rg_data.n);			\
+	}
+
+
+#define GLOBAL_CLASS_RW_ATTR(n)			\
+	__ATTR(n, S_IRUGO | S_IWUSR,		\
+		show_ ##n,			\
+		store_ ##n			\
+		)
+
+#define GLOBAL_CLASS_RO_ATTR(n)			\
+	__ATTR(n, S_IRUGO,			\
+		show_ ##n,			\
+		NULL				\
+		)
+
+RO_GLOBAL_CLASS_DATA(energy_unit_divisor)
+RO_GLOBAL_CLASS_DATA(power_unit_divisor)
+RO_GLOBAL_CLASS_DATA(time_unit_divisor)
+RW_GLOBAL_CLASS_DATA(polling_freq_hz)
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
+
+	return attrs;
+}
+
+/* for global rapl data */
+static struct class_attribute rapl_class_attrs[] = {
+	GLOBAL_CLASS_RO_ATTR(energy_unit_divisor),
+	GLOBAL_CLASS_RO_ATTR(power_unit_divisor),
+	GLOBAL_CLASS_RO_ATTR(time_unit_divisor),
+	GLOBAL_CLASS_RW_ATTR(polling_freq_hz),
+	__ATTR_NULL,
+};
+
+static struct class rapl_class = {
+	.name =		"rapl",
+	.owner =	THIS_MODULE,
+	.class_attrs =	rapl_class_attrs,
+};
+
+
+static int intel_rapl_probe(struct platform_device *pdev)
+{
+	int i;
+	int ret = 0;
+	struct thermal_cooling_device *cdev;
+	struct device *dev;
+	struct rapl_domain *rd;
+
+	/* read the initial data */
+	rapl_update_domain_data();
+
+	for (i = 0; i < rg_data.nr_domains; i++) {
+		rd = &rapl_domains[i];
+		/*
+		 * create a device for each rapl domain then link them with
+		 * generic thermal sysfs
+		 */
+		dev = device_create(&rapl_class, &pdev->dev, MKDEV(0, i),
+				rd, "%s_domain", rd->name);
+		if (IS_ERR(dev)) {
+			pr_debug("failed to create rapl device %s\n", rd->name);
+			ret = PTR_ERR(dev);
+			goto err_free_all;
+		}
+		rd->dev = dev;
+		/* assign domain specific attributes */
+		rd->attr_group.attrs = rapl_domain_attrs(i);
+		ret = sysfs_create_group(&dev->kobj, &rd->attr_group);
+		if (ret) {
+			pr_debug("failed to create rapl device %s attrs\n",
+				rd->name);
+			goto err_destroy;
+		}
+		cdev = thermal_cooling_device_register(DRIVER_NAME,
+						&rapl_domains[i],
+						&rapl_cdev_ops);
+		if (IS_ERR(cdev)) {
+			ret = PTR_ERR(cdev);
+			goto err_remove_attr;
+		}
+
+		rd->cool_dev = cdev;
+		pr_info("registered RAPL domain %d %s as cooling device\n", i,
+			rd->name);
+
+		ret = sysfs_create_link(&rd->dev->kobj,
+					&cdev->device.kobj, "thermal_cooling");
+		if (ret) {
+			dev_err(&intel_rapl_device.dev,
+				"Failed to create thermal_cooling link for domain %d %s\n",
+				i, rd->name);
+			goto err_unregister_cdev;
+		}
+
+		ret = sysfs_create_link(&cdev->device.kobj, &rd->dev->kobj,
+					"device");
+		if (ret) {
+			dev_err(&intel_rapl_device.dev,
+				"Failed to create device link for domain %d %s\n",
+				i, rd->name);
+			goto err_unlink;
+		}
+	}
+
+	return ret;
+
+err_unregister_cdev:
+	thermal_cooling_device_unregister(rd->cool_dev);
+err_unlink:
+	sysfs_remove_link(&rd->dev->kobj, "thermal_cooling");
+err_remove_attr:
+	sysfs_remove_group(&rd->dev->kobj, &rd->attr_group);
+err_destroy:
+	device_destroy(&rapl_class, MKDEV(0, i));
+err_free_all:
+	/* clean up previously initialized domains if we failed after the
+	 * first domain setup
+	 */
+	while (--i >= 0) {
+		pr_debug("clean up domain %d\n", i);
+		rd = &rapl_domains[i];
+		sysfs_remove_link(&rd->dev->kobj, "thermal_cooling");
+		sysfs_remove_link(&rd->cool_dev->device.kobj, "device");
+		thermal_cooling_device_unregister(rd->cool_dev);
+		sysfs_remove_group(&rd->dev->kobj, &rd->attr_group);
+		device_destroy(&rapl_class, MKDEV(0, i));
+	}
+
+	return ret;
+}
+
+static int intel_rapl_remove(struct platform_device *pdev)
+{
+	enum rapl_domain_id i;
+	struct rapl_event *event;
+	struct rapl_event *tmp;
+	struct rapl_domain *rd;
+
+	stop_periodic_polling();
+	set_pkg_thermal_irq(true);
+
+	for (i = 0; i < rg_data.nr_domains; i++) {
+		rd = &rapl_domains[i];
+
+		pr_debug("remove %s domain device\n", rd->name);
+		sysfs_remove_link(&rd->cool_dev->device.kobj, "device");
+		sysfs_remove_link(&rd->dev->kobj, "thermal_cooling");
+
+		sysfs_remove_group(&rd->dev->kobj, &rd->attr_group);
+		device_destroy(&rapl_class, MKDEV(0, i));
+		rapl_write_data_raw(rd, &rpi[pl1_enable], 0);
+		list_for_each_entry_safe(event, tmp, &rd->event_list, list) {
+			pr_debug("free event %s, threshold %lu\n",
+				rd->name, event->thresholds.value);
+			spin_lock(&rd->event_lock);
+			schedule_work(&event->remove);
+			list_del(&event->list);
+			spin_unlock(&rd->event_lock);
+		}
+
+		thermal_cooling_device_unregister(rd->cool_dev);
+
+		kfree(rd->attr_group.attrs);
+	}
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
+			/* check if we crossed threshold in either direction */
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
+	rg_data.nr_domains = bitmap_weight(&rg_data.domain_map,
+					RAPL_DOMAIN_MAX);
+	if (!rg_data.nr_domains) {
+		pr_err("no valid rapl domains found\n");
+		ret = -ENODEV;
+		goto done;
+	}
+	rg_data.polling_freq_hz = RAPL_POLLING_FREQ_DEFAULT;
+
+	pr_info("Found %d valid RAPL domains\n", rg_data.nr_domains);
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
+	int i, ret;
+
+	ret = rapl_check_unit();
+	if (ret)
+		return ret;
+
+	ret = rapl_detect_domains();
+	if (ret)
+		return ret;
+
+	ret = class_register(&rapl_class);
+	if (ret < 0)
+		goto exit_free_domains;
+
+	/* allocate per domain data */
+	rd_data = kcalloc(rg_data.nr_domains, sizeof(struct rapl_domain_data),
+			GFP_KERNEL);
+	if (!rd_data) {
+		ret = -ENOMEM;
+		goto exit_free_domains;
+	}
+
+	for (i = 0; i < rg_data.nr_domains; i++) {
+		rapl_domains[i].rdd = &rd_data[i];
+		INIT_LIST_HEAD(&rapl_domains[i].event_list);
+		spin_lock_init(&rapl_domains[i].event_lock);
+	}
+	intel_rapl_device.dev.release = intel_rapl_dev_release;
+	intel_rapl_device.dev.platform_data = rapl_domains;
+
+	ret = platform_device_register(&intel_rapl_device);
+	if (ret)
+		goto exit_free_rdata;
+	ret = platform_driver_register(&intel_rapl_driver);
+	if (ret)
+		goto exit_unregister_device;
+
+	return 0;
+
+exit_unregister_device:
+	class_unregister(&rapl_class);
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
+	class_unregister(&rapl_class);
+}
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
index 0000000..41600f4
--- /dev/null
+++ b/drivers/platform/x86/intel_rapl.h
@@ -0,0 +1,244 @@
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
+	const char *name;
+	enum rapl_domain_id id;
+	int msrs[RAPL_DOMAIN_MSR_MAX];
+	struct thermal_zone_device *tz_dev;
+	struct thermal_cooling_device *cool_dev;
+	struct device *dev;
+	struct rapl_domain_data *rdd;
+	struct list_head event_list;
+	unsigned long attr_map; /* bitmap for per domain features */
+	struct attribute_group attr_group;
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
+	average_power,
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
+#define RAPL_ATTR_POWER                  BIT(average_power)
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
+#define MAX_PRIM_NAME (32)
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

