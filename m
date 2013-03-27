Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab3C0XHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 19:07:14 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:37299
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240Ab3C0XHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 19:07:11 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKCDJU-01-4UQ-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, <x86@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 2/3] perf, x86: Allow for multiple kfree_on_online pointers
Date: Wed, 27 Mar 2013 18:07:03 -0500
Message-ID: <1364425624-7556-3-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364425624-7556-1-git-send-email-jacob.shin@amd.com>
References: <1364425624-7556-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently only 1 pointer can be freed using kfree_on_online mechanism,
allow for multiple.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c       |    7 +++++--
 arch/x86/kernel/cpu/perf_event.h       |    3 ++-
 arch/x86/kernel/cpu/perf_event_amd.c   |    2 +-
 arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index bf0f01a..64c4b7a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1258,10 +1258,12 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 	unsigned int cpu = (long)hcpu;
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
 	int ret = NOTIFY_OK;
+	int i;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_UP_PREPARE:
-		cpuc->kfree_on_online = NULL;
+		for (i = 0; i < MAX_KFREE_ON_ONLINE; i++)
+			cpuc->kfree_on_online[i] = NULL;
 		if (x86_pmu.cpu_prepare)
 			ret = x86_pmu.cpu_prepare(cpu);
 		break;
@@ -1274,7 +1276,8 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 		break;
 
 	case CPU_ONLINE:
-		kfree(cpuc->kfree_on_online);
+		for (i = 0; i < MAX_KFREE_ON_ONLINE; i++)
+			kfree(cpuc->kfree_on_online[i]);
 		break;
 
 	case CPU_DYING:
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index fdaac69..770f3b99 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -111,6 +111,7 @@ struct intel_shared_regs {
 };
 
 #define MAX_LBR_ENTRIES		16
+#define MAX_KFREE_ON_ONLINE	4
 
 struct cpu_hw_events {
 	/*
@@ -167,7 +168,7 @@ struct cpu_hw_events {
 	/* Inverted mask of bits to clear in the perf_ctr ctrl registers */
 	u64				perf_ctr_virt_mask;
 
-	void				*kfree_on_online;
+	void				*kfree_on_online[MAX_KFREE_ON_ONLINE];
 };
 
 #define __EVENT_CONSTRAINT(c, n, m, w, o) {\
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 23964a6..36b5162 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -505,7 +505,7 @@ static void amd_pmu_cpu_starting(int cpu)
 			continue;
 
 		if (nb->id == nb_id) {
-			cpuc->kfree_on_online = cpuc->amd_nb;
+			cpuc->kfree_on_online[0] = cpuc->amd_nb;
 			cpuc->amd_nb = nb;
 			break;
 		}
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index dab7580..f79a0c5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1719,7 +1719,7 @@ static void intel_pmu_cpu_starting(int cpu)
 
 			pc = per_cpu(cpu_hw_events, i).shared_regs;
 			if (pc && pc->core_id == core_id) {
-				cpuc->kfree_on_online = cpuc->shared_regs;
+				cpuc->kfree_on_online[0] = cpuc->shared_regs;
 				cpuc->shared_regs = pc;
 				break;
 			}
-- 
1.7.9.5


