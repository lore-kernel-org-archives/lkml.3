Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaKQTIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:08:12 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:50624 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaKQTIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:08:07 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        kan.liang@intel.com, bp@alien8.de, maria.n.dimakopoulou@gmail.com
Subject: [PATCH v3 02/13] perf/x86: vectorize cpuc->kfree_on_online
Date: Mon, 17 Nov 2014 20:06:54 +0100
Message-Id: <1416251225-17721-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416251225-17721-1-git-send-email-eranian@google.com>
References: <1416251225-17721-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the cpuc->kfree_on_online a vector to accommodate
more than one entry and add the second entry to be
used by a later patch.

Reviewed-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.c       | 10 +++++++---
 arch/x86/kernel/cpu/perf_event.h       |  8 +++++++-
 arch/x86/kernel/cpu/perf_event_amd.c   |  3 ++-
 arch/x86/kernel/cpu/perf_event_intel.c |  4 +++-
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 143e5f5..633a4b7 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1317,11 +1317,12 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (long)hcpu;
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
-	int ret = NOTIFY_OK;
+	int i, ret = NOTIFY_OK;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-		cpuc->kfree_on_online = NULL;
+		for (i = 0 ; i < X86_PERF_KFREE_MAX; i++)
+			cpuc->kfree_on_online[i] = NULL;
 		if (x86_pmu.cpu_prepare)
 			ret = x86_pmu.cpu_prepare(cpu);
 		break;
@@ -1334,7 +1335,10 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 		break;
 
 	case CPU_ONLINE:
-		kfree(cpuc->kfree_on_online);
+		for (i = 0 ; i < X86_PERF_KFREE_MAX; i++) {
+			kfree(cpuc->kfree_on_online[i]);
+			cpuc->kfree_on_online[i] = NULL;
+		}
 		break;
 
 	case CPU_DYING:
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 6a6b4e4..418e30d 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -123,6 +123,12 @@ struct intel_shared_regs {
 
 #define MAX_LBR_ENTRIES		16
 
+enum {
+	X86_PERF_KFREE_SHARED = 0,
+	X86_PERF_KFREE_EXCL   = 1,
+	X86_PERF_KFREE_MAX
+};
+
 struct cpu_hw_events {
 	/*
 	 * Generic x86 PMC bits
@@ -185,7 +191,7 @@ struct cpu_hw_events {
 	/* Inverted mask of bits to clear in the perf_ctr ctrl registers */
 	u64				perf_ctr_virt_mask;
 
-	void				*kfree_on_online;
+	void				*kfree_on_online[X86_PERF_KFREE_MAX];
 };
 
 #define __EVENT_CONSTRAINT(c, n, m, w, o, f) {\
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 2892631..e4302b8 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -382,6 +382,7 @@ static int amd_pmu_cpu_prepare(int cpu)
 static void amd_pmu_cpu_starting(int cpu)
 {
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
+	void **onln = &cpuc->kfree_on_online[X86_PERF_KFREE_SHARED];
 	struct amd_nb *nb;
 	int i, nb_id;
 
@@ -399,7 +400,7 @@ static void amd_pmu_cpu_starting(int cpu)
 			continue;
 
 		if (nb->nb_id == nb_id) {
-			cpuc->kfree_on_online = cpuc->amd_nb;
+			*onln = cpuc->amd_nb;
 			cpuc->amd_nb = nb;
 			break;
 		}
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 47d7357..9345194 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2011,12 +2011,14 @@ static void intel_pmu_cpu_starting(int cpu)
 		return;
 
 	if (!(x86_pmu.flags & PMU_FL_NO_HT_SHARING)) {
+		void **onln = &cpuc->kfree_on_online[X86_PERF_KFREE_SHARED];
+
 		for_each_cpu(i, topology_thread_cpumask(cpu)) {
 			struct intel_shared_regs *pc;
 
 			pc = per_cpu(cpu_hw_events, i).shared_regs;
 			if (pc && pc->core_id == core_id) {
-				cpuc->kfree_on_online = cpuc->shared_regs;
+				*onln = cpuc->shared_regs;
 				cpuc->shared_regs = pc;
 				break;
 			}
-- 
1.9.1

