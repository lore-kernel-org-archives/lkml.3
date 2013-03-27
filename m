Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab3C0XID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 19:08:03 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:28495
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753461Ab3C0XHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 19:07:13 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKCDJV-01-4UT-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, <x86@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 3/3] perf, amd: Enable L2I performance counters on AMD Family 16h
Date: Wed, 27 Mar 2013 18:07:04 -0500
Message-ID: <1364425624-7556-4-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364425624-7556-1-git-send-email-jacob.shin@amd.com>
References: <1364425624-7556-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD Family 16h processors provide 4 new performance counters (in
addition to 4 legacy core counters, and 4 northbridge counters) for
monitoring L2 cache specific events (i.e. L2 cache misses). These 4
counters are shared between all CPUs in a "compute unit" (they share
the same L2 cache). We will use the same existing event constraints
handling logic to enforce this sharing.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/include/asm/cpufeature.h     |    2 +
 arch/x86/include/asm/perf_event.h     |    4 +
 arch/x86/include/uapi/asm/msr-index.h |    4 +
 arch/x86/kernel/cpu/perf_event.h      |    2 +
 arch/x86/kernel/cpu/perf_event_amd.c  |  159 +++++++++++++++++++++++++++++----
 5 files changed, 154 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 93fe929..0f534af 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -168,6 +168,7 @@
 #define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
 #define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter extensions */
 #define X86_FEATURE_PERFCTR_NB  (6*32+24) /* NB performance counter extensions */
+#define X86_FEATURE_PERFCTR_L2I (6*32+28) /* L2I performance counter extensions */
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
@@ -311,6 +312,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
 #define cpu_has_perfctr_core	boot_cpu_has(X86_FEATURE_PERFCTR_CORE)
 #define cpu_has_perfctr_nb	boot_cpu_has(X86_FEATURE_PERFCTR_NB)
+#define cpu_has_perfctr_l2i	boot_cpu_has(X86_FEATURE_PERFCTR_L2I)
 #define cpu_has_cx8		boot_cpu_has(X86_FEATURE_CX8)
 #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
 #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 57cb634..ed430ea 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -36,6 +36,9 @@
 #define AMD64_EVENTSEL_INT_CORE_SEL_SHIFT		37
 #define AMD64_EVENTSEL_INT_CORE_SEL_MASK		\
 	(0xFULL << AMD64_EVENTSEL_INT_CORE_SEL_SHIFT)
+#define AMD64_EVENTSEL_THREAD_MASK_SHIFT		56
+#define AMD64_EVENTSEL_THREAD_MASK_MASK			\
+	(0xFULL << AMD64_EVENTSEL_THREAD_MASK_SHIFT)
 
 #define AMD64_EVENTSEL_EVENT	\
 	(ARCH_PERFMON_EVENTSEL_EVENT | (0x0FULL << 32))
@@ -57,6 +60,7 @@
 #define AMD64_NUM_COUNTERS				4
 #define AMD64_NUM_COUNTERS_CORE				6
 #define AMD64_NUM_COUNTERS_NB				4
+#define AMD64_NUM_COUNTERS_L2I				4
 
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL		0x3c
 #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK		(0x00 << 8)
diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index 892ce40..9c54104 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -194,6 +194,10 @@
 #define MSR_AMD64_IBSBRTARGET		0xc001103b
 #define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
 
+/* Fam 16h MSRs */
+#define MSR_F16H_L2I_PERF_CTL		0xc0010230
+#define MSR_F16H_L2I_PERF_CTR		0xc0010231
+
 /* Fam 15h MSRs */
 #define MSR_F15H_PERF_CTL		0xc0010200
 #define MSR_F15H_PERF_CTR		0xc0010201
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 770f3b99..79b65ac 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -165,6 +165,8 @@ struct cpu_hw_events {
 	 * AMD specific bits
 	 */
 	struct amd_shared_regs		*amd_nb;
+	struct amd_shared_regs		*amd_l2i;
+
 	/* Inverted mask of bits to clear in the perf_ctr ctrl registers */
 	u64				perf_ctr_virt_mask;
 
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 36b5162..b0e196c 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -132,7 +132,12 @@ static u64 amd_pmu_event_map(int hw_event)
 	return amd_perfmon_event_map[hw_event];
 }
 
