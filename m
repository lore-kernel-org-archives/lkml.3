Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab3KFKnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:43:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51498 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab3KFKnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:43:12 -0500
Date: Wed, 6 Nov 2013 11:42:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v5 3/4] perf,x86: add Intel RAPL PMU support
Message-ID: <20131106104243.GF10651@twins.programming.kicks-ass.net>
References: <1383670886-30827-1-git-send-email-eranian@google.com>
 <1383670886-30827-4-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383670886-30827-4-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 06:01:25PM +0100, Stephane Eranian wrote:
> +static int rapl_cpu_dying(int cpu)
> +{
> +	struct rapl_pmu *pmu = per_cpu(rapl_pmu, cpu);
> +	struct perf_event *event, *tmp;
> +
> +	if (!pmu)
> +		return 0;
> +
> +	spin_lock(&rapl_hotplug_lock);
> +
> +	/*
> +	 * stop all syswide RAPL events on that  CPU
> +	 * as a consequence also stops the hrtimer
> +	 */
> +	list_for_each_entry_safe(event, tmp, &pmu->active_list, active_entry) {
> +		rapl_pmu_event_stop(event, PERF_EF_UPDATE);
> +	}
> +
> +	per_cpu(rapl_pmu, cpu) = NULL;
> +
> +	if (atomic_dec_and_test(&pmu->refcnt))
> +		kfree(pmu);
> +
> +	spin_unlock(&rapl_hotplug_lock);
> +	return 0;
> +}

Could you do an add-on patch similar to the below -- no need to respin
the entire series once again for this.

---
commit 22cc4ccf63e10e361531bf61e6e6c96c53a2f665
Author: Yan, Zheng <zheng.z.yan@intel.com>
Date:   Tue Apr 16 19:51:05 2013 +0800

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

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 75da9e18b128..50d4a1c58106 100644
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
