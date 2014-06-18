Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbaFRASn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 20:18:43 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:53544 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316AbaFRASm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 20:18:42 -0400
Date: Tue, 17 Jun 2014 17:18:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140618001836.GV4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <539B594C.8070004@intel.com>
 <20140613224519.GV4581@linux.vnet.ibm.com>
 <53A0CAE5.9000702@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A0CAE5.9000702@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061800-0928-0000-0000-000002C4F4E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 04:10:29PM -0700, Dave Hansen wrote:
> On 06/13/2014 03:45 PM, Paul E. McKenney wrote:
> >> > Could the additional RCU quiescent states be causing us to be doing more
> >> > RCU frees that we were before, and getting less benefit from the lock
> >> > batching that RCU normally provides?
> > Quite possibly.  One way to check would be to use the debugfs files
> > rcu/*/rcugp, which give a count of grace periods since boot for each
> > RCU flavor.  Here "*" is rcu_preempt for CONFIG_PREEMPT and rcu_sched
> > for !CONFIG_PREEMPT.
> 
> With the previously-mentioned workload, rcugp's "age" averages 9 with
> the old kernel (or RCU_COND_RESCHED_LIM at a high value) and 2 with the
> current kernel which contains this regression.
> 
> I also checked the rate and sources for how I'm calling cond_resched.
> I'm calling it 5x for every open/close() pair in my test case, which
> take about 7us.  So, _cond_resched() is, on average, only being called
> every microsecond.  That doesn't seem _too_ horribly extreme.
> 
> >  3895.165846 |     8)               |  SyS_open() {
> >  3895.165846 |     8)   0.065 us    |    _cond_resched();
> >  3895.165847 |     8)   0.064 us    |    _cond_resched();
> >  3895.165849 |     8)   2.406 us    |  }
> >  3895.165849 |     8)   0.199 us    |  SyS_close();
> >  3895.165850 |     8)               |  do_notify_resume() {
> >  3895.165850 |     8)   0.063 us    |    _cond_resched();
> >  3895.165851 |     8)   0.069 us    |    _cond_resched();
> >  3895.165852 |     8)   0.060 us    |    _cond_resched();
> >  3895.165852 |     8)   2.194 us    |  }
> >  3895.165853 |     8)               |  SyS_open() {
> 
> The more I think about it, the more I think we can improve on a purely
> call-based counter.
> 
> First, it couples the number of cond_resched() directly calls with the
> benefits we see out of RCU.  We really don't *need* to see more grace
> periods if we have more cond_resched() calls.
> 
> It also ends up eating a new cacheline in a bunch of pretty hot paths.
> It would be nice to be able to keep the fast path part of this as at
> least read-only.
> 
> Could we do something (functionally) like the attached patch?  Instead
> of counting cond_resched() calls, we could just specify some future time
> by which we want have a quiescent state.  We could even push the time to
> be something _just_ before we would have declared a stall.

Nice analysis!

So if I understand correctly, a goodly part of the regression is due not
to the overhead added to cond_resched(), but rather because grace periods
are now happening faster, thus incurring more overhead.  Is that correct?

If this is the case, could you please let me know roughly how sensitive is
the performance to the time delay in RCU_COND_RESCHED_EVERY_THIS_JIFFIES?

The patch looks promising.  I will probably drive the time-setup deeper
into the guts of RCU, which should allow moving the access to jiffies
and the comparison off of the fast path as well, but this appears to
me to be good and sufficient for others encountering this same problem
in the meantime.

And of course, if my attempt to drive things deeper into the guts of
RCU doesn't work out, something close to the below might also be the
eventual solution.

							Thanx, Paul

> ---
> 
>  b/arch/x86/kernel/nmi.c    |    6 +++---
>  b/include/linux/rcupdate.h |    7 +++----
>  b/kernel/rcu/update.c      |    4 ++--
>  3 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff -puN include/linux/rcupdate.h~rcu-halfstall include/linux/rcupdate.h
> --- a/include/linux/rcupdate.h~rcu-halfstall	2014-06-17 14:08:19.596464173 -0700
> +++ b/include/linux/rcupdate.h	2014-06-17 14:15:40.335598696 -0700
> @@ -303,8 +303,8 @@ bool __rcu_is_watching(void);
>   * Hooks for cond_resched() and friends to avoid RCU CPU stall warnings.
>   */
> 
> -extern u64 RCU_COND_RESCHED_LIM;	/* ms vs. 100s of ms. */
> -DECLARE_PER_CPU(int, rcu_cond_resched_count);
> +extern u64 RCU_COND_RESCHED_EVERY_THIS_JIFFIES;
> +DECLARE_PER_CPU(unsigned long, rcu_cond_resched_at_jiffies);
>  void rcu_resched(void);
> 
>  /*
> @@ -321,8 +321,7 @@ void rcu_resched(void);
>   */
>  static inline bool rcu_should_resched(void)
>  {
> -	return raw_cpu_inc_return(rcu_cond_resched_count) >=
> -	       RCU_COND_RESCHED_LIM;
> +	return raw_cpu_read(rcu_cond_resched_at_jiffies) >= jiffies;
>  }
> 
>  /*
> diff -puN arch/x86/kernel/nmi.c~rcu-halfstall arch/x86/kernel/nmi.c
> --- a/arch/x86/kernel/nmi.c~rcu-halfstall	2014-06-17 14:11:28.442072042 -0700
> +++ b/arch/x86/kernel/nmi.c	2014-06-17 14:12:04.664723690 -0700
> @@ -88,13 +88,13 @@ __setup("unknown_nmi_panic", setup_unkno
> 
>  static u64 nmi_longest_ns = 1 * NSEC_PER_MSEC;
> 
> -u64 RCU_COND_RESCHED_LIM = 256;
> +u64 RCU_COND_RESCHED_EVERY_THIS_JIFFIES = 100;
>  static int __init nmi_warning_debugfs(void)
>  {
>  	debugfs_create_u64("nmi_longest_ns", 0644,
>  			arch_debugfs_dir, &nmi_longest_ns);
> -	debugfs_create_u64("RCU_COND_RESCHED_LIM", 0644,
> -			arch_debugfs_dir, &RCU_COND_RESCHED_LIM);
> +	debugfs_create_u64("RCU_COND_RESCHED_EVERY_THIS_JIFFIES", 0644,
> +			arch_debugfs_dir, &RCU_COND_RESCHED_EVERY_THIS_JIFFIES);
>  	return 0;
>  }
>  fs_initcall(nmi_warning_debugfs);
> diff -puN kernel/rcu/update.c~rcu-halfstall kernel/rcu/update.c
> --- a/kernel/rcu/update.c~rcu-halfstall	2014-06-17 14:12:50.768834979 -0700
> +++ b/kernel/rcu/update.c	2014-06-17 14:17:14.166894075 -0700
> @@ -355,7 +355,7 @@ early_initcall(check_cpu_stall_init);
>   * Hooks for cond_resched() and friends to avoid RCU CPU stall warnings.
>   */
> 
> -DEFINE_PER_CPU(int, rcu_cond_resched_count);
> +DEFINE_PER_CPU(unsigned long, rcu_cond_resched_at_jiffies);
> 
>  /*
>   * Report a set of RCU quiescent states, for use by cond_resched()
> @@ -364,7 +364,7 @@ DEFINE_PER_CPU(int, rcu_cond_resched_cou
>  void rcu_resched(void)
>  {
>  	preempt_disable();
> -	__this_cpu_write(rcu_cond_resched_count, 0);
> +	__this_cpu_write(rcu_cond_resched_at_jiffies, jiffies + RCU_COND_RESCHED_EVERY_THIS_JIFFIES);
>  	rcu_note_context_switch(smp_processor_id());
>  	preempt_enable();
>  }
> _

