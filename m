Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbaCRI02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:26:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53183 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbaCRI0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:26:21 -0400
Date: Tue, 18 Mar 2014 09:26:07 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] [RFC] perf: Fix a race between ring_buffer_detach() and
 ring_buffer_wakeup()
Message-ID: <20140318082607.GN25546@laptop.programming.kicks-ass.net>
References: <20140313195816.GJ21124@linux.vnet.ibm.com>
 <20140314095033.GP27965@twins.programming.kicks-ass.net>
 <20140314204736.GG21124@linux.vnet.ibm.com>
 <20140314224317.GQ30956@twins.programming.kicks-ass.net>
 <20140314230231.GM21124@linux.vnet.ibm.com>
 <20140315000009.GA28008@linux.vnet.ibm.com>
 <20140317111807.GE27965@twins.programming.kicks-ass.net>
 <20140317164815.GF21124@linux.vnet.ibm.com>
 <20140317173038.GK25546@laptop.programming.kicks-ass.net>
 <20140318024522.GF4420@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318024522.GF4420@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 07:45:22PM -0700, Paul E. McKenney wrote:
> > > Yep!  I will risk an ASCII diagram:
> > > 
> > > 
> > > 3:	                                                  +----gpnum----+-- ...
> > > 	                                                  |             |
> > > 2:	                            +----gpnum----+-------+--completed--+
> > > 	                            |             |
> > > 1:	      +----gpnum----+-------+--completed--+
> > > 	      |             |
> > > 0:	+-----+--completed--+
> > > 
> > > 
> > > A full RCU grace period happens between a pair of "|"s on the same line.
> > > By inspection, if your snapshot of ->gpnum is greater than the current
> > > value of ->completed, a grace period has passed.
> > 
> > OK, so I get the > part, but I'm not sure I get the = part of the above.
> > The way I read the diagram, when completed matches gpnum the grace
> > period is done and we don't have to wait anymore.
> 
> Absolutely not!  Let's try laying out the scenario:
> 
> 1.	Someone calls get_state_synchronize_rcu() when ->gpnum==->completed==0.
> 	It returns zero.
> 
> 2.	That someone immediately calls cond_synchronize_rcu().  Nothing
> 	has changed, so oldstate==newstate==0.
> 
> 	We had better call synchronize_rcu() in this case!!!

> Make sense?

Yes, should have seen that! Thanks for bearing with me on this.

> ------------------------------------------------------------------------
> 
> rcu: Provide grace-period piggybacking API
> 
> The following pattern is currently not well supported by RCU:
> 
> 1.	Make data element inaccessible to RCU readers.
> 
> 2.	Do work that probably lasts for more than one grace period.
> 
> 3.	Do something to make sure RCU readers in flight before #1 above
>     	have completed.
>     
> Here are some things that could currently be done:
> 
> a.	Do a synchronize_rcu() unconditionally at either #1 or #3 above.
>     	This works, but imposes needless work and latency.
>     
> b.	Post an RCU callback at #1 above that does a wakeup, then
>     	wait for the wakeup at #3.  This works well, but likely results
>     	in an extra unneeded grace period.  Open-coding this is also
>     	a bit more semi-tricky code than would be good.
>     
> This commit therefore adds get_state_synchronize_rcu() and
> cond_synchronize_rcu() APIs.  Call get_state_synchronize_rcu() at #1
> above and pass its return value to cond_synchronize_rcu() at #3 above.
> This results in a call to synchronize_rcu() if no grace period has
> elapsed between #1 and #3, but requires only a load, comparison, and
> memory barrier if a full grace period did elapse.
> 
> Requested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Thanks!

Acked-by: Peter Zijlstra <peterz@infradead.org>
