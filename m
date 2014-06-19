Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbaFSP6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:58:53 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:63084 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133AbaFSP6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:58:51 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jmario@redhat.com,
        dzickus@redhat.com, jolsa@redhat.com, acme@redhat.com
Subject: [PATCH 2/2] perf/x86: fix constraints for load latency and precise events
Date: Thu, 19 Jun 2014 17:58:29 +0200
Message-Id: <1403193509-22393-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403193509-22393-1-git-send-email-eranian@google.com>
References: <1403193509-22393-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The load latency does not have to be constrained to counter 3
on any of SNB, IVB, HSW. It operates fine on any PEBS-capable
counter.

The precise store event for SNB, IVB needs to be on counter 3.
But on Haswell, precise store is implemented differently and
the constraint is not needed anymore, so we remove it.

The artificial constraint on counter 3 was used to ease
scheduling because the load latency events rely on an
extra MSR which is shared for all the counters. But
perf_events has an infrastructure to handle shared_regs
and does not need to constrain the load latency event to
a single counter. It was already using that infrastructure
with the constraint on counter 3. By eliminating the constraint
on load latency, it becomes possible to measure loads and stores
precisely without multiplexing.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c    |    2 --
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    6 +++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index adb02aa..06c6616 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -110,7 +110,6 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 	INTEL_UEVENT_CONSTRAINT(0x06a3, 0x4), /* CYCLE_ACTIVITY.STALLS_L1D_PENDING */
 	INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
-	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
 	INTEL_UEVENT_CONSTRAINT(0x04a3, 0xf), /* CYCLE_ACTIVITY.CYCLES_NO_DISPATCH */
 	INTEL_UEVENT_CONSTRAINT(0x02a3, 0x4), /* CYCLE_ACTIVITY.CYCLES_L1D_PENDING */
 	EVENT_CONSTRAINT_END
@@ -210,7 +209,6 @@ static struct event_constraint intel_hsw_event_constraints[] = {
 	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* CPU_CLK_UNHALTED.REF */
 	INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.* */
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
-	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
 	/* CYCLE_ACTIVITY.CYCLES_L1D_PENDING */
 	INTEL_EVENT_CONSTRAINT(0x08a3, 0x4),
 	/* CYCLE_ACTIVITY.STALLS_L1D_PENDING */
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 46d4def..0685905 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -628,7 +628,7 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
 	INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
 	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
-	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
+	INTEL_PLD_CONSTRAINT(0x01cd, 0xf),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
 	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
 	INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
@@ -644,7 +644,7 @@ struct event_constraint intel_ivb_pebs_event_constraints[] = {
         INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
         INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
         INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
-        INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
+        INTEL_PLD_CONSTRAINT(0x01cd, 0xf),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
 	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
         INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
         INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
@@ -661,7 +661,7 @@ struct event_constraint intel_hsw_pebs_event_constraints[] = {
 	INTEL_UEVENT_CONSTRAINT(0x01c5, 0xf), /* BR_MISP_RETIRED.CONDITIONAL */
 	INTEL_UEVENT_CONSTRAINT(0x04c5, 0xf), /* BR_MISP_RETIRED.ALL_BRANCHES */
 	INTEL_UEVENT_CONSTRAINT(0x20c5, 0xf), /* BR_MISP_RETIRED.NEAR_TAKEN */
-	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.* */
+	INTEL_PLD_CONSTRAINT(0x01cd, 0xf),    /* MEM_TRANS_RETIRED.* */
 	/* MEM_UOPS_RETIRED.STLB_MISS_LOADS */
 	INTEL_UEVENT_CONSTRAINT(0x11d0, 0xf),
 	/* MEM_UOPS_RETIRED.STLB_MISS_STORES */
-- 
1.7.9.5

