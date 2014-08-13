Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaHMVRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 17:17:31 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:52198 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbaHMVR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 17:17:28 -0400
Date: Wed, 13 Aug 2014 14:17:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Joe Perches <joe@perches.com>, Josh Triplett <josh@freedesktop.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Iulia Manda <iulia.manda21@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] rcutorture: fixes for printing message buffer
Message-ID: <20140813211724.GV4752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1405110617-16498-1-git-send-email-bobby.prani@gmail.com>
 <1405111021.2796.23.camel@joe-AO725>
 <53C3DA88.8060004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C3DA88.8060004@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081321-1344-0000-0000-0000037264F8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 09:26:32AM -0400, Pranith Kumar wrote:
> On 07/11/2014 04:37 PM, Joe Perches wrote:
> > On Fri, 2014-07-11 at 16:30 -0400, Pranith Kumar wrote:
> >> Use snprintf() instead of sprintf() for writing to the message buffer.
> >> Also use vmalloc() for the allocation of the message buffer. Since pr_alert() is
> >> limited to print LOG_LINE_MAX characters at a time, we print the buffer in a
> >> loop one line at a time.
> >>
> >> I tested this using the parse-torture.sh script as follows:
> > 
> > Did you see the patch I sent you?
> > https://lkml.org/lkml/2014/6/20/604
> > 
> > It doesn't need a vmalloc.
> > What is wrong with that approach?
> > 
> > 
> 
> Hi Paul,
> 
> Please find an alternative patch as suggested by Joe.

Queued for 3.18, thank you both!

							Thanx, Paul

