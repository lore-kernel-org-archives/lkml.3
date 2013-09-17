Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab3IQE6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 00:58:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:58151 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab3IQE6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 00:58:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,920,1371106800"; 
   d="scan'208";a="295727995"
Message-ID: <5237E17A.80603@intel.com>
Date: Tue, 17 Sep 2013 12:58:34 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: eranian@google.com, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] uncore_pmu_event_init: using smp_processor_id() in preemptible
 core
References: <20130916092110.GA29018@twins.programming.kicks-ass.net>
In-Reply-To: <20130916092110.GA29018@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2013 05:21 PM, Peter Zijlstra wrote:
> Hi,
> 
> Trinity just triggered this:
> 
> [  595.847438] BUG: using smp_processor_id() in preemptible [00000000] code: trinity-child28/2674
> [  595.857378] caller is uncore_pmu_event_init+0x114/0x270
> [  595.863262] CPU: 11 PID: 2674 Comm: trinity-child28 Tainted: G        W    3.11.0+ #365
> [  595.872146] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/08/2010
> [  595.879656]  000000000000000b ffff880433e09d98 ffffffff81642eb8 ffff880433e09fd8
> [  595.888430]  ffff880433e09dc0 ffffffff81367d1e ffff880373621000 ffff880435bacc00
> [  595.897330]  0000000000000000 ffff880433e09df8 ffffffff81068394 ffffffff81068285
> [  595.906252] Call Trace:
> [  595.909127]  [<ffffffff81642eb8>] dump_stack+0x4e/0x82
> [  595.914925]  [<ffffffff81367d1e>] debug_smp_processor_id+0xde/0x100
> [  595.921903]  [<ffffffff81068394>] uncore_pmu_event_init+0x114/0x270
> [  595.928907]  [<ffffffff81068285>] ? uncore_pmu_event_init+0x5/0x270
> [  595.935806]  [<ffffffff8114d18c>] perf_init_event+0xcc/0x190
> 
> That's in uncore_validate_group() where we allocate the fake_box().
> 
> I'm thinking we might as well use raw_smp_processor_id() since it really
> doesn't matter where the fake box lives.
> 
> ---
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index 8ed4458..63c8913 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -3031,7 +3031,7 @@ static int uncore_validate_group(struct intel_uncore_pmu *pmu,
>  	struct intel_uncore_box *fake_box;
>  	int ret = -EINVAL, n;
>  
> -	fake_box = uncore_alloc_box(pmu->type, smp_processor_id());
> +	fake_box = uncore_alloc_box(pmu->type, raw_smp_processor_id());
>  	if (!fake_box)
>  		return -ENOMEM;
>  
> 

how about using kzalloc() in this case.

---
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index fd8011e..a12a22f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2713,7 +2713,10 @@ struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type, int cp
 
 	size = sizeof(*box) + type->num_shared_regs * sizeof(struct intel_uncore_extra_reg);
 
-	box = kzalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
+	if (cpu < 0)
+		box = kzalloc(size, GFP_KERNEL);
+	else
+		box = kzalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
 	if (!box)
 		return NULL;
 
@@ -3031,7 +3034,7 @@ static int uncore_validate_group(struct intel_uncore_pmu *pmu,
 	struct intel_uncore_box *fake_box;
 	int ret = -EINVAL, n;
 
-	fake_box = uncore_alloc_box(pmu->type, smp_processor_id());
+	fake_box = uncore_alloc_box(pmu->type, -1);
 	if (!fake_box)
 		return -ENOMEM;
 
