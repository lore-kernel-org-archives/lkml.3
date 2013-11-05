Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3KERCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:02:21 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:64407 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab3KERCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:02:12 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: [PATCH v5 3/4] perf,x86: add Intel RAPL PMU support
Date: Tue,  5 Nov 2013 18:01:25 +0100
Message-Id: <1383670886-30827-4-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383670886-30827-1-git-send-email-eranian@google.com>
References: <1383670886-30827-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new uncore PMU to expose the Intel
RAPL energy consumption counters. Up to 3 counters,
each counting a particular RAPL event are exposed.

The RAPL counters are available on Intel SandyBridge,
IvyBridge, Haswell. The server skus add a 3rd counter.

The following events are available and exposed in sysfs:
- power/energy-cores: power consumption of all cores on socket
- power/energy-pkg: power consumption of all cores + LLc cache
- power/energy-dram: power consumption of DRAM (servers only)

For each event both the unit (Joules) and scale (2^-32 J)
is exposed in sysfs for use by perf stat and other tools.
Files are:
	/sys/devices/power/events/energy-*.unit
	/sys/devices/power/events/energy-*.scale

The RAPL PMU is uncore by nature and is implemented such
that it only works in system-wide mode. Measuring only
one CPU per socket is sufficient. The /sys/devices/power/cpumask
file can be used by tools to figure out which CPUs to monitor
by default. For instance, on a 2-socket system, 2 CPUs
(one on each socket) will be shown.

All the counters measure in the same unit (exposed via sysfs).
The perf_events API exposes all RAPL counters as 64-bit integers
counting in unit of 1/2^32 Joules (about 0.23 nJ). User level tools
must convert the counts by multiplying them by 2^-32 to obtain
Joules. The reason for this is that the kernel avoids
doing floating point math whenever possible because it is
expensive (user floating-point state must be saved). The method
used avoids kernel floating-point usage. There is no loss of
precision. Thanks to PeterZ for suggesting this approach.

To convert the raw count in Watts:
   W = C * 2.3 / (1e10 * time)
or ldexp(C, -32).

RAPL PMU is a new standalone PMU which registers with the
perf_event core subsystem. The PMU type (attr->type) is
dynamically allocated and is available from /sys/device/power/type.

Sampling is not supported by the RAPL PMU. There is no
privilege level filtering either.

