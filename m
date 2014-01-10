Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbaAJKJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:09:04 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35236 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753128AbaAJKJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:09:00 -0500
Date: Fri, 10 Jan 2014 10:08:04 +0000
From: Will Deacon <will.deacon@arm.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Chad Paradis <chad.paradis@umit.maine.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [patch/rfc] perf on raspberry-pi without overflow interrupt
Message-ID: <20140110100804.GB11045@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.10.1401081613370.4410@vincent-weaver-1.um.maine.edu>
 <20140108225315.GG31570@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1401082245120.22965@vincent-weaver-1.um.maine.edu>
 <20140109101921.GA26435@mudshark.cambridge.arm.com>
 <alpine.DEB.2.10.1401092304590.31813@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1401092304590.31813@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 04:08:47AM +0000, Vince Weaver wrote:
> On Thu, 9 Jan 2014, Will Deacon wrote:
> 
> > I'd rather see it in the generic code if at all possible. Maybe we could add
> > a flags field to perf_pmu_register?
> 
> I can look into adding the check in generic code.
> 
> In the meantime, would you consider a patch like this that disables
> the IRQ check and lets ARM devices missing an IRQ (such as the rasp-pi)
> still have access to the counters?

In the absence of a core change, I think I'd rather have something like your
second patch, but without the extra no_overflow_irq field (you can check the
platform device, as I mentioned previously).

Cheers,

Will

> 
> diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
> index d85055c..ff1a752 100644
> --- a/arch/arm/kernel/perf_event_cpu.c
> +++ b/arch/arm/kernel/perf_event_cpu.c
> @@ -97,8 +97,8 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
>  
>  	irqs = min(pmu_device->num_resources, num_possible_cpus());
>  	if (irqs < 1) {
> -		pr_err("no irqs for PMUs defined\n");
> -		return -ENODEV;
> +		printk_once("no irqs for PMUs defined, sampling events not supported\n");
> +		return 0;
>  	}
>  
>  	for (i = 0; i < irqs; ++i) {
> 
> 
