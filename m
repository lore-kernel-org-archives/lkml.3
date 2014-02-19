Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaBSWc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 17:32:56 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:40614 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaBSWcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 17:32:55 -0500
Date: Wed, 19 Feb 2014 17:34:49 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: x86_pmu_start WARN_ON.
In-Reply-To: <20140219101949.GG15586@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1402191727420.23543@vincent-weaver-1.um.maine.edu>
References: <20140130190253.GA11819@redhat.com> <alpine.DEB.2.10.1402101620170.29602@vincent-weaver-1.um.maine.edu> <20140211132956.GY9987@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402121559350.20738@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu> <20140217152859.GF15586@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu> <20140219101949.GG15586@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Feb 2014, Peter Zijlstra wrote:

> So when we add a new event (or more) we compute a mapping from event to
> counter. Then we disable all (pre existing) events that moved to a new
> location, then we enable all events (insert HES_ARCH) that were running
> but got relocated and the new events.
> 
> Of course the code is horrible, but I think the above is what it does.

The code is a pain, with all of the various ctx types, and the nested 
calls to perf_pmu_enable/perf_pmu_disable in particular.


So I've hacked the code so that it shows the last location where 
hwc->state was cleared for an event (i.e., where it was last enabled).

The NMI counter event was enabled in _perf_install_in_context (presumably 
at creation time) and as far as I can tell never disabled.

Then when x86_pmu_enable/x86_pmu_start gets called at the end of
_perf_event_context_sched_in() it is sad because the NMI counter event is 
not disabled.

So where would the NMI counter event get disabled?  Would it never get 
disabled, just because it's always running and always gets the same fixed 
slot?  Why isn't this a problem all the time, not just with corner cases?

Is somehow n_added getting confused?

Vince

