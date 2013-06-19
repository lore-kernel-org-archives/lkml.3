Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965075Ab3FSSnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:43:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40298 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964945Ab3FSSnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:43:19 -0400
Date: Wed, 19 Jun 2013 11:43:04 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-f9134f36aed59ab55c0ab1a4618dd455f15aef5f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, ak@linux.jf.intel.com,
        ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        ak@linux.jf.intel.com, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1371515812-9646-7-git-send-email-andi@firstfloor.org>
References: <1371515812-9646-7-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel: Add mem-loads/
 stores support for Haswell
Git-Commit-ID: f9134f36aed59ab55c0ab1a4618dd455f15aef5f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:43:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9134f36aed59ab55c0ab1a4618dd455f15aef5f
Gitweb:     http://git.kernel.org/tip/f9134f36aed59ab55c0ab1a4618dd455f15aef5f
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 17 Jun 2013 17:36:52 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 14:43:35 +0200

perf/x86/intel: Add mem-loads/stores support for Haswell

mem-loads is basically the same as Sandy Bridge,
but we use a separate string for changes later.

Haswell doesn't support the full precise store mode,
so we emulate it using the "DataLA" facility.
This allows to do everything, but for data sources we
can only detect L1 hit or not.

There is no explicit enable bit anymore, so we have
to tie it to a perf internal only flag.

The address is supported for all memory related PEBS
events with DataLA. Instead of only logging for the
load and store events we allow logging it for all
(it will be simply 0 if the current event does not
support it)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <ak@linux.jf.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: http://lkml.kernel.org/r/1371515812-9646-7-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.h          |  6 ++++++
 arch/x86/kernel/cpu/perf_event_intel.c    | 10 ++++++++++
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 32 ++++++++++++++++++++++++-------
 3 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index f43473c..108dc75 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -67,6 +67,7 @@ struct event_constraint {
  */
 #define PERF_X86_EVENT_PEBS_LDLAT	0x1 /* ld+ldlat data address sampling */
 #define PERF_X86_EVENT_PEBS_ST		0x2 /* st data address sampling */
+#define PERF_X86_EVENT_PEBS_ST_HSW	0x4 /* haswell style st data sampling */
 
 struct amd_nb {
 	int nb_id;  /* NorthBridge id */
@@ -250,6 +251,11 @@ struct cpu_hw_events {
 	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST)
 
+/* DataLA version of store sampling without extra enable bit. */
+#define INTEL_PST_HSW_CONSTRAINT(c, n)	\
+	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
+			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST_HSW)
+
 #define EVENT_CONSTRAINT_END		\
 	EVENT_CONSTRAINT(0, 0, 0)
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 877672c..a6eccf1 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2036,6 +2036,15 @@ static __init void intel_nehalem_quirk(void)
 	}
 }
 
+EVENT_ATTR_STR(mem-loads,      mem_ld_hsw,     "event=0xcd,umask=0x1,ldlat=3");
+EVENT_ATTR_STR(mem-stores,     mem_st_hsw,     "event=0xd0,umask=0x82")
+
+static struct attribute *hsw_events_attrs[] = {
+	EVENT_PTR(mem_ld_hsw),
+	EVENT_PTR(mem_st_hsw),
+	NULL
+};
+
 __init int intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
@@ -2279,6 +2288,7 @@ __init int intel_pmu_init(void)
 
 		x86_pmu.hw_config = hsw_hw_config;
 		x86_pmu.get_event_constraints = hsw_get_event_constraints;
+		x86_pmu.cpu_events = hsw_events_attrs;
 		pr_cont("Haswell events, ");
 		break;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index e83148f..ed3e553 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -107,6 +107,19 @@ static u64 precise_store_data(u64 status)
 	return val;
 }
 
