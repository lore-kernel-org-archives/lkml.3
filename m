Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3DVH7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 03:59:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46785 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab3DVH7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 03:59:50 -0400
Date: Mon, 22 Apr 2013 00:59:09 -0700
From: tip-bot for Jacob Shin <tipbot@zytor.com>
Message-ID: <tip-0cf5f4323b1b51ecca3e952f95110e03ea611882@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        jolsa@redhat.com, jacob.shin@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jolsa@redhat.com, jacob.shin@amd.com,
        tglx@linutronix.de
In-Reply-To: <1366046483-1765-2-git-send-email-jacob.shin@amd.com>
References: <1366046483-1765-2-git-send-email-jacob.shin@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/amd:
  Remove old-style NB counter support from perf_event_amd.c
Git-Commit-ID: 0cf5f4323b1b51ecca3e952f95110e03ea611882
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 22 Apr 2013 00:59:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0cf5f4323b1b51ecca3e952f95110e03ea611882
Gitweb:     http://git.kernel.org/tip/0cf5f4323b1b51ecca3e952f95110e03ea611882
Author:     Jacob Shin <jacob.shin@amd.com>
AuthorDate: Mon, 15 Apr 2013 12:21:22 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 21 Apr 2013 17:21:59 +0200

perf/x86/amd: Remove old-style NB counter support from perf_event_amd.c

Support for NB counters, MSRs 0xc0010240 ~ 0xc0010247, got
moved to perf_event_amd_uncore.c in the following commit:

  c43ca5091a37 perf/x86/amd: Add support for AMD NB and L2I "uncore" counters

AMD Family 10h NB events (events 0xe0 ~ 0xff, on MSRs 0xc001000 ~
0xc001007) will still continue to be handled by perf_event_amd.c

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Jacob Shin <jacob.shin@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/1366046483-1765-2-git-send-email-jacob.shin@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd.c | 138 ++---------------------------------
 1 file changed, 5 insertions(+), 133 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index dfdab42..7e28d94 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -132,14 +132,11 @@ static u64 amd_pmu_event_map(int hw_event)
 	return amd_perfmon_event_map[hw_event];
 }
 
-static struct event_constraint *amd_nb_event_constraint;
-
 /*
  * Previously calculated offsets
  */
 static unsigned int event_offsets[X86_PMC_IDX_MAX] __read_mostly;
 static unsigned int count_offsets[X86_PMC_IDX_MAX] __read_mostly;
-static unsigned int rdpmc_indexes[X86_PMC_IDX_MAX] __read_mostly;
 
 /*
  * Legacy CPUs:
@@ -147,14 +144,10 @@ static unsigned int rdpmc_indexes[X86_PMC_IDX_MAX] __read_mostly;
  *
  * CPUs with core performance counter extensions:
  *   6 counters starting at 0xc0010200 each offset by 2
- *
- * CPUs with north bridge performance counter extensions:
- *   4 additional counters starting at 0xc0010240 each offset by 2
- *   (indexed right above either one of the above core counters)
  */
 static inline int amd_pmu_addr_offset(int index, bool eventsel)
 {
-	int offset, first, base;
+	int offset;
 
 	if (!index)
 		return index;
@@ -167,23 +160,7 @@ static inline int amd_pmu_addr_offset(int index, bool eventsel)
 	if (offset)
 		return offset;
 
-	if (amd_nb_event_constraint &&
-	    test_bit(index, amd_nb_event_constraint->idxmsk)) {
-		/*
-		 * calculate the offset of NB counters with respect to
-		 * base eventsel or perfctr
-		 */
-
-		first = find_first_bit(amd_nb_event_constraint->idxmsk,
-				       X86_PMC_IDX_MAX);
-
-		if (eventsel)
-			base = MSR_F15H_NB_PERF_CTL - x86_pmu.eventsel;
-		else
-			base = MSR_F15H_NB_PERF_CTR - x86_pmu.perfctr;
-
-		offset = base + ((index - first) << 1);
-	} else if (!cpu_has_perfctr_core)
+	if (!cpu_has_perfctr_core)
 		offset = index;
 	else
 		offset = index << 1;
@@ -196,36 +173,6 @@ static inline int amd_pmu_addr_offset(int index, bool eventsel)
 	return offset;
 }
 
-static inline int amd_pmu_rdpmc_index(int index)
-{
-	int ret, first;
-
-	if (!index)
-		return index;
-
-	ret = rdpmc_indexes[index];
-
-	if (ret)
-		return ret;
-
-	if (amd_nb_event_constraint &&
-	    test_bit(index, amd_nb_event_constraint->idxmsk)) {
-		/*
-		 * according to the mnual, ECX value of the NB counters is
-		 * the index of the NB counter (0, 1, 2 or 3) plus 6
-		 */
-
-		first = find_first_bit(amd_nb_event_constraint->idxmsk,
-				       X86_PMC_IDX_MAX);
-		ret = index - first + 6;
-	} else
-		ret = index;
-
-	rdpmc_indexes[index] = ret;
-
-	return ret;
-}
-
 static int amd_core_hw_config(struct perf_event *event)
 {
 	if (event->attr.exclude_host && event->attr.exclude_guest)
@@ -245,34 +192,6 @@ static int amd_core_hw_config(struct perf_event *event)
 }
 
 /*
- * NB counters do not support the following event select bits:
- *   Host/Guest only
- *   Counter mask
- *   Invert counter mask
- *   Edge detect
- *   OS/User mode
- */
-static int amd_nb_hw_config(struct perf_event *event)
-{
-	/* for NB, we only allow system wide counting mode */
-	if (is_sampling_event(event) || event->attach_state & PERF_ATTACH_TASK)
-		return -EINVAL;
-
-	if (event->attr.exclude_user || event->attr.exclude_kernel ||
-	    event->attr.exclude_host || event->attr.exclude_guest)
-		return -EINVAL;
-
-	event->hw.config &= ~(ARCH_PERFMON_EVENTSEL_USR |
-			      ARCH_PERFMON_EVENTSEL_OS);
-
-	if (event->hw.config & ~(AMD64_RAW_EVENT_MASK_NB |
-				 ARCH_PERFMON_EVENTSEL_INT))
-		return -EINVAL;
-
-	return 0;
-}
-
-/*
  * AMD64 events are detected based on their event codes.
  */
 static inline unsigned int amd_get_event_code(struct hw_perf_event *hwc)
