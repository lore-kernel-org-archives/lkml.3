Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab3FKVJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 17:09:24 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54747 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab3FKVJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 17:09:23 -0400
Date: Tue, 11 Jun 2013 14:09:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Waiman Long <waiman.long@hp.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, torvalds@linux-foundation.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
Message-ID: <20130611210914.GJ5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <51B748DA.2070306@hp.com>
 <20130611163607.GG5146@linux.vnet.ibm.com>
 <51B76F77.6020004@hp.com>
 <20130611194927.GX5146@linux.vnet.ibm.com>
 <1370984210.9844.225.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370984210.9844.225.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061121-7606-0000-0000-00000C623DFE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 04:56:50PM -0400, Steven Rostedt wrote:
> On Tue, 2013-06-11 at 12:49 -0700, Paul E. McKenney wrote:
> 
> > +config TICKET_LOCK_QUEUED
> > +	bool "Dynamically switch between ticket and queued locking"
> > +	depends on SMP
> > +	default n
> > +	---help---
> > +	  Enable dynamic switching between ticketlock and queued locking
> > +	  on a per-lock basis.  This option will slow down low-contention
> > +	  acquisition and release very slightly (additional conditional
> > +	  in release path), but will provide more efficient operation at
> > +	  high levels of lock contention.  High-contention operation will
> > +	  not be quite as efficient as would be a pure queued lock, but
> > +	  this dynamic approach consumes less memory than queud locks
> > +	  and also runs faster at low levels of contention.
> > +
> > +	  Say "Y" if you are running on a large system with a workload
> > +	  that is likely to result in high levels of contention.
> > +
> > +	  Say "N" if you are unsure.
> > +
> > +config TICKET_LOCK_QUEUED_SWITCH
> > +	int "When to switch from ticket to queued locking"
> > +	depends on TICKET_LOCK_QUEUED
> > +	default 8
> > +	range 3 32
> > +	---help---
> > +	  Specify how many tasks should be spinning on the lock before
> > +	  switching to queued mode.  Systems with low-latency memory/cache
> > +	  interconnects will prefer larger numbers, while extreme low-latency
> > +	  and real-time workloads will prefer a smaller number.  Of course,
> > +	  extreme real-time workloads would be even happier if contention
> > +	  on the locks were reduced to the point that there was never any
> > +	  need for queued locking in the first place.
> 
> Are you sure real-time wants low numbers? I would think that real-time
> would want this off. This is just a way to help prevent cache ping
> ponging, but it adds to non-deterministic behavior. As I mentioned
> before, even though you fixed the thundering herd on setup, once the
> queue is set, then we will get a thundering herd of tasks trying to
> queue itself, and the task that was spinning the longest could very well
> become the one at the end of the FIFO.

Me?  I think that real-time just wants contention to remain low, so that
this sort of thing isn't needed in the first place.  And now that you
mention it, I suppose that is one of the few things that real-time and
real-fast workloads have in common.

But if you had some mixed workload on a large system that was mostly
real-fast, but had a real-time component, and if the real-fast portion
needed TICKET_LOCK_QUEUED=y, then I would guess that the real-time
portion would want a relatively low number for TICKET_LOCK_QUEUED_SWITCH.

							Thanx, Paul

> -- Steve
> 
> 
> 
> > +
> > +	  Take the default if you are unsure.
> > diff --git a/kernel/Makefile b/kernel/Makefile
> 
> 

