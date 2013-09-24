Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab3IXPSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:18:52 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:54446 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab3IXPSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:18:51 -0400
Date: Tue, 24 Sep 2013 17:18:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [pchecks v1 4/4] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20130924151847.GB8494@gmail.com>
References: <20130923191256.584672290@linux.com>
 <000001414c47a1da-a60858ec-6fe0-4560-a859-8274151411bf-000000@email.amazonses.com>
 <20130924080347.GH28538@gmail.com>
 <00000141505b72a3-6935722e-fdfb-4c46-b52c-bc40609144ac-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000141505b72a3-6935722e-fdfb-4c46-b52c-bc40609144ac-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Tue, 24 Sep 2013, Ingo Molnar wrote:
> 
> > During past review of your series Peter Zijlstra very explicitly told you
> > to reuse (and unify with) the preempt checks in lib/smp_processor_id.c!
> > See debug_smp_processor_id().
> 
> No he did not. He mentioned something about debug_smp_processor_id() at 
> the end of a post after talking about something else. Given your 
> comments now I see what was meant. That was not really obvious in the 
> first place.

Holy cow, this is what PeterZ wrote to you a week ago:

     > +#ifdef CONFIG_PREEMPT
     > +extern void this_cpu_preempt_check(void);
     > +#else
     > +static inline void this_cpu_preempt_check(void) { }
     > +#endif

     How about re-using debug_smp_processor_id() instead?

          http://lkml.org/lkml/2013/9/16/137

Firstly, that sentence is as damn obvious as it gets.

Secondly, even if it wasn't obvious to you, a 'git grep 
debug_smp_processor_id' would have told you the story.

Thirdly, if it wasn't obvious to you, and if you didn't think of using git 
grep, how about ... asking? If a reviewer gives you review feedback then 
you should address _EVERY_ single review feedback and not just ignore 
it...

I get the impression that you are trying to deny your excessive sloppiness 
in this thread - there's no other way to put it really.

> > The problem isn't just that you are duplicating code and adding 
> > unnecessary #ifdefs into the wrong place, the bigger problem is that 
> > you are implementing weak checks which creates unnecessary raw_*() 
> > pollution all across the kernel.
> 
> what kind of idiotic comment is that? I am using a single function 
> preemptible(). How is that duplicating anything?

as PeterZ pointed it out, we have well-working preempt checks in 
debug_smp_processor_id() / lib/smp_processor_id.c.

Instead of reusing that you created a new preempt check, plopped your new, 
25 lines, duplicated check into an ugly #ifdef section into sched/core.c - 
see that gem attached further below.

> > Your lack of cooperation is getting ridiculous!
> 
> And this kind of insulting behavior is really discouraging people to do 
> work on the kernel.

Pointing out your repeated lack of cooperation in this matter is a 
statement of facts, not an 'insulting behavior'. Your wasting of other 
people's time is simply not acceptable.

That I called you out on it might be embarrassing to you but there's a 
really easy solution to that: implement reviewer and maintainer requests 
and don't send sloppy patches repeatedly.

	Ingo 

> Index: linux/kernel/sched/core.c
> ===================================================================
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
>  #endif /* CONFIG_PREEMPT */
>  
