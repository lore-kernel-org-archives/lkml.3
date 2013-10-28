Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab3J1NUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:20:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756367Ab3J1NUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:20:22 -0400
Date: Mon, 28 Oct 2013 09:19:46 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, dave.hansen@linux.intel.com,
        Stephane Eranian <eranian@google.com>, jmario@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH] perf, x86: Optimize intel_pmu_pebs_fixup_ip()
Message-ID: <20131028131946.GG108330@redhat.com>
References: <20131017163039.GR10651@twins.programming.kicks-ass.net>
 <CA+55aFx-1Xu2aSvAMi8SSUwq-J9Yo3oJGY8yUYWyAZmZmr8prQ@mail.gmail.com>
 <20131017220156.GB10651@twins.programming.kicks-ass.net>
 <CA+55aFyCCdwF78dM1=Km=0wqtoyosp-ChyoJuBb1DdBvmGe2vA@mail.gmail.com>
 <20131022211237.GH2490@laptop.programming.kicks-ass.net>
 <CA+55aFwfsyofuZtNyUGKPWdvqc=4gOW=HTFPxsiM-3GS1G8KKQ@mail.gmail.com>
 <20131023204838.GB19466@laptop.lan>
 <20131024105206.GM2490@laptop.programming.kicks-ass.net>
 <20131025163303.GD108330@redhat.com>
 <20131026103651.GA21294@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131026103651.GA21294@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 12:36:52PM +0200, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > On Thu, Oct 24, 2013 at 12:52:06PM +0200, Peter Zijlstra wrote:
> > > On Wed, Oct 23, 2013 at 10:48:38PM +0200, Peter Zijlstra wrote:
> > > > I'll also make sure to test we actually hit the fault path
> > > > by concurrently running something like:
> > > > 
> > > >  while :; echo 1 > /proc/sys/vm/drop_caches ; done
> > > > 
> > > > while doing perf top or so.. 
> > > 
> > > So the below appears to work; I've ran:
> > > 
> > >   while :; do echo 1 > /proc/sys/vm/drop_caches; sleep 1; done &
> > >   while :; do make O=defconfig-build/ clean; perf record -a -g fp -e cycles:pp make O=defconfig-build/ -s -j64; done
> > > 
> > > And verified that the if (in_nmi()) trace_printk() was visible in the
> > > trace output verifying we indeed took the fault from the NMI code.
> > > 
> > > I've had this running for ~ 30 minutes or so and the machine is still
> > > healthy.
> > > 
> > > Don, can you give this stuff a spin on your system?
> > 
> > Hi Peter,
> > 
> > I finally had a chance to run this on my machine.  From my 
> > testing, it looks good.  Better performance numbers.  I think my 
> > longest latency went from 300K cycles down to 150K cycles and very 
> > few of those (most are under 100K cycles).
> 
> Btw., do we know where those ~100k-150k cycles are spent 
> specifically? 100k cycles is still an awful lot of time to spend in 
> NMI context ...

I agree, there is still a bunch of latency in the nmi path.  I believe it
is still in the pebs code.  I share the machine with a colleague right
now, so I haven't been able to isolate it.

But going from a few hundred samples over a million cycles to about a
couple dozen over 100K was a big step.  :-)

I still see perf throttling and people are complaining about it here so I
still plan to keep investigating.  Just taking me a while.  Sorry about
that.

Cheers,
Don
