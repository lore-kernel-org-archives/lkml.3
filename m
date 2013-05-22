Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab3EVKU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:20:29 -0400
Received: from ozlabs.org ([203.10.76.45]:54405 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862Ab3EVKU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:20:26 -0400
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au,
        eranian@google.com, ak@linux.intel.com, mingo@kernel.org
Subject: Re: [PATCH 2/5] powerpc, perf: Enable conditional branch filter for POWER8
In-reply-to: <20130522075305.GN26912@twins.programming.kicks-ass.net>
References: <1369203761-12649-1-git-send-email-khandual@linux.vnet.ibm.com> <1369203761-12649-3-git-send-email-khandual@linux.vnet.ibm.com> <20130522075305.GN26912@twins.programming.kicks-ass.net>
Comments: In-reply-to Peter Zijlstra <peterz@infradead.org>
   message dated "Wed, 22 May 2013 09:53:05 +0200."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Wed, 22 May 2013 20:20:24 +1000
Message-ID: <1038.1369218024@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, May 22, 2013 at 11:52:38AM +0530, Anshuman Khandual wrote:
> > Enables conditional branch filter support for POWER8
> > utilizing MMCRA register based filter and also invalidates
> > a BHRB branch filter combination involving conditional
> > branches.
> > 
> > Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> > ---
> >  arch/powerpc/perf/power8-pmu.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
> > index 8ed323d..e60b38f 100644
> > --- a/arch/powerpc/perf/power8-pmu.c
> > +++ b/arch/powerpc/perf/power8-pmu.c
> > @@ -548,11 +548,21 @@ static u64 power8_bhrb_filter_map(u64 branch_sample_type)
> >  	if (branch_sample_type & PERF_SAMPLE_BRANCH_IND_CALL)
> >  		return -1;
> >  
> > +	/* Invalid branch filter combination - HW does not support */
> > +	if ((branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) &&
> > +			(branch_sample_type & PERF_SAMPLE_BRANCH_COND))
> > +		return -1;
> > +
> >  	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) {
> >  		pmu_bhrb_filter |= POWER8_MMCRA_IFM1;
> >  		return pmu_bhrb_filter;
> >  	}
> >  
> > +	if (branch_sample_type & PERF_SAMPLE_BRANCH_COND) {
> > +		pmu_bhrb_filter |= POWER8_MMCRA_IFM3;
> > +		return pmu_bhrb_filter;
> > +	}
> > +
> >  	/* Every thing else is unsupported */
> >  	return -1;
> >  }
> 
> So I suppose you've seen what x86 does in this case? ;-) I'm not saying
> you _have_ to do the software filter, but I would like the changelog to at
> least mention the issue.
> 
> In fact, I suppose that should have been in the original patches :/ as
> this patch series only adds the conditional branch support. 

Anshuman,

Now we have the branch reading and parsing code (for the "to" case), we
should use that to do what Peter is suggesting.  

Mikey
