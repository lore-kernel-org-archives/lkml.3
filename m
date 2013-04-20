Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab3DTTTa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 15:19:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:51316 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab3DTTT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 15:19:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,515,1363158000"; 
   d="scan'208";a="229707688"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: acme@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 01/15] perf, x86: Suppress duplicated abort LBR records
Date: Sat, 20 Apr 2013 12:19:09 -0700
Message-Id: <1366485563-16209-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
References: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Haswell always give an extra LBR record after every TSX abort. This can confuse
some clients. Suppress the extra record.

This only works when the abort is visible in the window, that is if the
extra record is the last entry in the LBR. If the abort has already
left it it will stay.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.h           |    1 +
 arch/x86/kernel/cpu/perf_event_intel.c     |    1 +
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   29 ++++++++++++++++++++-------
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index d75d0ff..563d6e8 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -427,6 +427,7 @@ struct x86_pmu {
 	int		lbr_nr;			   /* hardware stack size */
 	u64		lbr_sel_mask;		   /* LBR_SELECT valid bits */
 	const int	*lbr_sel_map;		   /* lbr_select mappings */
+	bool		lbr_double_abort;	   /* duplicated lbr aborts */
 
 	/*
 	 * Extra registers for events
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 4a78745..5a0d73c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2247,6 +2247,7 @@ __init int intel_pmu_init(void)
 
 		x86_pmu.hw_config = hsw_hw_config;
 		x86_pmu.get_event_constraints = hsw_get_event_constraints;
+		x86_pmu.lbr_double_abort = true;
 		pr_cont("Haswell events, ");
 		break;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 6f9b794..33b6b5f 100644
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
+		cpuc->lbr_entries[out].from	= from;
+		cpuc->lbr_entries[out].to	= to;
+		cpuc->lbr_entries[out].mispred	= mis;
+		cpuc->lbr_entries[out].predicted = pred;
+		cpuc->lbr_entries[out].in_tx	= in_tx;
+		cpuc->lbr_entries[out].abort	= abort;
+		cpuc->lbr_entries[out].reserved	= 0;
+		out++;
 	}
-	cpuc->lbr_stack.nr = i;
+	cpuc->lbr_stack.nr = out;
 }
 
 void intel_pmu_lbr_read(void)
-- 
1.7.7.6

