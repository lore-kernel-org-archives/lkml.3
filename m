Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab3CUUvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:51:39 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:60928 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3CUUvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:51:38 -0400
Date: Thu, 21 Mar 2013 13:50:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
        geoff@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH] nohz1: Documentation
Message-ID: <20130321205054.GI3637@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1363636794.15703.32@driftwood>
 <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>
 <20130318222548.GG3656@linux.vnet.ibm.com>
 <1363822338.6345.33.camel@gandalf.local.home>
 <20130320235545.GL3637@linux.vnet.ibm.com>
 <0000013d8db514e4-bf492080-82c9-412a-90b8-54ddc1463e4b-000000@email.amazonses.com>
 <20130321171518.GW3637@linux.vnet.ibm.com>
 <0000013d8e3f58ce-0f6ea95f-780a-49c1-a633-5aa0cf3e5040-000000@email.amazonses.com>
 <20130321185821.GF3637@linux.vnet.ibm.com>
 <0000013d8e8d24fd-d2931c45-2722-46d1-8b47-2ef11e21096d-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013d8e8d24fd-d2931c45-2722-46d1-8b47-2ef11e21096d-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032120-2398-0000-0000-00001278B013
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 08:04:08PM +0000, Christoph Lameter wrote:
> On Thu, 21 Mar 2013, Paul E. McKenney wrote:
> 
> > > Yeah doing that right now but I'd like to see it handled without manual
> > > intervention.
> >
> > Given that RCU has no idea where you want them to run, some manual
> > intervention would most likely be required even if RCU spawned them
> > dynamically, right?
> 
> If rcuoXX is a SCHED_OTHER process/thread then the kernel will move it to
> another processor from the one running the SCHED_FIFO task. There would be
> no manual intervention required.

Assuming that the SCHED_FIFO task was running at the time that RCU
decided to spawn the kthread, and assuming that there was at least
one CPU not running a SCHED_FIFO task, agreed.  But these assumptions
do not hold in general.

> > So, again, removing scheduling-clock interrupts in more situations is
> > a good future enhancement.
> 
> The point here is that the check for a single runnable process is wrong
> because it accounts for tasks in all scheduling classes.

Incomplete, yes.  Only a starting point, yes.  Wrong, no.

> It would be better to check if there is only one runnable task in the
> highest scheduling class. That would work and defer the SCHED_OTHER kernel
> threads for the SCHED_FIFO thread.

Agreed, that would be better.  Hopefully we will handle that and other
similar cases at some point.

> I am wondering how you actually can get NOHZ to work right? There is
> always a kernel thread that is scheduled in a couple of ticks.
> 
> I guess what will happens with this patchset is:
> 
> 1. SCHED_FIFO thread begins to run. There is only a single runnable task
> so adaptive tick mode is enabled.

Yep.

> 2. After 2 seconds or so some or other thing needs to run (keventd thread
> needs to run vm statistics f.e.). It becomes runnable. nr_running > 1.
> Adaptive tick mode is disabled? Occurs on my system. Or is there some
> other trick to avoid kernel threads becoming runnable?

Yes, adaptive tick mode would be disabled at that point.

> 3. Now there are 2 runnable processes. The SCHED_FIFO thread continues to
> run with the tick. The kernel thread is also runnable but will not be
> given cpu time since the SCHED_FIFO thread has priority?

Yep.

> So the SCHED_FIFO thread enjoys 2 seconds of no tick time and then ticks
> occur uselessly from there on?

If the SCHED_FIFO thread never sleeps at all, this would be the outcome.
On the other hand, if the SCHED_FIFO thread never sleeps at all, the
various per-CPU kthreads are deferred forever, which might not be so
good long term.

If the SCHED_FIFO thread does sleep at some point, the SCHED_OTHER threads
would run, the CPU would go idle, and then when the SCHED_OTHER thread
started up again, it would start up in adaptive-idle mode.

> I have not been able to consistently get the tick switched off with
> the nohz patchset. How do others use nohz? Is it only usable for short
> periods of less than 2 seconds?

I believe that many other SCHED_FIFO users run their SCHED_FIFO threads
in short bursts to respond to some real-time event.  They would not tend
to have a SCHED_FIFO thread with a busy period exceeding two seconds,
and therefore would be less likely to encounter this issue.

So, how long of busy periods are you contemplating for your SCHED_FIFO
threads?  Is it possible to tune/adjust the offending per-CPU ktheads
to wake up less frequently than that time?

							Thanx, Paul

