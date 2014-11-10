Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaKJQPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:15:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:59369 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaKJQPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:15:32 -0500
Date: Mon, 10 Nov 2014 17:15:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: rjw@rjwysocki.net, preeti@linux.vnet.ibm.com, nicolas.pitre@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org, lenb@kernel.org
Subject: Re: [PATCH V3 2/6] sched: idle: cpuidle: Check the latency req
 before idle
Message-ID: <20141110161530.GB10501@worktop.programming.kicks-ass.net>
References: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org>
 <1415370687-18688-3-git-send-email-daniel.lezcano@linaro.org>
 <20141110124111.GN3337@twins.programming.kicks-ass.net>
 <5460D5EF.2000805@linaro.org>
 <20141110152803.GX10501@worktop.programming.kicks-ass.net>
 <5460E0A5.9040508@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5460E0A5.9040508@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 04:58:29PM +0100, Daniel Lezcano wrote:
> >I don't get it, I've clearly not stared at it long enough, but why is
> >that STATE_START crap needed anywhere?
> 
> Excellent question :)
> 
> On x86, the config option ARCH_HAS_CPU_RELAX is set (x86 is the only one).
> That leads to the macro CPUIDLE_DRIVER_STATE_START equal 1.
> 
> https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/tree/include/linux/cpuidle.h#n221
> 
> Then the acpi cpuidle driver and the intel_driver begin to fill the idle
> state at index == CPUIDLE_DRIVER_STATE_START, so leaving the 0th idle state
> empty.
> 
> https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/tree/drivers/idle/intel_idle.c#n848
> 
> https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/tree/drivers/acpi/processor_idle.c#n953
> 
> Then when the driver is registered and if ARCH_HAS_CPU_RELAX is set, the
> cpuidle framework insert the 0th with the poll state (reminder : only for
> x86).

Appears to me part of the problem is right there, the intel_idle and
proessor_idle should register the poll state themselves. That
immediately makes this weirdness go away.

Registering states from two places is not something that's sane or
desired I think.

> https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/tree/drivers/cpuidle/driver.c#n195
> 
> If you look at the ladder governor (which I believe nobody is still using
> it), or at the menu governor, all the indexes begin at
> CPUIDLE_DRIVER_STATE_START, so all the code is preventing to use the 0th
> state ... :)
> 
> So why is needed the poll state ?
> 
> 1. When the latency_req is 0 (it returns 0, so the poll state)

Right, that makes sense.

> 2. When the select's menu governor fails to find a state *and* if the next
> timer is before 5us

That seems rather arbitrary. Why would it fail to find a state?

> https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/tree/drivers/cpuidle/driver.c#n195
> 
> And when we investigate the same code but on the other archs, the
> CPUIDLE_DRIVER_STATE_START dance makes things slightly different.
> 
> So the conclusion is, we are inserting a state in the idle state array but
> we do everything to prevent to use it :)
> 
> For me it appears logical to just kill this state from the x86 idle drivers
> and move it in the idle_mainloop in case an idle state selection fails.

But why, ppc has a latency_req==0 state too, right?

I agree that we should shoot STATE_START in the head, but I feel we
should do it by fixing the state registration.

I really don't get why the governors should know about this though, its
just another state, they should iterate all states and pick the best,
given the power usage this state should really never be eligible unless
we're QoS forced or whatnot.
