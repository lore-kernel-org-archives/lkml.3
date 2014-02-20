Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaBTPyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 10:54:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37558 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaBTPye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 10:54:34 -0500
Date: Thu, 20 Feb 2014 16:54:16 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: x86_pmu_start WARN_ON.
Message-ID: <20140220155416.GH9987@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu>
 <20140217152859.GF15586@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu>
 <20140219101949.GG15586@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402191727420.23543@vincent-weaver-1.um.maine.edu>
 <20140220100830.GN6835@laptop.programming.kicks-ass.net>
 <87r46xdbw4.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r46xdbw4.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 07:47:23AM -0800, Andi Kleen wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Wed, Feb 19, 2014 at 05:34:49PM -0500, Vince Weaver wrote:
> >> So where would the NMI counter event get disabled?  Would it never get 
> >> disabled, just because it's always running and always gets the same fixed 
> >> slot?  Why isn't this a problem all the time, not just with corner cases?
> >
> > Well it could get another counter assignment I suppose; there's no
> > guarantee it always ends up in the fixed counter although that's rather
> > likely.
> >
> >> Is somehow n_added getting confused?
> >
> > I'd expect worse than a warning if that happened, but who knows.
> >
> > You could try with the below; make sure you've got CONFIG_FUNCTION_TRACER=y.
> >
> > Then (assuming debugfs is mounted in /debug ; most modern distros have
> > it at /sys/kernel/debug but they're wrong!):
> >
> > # echo 0 > /debug/tracing/tracing_on
> > # echo function > /debug/tracing/current_tracer
> > # echo nop > /debug/tracing/current_tracer
> > # echo 0 > /debug/tracing/trace
> > # echo 1 > /debug/tracing/tracing_on
> >
> > And make it go *BOOM*, then:
> >
> > # cat /debug/tracing/trace | bzip2 -9 > ~/trace.bz2
> 
> This won't work unless you apply this patch
> 
> http://lkml.org/lkml/2013/10/20/94

It will; trace_printk() works without -pg, I think you didn't read the
instructions very well.

And there's a very good reason not to apply your patch; you can route
the function tracer into perf, guess what happens when perf calls the
function tracer again :-)

But yes; you can use it if you don't do that. But I didn't want the
function trace, so who cares.
