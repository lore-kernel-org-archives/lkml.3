Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaJVQyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:54:40 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:36358 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbaJVQyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:54:38 -0400
Date: Wed, 22 Oct 2014 09:54:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: lockdep splat in CPU hotplug
Message-ID: <20141022165433.GA22874@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1410211255531.24255@pobox.suse.cz>
 <alpine.LNX.2.00.1410221125280.22681@pobox.suse.cz>
 <20141022143837.GW4977@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022143837.GW4977@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102216-0025-0000-0000-00000589CC3A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 07:38:37AM -0700, Paul E. McKenney wrote:
> On Wed, Oct 22, 2014 at 11:53:49AM +0200, Jiri Kosina wrote:
> > On Tue, 21 Oct 2014, Jiri Kosina wrote:
> > 
> > > Hi,
> > > 
> > > I am seeing the lockdep report below when resuming from suspend-to-disk 
> > > with current Linus' tree (c2661b80609).
> > > 
> > > The reason for CCing Ingo and Peter is that I can't make any sense of one 
> > > of the stacktraces lockdep is providing.
> > > 
> > > Please have a look at the very first stacktrace in the dump, where lockdep 
> > > is trying to explain where cpu_hotplug.lock#2 has been acquired. It seems 
> > > to imply that cpuidle_pause() is taking cpu_hotplug.lock, but that's not 
> > > the case at all.
> > > 
> > > What am I missing?
> > 
> > Okay, reverting 442bf3aaf55a ("sched: Let the scheduler see CPU idle 
> > states") and followup 83a0a96a5f26 ("sched/fair: Leverage the idle state 
> > info when choosing the "idlest" cpu") which depends on it makes the splat 
> > go away.
> > 
> > Just for the sake of testing the hypothesis, I did just the minimal change 
> > below on top of current Linus' tree, and it also makes the splat go away 
> > (of course it's totally incorrect thing to do by itself alone):
> > 
> > diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> > index 125150d..d31e04c 100644
> > --- a/drivers/cpuidle/cpuidle.c
> > +++ b/drivers/cpuidle/cpuidle.c
> > @@ -225,12 +225,6 @@ void cpuidle_uninstall_idle_handler(void)
> >  		initialized = 0;
> >  		wake_up_all_idle_cpus();
> >  	}
> > -
> > -	/*
> > -	 * Make sure external observers (such as the scheduler)
> > -	 * are done looking at pointed idle states.
> > -	 */
> > -	synchronize_rcu();
> >  }
> > 
> >  /**
> > 
> > So indeed 442bf3aaf55a is guilty.
> > 
> > Paul was stating yesterday that it can't be the try_get_online_cpus() in 
> > synchronize_sched_expedited(), as it's doing only trylock. There are 
> > however more places where synchronize_sched_expedited() is acquiring 
> > cpu_hotplug.lock unconditionally by calling put_online_cpus(), so the race 
> > seems real.
> 
> Gah!  So I only half-eliminated the deadlock between
> synchronize_sched_expedited() and CPU hotplug.  Back to the drawing
> board...

Please see below for an untested alleged fix.

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 356450f09c1f..8589b94b005a 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -64,6 +64,8 @@ static struct {
 	 * an ongoing cpu hotplug operation.
 	 */
 	int refcount;
+	/* And allows lockless put_online_cpus(). */
+	atomic_t puts_pending;
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
@@ -113,7 +115,10 @@ void put_online_cpus(void)
 {
 	if (cpu_hotplug.active_writer == current)
 		return;
-	mutex_lock(&cpu_hotplug.lock);
+	if (!mutex_trylock(&cpu_hotplug.lock)) {
+		atomic_inc(&cpu_hotplug.puts_pending);
+		return;
+	}
 
 	if (WARN_ON(!cpu_hotplug.refcount))
 		cpu_hotplug.refcount++; /* try to fix things up */
@@ -155,6 +160,12 @@ void cpu_hotplug_begin(void)
 	cpuhp_lock_acquire();
 	for (;;) {
 		mutex_lock(&cpu_hotplug.lock);
+		if (atomic_read(&cpu_hotplug.puts_pending)) {
+			int delta;
+
+			delta = atomic_xchg(&cpu_hotplug.puts_pending, 0);
+			cpu_hotplug.refcount -= delta;
+		}
 		if (likely(!cpu_hotplug.refcount))
 			break;
 		__set_current_state(TASK_UNINTERRUPTIBLE);

