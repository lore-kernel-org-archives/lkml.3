Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaKJTs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:48:28 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:41860 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaKJTs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:48:26 -0500
Date: Mon, 10 Nov 2014 20:48:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: rjw@rjwysocki.net, preeti@linux.vnet.ibm.com, nicolas.pitre@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org, lenb@kernel.org
Subject: Re: [PATCH V3 2/6] sched: idle: cpuidle: Check the latency req
 before idle
Message-ID: <20141110194820.GD10501@worktop.programming.kicks-ass.net>
References: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org>
 <1415370687-18688-3-git-send-email-daniel.lezcano@linaro.org>
 <20141110124111.GN3337@twins.programming.kicks-ass.net>
 <5460D5EF.2000805@linaro.org>
 <20141110152803.GX10501@worktop.programming.kicks-ass.net>
 <5460E0A5.9040508@linaro.org>
 <20141110161530.GB10501@worktop.programming.kicks-ass.net>
 <5460F386.1050109@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5460F386.1050109@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 06:19:02PM +0100, Daniel Lezcano wrote:
> >I really don't get why the governors should know about this though, its
> >just another state, they should iterate all states and pick the best,
> >given the power usage this state should really never be eligible unless
> >we're QoS forced or whatnot.
> 
> The governors just don't use the poll state at all, except for a couple of
> cases in menu.c defined above in the previous email. What is the rational of
> adding a state in the cpuidle driver and do everything we can to avoid using
> it ? From my POV, the poll state is a special state, we should remove from
> the driver's idle states like the arch_cpu_idle() is a specific idle state
> only used in idle.c (but which may overlap with an idle state in different
> archs eg. cpu_do_idle() and the 0th idle state).

So I disagree, I think poll-idle is an idle mode just like all the
others. It should be an available state to the governor and it should
treat it like any other.

I don't tihnk the whole ARCH_HAS_CPU_RELAX thing makes any kind of
sense, _every_ arch has some definition of it, the generic polling loop
is always a valid idle implementation.

What we can do is always populate the idle state table with it before
calling the regular drivers.

If the arch drivers have a 'better' latency_req==0 idle routine -- note
my argument on the ppc issue, I think its wrong -- it can replace the
existing one.

We should further remove all the special casing in the governors, its
always a valid state, but it should hardly ever be the most desirable
state.

I think the whole arch specific idle loop is a mistake, we already have
an (arch) interface into the idle routines, we don't need yet another.
