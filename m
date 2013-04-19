Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082Ab3DSVfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 17:35:15 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:22579
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933914Ab3DSVfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 17:35:12 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dI936eI1432I111aIc8kzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLIULH-02-0HL-02
X-M-MSG: 
Date: Fri, 19 Apr 2013 16:34:28 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf, amd: support for AMD NB and L2I "uncore"
 counters.
Message-ID: <20130419213428.GA8229@jshin-Toonie>
References: <1366046483-1765-1-git-send-email-jacob.shin@amd.com>
 <1366046483-1765-3-git-send-email-jacob.shin@amd.com>
 <1366284534.19383.13.camel@laptop>
 <20130418163315.GA7903@jshin-Toonie>
 <1366374436.24945.6.camel@laptop>
 <20130419144100.GA2894@jshin-Toonie>
 <1366397724.24945.8.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1366397724.24945.8.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 08:55:24PM +0200, Peter Zijlstra wrote:
> On Fri, 2013-04-19 at 09:41 -0500, Jacob Shin wrote:
> > 
> > Thank you again, for taking the time.
> 
> Ah something I just remembered, could you do a patch like the below
> one? That makes things like perf stat -A work as expected.

Ah, okay. Here is V3 that also creates "cpumask" sysfs file. Tested
that the "perf stat -a .." works as expected.

Thanks again,

V3:
- Added "cpumask" attribute to sysfs to get "perf stat -a .." working
  correctly

V2:
- Added event migration if possible when CPU goes offline

>From fc8a5328069496187f7749a32acbe319dedbb548 Mon Sep 17 00:00:00 2001
From: Jacob Shin <jacob.shin@amd.com>
Date: Sun, 14 Apr 2013 04:12:42 -0500
Subject: [PATCH V3 2/2] perf, amd: support for AMD NB and L2I "uncore" counters.

Add support for AMD Family 15h [and above] northbridge performance
counters. MSRs 0xc0010240 ~ 0xc0010247 are shared across all cores
that share a common northbridge.

Add support for AMD Family 16h L2 performance counters. MSRs
0xc0010230 ~ 0xc0010237 are shared across all cores that share a
common L2 cache.

We do not enable counter overflow interrupts. Sampling mode and
per-thread events are not supported.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/include/asm/cpufeature.h           |    2 +
 arch/x86/include/uapi/asm/msr-index.h       |    4 +
 arch/x86/kernel/cpu/Makefile                |    2 +-
 arch/x86/kernel/cpu/perf_event_amd_uncore.c |  546 +++++++++++++++++++++++++++
 4 files changed, 553 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_uncore.c

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 93fe929..ac10df7 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -168,6 +168,7 @@
 #define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
 #define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter extensions */
 #define X86_FEATURE_PERFCTR_NB  (6*32+24) /* NB performance counter extensions */
+#define X86_FEATURE_PERFCTR_L2	(6*32+28) /* L2 performance counter extensions */
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
@@ -311,6 +312,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
 #define cpu_has_perfctr_core	boot_cpu_has(X86_FEATURE_PERFCTR_CORE)
 #define cpu_has_perfctr_nb	boot_cpu_has(X86_FEATURE_PERFCTR_NB)
+#define cpu_has_perfctr_l2	boot_cpu_has(X86_FEATURE_PERFCTR_L2)
 #define cpu_has_cx8		boot_cpu_has(X86_FEATURE_CX8)
 #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
 #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index bf7bb68..b575788 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -196,6 +196,10 @@
 #define MSR_AMD64_IBSBRTARGET		0xc001103b
 #define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
 
+/* Fam 16h MSRs */
+#define MSR_F16H_L2I_PERF_CTL		0xc0010230
+#define MSR_F16H_L2I_PERF_CTR		0xc0010231
+
 /* Fam 15h MSRs */
 #define MSR_F15H_PERF_CTL		0xc0010200
 #define MSR_F15H_PERF_CTR		0xc0010201
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index a0e067d..0074572 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -31,7 +31,7 @@ obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
 
 ifdef CONFIG_PERF_EVENTS
-obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o
+obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o perf_event_amd_uncore.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_knc.o perf_event_p4.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o
diff --git a/arch/x86/kernel/cpu/perf_event_amd_uncore.c b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
new file mode 100644
index 0000000..6dc6227
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
@@ -0,0 +1,546 @@
+/*
+ * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ *
+ * Author: Jacob Shin <jacob.shin@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/perf_event.h>
+#include <linux/percpu.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/cpu.h>
+#include <linux/cpumask.h>
+
+#include <asm/cpufeature.h>
+#include <asm/perf_event.h>
+#include <asm/msr.h>
+
+#define NUM_COUNTERS_NB		4
+#define NUM_COUNTERS_L2		4
+#define MAX_COUNTERS		NUM_COUNTERS_NB
+
+#define RDPMC_BASE_NB		6
+#define RDPMC_BASE_L2		10
+
+#define COUNTER_SHIFT		16
+
+struct amd_uncore {
+	int id;
+	int refcnt;
+	int cpu;
+	int num_counters;
+	int rdpmc_base;
+	u32 msr_base;
+	cpumask_t *active_mask;
+	struct pmu *pmu;
+	struct perf_event *events[MAX_COUNTERS];
+	struct amd_uncore *free_when_cpu_online;
+};
+
+static struct amd_uncore * __percpu *amd_uncore_nb;
+static struct amd_uncore * __percpu *amd_uncore_l2;
+
+static struct pmu amd_nb_pmu;
+static struct pmu amd_l2_pmu;
+
+static cpumask_t amd_nb_active_mask;
+static cpumask_t amd_l2_active_mask;
+
+static bool is_nb_event(struct perf_event *event)
+{
+	return event->pmu->type == amd_nb_pmu.type;
+}
+
+static bool is_l2_event(struct perf_event *event)
+{
+	return event->pmu->type == amd_l2_pmu.type;
+}
+
+static struct amd_uncore *event_to_amd_uncore(struct perf_event *event)
+{
+	if (is_nb_event(event) && amd_uncore_nb)
+		return *per_cpu_ptr(amd_uncore_nb, event->cpu);
+	else if (is_l2_event(event) && amd_uncore_l2)
+		return *per_cpu_ptr(amd_uncore_l2, event->cpu);
+
+	return NULL;
+}
+
+static void amd_uncore_read(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	u64 prev, new;
+	s64 delta;
+
+	/*
+	 * since we do not enable counter overflow interrupts,
+	 * we do not have to worry about prev_count changing on us
+	 */
+
+	prev = local64_read(&hwc->prev_count);
+	rdpmcl(hwc->event_base_rdpmc, new);
+	local64_set(&hwc->prev_count, new);
+	delta = (new << COUNTER_SHIFT) - (prev << COUNTER_SHIFT);
+	delta >>= COUNTER_SHIFT;
+	local64_add(delta, &event->count);
+}
+
+static void amd_uncore_start(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (flags & PERF_EF_RELOAD)
+		wrmsrl(hwc->event_base, (u64)local64_read(&hwc->prev_count));
+
+	hwc->state = 0;
+	wrmsrl(hwc->config_base, (hwc->config | ARCH_PERFMON_EVENTSEL_ENABLE));
+	perf_event_update_userpage(event);
+}
+
+static void amd_uncore_stop(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	wrmsrl(hwc->config_base, hwc->config);
+	hwc->state |= PERF_HES_STOPPED;
+
+	if ((flags & PERF_EF_UPDATE) && !(hwc->state & PERF_HES_UPTODATE)) {
+		amd_uncore_read(event);
+		hwc->state |= PERF_HES_UPTODATE;
+	}
+}
+
+static int amd_uncore_add(struct perf_event *event, int flags)
+{
+	int i;
+	struct amd_uncore *uncore = event_to_amd_uncore(event);
+	struct hw_perf_event *hwc = &event->hw;
+
+	/* are we already assigned? */
+	if (hwc->idx != -1 && uncore->events[hwc->idx] == event)
+		goto out;
+
+	for (i = 0; i < uncore->num_counters; i++) {
+		if (uncore->events[i] == event) {
+			hwc->idx = i;
+			goto out;
+		}
+	}
+
+	/* if not, take the first available counter */
+	hwc->idx = -1;
+	for (i = 0; i < uncore->num_counters; i++) {
+		if (cmpxchg(&uncore->events[i], NULL, event) == NULL) {
+			hwc->idx = i;
+			break;
+		}
+	}
+
+out:
+	if (hwc->idx == -1)
+		return -EBUSY;
+
+	hwc->config_base = uncore->msr_base + (2 * hwc->idx);
+	hwc->event_base = uncore->msr_base + 1 + (2 * hwc->idx);
+	hwc->event_base_rdpmc = uncore->rdpmc_base + hwc->idx;
+	hwc->state = PERF_HES_UPTODATE | PERF_HES_STOPPED;
+
+	if (flags & PERF_EF_START)
+		amd_uncore_start(event, PERF_EF_RELOAD);
+
+	return 0;
+}
+
+static void amd_uncore_del(struct perf_event *event, int flags)
+{
+	int i;
+	struct amd_uncore *uncore = event_to_amd_uncore(event);
+	struct hw_perf_event *hwc = &event->hw;
+
+	amd_uncore_stop(event, PERF_EF_UPDATE);
+
+	for (i = 0; i < uncore->num_counters; i++) {
+		if (cmpxchg(&uncore->events[i], event, NULL) == event)
+			break;
+	}
+
+	hwc->idx = -1;
+}
+
+static int amd_uncore_event_init(struct perf_event *event)
+{
+	struct amd_uncore *uncore;
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (event->attr.type != event->pmu->type)
+		return -ENOENT;
+
+	/*
+	 * NB and L2 counters (MSRs) are shared across all cores that share the
+	 * same NB / L2 cache. Interrupts can be directed to a single target
+	 * core, however, event counts generated by processes running on other
+	 * cores cannot be masked out. So we do not support sampling and
+	 * per-thread events.
+	 */
+	if (is_sampling_event(event) || event->attach_state & PERF_ATTACH_TASK)
+		return -EINVAL;
+
+	/* NB and L2 counters do not have usr/os/guest/host bits */
+	if (event->attr.exclude_user || event->attr.exclude_kernel ||
+	    event->attr.exclude_host || event->attr.exclude_guest)
+		return -EINVAL;
+
+	/* and we do not enable counter overflow interrupts */
+	hwc->config = event->attr.config & AMD64_RAW_EVENT_MASK_NB;
+	hwc->idx = -1;
+
+	if (event->cpu < 0)
+		return -EINVAL;
+
+	uncore = event_to_amd_uncore(event);
+	if (!uncore)
+		return -ENODEV;
+
+	/*
+	 * since request can come in to any of the shared cores, we will remap
+	 * to a single common cpu.
+	 */
+	event->cpu = uncore->cpu;
+
+	return 0;
+}
+
+static ssize_t amd_uncore_attr_show_cpumask(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	int n;
+	cpumask_t *active_mask;
+	struct pmu *pmu = dev_get_drvdata(dev);
+
+	if (pmu->type == amd_nb_pmu.type)
+		active_mask = &amd_nb_active_mask;
+	else if (pmu->type == amd_l2_pmu.type)
+		active_mask = &amd_l2_active_mask;
+	else
+		return 0;
+
+	n = cpulist_scnprintf(buf, PAGE_SIZE - 2, active_mask);
+	buf[n++] = '\n';
+	buf[n] = '\0';
+	return n;
+}
+static DEVICE_ATTR(cpumask, S_IRUGO, amd_uncore_attr_show_cpumask, NULL);
+
+static struct attribute *amd_uncore_attrs[] = {
+	&dev_attr_cpumask.attr,
+	NULL,
+};
+
+static struct attribute_group amd_uncore_attr_group = {
+	.attrs = amd_uncore_attrs,
+};
+
+PMU_FORMAT_ATTR(event, "config:0-7,32-35");
+PMU_FORMAT_ATTR(umask, "config:8-15");
+
+static struct attribute *amd_uncore_format_attr[] = {
+	&format_attr_event.attr,
+	&format_attr_umask.attr,
+	NULL,
+};
+
+static struct attribute_group amd_uncore_format_group = {
+	.name = "format",
+	.attrs = amd_uncore_format_attr,
+};
+
+static const struct attribute_group *amd_uncore_attr_groups[] = {
+	&amd_uncore_attr_group,
+	&amd_uncore_format_group,
+	NULL,
+};
+
+static struct pmu amd_nb_pmu = {
+	.attr_groups	= amd_uncore_attr_groups,
+	.name		= "amd_nb",
+	.event_init	= amd_uncore_event_init,
+	.add		= amd_uncore_add,
+	.del		= amd_uncore_del,
+	.start		= amd_uncore_start,
+	.stop		= amd_uncore_stop,
+	.read		= amd_uncore_read,
+};
+
+static struct pmu amd_l2_pmu = {
+	.attr_groups	= amd_uncore_attr_groups,
+	.name		= "amd_l2",
+	.event_init	= amd_uncore_event_init,
+	.add		= amd_uncore_add,
+	.del		= amd_uncore_del,
+	.start		= amd_uncore_start,
+	.stop		= amd_uncore_stop,
+	.read		= amd_uncore_read,
+};
+
+static struct amd_uncore * __cpuinit amd_uncore_alloc(unsigned int cpu)
+{
+	return kzalloc_node(sizeof(struct amd_uncore), GFP_KERNEL,
+			cpu_to_node(cpu));
+}
+
+static void __cpuinit amd_uncore_cpu_up_prepare(unsigned int cpu)
+{
+	struct amd_uncore *uncore;
+
+	if (amd_uncore_nb) {
+		uncore = amd_uncore_alloc(cpu);
+		uncore->cpu = cpu;
+		uncore->num_counters = NUM_COUNTERS_NB;
+		uncore->rdpmc_base = RDPMC_BASE_NB;
+		uncore->msr_base = MSR_F15H_NB_PERF_CTL;
+		uncore->active_mask = &amd_nb_active_mask;
+		uncore->pmu = &amd_nb_pmu;
+		*per_cpu_ptr(amd_uncore_nb, cpu) = uncore;
+	}
+
+	if (amd_uncore_l2) {
+		uncore = amd_uncore_alloc(cpu);
+		uncore->cpu = cpu;
+		uncore->num_counters = NUM_COUNTERS_L2;
+		uncore->rdpmc_base = RDPMC_BASE_L2;
+		uncore->msr_base = MSR_F16H_L2I_PERF_CTL;
+		uncore->active_mask = &amd_l2_active_mask;
+		uncore->pmu = &amd_l2_pmu;
+		*per_cpu_ptr(amd_uncore_l2, cpu) = uncore;
+	}
+}
+
+static struct amd_uncore *
+__cpuinit amd_uncore_find_online_sibling(struct amd_uncore *this,
+					 struct amd_uncore * __percpu *uncores)
+{
+	unsigned int cpu;
+	struct amd_uncore *that;
+
+	for_each_online_cpu(cpu) {
+		that = *per_cpu_ptr(uncores, cpu);
+
+		if (!that)
+			continue;
+
+		if (this == that)
+			continue;
+
+		if (this->id == that->id) {
+			that->free_when_cpu_online = this;
+			this = that;
+			break;
+		}
+	}
+
+	this->refcnt++;
+	return this;
+}
+
+static void __cpuinit amd_uncore_cpu_starting(unsigned int cpu)
+{
+	unsigned int eax, ebx, ecx, edx;
+	struct amd_uncore *uncore;
+
+	if (amd_uncore_nb) {
+		uncore = *per_cpu_ptr(amd_uncore_nb, cpu);
+		cpuid(0x8000001e, &eax, &ebx, &ecx, &edx);
+		uncore->id = ecx & 0xff;
+
+		uncore = amd_uncore_find_online_sibling(uncore, amd_uncore_nb);
+		*per_cpu_ptr(amd_uncore_nb, cpu) = uncore;
+	}
+
+	if (amd_uncore_l2) {
+		unsigned int apicid = cpu_data(cpu).apicid;
+		unsigned int nshared;
+
+		uncore = *per_cpu_ptr(amd_uncore_l2, cpu);
+		cpuid_count(0x8000001d, 2, &eax, &ebx, &ecx, &edx);
+		nshared = ((eax >> 14) & 0xfff) + 1;
+		uncore->id = apicid - (apicid % nshared);
+
+		uncore = amd_uncore_find_online_sibling(uncore, amd_uncore_l2);
+		*per_cpu_ptr(amd_uncore_l2, cpu) = uncore;
+	}
+}
+
+static void __cpuinit uncore_online(unsigned int cpu,
+				    struct amd_uncore * __percpu *uncores)
+{
+	struct amd_uncore *uncore = *per_cpu_ptr(uncores, cpu);
+
+	kfree(uncore->free_when_cpu_online);
+	uncore->free_when_cpu_online = NULL;
+
+	if (cpu == uncore->cpu)
+		cpumask_set_cpu(cpu, uncore->active_mask);
+}
+
+static void __cpuinit amd_uncore_cpu_online(unsigned int cpu)
+{
+	if (amd_uncore_nb)
+		uncore_online(cpu, amd_uncore_nb);
+
+	if (amd_uncore_l2)
+		uncore_online(cpu, amd_uncore_l2);
+}
+
+static void __cpuinit uncore_down_prepare(unsigned int cpu,
+					  struct amd_uncore * __percpu *uncores)
+{
+	unsigned int i;
+	struct amd_uncore *this = *per_cpu_ptr(uncores, cpu);
+
+	if (this->cpu != cpu)
+		return;
+
+	/* this cpu is going down, migrate to a shared sibling if possible */
+	for_each_online_cpu(i) {
+		struct amd_uncore *that = *per_cpu_ptr(uncores, i);
+
+		if (cpu == i)
+			continue;
+
+		if (this == that) {
+			perf_pmu_migrate_context(this->pmu, cpu, i);
+			cpumask_clear_cpu(cpu, that->active_mask);
+			cpumask_set_cpu(i, that->active_mask);
+			that->cpu = i;
+			break;
+		}
+	}
+}
+
+static void __cpuinit amd_uncore_cpu_down_prepare(unsigned int cpu)
+{
+	if (amd_uncore_nb)
+		uncore_down_prepare(cpu, amd_uncore_nb);
+
+	if (amd_uncore_l2)
+		uncore_down_prepare(cpu, amd_uncore_l2);
+}
+
+static void __cpuinit uncore_dead(unsigned int cpu,
+				  struct amd_uncore * __percpu *uncores)
+{
+	struct amd_uncore *uncore = *per_cpu_ptr(uncores, cpu);
+
+	if (cpu == uncore->cpu)
+		cpumask_clear_cpu(cpu, uncore->active_mask);
+
+	if (!--uncore->refcnt)
+		kfree(uncore);
+	*per_cpu_ptr(amd_uncore_nb, cpu) = NULL;
+}
+
+static void __cpuinit amd_uncore_cpu_dead(unsigned int cpu)
+{
+	if (amd_uncore_nb)
+		uncore_dead(cpu, amd_uncore_nb);
+
+	if (amd_uncore_l2)
+		uncore_dead(cpu, amd_uncore_l2);
+}
+
+static int __cpuinit
+amd_uncore_cpu_notifier(struct notifier_block *self, unsigned long action,
+			void *hcpu)
+{
+	unsigned int cpu = (long)hcpu;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+		amd_uncore_cpu_up_prepare(cpu);
+		break;
+
+	case CPU_STARTING:
+		amd_uncore_cpu_starting(cpu);
+		break;
+
+	case CPU_ONLINE:
+		amd_uncore_cpu_online(cpu);
+		break;
+
+	case CPU_DOWN_PREPARE:
+		amd_uncore_cpu_down_prepare(cpu);
+		break;
+
+	case CPU_UP_CANCELED:
+	case CPU_DEAD:
+		amd_uncore_cpu_dead(cpu);
+		break;
+
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block amd_uncore_cpu_notifier_block __cpuinitdata = {
+	.notifier_call	= amd_uncore_cpu_notifier,
+	.priority	= CPU_PRI_PERF + 1,
+};
+
+static void __init init_cpu_already_online(void *dummy)
+{
+	unsigned int cpu = smp_processor_id();
+
+	amd_uncore_cpu_up_prepare(cpu);
+	amd_uncore_cpu_starting(cpu);
+	amd_uncore_cpu_online(cpu);
+}
+
+static int __init amd_uncore_init(void)
+{
+	unsigned int cpu;
+	int ret = -ENODEV;
+
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
+		return -ENODEV;
+
+	if (!cpu_has_topoext)
+		return -ENODEV;
+
+	if (cpu_has_perfctr_nb) {
+		amd_uncore_nb = alloc_percpu(struct amd_uncore *);
+		perf_pmu_register(&amd_nb_pmu, amd_nb_pmu.name, -1);
+
+		printk(KERN_INFO "perf: AMD NB counters detected\n");
+		ret = 0;
+	}
+
+	if (cpu_has_perfctr_l2) {
+		amd_uncore_l2 = alloc_percpu(struct amd_uncore *);
+		perf_pmu_register(&amd_l2_pmu, amd_l2_pmu.name, -1);
+
+		printk(KERN_INFO "perf: AMD L2I counters detected\n");
+		ret = 0;
+	}
+
+	if (ret)
+		return -ENODEV;
+
+	get_online_cpus();
+	/* init cpus already online before registering for hotplug notifier */
+	for_each_online_cpu(cpu)
+		smp_call_function_single(cpu, init_cpu_already_online, NULL, 1);
+
+	register_cpu_notifier(&amd_uncore_cpu_notifier_block);
+	put_online_cpus();
+
+	return 0;
+}
+device_initcall(amd_uncore_init);
-- 
1.7.9.5


