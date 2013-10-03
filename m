Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab3JCQ1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:27:35 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:42812 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab3JCQ1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:27:34 -0400
Date: Thu, 3 Oct 2013 09:27:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20131003162728.GC5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131002145655.361606532@infradead.org>
 <20131002150518.600557855@infradead.org>
 <20131003140150.GL28601@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003140150.GL28601@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100316-0928-0000-0000-0000021E3DC3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 04:01:50PM +0200, Peter Zijlstra wrote:
> On Wed, Oct 02, 2013 at 04:56:56PM +0200, Peter Zijlstra wrote:
> > +	if (atomic_dec_and_test(&cpuhp_waitcount))
> > +		wake_up(&cpuhp_writer);
> > +
> > +	goto again:
> >  }
> 
> > +
> > +#define per_cpu_sum(var)						\
> > +({ 									\
> > + 	typeof(var) __sum = 0;						\
> > + 	int cpu;							\
> > + 	for_each_possible_cpu(cpu)					\
> > + 		__sum += per_cpu(var, cpu);				\
> > + 	__sum;								\
> > +)}
> >  
> 
> I just noticed I forgot a refresh..

And including these changes as well.  ;-)

							Thanx, Paul

> +++ b/kernel/cpu.c
> @@ -120,7 +120,7 @@ void __get_online_cpus(void)
>         if (atomic_dec_and_test(&cpuhp_waitcount))
>                 wake_up(&cpuhp_writer);
> 
> -       goto again:
> +       goto again;
>  }
>  EXPORT_SYMBOL_GPL(__get_online_cpus);
> 
> @@ -146,7 +146,7 @@ EXPORT_SYMBOL_GPL(__put_online_cpus);
>         for_each_possible_cpu(cpu)                                      \
>                 __sum += per_cpu(var, cpu);                             \
>         __sum;                                                          \
> -)}
> +})
> 
>  /*
>   * See srcu_readers_active_idx_check() for a rather more detailed explanation.
> 