+#define CONFIG1_CORE_EVENT 0
+#define CONFIG1_NB_EVENT   1
+#define CONFIG1_L2I_EVENT  2
+
 static struct event_constraint *amd_nb_event_constraint;
+static struct event_constraint *amd_l2i_event_constraint;
 
 /*
  * Previously calculated offsets
@@ -151,6 +156,9 @@ static unsigned int rdpmc_indexes[X86_PMC_IDX_MAX] __read_mostly;
  * CPUs with north bridge performance counter extensions:
  *   4 additional counters starting at 0xc0010240 each offset by 2
  *   (indexed right above either one of the above core counters)
+ *
+ * CPUs with L2I performance counter extensions:
+ *   4 additional counters starting at 0xc0010230 each offset by 2
  */
 static inline int amd_pmu_addr_offset(int index, bool eventsel)
 {
@@ -183,6 +191,18 @@ static inline int amd_pmu_addr_offset(int index, bool eventsel)
 			base = MSR_F15H_NB_PERF_CTR - x86_pmu.perfctr;
 
 		offset = base + ((index - first) << 1);
+	} else if (amd_l2i_event_constraint &&
+		   test_bit(index, amd_l2i_event_constraint->idxmsk)) {
+
+		first = find_first_bit(amd_l2i_event_constraint->idxmsk,
+				       X86_PMC_IDX_MAX);
+
+		if (eventsel)
+			base = MSR_F16H_L2I_PERF_CTL - x86_pmu.eventsel;
+		else
+			base = MSR_F16H_L2I_PERF_CTR - x86_pmu.perfctr;
+
+		offset = base + ((index - first) << 1);
 	} else if (!cpu_has_perfctr_core)
 		offset = index;
 	else
@@ -218,6 +238,13 @@ static inline int amd_pmu_rdpmc_index(int index)
 		first = find_first_bit(amd_nb_event_constraint->idxmsk,
 				       X86_PMC_IDX_MAX);
 		ret = index - first + 6;
+	} else if (amd_l2i_event_constraint &&
+	    test_bit(index, amd_l2i_event_constraint->idxmsk)) {
+
+		first = find_first_bit(amd_l2i_event_constraint->idxmsk,
+				       X86_PMC_IDX_MAX);
+
+		ret = index - first + 10;
 	} else
 		ret = index;
 
@@ -245,14 +272,14 @@ static int amd_core_hw_config(struct perf_event *event)
 }
 
 /*
- * NB counters do not support the following event select bits:
+ * NB and L2I counters do not support the following event select bits:
  *   Host/Guest only
  *   Counter mask
  *   Invert counter mask
  *   Edge detect
  *   OS/User mode
  */
-static int amd_nb_hw_config(struct perf_event *event)
+static int amd_shared_hw_config(struct perf_event *event)
 {
 	/* for NB, we only allow system wide counting mode */
 	if (is_sampling_event(event) || event->attach_state & PERF_ATTACH_TASK)
@@ -285,9 +312,22 @@ static inline int amd_is_nb_event(struct hw_perf_event *hwc)
 	return (hwc->config & 0xe0) == 0xe0;
 }
 
-static inline int amd_is_perfctr_nb_event(struct hw_perf_event *hwc)
+static inline int amd_is_perfctr_nb_event(struct perf_event *event)
+{
+	return amd_nb_event_constraint && amd_is_nb_event(&event->hw);
+}
+
+static inline int amd_is_perfctr_l2i_event(struct perf_event *event)
 {
-	return amd_nb_event_constraint && amd_is_nb_event(hwc);
+	unsigned int event_code = amd_get_event_code(&event->hw);
+
+	if (!amd_l2i_event_constraint)
+		return 0;
+
+	if (event_code >= 0x07d && event_code <= 0x07f)
+		return 1;
+
+	return event->attr.config1 == CONFIG1_L2I_EVENT;
 }
 
 static inline int amd_has_nb(struct cpu_hw_events *cpuc)
@@ -297,6 +337,13 @@ static inline int amd_has_nb(struct cpu_hw_events *cpuc)
 	return nb && nb->id != -1;
 }
 
