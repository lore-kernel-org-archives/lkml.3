Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaBRVgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:36:19 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:40393 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaBRVgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:36:17 -0500
Date: Tue, 18 Feb 2014 13:36:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 37/55] rcutorture: Abstract
 torture_create_kthread()
Message-ID: <20140218213611.GA4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1392675179-11560-37-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140218003402.GI19929@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218003402.GI19929@thin>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021821-6688-0000-0000-000006BAB3D6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 04:34:02PM -0800, Josh Triplett wrote:
> On Mon, Feb 17, 2014 at 02:12:41PM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > Creation of kthreads is not RCU-specific, so this commit abstracts
> > out torture_create_kthread(), saving a few tens of lines of code in
> > the process.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> One comment below.
> 
> >  include/linux/torture.h |  8 +++-
> >  kernel/rcu/rcutorture.c | 98 ++++++++++---------------------------------------
> >  kernel/torture.c        | 80 +++++++++++++++++-----------------------
> >  3 files changed, 60 insertions(+), 126 deletions(-)
> > 
> > diff --git a/include/linux/torture.h b/include/linux/torture.h
> > index db9bc7756a32..e5264c6ecfeb 100644
> > --- a/include/linux/torture.h
> > +++ b/include/linux/torture.h
> > @@ -47,7 +47,7 @@
> >  #define VERBOSE_TOROUT_STRING(s) \
> >  	do { if (verbose) pr_alert("%s" TORTURE_FLAG " %s\n", torture_type, s); } while (0)
> >  #define VERBOSE_TOROUT_ERRSTRING(s) \
> > -	do { if (verbose) pr_alert("%s" TORTURE_FLAG "!!! " s "\n", torture_type); } while (0)
> > +	do { if (verbose) pr_alert("%s" TORTURE_FLAG "!!! %s\n", torture_type, s); } while (0)
> 
> This change is also unrelated, and should not occur in this commit.

It is required for the invocation in _torture_create_kthread() below.
I have updated the commit log to call this out.

							Thanx, Paul

