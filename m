Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab3DUMoG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 08:44:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40629 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab3DUMoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 08:44:03 -0400
Date: Sun, 21 Apr 2013 05:43:43 -0700
From: "tip-bot for Yan, Zheng" <tipbot@zytor.com>
Message-ID: <tip-22cc4ccf63e10e361531bf61e6e6c96c53a2f665@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, zheng.z.yan@intel.com, tglx@linutronix.de
In-Reply-To: <1366113067-3262-2-git-send-email-zheng.z.yan@intel.com>
References: <1366113067-3262-2-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Avoid kfree() in CPU_{STARTING,DYING}
Git-Commit-ID: 22cc4ccf63e10e361531bf61e6e6c96c53a2f665
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 21 Apr 2013 05:43:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22cc4ccf63e10e361531bf61e6e6c96c53a2f665
Gitweb:     http://git.kernel.org/tip/22cc4ccf63e10e361531bf61e6e6c96c53a2f665
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Tue, 16 Apr 2013 19:51:05 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 21 Apr 2013 10:59:01 +0200

perf/x86: Avoid kfree() in CPU_{STARTING,DYING}

On -rt kfree() can schedule, but CPU_{STARTING,DYING} should be
atomic. So use a list to defer kfree until CPU_{ONLINE,DEAD}.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: peterz@infradead.org
Cc: eranian@google.com
Cc: ak@linux.intel.com
Link: http://lkml.kernel.org/r/1366113067-3262-2-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 28 ++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 75da9e1..50d4a1c 100644
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
