Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3J2Iip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:38:45 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:35650 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3J2Iih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:38:37 -0400
Date: Tue, 29 Oct 2013 09:38:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Doug Ledford <dledford@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131029083832.GB24625@gmail.com>
References: <201310181742.r9IHgO1q021001@ib.usersys.redhat.com>
 <20131019082314.GA7778@gmail.com>
 <52656A5A.4030406@redhat.com>
 <20131026115505.GB24067@gmail.com>
 <526E98AF.10300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526E98AF.10300@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Doug Ledford <dledford@redhat.com> wrote:

> [ Snipped a couple of really nice real-life bandwidth tests. ]

> Some of my preliminary results:
> 
> 1) Regarding the initial claim that changing the code to have two 
> addition chains, allowing the use of two ALUs, doubling 
> performance: I'm just not seeing it.  I have a number of theories 
> about this, but they are dependent on point #2 below:
> 
> 2) Prefetch definitely helped, although how much depends on which 
> of the test setups I was using above.  The biggest gainer was B) 
> the E3-1240 V2 @ 3.40GHz based machines.
> 
> So, my theories about #1 are that, with modern CPUs, it's more our 
> load/store speed that is killing us than the ALU speed.  I tried 
> at least 5 distinctly different ALU algorithms, including one that 
> eliminated the use of the carry chain entirely, and none of them 
> had a noticeable effect.  On the other hand, prefetch always had a 
> noticeable effect.  I suspect the original patch worked and had a 
> performance benefit some time ago due to a quirk on some CPU 
> common back then, but modern CPUs are capable of optimizing the 
> routine well enough that the benefit of the patch is already in 
> our original csum routine due to CPU optimizations. [...]

That definitely sounds plausible.

> [...] Or maybe there is another explanation, but I'm not really 
> looking too hard for it.
> 
> I also tried two different prefetch methods on the theory that 
> memory access cycles are more important than CPU access cycles, 
> and there appears to be a minor benefit to wasting CPU cycles to 
> prevent unnecessary prefetches, even with 65520 as our MTU where a 
> 320 byte excess prefetch at the end of the operation only caused 
> us to load a few % points of extra memory.  I suspect that if I 
> dropped the MTU down to 9K (to mimic jumbo frames on a device 
> without tx/rx checksum offloads), the smart version of prefetch 
> would be a much bigger winner.  The fact that there is any 
> apparent difference at all on such a large copy tells me that 
> prefetch should probably always be smart and never dumb (and here 
> by smart versus dumb I mean prefetch should check to make sure you 
> aren't prefetching beyond the end of data you care about before 
> executing the prefetch instruction).

That looks like an important result and it should matter even more 
to ~1.5k MTU sizes where the prefetch window will be even larger 
relative to the IP packet size.

> What strikes me as important here is that these 8 core Intel CPUs 
> actually got *slower* with the ALU patch + prefetch.  This 
> warrants more investigation to find out if it's the prefetch or 
> the ALU patch that did the damage to the speed.  It's also worth 
> noting that these 8 core CPUs have such high variability that I 
> don't trust these measurements yet.

It might make sense to have a good look at the PMU counts for these 
cases to see what's going on.

Also, once the packet is copied to user-space, we might want to do a 
CLFLUSH on the originating buffer, to zap the cacheline from the CPU 
caches. (This might or might not matter, depending on how good the 
CPU is at keeping its true working set in the cache.)

> > I'm a bit sceptical - I think 'looking 1-2 cachelines in 
> > advance' is something that might work reasonably well on a wide 
> > range of systems, while trying to find a bus capacity/latency 
> > dependent sweet spot would be difficult.
> 
> I think 1-2 cachelines is probably way too short. [...]

The 4-5 cachelines result you seem to be converging on looks very 
plausible to me too.

What I think we should try to avoid is to make the actual window per 
system variable: that would be really hard to tune right.

But the 'don't prefetch past the buffer' "smart prefetch" logic you 
mentioned is system-agnostic and might make sense to introduce.

Thanks,

	Ingo
