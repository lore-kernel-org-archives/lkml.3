Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965022Ab3FSSpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:45:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40252 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964952Ab3FSSmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:42:45 -0400
Date: Wed, 19 Jun 2013 11:42:29 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-3a632cb229bfb18b6d09822cc842451ea46c013e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        ak@linux.jf.intel.com, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        ak@linux.jf.intel.com, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1371515812-9646-3-git-send-email-andi@firstfloor.org>
References: <1371515812-9646-3-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel: Add simple Haswell PMU support
Git-Commit-ID: 3a632cb229bfb18b6d09822cc842451ea46c013e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:42:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a632cb229bfb18b6d09822cc842451ea46c013e
Gitweb:     http://git.kernel.org/tip/3a632cb229bfb18b6d09822cc842451ea46c013e
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 17 Jun 2013 17:36:48 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 14:43:33 +0200

perf/x86/intel: Add simple Haswell PMU support

Similar to SandyBridge, but has a few new events and two
new counter bits.

There are some new counter flags that need to be prevented
from being set on fixed counters, and allowed to be set
for generic counters.

Also we add support for the counter 2 constraint to handle
all raw events.

(Contains fixes from Stephane Eranian.)

Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <ak@linux.jf.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: http://lkml.kernel.org/r/1371515812-9646-3-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/perf_event.h      |  3 ++
 arch/x86/kernel/cpu/perf_event.h       |  5 +-
 arch/x86/kernel/cpu/perf_event_intel.c | 85 +++++++++++++++++++++++++++++++++-
 3 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 57cb634..8249df4 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -29,6 +29,9 @@
 #define ARCH_PERFMON_EVENTSEL_INV			(1ULL << 23)
 #define ARCH_PERFMON_EVENTSEL_CMASK			0xFF000000ULL
 
+#define HSW_IN_TX					(1ULL << 32)
+#define HSW_IN_TX_CHECKPOINTED				(1ULL << 33)
+
 #define AMD64_EVENTSEL_INT_CORE_ENABLE			(1ULL << 36)
 #define AMD64_EVENTSEL_GUESTONLY			(1ULL << 40)
 #define AMD64_EVENTSEL_HOSTONLY				(1ULL << 41)
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 6a6ca01..259ac3f 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -227,11 +227,14 @@ struct cpu_hw_events {
  *  - inv
  *  - edge
  *  - cnt-mask
+ *  - in_tx
+ *  - in_tx_checkpointed
  *  The other filters are supported by fixed counters.
  *  The any-thread option is supported starting with v3.
  */
+#define FIXED_EVENT_FLAGS (X86_RAW_EVENT_MASK|HSW_IN_TX|HSW_IN_TX_CHECKPOINTED)
 #define FIXED_EVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, (1ULL << (32+n)), X86_RAW_EVENT_MASK)
+	EVENT_CONSTRAINT(c, (1ULL << (32+n)), FIXED_EVENT_FLAGS)
 
 /*
  * Constraint on the Event code + UMask
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 1321cf8..4e995af 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 
+#include <asm/cpufeature.h>
 #include <asm/hardirq.h>
 #include <asm/apic.h>
 
@@ -190,6 +191,22 @@ struct attribute *snb_events_attrs[] = {
 	NULL,
 };
 
+static struct event_constraint intel_hsw_event_constraints[] = {
+	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
+	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
+	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* CPU_CLK_UNHALTED.REF */
+	INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.* */
+	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
+	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
+	/* CYCLE_ACTIVITY.CYCLES_L1D_PENDING */
+	INTEL_EVENT_CONSTRAINT(0x08a3, 0x4),
+	/* CYCLE_ACTIVITY.STALLS_L1D_PENDING */
+	INTEL_EVENT_CONSTRAINT(0x0ca3, 0x4),
+	/* CYCLE_ACTIVITY.CYCLES_NO_EXECUTE */
+	INTEL_EVENT_CONSTRAINT(0x04a3, 0xf),
+	EVENT_CONSTRAINT_END
+};
+
 static u64 intel_pmu_event_map(int hw_event)
 {
 	return intel_perfmon_event_map[hw_event];
@@ -1650,6 +1667,47 @@ static void core_pmu_enable_all(int added)
 	}
 }
 
