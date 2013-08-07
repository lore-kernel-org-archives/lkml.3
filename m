Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab3HGQPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:15:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:4565 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757111Ab3HGQPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:15:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,834,1367996400"; 
   d="scan'208";a="359102175"
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, rjw@sisk.pl, arjan@linux.intel.com,
        len.brown@intel.com, jacob.jun.pan@linux.intel.com, corbet@lwn.net,
        joe@perches.com,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: [RFC v02 5/5] Introduce Intel RAPL power capping driver
Date: Wed,  7 Aug 2013 09:12:45 -0700
Message-Id: <1375891965-6921-6-git-send-email-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375891965-6921-1-git-send-email-srinivas.pandruvada@linux.intel.com>
References: <1375891965-6921-1-git-send-email-srinivas.pandruvada@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

RAPL(Running Average Power Limit) interface provides platform software
with the ability to monitor, control, and get notifications on SOC
power consumptions. Since its first appearance on Sandy Bridge, more
features have being added to extend its usage. In RAPL, platforms are
divided into domains for fine grained control. These domains include
package, DRAM controller, CPU core (Power Plane 0), graphics uncore
(power plane 1), etc.

The purpose of this driver is to expose RAPL for userspace
consumption. Overall, RAPL fits in the new powercap class driver in
that platform level power capping controls are exposed via this
generic interface.

Zhang, Rui's initial RAPL driver was used as a reference and starting
point. Many thanks.
https://lkml.org/lkml/2011/5/26/93

Unlike the patch above, which is mainly for monitoring, this driver
focus on the control and usability by user applications.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 drivers/powercap/Kconfig      |    8 +
 drivers/powercap/Makefile     |    1 +
 drivers/powercap/intel_rapl.c | 1319 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1328 insertions(+)
 create mode 100644 drivers/powercap/intel_rapl.c

diff --git a/drivers/powercap/Kconfig b/drivers/powercap/Kconfig
index f70b7b9..7fd9d48 100644
--- a/drivers/powercap/Kconfig
+++ b/drivers/powercap/Kconfig
@@ -13,4 +13,12 @@ menuconfig POWERCAP_SUPPORT
 if POWERCAP_SUPPORT
 # Add client driver config here.
 
+config INTEL_RAPL
+	tristate "Intel RAPL Support"
+	default n
+	---help---
+	  RAPL (Running Average Power Limit) provides mechanisms to enforce
+	  and monitor power limits of supported Intel CPUs. Limits can be
+	  set by RAPL domains such as package, core, graphics, etc.
+
 endif
