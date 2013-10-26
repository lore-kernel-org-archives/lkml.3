Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab3JZLzK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 07:55:10 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:46744 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab3JZLzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 07:55:08 -0400
Date: Sat, 26 Oct 2013 13:55:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Doug Ledford <dledford@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131026115505.GB24067@gmail.com>
References: <201310181742.r9IHgO1q021001@ib.usersys.redhat.com>
 <20131019082314.GA7778@gmail.com>
 <52656A5A.4030406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52656A5A.4030406@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Doug Ledford <dledford@redhat.com> wrote:

> > What I was objecting to strongly here was to measure the _wrong_ 
> > thing, i.e. the cache-hot case. The cache-cold case should be 
> > measured in a low noise fashion, so that results are 
> > representative. It's closer to the real usecase than any other 
> > microbenchmark. That will give us a usable speedup figure and 
> > will tell us which technique helped how much and which parameter 
> > should be how large.
> 
> Cold cache, yes.  Low noise, yes.  But you need DMA traffic at the 
> same time to be truly representative.

Well, but in most usecases network DMA traffic is an order of 
magnitude smaller than system bus capacity. 100 gigabit network 
traffic is possible but not very common.

So I'd say that _if_ prefetching helps in the typical case we should 
tune it for that - not for the bus-contended case...

> >> [...]  This distance should be far enough out that it can 
> >> withstand other memory pressure, yet not so far as to 
> >> constantly be prefetching, tossing the result out of cache due 
> >> to pressure, then fetching/stalling that same memory on load.  
> >> And it may not benchmark as well on a quiescent system running 
> >> only the micro-benchmark, but it should end up performing 
> >> better in actual real world usage.
> > 
> > The 'fully adversarial' case where all resources are maximally 
> > competed for by all other cores is actually pretty rare in 
> > practice. I don't say it does not happen or that it does not 
> > matter, but I do say there are many other important usecases as 
> > well.
> > 
> > More importantly, the 'maximally adversarial' case is very hard 
> > to generate, validate, and it's highly system dependent!
> 
> This I agree with 100%, which is why I tend to think we should 
> scrap the static prefetch optimizations entirely and have a boot 
> up test that allows us to find our optimum prefetch distance for 
> our given hardware.

Would be interesting to see.

I'm a bit sceptical - I think 'looking 1-2 cachelines in advance' is 
something that might work reasonably well on a wide range of 
systems, while trying to find a bus capacity/latency dependent sweet 
spot would be difficult.

We had pretty bad experience from boot-time measurements, and it's 
not for lack of trying: I implemented the raid algorithm 
benchmarking thing and also the scheduler's boot time cache-size 
probing, both were problematic and have hurt reproducability and 
debuggability.

Thanks,

	Ingo
