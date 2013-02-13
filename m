Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934243Ab3BMQIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:08:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:18940 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759970Ab3BMQIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:08:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,658,1355126400"; 
   d="scan'208";a="290638189"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/5] perf, x86: Support full width counting v3
Date: Wed, 13 Feb 2013 08:08:12 -0800
Message-Id: <1360771693-32063-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360771693-32063-1-git-send-email-andi@firstfloor.org>
References: <1360771693-32063-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Recent Intel CPUs like Haswell and IvyBridge have a new alternative MSR
range for perfctrs that allows writing the full counter width. Enable this
range if the hardware reports it using a new capability bit.

This lowers the overhead of perf stat slightly because it has to do less
interrupts to accumulate the counter value. On Haswell it also avoids some
problems with TSX aborting when the end of the counter range is reached.

v2: Print the feature at boot
v3: Rename field. Add comment.
Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/uapi/asm/msr-index.h  |    3 +++
 arch/x86/kernel/cpu/perf_event.h       |    5 +++++
 arch/x86/kernel/cpu/perf_event_intel.c |    7 +++++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index 433a59f..af41a77 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -163,6 +163,9 @@
 #define MSR_KNC_EVNTSEL0               0x00000028
 #define MSR_KNC_EVNTSEL1               0x00000029
 
+/* Alternative perfctr range with full access. */
+#define MSR_IA32_PMC0			0x000004c1
+
 /* AMD64 MSRs. Not complete. See the architecture manual for a more
    complete list. */
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index ded4667..ebac06d 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -278,6 +278,11 @@ union perf_capabilities {
 		u64	pebs_arch_reg:1;
 		u64	pebs_format:4;
 		u64	smm_freeze:1;
+		/*
+		 * PMU supports separate counter range for writing
+		 * values > 32bit.
+		 */
+		u64	full_width_write:1;
 	};
 	u64	capabilities;
 };
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 74540ac..f4d3377 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2230,5 +2230,12 @@ __init int intel_pmu_init(void)
 		}
 	}
 
+	/* Support full width counters using alternative MSR range */
+	if (x86_pmu.intel_cap.full_width_write) {
+		x86_pmu.max_period = x86_pmu.cntval_mask;
+		x86_pmu.perfctr = MSR_IA32_PMC0;
+		pr_cont("full-width counters, ");
+	}
+
 	return 0;
 }
-- 
1.7.7.6

