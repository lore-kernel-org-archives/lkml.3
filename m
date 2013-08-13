Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab3HMKbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:31:09 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:58104 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab3HMKbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:31:07 -0400
Date: Tue, 13 Aug 2013 12:30:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] per-cpu preempt_count
Message-ID: <20130813103056.GA2170@gmail.com>
References: <20130812115113.GE27162@twins.programming.kicks-ass.net>
 <CA+55aFznj9WqGa_Qa0B4=5iTio2br54uJG7xkm6otN2sG2P=8w@mail.gmail.com>
 <20130812175830.GB18691@gmail.com>
 <CA+55aFw=S4xxdkKpjQdg77CehBBW6S-13N6-7tq4=-nN_cCUKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw=S4xxdkKpjQdg77CehBBW6S-13N6-7tq4=-nN_cCUKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Aug 12, 2013 at 10:58 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > We could still have the advantages of NEED_RESCHED in preempt_count() by
> > realizing that we only rarely actually set/clear need_resched and mostly
> > read it from the highest freq user, the preempt_enable() check.
> >
> > So we could have it atomic, but do atomic_read() in the preempt_enable()
> > hotpath which wouldn't suck donkey balls, right?
> 
> Wrong. The thing is, the common case for preempt is to increment and 
> decrement the count, not testing it. Exactly because we do this for 
> spinlocks and for rcu read-locked regions.

Indeed, I should have realized that immediately ...

> Now, what we *could* do is to say:
> 
>  - we will use the high bit of the preempt count for NEED_RESCHED
> 
>  - when we set/clear that high bit, we *always* use atomic sequences, 
> and we never change any of the other bits.
> 
>  - we will increment/decrement the other counters, we *only* do so on 
> the local CPU, and we don't use atomic accesses.
> 
> Now, the downside of that is that *because* we don't use atomic accesses 
> for the inc/dec parts, the updates to the high bit can get lost. But 
> because the high bit updates are done with atomics, we know that they 
> won't mess up the actual counting bits, so at least the count is never 
> corrupted.
> 
> And the NEED_RESCHED bit getting lost would be very unusual. That 
> clearly would *not* be acceptable for RT, but it it might be acceptable 
> for "in the unusual case where we want to preempt a thread that was not 
> preemtible, *and* we ended up having the extra unsual case that 
> preemption enable ended up missing the preempt bit, we don't get 
> preempted in a timely manner". It's probably impossible to ever see in 
> practice, and considering that for non-RT use the PREEMPT bit is a 
> "strong hint" rather than anything else, it sounds like it might be 
> acceptable.
> 
> It is obviously *not* going to be acceptable for the RT people, though, 
> but since they do different code sequences _anyway_, that's not really 
> much of an issue.

Hm, this could introduce weird artifacts for code like signal delivery 
(via kick_process()), with occasional high - possibly user noticeable - 
signal delivery latencies.

But we could perhaps do something else and push the overhead into 
resched_task(): instead of using atomics we could use the resched IPI to 
set the local preempt_count(). That way preempt_count() will only ever be 
updated CPU-locally and we could merge need_resched into preempt_count() 
just fine.

[ Some care has to be taken with polling-idle threads: those could simply
  use another signalling mechanism, another field in task struct, no need
  to abuse need_resched for that. ]

We could still _read_ the preempt count non-destructively from other CPUs, 
to avoid having to send a resched IPI for already marked tasks. [ OTOH it 
might be faster to never do that and assume that an IPI has to be sent in 
99.9% of the cases - that would have to be re-measured. ]

Using this method we could have a really lightweight, minimal, percpu 
based preempt count mechanism in all the default fastpath cases, both for 
nested and for non-nested preempt_enable()s.

Thanks,

	Ingo
