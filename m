Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab3JOI0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 04:26:22 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40645 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab3JOI0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 04:26:19 -0400
Date: Tue, 15 Oct 2013 01:26:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: josh@freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/rcutorture.c: use scnprintf() instead of sprintf()
Message-ID: <20131015082613.GG5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5253C335.5050609@asianux.com>
 <20131013110518.GC5790@linux.vnet.ibm.com>
 <525BAD9F.6060406@asianux.com>
 <20131014112839.GO5790@linux.vnet.ibm.com>
 <525C9256.5010002@asianux.com>
 <525C9FAE.4090209@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525C9FAE.4090209@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101508-8236-0000-0000-000002BC642C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 09:51:42AM +0800, Chen Gang wrote:
> On 10/15/2013 08:54 AM, Chen Gang wrote:
> > On 10/14/2013 07:28 PM, Paul E. McKenney wrote:
> >> On Mon, Oct 14, 2013 at 04:38:55PM +0800, Chen Gang wrote:
> >>> If the contents is more than 4096 bytes (e.g. if have 1K cpus), current
> >>> sprintf() will cause memory overflow.
> >>>
> >>> They are all test information which can be truncated, so use scnprintf()
> >>> instead of sprintf(), also add 'max' parameter for related functions,
> >>> also notice 80 columns boundary and parameters alignments.
> >>>
> >>> Test case:
> >>>
> >>>   Fedora16 x86_64, 2 CPUs, 2GB RAM, [in/rm]mod with "torture_type=srcu".
> >>>
> >>>     let maximize buffer to 256 to truncate in rcu_torture_printk().
> >>>     let maximize buffer to 410 to may truncate in srcu_torture_stats().
> >>>     let maximize buffer to 4096 (original size) to print full.
> >>>
> >>>   it is a rcu test module, so not need additional test or consideration.
> >>>
> >>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> >>
> >> At first glance, not a bad start.
> >>
> >> Suppose that your goal was to make it avoid truncation.  What would you
> >> do differently?
> >>
> > 
> > One simple way: using snprintf() instead of scnprintf() in the related
> > printing functions. Then call them with "buffer == NULL" to get buffer
> > size, next allocate it and call it again ...
> 
> Oh, this simple way assumes the printing contents will not be changed
> during the 2 calls.

Indeed.  But can you make use of nr_cpu_ids, which is set at boot time
to the the maximum number of CPUs that the particular booting system
will ever be able to contain?  Keep in mind that you know the maximum
number of digits that an unsigned long will print in 32-bit and 64-bit
systems.

> > Hmm... it is only a test module, is it worth enough to try to make it
> > avoid truncation? If some members (quite few members) find truncation,
> > they can simply extend maximize buffer to avoid it when testing.
> > 
> > But if we do not fix this bug, when memory overflow, the OS may not stop
> > immediately, then it will/may lead the testers to face various amazing
> > things (which is not quite easy to find root cause).

It might cause strange symptoms, but it is not bad practice to try
it anyway, especially when the code is unfamiliar.  After all, if the
strange systems appear on memory overflow, but do not appear if there
is no memory overflow, you have a pretty good idea what the cause .
Besides, there might be some other mechanism to prevent the problem.
Of course, there is no such mechanism in this particular case, but in
general it is more efficient to find that out quickly then to spend time
designing a solution that is not needed.

							Thanx, Paul

