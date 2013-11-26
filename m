Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab3KZKwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:52:10 -0500
Received: from www.linutronix.de ([62.245.132.108]:60894 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab3KZKwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:52:07 -0500
Date: Tue, 26 Nov 2013 11:51:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer@tamir.org.il>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        jacob.jun.pan@linux.intel.com, Mike Galbraith <bitbucket@online.de>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 6/7] sched: Clean up preempt_enable_no_resched() abuse
In-Reply-To: <52944A9A.6090906@linux.intel.com>
Message-ID: <alpine.DEB.2.02.1311261117100.30673@ionos.tec.linutronix.de>
References: <20131120160450.072555619@infradead.org> <20131120162736.691879744@infradead.org> <528CF94E.8020300@linux.intel.com> <20131121101018.GX10022@twins.programming.kicks-ass.net> <528E09F9.9030501@linux.intel.com> <20131121133936.GF10022@twins.programming.kicks-ass.net>
 <528F0000.7000505@linux.intel.com> <20131122113044.GL10022@twins.programming.kicks-ass.net> <52944A9A.6090906@linux.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Nov 2013, Eliezer Tamir wrote:

> On 22/11/2013 13:30, Peter Zijlstra wrote:
> > On Fri, Nov 22, 2013 at 08:56:00AM +0200, Eliezer Tamir wrote:
> >> On 21/11/2013 15:39, Peter Zijlstra wrote:
> >>> On Thu, Nov 21, 2013 at 03:26:17PM +0200, Eliezer Tamir wrote:
> > 
> > Please use local_clock(), yes its slightly more expensive, but I doubt
> > you can actually measure the effects on sane hardware.
> 
> If we limit the discussion to sane hardware, I should mention that on
> current Intel CPUs TSC is guaranteed to be monotonic for anything up to
> 8 sockets. Even on slightly older HS TSC skew is very small and should
> not be an issue for this use case.

> Modern sane HW does not have this issue.

That's wrong to begin with. There is no such thing which qualifies as
"sane hardware". Especially not if we are talking about timers.

> The people that do busy polling typically pin tasks to cores anyway.

This is completely irrelevant. If stuff falls apart if the task is not
pinned, then you lost nevertheless.

> You need cap_net_admin to use this setting.

And how is that relevant? cap_net_admin does not change the fact, that
you violate your constraints.

> There is no real damage if the issue happens.

You'r violating the constraints which is not fatal, but not desired
either.

> This is fast-low-latency-path so we are very sensitive to adding even
> a small cost.
> Linus really didn't like adding to the cost of poll/select when busy
> polling is not being used.
 
And that justifies exposing those who do not have access to "sane"
hardware and/or did not pin their tasks to constraint violation?

> Having said that, since we need to fix the timeout issue you pointed
> out, we will test the use of local_clock() and see if it matters or
> not.

If the hardware provides an indicator that the TSC is sane to use,
then sched_clock_stable is 1, so local_clock() will not do the slow
update dance at all. So for "sane" hardware the overhead is minimal
and on crappy hardware the correctness is still ensured with more
overhead.

If you are really concerned about the minimal overhead in the
sched_clock_stable == 1 case, then you better fix that (it's doable
with some brain) instead of hacking broken crap, based on even more
broken assumptions, into the networking code.

It's not the kernels fault, that we need to deal with
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK at all. And we have to deal with it
no matter what, so we cannot make this undone by magic assumptions.

Complain to those who forced us to do this. Hint: It's only ONE CPU
vendor who thought that providing useless timestamps is a brilliant
idea.

Thanks,

	tglx
