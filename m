Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965053Ab3FSSnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:43:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40275 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965031Ab3FSSmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:42:55 -0400
Date: Wed, 19 Jun 2013 11:42:38 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-3044318f1f3a2a0a636b4c751ddb7169cb1b11b2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        ak@linux.jf.intel.com, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        ak@linux.jf.intel.com, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1371515812-9646-4-git-send-email-andi@firstfloor.org>
References: <1371515812-9646-4-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel: Add Haswell PEBS support
Git-Commit-ID: 3044318f1f3a2a0a636b4c751ddb7169cb1b11b2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:42:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3044318f1f3a2a0a636b4c751ddb7169cb1b11b2
Gitweb:     http://git.kernel.org/tip/3044318f1f3a2a0a636b4c751ddb7169cb1b11b2
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 17 Jun 2013 17:36:49 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 14:43:33 +0200

perf/x86/intel: Add Haswell PEBS support

Add simple PEBS support for Haswell.

The constraints are similar to SandyBridge with a few new
events.

Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <ak@linux.jf.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: http://lkml.kernel.org/r/1371515812-9646-4-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.h          |  2 ++
 arch/x86/kernel/cpu/perf_event_intel.c    |  6 ++++--
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 36 +++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 259ac3f..fb7fe44 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -636,6 +636,8 @@ extern struct event_constraint intel_snb_pebs_event_constraints[];
 
 extern struct event_constraint intel_ivb_pebs_event_constraints[];
 
+extern struct event_constraint intel_hsw_pebs_event_constraints[];
+
 struct event_constraint *intel_pebs_constraints(struct perf_event *event);
 
 void intel_pmu_pebs_enable(struct perf_event *event);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 4e995af..4a4c4ba 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -889,7 +889,8 @@ static inline bool intel_pmu_needs_lbr_smpl(struct perf_event *event)
 		return true;
 
 	/* implicit branch sampling to correct PEBS skid */
-	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1)
+	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1 &&
+	    x86_pmu.intel_cap.pebs_format < 2)
 		return true;
 
 	return false;
@@ -2265,8 +2266,9 @@ __init int intel_pmu_init(void)
 		intel_pmu_lbr_init_snb();
 
 		x86_pmu.event_constraints = intel_hsw_event_constraints;
-
+		x86_pmu.pebs_constraints = intel_hsw_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_snb_extra_regs;
+		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 2a63d13..e83148f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -564,6 +564,42 @@ struct event_constraint intel_ivb_pebs_event_constraints[] = {
         EVENT_CONSTRAINT_END
 };
 
+struct event_constraint intel_hsw_pebs_event_constraints[] = {
+	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
+	INTEL_UEVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
+	INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
+	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
+	INTEL_UEVENT_CONSTRAINT(0x01c5, 0xf), /* BR_MISP_RETIRED.CONDITIONAL */
+	INTEL_UEVENT_CONSTRAINT(0x04c5, 0xf), /* BR_MISP_RETIRED.ALL_BRANCHES */
+	INTEL_UEVENT_CONSTRAINT(0x20c5, 0xf), /* BR_MISP_RETIRED.NEAR_TAKEN */
+	INTEL_EVENT_CONSTRAINT(0xcd, 0x8),    /* MEM_TRANS_RETIRED.* */
+	/* MEM_UOPS_RETIRED.STLB_MISS_LOADS */
+	INTEL_UEVENT_CONSTRAINT(0x11d0, 0xf),
+	/* MEM_UOPS_RETIRED.STLB_MISS_STORES */
+	INTEL_UEVENT_CONSTRAINT(0x12d0, 0xf),
+	INTEL_UEVENT_CONSTRAINT(0x21d0, 0xf), /* MEM_UOPS_RETIRED.LOCK_LOADS */
+	INTEL_UEVENT_CONSTRAINT(0x41d0, 0xf), /* MEM_UOPS_RETIRED.SPLIT_LOADS */
+	/* MEM_UOPS_RETIRED.SPLIT_STORES */
+	INTEL_UEVENT_CONSTRAINT(0x42d0, 0xf),
+	INTEL_UEVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOPS_RETIRED.ALL_LOADS */
+	INTEL_UEVENT_CONSTRAINT(0x82d0, 0xf), /* MEM_UOPS_RETIRED.ALL_STORES */
+	INTEL_UEVENT_CONSTRAINT(0x01d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L1_HIT */
+	INTEL_UEVENT_CONSTRAINT(0x02d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L2_HIT */
+	INTEL_UEVENT_CONSTRAINT(0x04d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L3_HIT */
+	/* MEM_LOAD_UOPS_RETIRED.HIT_LFB */
+	INTEL_UEVENT_CONSTRAINT(0x40d1, 0xf),
+	/* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_MISS */
+	INTEL_UEVENT_CONSTRAINT(0x01d2, 0xf),
+	/* MEM_LOAD_UOPS_LLC_HIT_RETIRED.XSNP_HIT */
+	INTEL_UEVENT_CONSTRAINT(0x02d2, 0xf),
+	/* MEM_LOAD_UOPS_LLC_MISS_RETIRED.LOCAL_DRAM */
+	INTEL_UEVENT_CONSTRAINT(0x01d3, 0xf),
+	INTEL_UEVENT_CONSTRAINT(0x04c8, 0xf), /* HLE_RETIRED.Abort */
+	INTEL_UEVENT_CONSTRAINT(0x04c9, 0xf), /* RTM_RETIRED.Abort */
+
+	EVENT_CONSTRAINT_END
+};
+
 struct event_constraint *intel_pebs_constraints(struct perf_event *event)
 {
 	struct event_constraint *c;
