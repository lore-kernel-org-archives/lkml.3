Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab3HTJ6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:58:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:46146 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab3HTJ6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:58:43 -0400
X-IronPort-AV: E=Sophos;i="4.89,919,1367942400"; 
   d="scan'208";a="8250242"
Message-ID: <52133EBF.3020605@cn.fujitsu.com>
Date: Tue, 20 Aug 2013 18:02:39 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@surriel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH tip/core/rcu 1/5] rcu: Add duplicate-callback tests to
 rcutorture
References: <20130818022453.GA3475@linux.vnet.ibm.com> <1376967074-32530-1-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1376967074-32530-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/20 17:56:30,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/20 17:56:44,
	Serialize complete at 2013/08/20 17:56:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 10:51 AM, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> This commit adds a object_debug option to rcutorture to allow the
> debug-object-based checks for duplicate call_rcu() invocations to
> be deterministically tested.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Sedat Dilek <sedat.dilek@gmail.com>
> Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> [ paulmck: Banish mid-function ifdef, more or less per Josh Triplett. ]
> ---
>  kernel/rcutorture.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index 3d936f0f..f5cf2bb 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -66,6 +66,7 @@ static int fqs_duration;	/* Duration of bursts (us), 0 to disable. */
>  static int fqs_holdoff;		/* Hold time within burst (us). */
>  static int fqs_stutter = 3;	/* Wait time between bursts (s). */
>  static int n_barrier_cbs;	/* Number of callbacks to test RCU barriers. */
> +static int object_debug;	/* Test object-debug double call_rcu()?. */
>  static int onoff_interval;	/* Wait time between CPU hotplugs, 0=disable. */
>  static int onoff_holdoff;	/* Seconds after boot before CPU hotplugs. */
>  static int shutdown_secs;	/* Shutdown time (s).  <=0 for no shutdown. */
> @@ -100,6 +101,8 @@ module_param(fqs_stutter, int, 0444);
>  MODULE_PARM_DESC(fqs_stutter, "Wait time between fqs bursts (s)");
>  module_param(n_barrier_cbs, int, 0444);
>  MODULE_PARM_DESC(n_barrier_cbs, "# of callbacks/kthreads for barrier testing");
> +module_param(object_debug, int, 0444);
> +MODULE_PARM_DESC(object_debug, "Enable debug-object double call_rcu() testing");
>  module_param(onoff_interval, int, 0444);
>  MODULE_PARM_DESC(onoff_interval, "Time between CPU hotplugs (s), 0=disable");
>  module_param(onoff_holdoff, int, 0444);
> @@ -1934,6 +1937,46 @@ rcu_torture_cleanup(void)
>  		rcu_torture_print_module_parms(cur_ops, "End of test: SUCCESS");
>  }
>  
> +#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
> +static void rcu_torture_leak_cb(struct rcu_head *rhp)
> +{
> +}
> +
> +static void rcu_torture_err_cb(struct rcu_head *rhp)
> +{
> +	/* This -might- happen due to race conditions, but is unlikely. */
> +	pr_alert("rcutorture: duplicated callback was invoked.\n");
> +}
> +#endif /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
> +
> +/*
> + * Verify that double-free causes debug-objects to complain, but only
> + * if CONFIG_DEBUG_OBJECTS_RCU_HEAD=y.  Otherwise, say that the test
> + * cannot be carried out.
> + */
> +static void rcu_test_debug_objects(void)
> +{
> +#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
> +	struct rcu_head rh1;
> +	struct rcu_head rh2;
> +
> +	init_rcu_head_on_stack(&rh1);
> +	init_rcu_head_on_stack(&rh2);
> +	pr_alert("rcutorture: WARN: Duplicate call_rcu() test starting.\n");
> +	local_irq_disable(); /* Make it hard to finish grace period. */

you can use rcu_read_lock() directly.

> +	call_rcu(&rh1, rcu_torture_leak_cb); /* start grace period. */
> +	call_rcu(&rh2, rcu_torture_err_cb);
> +	call_rcu(&rh2, rcu_torture_err_cb); /* duplicate callback. */
> +	local_irq_enable();
> +	rcu_barrier();
> +	pr_alert("rcutorture: WARN: Duplicate call_rcu() test complete.\n");
> +	destroy_rcu_head_on_stack(&rh1);
> +	destroy_rcu_head_on_stack(&rh2);
> +#else /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
> +	pr_alert("rcutorture: !CONFIG_DEBUG_OBJECTS_RCU_HEAD, not testing duplicate call_rcu()\n");
> +#endif /* #else #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
> +}
> +
>  static int __init
>  rcu_torture_init(void)
>  {
> @@ -2163,6 +2206,8 @@ rcu_torture_init(void)
>  		firsterr = retval;
>  		goto unwind;
>  	}
> +	if (object_debug)
> +		rcu_test_debug_objects();
>  	rcutorture_record_test_transition();
>  	mutex_unlock(&fullstop_mutex);
>  	return 0;

