Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaHNBSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 21:18:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:65466 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbaHNBR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 21:17:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,859,1400050800"; 
   d="scan'208";a="558285888"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/5] perf, x86: Add INST_RETIRED.ALL workarounds
Date: Wed, 13 Aug 2014 18:17:48 -0700
Message-Id: <1407979069-7121-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407979069-7121-1-git-send-email-andi@firstfloor.org>
References: <1407979069-7121-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

On Broadwell INST_RETIRED.ALL cannot be used with any period
that doesn't have the lowest 6 bits cleared. And the period
should not be smaller than 128.

Add a new callback to enforce this, and set it for Broadwell.

This is erratum BDM57 and BDM11.

v2: Use correct event name in description. Use EVENT() macro.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.c       |  3 +++
 arch/x86/kernel/cpu/perf_event.h       |  1 +
 arch/x86/kernel/cpu/perf_event_intel.c | 19 +++++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 0adc5e3..a0adf58 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -980,6 +980,9 @@ int x86_perf_event_set_period(struct perf_event *event)
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
index 4bfb0ec..66260e1 100644
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
+	if ((event->hw.config & 0xffff) ==
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
@@ -2711,6 +2729,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.hw_config = hsw_hw_config;
 		x86_pmu.get_event_constraints = hsw_get_event_constraints;
 		x86_pmu.cpu_events = hsw_events_attrs;
+		x86_pmu.limit_period = bdw_limit_period;
 		pr_cont("Broadwell events, ");
 		break;
 
-- 
1.9.3

