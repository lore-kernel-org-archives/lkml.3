Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab3JDReT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:34:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58785 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab3JDReM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:34:12 -0400
Date: Fri, 4 Oct 2013 10:33:18 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-b7af41a1bc255c0098c37a4bcf5c7e5e168ce875@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1379688044-14173-7-git-send-email-andi@firstfloor.org>
References: <1379688044-14173-7-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Suppress duplicated abort LBR records
Git-Commit-ID: b7af41a1bc255c0098c37a4bcf5c7e5e168ce875
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:33:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7af41a1bc255c0098c37a4bcf5c7e5e168ce875
Gitweb:     http://git.kernel.org/tip/b7af41a1bc255c0098c37a4bcf5c7e5e168ce875
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Fri, 20 Sep 2013 07:40:44 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 10:06:16 +0200

perf/x86: Suppress duplicated abort LBR records

Haswell always give an extra LBR record after every TSX abort.
Suppress the extra record.

This only works when the abort is visible in the LBR
If the original abort has already left the 16 LBR entries
the extra entry will will stay.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1379688044-14173-7-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
index 36b5ab8..0fa4f24 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2519,6 +2519,7 @@ __init int intel_pmu_init(void)
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
