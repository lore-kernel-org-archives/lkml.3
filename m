Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbaGIOGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:06:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:19291 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666AbaGIOGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:06:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,631,1400050800"; 
   d="scan'208";a="567370920"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH V4 1/2] perf ignore LBR and extra_regs.
Thread-Topic: [PATCH V4 1/2] perf ignore LBR and extra_regs.
Thread-Index: AQHPmw42PYiPusxucki+Ie3j6NurFZuW882AgADKCMA=
Date: Wed, 9 Jul 2014 14:04:44 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077014D1DB8@SHSMSX103.ccr.corp.intel.com>
References: <1404838181-3911-1-git-send-email-kan.liang@intel.com>
 <20140709092733.GD9918@twins.programming.kicks-ass.net>
In-Reply-To: <20140709092733.GD9918@twins.programming.kicks-ass.net>
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


> 
> On Tue, Jul 08, 2014 at 09:49:40AM -0700, kan.liang@intel.com wrote:
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
> >
> >  	/*
> >  	 * Intel host/guest support (KVM)
> 
> # pahole -C extra_reg arch/x86/kernel/cpu/perf_event_intel.o
> struct extra_reg {
>         unsigned int               event;                /*     0     4 */
>         unsigned int               msr;                  /*     4     4 */
>         u64                        config_mask;          /*     8     8 */
>         u64                        valid_mask;           /*    16     8 */
>         int                        idx;                  /*    24     4 */
> 
>         /* size: 32, cachelines: 1, members: 5 */
>         /* padding: 4 */
>         /* last cacheline: 32 bytes */
> };
> 
> There's still 4 empty bytes at the tail of extra_reg itself; would it make sense
> to store the availability of the reg in there?
> 

Now, it perfectly matches the 4 empty bytes. However, the extra_reg_type may be extended in the near future.   


> After all; the place we use it (x86_pmu_extra_regs) already has the pointer
> to the structure.


Yes, it's doable. However, if we move extra_msr_access to extra_reg, I guess we have to modify all the related micros (i.e EVENT_EXTRA_REG) to initialize the new items. That could be a big change.
On the other side, in x86_pmu structure, there are extra_regs related items defined under the comments "Extra registers for events". And the bit holes are enough for current usage and future extension.
I guess  x86_pmu should be a good place to store the availability of the reg. 


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


Thanks,
Kan
