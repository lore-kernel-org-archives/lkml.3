Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaETJM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:12:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60284 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaETJM4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:12:56 -0400
Date: Tue, 20 May 2014 11:12:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/3] perf, ARM: use common PMU interrupt disabled code
Message-ID: <20140520091246.GT2485@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1405161701160.11099@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405161712190.11099@vincent-weaver-1.umelst.maine.edu>
 <20140519155710.GK15130@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140519155710.GK15130@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 04:57:10PM +0100, Will Deacon wrote:
> On Fri, May 16, 2014 at 10:15:49PM +0100, Vince Weaver wrote:
> > 
> > Make the ARM perf code use the new common PMU interrupt disabled code.
> > 
> > This allows perf to work on ARM machines without a working PMU
> > interrupt (for example, raspberry pi).
> > 
> > Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
> > 
> > diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> > index a6bc431..4238bcb 100644
> > --- a/arch/arm/kernel/perf_event.c
> > +++ b/arch/arm/kernel/perf_event.c
> > @@ -410,7 +410,7 @@ __hw_perf_event_init(struct perf_event *event)
> >  	 */
> >  	hwc->config_base	    |= (unsigned long)mapping;
> >  
> > -	if (!hwc->sample_period) {
> > +	if (!is_sampling_event(event)) {
> >  		/*
> >  		 * For non-sampling runs, limit the sample_period to half
> >  		 * of the counter width. That way, the new counter value
> > diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
> > index 51798d7..63d95fa 100644
> > --- a/arch/arm/kernel/perf_event_cpu.c
> > +++ b/arch/arm/kernel/perf_event_cpu.c
> > @@ -126,8 +126,8 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
> >  
> >  	irqs = min(pmu_device->num_resources, num_possible_cpus());
> >  	if (irqs < 1) {
> > -		pr_err("no irqs for PMUs defined\n");
> > -		return -ENODEV;
> > +		printk_once("no irqs for PMU defined, sampled events not supported\n");
> 
> s/sampled/sampling/
> 
> > +		return 0;
> >  	}
> >  
> >  	irq = platform_get_irq(pmu_device, 0);
> > @@ -191,6 +191,11 @@ static void cpu_pmu_init(struct arm_pmu *cpu_pmu)
> >  	/* Ensure the PMU has sane values out of reset. */
> >  	if (cpu_pmu->reset)
> >  		on_each_cpu(cpu_pmu->reset, cpu_pmu, 1);
> > +
> > +	/* If no interrupts available, set the corresponding capability flag */
> > +	if (platform_get_irq(cpu_pmu->plat_device, 0) <= 0) {
> 
> I think you can just do if (!platform_get_irq(cpu_pmu->plat_device, 0))
> here (I appreciate the ARM perf code isn't consistent here).
> 
> Anyway, with those minor changes:
> 
>   Acked-by: Will Deacon <will.deacon@arm.com>

I did those two changes (and one of my own), thanks!
