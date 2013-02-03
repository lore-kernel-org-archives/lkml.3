Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab3BCKfI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 05:35:08 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:64935 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab3BCKfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 05:35:06 -0500
Date: Sun, 3 Feb 2013 11:35:00 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/5] perf, x86: Add PEBSv2 record support
Message-ID: <20130203103500.GD9330@gmail.com>
References: <1359770064-6344-1-git-send-email-andi@firstfloor.org>
 <1359770064-6344-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359770064-6344-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Add support for the v2 PEBS format. It has a superset of the v1 PEBS
> fields, but has a longer record so we need to adjust the code paths.
> 
> The main advantage is the new "EventingRip" support which directly
> gives the instruction, not off-by-one instruction. So with precise == 2
> we use that directly and don't try to use LBRs and walking basic blocks.
> This lowers the overhead significantly.
> 
> Some other features are added in later patches.
> 
> Reviewed-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c          |    2 +-
>  arch/x86/kernel/cpu/perf_event_intel_ds.c |  101 ++++++++++++++++++++++-------
>  2 files changed, 79 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 6774c17..c95290a 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -397,7 +397,7 @@ int x86_pmu_hw_config(struct perf_event *event)
>  		 * check that PEBS LBR correction does not conflict with
>  		 * whatever the user is asking with attr->branch_sample_type
>  		 */
> -		if (event->attr.precise_ip > 1) {
> +		if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format < 2) {
>  			u64 *br_type = &event->attr.branch_sample_type;
>  
>  			if (has_branch_stack(event)) {
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index 826054a..9d0dae0 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -41,6 +41,12 @@ struct pebs_record_nhm {
>  	u64 status, dla, dse, lat;
>  };
>  
> +struct pebs_record_v2 {
> +	struct pebs_record_nhm nhm;
> +	u64 eventingrip;
> +	u64 tsx_tuning;

'eventingrip' should be something more readable and obvious. 
Also, comments for fields are needed when introducing new 
structs.

> +};
> +
>  void init_debug_store_on_cpu(int cpu)
>  {
>  	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
> @@ -559,8 +565,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
>  {
>  	/*
>  	 * We cast to pebs_record_core since that is a subset of
> -	 * both formats and we don't use the other fields in this
> -	 * routine.
> +	 * both formats.
>  	 */
>  	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>  	struct pebs_record_core *pebs = __pebs;
> @@ -588,7 +593,10 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
>  	regs.bp = pebs->bp;
>  	regs.sp = pebs->sp;
>  
> -	if (event->attr.precise_ip > 1 && intel_pmu_pebs_fixup_ip(&regs))
> +	if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format >= 2) {
> +		regs.ip = ((struct pebs_record_v2 *)pebs)->eventingrip;
> +		regs.flags |= PERF_EFLAGS_EXACT;

Here you messed up the record types in this function with the 
introduction of the new pebs record format quite a bit.

First we have 'pebs' as type 'struct pebs_record_core *', but 
here it's cast over to 'struct pebs_record_v2 *' just to access 
a field that is not really in the pebs_record_core format...

If we continue down that road then code quickly becomes an 
unmaintainable mess. I'm sure you can think of a better,
cleaner solution than mixing types and forcing casts like
that.

> +	} else if (event->attr.precise_ip > 1 && intel_pmu_pebs_fixup_ip(&regs))
>  		regs.flags |= PERF_EFLAGS_EXACT;
>  	else
>  		regs.flags &= ~PERF_EFLAGS_EXACT;
> @@ -641,35 +649,21 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
>  	__intel_pmu_pebs_event(event, iregs, at);
>  }
>  
> -static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
> +static void intel_pmu_drain_pebs_common(struct pt_regs *iregs, void *at,
> +					void *top)
>  {
>  	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>  	struct debug_store *ds = cpuc->ds;
> -	struct pebs_record_nhm *at, *top;
>  	struct perf_event *event = NULL;
>  	u64 status = 0;
> -	int bit, n;
> -
> -	if (!x86_pmu.pebs_active)
> -		return;
> -
> -	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
> -	top = (struct pebs_record_nhm *)(unsigned long)ds->pebs_index;
> +	int bit;
>  
>  	ds->pebs_index = ds->pebs_buffer_base;
>  
> -	n = top - at;
> -	if (n <= 0)
> -		return;
> +	for ( ; at < top; at += x86_pmu.pebs_record_size) {
> +		struct pebs_record_nhm *p = at;

This function shows record type confusion as well: the function 
got renamed from intel_pmu_drain_pebs_nhm() to 
intel_pmu_drain_pebs_common(), but then it deals with 
pebs_record_nhm - which is obviously not 'common'.

> +		case 2:
> +			printk(KERN_CONT "PEBS fmt2%c, ", pebs_type);
> +			x86_pmu.pebs_record_size = sizeof(struct pebs_record_v2);
> +			x86_pmu.drain_pebs = intel_pmu_drain_pebs_v2;
> +			break;
> +

That's inconsistent too - the data types and the code talks 
about 'PEBS v2' but here it's printed out to the kernel log as 
'PEBS fmt2'. Death by a thousand cuts of sloppiness and all 
that.

Thanks,

	Ingo
