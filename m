Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934303Ab3JPMrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:47:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406Ab3JPMrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:47:15 -0400
Date: Wed, 16 Oct 2013 08:46:49 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: dave.hansen@linux.intel.com, eranian@google.com, ak@linux.intel.com,
        jmario@redhat.com, linux-kernel@vger.kernel.org, acme@infradead.org,
        mingo@kernel.org
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
Message-ID: <20131016124649.GG227855@redhat.com>
References: <20131014203549.GY227855@redhat.com>
 <20131015101404.GD10651@twins.programming.kicks-ass.net>
 <20131015130226.GX26785@twins.programming.kicks-ass.net>
 <20131015143227.GY26785@twins.programming.kicks-ass.net>
 <20131015150736.GZ26785@twins.programming.kicks-ass.net>
 <20131015154104.GA227855@redhat.com>
 <20131016105755.GX10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016105755.GX10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 12:57:55PM +0200, Peter Zijlstra wrote:
> A prettier patch below. The main difference is on-demand allocation of
> the scratch buffer.

I'll see if I can sanity test this in the next couple hours.

Further testing yesterday showed that intel_pmu_drain_pebs_nhm still
has long latencies somewhere.  With 15 minute reboots, isolation goes
slooow.

Thanks!

Cheers,
Don

> 
> ---
> Subject: perf, x86: Optimize intel_pmu_pebs_fixup_ip()
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Tue, 15 Oct 2013 12:14:04 +0200
> 
> On Mon, Oct 14, 2013 at 04:35:49PM -0400, Don Zickus wrote:
> > While there are a few places that are causing latencies, for now I focused on
> > the longest one first.  It seems to be 'copy_user_from_nmi'
> >
> > intel_pmu_handle_irq ->
> > 	intel_pmu_drain_pebs_nhm ->
> > 		__intel_pmu_drain_pebs_nhm ->
> > 			__intel_pmu_pebs_event ->
> > 				intel_pmu_pebs_fixup_ip ->
> > 					copy_from_user_nmi
> >
> > In intel_pmu_pebs_fixup_ip(), if the while-loop goes over 50, the sum of
> > all the copy_from_user_nmi latencies seems to go over 1,000,000 cycles
> > (there are some cases where only 10 iterations are needed to go that high
> > too, but in generall over 50 or so).  At this point copy_user_from_nmi
> > seems to account for over 90% of the nmi latency.
> 
> So avoid having to call copy_from_user_nmi() for every instruction.
> Since we already limit the max basic block size, we can easily
> pre-allocate a piece of memory to copy the entire thing into in one
> go.
> 
> Don reports (for a previous version):
> > Your patch made a huge difference in improvement.  The
> > copy_from_user_nmi() no longer hits the million of cycles.  I still
> > have a batch of 100,000-300,000 cycles.  My longest NMI paths used
> > to be dominated by copy_from_user_nmi, now it is not (I have to dig
> > up the new hot path).
> 
> Cc: eranian@google.com
> Cc: ak@linux.intel.com
> Cc: jmario@redhat.com
> Cc: acme@infradead.org
> Cc: dave.hansen@linux.intel.com
> Reported-by: Don Zickus <dzickus@redhat.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_ds.c |   48 +++++++++++++++++++++---------
>  1 file changed, 34 insertions(+), 14 deletions(-)
> 
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -12,6 +12,7 @@
>  
>  #define BTS_BUFFER_SIZE		(PAGE_SIZE << 4)
>  #define PEBS_BUFFER_SIZE	PAGE_SIZE
> +#define PEBS_FIXUP_SIZE		PAGE_SIZE
>  
>  /*
>   * pebs_record_32 for p4 and core not supported
> @@ -228,12 +229,14 @@ void fini_debug_store_on_cpu(int cpu)
>  	wrmsr_on_cpu(cpu, MSR_IA32_DS_AREA, 0, 0);
>  }
>  
> +static DEFINE_PER_CPU(void *, insn_buffer);
> +
>  static int alloc_pebs_buffer(int cpu)
>  {
>  	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
>  	int node = cpu_to_node(cpu);
>  	int max, thresh = 1; /* always use a single PEBS record */
> -	void *buffer;
> +	void *buffer, *ibuffer;
>  
>  	if (!x86_pmu.pebs)
>  		return 0;
> @@ -242,6 +245,15 @@ static int alloc_pebs_buffer(int cpu)
>  	if (unlikely(!buffer))
>  		return -ENOMEM;
>  
> +	if (x86_pmu.intel_cap.pebs_format < 2) {
> +		ibuffer = kzalloc_node(PEBS_FIXUP_SIZE, GFP_KERNEL, node);
> +		if (!ibuffer) {
> +			kfree(buffer);
> +			return -ENOMEM;
> +		}
> +		per_cpu(insn_buffer, cpu) = ibuffer;
> +	}
> +
>  	max = PEBS_BUFFER_SIZE / x86_pmu.pebs_record_size;
>  
>  	ds->pebs_buffer_base = (u64)(unsigned long)buffer;
> @@ -262,6 +274,9 @@ static void release_pebs_buffer(int cpu)
>  	if (!ds || !x86_pmu.pebs)
>  		return;
>  
> +	kfree(per_cpu(insn_buffer, cpu));
> +	per_cpu(insn_buffer, cpu) = NULL;
> +
>  	kfree((void *)(unsigned long)ds->pebs_buffer_base);
>  	ds->pebs_buffer_base = 0;
>  }
> @@ -729,6 +744,7 @@ static int intel_pmu_pebs_fixup_ip(struc
>  	unsigned long old_to, to = cpuc->lbr_entries[0].to;
>  	unsigned long ip = regs->ip;
>  	int is_64bit = 0;
> +	void *kaddr;
>  
>  	/*
>  	 * We don't need to fixup if the PEBS assist is fault like
> @@ -752,7 +768,7 @@ static int intel_pmu_pebs_fixup_ip(struc
>  	 * unsigned math, either ip is before the start (impossible) or
>  	 * the basic block is larger than 1 page (sanity)
>  	 */
> -	if ((ip - to) > PAGE_SIZE)
> +	if ((ip - to) > PEBS_FIXUP_SIZE)
>  		return 0;
>  
>  	/*
> @@ -763,29 +779,33 @@ static int intel_pmu_pebs_fixup_ip(struc
>  		return 1;
>  	}
>  
> +	if (!kernel_ip(ip)) {
> +		int size, bytes;
> +		u8 *buf = this_cpu_ptr(insn_buffer);
> +
> +		size = ip - to; /* Must fit our buffer, see above */
> +		bytes = copy_from_user_nmi(buf, (void __user *)to, size);
> +		if (bytes != size)
> +			return 0;
> +
> +		kaddr = buf;
> +	} else {
> +		kaddr = (void *)to;
> +	}
> +
>  	do {
>  		struct insn insn;
> -		u8 buf[MAX_INSN_SIZE];
> -		void *kaddr;
>  
>  		old_to = to;
> -		if (!kernel_ip(ip)) {
> -			int bytes, size = MAX_INSN_SIZE;
> -
> -			bytes = copy_from_user_nmi(buf, (void __user *)to, size);
> -			if (bytes != size)
> -				return 0;
> -
> -			kaddr = buf;
> -		} else
> -			kaddr = (void *)to;
>  
>  #ifdef CONFIG_X86_64
>  		is_64bit = kernel_ip(to) || !test_thread_flag(TIF_IA32);
>  #endif
>  		insn_init(&insn, kaddr, is_64bit);
>  		insn_get_length(&insn);
> +
>  		to += insn.length;
> +		kaddr += insn.length;
>  	} while (to < ip);
>  
>  	if (to == ip) {
