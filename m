Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbaAJK6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:58:48 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36469 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784AbaAJK6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:58:45 -0500
Date: Fri, 10 Jan 2014 10:58:13 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/7] ARM: perf_event: Support percpu irqs for the CPU PMU
Message-ID: <20140110105813.GB10455@mudshark.cambridge.arm.com>
References: <1389221984-10973-1-git-send-email-sboyd@codeaurora.org>
 <1389221984-10973-3-git-send-email-sboyd@codeaurora.org>
 <20140109104943.GB17838@mudshark.cambridge.arm.com>
 <52CEF5C9.1010701@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CEF5C9.1010701@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 07:17:29PM +0000, Stephen Boyd wrote:
> On 01/09/14 02:49, Will Deacon wrote:
> >
> >> +static irq_handler_t cpu_handler;
> >> +
> >> +static irqreturn_t cpu_pmu_dispatch_irq(int irq, void *dev)
> >> +{
> >> +	struct arm_pmu *arm_pmu = *(struct arm_pmu **)dev;
> >> +	return cpu_handler(irq, arm_pmu);
> >> +}
> > I don't like this bit -- having a global cpu_handler field is going to
> > interfere with the big.LITTLE work and casting the per-cpu dev token is also
> > pretty hacky.
> >
> > However, you're forced down this route by the need to invoke the armpmu IRQ
> > dispatcher. Now, that only exists as a workaround for the braindead
> > interrupt routing on the u8500 (they OR'd all the PMU SPIs together) -- it's
> > not a problem that will affect a system using PPIs. If you look, there is
> > only one use of the thing in: arch/arm/mach-ux500/cpu-db8500.c.
> >
> > So, we could rename that callback to make it clear that it's not so much an
> > IRQ handler wrapper as a specific hack to deal with broken SPIs. Then the
> > cpu_pmu code can neglect to make the callback if it's using PPI.
> >
> > What do you think?
> 
> Yeah I hate this bouncing layer too but it was the best I could come up
> with. I'll rename it to 'armpmu_dispatch_spi_irq' (bikeshedding welcome).

That sounds fine.

> We can avoid the hacky cast of the per-cpu dev token by using the
> cpu_pmu pointer directly, but we'll still need to pass something to the
> percpu interrupt handler otherwise the genirq layer doesn't allow us to
> request the PPI. I can pass hw_events I guess. Is that what you're
> thinking? Or were you thinking that we could just use
> cpu_pmu->handle_irq as the handler argument in request_percpu_irq()? I
> can't figure out how that is supposed to work.

Actually, I was thinking you could remove cpu_pmu_dispatch_irq completely
and just pass the actual handler straight through to request_percpu_irq. On
arm64 we pass the hw_events as the pcpu token, so I'd be inclined to do the
same here unless there's a good reason not to.

Cheers,

Will
