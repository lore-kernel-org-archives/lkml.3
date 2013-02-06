Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab3BFUcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:32:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36434 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758326Ab3BFUb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:31:57 -0500
Date: Wed, 6 Feb 2013 12:31:39 -0800
From: tip-bot for Jacob Shin <jacob.shin@amd.com>
Message-ID: <tip-4c1fd17a1cb32bc4f429c7a5ff9a91a3bffdb8fa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jolsa@redhat.com, jacob.shin@amd.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, jacob.shin@amd.com,
        tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1360171589-6381-5-git-send-email-jacob.shin@amd.com>
References: <1360171589-6381-5-git-send-email-jacob.shin@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Move MSR address offset calculation to architecture specific files
Git-Commit-ID: 4c1fd17a1cb32bc4f429c7a5ff9a91a3bffdb8fa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 12:31:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c1fd17a1cb32bc4f429c7a5ff9a91a3bffdb8fa
Gitweb:     http://git.kernel.org/tip/4c1fd17a1cb32bc4f429c7a5ff9a91a3bffdb8fa
Author:     Jacob Shin <jacob.shin@amd.com>
AuthorDate: Wed, 6 Feb 2013 11:26:27 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Feb 2013 19:45:24 +0100

perf/x86: Move MSR address offset calculation to architecture specific files

Move counter index to MSR address offset calculation to
architecture specific files. This prepares the way for
perf_event_amd to enable counter addresses that are not
contiguous -- for example AMD Family 15h processors have 6 core
performance counters starting at 0xc0010200 and 4 northbridge
performance counters starting at 0xc0010240.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1360171589-6381-5-git-send-email-jacob.shin@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.h     | 21 +++++-------------
 arch/x86/kernel/cpu/perf_event_amd.c | 42 ++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 115c1ea..a7f06a9 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -325,6 +325,7 @@ struct x86_pmu {
 	int		(*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
 	unsigned	eventsel;
 	unsigned	perfctr;
+	int		(*addr_offset)(int index, bool eventsel);
 	u64		(*event_map)(int);
 	int		max_events;
 	int		num_counters;
@@ -446,28 +447,16 @@ extern u64 __read_mostly hw_cache_extra_regs
 
 u64 x86_perf_event_update(struct perf_event *event);
 
-static inline int x86_pmu_addr_offset(int index)
-{
-	int offset;
-
-	/* offset = X86_FEATURE_PERFCTR_CORE ? index << 1 : index */
-	alternative_io(ASM_NOP2,
-		       "shll $1, %%eax",
-		       X86_FEATURE_PERFCTR_CORE,
-		       "=a" (offset),
-		       "a"  (index));
-
-	return offset;
-}
-
 static inline unsigned int x86_pmu_config_addr(int index)
 {
-	return x86_pmu.eventsel + x86_pmu_addr_offset(index);
+	return x86_pmu.eventsel + (x86_pmu.addr_offset ?
+				   x86_pmu.addr_offset(index, true) : index);
 }
 
 static inline unsigned int x86_pmu_event_addr(int index)
 {
-	return x86_pmu.perfctr + x86_pmu_addr_offset(index);
+	return x86_pmu.perfctr + (x86_pmu.addr_offset ?
+				  x86_pmu.addr_offset(index, false) : index);
 }
 
 int x86_setup_perfctr(struct perf_event *event);
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index aea8c20..b60f31c 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -132,6 +132,47 @@ static u64 amd_pmu_event_map(int hw_event)
 	return amd_perfmon_event_map[hw_event];
 }
 
+/*
+ * Previously calculated offsets
+ */
+static unsigned int event_offsets[X86_PMC_IDX_MAX] __read_mostly;
+static unsigned int count_offsets[X86_PMC_IDX_MAX] __read_mostly;
+
+/*
+ * Legacy CPUs:
+ *   4 counters starting at 0xc0010000 each offset by 1
+ *
+ * CPUs with core performance counter extensions:
+ *   6 counters starting at 0xc0010200 each offset by 2
+ */
+static inline int amd_pmu_addr_offset(int index, bool eventsel)
+{
+	int offset;
+
+	if (!index)
+		return index;
+
+	if (eventsel)
+		offset = event_offsets[index];
+	else
+		offset = count_offsets[index];
+
+	if (offset)
+		return offset;
+
+	if (!cpu_has_perfctr_core)
+		offset = index;
+	else
+		offset = index << 1;
+
+	if (eventsel)
+		event_offsets[index] = offset;
+	else
+		count_offsets[index] = offset;
+
+	return offset;
+}
+
 static int amd_pmu_hw_config(struct perf_event *event)
 {
 	int ret;
@@ -578,6 +619,7 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.schedule_events	= x86_schedule_events,
 	.eventsel		= MSR_K7_EVNTSEL0,
 	.perfctr		= MSR_K7_PERFCTR0,
+	.addr_offset            = amd_pmu_addr_offset,
 	.event_map		= amd_pmu_event_map,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
 	.num_counters		= AMD64_NUM_COUNTERS,