diff --git a/drivers/powercap/Makefile b/drivers/powercap/Makefile
index f2acfed..a08b8b0 100644
--- a/drivers/powercap/Makefile
+++ b/drivers/powercap/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-$(CONFIG_POWERCAP_SUPPORT)	+= powercap_sys.o
+obj-$(CONFIG_INTEL_RAPL)       += intel_rapl.o
diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
new file mode 100644
index 0000000..46642b8
--- /dev/null
+++ b/drivers/powercap/intel_rapl.c
@@ -0,0 +1,1319 @@
+/*
+ * Intel Running Average Power Limit (RAPL) Driver
+ * Copyright (c) 2013, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.
+ *
+ */
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
+#include <linux/cpu.h>
+#include <linux/powercap.h>
+
+#include <asm/processor.h>
+#include <asm/cpu_device_id.h>
+
+
+/* bitmasks for RAPL MSRs, used by primitive access functions */
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
+
+/* scale RAPL units to avoid floating point math inside kernel */
+#define POWER_UNIT_SCALE     (1000000)
+#define ENERGY_UNIT_SCALE    (1000000)
+#define TIME_UNIT_SCALE      (1000000)
+
+#define TIME_WINDOW_MAX_MSEC 40000
+#define TIME_WINDOW_MIN_MSEC 250
+
+enum unit_type {
+	NA_UNIT, /* no translation */
+	POWER_UNIT,
+	ENERGY_UNIT,
+	TIME_UNIT,
+};
+
+enum rapl_domain_type {
+	RAPL_DOMAIN_PKG, /* entire package/socket */
+	RAPL_DOMAIN_PP0, /* core power plane */
+	RAPL_DOMAIN_PP1, /* graphics uncore */
+	RAPL_DOMAIN_DRAM,/* DRAM controller */
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
+/* per domain data, some are optional */
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
+/* Can be expanded to include events, etc.*/
+struct rapl_domain_data {
+	u64 primitives[nr_rapl_primitives];
+	unsigned long timestamp;
+};
+
+
+#define	DOMAIN_STATE_INACTIVE           BIT(0)
+#define	DOMAIN_STATE_POWER_LIMIT_SET    BIT(1)
+#define DOMAIN_STATE_BIOS_LOCKED        BIT(2)
+
+#define NR_POWER_LIMITS (2)
+struct rapl_power_limit {
+	struct powercap_zone_constraint *constraint;
+	int prim_id; /* primitive ID used to enable */
+	struct rapl_domain *domain;
+	const char *name;
+};
+
+static const char pl1_name[] = "long_term";
+static const char pl2_name[] = "short_term";
+
+struct rapl_domain {
+	const char *name;
+	enum rapl_domain_type id;
+	int msrs[RAPL_DOMAIN_MSR_MAX];
+	struct powercap_zone_device *pzone;
+	struct powercap_zone_ops *ops;
+	struct rapl_domain_data rdd;
+	struct rapl_power_limit rpl[NR_POWER_LIMITS];
+	u64 attr_map; /* track capabilities */
+	unsigned int state;
+	int pkg_id;
+};
+
+/* Each physical package contains multiple domains, these are the common
+ * data across RAPL domains within a package.
+ */
+struct rapl_pkg {
+	unsigned int id; /* physical package/socket id */
+	unsigned int nr_domains;
+	unsigned long domain_map; /* bit map of active domains */
+	unsigned int power_unit_divisor;
+	unsigned int energy_unit_divisor;
+	unsigned int time_unit_divisor;
+	struct rapl_domain *domains;
+	struct powercap_zone_device *pzone; /* keep track of parent zone */
+	int nr_cpus; /* active cpus on the pkg, topology info is lost during
+		      * cpu hotplug. so we have to track ourselves.
+		      */
+	unsigned long power_limit_irq; /* keep track of pkg power limit
+					* notify interrupt enable status.
+					*/
+	struct list_head plist;
+};
+#define PACKAGE_PLN_INT_SAVED   BIT(0)
+#define MAX_PRIM_NAME (32)
+
+/* per domain data. used to describe individual knobs such that access function
+ * can be consolidated into one instead of many inline functions.
+ */
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
+static void rapl_init_domains(struct rapl_pkg *rp);
+static int rapl_read_data_raw(struct rapl_domain *rd,
+			enum rapl_primitives prim,
+			bool xlate, u64 *data);
+static int rapl_write_data_raw(struct rapl_domain *rd,
+			enum rapl_primitives prim,
+			unsigned long long value);
+static u64 rapl_unit_xlate(int pkg, enum unit_type type, u64 value, int to_raw);
+static void pkg_power_limit_irq_save(int pkg_id);
+
+static LIST_HEAD(rpkgs); /* guarded by CPU hotplug lock */
+
+static const char * const rapl_domain_names[] = {
+	"package",
+	"core",
+	"uncore",
+	"dram",
+};
+
+static struct powercap_controller *pccr; /* PowerCap Controller */
+
+/* caller to ensure CPU hotplug lock is held */
+static struct rapl_pkg *find_package_by_id(int id)
+{
+	struct rapl_pkg *rp;
+
+	list_for_each_entry(rp, &rpkgs, plist) {
+		if (rp->id == id)
+			return rp;
+	}
+
+	return NULL;
+}
+
+/* caller to ensure CPU hotplug lock is held */
+static int find_active_cpu_on_pkg(int pkg_id)
+{
+	int i;
+
+	for_each_online_cpu(i) {
+		if (topology_physical_package_id(i) == pkg_id)
+			return i;
+	}
+	/* all CPUs on this package are offline */
+
+	return -ENODEV;
+}
+
+/* caller must hold cpu hotplug lock */
+static void rapl_cleanup_data(void)
+{
+	struct rapl_pkg *p, *tmp;
+
+	if (list_empty(&rpkgs))
+		return;
+	list_for_each_entry_safe(p, tmp, &rpkgs, plist) {
+		kfree(p->domains);
+		list_del(&p->plist);
+		kfree(p);
+	}
+}
+
+
+int get_energy_counter(struct powercap_zone_device *pzdev, u64 *energy_raw)
+{
+	struct rapl_domain *rd;
+	u64 energy_now;
+
+	get_online_cpus();
+	rd = (struct rapl_domain *)powercap_get_zone_data(pzdev);
+	if (!rd)
+		return -ENODEV;
+
+	if (!rapl_read_data_raw(rd, energy, true, &energy_now)) {
+		*energy_raw = energy_now;
+		put_online_cpus();
+
+		return 0;
+	}
+	put_online_cpus();
+
+	return -EIO;
+}
+
+int get_max_power_counter(struct powercap_zone_device *pzdev, u64 *pwr)
+{
+	struct rapl_domain *rd;
+	u64 val64;
+
+	get_online_cpus();
+	rd = (struct rapl_domain *)powercap_get_zone_data(pzdev);
+	if (!rd)
+		return -ENODEV;
+
+	if (!rapl_read_data_raw(rd, thermal_spec_power, true, &val64)) {
+		*pwr = val64;
+		put_online_cpus();
+		return 0;
+	}
+	put_online_cpus();
+	return -EIO;
+}
+
+int get_max_energy_counter(struct powercap_zone_device *pcd_dev, u64 *energy)
+{
+	*energy = rapl_unit_xlate(0, ENERGY_UNIT, ENERGY_STATUS_MASK, 0);
+	return 0;
+}
+
+
+static struct powercap_zone_ops zone_ops_pkg = {
+	.get_energy_uj = get_energy_counter,
+	.get_max_power_range_uw = get_max_power_counter,
+	.get_max_energy_range_uj = get_max_energy_counter,
+};
+
+static struct powercap_zone_ops zone_ops_pp0 = {
+	.get_energy_uj = get_energy_counter,
+	.get_max_energy_range_uj = get_max_energy_counter,
+};
+
+static struct powercap_zone_ops zone_ops_pp1 = {
+	.get_energy_uj = get_energy_counter,
+	.get_max_energy_range_uj = get_max_energy_counter,
+
+};
+static struct powercap_zone_ops zone_ops_dram = {
+	.get_energy_uj = get_energy_counter,
+	.get_max_energy_range_uj = get_max_energy_counter,
+};
+
+static int set_power_limit(struct powercap_zone_device *pzdev, int id,
+			u64 power_limit)
+{
+	struct rapl_domain *rd;
+	struct rapl_pkg *rp;
+	int ret = 0;
+
+	get_online_cpus();
+
+	rd = (struct rapl_domain *)powercap_get_zone_data(pzdev);
+	if (!rd)
+		return -ENODEV;
+	rp = find_package_by_id(rd->pkg_id);
+	if (!rp) {
+		ret = -ENODEV;
+		goto set_exit;
+	}
+
+	if (rd->state & DOMAIN_STATE_BIOS_LOCKED) {
+		dev_warn(&pzdev->device, "%s locked by BIOS, monitoring only\n",
+			rd->name);
+		ret = -EACCES;
+		goto set_exit;
+	}
+
+	switch (rd->rpl[id].prim_id) {
+	case pl1_enable:
+		rapl_write_data_raw(rd, pl1_enable, 1);
+		rapl_write_data_raw(rd, pl1_clamp, 1);
+		rapl_write_data_raw(rd, power_limit1, power_limit);
+		break;
+	case pl2_enable:
+		rapl_write_data_raw(rd, pl2_enable, 1);
+		rapl_write_data_raw(rd, pl2_clamp, 1);
+		rapl_write_data_raw(rd, power_limit2, power_limit);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	if (!ret)
+		pkg_power_limit_irq_save(rd->pkg_id);
+set_exit:
+	put_online_cpus();
+	return ret;
+}
+
+static int get_current_power_limit(struct powercap_zone_device *pzdev, int id,
+					u64 *data)
+{
+	struct rapl_domain *rd;
+	u64 val;
+	int prim;
+	int ret = 0;
+
+	get_online_cpus();
+	rd = (struct rapl_domain *)powercap_get_zone_data(pzdev);
+	if (!rd)
+		return -ENODEV;
+
+	switch (rd->rpl[id].prim_id) {
+	case pl1_enable:
+		prim = power_limit1;
+		break;
+	case pl2_enable:
+		prim = power_limit2;
+		break;
+	default:
+		put_online_cpus();
+		return -EINVAL;
+	}
+	if (rapl_read_data_raw(rd, prim, true, &val))
+		ret = -EIO;
+	else
+		*data = val;
+
+	put_online_cpus();
+
+	return ret;
+}
+
+static int set_time_window(struct powercap_zone_device *pzdev, int id,
+								u64 window)
+{
+	struct rapl_domain *rd;
+	int ret = 0;
+
+	get_online_cpus();
+	rd = (struct rapl_domain *)powercap_get_zone_data(pzdev);
+	if (!rd)
+		return -ENODEV;
+
+	switch (rd->rpl[id].prim_id) {
+	case pl1_enable:
+		rapl_write_data_raw(rd, time_window1, window);
+		break;
+	case pl2_enable:
+		rapl_write_data_raw(rd, time_window2, window);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	put_online_cpus();
+	return ret;
+}
+
+int get_time_window(struct powercap_zone_device *pzdev, int id, u64 *data)
+{
+	struct rapl_domain *rd;
+	u64 val;
+	int ret = 0;
+
+	get_online_cpus();
+	rd = (struct rapl_domain *)powercap_get_zone_data(pzdev);
+	if (!rd)
+		return -ENODEV;
+
+	switch (rd->rpl[id].prim_id) {
+	case pl1_enable:
+		ret = rapl_read_data_raw(rd, time_window1, true, &val);
+		break;
+	case pl2_enable:
+		ret = rapl_read_data_raw(rd, time_window2, true, &val);
+		break;
+	default:
+		put_online_cpus();
+		return -EINVAL;
+	}
+	if (!ret)
+		*data = val;
+	put_online_cpus();
+
+	return ret;
+}
+
+const char *get_constraint_name(struct powercap_zone_device *pzdev, int id)
+{
+	struct rapl_power_limit *rpl;
+	struct rapl_domain *rd;
+
+	rd = (struct rapl_domain *)powercap_get_zone_data(pzdev);
+	if (!rd)
+		return NULL;
+
+	rpl = (struct rapl_power_limit *) &rd->rpl[id];
+
+	return rpl->name;
+}
+
+struct powercap_zone_constraint_ops const_ops = {
+	.set_power_limit_uw = set_power_limit,
+	.get_power_limit_uw = get_current_power_limit,
+	.set_time_window_us = set_time_window,
+	.get_time_window_us = get_time_window,
+	.get_name = get_constraint_name,
+};
+
+static int find_nr_power_limit(struct rapl_domain *rd)
+{
+	int i;
+
+	for (i = 0; i < NR_POWER_LIMITS; i++) {
+		if (rd->rpl[i].name == NULL)
+			break;
+	}
+
+	return i;
+}
+
+/* called after domain detection and package level data are set */
+static void rapl_init_domains(struct rapl_pkg *rp)
+{
+	int i;
+	struct rapl_domain *rd = rp->domains;
+
+	for (i = 0; i < RAPL_DOMAIN_MAX; i++) {
+		unsigned int mask = rp->domain_map & (1 << i);
+		switch (mask) {
+		case 1 << RAPL_DOMAIN_PKG:
+			rd->name = rapl_domain_names[RAPL_DOMAIN_PKG];
+			rd->id = RAPL_DOMAIN_PKG;
+			rd->msrs[0] = MSR_PKG_POWER_LIMIT;
+			rd->msrs[1] = MSR_PKG_ENERGY_STATUS;
+			rd->msrs[2] = MSR_PKG_PERF_STATUS;
+			rd->msrs[3] = 0;
+			rd->msrs[4] = MSR_PKG_POWER_INFO;
+			rd->ops = &zone_ops_pkg;
+			rd->rpl[0].prim_id = pl1_enable;
+			rd->rpl[0].name = pl1_name;
+			rd->rpl[1].prim_id = pl2_enable;
+			rd->rpl[1].name = pl2_name;
+			break;
+		case 1 << RAPL_DOMAIN_PP0:
+			rd->name = rapl_domain_names[RAPL_DOMAIN_PP0];
+			rd->id = RAPL_DOMAIN_PP0;
+			rd->msrs[0] = MSR_PP0_POWER_LIMIT;
+			rd->msrs[1] = MSR_PP0_ENERGY_STATUS;
+			rd->msrs[2] = 0;
+			rd->msrs[3] = MSR_PP0_POLICY;
+			rd->msrs[4] = 0;
+			rd->ops = &zone_ops_pp0;
+			rd->rpl[0].prim_id = pl1_enable;
+			rd->rpl[0].name = pl1_name;
+			break;
+		case 1 << RAPL_DOMAIN_PP1:
+			rd->name = rapl_domain_names[RAPL_DOMAIN_PP1];
+			rd->id = RAPL_DOMAIN_PP1;
+			rd->msrs[0] = MSR_PP1_POWER_LIMIT;
+			rd->msrs[1] = MSR_PP1_ENERGY_STATUS;
+			rd->msrs[2] = 0;
+			rd->msrs[3] = MSR_PP1_POLICY;
+			rd->msrs[4] = 0;
+			rd->ops = &zone_ops_pp1;
+			rd->rpl[0].prim_id = pl1_enable;
+			rd->rpl[0].name = pl1_name;
+			break;
+		case 1 << RAPL_DOMAIN_DRAM:
+			rd->name = rapl_domain_names[RAPL_DOMAIN_DRAM];
+			rd->id = RAPL_DOMAIN_DRAM;
+			rd->msrs[0] = MSR_DRAM_POWER_LIMIT;
+			rd->msrs[1] = MSR_DRAM_ENERGY_STATUS;
+			rd->msrs[2] = MSR_DRAM_PERF_STATUS;
+			rd->msrs[3] = 0;
+			rd->msrs[4] = MSR_DRAM_POWER_INFO;
+			rd->ops = &zone_ops_dram;
+			rd->rpl[0].prim_id = pl1_enable;
+			rd->rpl[0].name = pl1_name;
+			break;
+		}
+		if (mask) {
+			rd->pkg_id = rp->id;
+			rd++;
+		}
+	}
+}
+
+static u64 rapl_unit_xlate(int pkg, enum unit_type type, u64 value, int to_raw)
+{
+	u64 divisor = 1;
+	int scale = 1; /* scale to user friendly data without floating point */
+	u64 f, y; /* fraction and exp. used for time unit */
+	struct rapl_pkg *rp;
+
+	rp = find_package_by_id(pkg);
+	if (!rp)
+		return value;
+
+	switch (type) {
+	case POWER_UNIT:
+		divisor = rp->power_unit_divisor;
+		scale = POWER_UNIT_SCALE;
+		break;
+	case ENERGY_UNIT:
+		scale = ENERGY_UNIT_SCALE;
+		divisor = rp->energy_unit_divisor;
+		break;
+	case TIME_UNIT:
+		divisor = rp->time_unit_divisor;
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
+	/* name, mask, shift, msr index, unit divisor */
+	PRIMITIVE_INFO_INIT(energy, ENERGY_STATUS_MASK, 0,
+				RAPL_DOMAIN_MSR_STATUS, ENERGY_UNIT, 0),
+	PRIMITIVE_INFO_INIT(power_limit1, POWER_LIMIT1_MASK, 0,
+				RAPL_DOMAIN_MSR_LIMIT, POWER_UNIT, 0),
+	PRIMITIVE_INFO_INIT(power_limit2, POWER_LIMIT2_MASK, 32,
+				RAPL_DOMAIN_MSR_LIMIT, POWER_UNIT, 0),
+	PRIMITIVE_INFO_INIT(lock, POWER_PP_LOCK, 31,
+				RAPL_DOMAIN_MSR_LIMIT, NA_UNIT, 0),
+	PRIMITIVE_INFO_INIT(pl1_enable, POWER_LIMIT1_ENABLE, 15,
+				RAPL_DOMAIN_MSR_LIMIT, NA_UNIT, 0),
+	PRIMITIVE_INFO_INIT(pl1_clamp, POWER_LIMIT1_CLAMP, 16,
+				RAPL_DOMAIN_MSR_LIMIT, NA_UNIT, 0),
+	PRIMITIVE_INFO_INIT(pl2_enable, POWER_LIMIT2_ENABLE, 47,
+				RAPL_DOMAIN_MSR_LIMIT, NA_UNIT, 0),
+	PRIMITIVE_INFO_INIT(pl2_clamp, POWER_LIMIT2_CLAMP, 48,
+				RAPL_DOMAIN_MSR_LIMIT, NA_UNIT, 0),
+	PRIMITIVE_INFO_INIT(time_window1, TIME_WINDOW1_MASK, 17,
+				RAPL_DOMAIN_MSR_LIMIT, TIME_UNIT, 0),
+	PRIMITIVE_INFO_INIT(time_window2, TIME_WINDOW2_MASK, 49,
+				RAPL_DOMAIN_MSR_LIMIT, TIME_UNIT, 0),
+	PRIMITIVE_INFO_INIT(thermal_spec_power, POWER_INFO_THERMAL_SPEC_MASK,
+				0, RAPL_DOMAIN_MSR_INFO, POWER_UNIT, 0),
+	PRIMITIVE_INFO_INIT(max_power, POWER_INFO_MAX_MASK, 32,
+				RAPL_DOMAIN_MSR_INFO, POWER_UNIT, 0),
+	PRIMITIVE_INFO_INIT(min_power, POWER_INFO_MIN_MASK, 16,
+				RAPL_DOMAIN_MSR_INFO, POWER_UNIT, 0),
+	PRIMITIVE_INFO_INIT(max_window, POWER_INFO_MAX_TIME_WIN_MASK, 48,
+				RAPL_DOMAIN_MSR_INFO, TIME_UNIT, 0),
+	PRIMITIVE_INFO_INIT(throttle_time, PERF_STATUS_THROTTLE_TIME_MASK, 0,
+				RAPL_DOMAIN_MSR_PERF, TIME_UNIT, 0),
+	PRIMITIVE_INFO_INIT(prio_level, PP_POLICY_MASK, 0,
+				RAPL_DOMAIN_MSR_POLICY, NA_UNIT, 0),
+	/* non-hardware */
+	PRIMITIVE_INFO_INIT(average_power, 0, 0, 0, POWER_UNIT,
+				RAPL_PRIMITIVE_DERIVED),
+	{NULL, 0, 0, 0},
+};
+
+/* Read primitive data based on its related struct rapl_primitive_info.
+ * if xlate flag is set, return translated data based on data units, i.e.
+ * time, energy, and power.
+ * RAPL MSRs are non-architectual and are laided out not consistantly across
+ * domains. Here we use primitive info to allow writing consolidated access
+ * functions.
+ * For a given primitive, it is processed by MSR mask and shift. Unit conversion
+ * is pre-assigned based on RAPL unit MSRs read at init time.
+ * 63-------------------------- 31--------------------------- 0
+ * |                           xxxxx (mask)                   |
+ * |                                |<- shift ----------------|
+ * 63-------------------------- 31--------------------------- 0
+ */
+static int rapl_read_data_raw(struct rapl_domain *rd,
+			enum rapl_primitives prim,
+			bool xlate, u64 *data)
+{
+	u64 value, final;
+	u32 msr;
+	struct rapl_primitive_info *rp = &rpi[prim];
+	int cpu;
+
+	if (!rp->name || rp->flag & RAPL_PRIMITIVE_DUMMY)
+		return -EINVAL;
+
+	msr = rd->msrs[rp->id];
+	if (!msr)
+		return -EINVAL;
+	/* use physical package id to look up active cpus */
+	cpu = find_active_cpu_on_pkg(rd->pkg_id);
+	if (cpu < 0)
+		return cpu;
+
+	/* special-case pkg lock bit since pkg domain uses a different bit */
+	if (prim == lock && rd->id == RAPL_DOMAIN_PKG) {
+		rp->mask = POWER_PKG_LOCK;
+		rp->shift = 63;
+	}
+	/* non-hardware data are collected by the polling thread */
+	if (rp->flag & RAPL_PRIMITIVE_DERIVED) {
+		*data = rd->rdd.primitives[prim];
+		return 0;
+	}
+
+	if (rdmsrl_safe_on_cpu(cpu, msr, &value)) {
+		pr_debug("failed to read msr 0x%x on cpu %d\n", msr, cpu);
+		return -EIO;
+	}
+
+	final = value & rp->mask;
+	final = final >> rp->shift;
+	if (xlate)
+		*data = rapl_unit_xlate(rd->pkg_id, rp->unit, final, 0);
+	else
+		*data = final;
+
+	return 0;
+}
+
+/* Similar use of primitive info in the read counterpart */
+static int rapl_write_data_raw(struct rapl_domain *rd,
+			enum rapl_primitives prim,
+			unsigned long long value)
+{
+	u64 msr_val;
+	u32 msr;
+	struct rapl_primitive_info *rp = &rpi[prim];
+	int cpu;
+
+	cpu = find_active_cpu_on_pkg(rd->pkg_id);
+	if (cpu < 0)
+		return cpu;
+	msr = rd->msrs[rp->id];
+	if (rdmsrl_safe_on_cpu(cpu, msr, &msr_val)) {
+		dev_dbg(&rd->pzone->device,
+			"failed to read msr 0x%x on cpu %d\n", msr, cpu);
+		return -EIO;
+	}
+	value = rapl_unit_xlate(rd->pkg_id, rp->unit, value, 1);
+	msr_val &= ~rp->mask;
+	msr_val |= value << rp->shift;
+	if (wrmsrl_safe_on_cpu(cpu, msr, msr_val)) {
+		dev_dbg(&rd->pzone->device,
+			"failed to write msr 0x%x on cpu %d\n", msr, cpu);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/* Raw RAPL data stored in MSRs are in certain scales. We need to
+ * convert them into standard units based on the divisors reported in
+ * the RAPL unit MSRs.
+ */
+static int rapl_check_unit(struct rapl_pkg *rp, int cpu)
+{
+	u64 msr_val;
+	u32 value;
+
+	if (rdmsrl_safe_on_cpu(cpu, MSR_RAPL_POWER_UNIT, &msr_val)) {
+		pr_err("Failed to read power unit MSR 0x%x on CPU %d, exit.\n",
+			MSR_RAPL_POWER_UNIT, cpu);
+		return -ENODEV;
+	}
+
+	/* energy unit: 1/enery_unit_divisor Joules */
+	value = (msr_val & ENERGY_UNIT_MASK) >> ENERGY_UNIT_OFFSET;
+	rp->energy_unit_divisor = 1 << value;
+
+	/* power unit: 1/power_unit_divisor Watts */
+	value = (msr_val & POWER_UNIT_MASK) >> POWER_UNIT_OFFSET;
+	rp->power_unit_divisor = 1 << value;
+
+	/* time unit: 1/time_unit_divisor Seconds */
+	value = (msr_val & TIME_UNIT_MASK) >> TIME_UNIT_OFFSET;
+	rp->time_unit_divisor = 1 << value;
+
+	pr_debug("Physical package %d units: energy=%d, time=%d, power=%d\n",
+		rp->id,
+		rp->energy_unit_divisor,
+		rp->time_unit_divisor,
+		rp->power_unit_divisor);
+
+	return 0;
+}
+
+/* REVISIT:
+ * When package power limit is set artificially low by RAPL, LVT
+ * thermal interrupt for package power limit should be ignored
+ * since we are not really exceeding the real limit. The intention
+ * is to avoid excessive interrupts while we are trying to save power.
+ * A useful feature might be routing the pkg_power_limit interrupt
+ * to userspace via eventfd. once we have a usecase, this is simple
+ * to do by adding an atomic notifier.
+ */
+
+/* disable and save the original per package power limit interrupt state */
+static void pkg_power_limit_irq_save(int pkg_id)
+{
+	u32 l, h = 0;
+	int cpu;
+	struct rapl_pkg *rp;
+
+	rp = find_package_by_id(pkg_id);
+	if (!rp)
+		return;
+
+	if (!boot_cpu_has(X86_FEATURE_PTS) || !boot_cpu_has(X86_FEATURE_PLN))
+		return;
+
+	cpu = find_active_cpu_on_pkg(pkg_id);
+	if (cpu < 0)
+		return;
+	/* save the state of PLN irq mask bit before disabling it */
+	rdmsr_safe_on_cpu(cpu, MSR_IA32_PACKAGE_THERM_INTERRUPT, &l, &h);
+	if (!(rp->power_limit_irq & PACKAGE_PLN_INT_SAVED)) {
+		rp->power_limit_irq = l & PACKAGE_THERM_INT_PLN_ENABLE;
+		rp->power_limit_irq |= PACKAGE_PLN_INT_SAVED;
+	}
+	l &= ~PACKAGE_THERM_INT_PLN_ENABLE;
+	wrmsr_on_cpu(cpu, MSR_IA32_PACKAGE_THERM_INTERRUPT, l, h);
+}
+
+/* restore per package power limit interrupt enable state */
+static void pkg_power_limit_irq_restore(int pkg_id)
+{
+	u32 l, h;
+	int cpu;
+	struct rapl_pkg *rp;
+
+	rp = find_package_by_id(pkg_id);
+	if (!rp)
+		return;
+
+	if (!boot_cpu_has(X86_FEATURE_PTS) || !boot_cpu_has(X86_FEATURE_PLN))
+		return;
+
+	cpu = find_active_cpu_on_pkg(pkg_id);
+	if (cpu < 0)
+		return;
+
+	/* irq enable state not saved, nothing to restore */
+	if (!(rp->power_limit_irq & PACKAGE_PLN_INT_SAVED))
+		return;
+	rdmsr_safe_on_cpu(cpu, MSR_IA32_PACKAGE_THERM_INTERRUPT, &l, &h);
+
+	if (rp->power_limit_irq & PACKAGE_THERM_INT_PLN_ENABLE)
+		l |= PACKAGE_THERM_INT_PLN_ENABLE;
+	else
+		l &= ~PACKAGE_THERM_INT_PLN_ENABLE;
+
+	wrmsr_on_cpu(cpu, MSR_IA32_PACKAGE_THERM_INTERRUPT, l, h);
+}
+
+static const struct x86_cpu_id rapl_ids[] = {
+	{ X86_VENDOR_INTEL, 6, 0x2a},/* SNB */
+	{ X86_VENDOR_INTEL, 6, 0x2d},/* SNB EP */
+	{ X86_VENDOR_INTEL, 6, 0x3a},/* IVB */
+	{ X86_VENDOR_INTEL, 6, 0x45},/* HSW */
+	/* TODO: Add more CPU IDs after testing */
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, rapl_ids);
+
+/* read once for all raw primitive data for all pkgs, domains */
+static void rapl_update_domain_data(void)
+{
+	int dmn, prim;
+	u64 val;
+	struct rapl_pkg *rp;
+
+	list_for_each_entry(rp, &rpkgs, plist) {
+		for (dmn = 0; dmn < rp->nr_domains; dmn++) {
+			pr_debug("update pkg %d domain %s data\n", rp->id,
+				rp->domains[dmn].name);
+			/* exclude non-raw primitives */
+			for (prim = 0; prim < NR_RAW_PRIMITIVES; prim++)
+				if (!rapl_read_data_raw(&rp->domains[dmn], prim,
+								rpi[prim].unit,
+								&val))
+					rp->domains[dmn].rdd.primitives[prim] =
+									val;
+		}
+	}
+
+}
+
+/* unregister all active rapl pkgs from the thermal layer, hotplug lock held */
+static int rapl_unregister_powercap(void)
+{
+	int i;
+	struct rapl_pkg *rp;
+	struct rapl_domain *rd, *rd_pkg = NULL;
+
+	list_for_each_entry(rp, &rpkgs, plist) {
+		pkg_power_limit_irq_restore(rp->id);
+		/* might only need to delete parent */
+		for (i = 0; i < rp->nr_domains; i++) {
+			rd = &rp->domains[i];
+
+			pr_debug("remove pkg %d, %s domain, undo power limit\n",
+				rp->id, rd->name);
+			rapl_write_data_raw(rd, pl1_enable, 0);
+			rapl_write_data_raw(rd, pl2_enable, 0);
+			rapl_write_data_raw(rd, pl1_clamp, 0);
+			rapl_write_data_raw(rd, pl2_clamp, 0);
+			if (rd->id == RAPL_DOMAIN_PKG) {
+				rd_pkg = rd;
+				continue;
+			}
+			powercap_zone_unregister(pccr, rd->pzone);
+		}
+		/* do the package zone last */
+		if (rd_pkg)
+			powercap_zone_unregister(pccr, rd_pkg->pzone);
+	}
+	powercap_deallocate_controller(pccr);
+
+	return 0;
+}
+
+static int rapl_pkg_register_powercap(struct rapl_pkg *rp)
+{
+	int i;
+	struct rapl_domain *rd;
+	int ret = 0;
+	char dev_name[POWERCAP_ZONE_NAME_LENGTH];
+	struct powercap_zone_device *pzdev = NULL;
+	int nr_pl;
+
+	/* first we register package domain as the parent zone*/
+	for (i = 0; i < rp->nr_domains; i++) {
+		rd = &rp->domains[i];
+		if (rd->id == RAPL_DOMAIN_PKG) {
+			nr_pl = find_nr_power_limit(rd);
+			pr_debug("register socket %d pkg domain %d\n",
+				rp->id, i);
+			memset(dev_name, 0, sizeof(dev_name));
+			snprintf(dev_name, sizeof(dev_name), "%s-%d",
+				rd->name, rp->id);
+			pzdev = powercap_zone_register(pccr, dev_name,
+						NULL, rd->ops, nr_pl, &const_ops);
+			if (IS_ERR(pzdev)) {
+				pr_debug("failed to register pkg, %d\n",
+					rp->id);
+				ret = PTR_ERR(pzdev);
+				goto exit_pkg;
+			}
+			powercap_set_zone_data(pzdev, rd);
+			rd->pzone = pzdev;
+			rp->pzone = pzdev;
+			/* done, only one package domain per socket */
+			break;
+		}
+	}
+	if (!pzdev) {
+		pr_err("no package domain found, unknown topology!\n");
+		ret = -ENODEV;
+		goto exit_pkg;
+	}
+	/* now register domains as children of the socket/package*/
+	for (i = 0; i < rp->nr_domains; i++) {
+		rd = &rp->domains[i];
+		if (rd->id == RAPL_DOMAIN_PKG)
+			continue;
+		/* number of power limits per domain varies */
+		nr_pl = find_nr_power_limit(rd);
+		pzdev = powercap_zone_register(pccr, rd->name,
+					rp->pzone, rd->ops, nr_pl, &const_ops);
+
+		if (IS_ERR(pzdev)) {
+			pr_debug("failed to register pzdev, %d:%s:%s\n",
+				rp->id, rd->name, dev_name);
+			ret = PTR_ERR(pzdev);
+			goto err_cleanup;
+		}
+		powercap_set_zone_data(pzdev, rd);
+		rd->pzone = pzdev;
+	}
+
+exit_pkg:
+	return ret;
+err_cleanup:
+	/* clean up previously initialized domains within the package if we
+	 * failed after the first domain setup.
+	 */
+	while (--i >= 0) {
+		pr_debug("unregister zone/pkg %d domain %d\n", rp->id, i);
+		rd = &rp->domains[i];
+		powercap_zone_unregister(pccr, rd->pzone);
+	}
+
+	return ret;
+}
+
+static int rapl_register_powercap(void)
+{
+	int i = 0;
+	struct rapl_domain *rd;
+	int ret = 0;
+	struct rapl_pkg *rp;
+
+	pccr = powercap_allocate_controller("intel-rapl");
+	if (IS_ERR(pccr)) {
+		pr_debug("failed to register powercap controller.\n");
+		return PTR_ERR(pccr);
+	}
+	/* read the initial data */
+	rapl_update_domain_data();
+	list_for_each_entry(rp, &rpkgs, plist)
+		if (rapl_pkg_register_powercap(rp))
+			goto err_cleanup_pkg;
+	return ret;
+
+err_cleanup_pkg:
+	/* clean up previously initialized pkgs */
+	list_for_each_entry_continue_reverse(rp, &rpkgs, plist) {
+		for (i = 0; i < rp->nr_domains; i++) {
+			rd = &rp->domains[i];
+			pr_debug("unregister zone/pkg %d, %s domain\n",
+				rp->id, rd->name);
+			powercap_zone_unregister(pccr, rd->pzone);
+		}
+	}
+
+	return ret;
+}
+
+static int rapl_check_domain(int cpu, int domain)
+{
+	unsigned msr;
+	u64 val1, val2 = 0;
+	int retry = 0;
+
+	switch (domain) {
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
+		pr_err("invalid domain id %d\n", domain);
+		return -EINVAL;
+	}
+	if (rdmsrl_safe_on_cpu(cpu, msr, &val1))
+		return -ENODEV;
+
+	/* energy counters roll slowly on some domains */
+	while (++retry < 10) {
+		usleep_range(10000, 15000);
+		rdmsrl_safe_on_cpu(cpu, msr, &val2);
+		if ((val1 & ENERGY_STATUS_MASK) != (val2 & ENERGY_STATUS_MASK))
+			return 0;
+	}
+	/* if energy counter does not change, report as bad domain */
+	pr_info("domain %s energy ctr %llu:%llu not working, skip\n",
+		rapl_domain_names[domain], val1, val2);
+
+	return -ENODEV;
+}
+
+/* Detect active and valid domains for the given CPU, caller must
+ * ensure the CPU belongs to the targeted package and CPU hotlug is disabled.
+ */
+static int rapl_detect_domains(struct rapl_pkg *rp, int cpu)
+{
+	int i;
+	int ret = 0;
+	struct rapl_domain *rd;
+	u64 locked;
+
+	for (i = 0; i < RAPL_DOMAIN_MAX; i++) {
+		/* use physical package id to read counters */
+		if (!rapl_check_domain(cpu, i))
+			rp->domain_map |= 1 << i;
+	}
+	rp->nr_domains = bitmap_weight(&rp->domain_map,	RAPL_DOMAIN_MAX);
+	if (!rp->nr_domains) {
+		pr_err("no valid rapl domains found in pkg %d\n", rp->id);
+		ret = -ENODEV;
+		goto done;
+	}
+	pr_debug("found %d domains on package %d\n", rp->nr_domains, rp->id);
+
+	rp->domains = kcalloc(rp->nr_domains + 1, sizeof(struct rapl_domain),
+			GFP_KERNEL);
+	if (!rp->domains) {
+		ret = -ENOMEM;
+		goto done;
+	}
+	rapl_init_domains(rp);
+
+	for (i = 0; i < rp->nr_domains; i++) {
+		rd = &rp->domains[i];
+		/* check if the domain is locked by BIOS */
+		if (rapl_read_data_raw(rd, lock, false, &locked)) {
+			pr_info("RAPL pkg %d domain %s locked by BIOS\n",
+				rp->id, rd->name);
+				rd->state |= DOMAIN_STATE_BIOS_LOCKED;
+		}
+	}
+
+
+done:
+	return ret;
+}
+
+static bool is_package_new(int pkg)
+{
+	struct rapl_pkg *rp;
+
+	/* caller prevents cpu hotplug, there will be no new packages added
+	 * or deleted while traversing the package list, no need for locking.
+	 */
+	list_for_each_entry(rp, &rpkgs, plist) {
+		if (pkg == rp->id)
+			return false;
+	}
+
+	return true;
+}
+
+/* RAPL interface can be made of a two-level hierarchy: package level and domain
+ * level. We first detect the number of packages then domains of each package.
+ * We have to consider the possiblity of CPU online/offline due to hotplug and
+ * other scenarios.
+ */
+static int rapl_detect_topology(void)
+{
+	int i;
+	int phy_pkg_id;
+	struct rapl_pkg *new_pkg, *rp;
+
+	for_each_online_cpu(i) {
+		phy_pkg_id = topology_physical_package_id(i);
+		if (is_package_new(phy_pkg_id)) {
+			new_pkg = kzalloc(sizeof(struct rapl_pkg), GFP_KERNEL);
+			if (!new_pkg) {
+				rapl_cleanup_data();
+				return -ENOMEM;
+			}
+			/* add the new package to the list */
+			new_pkg->id = phy_pkg_id;
+			new_pkg->nr_cpus = 1;
+
+			/* check if the package contains valid domains */
+			if (rapl_detect_domains(new_pkg, i) ||
+				rapl_check_unit(new_pkg, i)) {
+				kfree(new_pkg->domains);
+				kfree(new_pkg);
+				/* free up the pkgs already initialized */
+				rapl_cleanup_data();
+				return -ENODEV;
+			}
+			INIT_LIST_HEAD(&new_pkg->plist);
+			list_add(&new_pkg->plist, &rpkgs);
+		} else {
+			rp = find_package_by_id(phy_pkg_id);
+			if (rp)
+				++rp->nr_cpus;
+		}
+	}
+
+	return 0;
+}
+
+/* called from CPU hotplug notifier, hotplug lock held */
+static void rapl_remove_pkg(struct rapl_pkg *rp)
+{
+	struct rapl_domain *rd;
+	int i;
+
+	for (i = 0; i < rp->nr_domains; i++) {
+		rd = &rp->domains[i];
+		pr_debug("remove pkg %d, %s domain\n", rp->id, rd->name);
+		powercap_zone_unregister(pccr, rd->pzone);
+	}
+	kfree(rp->domains);
+	list_del(&rp->plist);
+	kfree(rp);
+}
+
+/* called from CPU hotplug notifier, hotplug lock held */
+static int rapl_add_pkg(int cpu)
+{
+	int ret = 0;
+	int phy_pkg_id;
+	struct rapl_pkg *rp;
+
+	phy_pkg_id = topology_physical_package_id(cpu);
+	rp = kzalloc(sizeof(struct rapl_pkg), GFP_KERNEL);
+	if (!rp)
+		return -ENOMEM;
+
+	/* add the new package to the list */
+	rp->id = phy_pkg_id;
+	rp->nr_cpus = 1;
+	/* check if the package contains valid domains */
+	if (rapl_detect_domains(rp, cpu) ||
+		rapl_check_unit(rp, cpu)) {
+		ret = -ENODEV;
+		goto err_free_pkg;
+	}
+	if (!rapl_pkg_register_powercap(rp)) {
+		INIT_LIST_HEAD(&rp->plist);
+		list_add(&rp->plist, &rpkgs);
+		return ret;
+	}
+
+err_free_pkg:
+	kfree(rp->domains);
+	kfree(rp);
+
+	return ret;
+}
+
+/* Handles CPU hotplug on multi-socket systems.
+ * If a CPU goes online as the first CPU of the physical package
+ * we add the RAPL package to the system. Similarly, when the last
+ * CPU of the package is removed, we remove the RAPL package and its
+ * associated domains. Cooling devices are handled accordingly at
+ * per-domain level.
+ */
+static int rapl_cpu_callback(struct notifier_block *nfb,
+				unsigned long action, void *hcpu)
+{
+	unsigned long cpu = (unsigned long)hcpu;
+	int phy_pkg_id;
+	struct rapl_pkg *rp;
+
+	phy_pkg_id = topology_physical_package_id(cpu);
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
+		rp = find_package_by_id(phy_pkg_id);
+		if (rp)
+			++rp->nr_cpus;
+		else
+			rapl_add_pkg(cpu);
+		break;
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		rp = find_package_by_id(phy_pkg_id);
+		if (!rp)
+			break;
+		if (--rp->nr_cpus == 0)
+			rapl_remove_pkg(rp);
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block rapl_cpu_notifier = {
+	.notifier_call = rapl_cpu_callback,
+};
+
+static int __init rapl_init(void)
+{
+	int ret = 0;
+
+	if (!x86_match_cpu(rapl_ids)) {
+		pr_err("driver does not support CPU family %d model %d\n",
+			boot_cpu_data.x86, boot_cpu_data.x86_model);
+
+		return -ENODEV;
+	}
+	/* prevent CPU hotplug during detection */
+	get_online_cpus();
+	ret = rapl_detect_topology();
+	if (ret)
+		goto done;
+
+	if (rapl_register_powercap()) {
+		rapl_cleanup_data();
+		ret = -ENODEV;
+		goto done;
+	}
+	register_hotcpu_notifier(&rapl_cpu_notifier);
+done:
+	put_online_cpus();
+
+	return ret;
+}
+
+static void __exit rapl_exit(void)
+{
+	get_online_cpus();
+	unregister_hotcpu_notifier(&rapl_cpu_notifier);
+	rapl_unregister_powercap();
+	rapl_cleanup_data();
+	put_online_cpus();
+}
+
+module_init(rapl_init);
+module_exit(rapl_exit);
+
+MODULE_DESCRIPTION("Driver for Intel RAPL (Running Average Power Limit)");
+MODULE_AUTHOR("Jacob Pan <jacob.jun.pan@intel.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.8.3.1

