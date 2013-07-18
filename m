Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747Ab3GRKsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:48:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:51135 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758368Ab3GRKsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:48:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,692,1367996400"; 
   d="scan'208";a="347705282"
Message-ID: <51E7C7E6.4020200@intel.com>
Date: Thu, 18 Jul 2013 18:48:06 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [PATCH] perf, x86: Add Silvermont (22nm Atom) support
References: <1374125767-9411-1-git-send-email-zheng.z.yan@intel.com> <20130718082324.GA27075@twins.programming.kicks-ass.net> <51E7A6F3.10109@intel.com> <20130718090248.GF27075@twins.programming.kicks-ass.net>
In-Reply-To: <20130718090248.GF27075@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 05:02 PM, Peter Zijlstra wrote:
> On Thu, Jul 18, 2013 at 04:27:31PM +0800, Yan, Zheng wrote:
>> On 07/18/2013 04:23 PM, Peter Zijlstra wrote:
>>> On Thu, Jul 18, 2013 at 01:36:07PM +0800, Yan, Zheng wrote:
>>>> +static struct event_constraint intel_slm_event_constraints[] __read_mostly =
>>>> +{
>>>> +	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
>>>> +	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
>>>> +	FIXED_EVENT_CONSTRAINT(0x013c, 2), /* CPU_CLK_UNHALTED.REF */
>>>> +	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* pseudo CPU_CLK_UNHALTED.REF */
>>>
>>> So the normal event 0x13c and the fixed counter 2 are normally _not_ the
>>> same. Are they for slm? Are you sure?
>>>
>>
>> yes, I'm sure. see page 15-15 of http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-optimization-manual.pdf
> 
> OK, then put in a comment how slm is 'special' and you might want to fix
> intel_pmu_init():
> 
> 	if (x86_pmu.event_constraints) {
> 		/*
> 		 * event on fixed counter2 (REF_CYCLES) only works on this
> 		 * counter, so do not extend mask to generic counters
> 		 */
> 		for_each_event_constraint(c, x86_pmu.event_constraints) {
> 			if (c->cmask != FIXED_EVENT_FLAGS
> 			    || c->idxmsk64 == INTEL_PMC_MSK_FIXED_REF_CYCLES) {
> 				continue;
> 			}
> 
> 			c->idxmsk64 |= (1ULL << x86_pmu.num_counters) - 1;
> 			c->weight += x86_pmu.num_counters;
> 		}
> 	}
> 
> Since that explicitly skips the fixed counter 2 and doesn't extend its
> constraint to include all other counters.
> 

how about below patch

Regards
Yan, Zheng
---
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8249df4..aa0d876 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -140,7 +140,6 @@ struct x86_pmu_capability {
 /* CPU_CLK_Unhalted.Ref: */
 #define MSR_ARCH_PERFMON_FIXED_CTR2	0x30b
 #define INTEL_PMC_IDX_FIXED_REF_CYCLES	(INTEL_PMC_IDX_FIXED + 2)
-#define INTEL_PMC_MSK_FIXED_REF_CYCLES	(1ULL << INTEL_PMC_IDX_FIXED_REF_CYCLES)
 
 /*
  * We model BTS tracing as another fixed-mode PMC.
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index e4bb30a..47ffb48 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -169,7 +169,6 @@ static struct event_constraint intel_slm_event_constraints[] __read_mostly =
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
 	FIXED_EVENT_CONSTRAINT(0x013c, 2), /* CPU_CLK_UNHALTED.REF */
-	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* pseudo CPU_CLK_UNHALTED.REF */
 	EVENT_CONSTRAINT_END
 };
 
@@ -2331,6 +2330,9 @@ __init int intel_pmu_init(void)
 
 		intel_pmu_lbr_init_atom();
 
+		/* both event 0x013c and fixed counter2 count REF_CYCLES */
+		intel_perfmon_event_map[PERF_COUNT_HW_REF_CPU_CYCLES] = 0x013c;
+
 		x86_pmu.event_constraints = intel_slm_event_constraints;
 		x86_pmu.pebs_constraints = intel_slm_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_slm_extra_regs;
@@ -2486,12 +2488,12 @@ __init int intel_pmu_init(void)
 
 	if (x86_pmu.event_constraints) {
 		/*
-		 * event on fixed counter2 (REF_CYCLES) only works on this
-		 * counter, so do not extend mask to generic counters
+		 * If only fixed counter2 can count event REF_CYCLES, we use
+		 * pseudo-code 0x0300 for REF_CYCLES.
 		 */
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
-			if (c->cmask != FIXED_EVENT_FLAGS
-			    || c->idxmsk64 == INTEL_PMC_MSK_FIXED_REF_CYCLES) {
+			if (c->cmask != FIXED_EVENT_FLAGS ||
+			    c->code == 0x0300) {
 				continue;
 			}
 

