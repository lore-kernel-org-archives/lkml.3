Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227AbaK1K2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:28:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:59238 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbaK1K2W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:28:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="422611619"
From: "Berthier, Emmanuel" <emmanuel.berthier@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "Jarzmik, Robert" <robert.jarzmik@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: RE: [PATCH v2] [LBR] Dump LBRs on Exception
Thread-Topic: [PATCH v2] [LBR] Dump LBRs on Exception
Thread-Index: AQHQClAp6CYIYedu6ESpcFdbEVpmDZx0+/cAgADBLbA=
Date: Fri, 28 Nov 2014 10:28:19 +0000
Message-ID: <65CD3FC07F3BF942ABE211646D72D770356EB330@IRSMSX110.ger.corp.intel.com>
References: <65CD3FC07F3BF942ABE211646D72D770356EACA5@IRSMSX110.ger.corp.intel.com>
 <1417099205-13309-1-git-send-email-emmanuel.berthier@intel.com>
 <alpine.DEB.2.11.1411271609510.3961@nanos>
In-Reply-To: <alpine.DEB.2.11.1411271609510.3961@nanos>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.180]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Thursday, November 27, 2014 10:23 PM
> To: Berthier, Emmanuel
> Cc: H. Peter Anvin; x86@kernel.org; Jarzmik, Robert; LKML; Andy Lutomirski
> Subject: Re: [PATCH v2] [LBR] Dump LBRs on Exception
> 
> On Thu, 27 Nov 2014, Emmanuel Berthier wrote:
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> > b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> > index 45fa730..0a69365 100644
> > --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> > @@ -4,7 +4,7 @@
> >  #include <asm/perf_event.h>
> >  #include <asm/msr.h>
> >  #include <asm/insn.h>
> > -
> 
> This newline is intentional to seperate asm includes from the local one.

Got it.

> >  static void __intel_pmu_lbr_enable(void)  {
> >  	u64 debugctl;
> >  	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
> >
> > +	lbr_set_used_by_perf(true);
> 
> This cannot work.
> 
> CPU0					CPU1
> 
> __intel_pmu_lbr_enable()
>    lbr_set_used_by_perf(true);
> 					__intel_pmu_lbr_disable()
> 					  lbr_set_used_by_perf(false);
> 
> This is a per cpu property.
> 
> And there is more to that. Let's look at a single CPU.
> 
> lbr for oops is enabled
> 
> context switch()
>    __intel_pmu_lbr_enable()	-> LBR used by perf, oops dumper disabled
> 
> context switch()
>    __intel_pmu_lbr_disable()	-> LBR not longer used by perf, oops
>    				   dumper enabled
> 
> So after that context switch we crash in the kernel and LBR is empty because
> we did disable it at the context switch.
> 
> So you need per cpu state, which handles the LBR dumper state:
> 
> #define LBR_OOPS_DISABLED 0x01
> #define LBR_PERF_USAGE	  0x02
> 
> DEFINE_PER_CPU(unsigned long, lbr_dump_state) = LBR_OOPS_DISABLED;
> 
> lbr_perf_enable()
> 	this_cpu_add(lbr_dump_state, LBR_PERF_USAGE);
> 
> lbr_perf_disable()
> 	if (!this_cpu_sub_return(lbr_dump_state, LBR_PERF_USAGE))
> 	   	enable_lbr_oops();
> 
> Now of course you need to handle this in the exception path per cpu as well.

Agree, I will do that.

Thx.
Emmanuel.