+static inline int amd_has_l2i(struct cpu_hw_events *cpuc)
+{
+	struct amd_shared_regs *l2i = cpuc->amd_l2i;
+
+	return l2i && l2i->id != -1;
+}
+
 static int amd_pmu_hw_config(struct perf_event *event)
 {
 	int ret;
@@ -315,8 +362,8 @@ static int amd_pmu_hw_config(struct perf_event *event)
 	if (event->attr.type == PERF_TYPE_RAW)
 		event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
 
-	if (amd_is_perfctr_nb_event(&event->hw))
-		return amd_nb_hw_config(event);
+	if (amd_is_perfctr_nb_event(event) || amd_is_perfctr_l2i_event(event))
+		return amd_shared_hw_config(event);
 
 	return amd_core_hw_config(event);
 }
@@ -340,8 +387,9 @@ static void amd_put_shared_event_constraints(struct amd_shared_regs *regs,
 	}
 }
 
-static void amd_nb_interrupt_hw_config(struct hw_perf_event *hwc)
+static void amd_shared_interrupt_hw_config(struct perf_event *event)
 {
+	struct hw_perf_event *hwc = &event->hw;
 	int core_id = cpu_data(smp_processor_id()).cpu_core_id;
 
 	/* deliver interrupts only to this core */
@@ -351,6 +399,13 @@ static void amd_nb_interrupt_hw_config(struct hw_perf_event *hwc)
 		hwc->config |= (u64)(core_id) <<
 			AMD64_EVENTSEL_INT_CORE_SEL_SHIFT;
 	}