+static int hsw_hw_config(struct perf_event *event)
+{
+	int ret = intel_pmu_hw_config(event);
+
+	if (ret)
+		return ret;
+	if (!boot_cpu_has(X86_FEATURE_RTM) && !boot_cpu_has(X86_FEATURE_HLE))
+		return 0;
+	event->hw.config |= event->attr.config & (HSW_IN_TX|HSW_IN_TX_CHECKPOINTED);
+
+	/*
+	 * IN_TX/IN_TX-CP filters are not supported by the Haswell PMU with
+	 * PEBS or in ANY thread mode. Since the results are non-sensical forbid
+	 * this combination.
+	 */
+	if ((event->hw.config & (HSW_IN_TX|HSW_IN_TX_CHECKPOINTED)) &&
+	     ((event->hw.config & ARCH_PERFMON_EVENTSEL_ANY) ||
+	      event->attr.precise_ip > 0))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static struct event_constraint counter2_constraint =
+			EVENT_CONSTRAINT(0, 0x4, 0);
+
+static struct event_constraint *
+hsw_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	struct event_constraint *c = intel_get_event_constraints(cpuc, event);
+
+	/* Handle special quirk on in_tx_checkpointed only in counter 2 */
+	if (event->hw.config & HSW_IN_TX_CHECKPOINTED) {
+		if (c->idxmsk64 & (1U << 2))
+			return &counter2_constraint;
+		return &emptyconstraint;
+	}
+
+	return c;
+}
+
 PMU_FORMAT_ATTR(event,	"config:0-7"	);
 PMU_FORMAT_ATTR(umask,	"config:8-15"	);
 PMU_FORMAT_ATTR(edge,	"config:18"	);
@@ -1657,6 +1715,8 @@ PMU_FORMAT_ATTR(pc,	"config:19"	);
 PMU_FORMAT_ATTR(any,	"config:21"	); /* v3 + */
 PMU_FORMAT_ATTR(inv,	"config:23"	);
 PMU_FORMAT_ATTR(cmask,	"config:24-31"	);
+PMU_FORMAT_ATTR(in_tx,  "config:32");
+PMU_FORMAT_ATTR(in_tx_cp, "config:33");
 
 static struct attribute *intel_arch_formats_attr[] = {
 	&format_attr_event.attr,
@@ -1811,6 +1871,8 @@ static struct attribute *intel_arch3_formats_attr[] = {
 	&format_attr_any.attr,
 	&format_attr_inv.attr,
 	&format_attr_cmask.attr,
+	&format_attr_in_tx.attr,
+	&format_attr_in_tx_cp.attr,
 
 	&format_attr_offcore_rsp.attr, /* XXX do NHM/WSM + SNB breakout */
 	&format_attr_ldlat.attr, /* PEBS load latency */
@@ -2193,6 +2255,27 @@ __init int intel_pmu_init(void)
 		break;
 
 
+	case 60: /* Haswell Client */
+	case 70:
+	case 71:
+	case 63:
+		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids, sizeof(hw_cache_event_ids));
+		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
+
+		intel_pmu_lbr_init_snb();
+
+		x86_pmu.event_constraints = intel_hsw_event_constraints;
+
+		x86_pmu.extra_regs = intel_snb_extra_regs;
+		/* all extra regs are per-cpu when HT is on */
+		x86_pmu.er_flags |= ERF_HAS_RSP_1;
+		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
+
+		x86_pmu.hw_config = hsw_hw_config;
+		x86_pmu.get_event_constraints = hsw_get_event_constraints;
+		pr_cont("Haswell events, ");
+		break;
+
 	default:
 		switch (x86_pmu.version) {
 		case 1:
@@ -2231,7 +2314,7 @@ __init int intel_pmu_init(void)
 		 * counter, so do not extend mask to generic counters
 		 */
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
-			if (c->cmask != X86_RAW_EVENT_MASK
+			if (c->cmask != FIXED_EVENT_FLAGS
 			    || c->idxmsk64 == INTEL_PMC_MSK_FIXED_REF_CYCLES) {
 				continue;
 			}
