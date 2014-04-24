Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915AbaDXTJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:09:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:38831 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbaDXTJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:09:08 -0400
Date: Thu, 24 Apr 2014 21:09:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Bugfix] sched: fix possible invalid memory access caused by CPU
 hot-addition
Message-ID: <20140424190903.GC26782@laptop.programming.kicks-ass.net>
References: <1398144435-26271-1-git-send-email-jiang.liu@linux.intel.com>
 <20140422081515.GF11182@twins.programming.kicks-ass.net>
 <53572939.7020509@linux.intel.com>
 <20140423053213.GV26782@laptop.programming.kicks-ass.net>
 <20140423055107.GB1429@laptop.programming.kicks-ass.net>
 <3908561D78D1C84285E8C5FCA982C28F327EB605@ORSMSX114.amr.corp.intel.com>
 <53587E21.5070507@linux.intel.com>
 <20140424074741.GA26782@laptop.programming.kicks-ass.net>
 <3908561D78D1C84285E8C5FCA982C28F327EC694@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F327EC694@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 05:41:20PM +0000, Luck, Tony wrote:
> >> 	The BIOS always sends CPU hot-addition events before memory
> >> hot-addition events, so it's hard to change the order.
> >> 	And we couldn't completely solve this performance penalty because the
> >> affected code tries to allocate memory for all possible
> >> CPUs instead of onlined CPUs.
> >
> > So the BIOS is fucked, news at 11, one would have hoped Intel would have
> > _some_ say in it, but alas. So how about instead you force memory online
> > when you online the first CPU, screw whatever the BIOS does or does not?
> 
> Certainly an interesting implementation choice by the BIOS. The only logical
> order to use to bring components of a modern cpu online is:
> 
> 1) Memory - so we have a place to allocate structure needed for following steps
> 2) Cores - so we have a place to direct interrupts from next step
> 3) I/O
> 
> We should log a bug against the BIOS ... but systems are already shipping so we will
> have to deal with this.

Someone want to clue me in what systems these are so I can try and stay
the hell away from them?

> Either we use your existing patch - and systems with silly BIOS will work, but with a
> small NUMA penalty for objects allocated remotely

Depending on how this all is constructed, I can imagine the worst case
where we bring up a medium to large system (8+ nodes, non fully
connected etc) and we only have memory for the first node online from
booting. The cpu bringup could be concurrent/fast-enough to not have any
other memory online.

This would result in all cpus having their memory on the first node
(including per-cpu chunks I would imagine), that's entirely retarded.

We should really refuse to bring up CPUs and boot in reduced capacity
for such demented systems.

> or ... we implement some crazy queuing scheme ... where we delay bringing cores
> online for a while to see whether more things like memory and I/O start showing
> up too.  We can't wait forever - people sometimes do configure systems with
> memory-less nodes.

Is there no distinction between the cases? I've really no idea how the
BIOS communicates this (and honestly no real desire to know), but it
would be best if we can kludge around this in the arch code and keep it
out of core code.

Did I already say that memory-less nodes are stupid? ;-)

> I think your existing solution is the better choice ... the penalties probably aren't
> all that big ... so extensive workarounds for BIOS bugs seem like the wrong direction.

Why can't we have the architecture code generate a memory add event on
the first cpu up of which there is no memory yet?
