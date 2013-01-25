Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3AYITW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:19:22 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:34517 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab3AYITU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:19:20 -0500
Date: Fri, 25 Jan 2013 09:19:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] sched: add a tuning knob to allow changing RR tmeslice
Message-ID: <20130125081916.GC25314@gmail.com>
References: <20121108195113.2dd51d43@redhat.com>
 <20130124165955.GA9324@gmail.com>
 <20130124135427.1748d057@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124135427.1748d057@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Clark Williams <williams@redhat.com> wrote:

> On Thu, 24 Jan 2013 17:59:55 +0100
> Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > * Clark Williams <williams@redhat.com> wrote:
> > 
> > > This version stores the user-input value in a separate 
> > > location from the jiffies values used by the scheduler, to 
> > > prevent a race condition.
> > > 
> > > Subject: [PATCH v2] sched: add a tuning knob to allow changing 
> > > RR timeslice
> > 
> > looks useful.
> > 
> > > @@ -2010,7 +2010,7 @@ static void task_tick_rt(struct rq *rq, struct
> > > task_struct *p, int queued) if (--p->rt.time_slice)
> > >  		return;
> > >  
> > > -	p->rt.time_slice = RR_TIMESLICE;
> > > +	p->rt.time_slice = sched_rr_timeslice;
> > >  
> > >  	/*
> > >  	 * Requeue to the end of queue if we (and all of our
> > > ancestors) are the @@ -2041,7 +2041,7 @@ static unsigned int
> > > get_rr_interval_rt(struct rq *rq, struct task_struct *task)
> > >  	 * Time slice is 0 for SCHED_FIFO tasks
> > 
> > Patch wont apply due to patch corruption, alas.
> > 
> > 
> 
> Easily fixed. Modified for 3.8-rc4:

Thanks. Some more substantial review feedback this time around:

> 
> commit 0e2d40c5c84d06670f85cc212591f27f69f59c62
> Author: Clark Williams <williams@redhat.com>
> Date:   Thu Jan 24 13:51:01 2013 -0600
> 
>     [kernel] sched: add a tuning knob to allow changing RR timeslice
>     
>     Add a /proc/sys/kernel scheduler knob named sched_rr_timeslice_ms

s/Add a /proc/sys/kernel/sched_rr_timeslice_ms scheduler knob

>     that allows global changing of the SCHED_RR timeslice value. User
>     visable value is in milliseconds but is stored as jiffies.  Setting

s/visible

>     to 0 (zero) resets to the default (currently 100ms).
>     
>     Signed-off-by: Clark Williams <williams@redhat.com>
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 6fc8f45..d803690 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2082,6 +2082,11 @@ int sched_rt_handler(struct ctl_table *table, int write,
>  		void __user *buffer, size_t *lenp,
>  		loff_t *ppos);
>  
> +extern int sched_rr_timeslice;
> +extern int sched_rr_handler(struct ctl_table *table, int write,
> +		void __user *buffer, size_t *lenp,
> +		loff_t *ppos);
> +

Shouldn't this be in kernel/sched/sched.h instead of the 
(already too large) linux/sched.h?

>  #ifdef CONFIG_SCHED_AUTOGROUP
>  extern unsigned int sysctl_sched_autogroup_enabled;
>  
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 257002c..5675074 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -7507,6 +7507,24 @@ static int sched_rt_global_constraints(void)
>  }
>  #endif /* CONFIG_RT_GROUP_SCHED */
>  
> +int sched_rr_handler(struct ctl_table *table, int write,
> +		void __user *buffer, size_t *lenp,
> +		loff_t *ppos)
> +{
> +	int ret;
> +	static DEFINE_MUTEX(mutex);

This mutex should be outside the function (not in local scope), 
and named like this, with an explanation:

+/*
+ * Since it's an int the CPU will always read a full word
+ * of the RR timeslice interval - no need for locking.
+ *
+ * But in the RR handler we read the value multiple times
+ * before setting it, which should be protected - hence
+ * this mutex:
+ */
+static DEFINE_MUTEX(rr_timeslice_mutex);


> +
> +	mutex_lock(&mutex);
> +	ret = proc_dointvec(table, write, buffer, lenp, ppos);
> +	/* make sure that internally we keep jiffies */
> +	/* also, writing zero resets timeslice to default */
> +	if (!ret && write) 
> +		sched_rr_timeslice = sched_rr_timeslice <= 0 ? 
> +			RR_TIMESLICE : msecs_to_jiffies(sched_rr_timeslice);
> +	mutex_unlock(&mutex);
> +	return ret;

A couple of stray spaces at end of lines. Also, please put curly 
braces around multi-line statements.

Multi-line comments should be like this:

  /*
   * Comment .....
   * ...... goes here.
   */


> +}
> +
>  int sched_rt_handler(struct ctl_table *table, int write,
>  		void __user *buffer, size_t *lenp,
>  		loff_t *ppos)
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 418feb0..6c54e83 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -11,6 +11,8 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
>  
>  struct rt_bandwidth def_rt_bandwidth;
>  
> +int sched_rr_timeslice = RR_TIMESLICE;
> +

I think this could go into core.c as well, together with the 
mutex. That way it's easier to see why the mutex is needed as 
well.

It should also be __read_mostly.

>  static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
>  {
>  	struct rt_bandwidth *rt_b =
> @@ -2010,7 +2012,7 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
>  	if (--p->rt.time_slice)
>  		return;
>  
> -	p->rt.time_slice = RR_TIMESLICE;
> +	p->rt.time_slice = sched_rr_timeslice;
>  
>  	/*
>  	 * Requeue to the end of queue if we (and all of our ancestors) are the
> @@ -2041,7 +2043,7 @@ static unsigned int get_rr_interval_rt(struct rq *rq, struct task_struct *task)
>  	 * Time slice is 0 for SCHED_FIFO tasks
>  	 */
>  	if (task->policy == SCHED_RR)
> -		return RR_TIMESLICE;
> +		return sched_rr_timeslice;
>  	else
>  		return 0;
>  }
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index c88878d..1eabf86 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -403,6 +403,14 @@ static struct ctl_table kern_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= sched_rt_handler,
>  	},
> +	{
> +		.procname	= "sched_rr_timeslice_ms",
> +		.data		= &sched_rr_timeslice,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= sched_rr_handler,

Does this allow negative values? Wouldn't it be better to make 
it unsigned int all around?

Thanks,

	Ingo
