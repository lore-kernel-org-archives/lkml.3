Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaGHOWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:22:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:48940 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbaGHOWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:22:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,625,1400050800"; 
   d="scan'208";a="569999417"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH V3 1/2] perf ignore LBR and offcore_rsp.
Thread-Topic: [PATCH V3 1/2] perf ignore LBR and offcore_rsp.
Thread-Index: AQHPminNzOpbLO3T9E6R7RvweHK0aZuVY8SAgADKV5A=
Date: Tue, 8 Jul 2014 14:22:25 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077014CDF76@SHSMSX103.ccr.corp.intel.com>
References: <1404740066-4374-1-git-send-email-kan.liang@intel.com>
 <20140708092923.GC6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140708092923.GC6758@twins.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Tuesday, July 08, 2014 5:29 AM
> To: Liang, Kan
> Cc: andi@firstfloor.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.org
> Subject: Re: [PATCH V3 1/2] perf ignore LBR and offcore_rsp.
> 
> On Mon, Jul 07, 2014 at 06:34:25AM -0700, kan.liang@intel.com wrote:
> > @@ -555,7 +577,11 @@ static inline void __x86_pmu_enable_event(struct
> > hw_perf_event *hwc,  {
> >  	u64 disable_mask =
> > __this_cpu_read(cpu_hw_events.perf_ctr_virt_mask);
> >
> > -	if (hwc->extra_reg.reg)
> > +	if (hwc->extra_reg.reg &&
> > +		((hwc->extra_reg.idx == EXTRA_REG_RSP_0) ?
> > +			x86_pmu.extra_msr_access[0] : true) &&
> > +		((hwc->extra_reg.idx == EXTRA_REG_RSP_1) ?
> > +			x86_pmu.extra_msr_access[1] : true))
> >  		wrmsrl(hwc->extra_reg.reg, hwc->extra_reg.config);
> >  	wrmsrl(hwc->config_base, (hwc->config | enable_mask) &
> > ~disable_mask);  }
> 
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel.c
> > b/arch/x86/kernel/cpu/perf_event_intel.c
> > index adb02aa..3d18765 100644
> > --- a/arch/x86/kernel/cpu/perf_event_intel.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> 
> > +	/*
> > +	 * Access extra MSR may cause #GP under certain circumstances.
> > +	 * E.g. KVM doesn't support offcore event
> > +	 * Check all extra_regs here.
> > +	 */
> > +	if (x86_pmu.extra_regs) {
> > +		x86_pmu.extra_msr_access[0] =
> > +
> 	check_msr(x86_pmu.extra_regs[EXTRA_REG_RSP_0].msr);
> > +
> > +		/* Not all platforms have EXTRA_REG_RSP_1 */
> > +		if (x86_pmu.extra_regs[EXTRA_REG_RSP_1].idx ==
> EXTRA_REG_RSP_1)
> > +			x86_pmu.extra_msr_access[1] =
> > +
> 	check_msr(x86_pmu.extra_regs[EXTRA_REG_RSP_1].msr);
> > +		/*
> > +		 * If there is no EXTRA_REG_RSP_1 support,
> > +		 * just set the flag to be true.
> > +		 * So it is ignored at the runtime check.
> > +		 */
> > +		else
> > +			x86_pmu.extra_msr_access[1] = true;
> > +	}
> 
> This too is wrong in many ways; there's more than 2 extra_msrs on many
> systems.
> 
Right, there are four extra  reg types on Intel systems. Since my previous test only triggers the crash with RSP_0 and RSP_1, so I only handle these two msrs.
I will handle all the extra msrs then.

> And the place you check is abysmal, if we know at init time that we don't
> have those MSRs, WTF do you allow event creation that would use them,
> only to then misbehave?

Right, we can check it at all the possible creation places.
I think the most common place to check should be x86_pmu_extra_regs.
For RSP_0 and RSP_1, I also plan to do the check in intel_fixup_er, so extra_reg will not be updated.
For LBR select, lbr_sel_map will be cleared at runtime once check_msr failed.
Besides the three places, is there any place I missed?

Thanks,
Kan


