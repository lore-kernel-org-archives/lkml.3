Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaKKKVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:21:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:36183 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbaKKKVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:21:01 -0500
Date: Tue, 11 Nov 2014 11:20:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: rjw@rjwysocki.net, preeti@linux.vnet.ibm.com, nicolas.pitre@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org, lenb@kernel.org
Subject: Re: [PATCH V3 2/6] sched: idle: cpuidle: Check the latency req
 before idle
Message-ID: <20141111102058.GI10501@worktop.programming.kicks-ass.net>
References: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org>
 <1415370687-18688-3-git-send-email-daniel.lezcano@linaro.org>
 <20141110124111.GN3337@twins.programming.kicks-ass.net>
 <5460D5EF.2000805@linaro.org>
 <20141110152803.GX10501@worktop.programming.kicks-ass.net>
 <5460E0A5.9040508@linaro.org>
 <20141110161530.GB10501@worktop.programming.kicks-ass.net>
 <5460F386.1050109@linaro.org>
 <20141110194820.GD10501@worktop.programming.kicks-ass.net>
 <54613A5F.7060107@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54613A5F.7060107@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 11:21:19PM +0100, Daniel Lezcano wrote:
> On 11/10/2014 08:48 PM, Peter Zijlstra wrote:
> >On Mon, Nov 10, 2014 at 06:19:02PM +0100, Daniel Lezcano wrote:
> >>>I really don't get why the governors should know about this though, its
> >>>just another state, they should iterate all states and pick the best,
> >>>given the power usage this state should really never be eligible unless
> >>>we're QoS forced or whatnot.
> >>
> >>The governors just don't use the poll state at all, except for a couple of
> >>cases in menu.c defined above in the previous email. What is the rational of
> >>adding a state in the cpuidle driver and do everything we can to avoid using
> >>it ? From my POV, the poll state is a special state, we should remove from
> >>the driver's idle states like the arch_cpu_idle() is a specific idle state
> >>only used in idle.c (but which may overlap with an idle state in different
> >>archs eg. cpu_do_idle() and the 0th idle state).
> >
> >So I disagree, I think poll-idle is an idle mode just like all the
> >others. It should be an available state to the governor and it should
> >treat it like any other.
> 
> The governors are just ignoring it, except for a small timer optimization in
> menu.c (and I am still not convinced it is worth to have it). I don't see
> the point to add a state we don't want to use.

The ignoring it is _wrong_. Make that go away and you'll get rid of most
of the STATE_START crap.

The governors are the place where we combine the QoS constraints with
idle predictors and pick an idle state, polling is a valid state to
pick, and given QoS constraints it might be the only state to pick.

> Eg. on my server it was called 2 times over 1313856 times.
> 
> >I don't tihnk the whole ARCH_HAS_CPU_RELAX thing makes any kind of
> >sense, _every_ arch has some definition of it, the generic polling loop
> >is always a valid idle implementation.
> >
> >What we can do is always populate the idle state table with it before
> >calling the regular drivers.
> 
> I am not sure to understand. You want to add the poll idle loop in all the
> drivers ?
> 
> What about "safe_halt()" ? (arch_cpu_idle() for x86). It is also an idle
> state. Why not add it in the idle state table also ?

Because the latter is actually arch specific, whereas the idle polling
thing is not. You can _always_ poll idle, its generic, its valid, and
its guaranteed the most responsive method.

The arch drivers get to add arch specific idle states; if a x86 cpuidle
driver wants to add hlt they can.


