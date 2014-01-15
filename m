Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaAOKeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:34:14 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58532 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010AbaAOKeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:34:11 -0500
Date: Wed, 15 Jan 2014 10:33:37 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/7] ARM: perf_event: Support percpu irqs for the CPU PMU
Message-ID: <20140115103337.GB15422@mudshark.cambridge.arm.com>
References: <1389221984-10973-1-git-send-email-sboyd@codeaurora.org>
 <1389221984-10973-3-git-send-email-sboyd@codeaurora.org>
 <20140109104943.GB17838@mudshark.cambridge.arm.com>
 <52CEF5C9.1010701@codeaurora.org>
 <20140110105813.GB10455@mudshark.cambridge.arm.com>
 <20140110193657.GG14405@codeaurora.org>
 <20140113115213.GE1189@mudshark.cambridge.arm.com>
 <52D5A4D1.9030403@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D5A4D1.9030403@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, Jan 14, 2014 at 08:57:53PM +0000, Stephen Boyd wrote:
> On 01/13/14 03:52, Will Deacon wrote:
> > I also don't think that's the right solution, based on the above. It's
> > actually pretty hard to work out what's the right thing to do here...
> 
> Yes it doesn't seem like the right solution.
> 
> >
> > We *could* have a per-cpu pointer to the cpu_pmu_pointer, but then we'd
> > need to update the IRQ handlers, including things like the CCI PMU which
> > really doesn't care about per-cpu stuff. So after all this, the shim we have
> > around the IRQ handler for the U8500 SPI workarounds might be the right
> > thing after all -- it allows us to consolidate the conversion of a pcpu
> > pointer into the relevant instance (actually any instance, since they'd all
> > point at the same thing) for the current CPU.
> >
> > What do you think to having that shim throw away the second level pcpu
> > pointer in the case of a PPI? (probably means we need to revisit that
> > renaming again).
> 
> Ok I think I understand what you're getting at. We pass a per-cpu
> pointer to the cpu_pmu pointer as the dev_id argument to the PPI irq
> handler, and then we check to see if the irq is per-cpu inside the
> armpmu_dispatch_irq() function and throw away the second level of
> pointer, i.e.
> 
> static irqreturn_t armpmu_dispatch_irq(int irq, void *dev)
> {
>         struct arm_pmu *armpmu;
>         struct platform_device *plat_device;
>         struct arm_pmu_platdata *plat;
> 
>         if (irq_is_percpu(irq))
>                 dev = *(struct arm_pmu_cpu **)dev;
>         armpmu = dev;
>         plat_device = armpmu->plat_device;
>         plat = dev_get_platdata(&plat_device->dev);
> 
>         if (plat && plat->handle_irq)
>                 return plat->handle_irq(irq, dev, armpmu->handle_irq);
>         else
>                 return armpmu->handle_irq(irq, dev);
> }

Yup, that's what I was trying to explain (badly). Thanks.

> We still need to make a per-cpu variable to hold the pointer, and assign
> it during cpu_pmu_init like this patch does. Hopefully that is ok.

I think that's ok. The percpu code in genirq requires a pcpu token (for good
reason) and the irq handler needs to get at the pmu structure. The
alternative is adding pointers from something like the pmu_hw_events to the
arm_pmu, but I think that's more ugly.

Will
