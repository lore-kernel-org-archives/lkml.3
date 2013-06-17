Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab3FQSUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:20:32 -0400
Received: from mail-ye0-f173.google.com ([209.85.213.173]:61702 "EHLO
	mail-ye0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab3FQSUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:20:30 -0400
Date: Mon, 17 Jun 2013 11:20:23 -0700
From: Tejun Heo <tj@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: A question on RCU vs. preempt-RCU
Message-ID: <20130617182023.GH32663@mtj.dyndns.org>
References: <20130616023611.GA19863@htj.dyndns.org>
 <8761xer1s8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761xer1s8.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rusty.

On Sun, Jun 16, 2013 at 04:16:15PM +0930, Rusty Russell wrote:
> > For most use cases, the trade-off should be fine.  With any kind of
> > cross-cpu traffic, which there usually will be, it should be an easy
> > win for the percpu-refcount even when CONFIG_PREEMPT; however, I've
> > been looking to replace the module ref with the generic one and the
> > performance degradation there has low but existing possibility of
> > being noticeable in some edge use cases.
> 
> I'm confused: is it actually 10% slower than the existing module
> refcount code, or 10% slower than atomic inc?

Heh, sorry about the confusion.  I was comparing percpu_ref to
atomic_t and then worrying about the rcu flipping overhead as it
definitely seemed higher than flipping preemption.  As I wrote in a
reply to Paul, if I compare perpcu-ref with normal RCU against
RCU-sched, the performance difference is around 18% in favor of
RCU-sched.

> CONFIG_PREEMPT, now with more preempt!  Sure, that has a cost, but
> you're arguably fixing a bug.

It seems that using RCU-sched is the right flavor for perpcu_ref.  In
theory, we shouldn't see any performance degradation when converting
module ref to percpu_ref.

> If we want to improve CONFIG_PREEMPT performance, we can probably use a
> trick I wanted to try long ago:

So, this is a slight digression.

> 1) Use a per-cpu counter rather than a per-task counter for preempt.
> 2) Lay out preempt_counter so it covers NR_CPU pages, one per page.
> 3) When you want to preempt a CPU and counter isn't zero, make the page RO.
> 4) Handle preemption enable in the fault handler.
> 
> Then there's no branch in preempt_enable().

Buth yeah, interesting trick.  We'll be doing IPIs, flushing TLB and
taking faults until it hits zero.  It'll all depend on the frequency
of preemption but given that branches don't tend to be too expensive
on modern processors, maybe it'd be a bit too hairy for possibly
marginal gain?

Thanks.

-- 
tejun
