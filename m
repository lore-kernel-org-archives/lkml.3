Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925Ab3JONCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:02:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55533 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527Ab3JONCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:02:37 -0400
Date: Tue, 15 Oct 2013 15:02:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: dave.hansen@linux.intel.com, eranian@google.com, ak@linux.intel.com,
        jmario@redhat.com, linux-kernel@vger.kernel.org, acme@infradead.org
Subject: Re: x86, perf: throttling issues with long nmi latencies
Message-ID: <20131015130226.GX26785@twins.programming.kicks-ass.net>
References: <20131014203549.GY227855@redhat.com>
 <20131015101404.GD10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015101404.GD10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 12:14:04PM +0200, Peter Zijlstra wrote:
>  arch/x86/kernel/cpu/perf_event_intel_ds.c | 43 ++++++++++++++++++++++---------
>  1 file changed, 31 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index 32e9ed81cd00..3978e72a1c9f 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -722,6 +722,8 @@ void intel_pmu_pebs_disable_all(void)
>  		wrmsrl(MSR_IA32_PEBS_ENABLE, 0);
>  }
>  
> +static DEFINE_PER_CPU(u8 [PAGE_SIZE], insn_page);
> +
>  static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
>  {
>  	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> @@ -729,6 +731,8 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
>  	unsigned long old_to, to = cpuc->lbr_entries[0].to;
>  	unsigned long ip = regs->ip;
>  	int is_64bit = 0;
> +	int size, bytes;
> +	void *kaddr;
>  
>  	/*
>  	 * We don't need to fixup if the PEBS assist is fault like
> @@ -763,29 +767,44 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
>  		return 1;
>  	}
>  
> +refill:
> +	if (kernel_ip(ip)) {
> +		u8 *buf = &__get_cpu_var(insn_page[0]);
> +		size = PAGE_SIZE - ((unsigned long)to & (PAGE_SIZE-1));
> +		if (size < MAX_INSN_SIZE) {
> +			/*
> +			 * If we're going to have to touch two pages; just copy
> +			 * as much as we can hold.
> +			 */
> +			size = PAGE_SIZE;


Arguably we'd want that to be:

			size = min(PAGE_SIZE, ip - to);

As there's no point in copying beyond the basic block.

> +		}
> +		bytes = copy_from_user_nmi(buf, (void __user *)to, size);
> +		if (bytes != size)
> +			return 0;
> +
> +		kaddr = buf;
