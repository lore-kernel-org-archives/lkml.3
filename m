Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930Ab3IXID6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:03:58 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:37051 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3IXIDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:03:51 -0400
Date: Tue, 24 Sep 2013 10:03:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [pchecks v1 4/4] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20130924080347.GH28538@gmail.com>
References: <20130923191256.584672290@linux.com>
 <000001414c47a1da-a60858ec-6fe0-4560-a859-8274151411bf-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001414c47a1da-a60858ec-6fe0-4560-a859-8274151411bf-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> --- linux.orig/kernel/sched/core.c	2013-09-23 10:24:47.371629684 -0500
> +++ linux/kernel/sched/core.c	2013-09-23 10:24:47.371629684 -0500
> @@ -2566,6 +2566,29 @@ asmlinkage void __sched preempt_schedule
>  	exception_exit(prev_state);
>  }
>  
> +#ifdef CONFIG_DEBUG_PREEMPT
> +/*
> + * This function is called if the kernel is compiled with preempt
> + * support for each __this_cpu operations. It verifies that
> + * preemption has been disabled.
> + *
> + * The function cannot be a macro due to the low level nature
> + * of the per cpu header files.
> + */
> +void __this_cpu_preempt_check(void)
> +{
> +	int p;
> +
> +	p = preemptible();
> +	if (p) {
> +		printk(KERN_ERR "__this_cpu but preemptable."
> +			" preempt_count=%d irqs_disabled=%d\n",
> +			preempt_count(), irqs_disabled());
> +		dump_stack();
> +	}
> +
> +}
> +#endif /* CONFIG_DEBUG_PREEMPT */

During past review of your series Peter Zijlstra very explicitly told you 
to reuse (and unify with) the preempt checks in lib/smp_processor_id.c! 
See debug_smp_processor_id().

The problem isn't just that you are duplicating code and adding 
unnecessary #ifdefs into the wrong place, the bigger problem is that you 
are implementing weak checks which creates unnecessary raw_*() pollution 
all across the kernel.

Your lack of cooperation is getting ridiculous!

My NAK still stands, obviously.

Thanks,

	Ingo
