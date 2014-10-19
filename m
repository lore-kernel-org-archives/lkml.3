Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaJSWJt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:09:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:34011 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbaJSWFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:05:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="402644485"
From: Kan Liang <kan.liang@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V6 07/17] perf, x86: allocate space for storing LBR stack
Date: Sun, 19 Oct 2014 17:55:02 -0400
Message-Id: <1413755712-8259-8-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
References: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the LBR call stack is enabled, it is necessary to save/restore
the LBR stack on context switch. We can use pmu specific data to
store LBR stack when task is scheduled out. This patch adds code
that allocates the pmu specific data.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Kan Liang <kan.liang@intel.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.c | 4 ++++
 arch/x86/kernel/cpu/perf_event.h | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index fa7a168..f94a618e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -427,6 +427,9 @@ int x86_pmu_hw_config(struct perf_event *event)
 		}
 	}
 
+	if (event->attr.branch_sample_type & PERF_SAMPLE_BRANCH_CALL_STACK)
+		event->attach_state |= PERF_ATTACH_TASK_DATA;
+
 	/*
 	 * Generate PMC IRQs:
 	 * (keep 'enabled' bit clear for now)
@@ -1920,6 +1923,7 @@ static struct pmu pmu = {
 
 	.event_idx		= x86_pmu_event_idx,
 	.sched_task		= x86_pmu_sched_task,
+	.task_ctx_size          = sizeof(struct x86_perf_task_context),
 };
 
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 21e03ed..c210bff 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -511,6 +511,13 @@ struct x86_pmu {
 	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
 };
 
+struct x86_perf_task_context {
+	u64 lbr_from[MAX_LBR_ENTRIES];
+	u64 lbr_to[MAX_LBR_ENTRIES];
+	int lbr_callstack_users;
+	int lbr_stack_state;
+};
+
 enum {
 	PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT = PERF_SAMPLE_BRANCH_MAX_SHIFT,
 	PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE,
-- 
1.8.3.2

