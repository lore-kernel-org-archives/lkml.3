Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbaJDUAv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 16:00:51 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53537 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaJDUAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 16:00:50 -0400
Date: Sat, 4 Oct 2014 22:00:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Cc: linux-mips@linux-mips.org, Zubair.Kakakhel@imgtec.com,
        david.daney@cavium.com, paul.gortmaker@windriver.com, davidlohr@hp.com,
        macro@linux-mips.org, chenhc@lemote.com, zajec5@gmail.com,
        james.hogan@imgtec.com, keescook@chromium.org, alex@alex-smith.me.uk,
        tglx@linutronix.de, blogic@openwrt.org, jchandra@broadcom.com,
        paul.burton@imgtec.com, qais.yousef@imgtec.com,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        markos.chandras@imgtec.com, manuel.lauss@gmail.com,
        akpm@linux-foundation.org, lars.persson@axis.com
Subject: Re: [PATCH 2/3] MIPS: Setup an instruction emulation in VDSO
 protected page instead of user stack
Message-ID: <20141004200016.GB7509@worktop.ger.corp.intel.com>
References: <20141004030438.28569.85536.stgit@linux-yegoshin>
 <20141004031730.28569.38511.stgit@linux-yegoshin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141004031730.28569.38511.stgit@linux-yegoshin>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 08:17:30PM -0700, Leonid Yegoshin wrote:

> --- a/arch/mips/include/asm/switch_to.h
> +++ b/arch/mips/include/asm/switch_to.h
> @@ -17,6 +17,7 @@
>  #include <asm/dsp.h>
>  #include <asm/cop2.h>
>  #include <asm/msa.h>
> +#include <asm/mmu_context.h>
>  
>  struct task_struct;
>  
> @@ -104,6 +105,16 @@ do {									\
>  	disable_msa();							\
>  } while (0)
>  
> +static inline void flush_vdso_page(void)
> +{
> +	if (current->mm && cpu_context(raw_smp_processor_id(), current->mm) &&
> +	    (current->mm->context.vdso_asid[raw_smp_processor_id()] ==
> +	     cpu_asid(raw_smp_processor_id(), current->mm))) {
> +		local_flush_tlb_page(current->mm->mmap, (unsigned long)current->mm->context.vdso);
> +		current->mm->context.vdso_asid[raw_smp_processor_id()] = 0;
> +	}
> +}

Why raw_smp_processor_id() and why evaluate it 3 times, sure compilers
can be expected to do some CSE but something like:

	int cpu = smp_processor_id();

	if ( ... [cpu] ...)

is far more readable as well.

> +
>  #define finish_arch_switch(prev)					\
>  do {									\
>  	u32 __c0_stat;							\
> @@ -118,6 +129,7 @@ do {									\
>  		__restore_dsp(current);					\
>  	if (cpu_has_userlocal)						\
>  		write_c0_userlocal(current_thread_info()->tp_value);	\
> +	flush_vdso_page();                                              \
>  	__restore_watch();						\
>  } while (0)

So what I didn't see is any talk about the cost of this. Surely a TLB
flush isn't exactly free.
