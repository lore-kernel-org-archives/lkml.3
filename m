Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab3CUS6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:58:39 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:46374 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3CUS6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:58:38 -0400
Date: Thu, 21 Mar 2013 11:58:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
        geoff@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH] nohz1: Documentation
Message-ID: <20130321185821.GF3637@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com>
 <1363636794.15703.32@driftwood>
 <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>
 <20130318222548.GG3656@linux.vnet.ibm.com>
 <1363822338.6345.33.camel@gandalf.local.home>
 <20130320235545.GL3637@linux.vnet.ibm.com>
 <0000013d8db514e4-bf492080-82c9-412a-90b8-54ddc1463e4b-000000@email.amazonses.com>
 <20130321171518.GW3637@linux.vnet.ibm.com>
 <0000013d8e3f58ce-0f6ea95f-780a-49c1-a633-5aa0cf3e5040-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013d8e3f58ce-0f6ea95f-780a-49c1-a633-5aa0cf3e5040-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032118-7606-0000-0000-000009BB73EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 06:39:09PM +0000, Christoph Lameter wrote:
> On Thu, 21 Mar 2013, Paul E. McKenney wrote:
> 
> > > Why are there multiple rcuo threads? Would a single thread that may be
> > > able to run on multiple cpus not be sufficient?
> >
> > In many cases, this would indeed be sufficient.  However, if you have
> > enough CPUs posting RCU callbacks, then the single thread would become
> > a bottleneck, eventually resulting in an OOM.  Per-CPU kthreads avoid
> > this possibility.
> 
> Spawn another if the load gets too high for a single cpu?
> 
> > That said, if you know that your workload's RCU callbacks could be
> > serviced by a single CPU, you can bind all the rcuo kthreads to a
> > single CPU.
> 
> Yeah doing that right now but I'd like to see it handled without manual
> intervention.

Given that RCU has no idea where you want them to run, some manual
intervention would most likely be required even if RCU spawned them
dynamically, right?

> > > > Again, good point!
> > >
> > > Uggh. That will cause problems and did cause problems when I tried to use
> > > nohz.
> > >
> > > The OS always has some sched other tasks around that become runnable after
> > > a while (like for example the vm statistics update, or the notorious slab
> > > scanning). As long as SCHED_FIFO is active and there is no process in the
> > > same scheduling class then tick needs to be off. Also wish that this would
> > > work with SCHED_OTHER if there is only a single task with a certain renice
> > > value (-10?) and the rest is runnable at lower priorities. Maybe in that
> > > case stop the tick for a longer period and then give the lower priority
> > > tasks a chance to run but then switch off the tick again.
> >
> > These sound to me like good future enhancements.
> >
> > In the meantime, one approach is to bind all these SCHED_OTHER tasks
> > to designated housekeeping CPU(s) that don't run your main workload.
> 
> One cannot bind kevent threads and other per cpu threads to another
> processor. So right now there is no way to avoid this issue.

Yep, my approach works only for those threads that are free to migrate.
Of course, in some cases, you can avoid per-CPU threads running by pinning
interrupts, avoiding certain operations in your workload, and so on.

So, again, removing scheduling-clock interrupts in more situations is
a good future enhancement.

							Thanx, Paul

