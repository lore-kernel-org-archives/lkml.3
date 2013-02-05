Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab3BEBuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 20:50:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:29594 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612Ab3BEBt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 20:49:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,602,1355126400"; 
   d="scan'208";a="282784999"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/5] perf, x86: Basic Haswell PMU support v4
Date: Mon,  4 Feb 2013 17:49:11 -0800
Message-Id: <1360028954-16946-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360028954-16946-1-git-send-email-andi@firstfloor.org>
References: <1360028954-16946-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add basic Haswell PMU support.

Similar to SandyBridge, but has a few new events and two
new counter bits.

There are some new counter flags that need to be prevented
from being set on fixed counters, and allowed to be set
for generic counters.

Also we add support for the counter 2 constraint to handle
all raw events.

Contains fixes from Stephane Eranian

v2: Folded TSX bits into standard FIXED_EVENT_CONSTRAINTS
v3: Use SNB LBR init code. Comment fix (Stephane Eranian)
v4: Add the counter2 constraints. Fix comment in the right place.
Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/perf_event.h      |    3 +
 arch/x86/kernel/cpu/perf_event.h       |    5 ++-
 arch/x86/kernel/cpu/perf_event_intel.c |   71 ++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 4fabcdf..4003bb6 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -29,6 +29,9 @@
 #define ARCH_PERFMON_EVENTSEL_INV			(1ULL << 23)
 #define ARCH_PERFMON_EVENTSEL_CMASK			0xFF000000ULL
 
+#define HSW_INTX					(1ULL << 32)
+#define HSW_INTX_CHECKPOINTED				(1ULL << 33)
+
 #define AMD_PERFMON_EVENTSEL_GUESTONLY			(1ULL << 40)
 #define AMD_PERFMON_EVENTSEL_HOSTONLY			(1ULL << 41)
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 115c1ea..8941899 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -219,11 +219,14 @@ struct cpu_hw_events {
  *  - inv
  *  - edge
  *  - cnt-mask
+ *  - intx
+ *  - intx_cp
  *  The other filters are supported by fixed counters.
  *  The any-thread option is supported starting with v3.
  */
+#define FIXED_EVENT_FLAGS (X86_RAW_EVENT_MASK|HSW_INTX|HSW_INTX_CHECKPOINTED)
 #define FIXED_EVENT_CONSTRAINT(c, n)	\
-	EVENT_CONSTRAINT(c, (1ULL << (32+n)), X86_RAW_EVENT_MASK)
+	EVENT_CONSTRAINT(c, (1ULL << (32+n)), FIXED_EVENT_FLAGS)
 
 /*
  * Constraint on the Event code + UMask
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 93b9e11..58b737d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 
+#include <asm/cpufeature.h>
 #include <asm/hardirq.h>
 #include <asm/apic.h>
 
@@ -133,6 +134,17 @@ static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
 	EVENT_EXTRA_END
 };
 
+static struct event_constraint intel_hsw_event_constraints[] =
+{
+	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
+	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
+	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* CPU_CLK_UNHALTED.REF */
+	INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.* */
+	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
+	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
+	EVENT_CONSTRAINT_END
+};
+
 static u64 intel_pmu_event_map(int hw_event)
 {
 	return intel_perfmon_event_map[hw_event];
@@ -1585,6 +1597,45 @@ static void core_pmu_enable_all(int added)
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
+	event->hw.config |= event->attr.config & (HSW_INTX|HSW_INTX_CHECKPOINTED);
+
+	/*
+	 * INTX/INTX-CP do not play well with PEBS or ANY thread mode.
+	 */
+	if ((event->hw.config & (HSW_INTX|HSW_INTX_CHECKPOINTED)) &&
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
+	/* Handle special quirk on intx_checkpointed only in counter 2 */
+	if (event->hw.config & HSW_INTX_CHECKPOINTED) {
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
@@ -2107,6 +2158,26 @@ __init int intel_pmu_init(void)
 		break;
 
 
+	case 60: /* Haswell Client */
+	case 70:
+	case 71:
+		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
+		       sizeof(hw_cache_event_ids));
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
-- 
1.7.7.6

