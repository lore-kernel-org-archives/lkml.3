Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbaGNO2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:28:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:47292 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196AbaGNO2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:28:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,658,1400050800"; 
   d="scan'208";a="456740229"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH V5 1/2] perf ignore LBR and extra_regs
Thread-Topic: [PATCH V5 1/2] perf ignore LBR and extra_regs
Thread-Index: AQHPnG+hivFH9gFqr0Syb8Ke5/aDbZue5MOAgACz8nA=
Date: Mon, 14 Jul 2014 14:28:36 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077014E1D5E@SHSMSX103.ccr.corp.intel.com>
References: <1404989984-3068-1-git-send-email-kan.liang@intel.com>
 <20140714105341.GT9918@twins.programming.kicks-ass.net>
In-Reply-To: <20140714105341.GT9918@twins.programming.kicks-ass.net>
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



> > diff --git a/arch/x86/kernel/cpu/perf_event.h
> > b/arch/x86/kernel/cpu/perf_event.h
> > index 3b2f9bd..992c678 100644
> > --- a/arch/x86/kernel/cpu/perf_event.h
> > +++ b/arch/x86/kernel/cpu/perf_event.h
> > @@ -464,6 +464,12 @@ struct x86_pmu {
> >  	 */
> >  	struct extra_reg *extra_regs;
> >  	unsigned int er_flags;
> > +	/*
> > +	 * EXTRA REG MSR can be accessed
> > +	 * The extra registers are completely unrelated to each other.
> > +	 * So it needs a flag for each extra register.
> > +	 */
> > +	bool		extra_msr_access[EXTRA_REG_MAX];
> 
> So why not in struct extra_reg again? You didn't give a straight answer there.

I think I did in the email.
You mentioned that there's still (only) 4 empty bytes at the tail of extra_reg itself. 
However, the extra_reg_type may be extended in the near future.
So that may not be a reason to move to extra_reg.

Furthermore, if we move extra_msr_access to extra_reg, 
I guess we have to modify all the related micros (i.e EVENT_EXTRA_REG) to initialize the new items.
That could be a big change.

On the other side, in x86_pmu structure, there are extra_regs related items defined under the comments "Extra registers for events".
 And the bit holes are enough for current usage and future extension.

So I guess  x86_pmu should be a good place to store the availability of the reg.

         /* --- cacheline 6 boundary (384 bytes) --- */
         bool                       lbr_double_abort;     /*   384     1 */
 
         /* XXX 7 bytes hole, try to pack */
 
         struct extra_reg *         extra_regs;           /*   392     8 */
         unsigned int               er_flags;             /*   400     4 */
 
         /* XXX 4 bytes hole, try to pack */
 
         struct perf_guest_switch_msr * (*guest_get_msrs)(int *); /*   408     8 */
 
         /* size: 416, cachelines: 7, members: 64 */
         /* sum members: 391, holes: 6, sum holes: 25 */
         /* bit holes: 1, sum bit holes: 27 bits */
         /* last cacheline: 32 bytes */

> 
> > +/*
> > + * Under certain circumstances, access certain MSR may cause #GP.
> > + * The function tests if the input MSR can be safely accessed.
> > + */
> > +static inline bool check_msr(unsigned long msr) {
> 
> This reads like a generic function;
> 
> > +	u64 val_old, val_new, val_tmp;
> > +
> > +	/*
> > +	 * Read the current value, change it and read it back to see if it
> > +	 * matches, this is needed to detect certain hardware emulators
> > +	 * (qemu/kvm) that don't trap on the MSR access and always return
> 0s.
> > +	 */
> > +	if (rdmsrl_safe(msr, &val_old))
> > +		goto msr_fail;
> > +	/*
> > +	 * Only chagne it slightly,
> > +	 * since the higher bits of some MSRs cannot be updated by wrmsrl.
> > +	 * E.g. MSR_LBR_TOS
> > +	 */
> > +	val_tmp = val_old ^ 0x3UL;
> 
> but this is not generally true; not all MSRs can write the 2 LSB, can they? One
> option would be to extend the function with a u64 mask.

Right, the function should be easily used to check all MSRs, not just for the MSRs I tested.
I will pass a mask as a parameter of the function.  

> 
> > +	if (wrmsrl_safe(msr, val_tmp) ||
> > +		rdmsrl_safe(msr, &val_new))
> > +		goto msr_fail;
> > +
> > +	if (val_new != val_tmp)
> > +		goto msr_fail;
> > +
> > +	/* Here it's sure that the MSR can be safely accessed.
> > +	 * Restore the old value and return.
> > +	 */
> > +	wrmsrl(msr, val_old);
> > +
> > +	return true;
> > +
> > +msr_fail:
> > +	return false;
> > +}
> 
> Also, by now this function is far too large to be inline and in a header.

OK. I will move it to perf_event_intel.c as a static function.

