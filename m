Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaBSKT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:19:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51733 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaBSKT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:19:56 -0500
Date: Wed, 19 Feb 2014 11:19:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: x86_pmu_start WARN_ON.
Message-ID: <20140219101949.GG15586@twins.programming.kicks-ass.net>
References: <20140130190253.GA11819@redhat.com>
 <alpine.DEB.2.10.1402101620170.29602@vincent-weaver-1.um.maine.edu>
 <20140211132956.GY9987@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402121559350.20738@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu>
 <20140217152859.GF15586@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 05:20:57PM -0500, Vince Weaver wrote:
> On Tue, 18 Feb 2014, Vince Weaver wrote:
> 
> > On Mon, 17 Feb 2014, Peter Zijlstra wrote:
> > 
> > > Enable CONFIG_FRAME_POINTER for better stack traces; I suspect the
> > > list_del_event() is just random stack garbage. The path that makes sense
> > > is:
> > >   wait_rcu()->__wait_for_common()->schedule_timeout()
> > 
> > Here's an updated stack trace on 3.14-rc3 with CONFIG_FRAME_POINTER 
> > enabled, in case it's helpful:
> 
> Still chasing this, although all I can add are these debug messages:
> 
> [  140.812003] PROBLEM: n_events=2 n_added=2 VMW: idx=33 state=f00 type=0 config=0 samp_per=5e6069eb0
> [  140.812003] ALL: VMW: Num=0 idx=33 state=f00 type=0 config=0 samp_per=5e6069eb0
> [  140.812003] ALL: VMW: Num=1 idx=0 state=3 type=0 config=1 samp_per=0
> 
> So when the WARN gets triggered there only only two events in the event
> list, the NMI watchdog which has already been enabled somehow (that f00
> I stuck in, pmu_start sets it to f00 instead of 00 to make sure it wasn't
> something stomping on memory) and the precise instructions event.
> 
> I still have a hard time following what all the schedule in code is doing.

Yes, I got it once, then promptly forgot it. It all became the thing it
is because AMD Fam15 had some horrible constraints.

So in general it tries to map events to counters in order of decreasing
constraints (so it starts with the most constrained events).

It all gets a bit funny due to overlapping constraints; see commit
bc1738f6ee830 for a little blurb on what the overlap thing is about.


So when we add a new event (or more) we compute a mapping from event to
counter. Then we disable all (pre existing) events that moved to a new
location, then we enable all events (insert HES_ARCH) that were running
but got relocated and the new events.

Of course the code is horrible, but I think the above is what it does.
