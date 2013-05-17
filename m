Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab3EQLO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:14:28 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58626
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752506Ab3EQLO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:14:27 -0400
Date: Fri, 17 May 2013 13:12:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH 3/3] perf, x86, lbr: Demand proper privileges for
 PERF_SAMPLE_BRANCH_KERNEL
Message-ID: <20130517111232.GE5162@dyad.programming.kicks-ass.net>
References: <20130503121122.931661809@chello.nl>
 <20130503121256.230745028@chello.nl>
 <CABPqkBTvcQAyXfeiJwpPsNtbs4ffsVguXE631dK_rbzHpwBdOg@mail.gmail.com>
 <20130516090916.GF19669@dyad.programming.kicks-ass.net>
 <8578.1368699317@ale.ozlabs.ibm.com>
 <20130516111634.GA15314@twins.programming.kicks-ass.net>
 <CABPqkBSCXJN7gLK_e_Q3YVVVFVGS78fo4j2z0+MmriqoXszH+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSCXJN7gLK_e_Q3YVVVFVGS78fo4j2z0+MmriqoXszH+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 05:36:11PM +0200, Stephane Eranian wrote:
> On Thu, May 16, 2013 at 1:16 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, May 16, 2013 at 08:15:17PM +1000, Michael Neuling wrote:
> >> Peter,
> >>
> >> BTW PowerPC also has the ability to filter on conditional branches.  Any
> >> chance we could add something like the follow to perf also?
> >>
> >
> > I don't see an immediate problem with that except that we on x86 need to
> > implement that in the software filter. Stephane do you see any
> > fundamental issue with that?
> >
> On X86, the LBR cannot filter on conditional in HW. Thus as Peter said, it would
> have to be done in SW. I did not add that because I think those branches are
> not necessarily useful for tools.

Wouldn't it be mostly conditional branches that are the primary control flow
and can get predicted wrong? I mean, I'm sure someone will miss-predict an
unconditional branch but its not like we care about people with such
afflictions do we?

Anyway, since PPC people thought it worth baking into hardware, presumably they
have a compelling use case. Mikey could you see if you can retrieve that from
someone in the know? It might be interesting.

Also, it looks like its trivial to add to x86, you seem to have already done
all the hard work by having X86_BR_JCC.

The only missing piece would be:

--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -337,6 +337,10 @@ static int intel_pmu_setup_sw_lbr_filter
 
 	if (br_type & PERF_SAMPLE_BRANCH_IND_CALL)
 		mask |= X86_BR_IND_CALL;
+
+	if (br_type & PERF_SAMPLE_BRANCH_CONDITIONAL)
+		mask |= X86_BR_JCC;
+
 	/*
 	 * stash actual user request into reg, it may
 	 * be used by fixup code for some CPU