+static u64 precise_store_data_hsw(u64 status)
+{
+	union perf_mem_data_src dse;
+
+	dse.val = 0;
+	dse.mem_op = PERF_MEM_OP_STORE;
+	dse.mem_lvl = PERF_MEM_LVL_NA;
+	if (status & 1)
+		dse.mem_lvl = PERF_MEM_LVL_L1;
+	/* Nothing else supported. Sorry. */
+	return dse.val;
+}
+
 static u64 load_latency_data(u64 status)
 {
 	union intel_x86_pebs_dse dse;
@@ -566,13 +579,13 @@ struct event_constraint intel_ivb_pebs_event_constraints[] = {
 
 struct event_constraint intel_hsw_pebs_event_constraints[] = {
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
-	INTEL_UEVENT_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
+	INTEL_PST_HSW_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
 	INTEL_UEVENT_CONSTRAINT(0x02c2, 0xf), /* UOPS_RETIRED.RETIRE_SLOTS */
 	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
 	INTEL_UEVENT_CONSTRAINT(0x01c5, 0xf), /* BR_MISP_RETIRED.CONDITIONAL */
 	INTEL_UEVENT_CONSTRAINT(0x04c5, 0xf), /* BR_MISP_RETIRED.ALL_BRANCHES */
 	INTEL_UEVENT_CONSTRAINT(0x20c5, 0xf), /* BR_MISP_RETIRED.NEAR_TAKEN */
-	INTEL_EVENT_CONSTRAINT(0xcd, 0x8),    /* MEM_TRANS_RETIRED.* */
+	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.* */
 	/* MEM_UOPS_RETIRED.STLB_MISS_LOADS */
 	INTEL_UEVENT_CONSTRAINT(0x11d0, 0xf),
 	/* MEM_UOPS_RETIRED.STLB_MISS_STORES */
@@ -582,7 +595,7 @@ struct event_constraint intel_hsw_pebs_event_constraints[] = {
 	/* MEM_UOPS_RETIRED.SPLIT_STORES */
 	INTEL_UEVENT_CONSTRAINT(0x42d0, 0xf),
 	INTEL_UEVENT_CONSTRAINT(0x81d0, 0xf), /* MEM_UOPS_RETIRED.ALL_LOADS */
-	INTEL_UEVENT_CONSTRAINT(0x82d0, 0xf), /* MEM_UOPS_RETIRED.ALL_STORES */
+	INTEL_PST_HSW_CONSTRAINT(0x82d0, 0xf), /* MEM_UOPS_RETIRED.ALL_STORES */
 	INTEL_UEVENT_CONSTRAINT(0x01d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L1_HIT */
 	INTEL_UEVENT_CONSTRAINT(0x02d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L2_HIT */
 	INTEL_UEVENT_CONSTRAINT(0x04d1, 0xf), /* MEM_LOAD_UOPS_RETIRED.L3_HIT */
@@ -759,7 +772,8 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 		return;
 
 	fll = event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT;
-	fst = event->hw.flags & PERF_X86_EVENT_PEBS_ST;
+	fst = event->hw.flags & (PERF_X86_EVENT_PEBS_ST |
+				 PERF_X86_EVENT_PEBS_ST_HSW);
 
 	perf_sample_data_init(&data, 0, event->hw.last_period);
 
@@ -770,9 +784,6 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	 * if PEBS-LL or PreciseStore
 	 */
 	if (fll || fst) {
-		if (sample_type & PERF_SAMPLE_ADDR)
-			data.addr = pebs->dla;
-
 		/*
 		 * Use latency for weight (only avail with PEBS-LL)
 		 */
@@ -785,6 +796,9 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 		if (sample_type & PERF_SAMPLE_DATA_SRC) {
 			if (fll)
 				data.data_src.val = load_latency_data(pebs->dse);
+			else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST_HSW)
+				data.data_src.val =
+					precise_store_data_hsw(pebs->dse);
 			else
 				data.data_src.val = precise_store_data(pebs->dse);
 		}
@@ -814,6 +828,10 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	else
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 
+	if ((event->attr.sample_type & PERF_SAMPLE_ADDR) &&
+		x86_pmu.intel_cap.pebs_format >= 1)
+		data.addr = pebs->dla;
+
 	if (has_branch_stack(event))
 		data.br_stack = &cpuc->lbr_stack;
 
