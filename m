Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab3DPLvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 07:51:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:41990 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab3DPLvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 07:51:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,485,1363158000"; 
   d="scan'208";a="295630060"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 1/3] perf/x86: Avoid kfree() in CPU_{STARTING,DYING}
Date: Tue, 16 Apr 2013 19:51:05 +0800
Message-Id: <1366113067-3262-2-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1366113067-3262-1-git-send-email-zheng.z.yan@intel.com>
References: <1366113067-3262-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

On -rt kfree() can schedule, but CPU_{STARTING,DYING} should be
atomic. So use a list to defer kfree until CPU_{ONLINE,DEAD}.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 28 ++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index b43200d..eafde72 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2622,6 +2622,21 @@ static void __init uncore_pci_exit(void)
 	}
 }
 
+/* CPU hot plug/unplug are serialized by cpu_add_remove_lock mutex */
+static LIST_HEAD(boxes_to_free);
+
+static void __cpuinit uncore_kfree_boxes(void)
+{
+	struct intel_uncore_box *box;
+
+	while (!list_empty(&boxes_to_free)) {
+		box = list_entry(boxes_to_free.next,
+				 struct intel_uncore_box, list);
+		list_del(&box->list);
+		kfree(box);
+	}
+}
+
 static void __cpuinit uncore_cpu_dying(int cpu)
 {
 	struct intel_uncore_type *type;
@@ -2636,7 +2651,7 @@ static void __cpuinit uncore_cpu_dying(int cpu)
 			box = *per_cpu_ptr(pmu->box, cpu);
 			*per_cpu_ptr(pmu->box, cpu) = NULL;
 			if (box && atomic_dec_and_test(&box->refcnt))
-				kfree(box);
+				list_add(&box->list, &boxes_to_free);
 		}
 	}
 }
@@ -2666,8 +2681,11 @@ static int __cpuinit uncore_cpu_starting(int cpu)
 				if (exist && exist->phys_id == phys_id) {
 					atomic_inc(&exist->refcnt);
 					*per_cpu_ptr(pmu->box, cpu) = exist;
-					kfree(box);
-					box = NULL;
+					if (box) {
+						list_add(&box->list,
+							 &boxes_to_free);
+						box = NULL;
+					}
 					break;
 				}
 			}
@@ -2806,6 +2824,10 @@ static int
 	case CPU_DYING:
 		uncore_cpu_dying(cpu);
 		break;
+	case CPU_ONLINE:
+	case CPU_DEAD:
+		uncore_kfree_boxes();
+		break;
 	default:
 		break;
 	}
-- 
1.7.11.7

