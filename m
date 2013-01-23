Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab3AWUJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 15:09:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab3AWUJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 15:09:39 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=sWCNLPJa_UsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=yruuRsm07C4A:10 a=20KFwNOVAAAA:8 a=GRDoAJCN5DIX5ZmCHJgA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358971778.21576.122.camel@gandalf.local.home>
Subject: Re: [PATCH] sched: add a tuning knob to allow changing RR tmeslice
From: Steven Rostedt <rostedt@goodmis.org>
To: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Date: Wed, 23 Jan 2013 15:09:38 -0500
In-Reply-To: <20121108142719.1e0dfc24@redhat.com>
References: <20121108142719.1e0dfc24@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-08 at 14:27 -0600, Clark Williams wrote:
> Subject: [PATCH] sched: add a tuning knob to allow changing RR timeslice
> 
> User wanted a facility simliar to the ability on Solaris to adjust
> the SCHED_RR timeslice value. Add a /proc/sys/kernel scheduler knob
> named sched_rr_timeslice_ms which allows global changing of the SCHED_RR
> timeslice value. User visable value is in milliseconds but is stored as
> jiffies.  Setting to 0 (zero) resets to the default (currently 100ms).
> 

Hmm, has this been ignored?

I guess the real question, is it still needed (or wanted)?

-- Steve

> Patch against tip/master, currently 3.7-rc3.
> 
> Signed-off-by: Clark Williams <williams@redhat.com>
> ---
>  include/linux/sched.h |  6 +++++-
>  kernel/sched.c        | 19 +++++++++++++++++++
>  kernel/sched_rt.c     |  4 ++--
>  kernel/sysctl.c       |  8 ++++++++
>  4 files changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 12317b6..214bf27 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2097,11 +2097,15 @@ static inline unsigned int get_sysctl_timer_migration(void)
>  #endif
>  extern unsigned int sysctl_sched_rt_period;
>  extern int sysctl_sched_rt_runtime;
> -
>  int sched_rt_handler(struct ctl_table *table, int write,
>  		void __user *buffer, size_t *lenp,
>  		loff_t *ppos);
>  
> +extern int sched_rr_timeslice;
> +extern int sched_rr_handler(struct ctl_table *table, int write,
> +		void __user *buffer, size_t *lenp,
> +		loff_t *ppos);
> +
>  #ifdef CONFIG_SCHED_AUTOGROUP
>  extern unsigned int sysctl_sched_autogroup_enabled;
>  
> diff --git a/kernel/sched.c b/kernel/sched.c
> index cdf9484..c63c3a4 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -120,6 +120,7 @@
>   * Timeslices get refilled after they expire.
>   */
>  #define DEF_TIMESLICE		(100 * HZ / 1000)
> +int sched_rr_timeslice = DEF_TIMESLICE;
>  
>  /*
>   * single value that denotes runtime == period, ie unlimited time.
> @@ -9614,6 +9615,24 @@ static int sched_rt_global_constraints(void)
>  }
>  #endif /* CONFIG_RT_GROUP_SCHED */
>  
> +int sched_rr_handler(struct ctl_table *table, int write,
> +		void __user *buffer, size_t *lenp,
> +		loff_t *ppos)
> +{
> +	int ret;
> +	static DEFINE_MUTEX(mutex);
> +
> +	mutex_lock(&mutex);
> +	ret = proc_dointvec(table, write, buffer, lenp, ppos);
> +	/* make sure that internally we keep jiffies */
> +	/* also, writing zero resets timeslice to default */
> +	if (!ret && write) 
> +		sched_rr_timeslice = sched_rr_timeslice <= 0 ? 
> +			DEF_TIMESLICE : msecs_to_jiffies(sched_rr_timeslice);
> +	mutex_unlock(&mutex);
> +	return ret;
> +}
> +
>  int sched_rt_handler(struct ctl_table *table, int write,
>  		void __user *buffer, size_t *lenp,
>  		loff_t *ppos)
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index c108b9c..799dd09 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1791,7 +1791,7 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
>  	if (--p->rt.time_slice)
>  		return;
>  
> -	p->rt.time_slice = DEF_TIMESLICE;
> +	p->rt.time_slice = sched_rr_timeslice;
>  
>  	/*
>  	 * Requeue to the end of queue if we are not the only element
> @@ -1819,7 +1819,7 @@ static unsigned int get_rr_interval_rt(struct rq *rq, struct task_struct *task)
>  	 * Time slice is 0 for SCHED_FIFO tasks
>  	 */
>  	if (task->policy == SCHED_RR)
> -		return DEF_TIMESLICE;
> +		return sched_rr_timeslice;
>  	else
>  		return 0;
>  }
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index ea7ec7f..10b1129 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -362,6 +362,14 @@ static struct ctl_table kern_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= sched_rt_handler,
>  	},
> +	{
> +		.procname	= "sched_rr_timeslice_ms",
> +		.data		= &sched_rr_timeslice,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= sched_rr_handler,
> +	},
> +
>  #ifdef CONFIG_SCHED_AUTOGROUP
>  	{
>  		.procname	= "sched_autogroup_enabled",


