Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaAIKUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:20:53 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41928 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843AbaAIKUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:20:44 -0500
Date: Thu, 9 Jan 2014 10:19:21 +0000
From: Will Deacon <will.deacon@arm.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [patch/rfc] perf on raspberry-pi without overflow interrupt
Message-ID: <20140109101921.GA26435@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.10.1401081613370.4410@vincent-weaver-1.um.maine.edu>
 <20140108225315.GG31570@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1401082245120.22965@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1401082245120.22965@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vince,

On Thu, Jan 09, 2014 at 03:47:19AM +0000, Vince Weaver wrote:
> On Wed, 8 Jan 2014, Peter Zijlstra wrote:
> 
> > On Wed, Jan 08, 2014 at 04:28:20PM -0500, Vince Weaver wrote:
> > > Should the perf_event interface handle setups like this better and work 
> > > fine in aggregate mode but return ENOTSUP if a sampled or overflow event 
> > > is attempted?
> > 
> > Yeah that would be better, we do something similar for P6 class machines
> > without lapic IIRC.
> 
> You're right.  Something like the following works for me on the rasp-pi,
> although maybe if x86 is doing it too things should be moved up into 
> generic code?

I'd rather see it in the generic code if at all possible. Maybe we could add
a flags field to perf_pmu_register?

> Return EOPNOTSUPP if we have no PMU overflow interrupt but a
> sampled event is requested.
> 
> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
> 
> diff --git a/arch/arm/include/asm/pmu.h b/arch/arm/include/asm/pmu.h
> index f24edad..f1f27a3 100644
> --- a/arch/arm/include/asm/pmu.h
> +++ b/arch/arm/include/asm/pmu.h
> @@ -87,6 +87,7 @@ struct arm_pmu {
>  	u64		max_period;
>  	struct platform_device	*plat_device;
>  	struct pmu_hw_events	*(*get_hw_events)(void);
> +	int		no_overflow_interrupt;

For the arm bits, we can actually use platform_get_irq on the platform
device and avoid the need for a new field in here.

Cheers,

Will