Thanks to Maria Dimakopoulou for her contributions to this patch
especially on the floating-point aspects.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
---
 arch/x86/kernel/cpu/Makefile                |    2 +-
 arch/x86/kernel/cpu/perf_event_intel_rapl.c |  655 +++++++++++++++++++++++++++
 2 files changed, 656 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_intel_rapl.c

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 47b56a7..6359506 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -36,7 +36,7 @@ obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd_iommu.o
 endif
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_knc.o perf_event_p4.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
-obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o
+obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o perf_event_intel_rapl.o
 endif
 
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
new file mode 100644
index 0000000..cf3559f
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -0,0 +1,655 @@
+/*
+ * perf_event_intel_rapl.c: support Intel RAPL energy consumption counters
+ * Copyright (C) 2013 Google, Inc., Stephane Eranian
+ *
+ * Intel RAPL interface is specified in the IA-32 Manual Vol3b
+ * section 14.7.1 (September 2013)
+ *
+ * RAPL provides more controls than just reporting energy consumption
+ * however here we only expose the 3 energy consumption free running
+ * counters (pp0, pkg, dram).
+ *
+ * Each of those counters increments in a power unit defined by the
+ * RAPL_POWER_UNIT MSR. On SandyBridge, this unit is 1/(2^16) Joules
+ * but it can vary.
+ *
+ * Counter to rapl events mappings:
+ *
+ *  pp0 counter: consumption of all physical cores (power plane 0)
+ * 	  event: rapl_energy_cores
+ *    perf code: 0x1
+ *
+ *  pkg counter: consumption of the whole processor package
+ *	  event: rapl_energy_pkg
+ *    perf code: 0x2
+ *
+ * dram counter: consumption of the dram domain (servers only)
+ *	  event: rapl_energy_dram
+ *    perf code: 0x3
+ *
+ * We manage those counters as free running (read-only). They may be
+ * use simultaneously by other tools, such as turbostat.
+ *
+ * The events only support system-wide mode counting. There is no
+ * sampling support because it does not make sense and is not
+ * supported by the RAPL hardware.
+ *
+ * Because we want to avoid floating-point operations in the kernel,
+ * the events are all reported in fixed point arithmetic (32.32).
+ * Tools must adjust the counts to convert them to Watts using
+ * the duration of the measurement. Tools may use a function such as
+ * ldexp(raw_count, -32);
+ */
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/perf_event.h>
+#include <asm/cpu_device_id.h>
+#include "perf_event.h"
+
+/*
+ * RAPL energy status counters
+ */
+#define RAPL_IDX_PP0_NRG_STAT	0	/* all cores */
+#define INTEL_RAPL_PP0		0x1	/* pseudo-encoding */
+#define RAPL_IDX_PKG_NRG_STAT	1	/* entire package */
+#define INTEL_RAPL_PKG		0x2	/* pseudo-encoding */
+#define RAPL_IDX_RAM_NRG_STAT	2	/* DRAM */
+#define INTEL_RAPL_RAM		0x3	/* pseudo-encoding */
+
+/* Clients have PP0, PKG */
+#define RAPL_IDX_CLN	(1<<RAPL_IDX_PP0_NRG_STAT|\
+			 1<<RAPL_IDX_PKG_NRG_STAT)
+
+/* Servers have PP0, PKG, RAM */
+#define RAPL_IDX_SRV	(1<<RAPL_IDX_PP0_NRG_STAT|\
+			 1<<RAPL_IDX_PKG_NRG_STAT|\
+			 1<<RAPL_IDX_RAM_NRG_STAT)
+
+/*
+ * event code: LSB 8 bits, passed in attr->config
+ * any other bit is reserved
+ */
+#define RAPL_EVENT_MASK	0xFFULL
+
+#define DEFINE_RAPL_FORMAT_ATTR(_var, _name, _format)		\
+static ssize_t __rapl_##_var##_show(struct kobject *kobj,	\
+				struct kobj_attribute *attr,	\
+				char *page)			\
+{								\
+	BUILD_BUG_ON(sizeof(_format) >= PAGE_SIZE);		\
+	return sprintf(page, _format "\n");			\
+}								\
+static struct kobj_attribute format_attr_##_var =		\
+	__ATTR(_name, 0444, __rapl_##_var##_show, NULL)
+
+#define RAPL_EVENT_DESC(_name, _config)				\
+{								\
+	.attr	= __ATTR(_name, 0444, rapl_event_show, NULL),	\
+	.config	= _config,					\
+}
+
+#define RAPL_CNTR_WIDTH 32 /* 32-bit rapl counters */
+
+struct rapl_pmu {
+	spinlock_t	lock;
+	atomic_t	refcnt;
+	int		hw_unit;  /* 1/2^hw_unit Joule */
+	int		phys_id;
+	int		n_active; /* number of active events */
+	struct list_head active_list;
+};
+
+static struct pmu rapl_pmu_class;
+static cpumask_t rapl_cpu_mask;
+static int rapl_cntr_mask;
+
+static DEFINE_PER_CPU(struct rapl_pmu *, rapl_pmu);
+static DEFINE_PER_CPU(struct rapl_pmu *, rapl_pmu_kfree);
+
+static DEFINE_SPINLOCK(rapl_hotplug_lock);
+
+static inline u64 rapl_read_counter(struct perf_event *event)
+{
+	u64 raw;
+	rdmsrl(event->hw.event_base, raw);
+	return raw;
+}
+
+static inline u64 rapl_scale(u64 v)
+{
+	/*
+	 * scale delta to smallest unit (1/2^32)
+	 * users must then scale back: count * 1/(1e9*2^32) to get Joules
+	 * or use ldexp(count, -32).
+	 * Watts = Joules/Time delta
+	 */
+	return v << (32 - __get_cpu_var(rapl_pmu)->hw_unit);
+}
+
+static u64 rapl_event_update(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	u64 prev_raw_count, new_raw_count;
+	s64 delta, sdelta;
+	int shift = RAPL_CNTR_WIDTH;
+
+again:
+	prev_raw_count = local64_read(&hwc->prev_count);
+	rdmsrl(event->hw.event_base, new_raw_count);
+
+	if (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
+			    new_raw_count) != prev_raw_count) {
+		cpu_relax();
+		goto again;
+	}
+
+	/*
+	 * Now we have the new raw value and have updated the prev
+	 * timestamp already. We can now calculate the elapsed delta
+	 * (event-)time and add that to the generic event.
+	 *
+	 * Careful, not all hw sign-extends above the physical width
+	 * of the count.
+	 */
+	delta = (new_raw_count << shift) - (prev_raw_count << shift);
+	delta >>= shift;
+
+	sdelta = rapl_scale(delta);
+
+	local64_add(sdelta, &event->count);
+
+	return new_raw_count;
+}
+
+static void __rapl_pmu_event_start(struct rapl_pmu *pmu,
+				   struct perf_event *event)
+{
+	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
+		return;
+
+	event->hw.state = 0;
+
+	list_add_tail(&event->active_entry, &pmu->active_list);
+
+	local64_set(&event->hw.prev_count, rapl_read_counter(event));
+
+	pmu->n_active++;
+}
+
+static void rapl_pmu_event_start(struct perf_event *event, int mode)
+{
+	struct rapl_pmu *pmu = __get_cpu_var(rapl_pmu);
+	unsigned long flags;
+
+	spin_lock_irqsave(&pmu->lock, flags);
+	__rapl_pmu_event_start(pmu, event);
+	spin_unlock_irqrestore(&pmu->lock, flags);
+}
+
+static void rapl_pmu_event_stop(struct perf_event *event, int mode)
+{
+	struct rapl_pmu *pmu = __get_cpu_var(rapl_pmu);
+	struct hw_perf_event *hwc = &event->hw;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pmu->lock, flags);
+
+	/* mark event as deactivated and stopped */
+	if (!(hwc->state & PERF_HES_STOPPED)) {
+		WARN_ON_ONCE(pmu->n_active <= 0);
+		pmu->n_active--;
+
+		list_del(&event->active_entry);
+
+		WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
+		hwc->state |= PERF_HES_STOPPED;
+	}
+
+	/* check if update of sw counter is necessary */
+	if ((mode & PERF_EF_UPDATE) && !(hwc->state & PERF_HES_UPTODATE)) {
+		/*
+		 * Drain the remaining delta count out of a event
+		 * that we are disabling:
+		 */
+		rapl_event_update(event);
+		hwc->state |= PERF_HES_UPTODATE;
+	}
+
+	spin_unlock_irqrestore(&pmu->lock, flags);
+}
+
+static int rapl_pmu_event_add(struct perf_event *event, int mode)
+{
+	struct rapl_pmu *pmu = __get_cpu_var(rapl_pmu);
+	struct hw_perf_event *hwc = &event->hw;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pmu->lock, flags);
+
+	hwc->state = PERF_HES_UPTODATE | PERF_HES_STOPPED;
+
+	if (mode & PERF_EF_START)
+		__rapl_pmu_event_start(pmu, event);
+
+	spin_unlock_irqrestore(&pmu->lock, flags);
+
+	return 0;
+}
+
+static void rapl_pmu_event_del(struct perf_event *event, int flags)
+{
+	rapl_pmu_event_stop(event, PERF_EF_UPDATE);
+}
+
+static int rapl_pmu_event_init(struct perf_event *event)
+{
+	u64 cfg = event->attr.config & RAPL_EVENT_MASK;
+	int bit, msr, ret = 0;
+
+	/* only look at RAPL events */
+	if (event->attr.type != rapl_pmu_class.type)
+		return -ENOENT;
+
+	/* check only supported bits are set */
+	if (event->attr.config & ~RAPL_EVENT_MASK)
+		return -EINVAL;
+
+	/*
+	 * check event is known (determines counter)
+	 */
+	switch (cfg) {
+	case INTEL_RAPL_PP0:
+		bit = RAPL_IDX_PP0_NRG_STAT;
+		msr = MSR_PP0_ENERGY_STATUS;
+		break;
+	case INTEL_RAPL_PKG:
+		bit = RAPL_IDX_PKG_NRG_STAT;
+		msr = MSR_PKG_ENERGY_STATUS;
+		break;
+	case INTEL_RAPL_RAM:
+		bit = RAPL_IDX_RAM_NRG_STAT;
+		msr = MSR_DRAM_ENERGY_STATUS;
+		break;
+	default:
+		return -EINVAL;
+	}
+	/* check event supported */
+	if (!(rapl_cntr_mask & (1 << bit)))
+		return -EINVAL;
+
+	/* unsupported modes and filters */
+	if (event->attr.exclude_user   ||
+	    event->attr.exclude_kernel ||
+	    event->attr.exclude_hv     ||
+	    event->attr.exclude_idle   ||
+	    event->attr.exclude_host   ||
+	    event->attr.exclude_guest  ||
+	    event->attr.sample_period) /* no sampling */
+		return -EINVAL;
+
+	/* must be done before validate_group */
+	event->hw.event_base = msr;
+	event->hw.config = cfg;
+	event->hw.idx = bit;
+
+	return ret;
+}
+
+static void rapl_pmu_event_read(struct perf_event *event)
+{
+	rapl_event_update(event);
+}
+
+static ssize_t rapl_get_attr_cpumask(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int n = cpulist_scnprintf(buf, PAGE_SIZE - 2, &rapl_cpu_mask);
+
+	buf[n++] = '\n';
+	buf[n] = '\0';
+	return n;
+}
+
+static DEVICE_ATTR(cpumask, S_IRUGO, rapl_get_attr_cpumask, NULL);
+
+static struct attribute *rapl_pmu_attrs[] = {
+	&dev_attr_cpumask.attr,
+	NULL,
+};
+
+static struct attribute_group rapl_pmu_attr_group = {
+	.attrs = rapl_pmu_attrs,
+};
+
+EVENT_ATTR_STR(energy-cores, rapl_cores, "event=0x01");
+EVENT_ATTR_STR(energy-pkg  , rapl_pkg, "event=0x02");
+EVENT_ATTR_STR(energy-ram  , rapl_ram, "event=0x03");
+
+EVENT_ATTR_STR(energy-cores.unit, rapl_cores_unit, "Joules");
+EVENT_ATTR_STR(energy-pkg.unit  , rapl_pkg_unit, "Joules");
+EVENT_ATTR_STR(energy-ram.unit  , rapl_ram_unit, "Joules");
+
+/*
+ * we compute in 0.23 nJ increments regardless of MSR
+ */
+EVENT_ATTR_STR(energy-cores.scale, rapl_cores_scale, "2.3283064365386962890625e-10");
+EVENT_ATTR_STR(energy-pkg.scale, rapl_pkg_scale, "2.3283064365386962890625e-10");
+EVENT_ATTR_STR(energy-ram.scale, rapl_ram_scale, "2.3283064365386962890625e-10");
+
+static struct attribute *rapl_events_srv_attr[] = {
+	EVENT_PTR(rapl_cores),
+	EVENT_PTR(rapl_pkg),
+	EVENT_PTR(rapl_ram),
+
+	EVENT_PTR(rapl_cores_unit),
+	EVENT_PTR(rapl_pkg_unit),
+	EVENT_PTR(rapl_ram_unit),
+
+	EVENT_PTR(rapl_cores_scale),
+	EVENT_PTR(rapl_pkg_scale),
+	EVENT_PTR(rapl_ram_scale),
+	NULL,
+};
+
+static struct attribute *rapl_events_cln_attr[] = {
+	EVENT_PTR(rapl_cores),
+	EVENT_PTR(rapl_pkg),
+
+	EVENT_PTR(rapl_cores_unit),
+	EVENT_PTR(rapl_pkg_unit),
+
+	EVENT_PTR(rapl_cores_scale),
+	EVENT_PTR(rapl_pkg_scale),
+	NULL,
+};
+
+static struct attribute_group rapl_pmu_events_group = {
+	.name = "events",
+	.attrs = NULL, /* patched at runtime */
+};
+
+DEFINE_RAPL_FORMAT_ATTR(event, event, "config:0-7");
+static struct attribute *rapl_formats_attr[] = {
+	&format_attr_event.attr,
+	NULL,
+};
+
+static struct attribute_group rapl_pmu_format_group = {
+	.name = "format",
+	.attrs = rapl_formats_attr,
+};
+
+const struct attribute_group *rapl_attr_groups[] = {
+	&rapl_pmu_attr_group,
+	&rapl_pmu_format_group,
+	&rapl_pmu_events_group,
+	NULL,
+};
+
+static struct pmu rapl_pmu_class = {
+	.attr_groups	= rapl_attr_groups,
+	.task_ctx_nr	= perf_invalid_context, /* system-wide only */
+	.event_init	= rapl_pmu_event_init,
+	.add		= rapl_pmu_event_add, /* must have */
+	.del		= rapl_pmu_event_del, /* must have */
+	.start		= rapl_pmu_event_start,
+	.stop		= rapl_pmu_event_stop,
+	.read		= rapl_pmu_event_read,
+};
+
+static void rapl_exit_cpu(int cpu)
+{
+	int i, phys_id = topology_physical_package_id(cpu);
+
+	spin_lock(&rapl_hotplug_lock);
+
+	/* if CPU not in RAPL mask, nothing to do */
+	if (!cpumask_test_and_clear_cpu(cpu, &rapl_cpu_mask))
+		goto skip;
+
+	/* find a new cpu on same package */
+	for_each_online_cpu(i) {
+		if (i == cpu || i == 0)
+			continue;
+		if (phys_id == topology_physical_package_id(i)) {
+			cpumask_set_cpu(i, &rapl_cpu_mask);
+			break;
+		}
+	}
+
+	WARN_ON(cpumask_empty(&rapl_cpu_mask));
+skip:
+	spin_unlock(&rapl_hotplug_lock);
+}
+
+static void rapl_init_cpu(int cpu)
+{
+	int i, phys_id = topology_physical_package_id(cpu);
+
+	spin_lock(&rapl_hotplug_lock);
+
+	/* check if phys_is is already covered */
+	for_each_cpu(i, &rapl_cpu_mask) {
+		if (phys_id == topology_physical_package_id(i))
+			goto skip;
+	}
+	/* was not found, so add it */
+	cpumask_set_cpu(cpu, &rapl_cpu_mask);
+skip:
+	spin_unlock(&rapl_hotplug_lock);
+}
+
+static int rapl_cpu_prepare(int cpu)
+{
+	struct rapl_pmu *pmu = per_cpu(rapl_pmu, cpu);
+	int phys_id = topology_physical_package_id(cpu);
+
+	if (pmu)
+		return 0;
+
+	if (phys_id < 0)
+		return -1;
+
+	pmu = kzalloc_node(sizeof(*pmu), GFP_KERNEL, cpu_to_node(cpu));
+	if (!pmu)
+		return -1;
+
+	spin_lock_init(&pmu->lock);
+	atomic_set(&pmu->refcnt, 1);
+
+	INIT_LIST_HEAD(&pmu->active_list);
+
+	pmu->phys_id = phys_id;
+	/*
+	 * grab power unit as: 1/2^unit Joules
+	 *
+	 * we cache in local PMU instance
+	 */
+	rdmsrl(MSR_RAPL_POWER_UNIT, pmu->hw_unit);
+	pmu->hw_unit = (pmu->hw_unit >> 8) & 0x1FULL;
+
+	/* set RAPL pmu for this cpu for now */
+	per_cpu(rapl_pmu_kfree, cpu) = NULL;
+	per_cpu(rapl_pmu, cpu) = pmu;
+
+	return 0;
+}
+
+static int rapl_cpu_starting(int cpu)
+{
+	struct rapl_pmu *pmu2;
+	struct rapl_pmu *pmu1 = per_cpu(rapl_pmu, cpu);
+	int i, phys_id = topology_physical_package_id(cpu);
+
+	if (pmu1)
+		return 0;
+
+	spin_lock(&rapl_hotplug_lock);
+
+	for_each_online_cpu(i) {
+		pmu2 = per_cpu(rapl_pmu, i);
+
+		if (!pmu2 || i == cpu)
+			continue;
+
+		if (pmu2->phys_id == phys_id) {
+			per_cpu(rapl_pmu, cpu) = pmu2;
+			per_cpu(rapl_pmu_kfree, cpu) = pmu1;
+			atomic_inc(&pmu2->refcnt);
+			break;
+		}
+	}
+	spin_unlock(&rapl_hotplug_lock);
+	return 0;
+}
+
+static int rapl_cpu_dying(int cpu)
+{
+	struct rapl_pmu *pmu = per_cpu(rapl_pmu, cpu);
+	struct perf_event *event, *tmp;
+
+	if (!pmu)
+		return 0;
+
+	spin_lock(&rapl_hotplug_lock);
+
+	/*
+	 * stop all syswide RAPL events on that  CPU
+	 * as a consequence also stops the hrtimer
+	 */
+	list_for_each_entry_safe(event, tmp, &pmu->active_list, active_entry) {
+		rapl_pmu_event_stop(event, PERF_EF_UPDATE);
+	}
+
+	per_cpu(rapl_pmu, cpu) = NULL;
+
+	if (atomic_dec_and_test(&pmu->refcnt))
+		kfree(pmu);
+
+	spin_unlock(&rapl_hotplug_lock);
+	return 0;
+}
+
+static int rapl_cpu_notifier(struct notifier_block *self,
+			     unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (long)hcpu;
+
+	/* allocate/free data structure for uncore box */
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+		rapl_cpu_prepare(cpu);
+		break;
+	case CPU_STARTING:
+		rapl_cpu_starting(cpu);
+		break;
+	case CPU_UP_CANCELED:
+	case CPU_DYING:
+		rapl_cpu_dying(cpu);
+		break;
+	case CPU_ONLINE:
+		kfree(per_cpu(rapl_pmu_kfree, cpu));
+		per_cpu(rapl_pmu_kfree, cpu) = NULL;
+		break;
+	case CPU_DEAD:
+		per_cpu(rapl_pmu, cpu) = NULL;
+		break;
+	default:
+		break;
+	}
+
+	/* select the cpu that collects uncore events */
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_DOWN_FAILED:
+	case CPU_STARTING:
+		rapl_init_cpu(cpu);
+		break;
+	case CPU_DOWN_PREPARE:
+		rapl_exit_cpu(cpu);
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static const struct x86_cpu_id rapl_cpu_match[] = {
+	[0] = { .vendor = X86_VENDOR_INTEL, .family = 6 },
+	[1] = {},
+};
+static int __init rapl_pmu_init(void)
+{
+	struct rapl_pmu *pmu;
+	int i, cpu, ret;
+
+	/*
+	 * check for Intel processor family 6
+	 */
+	if (!x86_match_cpu(rapl_cpu_match))
+		return 0;
+
+	/* check supported CPU */
+	switch (boot_cpu_data.x86_model) {
+	case 42: /* Sandy Bridge */
+	case 58: /* Ivy Bridge */
+	case 60: /* Haswell */
+		rapl_cntr_mask = RAPL_IDX_CLN;
+		rapl_pmu_events_group.attrs = rapl_events_cln_attr;
+		break;
+	case 45: /* Sandy Bridge-EP */
+	case 62: /* IvyTown */
+		rapl_cntr_mask = RAPL_IDX_SRV;
+		rapl_pmu_events_group.attrs = rapl_events_srv_attr;
+		break;
+
+	default:
+		/* unsupported */
+		return 0;
+	}
+	get_online_cpus();
+
+	for_each_online_cpu(cpu) {
+		int phys_id = topology_physical_package_id(cpu);
+
+		/* save on prepare by only calling prepare for new phys_id */
+		for_each_cpu(i, &rapl_cpu_mask) {
+			if (phys_id == topology_physical_package_id(i)) {
+				phys_id = -1;
+				break;
+			}
+		}
+		if (phys_id < 0) {
+			pmu = per_cpu(rapl_pmu, i);
+			if (pmu) {
+				per_cpu(rapl_pmu, cpu) = pmu;
+				atomic_inc(&pmu->refcnt);
+			}
+			continue;
+		}
+		rapl_cpu_prepare(cpu);
+		cpumask_set_cpu(cpu, &rapl_cpu_mask);
+	}
+
+	perf_cpu_notifier(rapl_cpu_notifier);
+
+	ret = perf_pmu_register(&rapl_pmu_class, "power", -1);
+	if (WARN_ON(ret)) {
+		pr_info("RAPL PMU detected, registration failed (%d), RAPL PMU disabled\n", ret);
+		put_online_cpus();
+		return -1;
+	}
+
+	pmu = __get_cpu_var(rapl_pmu);
+
+	pr_info("RAPL PMU detected, hw unit 2^-%d Joules,"
+		" API unit is 2^-32 Joules,"
+		" %d fixed counters\n",
+		pmu->hw_unit,
+		hweight32(rapl_cntr_mask));
+
+	put_online_cpus();
+
+	return 0;
+}
+device_initcall(rapl_pmu_init);
-- 
1.7.9.5

