Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080Ab3BGTZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:25:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:61556 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758806Ab3BGTXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:23:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,623,1355126400"; 
   d="scan'208";a="282303427"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/5] perf, x86: Support full width counting v2
Date: Thu,  7 Feb 2013 11:23:38 -0800
Message-Id: <1360265019-23865-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360265019-23865-1-git-send-email-andi@firstfloor.org>
References: <1360265019-23865-1-git-send-email-andi@firstfloor.org>
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
Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/uapi/asm/msr-index.h  |    3 +++
 arch/x86/kernel/cpu/perf_event.h       |    1 +
 arch/x86/kernel/cpu/perf_event_intel.c |    7 +++++++
 3 files changed, 11 insertions(+), 0 deletions(-)

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
index ded4667..adaa0b0 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -278,6 +278,7 @@ union perf_capabilities {
 		u64	pebs_arch_reg:1;
 		u64	pebs_format:4;
 		u64	smm_freeze:1;
+		u64	fw_write:1;
 	};
 	u64	capabilities;
 };
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index aa48048..06dcc0c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2228,5 +2228,12 @@ __init int intel_pmu_init(void)
 		}
 	}
 
+	/* Support full width counters using alternative MSR range */
+	if (x86_pmu.intel_cap.fw_write) {
+		x86_pmu.max_period = x86_pmu.cntval_mask;
+		x86_pmu.perfctr = MSR_IA32_PMC0;
+		pr_cont("full-width counters, ");
+	}
+
 	return 0;
 }
-- 
1.7.7.6

