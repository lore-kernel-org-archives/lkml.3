Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030201Ab3AYAvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:51:51 -0500
Received: from mail-qe0-f46.google.com ([209.85.128.46]:40035 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab3AYAvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:51:44 -0500
Date: Thu, 24 Jan 2013 16:51:36 -0800
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu, Oleg Nesterov <oleg@redhat.com>,
        srivatsa.bhat@linux.vnet.ibm.com, Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 23/32] Generic dynamic per cpu refcounting
Message-ID: <20130125005136.GE2373@mtj.dyndns.org>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-26-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356573611-18590-26-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing percpu / rcu crowd)

Hello, Kent.

On Wed, Dec 26, 2012 at 06:00:02PM -0800, Kent Overstreet wrote:
> This implements a refcount with similar semantics to
> atomic_get()/atomic_dec_and_test(), that starts out as just an atomic_t
> but dynamically switches to per cpu refcounting when the rate of
> gets/puts becomes too high.

I'm not sure this is necessary.  Percpu memory is expensive but not
that expensive.  Perpcu memories are tightly packed and if you
allocate, say, 4 bytes, it's really gonna be 4 bytes for each possible
CPU, and the number of possible CPUs is determined during boot to the
number of CPUs the platform may have while booted.  ie. On machines w/
8 CPU threads which don't have extra CPU sockets or don't support CPU
hotplugging (most don't), nr_possible_cpus would exactly be 8 and you
would be allocating 32 bytes of memory per each 4 byte percpu
allocation.

Memory size usually having very strong correlation with the number of
CPUs on the system, it usually isn't worth optimizing out percpu
allocation like this.  Especially not for a single counter.

Maybe this one is way more ambitious than I think but it seems quite a
bit over engineered.

> It also implements two stage shutdown, as we need it to tear down the
> percpu counts. Before dropping the initial refcount, you must call
> percpu_ref_kill(); this puts the refcount in "shutting down mode" and
> switches back to a single atomic refcount with the appropriate barriers
> (synchronize_rcu()).

Maybe if we have tryget() which only succeeds if the counter is alive,
we can replace moulde refcnt with this?  Rusty?

> +static void percpu_ref_alloc(struct percpu_ref *ref, unsigned __user *pcpu_count)
> +{
> +	unsigned __percpu *new;
> +	unsigned long last = (unsigned long) pcpu_count;
> +	unsigned long now = jiffies;
> +
> +	now <<= PCPU_STATUS_BITS;
> +	now |= PCPU_REF_NONE;
> +
> +	if (now - last <= HZ << PCPU_STATUS_BITS) {
> +		rcu_read_unlock();
> +		new = alloc_percpu(unsigned);
> +		rcu_read_lock();

I suppose RCU is used to make sure the dying status is visible while
trying to drain percpu counters?  Requiring rcu locking for refcnt is
very unusure and it would probably be better to use
synchronize_sched[_expedited]() instead in combination w/ preemp or
irq flipping.

> +		if (!new)
> +			goto update_time;
> +
> +		BUG_ON(((unsigned long) new) & PCPU_STATUS_MASK);
> +
> +		if (cmpxchg(&ref->pcpu_count, pcpu_count, new) != pcpu_count)
> +			free_percpu(new);
> +		else
> +			pr_debug("created");
> +	} else {
> +update_time:	new = (void *) now;
> +		cmpxchg(&ref->pcpu_count, pcpu_count, new);
> +	}
> +}

The above function needs a lot more documentation on synchronization
and just general operation.

Overall, I don't know.  It feels quite over-engineered.  I really
don't think dynamic allocation is justified.  It also makes the
interface prone to misuse.  It'll be easy to have mixed alloc and
noalloc sites and then lose alloc ones or just foget about the
distinction and end up with refcnts which never convert to percpu one
and there will be no way to easily identify those.

Thanks.

-- 
tejun
