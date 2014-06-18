Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbaFRUgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:36:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993AbaFRUgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:36:14 -0400
Date: Wed, 18 Jun 2014 22:36:10 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH 00/11] printk: safe printing in NMI context
In-Reply-To: <20140618162117.GM4669@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1406182232390.2303@pobox.suse.cz>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz> <alpine.LNX.2.00.1405290000350.17241@pobox.suse.cz> <20140529000909.GC6507@localhost.localdomain> <alpine.LNX.2.00.1405290959270.17241@pobox.suse.cz> <20140610164641.GD1951@localhost.localdomain>
 <CA+55aFzseOqF-EpKMvwKpfhBJZQSLqKpJ3shzVee9s0+mvyCuA@mail.gmail.com> <alpine.LNX.2.00.1406181245230.2303@pobox.suse.cz> <20140618143612.GC4669@linux.vnet.ibm.com> <CA+55aFwPgDC6gSEPfu3i-pA4f0ZbsTSvykxzX4sXMeLbdXuKrw@mail.gmail.com>
 <20140618162117.GM4669@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Paul E. McKenney wrote:

> OK, unconditional non-use of NMIs is even easier.  ;-)
> 
> Something like the following.
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> rcu: Don't use NMIs to dump other CPUs' stacks
> 
> Although NMI-based stack dumps are in principle more accurate, they are
> also more likely to trigger deadlocks.  This commit therefore replaces
> all uses of trigger_all_cpu_backtrace() with rcu_dump_cpu_stacks(), so
> that the CPU detecting an RCU CPU stall does the stack dumping.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index c590e1201c74..777624e1329b 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -932,10 +932,7 @@ static void record_gp_stall_check_time(struct rcu_state *rsp)
>  }
>  
>  /*
> - * Dump stacks of all tasks running on stalled CPUs.  This is a fallback
> - * for architectures that do not implement trigger_all_cpu_backtrace().
> - * The NMI-triggered stack traces are more accurate because they are
> - * printed by the target CPU.
> + * Dump stacks of all tasks running on stalled CPUs.
>   */
>  static void rcu_dump_cpu_stacks(struct rcu_state *rsp)
>  {
> @@ -1013,7 +1010,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
>  	       (long)rsp->gpnum, (long)rsp->completed, totqlen);
>  	if (ndetected == 0)
>  		pr_err("INFO: Stall ended before state dump start\n");
> -	else if (!trigger_all_cpu_backtrace())
> +	else
>  		rcu_dump_cpu_stacks(rsp);
>  
>  	/* Complain about tasks blocking the grace period. */
> @@ -1044,8 +1041,7 @@ static void print_cpu_stall(struct rcu_state *rsp)
>  	pr_cont(" (t=%lu jiffies g=%ld c=%ld q=%lu)\n",
>  		jiffies - rsp->gp_start,
>  		(long)rsp->gpnum, (long)rsp->completed, totqlen);
> -	if (!trigger_all_cpu_backtrace())
> -		dump_stack();
> +	rcu_dump_cpu_stacks(rsp);

This is prone to producing not really consistent stacktraces though, 
right? As the target task is still running at the time the stack is being 
walked, it might produce stacktraces that are potentially nonsensial.

How about sending NMI to the target CPU, so that the task is actually 
stopped, but printing its stacktrace from the CPU that detected the stall 
while it's stopped?

That way, there is no printk()-from-NMI, but also the stacktrace is 
guaranteed to be self-consistent.

Thanks,

-- 
Jiri Kosina
SUSE Labs
