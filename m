Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbaCQRaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:30:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38635 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836AbaCQRav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:30:51 -0400
Date: Mon, 17 Mar 2014 18:30:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] [RFC] perf: Fix a race between ring_buffer_detach() and
 ring_buffer_wakeup()
Message-ID: <20140317173038.GK25546@laptop.programming.kicks-ass.net>
References: <1394199526-6400-1-git-send-email-alexander.shishkin@linux.intel.com>
 <20140313195816.GJ21124@linux.vnet.ibm.com>
 <20140314095033.GP27965@twins.programming.kicks-ass.net>
 <20140314204736.GG21124@linux.vnet.ibm.com>
 <20140314224317.GQ30956@twins.programming.kicks-ass.net>
 <20140314230231.GM21124@linux.vnet.ibm.com>
 <20140315000009.GA28008@linux.vnet.ibm.com>
 <20140317111807.GE27965@twins.programming.kicks-ass.net>
 <20140317164815.GF21124@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317164815.GF21124@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 09:48:15AM -0700, Paul E. McKenney wrote:
> Good point, this barrier is a bit obsure.  Here you go:
> 
> 	/*
> 	 * Make sure this load happens before the purportedly
> 	 * time-consuming work between get_state_synchronize_rcu()
> 	 * and cond_synchronize_rcu().
> 	 */
> 
> So all you lose by leaving this barrier out is a slightly higher
> probability of invoking synchronize_rcu() at cond_synchronize_rcu() time.
> And without the barrier there is some chance of the CPU doing the load in
> cond_synchronize_rcu() before this load in get_state_synchronize_rcu().
> Which should be OK, but simpler to exclude this than have to worry about
> counters out of sync.  Besides, you are taking a grace-period delay in
> here somewhere, so the memory barrier is way down in the noise.

Oh sure; expense wasn't my concern. But I always question barriers
without comments, and I couldn't come up with a reason for this one.

> > The way I imaged using this is taking this snapshot after the RCU
> > operation, such that we err towards seeing a later grace period and
> > synchronizing too much in stead of seeing an earlier and sync'ing too
> > little.
> > 
> > Such use would suggest the barrier the other way around.
> 
> Ah, but that ordering happens at the updater's end.  And there
> are in fact memory barriers before and after the increment of
> ->gpnum in rcu_gp_init():
> 
> 	/* Advance to a new grace period and initialize state. */
> 	record_gp_stall_check_time(rsp);
> 	/* Record GP times before starting GP, hence smp_store_release(). */
> 	smp_store_release(&rsp->gpnum, rsp->gpnum + 1);
> 	trace_rcu_grace_period(rsp->name, rsp->gpnum, TPS("start"));
> 	raw_spin_unlock_irq(&rnp->lock);
> 
> 	/* Exclude any concurrent CPU-hotplug operations. */
> 	mutex_lock(&rsp->onoff_mutex);
> 	smp_mb__after_unlock_lock(); /* ->gpnum increment before GP! */
> 
> The smp_store_release() provides the memory barrier before, and the
> smp_mb__after_unlock_lock() provides it after.

That wasn't exactly what I was talking about.

So suppose:

  spin_lock(&lock)
  list_del_rcu(&entry->foo);
  spin_unlock(&lock);

  rcu_stamp = get_state_sync_rcu();

Now we very much want to ensure to get the gpnum _after_ completing that
list_del_rcu(), because if we were to observe the gpnum before it could
complete before and we'd fail to wait long enough.

Now in the above, and with your proposed implementation, there is in
fact no guarantee the load doesn't slip up past the list_del_rcu().

The RELEASE per the spin_unlock() only guarantees the list_del_rcu()
happens before it, but the gpnum load can slip in, and in fact pass over
the list_del_rcu().

> > > +void cond_synchronize_rcu(unsigned long oldstate)
> > > +{
> > > +	unsigned long newstate = smp_load_acquire(&rcu_state->completed);
> > 
> > Again, uncommented barriers; the load_acquire seems to suggest you want
> > to make sure the sync_rcu() bits happen after this read. But seeing how
> > sync_rcu() will invariably read the same data again and you get an
> > address dep this seems somewhat superfluous.
> 
> Not quite!  The get_state_synchronize_rcu() function reads ->gpnum,
> but cond_synchronize_rcu() reads ->completed.  The

I was talking about the synchronize_rcu() call later in
cond_synchronize_rcu().

But looking at its implementation; they don't in fact load either gpnum
or completed.

> > > +	if (ULONG_CMP_GE(oldstate, newstate))
> > 
> > So if the observed active gp (oldstate) is ahead or equal to the last
> > completed gp, then we wait?
> 
> Yep!  I will risk an ASCII diagram:
> 
> 
> 3:	                                                  +----gpnum----+-- ...
> 	                                                  |             |
> 2:	                            +----gpnum----+-------+--completed--+
> 	                            |             |
> 1:	      +----gpnum----+-------+--completed--+
> 	      |             |
> 0:	+-----+--completed--+
> 
> 
> A full RCU grace period happens between a pair of "|"s on the same line.
> By inspection, if your snapshot of ->gpnum is greater than the current
> value of ->completed, a grace period has passed.

OK, so I get the > part, but I'm not sure I get the = part of the above.
The way I read the diagram, when completed matches gpnum the grace
period is done and we don't have to wait anymore.
