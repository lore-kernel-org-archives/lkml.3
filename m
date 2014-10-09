Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbaJIQfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:35:33 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:43638 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239AbaJIQfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:35:22 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        kan.liang@intel.com, bp@alien8.de, maria.n.dimakopoulou@gmail.com
Subject: [PATCH v2 02/12] perf/x86: vectorize cpuc->kfree_on_online
Date: Thu,  9 Oct 2014 18:34:36 +0200
Message-Id: <1412872486-2930-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412872486-2930-1-git-send-email-eranian@google.com>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the cpuc->kfree_on_online a vector to accomodate
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
index 16c7302..542435f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1325,11 +1325,12 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
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
@@ -1342,7 +1343,10 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
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
index 8af5010..4c5a00c 100644
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
index beeb7cc..a8d1a43 100644
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
index 9f79da7..4b6a3b0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2158,12 +2158,14 @@ static void intel_pmu_cpu_starting(int cpu)
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

