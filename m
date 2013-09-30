Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab3I3V7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 17:59:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:16835 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974Ab3I3V7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 17:59:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1010,1371106800"; 
   d="scan'208";a="385921931"
From: Andi Kleen <andi@firstfloor.org>
To: acma@infradead.org
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 6/6] perf, x86: Suppress duplicated abort LBR records v2
Date: Mon, 30 Sep 2013 14:59:03 -0700
Message-Id: <1380578343-31301-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380578343-31301-1-git-send-email-andi@firstfloor.org>
References: <1380578343-31301-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Haswell always give an extra LBR record after every TSX abort.
Suppress the extra record.

This only works when the abort is visible in the LBR
If the original abort has already left the 16 LBR entries
the extra entry will will stay.

v2: Adjust white space.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.h           |  1 +
 arch/x86/kernel/cpu/perf_event_intel.c     |  1 +
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 29 +++++++++++++++++++++--------
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index ce84ede..fd00bb2 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -445,6 +445,7 @@ struct x86_pmu {
 	int		lbr_nr;			   /* hardware stack size */
 	u64		lbr_sel_mask;		   /* LBR_SELECT valid bits */
 	const int	*lbr_sel_map;		   /* lbr_select mappings */
+	bool		lbr_double_abort;	   /* duplicated lbr aborts */
 
 	/*
 	 * Extra registers for events
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 353b7a3..d6badfc 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2518,6 +2518,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.hw_config = hsw_hw_config;
 		x86_pmu.get_event_constraints = hsw_get_event_constraints;
 		x86_pmu.cpu_events = hsw_events_attrs;
+		x86_pmu.lbr_double_abort = true;
 		pr_cont("Haswell events, ");
 		break;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index d5be06a..90ee6c1 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -284,6 +284,7 @@ static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
 	int lbr_format = x86_pmu.intel_cap.lbr_format;
 	u64 tos = intel_pmu_lbr_tos();
 	int i;
+	int out = 0;
 
 	for (i = 0; i < x86_pmu.lbr_nr; i++) {
 		unsigned long lbr_idx = (tos - i) & mask;
@@ -306,15 +307,27 @@ static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
 		}
 		from = (u64)((((s64)from) << skip) >> skip);
 
-		cpuc->lbr_entries[i].from	= from;
-		cpuc->lbr_entries[i].to		= to;
-		cpuc->lbr_entries[i].mispred	= mis;
-		cpuc->lbr_entries[i].predicted	= pred;
-		cpuc->lbr_entries[i].in_tx	= in_tx;
-		cpuc->lbr_entries[i].abort	= abort;
-		cpuc->lbr_entries[i].reserved	= 0;
+		/*
+		 * Some CPUs report duplicated abort records,
+		 * with the second entry not having an abort bit set.
+		 * Skip them here. This loop runs backwards,
+		 * so we need to undo the previous record.
+		 * If the abort just happened outside the window
+		 * the extra entry cannot be removed.
+		 */
+		if (abort && x86_pmu.lbr_double_abort && out > 0)
+			out--;
+
+		cpuc->lbr_entries[out].from	 = from;
+		cpuc->lbr_entries[out].to	 = to;
+		cpuc->lbr_entries[out].mispred	 = mis;
+		cpuc->lbr_entries[out].predicted = pred;
+		cpuc->lbr_entries[out].in_tx	 = in_tx;
+		cpuc->lbr_entries[out].abort	 = abort;
+		cpuc->lbr_entries[out].reserved	 = 0;
+		out++;
 	}
-	cpuc->lbr_stack.nr = i;
+	cpuc->lbr_stack.nr = out;
 }
 
 void intel_pmu_lbr_read(void)
-- 
1.8.3.1

