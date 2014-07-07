Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaGGG32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 02:29:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:11668 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbaGGG3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 02:29:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,616,1400050800"; 
   d="scan'208";a="539565635"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v5 14/16] perf, x86: enable LBR callstack when recording callchain
Date: Mon,  7 Jul 2014 14:28:45 +0800
Message-Id: <1404714527-18603-17-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404714527-18603-1-git-send-email-zheng.z.yan@intel.com>
References: <1404714527-18603-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a task specific event wants user space callchain but does not want
branch stack sampling, enable the LBR call stack facility implicitly.
The LBR call stack facility can help perf to get user space callchain
in case of there is no frame pointer.

Note: this feature only affects how to get user callchain. The kernel
callchain is always got by frame pointers.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 367a76f..88f22dc 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -420,10 +420,23 @@ int x86_pmu_hw_config(struct perf_event *event)
 			if (!event->attr.exclude_kernel)
 				*br_type |= PERF_SAMPLE_BRANCH_KERNEL;
 		}
-	}
+	} else if (x86_pmu_has_lbr_callstack() &&
+		   (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN) &&
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
1.9.3