> - Josh Triplett
> 
> >  /* Definitions for a non-string torture-test module parameter. */
> >  #define torture_parm(type, name, init, msg) \
> > @@ -89,5 +89,11 @@ bool torture_cleanup(void);
> >  bool torture_must_stop(void);
> >  bool torture_must_stop_irq(void);
> >  void torture_kthread_stopping(char *title);
> > +int _torture_create_kthread(int (*fn)(void *arg), void *arg, char *s, char *m,
> > +			     char *f, struct task_struct **tp);
> > +
> > +#define torture_create_kthread(n, arg, tp) \
> > +	_torture_create_kthread(n, (arg), #n, "Creating " #n " task", \
> > +				"Failed to create " #n, &(tp))
> >  
> >  #endif /* __LINUX_TORTURE_H */
> > diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
> > index cf365160b44f..951a5559d9fa 100644
> > --- a/kernel/rcu/rcutorture.c
> > +++ b/kernel/rcu/rcutorture.c
> > @@ -1104,19 +1104,9 @@ static int rcu_torture_stall(void *args)
> >  /* Spawn CPU-stall kthread, if stall_cpu specified. */
> >  static int __init rcu_torture_stall_init(void)
> >  {
> > -	int ret;
> > -
> >  	if (stall_cpu <= 0)
> >  		return 0;
> > -	VERBOSE_TOROUT_STRING("Creating rcu_torture_stall task");
> > -	stall_task = kthread_run(rcu_torture_stall, NULL, "rcu_torture_stall");
> > -	if (IS_ERR(stall_task)) {
> > -		ret = PTR_ERR(stall_task);
> > -		stall_task = NULL;
> > -		return ret;
> > -	}
> > -	torture_shuffle_task_register(stall_task);
> > -	return 0;
> > +	return torture_create_kthread(rcu_torture_stall, NULL, stall_task);
> >  }
> >  
> >  /* Clean up after the CPU-stall kthread, if one was spawned. */
> > @@ -1225,29 +1215,13 @@ static int rcu_torture_barrier_init(void)
> >  		return -ENOMEM;
> >  	for (i = 0; i < n_barrier_cbs; i++) {
> >  		init_waitqueue_head(&barrier_cbs_wq[i]);
> > -		VERBOSE_TOROUT_STRING("Creating rcu_torture_barrier_cbs task");
> > -		barrier_cbs_tasks[i] = kthread_run(rcu_torture_barrier_cbs,
> > -						   (void *)(long)i,
> > -						   "rcu_torture_barrier_cbs");
> > -		if (IS_ERR(barrier_cbs_tasks[i])) {
> > -			ret = PTR_ERR(barrier_cbs_tasks[i]);
> > -			VERBOSE_TOROUT_ERRSTRING("Failed to create rcu_torture_barrier_cbs");
> > -			barrier_cbs_tasks[i] = NULL;
> > +		ret = torture_create_kthread(rcu_torture_barrier_cbs,
> > +					     (void *)(long)i,
> > +					     barrier_cbs_tasks[i]);
> > +		if (ret)
> >  			return ret;
> > -		}
> > -		torture_shuffle_task_register(barrier_cbs_tasks[i]);
> >  	}
> > -	VERBOSE_TOROUT_STRING("Creating rcu_torture_barrier task");
> > -	barrier_task = kthread_run(rcu_torture_barrier, NULL,
> > -				   "rcu_torture_barrier");
> > -	if (IS_ERR(barrier_task)) {
> > -		ret = PTR_ERR(barrier_task);
> > -		VERBOSE_TOROUT_ERRSTRING("Failed to create rcu_torture_barrier");
> > -		barrier_task = NULL;
> > -		return ret;
> > -	}
> > -	torture_shuffle_task_register(barrier_task);
> > -	return 0;
> > +	return torture_create_kthread(rcu_torture_barrier, NULL, barrier_task);
> >  }
> >  
> >  /* Clean up after RCU barrier testing. */
> > @@ -1515,17 +1489,10 @@ rcu_torture_init(void)
> >  
> >  	/* Start up the kthreads. */
> >  
> > -	VERBOSE_TOROUT_STRING("Creating rcu_torture_writer task");
> > -	writer_task = kthread_create(rcu_torture_writer, NULL,
> > -				     "rcu_torture_writer");
> > -	if (IS_ERR(writer_task)) {
> > -		firsterr = PTR_ERR(writer_task);
> > -		VERBOSE_TOROUT_ERRSTRING("Failed to create writer");
> > -		writer_task = NULL;
> > +	firsterr = torture_create_kthread(rcu_torture_writer, NULL,
> > +					  writer_task);
> > +	if (firsterr)
> >  		goto unwind;
> > -	}
> > -	torture_shuffle_task_register(writer_task);
> > -	wake_up_process(writer_task);
> >  	fakewriter_tasks = kzalloc(nfakewriters * sizeof(fakewriter_tasks[0]),
> >  				   GFP_KERNEL);
> >  	if (fakewriter_tasks == NULL) {
> > @@ -1534,16 +1501,10 @@ rcu_torture_init(void)
> >  		goto unwind;
> >  	}
> >  	for (i = 0; i < nfakewriters; i++) {
> > -		VERBOSE_TOROUT_STRING("Creating rcu_torture_fakewriter task");
> > -		fakewriter_tasks[i] = kthread_run(rcu_torture_fakewriter, NULL,
> > -						  "rcu_torture_fakewriter");
> > -		if (IS_ERR(fakewriter_tasks[i])) {
> > -			firsterr = PTR_ERR(fakewriter_tasks[i]);
> > -			VERBOSE_TOROUT_ERRSTRING("Failed to create fakewriter");
> > -			fakewriter_tasks[i] = NULL;
> > +		firsterr = torture_create_kthread(rcu_torture_fakewriter,
> > +						  NULL, fakewriter_tasks[i]);
> > +		if (firsterr)
> >  			goto unwind;
> > -		}
> > -		torture_shuffle_task_register(fakewriter_tasks[i]);
> >  	}
> >  	reader_tasks = kzalloc(nrealreaders * sizeof(reader_tasks[0]),
> >  			       GFP_KERNEL);
> > @@ -1553,28 +1514,16 @@ rcu_torture_init(void)
> >  		goto unwind;
> >  	}
> >  	for (i = 0; i < nrealreaders; i++) {
> > -		VERBOSE_TOROUT_STRING("Creating rcu_torture_reader task");
> > -		reader_tasks[i] = kthread_run(rcu_torture_reader, NULL,
> > -					      "rcu_torture_reader");
> > -		if (IS_ERR(reader_tasks[i])) {
> > -			firsterr = PTR_ERR(reader_tasks[i]);
> > -			VERBOSE_TOROUT_ERRSTRING("Failed to create reader");
> > -			reader_tasks[i] = NULL;
> > +		firsterr = torture_create_kthread(rcu_torture_reader, NULL,
> > +						  reader_tasks[i]);
> > +		if (firsterr)
> >  			goto unwind;
> > -		}
> > -		torture_shuffle_task_register(reader_tasks[i]);
> >  	}
> >  	if (stat_interval > 0) {
> > -		VERBOSE_TOROUT_STRING("Creating rcu_torture_stats task");
> > -		stats_task = kthread_run(rcu_torture_stats, NULL,
> > -					"rcu_torture_stats");
> > -		if (IS_ERR(stats_task)) {
> > -			firsterr = PTR_ERR(stats_task);
> > -			VERBOSE_TOROUT_ERRSTRING("Failed to create stats");
> > -			stats_task = NULL;
> > +		firsterr = torture_create_kthread(rcu_torture_stats, NULL,
> > +						  stats_task);
> > +		if (firsterr)
> >  			goto unwind;
> > -		}
> > -		torture_shuffle_task_register(stats_task);
> >  	}
> >  	if (test_no_idle_hz) {
> >  		firsterr = torture_shuffle_init(shuffle_interval * HZ);
> > @@ -1592,16 +1541,9 @@ rcu_torture_init(void)
> >  		fqs_duration = 0;
> >  	if (fqs_duration) {
> >  		/* Create the fqs thread */
> > -		VERBOSE_TOROUT_STRING("Creating rcu_torture_fqs task");
> > -		fqs_task = kthread_run(rcu_torture_fqs, NULL,
> > -				       "rcu_torture_fqs");
> > -		if (IS_ERR(fqs_task)) {
> > -			firsterr = PTR_ERR(fqs_task);
> > -			VERBOSE_TOROUT_ERRSTRING("Failed to create fqs");
> > -			fqs_task = NULL;
> > +		torture_create_kthread(rcu_torture_fqs, NULL, fqs_task);
> > +		if (firsterr)
> >  			goto unwind;
> > -		}
> > -		torture_shuffle_task_register(fqs_task);
> >  	}
> >  	if (test_boost_interval < 1)
> >  		test_boost_interval = 1;
> > diff --git a/kernel/torture.c b/kernel/torture.c
> > index 6f1c6600d183..94760f0f2923 100644
> > --- a/kernel/torture.c
> > +++ b/kernel/torture.c
> > @@ -180,23 +180,16 @@ torture_onoff(void *arg)
> >   */
> >  int torture_onoff_init(long ooholdoff, long oointerval)
> >  {
> > -#ifdef CONFIG_HOTPLUG_CPU
> > -	int ret;
> > +	int ret = 0;
> >  
> > +#ifdef CONFIG_HOTPLUG_CPU
> >  	onoff_holdoff = ooholdoff;
> >  	onoff_interval = oointerval;
> >  	if (onoff_interval <= 0)
> >  		return 0;
> > -	VERBOSE_TOROUT_STRING("Creating torture_onoff task");
> > -	onoff_task = kthread_run(torture_onoff, NULL, "torture_onoff");
> > -	if (IS_ERR(onoff_task)) {
> > -		ret = PTR_ERR(onoff_task);
> > -		onoff_task = NULL;
> > -		return ret;
> > -	}
> > -	torture_shuffle_task_register(onoff_task);
> > +	ret = torture_create_kthread(torture_onoff, NULL, onoff_task);
> >  #endif /* #ifdef CONFIG_HOTPLUG_CPU */
> > -	return 0;
> > +	return ret;
> >  }
> >  EXPORT_SYMBOL_GPL(torture_onoff_init);
> >  
> > @@ -379,8 +372,6 @@ static int torture_shuffle(void *arg)
> >   */
> >  int torture_shuffle_init(long shuffint)
> >  {
> > -	int ret;
> > -
> >  	shuffle_interval = shuffint;
> >  
> >  	shuffle_idle_cpu = -1;
> > @@ -391,17 +382,7 @@ int torture_shuffle_init(long shuffint)
> >  	}
> >  
> >  	/* Create the shuffler thread */
> > -	VERBOSE_TOROUT_STRING("Creating torture_shuffle task");
> > -	shuffler_task = kthread_run(torture_shuffle, NULL, "torture_shuffle");
> > -	if (IS_ERR(shuffler_task)) {
> > -		ret = PTR_ERR(shuffler_task);
> > -		free_cpumask_var(shuffle_tmp_mask);
> > -		VERBOSE_TOROUT_ERRSTRING("Failed to create shuffler");
> > -		shuffler_task = NULL;
> > -		return ret;
> > -	}
> > -	torture_shuffle_task_register(shuffler_task);
> > -	return 0;
> > +	return torture_create_kthread(torture_shuffle, NULL, shuffler_task);
> >  }
> >  EXPORT_SYMBOL_GPL(torture_shuffle_init);
> >  
> > @@ -483,25 +464,16 @@ static int torture_shutdown(void *arg)
> >   */
> >  int torture_shutdown_init(int ssecs, void (*cleanup)(void))
> >  {
> > -	int ret;
> > +	int ret = 0;
> >  
> >  	shutdown_secs = ssecs;
> >  	torture_shutdown_hook = cleanup;
> >  	if (shutdown_secs > 0) {
> > -		VERBOSE_TOROUT_STRING("Creating torture_shutdown task");
> >  		shutdown_time = jiffies + shutdown_secs * HZ;
> > -		shutdown_task = kthread_create(torture_shutdown, NULL,
> > -					       "torture_shutdown");
> > -		if (IS_ERR(shutdown_task)) {
> > -			ret = PTR_ERR(shutdown_task);
> > -			VERBOSE_TOROUT_ERRSTRING("Failed to create shutdown");
> > -			shutdown_task = NULL;
> > -			return ret;
> > -		}
> > -		torture_shuffle_task_register(shutdown_task);
> > -		wake_up_process(shutdown_task);
> > +		ret = torture_create_kthread(torture_shutdown, NULL,
> > +					     shutdown_task);
> >  	}
> > -	return 0;
> > +	return ret;
> >  }
> >  EXPORT_SYMBOL_GPL(torture_shutdown_init);
> >  
> > @@ -595,16 +567,8 @@ int torture_stutter_init(int s)
> >  	int ret;
> >  
> >  	stutter = s;
> > -	VERBOSE_TOROUT_STRING("Creating torture_stutter task");
> > -	stutter_task = kthread_run(torture_stutter, NULL, "torture_stutter");
> > -	if (IS_ERR(stutter_task)) {
> > -		ret = PTR_ERR(stutter_task);
> > -		VERBOSE_TOROUT_ERRSTRING("Failed to create stutter");
> > -		stutter_task = NULL;
> > -		return ret;
> > -	}
> > -	torture_shuffle_task_register(stutter_task);
> > -	return 0;
> > +	ret = torture_create_kthread(torture_stutter, NULL, stutter_task);
> > +	return ret;
> >  }
> >  EXPORT_SYMBOL_GPL(torture_stutter_init);
> >  
> > @@ -714,3 +678,25 @@ void torture_kthread_stopping(char *title)
> >  	}
> >  }
> >  EXPORT_SYMBOL_GPL(torture_kthread_stopping);
> > +
> > +/*
> > + * Create a generic torture kthread that is immediately runnable.  If you
> > + * need the kthread to be stopped so that you can do something to it before
> > + * it starts, you will need to open-code your own.
> > + */
> > +int _torture_create_kthread(int (*fn)(void *arg), void *arg, char *s, char *m,
> > +			    char *f, struct task_struct **tp)
> > +{
> > +	int ret = 0;
> > +
> > +	VERBOSE_TOROUT_STRING(m);
> > +	*tp = kthread_run(fn, arg, s);
> > +	if (IS_ERR(*tp)) {
> > +		ret = PTR_ERR(*tp);
> > +		VERBOSE_TOROUT_ERRSTRING(f);
> > +		*tp = NULL;
> > +	}
> > +	torture_shuffle_task_register(*tp);
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(_torture_create_kthread);
> > -- 
> > 1.8.1.5
> > 
> 