> > All together, making contribution with efficiency and without negative
> > effect is our goal, so ...
> > 
> > 
> > Thanks.
> > 
> >> 							Thanx, Paul
> >>
> >>> ---
> >>>  kernel/rcutorture.c |  110 +++++++++++++++++++++++++++-----------------------
> >>>  1 files changed, 59 insertions(+), 51 deletions(-)
> >>>
> >>> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> >>> index be63101..107fd76 100644
> >>> --- a/kernel/rcutorture.c
> >>> +++ b/kernel/rcutorture.c
> >>> @@ -370,7 +370,7 @@ struct rcu_torture_ops {
> >>>  	void (*call)(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
> >>>  	void (*cb_barrier)(void);
> >>>  	void (*fqs)(void);
> >>> -	int (*stats)(char *page);
> >>> +	int (*stats)(char *page, int max);
> >>>  	int irq_capable;
> >>>  	int can_boost;
> >>>  	const char *name;
> >>> @@ -572,20 +572,20 @@ static void srcu_torture_barrier(void)
> >>>  	srcu_barrier(&srcu_ctl);
> >>>  }
> >>>
> >>> -static int srcu_torture_stats(char *page)
> >>> +static int srcu_torture_stats(char *page, int max)
> >>>  {
> >>>  	int cnt = 0;
> >>>  	int cpu;
> >>>  	int idx = srcu_ctl.completed & 0x1;
> >>>
> >>> -	cnt += sprintf(&page[cnt], "%s%s per-CPU(idx=%d):",
> >>> -		       torture_type, TORTURE_FLAG, idx);
> >>> +	cnt += scnprintf(&page[cnt], max - cnt, "%s%s per-CPU(idx=%d):",
> >>> +			torture_type, TORTURE_FLAG, idx);
> >>>  	for_each_possible_cpu(cpu) {
> >>> -		cnt += sprintf(&page[cnt], " %d(%lu,%lu)", cpu,
> >>> -			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[!idx],
> >>> -			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[idx]);
> >>> +		cnt += scnprintf(&page[cnt], max - cnt, " %d(%lu,%lu)", cpu,
> >>> +				per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[!idx],
> >>> +				per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[idx]);
> >>>  	}
> >>> -	cnt += sprintf(&page[cnt], "\n");
> >>> +	cnt += scnprintf(&page[cnt], max - cnt, "\n");
> >>>  	return cnt;
> >>>  }
> >>>
> >>> @@ -1047,7 +1047,7 @@ rcu_torture_reader(void *arg)
> >>>   * Create an RCU-torture statistics message in the specified buffer.
> >>>   */
> >>>  static int
> >>> -rcu_torture_printk(char *page)
> >>> +rcu_torture_printk(char *page, int max)
> >>>  {
> >>>  	int cnt = 0;
> >>>  	int cpu;
> >>> @@ -1065,61 +1065,69 @@ rcu_torture_printk(char *page)
> >>>  		if (pipesummary[i] != 0)
> >>>  			break;
> >>>  	}
> >>> -	cnt += sprintf(&page[cnt], "%s%s ", torture_type, TORTURE_FLAG);
> >>> -	cnt += sprintf(&page[cnt],
> >>> -		       "rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d ",
> >>> -		       rcu_torture_current,
> >>> -		       rcu_torture_current_version,
> >>> -		       list_empty(&rcu_torture_freelist),
> >>> -		       atomic_read(&n_rcu_torture_alloc),
> >>> -		       atomic_read(&n_rcu_torture_alloc_fail),
> >>> -		       atomic_read(&n_rcu_torture_free));
> >>> -	cnt += sprintf(&page[cnt], "rtmbe: %d rtbke: %ld rtbre: %ld ",
> >>> -		       atomic_read(&n_rcu_torture_mberror),
> >>> -		       n_rcu_torture_boost_ktrerror,
> >>> -		       n_rcu_torture_boost_rterror);
> >>> -	cnt += sprintf(&page[cnt], "rtbf: %ld rtb: %ld nt: %ld ",
> >>> -		       n_rcu_torture_boost_failure,
> >>> -		       n_rcu_torture_boosts,
> >>> -		       n_rcu_torture_timers);
> >>> -	cnt += sprintf(&page[cnt],
> >>> -		       "onoff: %ld/%ld:%ld/%ld %d,%d:%d,%d %lu:%lu (HZ=%d) ",
> >>> -		       n_online_successes, n_online_attempts,
> >>> -		       n_offline_successes, n_offline_attempts,
> >>> -		       min_online, max_online,
> >>> -		       min_offline, max_offline,
> >>> -		       sum_online, sum_offline, HZ);
> >>> -	cnt += sprintf(&page[cnt], "barrier: %ld/%ld:%ld",
> >>> -		       n_barrier_successes,
> >>> -		       n_barrier_attempts,
> >>> -		       n_rcu_torture_barrier_error);
> >>> -	cnt += sprintf(&page[cnt], "\n%s%s ", torture_type, TORTURE_FLAG);
> >>> +	cnt += scnprintf(&page[cnt], max - cnt, "%s%s ",
> >>> +			torture_type, TORTURE_FLAG);
> >>> +	cnt += scnprintf(&page[cnt], max - cnt,
> >>> +			"rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d ",
> >>> +			rcu_torture_current,
> >>> +			rcu_torture_current_version,
> >>> +			list_empty(&rcu_torture_freelist),
> >>> +			atomic_read(&n_rcu_torture_alloc),
> >>> +			atomic_read(&n_rcu_torture_alloc_fail),
> >>> +			atomic_read(&n_rcu_torture_free));
> >>> +	cnt += scnprintf(&page[cnt], max - cnt,
> >>> +			"rtmbe: %d rtbke: %ld rtbre: %ld ",
> >>> +			atomic_read(&n_rcu_torture_mberror),
> >>> +			n_rcu_torture_boost_ktrerror,
> >>> +			n_rcu_torture_boost_rterror);
> >>> +	cnt += scnprintf(&page[cnt], max - cnt,
> >>> +			"rtbf: %ld rtb: %ld nt: %ld ",
> >>> +			n_rcu_torture_boost_failure,
> >>> +			n_rcu_torture_boosts,
> >>> +			n_rcu_torture_timers);
> >>> +	cnt += scnprintf(&page[cnt], max - cnt,
> >>> +			"onoff: %ld/%ld:%ld/%ld %d,%d:%d,%d %lu:%lu (HZ=%d) ",
> >>> +			n_online_successes, n_online_attempts,
> >>> +			n_offline_successes, n_offline_attempts,
> >>> +			min_online, max_online,
> >>> +			min_offline, max_offline,
> >>> +			sum_online, sum_offline, HZ);
> >>> +	cnt += scnprintf(&page[cnt], max - cnt,
> >>> +			"barrier: %ld/%ld:%ld",
> >>> +			n_barrier_successes,
> >>> +			n_barrier_attempts,
> >>> +			n_rcu_torture_barrier_error);
> >>> +	cnt += scnprintf(&page[cnt], max - cnt, "\n%s%s ",
> >>> +			torture_type, TORTURE_FLAG);
> >>>  	if (atomic_read(&n_rcu_torture_mberror) != 0 ||
> >>>  	    n_rcu_torture_barrier_error != 0 ||
> >>>  	    n_rcu_torture_boost_ktrerror != 0 ||
> >>>  	    n_rcu_torture_boost_rterror != 0 ||
> >>>  	    n_rcu_torture_boost_failure != 0 ||
> >>>  	    i > 1) {
> >>> -		cnt += sprintf(&page[cnt], "!!! ");
> >>> +		cnt += scnprintf(&page[cnt], max - cnt, "!!! ");
> >>>  		atomic_inc(&n_rcu_torture_error);
> >>>  		WARN_ON_ONCE(1);
> >>>  	}
> >>> -	cnt += sprintf(&page[cnt], "Reader Pipe: ");
> >>> +	cnt += scnprintf(&page[cnt], max - cnt, "Reader Pipe: ");
> >>>  	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
> >>> -		cnt += sprintf(&page[cnt], " %ld", pipesummary[i]);
> >>> -	cnt += sprintf(&page[cnt], "\n%s%s ", torture_type, TORTURE_FLAG);
> >>> -	cnt += sprintf(&page[cnt], "Reader Batch: ");
> >>> +		cnt += scnprintf(&page[cnt], max - cnt, " %ld", pipesummary[i]);
> >>> +	cnt += scnprintf(&page[cnt], max - cnt, "\n%s%s ",
> >>> +			torture_type, TORTURE_FLAG);
> >>> +	cnt += scnprintf(&page[cnt], max - cnt, "Reader Batch: ");
> >>>  	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
> >>> -		cnt += sprintf(&page[cnt], " %ld", batchsummary[i]);
> >>> -	cnt += sprintf(&page[cnt], "\n%s%s ", torture_type, TORTURE_FLAG);
> >>> -	cnt += sprintf(&page[cnt], "Free-Block Circulation: ");
> >>> +		cnt += scnprintf(&page[cnt], max - cnt, " %ld",
> >>> +				batchsummary[i]);
> >>> +	cnt += scnprintf(&page[cnt], max - cnt, "\n%s%s ",
> >>> +			torture_type, TORTURE_FLAG);
> >>> +	cnt += scnprintf(&page[cnt], max - cnt, "Free-Block Circulation: ");
> >>>  	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++) {
> >>> -		cnt += sprintf(&page[cnt], " %d",
> >>> -			       atomic_read(&rcu_torture_wcount[i]));
> >>> +		cnt += scnprintf(&page[cnt], max - cnt, " %d",
> >>> +				atomic_read(&rcu_torture_wcount[i]));
> >>>  	}
> >>> -	cnt += sprintf(&page[cnt], "\n");
> >>> +	cnt += scnprintf(&page[cnt], max - cnt, "\n");
> >>>  	if (cur_ops->stats)
> >>> -		cnt += cur_ops->stats(&page[cnt]);
> >>> +		cnt += cur_ops->stats(&page[cnt], max - cnt);
> >>>  	return cnt;
> >>>  }
> >>>
> >>> @@ -1136,7 +1144,7 @@ rcu_torture_stats_print(void)
> >>>  {
> >>>  	int cnt;
> >>>
> >>> -	cnt = rcu_torture_printk(printk_buf);
> >>> +	cnt = rcu_torture_printk(printk_buf, sizeof(printk_buf));
> >>>  	pr_alert("%s", printk_buf);
> >>>  }
> >>>
> >>> -- 
> >>> 1.7.7.6
> >>>
> >>
> >>
> >>
> > 
> > 
> 
> 
> -- 
> Chen Gang
> 

