Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab3JSIXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 04:23:22 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:48499 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab3JSIXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 04:23:18 -0400
Date: Sat, 19 Oct 2013 10:23:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Doug Ledford <dledford@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131019082314.GA7778@gmail.com>
References: <201310181742.r9IHgO1q021001@ib.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201310181742.r9IHgO1q021001@ib.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Doug Ledford <dledford@redhat.com> wrote:

> >> Based on these, prefetching is obviously a a good improvement, but 
> >> not as good as parallel execution, and the winner by far is doing 
> >> both.
> 
> OK, this is where I have to chime in that these tests can *not* be used 
> to say anything about prefetch, and not just for the reasons Ingo lists 
> in his various emails to this thread.  In fact I would argue that Ingo's 
> methodology on this is wrong as well.

Well, I didn't go into as many details as you - but I agree with your full 
list obviously:

> All prefetch operations get sent to an access queue in the memory 
> controller where they compete with both other reads and writes for the 
> available memory bandwidth.  The optimal prefetch window is not a factor 
> of memory bandwidth and latency, it's a factor of memory bandwidth, 
> memory latency, current memory access queue depth at time prefetch is 
> issued, and memory bank switch time * number of queued memory operations 
> that will require a bank switch.  In other words, it's much more complex 
> and also much more fluid than any static optimization can pull out. 
> [...]

But this is generally true of _any_ static operation - CPUs are complex, 
workloads are complex, other threads, CPUs, sockets, devices might 
interact, etc.

Yet it does not make it invalid to optimize for the isolated, static 
usecase that was offered, because 'dynamism' and parallelism in a real 
system will rarely make that optimization completely invalid, it will 
typically only diminish its fruits to a certain degree (for example by 
causing prefetches to be discarded).

What I was objecting to strongly here was to measure the _wrong_ thing, 
i.e. the cache-hot case. The cache-cold case should be measured in a low 
noise fashion, so that results are representative. It's closer to the real 
usecase than any other microbenchmark. That will give us a usable speedup 
figure and will tell us which technique helped how much and which 
parameter should be how large.

> [...]  So every time I see someone run a series of micro- benchmarks 
> like you just did, where the system was only doing the micro- benchmark 
> and not a real workload, and we draw conclusions about optimal prefetch 
> distances from that test, I cringe inside and I think I even die... just 
> a little.

So the thing is, microbenchmarks can indeed be misleading - and as in this 
case the cache-hot claims can be outright dangerously misleading.

But yet, if done correctly and interpreted correctly they tell us a little 
bit of the truth and are often correlated to real performance.

Do microbenchmarks show us everything that a 'real' workload inhibits? Not 
at all, they are way too simple for that. They are a shortcut, an 
indicator, which is often helpful as long as not taken as 'the' 
performance of the system.

> A better test for this, IMO, would be to start a local kernel compile 
> with at least twice as many gcc instances allowed as you have CPUs, 
> *then* run your benchmark kernel module and see what prefetch distance 
> works well. [...]

I don't agree that this represents our optimization target. It may 
represent _one_ optimization target. But many other important usecases 
such as a dedicated file server, or a computation node that is 
cache-optimized, would unlikely to show such high parallel memory pressure 
as a GCC compilation.

> [...]  This distance should be far enough out that it can withstand 
> other memory pressure, yet not so far as to constantly be prefetching, 
> tossing the result out of cache due to pressure, then fetching/stalling 
> that same memory on load.  And it may not benchmark as well on a 
> quiescent system running only the micro-benchmark, but it should end up 
> performing better in actual real world usage.

The 'fully adversarial' case where all resources are maximally competed 
for by all other cores is actually pretty rare in practice. I don't say it 
does not happen or that it does not matter, but I do say there are many 
other important usecases as well.

More importantly, the 'maximally adversarial' case is very hard to 
generate, validate, and it's highly system dependent!

Cache-cold (and cache hot) microbenchmarks on the other hand tend to be 
more stable, because they typically reflect current physical (mostly 
latency) limits of CPU and system technology, _not_ highly system 
dependent resource sizing (mostly bandwidth) limits which are very hard to 
optimize for in a generic fashion.

Cache-cold and cache-hot measurements are, in a way, important physical 
'eigenvalues' of a complex system. If they both show speedups then it's 
likely that a more dynamic, contended for, mixed workload will show 
speedups as well. And these 'eigenvalues' are statistically much more 
stable across systems, and that's something we care for when we implement 
various lowlevel assembly routines in arch/x86/ which cover many different 
systems with different bandwidth characteristics.

I hope I managed to explain my views clearly enough on this.

Thanks,

	Ingo
