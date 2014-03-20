Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbaCTTIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:08:36 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:38455 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaCTTIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:08:35 -0400
Message-ID: <1395342510.14694.43.camel@buesod1.americas.hpqcorp.net>
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Date: Thu, 20 Mar 2014 12:08:30 -0700
In-Reply-To: <CA+55aFwH2sJKCH6hUf8H-7nMPo8YwFCR6oP8McZ5VpMcGDrYSw@mail.gmail.com>
References: <20140319152619.GB10406@linux.vnet.ibm.com>
	 <20140319154705.GB8557@laptop.programming.kicks-ass.net>
	 <20140319170829.GD8557@laptop.programming.kicks-ass.net>
	 <20140320053350.GB30295@linux.vnet.ibm.com>
	 <1395295019.2612.11.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFzP60Ucn0snFchHNw2tOnS6HYp-6n+f+9nxrbTPw8fTfQ@mail.gmail.com>
	 <1395335909.14694.15.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFwH2sJKCH6hUf8H-7nMPo8YwFCR6oP8McZ5VpMcGDrYSw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 11:36 -0700, Linus Torvalds wrote:
> On Thu, Mar 20, 2014 at 10:18 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> >
> > Comparing with the patch I sent earlier this morning, looks equivalent,
> > and fwiw, passes my initial qemu bootup, which is the first way of
> > detecting anything stupid going on.
> >
> > So, Srikar, please try this patch out, as opposed to mine, you don't
> > have to first revert the commit in question.
> 
> Ok, so it boots for me too, so hopefully it isn't totally broken.
> 
> However, since it's just closing a race, and since getting the counts
> wrong should easily result in it *working* but always taking the slow
> path (for example), I'd really like people to also verify that it
> fixes the actual performance issue (ie assuming it fixes powerpc
> behavior for Srikar, I'd like to get it double-checked that it also
> avoids the spinlock in the common case). 

Oh, it does. This atomics technique was tested at a customer's site and
ready for upstream. To refresh, we were originally seeing massive
contention on the hb->lock and an enormous amounts of 0 returns from
futex_wake, indicating that spinners where piling up just to realize
that the plist was empty! While I don't have any official numbers, I can
confirm that perf showed that this issue was addressed with the atomics
variant. Yes, such pathological behavior shows problems in the userspace
locking primitives design/implementation, but allowing the kernel not to
be affected by suboptimal uses of futexes is definitely a plus. 

As tglx suggested at the time, I also made sure that adding the barriers
when doing the key refcounting didn't impose any serious restrictions to
performance either.

Now, what at the time required re-testing everything was when you
suggested replacing this approach with a more elegant spin is locked
test. Both approaches showed pretty much identical performance (and
correctness, at least on x86). And to this day shows *significant* less
time spent in kernel space dealing with futexes.


> Because if the
> increment/decrement pairings end up being wrong, we could have a
> situation where the waiter count just ends up bogus, and it all works
> from a correctness standpoint but not from the intended performance
> optimization.
> 
> No way I can test that sanely on my single-socket machine. Davidlohr?

Not this patch, no :( -- we could never blindly reproduce the customer's
workload. The only patch that I was able to create test cases for is the
larger hash table one, which simply alleviates collisions. This is now
part of perf-bench.

Thanks,
Davidlohr

