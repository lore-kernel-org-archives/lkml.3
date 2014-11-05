Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbaKEDLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 22:11:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:23387 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbaKEDKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 22:10:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,317,1413270000"; 
   d="scan'208";a="617287015"
From: Kan Liang <kan.liang@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V7 13/17] perf, x86: enable LBR callstack when recording callchain
Date: Tue,  4 Nov 2014 21:56:09 -0500
Message-Id: <1415156173-10035-14-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
References: <1415156173-10035-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yan, Zheng <zheng.z.yan@intel.com>

Only enable LBR callstack when user requires fp callgraph. The feature
is not available when PERF_SAMPLE_BRANCH_STACK or PERF_SAMPLE_STACK_USER
is required.
Also, this feature only affects how to get user callchain. The kernel
callchain is always got by frame pointers.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2f79b9d..f454620 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -425,10 +425,24 @@ int x86_pmu_hw_config(struct perf_event *event)
 			if (!event->attr.exclude_kernel)
 				*br_type |= PERF_SAMPLE_BRANCH_KERNEL;
 		}
-	}
+	} else if (x86_pmu_has_lbr_callstack() &&
+		   (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) &&
+		   !(event->attr.sample_type & PERF_SAMPLE_STACK_USER) &&
+		   !has_branch_stack(event) &&
+		   !event->attr.exclude_user &&
+		   (event->attach_state & PERF_ATTACH_TASK)) {
+		/*
+		 * user did not specify branch_sample_type,
+		 * try using the LBR call stack facility to
+		 * record call chains of user program.
+		 */
+		event->attr.branch_sample_type =
+			PERF_SAMPLE_BRANCH_USER |
+			PERF_SAMPLE_BRANCH_CALL_STACK;
 
-	if (event->attr.branch_sample_type & PERF_SAMPLE_BRANCH_CALL_STACK)
+		/* needs PMU specific data to save LBR stack */
 		event->attach_state |= PERF_ATTACH_TASK_DATA;
+	}
 
 	/*
 	 * Generate PMC IRQs:
-- 
1.8.3.2

