Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab3FQAJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 20:09:14 -0400
Received: from ozlabs.org ([203.10.76.45]:43661 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557Ab3FQAJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 20:09:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: A question on RCU vs. preempt-RCU
In-Reply-To: <20130616023611.GA19863@htj.dyndns.org>
References: <20130616023611.GA19863@htj.dyndns.org>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Sun, 16 Jun 2013 16:16:15 +0930
Message-ID: <8761xer1s8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:
> I've been running some performance tests with different preemption
> levels and, with CONFIG_PREEMPT, the percpu ref could be slower by
> around 10% or at the worst contrived case maybe even close to 20% when
> compared to simple atomic_t on a single CPU (when hit by multiple CPUs
> concurrently, it of course destroys atomic_t).  Most of the slow down
> seems to come from the preempt tree RCU calls and there no longer
> seems to be a way to opt out of that RCU implementation when
> CONFIG_PREEMPT.
>
> For most use cases, the trade-off should be fine.  With any kind of
> cross-cpu traffic, which there usually will be, it should be an easy
> win for the percpu-refcount even when CONFIG_PREEMPT; however, I've
> been looking to replace the module ref with the generic one and the
> performance degradation there has low but existing possibility of
> being noticeable in some edge use cases.

I'm confused: is it actually 10% slower than the existing module
refcount code, or 10% slower than atomic inc?

> We can convert the percpu-refcount to use preempt_disable/enable()
> paired with call_rcu_sched() but IIUC that would have latency
> implications from the callback processing side, right?  Given that
> module ref killing would be very low-frequency, it shouldn't
> contribute significant amount of callbacks but I'd like to avoid
> providing two separate implementations if at all possible.
>
> So, what would be the right thing to do here?  How bad would
> converting percpu-refcount to sched-RCU by default be?  Would the
> extra overhead on module ref be acceptable when CONFIG_PREEMPT?
> What do you guys think?

CONFIG_PREEMPT, now with more preempt!  Sure, that has a cost, but
you're arguably fixing a bug.

If we want to improve CONFIG_PREEMPT performance, we can probably use a
trick I wanted to try long ago:

1) Use a per-cpu counter rather than a per-task counter for preempt.
2) Lay out preempt_counter so it covers NR_CPU pages, one per page.
3) When you want to preempt a CPU and counter isn't zero, make the page RO.
4) Handle preemption enable in the fault handler.

Then there's no branch in preempt_enable().

At a glance, the same trick could apply to t->rcu_read_unlock_special,
but I'd have to offload that to my RCU coprocessor.  Paul? :)

Cheers,
Rusty.