> >From 0a3050d5ac910cb5f488e0a0dfe44cde06af1259 Mon Sep 17 00:00:00 2001
> From: Pranith Kumar <bobby.prani@gmail.com>
> Date: Mon, 14 Jul 2014 09:16:15 -0400
> Subject: [PATCH 1/1] rcu: Use pr_alert/pr_cont for printing logs
> 
> User pr_alert/pr_cont for printing the logs from rcutorture module directly
> instead of writing it to a buffer and then printing it. This allows us from not
> having to allocate such buffers. Also remove a resulting empty function.
> 
> I tested this using the parse-torture.sh script as follows:
> 
> $ dmesg | grep torture > log.txt
> $ bash parse-torture.sh log.txt test
> $
> 
> There were no warnings which means that parsing went fine.
> 
> Signed-off-by: Joe Percesh <joe@perches.com>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  include/linux/torture.h |   2 +-
>  kernel/rcu/rcutorture.c | 127 +++++++++++++++++++++---------------------------
>  kernel/torture.c        |  16 +++---
>  3 files changed, 64 insertions(+), 81 deletions(-)
> 
> diff --git a/include/linux/torture.h b/include/linux/torture.h
> index 5ca58fc..fec46f8 100644
> --- a/include/linux/torture.h
> +++ b/include/linux/torture.h
> @@ -51,7 +51,7 @@
> 
>  /* Definitions for online/offline exerciser. */
>  int torture_onoff_init(long ooholdoff, long oointerval);
> -char *torture_onoff_stats(char *page);
> +void torture_onoff_stats(void);
>  bool torture_onoff_failures(void);
> 
>  /* Low-rider random number generator. */
> diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
> index 5ec0452..3e35f1b 100644
> --- a/kernel/rcu/rcutorture.c
> +++ b/kernel/rcu/rcutorture.c
> @@ -242,7 +242,7 @@ struct rcu_torture_ops {
>  	void (*call)(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
>  	void (*cb_barrier)(void);
>  	void (*fqs)(void);
> -	void (*stats)(char *page);
> +	void (*stats)(void);
>  	int irq_capable;
>  	int can_boost;
>  	const char *name;
> @@ -525,21 +525,21 @@ static void srcu_torture_barrier(void)
>  	srcu_barrier(&srcu_ctl);
>  }
> 
> -static void srcu_torture_stats(char *page)
> +static void srcu_torture_stats(void)
>  {
>  	int cpu;
>  	int idx = srcu_ctl.completed & 0x1;
> 
> -	page += sprintf(page, "%s%s per-CPU(idx=%d):",
> -		       torture_type, TORTURE_FLAG, idx);
> +	pr_alert("%s%s per-CPU(idx=%d):",
> +		 torture_type, TORTURE_FLAG, idx);
>  	for_each_possible_cpu(cpu) {
>  		long c0, c1;
> 
>  		c0 = (long)per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[!idx];
>  		c1 = (long)per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[idx];
> -		page += sprintf(page, " %d(%ld,%ld)", cpu, c0, c1);
> +		pr_cont(" %d(%ld,%ld)", cpu, c0, c1);
>  	}
> -	sprintf(page, "\n");
> +	pr_cont("\n");
>  }
> 
>  static void srcu_torture_synchronize_expedited(void)
> @@ -1031,10 +1031,15 @@ rcu_torture_reader(void *arg)
>  }
> 
>  /*
> - * Create an RCU-torture statistics message in the specified buffer.
> + * Print torture statistics.  Caller must ensure that there is only
> + * one call to this function at a given time!!!  This is normally
> + * accomplished by relying on the module system to only have one copy
> + * of the module loaded, and then by giving the rcu_torture_stats
> + * kthread full control (or the init/cleanup functions when rcu_torture_stats
> + * thread is not running).
>   */
>  static void
> -rcu_torture_printk(char *page)
> +rcu_torture_stats_print(void)
>  {
>  	int cpu;
>  	int i;
> @@ -1052,55 +1057,60 @@ rcu_torture_printk(char *page)
>  		if (pipesummary[i] != 0)
>  			break;
>  	}
> -	page += sprintf(page, "%s%s ", torture_type, TORTURE_FLAG);
> -	page += sprintf(page,
> -		       "rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d ",
> -		       rcu_torture_current,
> -		       rcu_torture_current_version,
> -		       list_empty(&rcu_torture_freelist),
> -		       atomic_read(&n_rcu_torture_alloc),
> -		       atomic_read(&n_rcu_torture_alloc_fail),
> -		       atomic_read(&n_rcu_torture_free));
> -	page += sprintf(page, "rtmbe: %d rtbke: %ld rtbre: %ld ",
> -		       atomic_read(&n_rcu_torture_mberror),
> -		       n_rcu_torture_boost_ktrerror,
> -		       n_rcu_torture_boost_rterror);
> -	page += sprintf(page, "rtbf: %ld rtb: %ld nt: %ld ",
> -		       n_rcu_torture_boost_failure,
> -		       n_rcu_torture_boosts,
> -		       n_rcu_torture_timers);
> -	page = torture_onoff_stats(page);
> -	page += sprintf(page, "barrier: %ld/%ld:%ld",
> -		       n_barrier_successes,
> -		       n_barrier_attempts,
> -		       n_rcu_torture_barrier_error);
> -	page += sprintf(page, "\n%s%s ", torture_type, TORTURE_FLAG);
> +
> +	pr_alert("%s%s ", torture_type, TORTURE_FLAG);
> +	pr_cont("rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d ",
> +		rcu_torture_current,
> +		rcu_torture_current_version,
> +		list_empty(&rcu_torture_freelist),
> +		atomic_read(&n_rcu_torture_alloc),
> +		atomic_read(&n_rcu_torture_alloc_fail),
> +		atomic_read(&n_rcu_torture_free));
> +	pr_cont("rtmbe: %d rtbke: %ld rtbre: %ld ",
> +		atomic_read(&n_rcu_torture_mberror),
> +		n_rcu_torture_boost_ktrerror,
> +		n_rcu_torture_boost_rterror);
> +	pr_cont("rtbf: %ld rtb: %ld nt: %ld ",
> +		n_rcu_torture_boost_failure,
> +		n_rcu_torture_boosts,
> +		n_rcu_torture_timers);
> +	torture_onoff_stats();
> +	pr_cont("barrier: %ld/%ld:%ld\n",
> +		n_barrier_successes,
> +		n_barrier_attempts,
> +		n_rcu_torture_barrier_error);
> +
> +	pr_alert("%s%s ", torture_type, TORTURE_FLAG);
>  	if (atomic_read(&n_rcu_torture_mberror) != 0 ||
>  	    n_rcu_torture_barrier_error != 0 ||
>  	    n_rcu_torture_boost_ktrerror != 0 ||
>  	    n_rcu_torture_boost_rterror != 0 ||
>  	    n_rcu_torture_boost_failure != 0 ||
>  	    i > 1) {
> -		page += sprintf(page, "!!! ");
> +		pr_cont("%s", "!!! ");
>  		atomic_inc(&n_rcu_torture_error);
>  		WARN_ON_ONCE(1);
>  	}
> -	page += sprintf(page, "Reader Pipe: ");
> +	pr_cont("Reader Pipe: ");
>  	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
> -		page += sprintf(page, " %ld", pipesummary[i]);
> -	page += sprintf(page, "\n%s%s ", torture_type, TORTURE_FLAG);
> -	page += sprintf(page, "Reader Batch: ");
> +		pr_cont(" %ld", pipesummary[i]);
> +	pr_cont("\n");
> +
> +	pr_alert("%s%s ", torture_type, TORTURE_FLAG);
> +	pr_cont("Reader Batch: ");
>  	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
> -		page += sprintf(page, " %ld", batchsummary[i]);
> -	page += sprintf(page, "\n%s%s ", torture_type, TORTURE_FLAG);
> -	page += sprintf(page, "Free-Block Circulation: ");
> +		pr_cont(" %ld", batchsummary[i]);
> +	pr_cont("\n");
> +
> +	pr_alert("%s%s ", torture_type, TORTURE_FLAG);
> +	pr_cont("Free-Block Circulation: ");
>  	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++) {
> -		page += sprintf(page, " %d",
> -			       atomic_read(&rcu_torture_wcount[i]));
> +		pr_cont(" %d", atomic_read(&rcu_torture_wcount[i]));
>  	}
> -	page += sprintf(page, "\n");
> +	pr_cont("\n");
> +
>  	if (cur_ops->stats)
> -		cur_ops->stats(page);
> +		cur_ops->stats();
>  	if (rtcv_snap == rcu_torture_current_version &&
>  	    rcu_torture_current != NULL) {
>  		int __maybe_unused flags;
> @@ -1109,10 +1119,9 @@ rcu_torture_printk(char *page)
> 
>  		rcutorture_get_gp_data(cur_ops->ttype,
>  				       &flags, &gpnum, &completed);
> -		page += sprintf(page,
> -				"??? Writer stall state %d g%lu c%lu f%#x\n",
> -				rcu_torture_writer_state,
> -				gpnum, completed, flags);
> +		pr_alert("??? Writer stall state %d g%lu c%lu f%#x\n",
> +			 rcu_torture_writer_state,
> +			 gpnum, completed, flags);
>  		show_rcu_gp_kthreads();
>  		rcutorture_trace_dump();
>  	}
> @@ -1120,30 +1129,6 @@ rcu_torture_printk(char *page)
>  }
> 
>  /*
> - * Print torture statistics.  Caller must ensure that there is only
> - * one call to this function at a given time!!!  This is normally
> - * accomplished by relying on the module system to only have one copy
> - * of the module loaded, and then by giving the rcu_torture_stats
> - * kthread full control (or the init/cleanup functions when rcu_torture_stats
> - * thread is not running).
> - */
> -static void
> -rcu_torture_stats_print(void)
> -{
> -	int size = nr_cpu_ids * 200 + 8192;
> -	char *buf;
> -
> -	buf = kmalloc(size, GFP_KERNEL);
> -	if (!buf) {
> -		pr_err("rcu-torture: Out of memory, need: %d", size);
> -		return;
> -	}
> -	rcu_torture_printk(buf);
> -	pr_alert("%s", buf);
> -	kfree(buf);
> -}
> -
> -/*
>   * Periodically prints torture statistics, if periodic statistics printing
>   * was specified via the stat_interval module parameter.
>   */
> diff --git a/kernel/torture.c b/kernel/torture.c
> index d600af2..ede8b25 100644
> --- a/kernel/torture.c
> +++ b/kernel/torture.c
> @@ -211,18 +211,16 @@ EXPORT_SYMBOL_GPL(torture_onoff_cleanup);
>  /*
>   * Print online/offline testing statistics.
>   */
> -char *torture_onoff_stats(char *page)
> +void torture_onoff_stats(void)
>  {
>  #ifdef CONFIG_HOTPLUG_CPU
> -	page += sprintf(page,
> -		       "onoff: %ld/%ld:%ld/%ld %d,%d:%d,%d %lu:%lu (HZ=%d) ",
> -		       n_online_successes, n_online_attempts,
> -		       n_offline_successes, n_offline_attempts,
> -		       min_online, max_online,
> -		       min_offline, max_offline,
> -		       sum_online, sum_offline, HZ);
> +	pr_cont("onoff: %ld/%ld:%ld/%ld %d,%d:%d,%d %lu:%lu (HZ=%d) ",
> +		n_online_successes, n_online_attempts,
> +		n_offline_successes, n_offline_attempts,
> +		min_online, max_online,
> +		min_offline, max_offline,
> +		sum_online, sum_offline, HZ);
>  #endif /* #ifdef CONFIG_HOTPLUG_CPU */
> -	return page;
>  }
>  EXPORT_SYMBOL_GPL(torture_onoff_stats);
> 
> -- 
> 2.0.1
> 

