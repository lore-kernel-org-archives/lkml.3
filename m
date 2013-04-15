Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab3DORVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:21:47 -0400
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:45458
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755311Ab3DORVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:21:44 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VPS3(zzc8kzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLB47X-02-42J-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 2/2] perf, amd: support for AMD NB and L2I "uncore" counters.
Date: Mon, 15 Apr 2013 12:21:23 -0500
Message-ID: <1366046483-1765-3-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366046483-1765-1-git-send-email-jacob.shin@amd.com>
References: <1366046483-1765-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 arch/x86/kernel/cpu/perf_event_amd_uncore.c |  442 +++++++++++++++++++++++++++
 4 files changed, 449 insertions(+), 1 deletion(-)
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
index 0000000..384f674
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
@@ -0,0 +1,442 @@
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
+
+#include "perf_event.h"
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
+	int num_counters;
+	int rdpmc_base;
+	u32 msr_base;
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
+	if (event->cpu < 0)
+		return -EINVAL;
+
+	hwc->idx = -1;
+
+	/* and we do not enable counter overflow interrupts */
+	hwc->config = event->attr.config & AMD64_RAW_EVENT_MASK_NB;
+
+	return 0;
+}
+
+PMU_FORMAT_ATTR(event,	"config:0-7,32-35");
+PMU_FORMAT_ATTR(umask,	"config:8-15"	);
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
+static void __cpuinit amd_uncore_cpu_prepare(unsigned int cpu)
+{
+	struct amd_uncore *uncore;
+
+	if (amd_uncore_nb) {
+		uncore = amd_uncore_alloc(cpu);
+		uncore->num_counters = NUM_COUNTERS_NB;
+		uncore->rdpmc_base = RDPMC_BASE_NB;
+		uncore->msr_base = MSR_F15H_NB_PERF_CTL;
+		*per_cpu_ptr(amd_uncore_nb, cpu) = uncore;
+	}
+
+	if (amd_uncore_l2) {
+		uncore = amd_uncore_alloc(cpu);
+		uncore->num_counters = NUM_COUNTERS_L2;
+		uncore->rdpmc_base = RDPMC_BASE_L2;
+		uncore->msr_base = MSR_F16H_L2I_PERF_CTL;
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
+	if (uncore->free_when_cpu_online) {
+		kfree(uncore->free_when_cpu_online);
+		uncore->free_when_cpu_online = NULL;
+	}
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
+static void __cpuinit uncore_dead(unsigned int cpu,
+				  struct amd_uncore * __percpu *uncores)
+{
+	struct amd_uncore *uncore = *per_cpu_ptr(uncores, cpu);
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
+		amd_uncore_cpu_prepare(cpu);
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
+};
+
+static void __init init_cpu_already_online(void *dummy)
+{
+	unsigned int cpu = smp_processor_id();
+
+	amd_uncore_cpu_prepare(cpu);
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


