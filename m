Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaKJPRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:17:44 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55596 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbaKJPRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:17:42 -0500
Date: Mon, 10 Nov 2014 16:17:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, rjw@rjwysocki.net,
        nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, lenb@kernel.org
Subject: Re: [PATCH V3 1/6] sched: idle: Add a weak arch_cpu_idle_poll
 function
Message-ID: <20141110151735.GW10501@worktop.programming.kicks-ass.net>
References: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org>
 <1415370687-18688-2-git-send-email-daniel.lezcano@linaro.org>
 <20141110122954.GM3337@twins.programming.kicks-ass.net>
 <5460C9A6.6080103@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5460C9A6.6080103@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 07:50:22PM +0530, Preeti U Murthy wrote:
> Hi Peter,
> 
> On 11/10/2014 05:59 PM, Peter Zijlstra wrote:
> > On Fri, Nov 07, 2014 at 03:31:22PM +0100, Daniel Lezcano wrote:
> >> The poll function is called when a timer expired or if we force to poll when
> >> the cpu_idle_force_poll option is set.
> >>
> >> The poll function does:
> >>
> >>        local_irq_enable();
> >>        while (!tif_need_resched())
> >>                cpu_relax();
> >>
> >> This default poll function suits for the x86 arch because its rep; nop;
> >> hardware power optimization. But on other archs, this optimization does not
> >> exists and we are not saving power. The arch specific bits may want to
> >> optimize this loop by adding their own optimization.
> > 
> > This doesn't make sense to me; should an arch not either implement an
> > actual idle driver or implement cpu_relax() properly, why allow for a
> > third weird option?
> > 
> 
> The previous version of this patch simply invoked cpu_idle_loop() for
> cases where latency_req was 0. This would have changed the behavior
> on PowerPC wherein earlier the 0th idle index was returned which is also
> a polling loop but differs from cpu_idle_loop() in two ways:
> 
> a. It polls at a relatively lower power state than cpu_relax().
> b. We set certain registers to indicate that the cpu is idle.

So I'm confused; the current code runs the generic cpu_relax idle poll
loop for the broadcast case. I suppose you want to retain this because
not doing your a-b above will indeed give you a lower latency.

Therefore one could argue that latency_req==0 should indeed use this,
and your a-b idle state should be latency_req==1 or higher.

Thus yes it changes behaviour, but I think it actually fixes something.
You cannot have a latency_req==0 state which has higher latency than the
actual polling loop, as you appear to have.

> Hence for all such cases wherein the cpu is required to poll while idle
> (only for cases such as force poll, broadcast ipi to arrive soon and
> latency_req = 0), we should be able to call into cpuidle_idle_loop()
> only if the cpuidle driver's 0th idle state has an exit_latency > 0.
> (The 0th idle state is expected to be a polling loop with
> exit_latency = 0).
> 
> If otherwise, it would mean the driver has an optimized polling loop
> when idle. But instead of adding in the logic of checking the
> exit_latency, we thought it would be simpler to call into an arch
> defined polling idle loop under the above circumstances. If that is no
> better we could fall back to cpuidle_idle_loop().

That still doesn't make sense to me; suppose the implementation of this
special poll state differs on different uarchs for the same arch, then
we'll end up with another registration and selection interface parallel
to cpuidle.


