Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab3J2P2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 11:28:50 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:62041 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab3J2P2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 11:28:49 -0400
Date: Tue, 29 Oct 2013 11:36:52 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Will Deacon <will.deacon@arm.com>, Vince Weaver <vincent.weaver@maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf: PERF_EVENT_IOC_PERIOD on ARM vs everywhere else
In-Reply-To: <20131029134536.GD16117@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1310291129090.15619@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1310272233120.12721@vincent-weaver-1.um.maine.edu> <20131028085700.GB20218@mudshark.cambridge.arm.com> <alpine.DEB.2.10.1310281002020.24060@vincent-weaver-1.um.maine.edu> <20131029042810.GD22291@mudshark.cambridge.arm.com>
 <20131029134536.GD16117@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Oct 2013, Peter Zijlstra wrote:
> On Tue, Oct 29, 2013 at 04:28:10AM +0000, Will Deacon wrote:
> > 
> > I can CC LKML on ARM perf patches if you think it will help, but all PMU
> > backend patches go via their respective arch trees afaict.
> 
> Just those that change user visible semantics that are shared between
> archs I suppose :-)

I suppose it is hard to know what's commonly shared.  I hadn't realized
that the IOC_PERIOD stuff was arch specific code, I would have thought
it was common code.

Since there isn't a perf-specific list CCing LKML might be the answer even 
though it sometimes adds to the noise.  I think the Power people CC all 
their PMU related patches to LKML and it has made them easier to find and 
review.

> We could start by making all archs do the same thing again; but yes
> ideally we'd move some of it into generic code. Not entirely sure how
> that will work out though, there's a reason its in per-arch code :/
> 
> 
> Vince, what would you prefer to do here?

as with most of thes things there isn't really a good answer.

It turns out in the end that PAPI isn't bit by this one, because instead 
of using PERF_EVENT_IOC_PERIOD when the period is changed, PAPI just tears 
down all the perf_events and re-sets them up from scratch with the new 
period.  This is probably because PERF_EVENT_IOC_PERIOD was broken until 
2.6.36.

It is true the current behavior is unexpected.  What was the logic behind 
deferring to the next overflow for the update?  Was it a code simplicity 
thing?  Or were there hardware reasons behind it?

Definitely when an event is stopped, it makes more sense for 
PERF_EVENT_IOC_PERIOD to take place immediately.  

I'm not sure what happens if we try to use it on a running event, 
especially if we've already passed the new period value.

Vince

