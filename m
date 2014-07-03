Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067AbaGCE0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 00:26:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:21132 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbaGCE0h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 00:26:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,592,1400050800"; 
   d="scan'208";a="556755889"
From: "Liang, Kan" <kan.liang@intel.com>
To: Andi Kleen <ak@linux.intel.com>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: RE: [PATCH V2 1/3] perf ignore LBR and offcore_rsp.
Thread-Topic: [PATCH V2 1/3] perf ignore LBR and offcore_rsp.
Thread-Index: AQHPlmMa2+E29q6Tk0SWaq86jnLk6JuNFpsAgACPO4A=
Date: Thu, 3 Jul 2014 04:26:30 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077014BDCB4@SHSMSX103.ccr.corp.intel.com>
References: <1404324855-15166-1-git-send-email-kan.liang@intel.com>
 <20140703021606.GT19781@tassilo.jf.intel.com>
In-Reply-To: <20140703021606.GT19781@tassilo.jf.intel.com>
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



> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> I did not contribute to this patch, so please remove that SOB.
> 

OK

> > Signed-off-by: Kan Liang <kan.liang@intel.com>
> 
> >  	struct extra_reg *extra_regs;
> >  	unsigned int er_flags;
> > +	bool		extra_msr_access;	   /* EXTRA REG MSR can be
> accessed */
> >
> 
> This doesn't look right, needs a flag for each extra register.
> 
> They are completely unrelated to each other.

The extra register is either MSR_OFFCORE_RSP_0 or MSR_OFFCORE_RSP_1.
I will add two variables to handle them.

> 
> BTW this will also cause KVM messages at each boot now.
>

Do you mean the "unhandled wrmsr" or " unhandled rdmsr " messages? 
You should not observer  such error message for offcore msrs and LBR from/to msrs.

But I forget to handle LBR TOS in KVM patch. You may observed unhandled rdmsr: 0x1c9 when doing LBR in guest.
I will fix it in next version.
 
> >  		wrmsrl(hwc->extra_reg.reg, hwc->extra_reg.config);
> >  	wrmsrl(hwc->config_base, (hwc->config | enable_mask) &
> > ~disable_mask);  } diff --git a/arch/x86/kernel/cpu/perf_event_intel.c
> > b/arch/x86/kernel/cpu/perf_event_intel.c
> > index adb02aa..8011d42 100644
> > --- a/arch/x86/kernel/cpu/perf_event_intel.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> > @@ -2565,6 +2565,13 @@ __init int intel_pmu_init(void)
> >  		}
> >  	}
> >
> > +	/* Access LBR MSR may cause #GP under certain circumstances. E.g.
> KVM doesn't support LBR MSR */
> > +	if (x86_pmu.lbr_nr)
> > +		x86_pmu.lbr_msr_access =
> test_msr_access(x86_pmu.lbr_tos) &
> > +test_msr_access(x86_pmu.lbr_from);
> 
> s/&/&&/
> 
> And also this doesn't cover the case when someone takes over the LBRs and
> they start #GPing later.
> So for LBR the test has to be still at each access.

In the second patch, the LBR test has been moved to runtime check.
This case has been handled.  


Kan

> 
> -Andi
