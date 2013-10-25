Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab3JYQdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 12:33:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab3JYQdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 12:33:49 -0400
Date: Fri, 25 Oct 2013 12:33:03 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, dave.hansen@linux.intel.com,
        Stephane Eranian <eranian@google.com>, jmario@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
Message-ID: <20131025163303.GD108330@redhat.com>
References: <20131017160034.GO227855@redhat.com>
 <20131017160439.GP227855@redhat.com>
 <20131017163039.GR10651@twins.programming.kicks-ass.net>
 <CA+55aFx-1Xu2aSvAMi8SSUwq-J9Yo3oJGY8yUYWyAZmZmr8prQ@mail.gmail.com>
 <20131017220156.GB10651@twins.programming.kicks-ass.net>
 <CA+55aFyCCdwF78dM1=Km=0wqtoyosp-ChyoJuBb1DdBvmGe2vA@mail.gmail.com>
 <20131022211237.GH2490@laptop.programming.kicks-ass.net>
 <CA+55aFwfsyofuZtNyUGKPWdvqc=4gOW=HTFPxsiM-3GS1G8KKQ@mail.gmail.com>
 <20131023204838.GB19466@laptop.lan>
 <20131024105206.GM2490@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131024105206.GM2490@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 12:52:06PM +0200, Peter Zijlstra wrote:
> On Wed, Oct 23, 2013 at 10:48:38PM +0200, Peter Zijlstra wrote:
> > I'll also make sure to test we actually hit the fault path
> > by concurrently running something like:
> > 
> >  while :; echo 1 > /proc/sys/vm/drop_caches ; done
> > 
> > while doing perf top or so.. 
> 
> So the below appears to work; I've ran:
> 
>   while :; do echo 1 > /proc/sys/vm/drop_caches; sleep 1; done &
>   while :; do make O=defconfig-build/ clean; perf record -a -g fp -e cycles:pp make O=defconfig-build/ -s -j64; done
> 
> And verified that the if (in_nmi()) trace_printk() was visible in the
> trace output verifying we indeed took the fault from the NMI code.
> 
> I've had this running for ~ 30 minutes or so and the machine is still
> healthy.
> 
> Don, can you give this stuff a spin on your system?

Hi Peter,

I finally had a chance to run this on my machine.  From my testing, it
looks good.  Better performance numbers.  I think my longest latency went
from 300K cycles down to 150K cycles and very few of those (most are under
100K cycles).

I also don't see perf throttling me down to 1500 samples, it stops around
7000.  So I see progress with this patch. :-)

Thanks!

Cheers,
Don

> 
> ---
>  arch/x86/lib/usercopy.c | 43 +++++++++++++++----------------------------
>  arch/x86/mm/fault.c     | 43 +++++++++++++++++++++++--------------------
>  2 files changed, 38 insertions(+), 48 deletions(-)
> 
> diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
> index 4f74d94c8d97..5465b8613944 100644
> --- a/arch/x86/lib/usercopy.c
> +++ b/arch/x86/lib/usercopy.c
> @@ -11,39 +11,26 @@
>  #include <linux/sched.h>
>  
>  /*
> - * best effort, GUP based copy_from_user() that is NMI-safe
> + * We rely on the nested NMI work to allow atomic faults from the NMI path; the
> + * nested NMI paths are careful to preserve CR2.
>   */
>  unsigned long
>  copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
>  {
> -	unsigned long offset, addr = (unsigned long)from;
> -	unsigned long size, len = 0;
> -	struct page *page;
> -	void *map;
> -	int ret;
> +	unsigned long ret;
>  
>  	if (__range_not_ok(from, n, TASK_SIZE))
> -		return len;
> -
> -	do {
> -		ret = __get_user_pages_fast(addr, 1, 0, &page);
> -		if (!ret)
> -			break;
> -
> -		offset = addr & (PAGE_SIZE - 1);
> -		size = min(PAGE_SIZE - offset, n - len);
> -
> -		map = kmap_atomic(page);
> -		memcpy(to, map+offset, size);
> -		kunmap_atomic(map);
> -		put_page(page);
> -
> -		len  += size;
> -		to   += size;
> -		addr += size;
> -
> -	} while (len < n);
> -
> -	return len;
> +		return 0;
> +
> +	/*
> +	 * Even though this function is typically called from NMI/IRQ context
> +	 * disable pagefaults so that its behaviour is consistent even when
> +	 * called form other contexts.
> +	 */
> +	pagefault_disable();
> +	ret = __copy_from_user_inatomic(to, from, n);
> +	pagefault_enable();
> +
> +	return n - ret;
>  }
>  EXPORT_SYMBOL_GPL(copy_from_user_nmi);
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 3aaeffcfd67a..506564b13ba7 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -51,7 +51,7 @@ kmmio_fault(struct pt_regs *regs, unsigned long addr)
>  	return 0;
>  }
>  
> -static inline int __kprobes notify_page_fault(struct pt_regs *regs)
> +static inline int __kprobes kprobes_fault(struct pt_regs *regs)
>  {
>  	int ret = 0;
>  
> @@ -1048,7 +1048,7 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  			return;
>  
>  		/* kprobes don't want to hook the spurious faults: */
> -		if (notify_page_fault(regs))
> +		if (kprobes_fault(regs))
>  			return;
>  		/*
>  		 * Don't take the mm semaphore here. If we fixup a prefetch
> @@ -1060,23 +1060,8 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  	}
>  
>  	/* kprobes don't want to hook the spurious faults: */
> -	if (unlikely(notify_page_fault(regs)))
> +	if (unlikely(kprobes_fault(regs)))
>  		return;
> -	/*
> -	 * It's safe to allow irq's after cr2 has been saved and the
> -	 * vmalloc fault has been handled.
> -	 *
> -	 * User-mode registers count as a user access even for any
> -	 * potential system fault or CPU buglet:
> -	 */
> -	if (user_mode_vm(regs)) {
> -		local_irq_enable();
> -		error_code |= PF_USER;
> -		flags |= FAULT_FLAG_USER;
> -	} else {
> -		if (regs->flags & X86_EFLAGS_IF)
> -			local_irq_enable();
> -	}
>  
>  	if (unlikely(error_code & PF_RSVD))
>  		pgtable_bad(regs, error_code, address);
> @@ -1088,17 +1073,35 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  		}
>  	}
>  
> -	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
> -
>  	/*
>  	 * If we're in an interrupt, have no user context or are running
>  	 * in an atomic region then we must not take the fault:
>  	 */
>  	if (unlikely(in_atomic() || !mm)) {
> +		if (in_nmi())
> +			trace_printk("YIPEE!!!\n");
>  		bad_area_nosemaphore(regs, error_code, address);
>  		return;
>  	}
>  
> +	/*
> +	 * It's safe to allow irq's after cr2 has been saved and the
> +	 * vmalloc fault has been handled.
> +	 *
> +	 * User-mode registers count as a user access even for any
> +	 * potential system fault or CPU buglet:
> +	 */
> +	if (user_mode_vm(regs)) {
> +		local_irq_enable();
> +		error_code |= PF_USER;
> +		flags |= FAULT_FLAG_USER;
> +	} else {
> +		if (regs->flags & X86_EFLAGS_IF)
> +			local_irq_enable();
> +	}
> +
> +	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
> +
>  	if (error_code & PF_WRITE)
>  		flags |= FAULT_FLAG_WRITE;
>  
