Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbaCQLSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:18:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57418 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaCQLS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:18:26 -0400
Date: Mon, 17 Mar 2014 12:18:07 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] [RFC] perf: Fix a race between ring_buffer_detach() and
 ring_buffer_wakeup()
Message-ID: <20140317111807.GE27965@twins.programming.kicks-ass.net>
References: <1394199526-6400-1-git-send-email-alexander.shishkin@linux.intel.com>
 <20140313195816.GJ21124@linux.vnet.ibm.com>
 <20140314095033.GP27965@twins.programming.kicks-ass.net>
 <20140314204736.GG21124@linux.vnet.ibm.com>
 <20140314224317.GQ30956@twins.programming.kicks-ass.net>
 <20140314230231.GM21124@linux.vnet.ibm.com>
 <20140315000009.GA28008@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140315000009.GA28008@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> Reported-by: Peter Zijlstra <peterz@infradead.org>

More a requested-by, I'd say.

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> +/**
> + * get_state_synchronize_rcu - Snapshot current RCU state
> + *
> + * Returns a cookie that is used by a later call to cond_synchronize_rcu()
> + * to determine whether or not a full grace period has elapsed in the
> + * meantime.
> + */
> +unsigned long get_state_synchronize_rcu(void)
> +{

/*
 * Make sure this load happens before anything following it; such that
 * ... ?
 */

The way I imaged using this is taking this snapshot after the RCU
operation, such that we err towards seeing a later grace period and
synchronizing too much in stead of seeing an earlier and sync'ing too
little.

Such use would suggest the barrier the other way around.

> +	return smp_load_acquire(&rcu_state->gpnum);
> +}
> +EXPORT_SYMBOL_GPL(get_state_synchronize_rcu);

I can't say I'm excited about that function name; but I'm also
completely lacking in alternatives.

> +
> +/**
> + * cond_synchronize_rcu - Conditionally wait for an RCU grace period
> + *
> + * @oldstate: return value from earlier call to get_state_synchronize_rcu()
> + *
> + * If a full RCU grace period has elapsed since the earlier call to
> + * get_state_synchronize_rcu(), just return.  Otherwise, invoke
> + * synchronize_rcu() to wait for a full grace period.
> + */
> +void cond_synchronize_rcu(unsigned long oldstate)
> +{
> +	unsigned long newstate = smp_load_acquire(&rcu_state->completed);

Again, uncommented barriers; the load_acquire seems to suggest you want
to make sure the sync_rcu() bits happen after this read. But seeing how
sync_rcu() will invariably read the same data again and you get an
address dep this seems somewhat superfluous.

Then again, can't hurt I suppose :-)

> +	if (ULONG_CMP_GE(oldstate, newstate))

So if the observed active gp (oldstate) is ahead or equal to the last
completed gp, then we wait?

I thought the double grace period thing was for preemptible rcu; is it
done here because you don't want to special case the preemptible rcu and
make do with a single implementation?

And I suppose that on wrap around; we do extra sync_rcu() calls, which
can never be wrong.

> +		synchronize_rcu();
> +}
> +EXPORT_SYMBOL_GPL(cond_synchronize_rcu);

