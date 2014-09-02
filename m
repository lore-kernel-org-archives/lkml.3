Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbaIBSob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 14:44:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:52192 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871AbaIBSo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:44:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,450,1406617200"; 
   d="scan'208";a="567311055"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        tglx@linutronix.de, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/5] perf, x86: Add INST_RETIRED.ALL workarounds
Date: Tue,  2 Sep 2014 11:44:14 -0700
Message-Id: <1409683455-29168-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409683455-29168-1-git-send-email-andi@firstfloor.org>
References: <1409683455-29168-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

On Broadwell INST_RETIRED.ALL cannot be used with any period
that doesn't have the lowest 6 bits cleared. And the period
should not be smaller than 128.

Add a new callback to enforce this, and set it for Broadwell.

This is erratum BDM57 and BDM11.

How does this handle the case when an app requests a specific
period with some of the bottom bits set

The apps thinks it is sampling at X occurences per sample, when it is
in fact at X - 63 (worst case).

Short answer:

Any useful instruction sampling period needs to be 4-6 orders
of magnitude larger than 128, as an PMI every 128 instructions
would instantly overwhelm the system and be throttled.
So the +-64 error from this is really small compared to the
period, much smaller than normal system jitter.

Long answer:

<write up by Peter:>

IFF we guarantee perf_event_attr::sample_period >= 128.

Suppose we start out with sample_period=192; then we'll set period_left
to 192, we'll end up with left = 128 (we truncate the lower bits). We
get an interrupt, find that period_left = 64 (>0 so we return 0 and
don't get an overflow handler), up that to 128. Then we trigger again,
at n=256. Then we find period_left = -64 (<=0 so we return 1 and do get
an overflow). We increment with sample_period so we get left = 128. We
fire again, at n=384, period_left = 0 (<=0 so we return 1 and get an
overflow). And on and on.

So while the individual interrupts are 'wrong' we get then with
interval=256,128 in exactly the right ratio to average out at 192. And
this works for everything >=128.

So the num_samples*fixed_period thing is still entirely correct +- 127,
which is good enough I'd say, as you already have that error anyhow.

So no need to 'fix' the tools, al we need to do is refuse to create
INST_RETIRED:ALL events with sample_period < 128.

v2: Use correct event name in description. Use EVENT() macro.
v3: Use INTEL_ARCH_EVENT_MASK. Error out for events with too small period.
v4: Expand description.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.c       |  9 +++++++++
 arch/x86/kernel/cpu/perf_event.h       |  1 +
 arch/x86/kernel/cpu/perf_event_intel.c | 19 +++++++++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 0adc5e3..a6e4724 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -443,6 +443,12 @@ int x86_pmu_hw_config(struct perf_event *event)
 	if (event->attr.type == PERF_TYPE_RAW)
 		event->hw.config |= event->attr.config & X86_RAW_EVENT_MASK;
 
+	if (event->attr.sample_period && x86_pmu.limit_period) {
+		if (x86_pmu.limit_period(event, event->attr.sample_period) >
+				event->attr.sample_period)
+			return -EINVAL;
+	}
+
 	return x86_setup_perfctr(event);
 }
 
@@ -980,6 +986,9 @@ int x86_perf_event_set_period(struct perf_event *event)
 	if (left > x86_pmu.max_period)
 		left = x86_pmu.max_period;
 
+	if (x86_pmu.limit_period)
+		left = x86_pmu.limit_period(event, left);
+
 	per_cpu(pmc_prev_left[idx], smp_processor_id()) = left;
 
 	/*
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index de81627..a46e391 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -456,6 +456,7 @@ struct x86_pmu {
 	struct x86_pmu_quirk *quirks;
 	int		perfctr_second_write;
 	bool		late_ack;
+	unsigned	(*limit_period)(struct perf_event *event, unsigned l);
 
 	/*
 	 * sysfs attrs
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 61b5404..6733a7f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2034,6 +2034,24 @@ hsw_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	return c;
 }
 
+/*
+ * Broadwell:
+ * The INST_RETIRED.ALL period always needs to have lowest
+ * 6bits cleared (BDM57). It shall not use a period smaller
+ * than 100 (BDM11). We combine the two to enforce
+ * a min-period of 128.
+ */
+static unsigned bdw_limit_period(struct perf_event *event, unsigned left)
+{
+	if ((event->hw.config & INTEL_ARCH_EVENT_MASK) ==
+			X86_CONFIG(.event=0xc0, .umask=0x01)) {
+		if (left < 128)
+			left = 128;
+		left &= ~0x3fu;
+	}
+	return left;
+}
+
 PMU_FORMAT_ATTR(event,	"config:0-7"	);
 PMU_FORMAT_ATTR(umask,	"config:8-15"	);
 PMU_FORMAT_ATTR(edge,	"config:18"	);
@@ -2712,6 +2730,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.hw_config = hsw_hw_config;
 		x86_pmu.get_event_constraints = hsw_get_event_constraints;
 		x86_pmu.cpu_events = hsw_events_attrs;
+		x86_pmu.limit_period = bdw_limit_period;
 		pr_cont("Broadwell events, ");
 		break;
 
-- 
1.9.3

