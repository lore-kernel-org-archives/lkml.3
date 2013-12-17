Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab3LQXtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 18:49:20 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:55683 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab3LQXtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 18:49:19 -0500
Date: Wed, 18 Dec 2013 00:49:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 03/13] rcu: Exclude all potential timekeepers from
 sysidle detection
Message-ID: <20131217234913.GB18689@localhost.localdomain>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-4-git-send-email-fweisbec@gmail.com>
 <20131217232714.GD19211@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217232714.GD19211@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 03:27:14PM -0800, Paul E. McKenney wrote:
> On Tue, Dec 17, 2013 at 11:51:22PM +0100, Frederic Weisbecker wrote:
> > The purpose of the full system idle detection is to notify the CPU
> > handling the timekeeping when the rest of the system is idle so that it
> > can sleep when nobody needs the jiffies nor GTOD to be maintained.
> > 
> > Now this machinery excludes CPU 0 itself from the range of the idle
> > detection because if CPU 0 has any non-idle task to execute, it is going
> > to restart its own tick since it's guaranteed to be outside the full
> > dynticks range. And as it is the only eligible timekeeper when
> > CONFIG_NO_HZ_FULL=y anyway, it can handle the timekeeping duty for
> > and by itself.
> > 
> > Still we also plan to extend the timekeepers affinity and allow every CPU
> > outside the full dynticks range to handle the timekeeping duty, not just
> > CPU 0.
> > 
> > So once we reach that step, we can state that all CPUs that are not
> > full dynticks can be excluded from the full system idle detection,
> > simply because those CPUs share the same property than CPU 0 today. When
> > a non full dynticks CPU needs to run some busy task, it restarts its
> > tick and handles the timekeeping duty for its own needs as is currently
> > done under CONFIG_NO_HZ_IDLE=y.
> > 
> > To prepare for this support in the sysidle detection, we can use the
> > tick_timekeeping_cpu() API which checks if a CPU is allowed to handle
> > timekeeping duty. If so we can conclude that it's not full dynticks and
> > it can maintain timekeeping by itself and as such it can be excluded
> > from the sysidle detection.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: John Stultz <john.stultz@linaro.org>
> > Cc: Alex Shi <alex.shi@linaro.org>
> > Cc: Kevin Hilman <khilman@linaro.org>
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Thanks!

> 
> A few comments below as well.
> 
> > ---
> >  kernel/rcu/tree_plugin.h | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > index 6abb03d..08004da 100644
> > --- a/kernel/rcu/tree_plugin.h
> > +++ b/kernel/rcu/tree_plugin.h
> 
> The rcu_sysidle_force_exit() function uses tick_do_timer_cpu, but
> presumably needs to continue doing so in order to whack the right
> CPU over the head.  I am happy to defer worrying about the interaction
> with multiple timekeeping CPUs for the moment.  ;-)

So yeah, I changed that in "nohz: Wake up timekeeper on exit from sysidle state".
We always target CPU 0 for the IPI.

That's to start simple as CPU 0 can't be offlined. But we certainly want
to optimize that by kicking a potential timekeeper that is not idle.

But that require a lookup like get_timer_nohz_target() and some safety against
CPU hotplug. So that needs more thought :)

> 
> > @@ -2539,7 +2539,7 @@ static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
> >  	 * invoke rcu_sysidle_force_exit() directly if it does anything
> >  	 * more than take a scheduling-clock interrupt.
> >  	 */
> > -	if (smp_processor_id() == tick_do_timer_cpu)
> > +	if (tick_timekeeping_cpu(smp_processor_id()))
> >  		return;
> > 
> >  	/* Update system-idle state: We are clearly no longer fully idle! */
> > @@ -2563,10 +2563,10 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
> >  	 * is an offline or the timekeeping CPU, nothing to do.
> >  	 */
> >  	if (!*isidle || rdp->rsp != rcu_sysidle_state ||
> > -	    cpu_is_offline(rdp->cpu) || rdp->cpu == tick_do_timer_cpu)
> > +	    cpu_is_offline(rdp->cpu) || tick_timekeeping_cpu(rdp->cpu))
> >  		return;
> >  	if (rcu_gp_in_progress(rdp->rsp))
> > -		WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu);
> > +		WARN_ON_ONCE(!tick_timekeeping_cpu(smp_processor_id()));
> > 
> >  	/* Pick up current idle and NMI-nesting counter and check. */
> >  	cur = atomic_read(&rdtp->dynticks_idle);
> 
> The rcu_bind_gp_kthread() uses tick_do_timer_cpu to figure out where
> to run.  Is there some CPU mask that it should use instead once there
> can be multiple timekeeping CPUs?

Good point, we'll need to build one, or use ~nohz_full_mask

Thanks.

> 
> > @@ -2729,7 +2729,7 @@ bool rcu_sys_is_idle(void)
> >  	static struct rcu_sysidle_head rsh;
> >  	int rss = ACCESS_ONCE(full_sysidle_state);
> > 
> > -	if (WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu))
> > +	if (WARN_ON_ONCE(!tick_timekeeping_cpu(smp_processor_id())))
> >  		return false;
> > 
> >  	/* Handle small-system case by doing a full scan of CPUs. */
> > -- 
> > 1.8.3.1
> > 
> 
