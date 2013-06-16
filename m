Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab3FPONn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 10:13:43 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55752 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172Ab3FPONl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 10:13:41 -0400
Date: Sun, 16 Jun 2013 07:13:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: A question on RCU vs. preempt-RCU
Message-ID: <20130616141335.GW5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130616023611.GA19863@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130616023611.GA19863@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061614-7182-0000-0000-00000759EE2B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 07:36:11PM -0700, Tejun Heo wrote:
> Hello, guys.
> 
> Kent recently implemented a generic percpu reference counter.  It's
> scheduled to be merged in the coming merge window and some part of
> cgroup refcnting is already converted to it.
> 
>  https://git.kernel.org/cgit/linux/kernel/git/tj/percpu.git/tree/include/linux/percpu-refcount.h?h=for-3.11
> 
>  https://git.kernel.org/cgit/linux/kernel/git/tj/percpu.git/tree/lib/percpu-refcount.c?h=for-3.11
> 
> It's essentially a generalized form of module refcnting but uses
> regular RCU instead of toggling preemption for local atomicity.
> 
> I've been running some performance tests with different preemption
> levels and, with CONFIG_PREEMPT, the percpu ref could be slower by
> around 10% or at the worst contrived case maybe even close to 20% when
> compared to simple atomic_t on a single CPU (when hit by multiple CPUs
> concurrently, it of course destroys atomic_t).  Most of the slow down
> seems to come from the preempt tree RCU calls and there no longer
> seems to be a way to opt out of that RCU implementation when
> CONFIG_PREEMPT.

CONFIG_TREE_PREEMPT_RCU does have an increment, decrement (sort of),
and check in its rcu_read_lock() and rcu_read_unlock(), which will
add overhead that might well be noticeable compared to CONFIG_TREE_RCU's
zero-code implementation of rcu_read_lock() and rcu_read_unlock().

> For most use cases, the trade-off should be fine.  With any kind of
> cross-cpu traffic, which there usually will be, it should be an easy
> win for the percpu-refcount even when CONFIG_PREEMPT; however, I've
> been looking to replace the module ref with the generic one and the
> performance degradation there has low but existing possibility of
> being noticeable in some edge use cases.
> 
> We can convert the percpu-refcount to use preempt_disable/enable()
> paired with call_rcu_sched() but IIUC that would have latency
> implications from the callback processing side, right?  Given that
> module ref killing would be very low-frequency, it shouldn't
> contribute significant amount of callbacks but I'd like to avoid
> providing two separate implementations if at all possible.

The main source of longer latency from preempt_disable/enable()
(or rcu_read_{,un}lock_sched()) will be on the read side.
The callback-processing is very nearly identical.

> So, what would be the right thing to do here?  How bad would
> converting percpu-refcount to sched-RCU by default be?  Would the
> extra overhead on module ref be acceptable when CONFIG_PREEMPT?
> What do you guys think?

The big question is "how long are the RCU read-side critical sections?"
My guess is that module references can have arbitrarily long lifetimes,
which would argue strongly against use of RCU-sched.  But if the lifetimes
are always short (say, sub-microsecond), then RCU-sched should be fine.

							Thanx, Paul

