Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760333Ab3JPItg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:49:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48912 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760268Ab3JPItc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:49:32 -0400
Date: Wed, 16 Oct 2013 10:49:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20131016084920.GT10651@twins.programming.kicks-ass.net>
References: <20131015174722.615394057@linux.com>
 <20131015174747.813545438@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015174747.813545438@linux.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 12:47:28PM -0500, Christoph Lameter wrote:
> V3->V4:
> 	- Drop CONFIG_DEBUG_THIS_CPU_OPERATIONS
> 	- Add support for logging the exact operation that caused the issue.
> 
> We define a check function in order to avoid trouble with the
> include files. Then the higher level __this_cpu macros are
> modified to invoke the check before __this_cpu operation
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/include/linux/percpu.h
> ===================================================================
> --- linux.orig/include/linux/percpu.h	2013-10-10 11:30:17.111743444 -0500
> +++ linux/include/linux/percpu.h	2013-10-10 10:30:26.817316787 -0500
> @@ -175,6 +175,12 @@ extern phys_addr_t per_cpu_ptr_to_phys(v
>  
>  extern void __bad_size_call_parameter(void);
>  
> +#ifdef CONFIG_DEBUG_PREEMPT
> +extern void __this_cpu_preempt_check(const char *op);
> +#else
> +static inline void __this_cpu_preempt_check(const char *op) { }
> +#endif
> +
>  #define __pcpu_size_call_return(stem, variable)				\
>  ({	typeof(variable) pscr_ret__;					\
>  	__verify_pcpu_ptr(&(variable));					\
> @@ -538,7 +544,8 @@ do {									\
>  # ifndef __this_cpu_read_8
>  #  define __this_cpu_read_8(pcp)	(*__this_cpu_ptr(&(pcp)))
>  # endif
> -# define __this_cpu_read(pcp)	__pcpu_size_call_return(__this_cpu_read_, (pcp))
> +# define __this_cpu_read(pcp) \
> +	(__this_cpu_preempt_check("read"),__pcpu_size_call_return(__this_cpu_read_, (pcp)))
>  #endif
>  

So I didn't understand what was wrong with:

#define __this_cpu_read(pcp) \
	(__this_cpu_preempt_check("read"), raw_this_cpu_read(pcp))

And idem for all others. This is 1) shorter to write; and 2) makes it
blindingly obvious that the implementations are actually the same.

> Index: linux/lib/smp_processor_id.c
> ===================================================================
> --- linux.orig/lib/smp_processor_id.c	2013-10-10 11:30:17.111743444 -0500
> +++ linux/lib/smp_processor_id.c	2013-10-10 10:32:16.046357108 -0500
> @@ -7,7 +7,7 @@
>  #include <linux/kallsyms.h>
>  #include <linux/sched.h>
>  
> -notrace unsigned int debug_smp_processor_id(void)
> +notrace static unsigned int check_preemption_disabled(char *what)
>  {
>  	unsigned long preempt_count = preempt_count();
>  	int this_cpu = raw_smp_processor_id();
> @@ -39,9 +39,9 @@ notrace unsigned int debug_smp_processor
>  	if (!printk_ratelimit())
>  		goto out_enable;
>  
> -	printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] "
> -			"code: %s/%d\n",
> -			preempt_count() - 1, current->comm, current->pid);
> +	printk(KERN_ERR "%s in preemptible [%08x] code: %s/%d\n",
> +		what, preempt_count() - 1, current->comm, current->pid);
> +

Like already said; NAK until that "BUG" remains.
