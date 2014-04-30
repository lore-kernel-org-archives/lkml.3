Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945AbaD3Qzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:55:40 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51300 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933786AbaD3Qzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:55:38 -0400
Date: Wed, 30 Apr 2014 09:55:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dipankar Sarma <dipankar@in.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC 09/16] kgr: mark task_safe in some kthreads
Message-ID: <20140430165532.GS8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
 <1398868249-26169-10-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398868249-26169-10-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14043016-1542-0000-0000-0000017502C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 04:30:42PM +0200, Jiri Slaby wrote:
> Some threads do not use kthread_should_stop. Before we enable a
> kthread support in kgr, we must make sure all those mark themselves
> safe explicitly.

Would it make sense to bury kgr_task_safe() in wait_event_interruptible()
and friends?  The kgr_task_safe() implementation looks pretty lightweight,
so it should not be a performance problem.

One reason might this might be a bad idea is that there are calls to
wait_event_interruptible() all over the place, which might therefore
constrain where grafting could be safely done.  That would be fair enough,
but does that also imply new constraints on where kthread_should_stop()
can be invoked?  Any new constraints might not be a big deal given that
a very large fraction of the kthreads (and maybe all of them) invoke
kthread_should_stop() from their top-level function, but would be good
to call out.

So, what is the story?

							Thanx, Paul

> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Dipankar Sarma <dipankar@in.ibm.com>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: Tejun Heo <tj@kernel.org>
> ---
>  drivers/base/devtmpfs.c  | 1 +
>  fs/jbd2/journal.c        | 2 ++
>  fs/notify/mark.c         | 5 ++++-
>  kernel/hung_task.c       | 5 ++++-
>  kernel/kthread.c         | 3 +++
>  kernel/rcu/tree.c        | 6 ++++--
>  kernel/rcu/tree_plugin.h | 9 +++++++--
>  kernel/workqueue.c       | 1 +
>  8 files changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
> index 25798db14553..c7d52d1b8c9c 100644
> --- a/drivers/base/devtmpfs.c
> +++ b/drivers/base/devtmpfs.c
> @@ -387,6 +387,7 @@ static int devtmpfsd(void *p)
>  	sys_chroot(".");
>  	complete(&setup_done);
>  	while (1) {
> +		kgr_task_safe(current);
>  		spin_lock(&req_lock);
>  		while (requests) {
>  			struct req *req = requests;
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 67b8e303946c..1b9c4c2e014a 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -43,6 +43,7 @@
>  #include <linux/backing-dev.h>
>  #include <linux/bitops.h>
>  #include <linux/ratelimit.h>
> +#include <linux/sched.h>
> 
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/jbd2.h>
> @@ -260,6 +261,7 @@ loop:
>  			write_lock(&journal->j_state_lock);
>  		}
>  		finish_wait(&journal->j_wait_commit, &wait);
> +		kgr_task_safe(current);
>  	}
> 
>  	jbd_debug(1, "kjournald2 wakes\n");
> diff --git a/fs/notify/mark.c b/fs/notify/mark.c
> index 923fe4a5f503..a74b6175e645 100644
> --- a/fs/notify/mark.c
> +++ b/fs/notify/mark.c
> @@ -82,6 +82,7 @@
>  #include <linux/kthread.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
> +#include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
>  #include <linux/srcu.h>
> @@ -355,7 +356,9 @@ static int fsnotify_mark_destroy(void *ignored)
>  			fsnotify_put_mark(mark);
>  		}
> 
> -		wait_event_interruptible(destroy_waitq, !list_empty(&destroy_list));
> +		wait_event_interruptible(destroy_waitq, ({
> +					kgr_task_safe(current);
> +					!list_empty(&destroy_list); }));
>  	}
> 
>  	return 0;
> diff --git a/kernel/hung_task.c b/kernel/hung_task.c
> index 06bb1417b063..b5f85bff2509 100644
> --- a/kernel/hung_task.c
> +++ b/kernel/hung_task.c
> @@ -14,6 +14,7 @@
>  #include <linux/kthread.h>
>  #include <linux/lockdep.h>
>  #include <linux/export.h>
> +#include <linux/sched.h>
>  #include <linux/sysctl.h>
>  #include <linux/utsname.h>
>  #include <trace/events/sched.h>
> @@ -227,8 +228,10 @@ static int watchdog(void *dummy)
>  	for ( ; ; ) {
>  		unsigned long timeout = sysctl_hung_task_timeout_secs;
> 
> -		while (schedule_timeout_interruptible(timeout_jiffies(timeout)))
> +		while (schedule_timeout_interruptible(timeout_jiffies(timeout))) {
> +			kgr_task_safe(current);
>  			timeout = sysctl_hung_task_timeout_secs;
> +		}
> 
>  		if (atomic_xchg(&reset_hung_task, 0))
>  			continue;
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 9a130ec06f7a..08b979dad619 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -78,6 +78,8 @@ static struct kthread *to_live_kthread(struct task_struct *k)
>   */
>  bool kthread_should_stop(void)
>  {
> +	kgr_task_safe(current);
> +
>  	return test_bit(KTHREAD_SHOULD_STOP, &to_kthread(current)->flags);
>  }
>  EXPORT_SYMBOL(kthread_should_stop);
> @@ -497,6 +499,7 @@ int kthreadd(void *unused)
>  		if (list_empty(&kthread_create_list))
>  			schedule();
>  		__set_current_state(TASK_RUNNING);
> +		kgr_task_safe(current);
> 
>  		spin_lock(&kthread_create_lock);
>  		while (!list_empty(&kthread_create_list)) {
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index 0c47e300210a..5dddedacfc06 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -1593,9 +1593,10 @@ static int __noreturn rcu_gp_kthread(void *arg)
>  			trace_rcu_grace_period(rsp->name,
>  					       ACCESS_ONCE(rsp->gpnum),
>  					       TPS("reqwait"));
> -			wait_event_interruptible(rsp->gp_wq,
> +			wait_event_interruptible(rsp->gp_wq, ({
> +						 kgr_task_safe(current);
>  						 ACCESS_ONCE(rsp->gp_flags) &
> -						 RCU_GP_FLAG_INIT);
> +						 RCU_GP_FLAG_INIT; }));
>  			/* Locking provides needed memory barrier. */
>  			if (rcu_gp_init(rsp))
>  				break;
> @@ -1626,6 +1627,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
>  					(!ACCESS_ONCE(rnp->qsmask) &&
>  					 !rcu_preempt_blocked_readers_cgp(rnp)),
>  					j);
> +			kgr_task_safe(current);
>  			/* Locking provides needed memory barriers. */
>  			/* If grace period done, leave loop. */
>  			if (!ACCESS_ONCE(rnp->qsmask) &&
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 962d1d589929..8b383003b228 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -27,6 +27,7 @@
>  #include <linux/delay.h>
>  #include <linux/gfp.h>
>  #include <linux/oom.h>
> +#include <linux/sched.h>
>  #include <linux/smpboot.h>
>  #include "../time/tick-internal.h"
> 
> @@ -1273,7 +1274,8 @@ static int rcu_boost_kthread(void *arg)
>  	for (;;) {
>  		rnp->boost_kthread_status = RCU_KTHREAD_WAITING;
>  		trace_rcu_utilization(TPS("End boost kthread@rcu_wait"));
> -		rcu_wait(rnp->boost_tasks || rnp->exp_tasks);
> +		rcu_wait(({ kgr_task_safe(current);
> +					rnp->boost_tasks || rnp->exp_tasks; }));
>  		trace_rcu_utilization(TPS("Start boost kthread@rcu_wait"));
>  		rnp->boost_kthread_status = RCU_KTHREAD_RUNNING;
>  		more2boost = rcu_boost(rnp);
> @@ -2283,11 +2285,14 @@ static int rcu_nocb_kthread(void *arg)
> 
>  	/* Each pass through this loop invokes one batch of callbacks */
>  	for (;;) {
> +		kgr_task_safe(current);
>  		/* If not polling, wait for next batch of callbacks. */
>  		if (!rcu_nocb_poll) {
>  			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
>  					    TPS("Sleep"));
> -			wait_event_interruptible(rdp->nocb_wq, rdp->nocb_head);
> +			wait_event_interruptible(rdp->nocb_wq, ({
> +						kgr_task_safe(current);
> +						rdp->nocb_head; }));
>  			/* Memory barrier provide by xchg() below. */
>  		} else if (firsttime) {
>  			firsttime = 0;
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 0ee63af30bd1..4b89f1dc0dd8 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2369,6 +2369,7 @@ sleep:
>  	__set_current_state(TASK_INTERRUPTIBLE);
>  	spin_unlock_irq(&pool->lock);
>  	schedule();
> +	kgr_task_safe(current);
>  	goto woke_up;
>  }
> 
> -- 
> 1.9.2
> 