@@ -285,11 +204,6 @@ static inline int amd_is_nb_event(struct hw_perf_event *hwc)
 	return (hwc->config & 0xe0) == 0xe0;
 }
 
-static inline int amd_is_perfctr_nb_event(struct hw_perf_event *hwc)
-{
-	return amd_nb_event_constraint && amd_is_nb_event(hwc);
-}
-
 static inline int amd_has_nb(struct cpu_hw_events *cpuc)
 {
 	struct amd_nb *nb = cpuc->amd_nb;
@@ -315,9 +229,6 @@ static int amd_pmu_hw_config(struct perf_event *event)
 	if (event->attr.type == PERF_TYPE_RAW)
 		event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
 
-	if (amd_is_perfctr_nb_event(&event->hw))
-		return amd_nb_hw_config(event);
-
 	return amd_core_hw_config(event);
 }
 
@@ -341,19 +252,6 @@ static void __amd_put_nb_event_constraints(struct cpu_hw_events *cpuc,
 	}
 }
 
-static void amd_nb_interrupt_hw_config(struct hw_perf_event *hwc)
-{
-	int core_id = cpu_data(smp_processor_id()).cpu_core_id;
-
-	/* deliver interrupts only to this core */
-	if (hwc->config & ARCH_PERFMON_EVENTSEL_INT) {
-		hwc->config |= AMD64_EVENTSEL_INT_CORE_ENABLE;
-		hwc->config &= ~AMD64_EVENTSEL_INT_CORE_SEL_MASK;
-		hwc->config |= (u64)(core_id) <<
-			AMD64_EVENTSEL_INT_CORE_SEL_SHIFT;
-	}
-}
-
  /*
   * AMD64 NorthBridge events need special treatment because
   * counter access needs to be synchronized across all cores
@@ -441,9 +339,6 @@ __amd_get_nb_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *ev
 	if (new == -1)
 		return &emptyconstraint;
 
-	if (amd_is_perfctr_nb_event(hwc))
-		amd_nb_interrupt_hw_config(hwc);
-
 	return &nb->event_constraints[new];
 }
 
@@ -543,8 +438,7 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	if (!(amd_has_nb(cpuc) && amd_is_nb_event(&event->hw)))
 		return &unconstrained;
 
-	return __amd_get_nb_event_constraints(cpuc, event,
-					      amd_nb_event_constraint);
+	return __amd_get_nb_event_constraints(cpuc, event, NULL);
 }
 
 static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
@@ -643,9 +537,6 @@ static struct event_constraint amd_f15_PMC30 = EVENT_CONSTRAINT_OVERLAP(0, 0x09,
 static struct event_constraint amd_f15_PMC50 = EVENT_CONSTRAINT(0, 0x3F, 0);
 static struct event_constraint amd_f15_PMC53 = EVENT_CONSTRAINT(0, 0x38, 0);
 
-static struct event_constraint amd_NBPMC96 = EVENT_CONSTRAINT(0, 0x3C0, 0);
-static struct event_constraint amd_NBPMC74 = EVENT_CONSTRAINT(0, 0xF0, 0);
-
 static struct event_constraint *
 amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
@@ -711,8 +602,8 @@ amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *ev
 			return &amd_f15_PMC20;
 		}
 	case AMD_EVENT_NB:
-		return __amd_get_nb_event_constraints(cpuc, event,
-						      amd_nb_event_constraint);
+		/* moved to perf_event_amd_uncore.c */
+		return &emptyconstraint;
 	default:
 		return &emptyconstraint;
 	}
@@ -738,7 +629,6 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.eventsel		= MSR_K7_EVNTSEL0,
 	.perfctr		= MSR_K7_PERFCTR0,
 	.addr_offset            = amd_pmu_addr_offset,
-	.rdpmc_index		= amd_pmu_rdpmc_index,
 	.event_map		= amd_pmu_event_map,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
 	.num_counters		= AMD64_NUM_COUNTERS,
@@ -790,23 +680,6 @@ static int setup_perfctr_core(void)
 	return 0;
 }
 
-static int setup_perfctr_nb(void)
-{
-	if (!cpu_has_perfctr_nb)
-		return -ENODEV;
-
-	x86_pmu.num_counters += AMD64_NUM_COUNTERS_NB;
-
-	if (cpu_has_perfctr_core)
-		amd_nb_event_constraint = &amd_NBPMC96;
-	else
-		amd_nb_event_constraint = &amd_NBPMC74;
-
-	printk(KERN_INFO "perf: AMD northbridge performance counters detected\n");
-
-	return 0;
-}
-
 __init int amd_pmu_init(void)
 {
 	/* Performance-monitoring supported from K7 and later: */
@@ -817,7 +690,6 @@ __init int amd_pmu_init(void)
 
 	setup_event_constraints();
 	setup_perfctr_core();
-	setup_perfctr_nb();
 
 	/* Events are common for all AMDs */
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
