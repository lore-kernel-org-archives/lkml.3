Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaBSInR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:43:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49280 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaBSInP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:43:15 -0500
Date: Wed, 19 Feb 2014 09:43:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: x86 perf's dTLB-load-misses broken on IvyBridge?
Message-ID: <20140219084308.GE27965@twins.programming.kicks-ass.net>
References: <5303E8BF.9030107@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5303E8BF.9030107@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 03:11:59PM -0800, Dave Hansen wrote:
> I noticed that perf's dTLB-load-misses even t isn't working on my
> Ivybridge system:
> 
> >  Performance counter stats for 'system wide':
> > 
> >                  0      dTLB-load-misses                                             [100.00%]
> >             48,570      dTLB-store-misses                                            [100.00%]
> >            202,573      iTLB-loads                                                   [100.00%]
> >            271,546      iTLB-load-misses          #  134.05% of all iTLB cache hits 
> 
> But it works on a SandyBridge system that I have.
> 
> arch/x86/kernel/cpu/perf_event_intel.c seems to use the same tables for
> SandyBridge and IvyBridge, so they both use the
> 'MEM_UOP_RETIRED.ALL_LOADS' event:
> 
> >  [ C(DTLB) ] = {
> >         [ C(OP_READ) ] = {
> >                 [ C(RESULT_ACCESS) ] = 0x81d0, /* MEM_UOP_RETIRED.ALL_LOADS */
> >                 [ C(RESULT_MISS)   ] = 0x0108, /* DTLB_LOAD_MISSES.CAUSES_A_WALK */
> >         },
> 
> But that event looks to be unsupported on this CPU:
> 
> > /ocperf.py stat -a -e mem_uops_retired.all_loads sleep 1

That kind of snake voo-doo is that?

> > perf stat -a -e cpu/event=0xd0,umask=0x81,name=mem_uops_retired_all_loads/ sleep 1

So this line only produces the mem_uops_retired_all_loads thing, not the
_ps thing.

> > 
> >  Performance counter stats for 'system wide':
> > 
> >    <not supported>      mem_uops_retired_all_loads
> >         50,204,763      mem_uops_retired_all_loads_ps
> 
> But there's a "_ps" version which uses PEBS which does work?

So clearly there is no _ps version, as I'm still utterly confused as to
wtf you mean and where it came from.

> >   mem_uops_retired.all_loads                  [Load uops retired to architected path with filter on bits 0 and 1 applied. (Supports PEBS)]
> >   mem_uops_retired.all_loads_ps               [Load uops retired to architected path with filter on bits 0 and 1 applied.  (Uses PEBS) (Uses PEBS)]

What's that; SDM not haz this.

> Should we swap perf_event_intel.c over to use the PEBS version so that
> it works everywhere?

I'm confused; where does this _ps thing come from? There's nothing like
that in the SDM. That only lists the D0H event, and says it should work.

Of course the SDM is trying to confuse the living daylight out of people
by calling it crap like "3rd gen intel core", which just shows they
can't bloody well count either, since it went:

  core, core2, nhm, wsm, snb, ivb

do its damn well 6th gen.
