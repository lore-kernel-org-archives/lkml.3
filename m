Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbaHMOnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:43:39 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49640 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaHMOni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:43:38 -0400
Date: Wed, 13 Aug 2014 07:43:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v5 tip/core/rcu 15/16] rcu: Make RCU-tasks wait for idle
 tasks
Message-ID: <20140813144332.GW4752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140813081215.GB9918@twins.programming.kicks-ass.net>
 <20140813124818.GQ4752@linux.vnet.ibm.com>
 <20140813134025.GN9918@twins.programming.kicks-ass.net>
 <20140813095132.56d288f2@gandalf.local.home>
 <20140813140705.GO9918@twins.programming.kicks-ass.net>
 <20140813101301.08019895@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813101301.08019895@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081314-0928-0000-0000-00000409A444
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 10:13:01AM -0400, Steven Rostedt wrote:
> On Wed, 13 Aug 2014 16:07:05 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, Aug 13, 2014 at 09:51:32AM -0400, Steven Rostedt wrote:
> > 
> > > I still need to look at the patches, but if this is just for the idle
> > > case, then we don't need it. The idle case can be solved with a simple
> > > sched_on_each_cpu(). I need a way to solve waiting for processes to
> > > finish from a preemption point.
> > > 
> > > That's all I want, and if we can remove the "idle" case and document it
> > > well that it's not covered and a sched_on_each_cpu() may be needed,
> > > then I'm fine with that.
> > > 
> > > 	sched_on_each_cpu(dummy_op);
> > > 	call_rcu_tasks(free_tramp);
> > 
> > Sure, but why not dtrt and push rcu_idle hooks all the way down into the
> > idle drivers if and where appropriate?
> > 
> > There isn't _that_ much idle driver code. Also, some stuff should be
> > cleaned up; we're already calling stop_critical_timings() in the generic
> > idle code, and then calling it again in the cpuidle drivers.
> 
> True, perhaps the rcu code should hook into the stop_critical_timings
> code?

Is that safe given that stop_critical_timings() is invoked around other things?
Let's see...

o	drivers/acpi/acpi_pad.c, power_saving_thread().

	Looks like a kthread that does idle injection.  Currently, RCU
	sees it as not a quiescent state.  Would it kill these guys to
	put in a comment or two about what this is for???

	So adding rcu_idle_enter() and rcu_idle_exit() here might
	actually fix a bug, though it is not clear how long this thing
	actually runs.  If only for a few milliseconds, no harm done.

o	drivers/acpi/processor_idle.c, acpi_idle_do_entry().

	Hmmm...  Is the idle loop really simpler these days?  Or is the
	complexity just better hidden?  :-/

	So acpi_idle_do_entry() is called from several places, will chase
	them down later.  Does stop_critical_timings() nest?

o	drivers/thermal/intel_powerclamp.c, clamp_thread().

	Looks similar to power_saving_thread(), but for thermal control.
	Probably short term, shouldn't be a problem either way.

o	kernel/printk/printk.c, console_cont_flush().

	call_console_drivers() certainly isn't idle.  Might not use
	RCU read sides, but...

o	kernel/printk/printk.c, console_unlock()

	Same as console_cont_flush().

So the first three look OK to hook rcu_idle_enter() and rcu_idle_exit()
into, but the last two don't look so good.

That said, if you are OK not tracing the stuff under stop_critical_timings(),
then I can use the RCU dyntick-idle state and not wake anything up.

							Thanx, Paul

