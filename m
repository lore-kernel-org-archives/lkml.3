Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761765Ab3DBJrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:47:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50973 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760743Ab3DBJrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:47:18 -0400
Date: Tue, 2 Apr 2013 02:47:00 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-9ad64c0f481c37a63dd39842a0fd264bee44a097@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, tglx@linutronix.de
In-Reply-To: <1359040242-8269-11-git-send-email-eranian@google.com>
References: <1359040242-8269-11-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Add support for PEBS Precise Store
Git-Commit-ID: 9ad64c0f481c37a63dd39842a0fd264bee44a097
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 02:47:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ad64c0f481c37a63dd39842a0fd264bee44a097
Gitweb:     http://git.kernel.org/tip/9ad64c0f481c37a63dd39842a0fd264bee44a097
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 24 Jan 2013 16:10:34 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 1 Apr 2013 12:17:06 -0300

perf/x86: Add support for PEBS Precise Store

This patch adds support for PEBS Precise Store
which is available on Intel Sandy Bridge and
Ivy Bridge processors.

To use Precise store, the proper PEBS event
must be used: mem_trans_retired:precise_stores.
For the perf tool, the generic mem-stores event
exported via sysfs can be used directly.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: ak@linux.intel.com
Cc: acme@redhat.com
Cc: jolsa@redhat.com
Cc: namhyung.kim@lge.com
Link: http://lkml.kernel.org/r/1359040242-8269-11-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.h          |  5 ++++
 arch/x86/kernel/cpu/perf_event_intel.c    |  2 ++
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 49 +++++++++++++++++++++++++++++--
 3 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index f3a9a94..ba9aadf 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -66,6 +66,7 @@ struct event_constraint {
  * struct event_constraint flags
  */
 #define PERF_X86_EVENT_PEBS_LDLAT	0x1 /* ld+ldlat data address sampling */
+#define PERF_X86_EVENT_PEBS_ST		0x2 /* st data address sampling */
 
 struct amd_nb {
 	int nb_id;  /* NorthBridge id */
@@ -242,6 +243,10 @@ struct cpu_hw_events {
 	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
 			   HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LDLAT)
 
+#define INTEL_PST_CONSTRAINT(c, n)	\
+	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
+			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST)
+
 #define EVENT_CONSTRAINT_END		\
 	EVENT_CONSTRAINT(0, 0, 0)
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index ae6096b..e84c4ba 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -163,6 +163,7 @@ static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
 
 EVENT_ATTR_STR(mem-loads, mem_ld_nhm, "event=0x0b,umask=0x10,ldlat=3");
 EVENT_ATTR_STR(mem-loads, mem_ld_snb, "event=0xcd,umask=0x1,ldlat=3");
+EVENT_ATTR_STR(mem-stores, mem_st_snb, "event=0xcd,umask=0x2");
 
 struct attribute *nhm_events_attrs[] = {
 	EVENT_PTR(mem_ld_nhm),
@@ -171,6 +172,7 @@ struct attribute *nhm_events_attrs[] = {
 
 struct attribute *snb_events_attrs[] = {
 	EVENT_PTR(mem_ld_snb),
+	EVENT_PTR(mem_st_snb),
 	NULL,
 };
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index a6400bd..36dc13d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -69,6 +69,44 @@ static const u64 pebs_data_source[] = {
 	OP_LH | P(LVL, UNC) | P(SNOOP, NONE), /* 0x0f: uncached */
 };
 
+static u64 precise_store_data(u64 status)
+{
+	union intel_x86_pebs_dse dse;
+	u64 val = P(OP, STORE) | P(SNOOP, NA) | P(LVL, L1) | P(TLB, L2);
+
+	dse.val = status;
+
+	/*
+	 * bit 4: TLB access
+	 * 1 = stored missed 2nd level TLB
+	 *
+	 * so it either hit the walker or the OS
+	 * otherwise hit 2nd level TLB
+	 */
+	if (dse.st_stlb_miss)
+		val |= P(TLB, MISS);
+	else
+		val |= P(TLB, HIT);
+
+	/*
+	 * bit 0: hit L1 data cache
+	 * if not set, then all we know is that
+	 * it missed L1D
+	 */
+	if (dse.st_l1d_hit)
+		val |= P(LVL, HIT);
+	else
+		val |= P(LVL, MISS);
+
+	/*
+	 * bit 5: Locked prefix
+	 */
+	if (dse.st_locked)
+		val |= P(LOCK, LOCKED);
+
+	return val;
+}
+
 static u64 load_latency_data(u64 status)
 {
 	union intel_x86_pebs_dse dse;
@@ -486,6 +524,7 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
 	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
+	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
 	INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
@@ -500,6 +539,7 @@ struct event_constraint intel_ivb_pebs_event_constraints[] = {
         INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
         INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
         INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
+	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
         INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
         INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
         INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
@@ -537,6 +577,8 @@ void intel_pmu_pebs_enable(struct perf_event *event)
 
 	if (event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT)
 		cpuc->pebs_enabled |= 1ULL << (hwc->idx + 32);
+	else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST)
+		cpuc->pebs_enabled |= 1ULL << 63;
 }
 
 void intel_pmu_pebs_disable(struct perf_event *event)
@@ -657,12 +699,13 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	struct perf_sample_data data;
 	struct pt_regs regs;
 	u64 sample_type;
-	int fll;
+	int fll, fst;
 
 	if (!intel_pmu_save_and_restart(event))
 		return;
 
 	fll = event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT;
+	fst = event->hw.flags & PERF_X86_EVENT_PEBS_ST;
 
 	perf_sample_data_init(&data, 0, event->hw.last_period);
 
@@ -672,7 +715,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	/*
 	 * if PEBS-LL or PreciseStore
 	 */
-	if (fll) {
+	if (fll || fst) {
 		if (sample_type & PERF_SAMPLE_ADDR)
 			data.addr = pebs->dla;
 
@@ -688,6 +731,8 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 		if (sample_type & PERF_SAMPLE_DATA_SRC) {
 			if (fll)
 				data.data_src.val = load_latency_data(pebs->dse);
+			else
+				data.data_src.val = precise_store_data(pebs->dse);
 		}
 	}
 
