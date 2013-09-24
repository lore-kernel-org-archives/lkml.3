Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab3IXRKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 13:10:36 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:39252 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab3IXRKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 13:10:33 -0400
Date: Tue, 24 Sep 2013 19:10:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        linux-arch@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [pchecks v2 2/2] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20130924171029.GB10261@gmail.com>
References: <20130924154159.855373283@linux.com>
 <0000014150a21408-2d759c49-6a9e-4553-956f-2d4b53e710f8-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000014150a21408-2d759c49-6a9e-4553-956f-2d4b53e710f8-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> Index: linux/lib/smp_processor_id.c
> ===================================================================
> --- linux.orig/lib/smp_processor_id.c	2013-09-24 10:06:26.000000000 -0500
> +++ linux/lib/smp_processor_id.c	2013-09-24 10:14:19.412825970 -0500
> @@ -7,7 +7,7 @@
>  #include <linux/kallsyms.h>
>  #include <linux/sched.h>
>  
> -notrace unsigned int debug_smp_processor_id(void)
> +notrace static unsigned int check_preemption(char *what)
>  {
>  	unsigned long preempt_count = preempt_count();
>  	int this_cpu = raw_smp_processor_id();
> @@ -39,8 +39,8 @@ notrace unsigned int debug_smp_processor
>  	if (!printk_ratelimit())
>  		goto out_enable;
>  
> -	printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] "
> -			"code: %s/%d\n",
> +	printk(KERN_ERR "BUG: using %s in preemptible [%08x] "
> +			"code: %s/%d\n", what,
>  			preempt_count() - 1, current->comm, current->pid);
>  	print_symbol("caller is %s\n", (long)__builtin_return_address(0));
>  	dump_stack();
> @@ -51,5 +51,18 @@ out:
>  	return this_cpu;
>  }
>  
> +notrace unsigned int debug_smp_processor_id(void)
> +{
> +	return check_preemption("smp_processor_id()");
> +
> +}
>  EXPORT_SYMBOL(debug_smp_processor_id);
>  
> +notrace void __this_cpu_preempt_check(void)
> +{
> +#ifdef CONFIG_THIS_CPU_PREEMPTION_CHECK
> +	check_preemption("__this_cpu operation");
> +#endif
> +}
> +EXPORT_SYMBOL(__this_cpu_preempt_check);

Ok, this variant looks pretty good, modulo testing. I'd do:

  s/check_preemption/check_preemption_disabled

but that's a minor detail.

> +config DEBUG_THIS_CPU_OPERATIONS
> +	bool "Debug __this_cpu operations"
> +	depends on DEBUG_PREEMPT
> +	default n
> +	help
> +	  Enables preemption checks for __this_cpu macros. These
> +	  are macros to generate single instruction operations on
> +	  per cpu data. The option only affects the __this_cpu variant
> +	  which is used when fallback to multiple instructions without
> +	  other synchronization is possible. A verification is then
> +	  done to make sure that the thread cannot be preempted.

I don't think there's a need to make this a separate preemption debug 
option: smp_processor_id() is really just a subset of the checks.

So please just put it under CONFIG_DEBUG_PREEMPT, there's no need to add 
yet another x2 to the kernel Kconfig space. Maybe extend the DEBUG_PREEMPT 
help text to explain that it also checks __this_cpu ops.

That will remove the #ifdef from lib/smp_processor_id.c and will simplify 
debugging a bit as well.

Thanks,

	Ingo