+
+	/* mask out events from other cores */
+	if (amd_is_perfctr_l2i_event(event)) {
+		hwc->config |= AMD64_EVENTSEL_THREAD_MASK_MASK;
+		hwc->config &= ~(1ULL <<
+			(AMD64_EVENTSEL_THREAD_MASK_SHIFT + core_id));
+	}
 }
 
  /*
@@ -441,8 +496,8 @@ amd_get_shared_event_constraints(struct cpu_hw_events *cpuc,
 	if (new == -1)
 		return &emptyconstraint;
 
-	if (amd_is_perfctr_nb_event(hwc))
-		amd_nb_interrupt_hw_config(hwc);
+	if (amd_is_perfctr_nb_event(event) || amd_is_perfctr_l2i_event(event))
+		amd_shared_interrupt_hw_config(event);
 
 	return &regs->event_constraints[new];
 }
@@ -482,14 +537,18 @@ static int amd_pmu_cpu_prepare(int cpu)
 	if (!cpuc->amd_nb)
 		return NOTIFY_BAD;
 
+	cpuc->amd_l2i = amd_alloc_shared_regs(cpu);
+	if (!cpuc->amd_l2i)
+		return NOTIFY_BAD;
+
 	return NOTIFY_OK;
 }
 
 static void amd_pmu_cpu_starting(int cpu)
 {
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
-	struct amd_shared_regs *nb;
-	int i, nb_id;
+	struct amd_shared_regs *nb, *l2i;
+	int i, nb_id, cu_id;
 
 	cpuc->perf_ctr_virt_mask = AMD64_EVENTSEL_HOSTONLY;
 
@@ -499,20 +558,36 @@ static void amd_pmu_cpu_starting(int cpu)
 	nb_id = amd_get_nb_id(cpu);
 	WARN_ON_ONCE(nb_id == BAD_APICID);
 
+	cu_id = cpu_data(cpu).compute_unit_id;
+
 	for_each_online_cpu(i) {
-		nb = per_cpu(cpu_hw_events, i).amd_nb;
-		if (WARN_ON_ONCE(!nb))
+		struct cpu_hw_events *other_cpuc = &per_cpu(cpu_hw_events, i);
+
+		nb = other_cpuc->amd_nb;
+		l2i = other_cpuc->amd_l2i;
+
+		if (WARN_ON_ONCE(!(nb && l2i)))
 			continue;
 
 		if (nb->id == nb_id) {
-			cpuc->kfree_on_online[0] = cpuc->amd_nb;
-			cpuc->amd_nb = nb;
-			break;
+			if (!cpuc->kfree_on_online[0]) {
+				cpuc->kfree_on_online[0] = cpuc->amd_nb;
+				cpuc->amd_nb = nb;
+			}
+
+			if (l2i->id == cu_id) {
+				cpuc->kfree_on_online[1] = cpuc->amd_l2i;
+				cpuc->amd_l2i = l2i;
+				break;
+			}
 		}
 	}
 
 	cpuc->amd_nb->id = nb_id;
 	cpuc->amd_nb->refcnt++;
+
+	cpuc->amd_l2i->id = cu_id;
+	cpuc->amd_l2i->refcnt++;
 }
 
 static void amd_pmu_cpu_dead(int cpu)
@@ -532,6 +607,15 @@ static void amd_pmu_cpu_dead(int cpu)
 
 		cpuhw->amd_nb = NULL;
 	}
+
+	if (cpuhw->amd_l2i) {
+		struct amd_shared_regs *l2i = cpuhw->amd_l2i;
+
+		if (l2i->id == -1 || --l2i->refcnt == 0)
+			kfree(l2i);
+
+		cpuhw->amd_l2i = NULL;
+	}
 }
 
 static struct event_constraint *
@@ -550,8 +634,12 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
 				      struct perf_event *event)
 {
-	if (amd_has_nb(cpuc) && amd_is_nb_event(&event->hw))
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (amd_has_nb(cpuc) && amd_is_nb_event(hwc))
 		amd_put_shared_event_constraints(cpuc->amd_nb, event);
+	else if (amd_has_l2i(cpuc) && amd_is_perfctr_l2i_event(event))
+		amd_put_shared_event_constraints(cpuc->amd_l2i, event);
 }
 
 PMU_FORMAT_ATTR(event,	"config:0-7,32-35");
@@ -718,6 +806,25 @@ amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *ev
 	}
 }
 
+static struct event_constraint amd_f16_PMC30 = EVENT_CONSTRAINT(0, 0x0F, 0);
+
+static struct event_constraint amd_L2IPMC = EVENT_CONSTRAINT(0, 0xF00, 0);
+
+static struct event_constraint *
+amd_get_event_constraints_f16h(struct cpu_hw_events *cpuc,
+			       struct perf_event    *event)
+{
+	if (amd_is_perfctr_l2i_event(event))
+		return amd_get_shared_event_constraints(cpuc, cpuc->amd_l2i,
+				event, amd_l2i_event_constraint);
+
+	if (amd_is_perfctr_nb_event(event))
+		return amd_get_shared_event_constraints(cpuc, cpuc->amd_nb,
+				event, amd_nb_event_constraint);
+
+	return &amd_f16_PMC30;
+}
+
 static ssize_t amd_event_sysfs_show(char *page, u64 config)
 {
 	u64 event = (config & ARCH_PERFMON_EVENTSEL_EVENT) |
@@ -762,6 +869,9 @@ static int setup_event_constraints(void)
 {
 	if (boot_cpu_data.x86 == 0x15)
 		x86_pmu.get_event_constraints = amd_get_event_constraints_f15h;
+	else if (boot_cpu_data.x86 == 0x16)
+		x86_pmu.get_event_constraints = amd_get_event_constraints_f16h;
+
 	return 0;
 }
 
@@ -807,6 +917,20 @@ static int setup_perfctr_nb(void)
 	return 0;
 }
 
+static int setup_perfctr_l2i(void)
+{
+	if (!cpu_has_perfctr_l2i)
+		return -ENODEV;
+
+	x86_pmu.num_counters += AMD64_NUM_COUNTERS_L2I;
+
+	amd_l2i_event_constraint = &amd_L2IPMC;
+
+	printk(KERN_INFO "perf: AMD L2I performance counters detected\n");
+
+	return 0;
+}
+
 __init int amd_pmu_init(void)
 {
 	/* Performance-monitoring supported from K7 and later: */
@@ -818,6 +942,7 @@ __init int amd_pmu_init(void)
 	setup_event_constraints();
 	setup_perfctr_core();
 	setup_perfctr_nb();
+	setup_perfctr_l2i();
 
 	/* Events are common for all AMDs */
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
-- 
1.7.9.5


