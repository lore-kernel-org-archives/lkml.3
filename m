Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3IRLbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 07:31:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40572 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab3IRLbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 07:31:32 -0400
Date: Wed, 18 Sep 2013 13:31:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: eranian@google.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] perf/x86/intel/uncore: don't use smp_processor_id() in
 validate_group()
Message-ID: <20130918113124.GI9326@twins.programming.kicks-ass.net>
References: <1379400493-11505-1-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379400493-11505-1-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 02:48:13PM +0800, Yan, Zheng wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> uncore_validate_group() can't call smp_processor_id() because it is
> in preemptible context. Pass NUMA_NO_NODE to the allocator instead.
> 
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index fd8011e..11b1582 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -3031,7 +3031,7 @@ static int uncore_validate_group(struct intel_uncore_pmu *pmu,
>  	struct intel_uncore_box *fake_box;
>  	int ret = -EINVAL, n;
>  
> -	fake_box = uncore_alloc_box(pmu->type, smp_processor_id());
> +	fake_box = uncore_alloc_box(pmu->type, NUMA_NO_NODE);

Doesn't work since you're passing cpu, not node.

I changed it to the below. However upon doing so I noticed you
hard coded PCI devices live on Node0, this is not true in general
(although likely true for tiny systems).

I've absolutely no clue about the entire PCI layer, but it would be nice
if there's a method to extract the local node of a pci device.

Bjorn is there such a thing?

---
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2706,14 +2706,14 @@ static void uncore_pmu_init_hrtimer(stru
 	box->hrtimer.function = uncore_pmu_hrtimer;
 }
 
-struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type, int cpu)
+static struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type, int node)
 {
 	struct intel_uncore_box *box;
 	int i, size;
 
 	size = sizeof(*box) + type->num_shared_regs * sizeof(struct intel_uncore_extra_reg);
 
-	box = kzalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
+	box = kzalloc_node(size, GFP_KERNEL, node);
 	if (!box)
 		return NULL;
 
@@ -3031,7 +3031,7 @@ static int uncore_validate_group(struct
 	struct intel_uncore_box *fake_box;
 	int ret = -EINVAL, n;
 
-	fake_box = uncore_alloc_box(pmu->type, smp_processor_id());
+	fake_box = uncore_alloc_box(pmu->type, NUMA_NO_NODE);
 	if (!fake_box)
 		return -ENOMEM;
 
@@ -3294,7 +3294,7 @@ static int uncore_pci_probe(struct pci_d
 	}
 
 	type = pci_uncores[UNCORE_PCI_DEV_TYPE(id->driver_data)];
-	box = uncore_alloc_box(type, 0);
+	box = uncore_alloc_box(type, NUMA_NO_NODE);
 	if (!box)
 		return -ENOMEM;
 
@@ -3499,7 +3499,7 @@ static int uncore_cpu_prepare(int cpu, i
 			if (pmu->func_id < 0)
 				pmu->func_id = j;
 
-			box = uncore_alloc_box(type, cpu);
+			box = uncore_alloc_box(type, cpu_to_node(cpu));
 			if (!box)
 				return -ENOMEM;
 
