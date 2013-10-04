Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab3JDI1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 04:27:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40589 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3JDI1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 04:27:40 -0400
Date: Fri, 4 Oct 2013 10:27:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [pchecks v2 2/2] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20131004082728.GG3081@twins.programming.kicks-ass.net>
References: <20131003182902.174251532@linux.com>
 <000001417f93fb74-f307f391-26a4-431a-8295-04c5319d1373-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001417f93fb74-f307f391-26a4-431a-8295-04c5319d1373-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 06:28:26PM +0000, Christoph Lameter wrote:
> @@ -538,7 +544,8 @@ do {									\
>  # ifndef __this_cpu_read_8
>  #  define __this_cpu_read_8(pcp)	(*__this_cpu_ptr(&(pcp)))
>  # endif
> -# define __this_cpu_read(pcp)	__pcpu_size_call_return(__this_cpu_read_, (pcp))
> +# define __this_cpu_read(pcp) \
> +	(__this_cpu_preempt_check(),__pcpu_size_call_return(__this_cpu_read_, (pcp)))
>  #endif

Would it not be move convenient to implement it in terms of the
raw_this_cpu*() thingies? That way you're sure they actually do the same
thing and there's only 1 site to change when changing the
implementation.

Something like:

#define __this_cpu_read(pcp) 						\
({									\
	__this_cpu_preempt_check();					\
	raw_this_cpu_read(pcp);						\
})



> @@ -39,8 +39,8 @@ notrace unsigned int debug_smp_processor
>  	if (!printk_ratelimit())
>  		goto out_enable;
>  
> -	printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] "
> -			"code: %s/%d\n",
> +	printk(KERN_ERR "%s in preemptible [%08x] "
> +			"code: %s/%d\n", what,
>  			preempt_count() - 1, current->comm, current->pid);

I would argue for keeping the "BUG" string intact and in front of the
%s.

>  	print_symbol("caller is %s\n", (long)__builtin_return_address(0));
>  	dump_stack();
> @@ -51,5 +51,17 @@ out:
>  	return this_cpu;
>  }
>  
> +notrace unsigned int debug_smp_processor_id(void)
> +{
> +	return check_preemption_disabled("BUG: using smp_processor_id()");
> +}
>  EXPORT_SYMBOL(debug_smp_processor_id);
>  
> +notrace void __this_cpu_preempt_check(void)
> +{
> +#ifdef CONFIG_DEBUG_THIS_CPU_OPERATIONS
> +	check_preemption_disabled("__this_cpu operation");
> +#endif

Because here you've forgotten it..

> +}
> +EXPORT_SYMBOL(__this_cpu_preempt_check);
