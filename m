Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbaILSC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:02:27 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:46422 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaILSCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:02:25 -0400
Date: Fri, 12 Sep 2014 11:02:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 3/9] locktorture: Support mutexes
Message-ID: <20140912180220.GE4775@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
 <1410493224-3312-4-git-send-email-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410493224-3312-4-git-send-email-dave@stgolabs.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091218-3532-0000-0000-000004953253
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 08:40:18PM -0700, Davidlohr Bueso wrote:
> Add a "mutex_lock" torture test. The main difference with the already
> existing spinlock tests is that the latency of the critical region
> is much larger. We randomly delay for (arbitrarily) either 500 ms or,
> otherwise, 25 ms. While this can considerably reduce the amount of
> writes compared to non blocking locks, if run long enough it can have
> the same torturous effect. Furthermore it is more representative of
> mutex hold times and can stress better things like thrashing.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>

One question and one follow-up patch below.

								Thanx, Paul

> ---
>  Documentation/locking/locktorture.txt |  2 ++
>  kernel/locking/locktorture.c          | 41 +++++++++++++++++++++++++++++++++--
>  2 files changed, 41 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/locking/locktorture.txt b/Documentation/locking/locktorture.txt
> index c0ab969..6b1e7ca 100644
> --- a/Documentation/locking/locktorture.txt
> +++ b/Documentation/locking/locktorture.txt
> @@ -40,6 +40,8 @@ torture_type	  Type of lock to torture. By default, only spinlocks will
>  		     o "spin_lock_irq": spin_lock_irq() and spin_unlock_irq()
>  					pairs.
> 
> +		     o "mutex_lock": mutex_lock() and mutex_unlock() pairs.
> +
>  torture_runnable  Start locktorture at module init. By default it will begin
>  		  once the module is loaded.
> 
> diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
> index 8c770b2..414ba45 100644
> --- a/kernel/locking/locktorture.c
> +++ b/kernel/locking/locktorture.c
> @@ -27,6 +27,7 @@
>  #include <linux/kthread.h>
>  #include <linux/err.h>
>  #include <linux/spinlock.h>
> +#include <linux/mutex.h>
>  #include <linux/smp.h>
>  #include <linux/interrupt.h>
>  #include <linux/sched.h>
> @@ -66,7 +67,7 @@ torture_param(bool, verbose, true,
>  static char *torture_type = "spin_lock";
>  module_param(torture_type, charp, 0444);
>  MODULE_PARM_DESC(torture_type,
> -		 "Type of lock to torture (spin_lock, spin_lock_irq, ...)");
> +		 "Type of lock to torture (spin_lock, spin_lock_irq, mutex_lock, ...)");
> 
>  static atomic_t n_lock_torture_errors;
> 
> @@ -206,6 +207,42 @@ static struct lock_torture_ops spin_lock_irq_ops = {
>  	.name		= "spin_lock_irq"
>  };
> 
> +static DEFINE_MUTEX(torture_mutex);
> +
> +static int torture_mutex_lock(void) __acquires(torture_mutex)
> +{
> +	mutex_lock(&torture_mutex);
> +	return 0;
> +}
> +
> +static void torture_mutex_delay(struct torture_random_state *trsp)
> +{
> +	const unsigned long longdelay_ms = 100;
> +
> +	/* We want a long delay occasionally to force massive contention.  */
> +	if (!(torture_random(trsp) %
> +	      (nrealwriters_stress * 2000 * longdelay_ms)))
> +		mdelay(longdelay_ms * 5);

So let's see...  We wait 500 milliseconds about once per 200,000 operations
per writer.  So if we have 5 writers, we wait 500 milliseconds per million
operations.  So each writer will do about 200,000 operations, then there
will be a half-second gap.  But each short operation holds the lock for
20 milliseconds, which takes several hours to work through the million
operations.

So it looks to me like you are in massive contention state either way,
at least until the next stutter interval shows up.

Is that the intent?  Or am I missing something here?

> +	else
> +		mdelay(longdelay_ms / 5);
> +#ifdef CONFIG_PREEMPT
> +	if (!(torture_random(trsp) % (nrealwriters_stress * 20000)))
> +		preempt_schedule();  /* Allow test to be preempted. */
> +#endif
> +}
> +
> +static void torture_mutex_unlock(void) __releases(torture_mutex)
> +{
> +	mutex_unlock(&torture_mutex);
> +}
> +
> +static struct lock_torture_ops mutex_lock_ops = {
> +	.writelock	= torture_mutex_lock,
> +	.write_delay	= torture_mutex_delay,
> +	.writeunlock	= torture_mutex_unlock,
> +	.name		= "mutex_lock"
> +};
> +
>  /*
>   * Lock torture writer kthread.  Repeatedly acquires and releases
>   * the lock, checking for duplicate acquisitions.
> @@ -352,7 +389,7 @@ static int __init lock_torture_init(void)
>  	int i;
>  	int firsterr = 0;
>  	static struct lock_torture_ops *torture_ops[] = {
> -		&lock_busted_ops, &spin_lock_ops, &spin_lock_irq_ops,
> +		&lock_busted_ops, &spin_lock_ops, &spin_lock_irq_ops, &mutex_lock_ops,
>  	};
> 
>  	if (!torture_init_begin(torture_type, verbose, &torture_runnable))
> -- 

And I queued the following patch to catch up the scripting.

------------------------------------------------------------------------

locktorture: Add test scenario for mutex_lock

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/tools/testing/selftests/rcutorture/configs/lock/CFLIST b/tools/testing/selftests/rcutorture/configs/lock/CFLIST
index a061b22d1892..901bafde4588 100644
--- a/tools/testing/selftests/rcutorture/configs/lock/CFLIST
+++ b/tools/testing/selftests/rcutorture/configs/lock/CFLIST
@@ -1 +1,2 @@
 LOCK01
+LOCK02
diff --git a/tools/testing/selftests/rcutorture/configs/lock/LOCK02 b/tools/testing/selftests/rcutorture/configs/lock/LOCK02
new file mode 100644
index 000000000000..1d1da1477fc3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/LOCK02
@@ -0,0 +1,6 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=4
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
diff --git a/tools/testing/selftests/rcutorture/configs/lock/LOCK02.boot b/tools/testing/selftests/rcutorture/configs/lock/LOCK02.boot
new file mode 100644
index 000000000000..5aa44b4f1b51
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/LOCK02.boot
@@ -0,0 +1 @@
+locktorture.torture_type=mutex_lock

