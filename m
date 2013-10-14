Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab3JNV3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:29:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:15967 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757413Ab3JNV27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:28:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,494,1378882800"; 
   d="scan'208";a="392866883"
Date: Mon, 14 Oct 2013 14:28:40 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: dave.hansen@linux.intel.com, a.p.zijlstra@chello.nl, eranian@google.com,
        jmario@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: x86, perf: throttling issues with long nmi latencies
Message-ID: <20131014212840.GE7456@tassilo.jf.intel.com>
References: <20131014203549.GY227855@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014203549.GY227855@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 04:35:49PM -0400, Don Zickus wrote:
> I have been playing with quad socket Ivy Bridges for awhile and have seen
> numerous "perf samples too long" messages, to the point, the machine is
> unusable for any perf analyzing.

We've seen the same problem on our large systems. Dave 
did some fixes in mainline, but they only work around the problem.

One main cause I believe is that dynamic period, which often 
goes down to insanely low values for cycles.

This also causes a lot of measurement overhead, without really giving better
data.

If you use -c ... with a reasonable period the problem completely
goes away (with pmu-tools ocperf stat -c default sets a reasonable default)

> So I tried to investigate the source of the NMI latencies using the
> traditional 'rdtscll()' command.  That failed miserably.  Then it was
> pointed out to me that rdtscll() is terrible for benchmarking due to
> out-of-order execution by the Intel processors.  This Intel whitepaper
> describes a better way using cpuid and rdtsc:

We just used ftrace function tracer.

> the longest one first.  It seems to be 'copy_user_from_nmi'
> 
> intel_pmu_handle_irq ->
> 	intel_pmu_drain_pebs_nhm ->
> 		__intel_pmu_drain_pebs_nhm ->
> 			__intel_pmu_pebs_event ->
> 				intel_pmu_pebs_fixup_ip ->
> 					copy_from_user_nmi
> 
> In intel_pmu_pebs_fixup_ip(), if the while-loop goes over 50, the sum of
> all the copy_from_user_nmi latencies seems to go over 1,000,000 cycles

fixup_ip has to decode a whole basic block, to correct off by one.
I'm not sure why the copy dominates though. But copy_from_user_nmi
does a lot of nasty things.

I would just use :p which skips this. The single instruction correction 
is not worth all the overhead, and  there is always more skid anyways
even with the correction.

The good news is that Haswell fixes the overhead, :pp is as fast as :p

> (there are some cases where only 10 iterations are needed to go that high
> too, but in generall over 50 or so).  At this point copy_user_from_nmi
> seems to account for over 90% of the nmi latency.

Yes saw the same. It's unclear why it is that expensive.
I've also seen the copy dominate with -g.

Also for some reason it seems to hurt much more on larger systems
(cache misses?) Unfortunately it's hard to use perf to analyze
perf, that was the road block last time I understanding this better.

One guess was that if you profile the same code running on many
cores the copy*user_nmi code will have a very hot cache line
with the page reference count.

Some obvious improvements are likely possible:

The copy function is pretty dumb -- for example it repins the pages
for each access. It would be likely much faster to batch that
and only do it once per backtrace/decode. This would need
a new interface.

I suppose there would be a way to do this access without actually
incrementing the ref count (e.g. with a seqlock like scheme
or just using TSX)

But if you don't do the IP correction and only the stack access
in theory it should be possible to avoid the majority of changes.

First level recommendations:

- Always use -c ... / or -F ..., NEVER dynamic period
- Don't use :pp

-Andi

