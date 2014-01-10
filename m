Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbaAJThE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 14:37:04 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53940 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaAJTg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 14:36:59 -0500
Date: Fri, 10 Jan 2014 11:36:57 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/7] ARM: perf_event: Support percpu irqs for the CPU
 PMU
Message-ID: <20140110193657.GG14405@codeaurora.org>
References: <1389221984-10973-1-git-send-email-sboyd@codeaurora.org>
 <1389221984-10973-3-git-send-email-sboyd@codeaurora.org>
 <20140109104943.GB17838@mudshark.cambridge.arm.com>
 <52CEF5C9.1010701@codeaurora.org>
 <20140110105813.GB10455@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110105813.GB10455@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10, Will Deacon wrote:
> On Thu, Jan 09, 2014 at 07:17:29PM +0000, Stephen Boyd wrote:
> 
> > We can avoid the hacky cast of the per-cpu dev token by using the
> > cpu_pmu pointer directly, but we'll still need to pass something to the
> > percpu interrupt handler otherwise the genirq layer doesn't allow us to
> > request the PPI. I can pass hw_events I guess. Is that what you're
> > thinking? Or were you thinking that we could just use
> > cpu_pmu->handle_irq as the handler argument in request_percpu_irq()? I
> > can't figure out how that is supposed to work.
> 
> Actually, I was thinking you could remove cpu_pmu_dispatch_irq completely
> and just pass the actual handler straight through to request_percpu_irq. On
> arm64 we pass the hw_events as the pcpu token, so I'd be inclined to do the
> same here unless there's a good reason not to.
> 

Passing the hw_events as the pcpu token here is kind of hacky.
The reason is because the token is dereferenced into cpu_pmu in
armv7pmu_handle_irq() like so:

	struct arm_pmu *cpu_pmu = (struct arm_pmu *)dev;

It would be great if we could pass cpu_pmu directly to the
request call like so:

	request_percpu_irq(irq, cpu_pmu->handle_irq, "arm-pmu", &cpu_pmu);

but no. request_percpu_irq() wants a percpu pointer so this won't
work. If cpu_pmu was declared as DEFINE_PER_CPU, this would work
out just fine.

Should the cpu_pmu become a per-cpu variable? That sounds rather
invasive.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
