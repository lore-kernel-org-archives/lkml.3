Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab3EGGnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 02:43:49 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:42965 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab3EGGnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 02:43:47 -0400
Date: Tue, 7 May 2013 08:43:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL, RFC] Full dynticks, CONFIG_NO_HZ_FULL feature
Message-ID: <20130507064342.GC17705@gmail.com>
References: <20130505110351.GA4768@gmail.com>
 <CA+55aFzPHkCH7CVZ4tkaF91+=GLZAxxncTq0J9d6AKpSPqovZw@mail.gmail.com>
 <20130505212511.GC3659@linux.vnet.ibm.com>
 <20130506092537.GA8879@gmail.com>
 <20130506153517.GA3501@linux.vnet.ibm.com>
 <CA+55aFxYRDZvisB7iZ5a-bcp5_2pkvcC9Opk6=yJtjfK57EWTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxYRDZvisB7iZ5a-bcp5_2pkvcC9Opk6=yJtjfK57EWTw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, May 6, 2013 at 8:35 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >>
> >> I think Linus might have referred to my 'future plans' entry:
> 
> Indeed. I feel that HPC is entirely irrelevant to anybody,
> *especially* HPC benchmarks. In real life, even HPC doesn't tend to
> have the nice behavior their much-touted benchmarks have.
> 
> So as long as the NOHZ is for HPC-style loads, then quite frankly, I
> don't feel it is worth it. The _only_ thing that makes it worth it is
> that "future plans" part where it would actually help real loads.
> 
> >>
> >> Interesting that HZ=1000 caused 8% overhead there. On a regular x86 server
> >> PC I've measured the HZ=1000 overhead to pure user-space execution to be
> >> around 1% (sometimes a bit less, sometimes a bit more).
> >>
> >> But even 1% is worth it.
> >
> > I believe that the difference is tick skew
> 
> Quite possibly it is also virtualization.
> 
> The VM people are the one who complain the loudest about how certain
> things make their performance go down the toilet. And interrupts tend
> to be high on that list, and unless you have hardware support for
> virtual timer interrupts I can easily see a factor of four cost or
> more.
> 
> And the VM people then flail around wildly to always blame everybody
> else. *Anybody* else than the VM overhead itself.
> 
> It also depends a lot on architecture. The ia64 people had much bigger
> problems with the timer interrupt than x86 ever did. Again, they saw
> this mainly on the HPC benchmarks, because the benchmarks were
> carefully tuned to have huge-page support and were doing largely
> irrelevant things like big LINPACK runs, and the timer irq ended up
> blowing their carefully tuned caches and TLB's out.
> 
> Never mind that nobody sane ever *cared*. Afaik, no real HPC load has
> anything like that behavior, much less anything else. But they had
> numbers to prove how bad it was, and it was a load with very stable
> numbers.
> 
> Combine the two (bad HPC benchmarks and VM), and you can make an
> argument for just about anything. And people have.
> 
> I am personally less than impressed with some of the benchmarks I've
> seen, if it wasn't clear.

Okay.

I never actually ran HPC benchmarks to characterise the overhead - the 
0.5%-1.0% figure was the 'worst case' improvement on native hardware with 
a couple of cores, running a plain infinite loop with no cache footprint. 

The per CPU timer/scheduler irq takes 5-10 usecs to execute, and with 
HZ=1000 which most distros use that happens once every 1000 usecs, which 
is measurable overhead.

So this feature, in the nr_running=1 case, will produce at minimum a 
0.5%-1.0% speedup of user-space workloads (on typical x86).

That alone makes it worth it I think - but we also want to generalize it 
to nr_running >= 2 as well to cover make -jX workloads, etc.

Thanks,

	Ingo
