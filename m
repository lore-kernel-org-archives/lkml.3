Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab3KFUj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:39:27 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52228 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab3KFUj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:39:26 -0500
Date: Wed, 6 Nov 2013 12:38:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: josh@freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/rcutorture.c: be sure of enough memory for result
 printing.
Message-ID: <20131106203859.GO18245@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <525BAD9F.6060406@asianux.com>
 <20131014112839.GO5790@linux.vnet.ibm.com>
 <525C9256.5010002@asianux.com>
 <525C9FAE.4090209@asianux.com>
 <20131015082613.GG5790@linux.vnet.ibm.com>
 <525D35E9.3000604@asianux.com>
 <20131015144732.GG9150@linux.vnet.ibm.com>
 <525DF4F0.3070901@asianux.com>
 <525F3830.2060001@asianux.com>
 <5264C0DD.9060006@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5264C0DD.9060006@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110620-5806-0000-0000-000023571A0F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 01:51:25PM +0800, Chen Gang wrote:
> If the contents is more than 4096 bytes (e.g. if have 1K cpus), current
> sprintf() will cause memory overflow. And this fix patch is to be sure
> of memory large enough.

Getting close, a few issues called out below.  Please resubmit with
these fixed.

> Benefit:
> 
>  - do not truncate printing contents.
>  - extensible, it is large enough for printing various related contents.
>  - simple and clear enough for both source code readers and writers.
> 
> Shortcoming:
> 
>  - It will waste some memory:
>     1 cpu may waste 24KB,
>     10 cpus may waste 96KB,
>     100 cpus may waste 816KB,
>     1K cpus may waste 8MB
>     ...
>    after finish printing, it will free the related memory, quickly.
>    it is a test module, so wast a little memory for extensible is OK.

Hmmm... 1K CPUs should be able to get by with about 200K rather than 8MB.
(Actually more like 60K, but allowing a little slop is not a bad thing.)

