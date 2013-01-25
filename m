Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3AYBN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 20:13:56 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34954 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab3AYBNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 20:13:49 -0500
Date: Thu, 24 Jan 2013 17:13:45 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu, Oleg Nesterov <oleg@redhat.com>,
        srivatsa.bhat@linux.vnet.ibm.com, Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 23/32] Generic dynamic per cpu refcounting
Message-ID: <20130125011345.GT26407@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-26-git-send-email-koverstreet@google.com>
 <20130125005136.GE2373@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125005136.GE2373@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 04:51:36PM -0800, Tejun Heo wrote:
> (cc'ing percpu / rcu crowd)
> 
> Hello, Kent.
> 
> On Wed, Dec 26, 2012 at 06:00:02PM -0800, Kent Overstreet wrote:
> > This implements a refcount with similar semantics to
> > atomic_get()/atomic_dec_and_test(), that starts out as just an atomic_t
> > but dynamically switches to per cpu refcounting when the rate of
> > gets/puts becomes too high.
> 
> I'm not sure this is necessary.  Percpu memory is expensive but not
> that expensive.  Perpcu memories are tightly packed and if you
> allocate, say, 4 bytes, it's really gonna be 4 bytes for each possible
> CPU, and the number of possible CPUs is determined during boot to the
> number of CPUs the platform may have while booted.  ie. On machines w/
> 8 CPU threads which don't have extra CPU sockets or don't support CPU
> hotplugging (most don't), nr_possible_cpus would exactly be 8 and you
> would be allocating 32 bytes of memory per each 4 byte percpu
> allocation.

You could be right - and I'd be just fine with a simpler version.

I was envisioning something with low enough overhead that we could use
it for the refcounts in struct file and kref/kobject - I've seen both of
those show up in profiles (admittedly with the kobject ref some of it
was stupid usage, but it'd be nice if we could just hit it with a very
big hammer and make the problem go away once and for all).

I'm not sure what the memory overhead would be like if we made all those
refcounts percpu and whether people would find it acceptable.

> Memory size usually having very strong correlation with the number of
> CPUs on the system, it usually isn't worth optimizing out percpu
> allocation like this.  Especially not for a single counter.
> 
> Maybe this one is way more ambitious than I think but it seems quite a
> bit over engineered.

That said, there's not that much more code in this version than the
"always percpu" version, and not really any more overhead in the fast
path (we always need the branch if we're not in percpu mode so we can
shut down).

> > It also implements two stage shutdown, as we need it to tear down the
> > percpu counts. Before dropping the initial refcount, you must call
> > percpu_ref_kill(); this puts the refcount in "shutting down mode" and
> > switches back to a single atomic refcount with the appropriate barriers
> > (synchronize_rcu()).
> 
> Maybe if we have tryget() which only succeeds if the counter is alive,
> we can replace moulde refcnt with this?  Rusty?

Glancing try_module_get(), it looks like that'd correspend to

if (!percpu_ref_dead(ref))
	percpu_ref_get(ref);

with some synchronization. That should be easy.

> > +static void percpu_ref_alloc(struct percpu_ref *ref, unsigned __user *pcpu_count)
> > +{
> > +	unsigned __percpu *new;
> > +	unsigned long last = (unsigned long) pcpu_count;
> > +	unsigned long now = jiffies;
> > +
> > +	now <<= PCPU_STATUS_BITS;
> > +	now |= PCPU_REF_NONE;
> > +
> > +	if (now - last <= HZ << PCPU_STATUS_BITS) {
> > +		rcu_read_unlock();
> > +		new = alloc_percpu(unsigned);
> > +		rcu_read_lock();
> 
> I suppose RCU is used to make sure the dying status is visible while
> trying to drain percpu counters? 

Precisely.

> Requiring rcu locking for refcnt is
> very unusure and it would probably be better to use
> synchronize_sched[_expedited]() instead in combination w/ preemp or
> irq flipping.

I haven't come across synchronize_sched() before - is it less overhead
than synchronize_rcu()? 

> 
> > +		if (!new)
> > +			goto update_time;
> > +
> > +		BUG_ON(((unsigned long) new) & PCPU_STATUS_MASK);
> > +
> > +		if (cmpxchg(&ref->pcpu_count, pcpu_count, new) != pcpu_count)
> > +			free_percpu(new);
> > +		else
> > +			pr_debug("created");
> > +	} else {
> > +update_time:	new = (void *) now;
> > +		cmpxchg(&ref->pcpu_count, pcpu_count, new);
> > +	}
> > +}
> 
> The above function needs a lot more documentation on synchronization
> and just general operation.

I had a quite a bit of code documentation when I was writing the rest of
the documentation for Andrew, and then I flubbed git and lost it. Doh.

I'll rewrite it while it's on my mind, I suppose.

> Overall, I don't know.  It feels quite over-engineered.  I really
> don't think dynamic allocation is justified. 

Dynamic allocation doesn't add that much complexity, imo. For something
small and generic, I think it's worthwhile if it means it can get used
more. But like I said I don't have a strong opinion on the memory
overhead vs. complexity.

> It also makes the
> interface prone to misuse.  It'll be easy to have mixed alloc and
> noalloc sites and then lose alloc ones or just foget about the
> distinction and end up with refcnts which never convert to percpu one
> and there will be no way to easily identify those.

This is true, I'm not a huge fan of the interface.

The way percpu_ref_get() drops and retakes rcu_read_lock() is definitely
ugly. I had an idea when I was last looking at the code for that -
percpu_ref_get() could merely return whether the user should call
percpu_ref_alloc(), and then the caller can do that in the appropriate
context (or skip it if it's in a slowpath and can't).

This would also mean that users could just unconditionally call
percpu_ref_alloc() (or have an init function that does that too).

Just given that the code works and is tested I wasn't in a huge hurry to
screw with it more - sort of prefer to wait and see how it gets used.

Anyways, we can definitely change it.
