Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab3EQLcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:32:11 -0400
Received: from ozlabs.org ([203.10.76.45]:39102 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab3EQLcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:32:10 -0400
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH 3/3] perf, x86, lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL
In-reply-to: <20130517111232.GE5162@dyad.programming.kicks-ass.net>
References: <20130503121122.931661809@chello.nl> <20130503121256.230745028@chello.nl> <CABPqkBTvcQAyXfeiJwpPsNtbs4ffsVguXE631dK_rbzHpwBdOg@mail.gmail.com> <20130516090916.GF19669@dyad.programming.kicks-ass.net> <8578.1368699317@ale.ozlabs.ibm.com> <20130516111634.GA15314@twins.programming.kicks-ass.net> <CABPqkBSCXJN7gLK_e_Q3YVVVFVGS78fo4j2z0+MmriqoXszH+w@mail.gmail.com> <20130517111232.GE5162@dyad.programming.kicks-ass.net>
Comments: In-reply-to Peter Zijlstra <peterz@infradead.org>
   message dated "Fri, 17 May 2013 13:12:32 +0200."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Fri, 17 May 2013 21:32:08 +1000
Message-ID: <29969.1368790328@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, May 16, 2013 at 05:36:11PM +0200, Stephane Eranian wrote:
> > On Thu, May 16, 2013 at 1:16 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Thu, May 16, 2013 at 08:15:17PM +1000, Michael Neuling wrote:
> > >> Peter,
> > >>
> > >> BTW PowerPC also has the ability to filter on conditional branches.  Any
> > >> chance we could add something like the follow to perf also?
> > >>
> > >
> > > I don't see an immediate problem with that except that we on x86 need to
> > > implement that in the software filter. Stephane do you see any
> > > fundamental issue with that?
> > >
> > On X86, the LBR cannot filter on conditional in HW. Thus as Peter said, it would
> > have to be done in SW. I did not add that because I think those branches are
> > not necessarily useful for tools.
> 
> Wouldn't it be mostly conditional branches that are the primary control flow
> and can get predicted wrong? I mean, I'm sure someone will miss-predict an
> unconditional branch but its not like we care about people with such
> afflictions do we?

You could mispredict the target address of a computed goto.  You'd know
it was taken but not know target address until later in the pipeline.

On this, the POWER8 branch history buffer tells us two things about the
prediction status.  
  1) if the branch was predicted taken/not taken correctly
  2) if the target address was predicted correctly or not (for computed
     gotos only)
So we'd actually like more prediction bits too :-D

> Anyway, since PPC people thought it worth baking into hardware,
> presumably they have a compelling use case. Mikey could you see if you
> can retrieve that from someone in the know? It might be interesting.

I don't think we can mispredict a non-conditional non-computed but I'll
have to check with the HW folks.

Mikey

>
> Also, it looks like its trivial to add to x86, you seem to have already done
> all the hard work by having X86_BR_JCC.
> 
> The only missing piece would be:
> 
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -337,6 +337,10 @@ static int intel_pmu_setup_sw_lbr_filter
>  
>  	if (br_type & PERF_SAMPLE_BRANCH_IND_CALL)
>  		mask |= X86_BR_IND_CALL;
> +
> +	if (br_type & PERF_SAMPLE_BRANCH_CONDITIONAL)
> +		mask |= X86_BR_JCC;
> +
>  	/*
>  	 * stash actual user request into reg, it may
>  	 * be used by fixup code for some CPU
> 