> Related  test (Fedora16 2 CPUs, 2GB RAM x86_64)
> 
>  - as module, with/without "torture_type=srcu".
>  - build-in not boot runnable, with/without "torture_type=srcu".
>  - build-in let boot runnable, with/without "torture_type=srcu".
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/rcutorture.c |   67 ++++++++++++++++++++++++++-------------------------
>  1 files changed, 34 insertions(+), 33 deletions(-)
> 
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index be63101..3413bc1 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -133,8 +133,6 @@ MODULE_PARM_DESC(verbose, "Enable verbose debugging printk()s");
>  #define VERBOSE_PRINTK_ERRSTRING(s) \
>  	do { if (verbose) pr_alert("%s" TORTURE_FLAG "!!! " s "\n", torture_type); } while (0)
> 
> -static char printk_buf[4096];
> -
>  static int nrealreaders;
>  static struct task_struct *writer_task;
>  static struct task_struct **fakewriter_tasks;
> @@ -370,7 +368,7 @@ struct rcu_torture_ops {
>  	void (*call)(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
>  	void (*cb_barrier)(void);
>  	void (*fqs)(void);
> -	int (*stats)(char *page);
> +	void (*stats)(char *page);
>  	int irq_capable;
>  	int can_boost;
>  	const char *name;
> @@ -572,21 +570,19 @@ static void srcu_torture_barrier(void)
>  	srcu_barrier(&srcu_ctl);
>  }
> 
> -static int srcu_torture_stats(char *page)
> +static void srcu_torture_stats(char *page)
>  {
> -	int cnt = 0;
>  	int cpu;
>  	int idx = srcu_ctl.completed & 0x1;
> 
> -	cnt += sprintf(&page[cnt], "%s%s per-CPU(idx=%d):",
> +	page += sprintf(page, "%s%s per-CPU(idx=%d):",
>  		       torture_type, TORTURE_FLAG, idx);
>  	for_each_possible_cpu(cpu) {
> -		cnt += sprintf(&page[cnt], " %d(%lu,%lu)", cpu,
> +		page += sprintf(page, " %d(%lu,%lu)", cpu,

This format string has at most 54 characters, call it 100.

>  			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[!idx],
>  			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[idx]);
>  	}
> -	cnt += sprintf(&page[cnt], "\n");
> -	return cnt;
> +	sprintf(page, "\n");
>  }
> 
>  static void srcu_torture_synchronize_expedited(void)
> @@ -1046,10 +1042,9 @@ rcu_torture_reader(void *arg)
>  /*
>   * Create an RCU-torture statistics message in the specified buffer.
>   */
> -static int
> +static void
>  rcu_torture_printk(char *page)
>  {
> -	int cnt = 0;
>  	int cpu;
>  	int i;
>  	long pipesummary[RCU_TORTURE_PIPE_LEN + 1] = { 0 };
> @@ -1065,8 +1060,8 @@ rcu_torture_printk(char *page)
>  		if (pipesummary[i] != 0)
>  			break;
>  	}
> -	cnt += sprintf(&page[cnt], "%s%s ", torture_type, TORTURE_FLAG);
> -	cnt += sprintf(&page[cnt],
> +	page += sprintf(page, "%s%s ", torture_type, TORTURE_FLAG);
> +	page += sprintf(page,
>  		       "rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d ",
>  		       rcu_torture_current,
>  		       rcu_torture_current_version,
> @@ -1074,53 +1069,52 @@ rcu_torture_printk(char *page)
>  		       atomic_read(&n_rcu_torture_alloc),
>  		       atomic_read(&n_rcu_torture_alloc_fail),
>  		       atomic_read(&n_rcu_torture_free));
> -	cnt += sprintf(&page[cnt], "rtmbe: %d rtbke: %ld rtbre: %ld ",
> +	page += sprintf(page, "rtmbe: %d rtbke: %ld rtbre: %ld ",
>  		       atomic_read(&n_rcu_torture_mberror),
>  		       n_rcu_torture_boost_ktrerror,
>  		       n_rcu_torture_boost_rterror);
> -	cnt += sprintf(&page[cnt], "rtbf: %ld rtb: %ld nt: %ld ",
> +	page += sprintf(page, "rtbf: %ld rtb: %ld nt: %ld ",
>  		       n_rcu_torture_boost_failure,
>  		       n_rcu_torture_boosts,
>  		       n_rcu_torture_timers);
> -	cnt += sprintf(&page[cnt],
> +	page += sprintf(page,
>  		       "onoff: %ld/%ld:%ld/%ld %d,%d:%d,%d %lu:%lu (HZ=%d) ",
>  		       n_online_successes, n_online_attempts,
>  		       n_offline_successes, n_offline_attempts,
>  		       min_online, max_online,
>  		       min_offline, max_offline,
>  		       sum_online, sum_offline, HZ);
> -	cnt += sprintf(&page[cnt], "barrier: %ld/%ld:%ld",
> +	page += sprintf(page, "barrier: %ld/%ld:%ld",
>  		       n_barrier_successes,
>  		       n_barrier_attempts,
>  		       n_rcu_torture_barrier_error);
> -	cnt += sprintf(&page[cnt], "\n%s%s ", torture_type, TORTURE_FLAG);
> +	page += sprintf(page, "\n%s%s ", torture_type, TORTURE_FLAG);
>  	if (atomic_read(&n_rcu_torture_mberror) != 0 ||
>  	    n_rcu_torture_barrier_error != 0 ||
>  	    n_rcu_torture_boost_ktrerror != 0 ||
>  	    n_rcu_torture_boost_rterror != 0 ||
>  	    n_rcu_torture_boost_failure != 0 ||
>  	    i > 1) {
> -		cnt += sprintf(&page[cnt], "!!! ");
> +		page += sprintf(page, "!!! ");
>  		atomic_inc(&n_rcu_torture_error);
>  		WARN_ON_ONCE(1);
>  	}
> -	cnt += sprintf(&page[cnt], "Reader Pipe: ");
> +	page += sprintf(page, "Reader Pipe: ");
>  	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
> -		cnt += sprintf(&page[cnt], " %ld", pipesummary[i]);
> -	cnt += sprintf(&page[cnt], "\n%s%s ", torture_type, TORTURE_FLAG);
> -	cnt += sprintf(&page[cnt], "Reader Batch: ");
> +		page += sprintf(page, " %ld", pipesummary[i]);
> +	page += sprintf(page, "\n%s%s ", torture_type, TORTURE_FLAG);
> +	page += sprintf(page, "Reader Batch: ");
>  	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
> -		cnt += sprintf(&page[cnt], " %ld", batchsummary[i]);
> -	cnt += sprintf(&page[cnt], "\n%s%s ", torture_type, TORTURE_FLAG);
> -	cnt += sprintf(&page[cnt], "Free-Block Circulation: ");
> +		page += sprintf(page, " %ld", batchsummary[i]);
> +	page += sprintf(page, "\n%s%s ", torture_type, TORTURE_FLAG);
> +	page += sprintf(page, "Free-Block Circulation: ");
>  	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++) {
> -		cnt += sprintf(&page[cnt], " %d",
> +		page += sprintf(page, " %d",
>  			       atomic_read(&rcu_torture_wcount[i]));
>  	}
> -	cnt += sprintf(&page[cnt], "\n");
> +	page += sprintf(page, "\n");
>  	if (cur_ops->stats)
> -		cnt += cur_ops->stats(&page[cnt]);
> -	return cnt;
> +		 cur_ops->stats(page);

Extraneous space here, please fix.  (As your later checkpatch noted.)

And this function can output a few K of characters.

>  }
> 
>  /*
> @@ -1134,10 +1128,17 @@ rcu_torture_printk(char *page)
>  static void
>  rcu_torture_stats_print(void)
>  {
> -	int cnt;
> +	int size = (nr_cpu_ids + 2) * PAGE_SIZE; /* be sure of large enough */

So 8K should cover the preamble, and about 54 per CPU for SRCU (which
we can round to 100 and then double to 200 for safety against changes),
so something like this should suffice:

	int size = nr_cpu_ids * 200 + 8192; /* be sure of large enough */

This allows about a factor of 4 slop, which is OK.  The original factor
of 80 was a bit excessive.

> +	char *buf;
> 
> -	cnt = rcu_torture_printk(printk_buf);
> -	pr_alert("%s", printk_buf);
> +	buf = kmalloc(size, GFP_KERNEL);
> +	if (!buf) {
> +		pr_err("no enough memory for printing, requre: %d", size);
> +		return;
> +	}
> +	rcu_torture_printk(buf);
> +	pr_alert("%s", buf);
> +	kfree(buf);
>  }
> 
>  /*
> -- 
> 1.7.7.6
> 

