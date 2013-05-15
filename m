Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273Ab3EOOai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:30:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34426 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758992Ab3EOOai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:30:38 -0400
Date: Wed, 15 May 2013 16:30:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH 3/3] perf, x86, lbr: Demand proper privileges for
 PERF_SAMPLE_BRANCH_KERNEL
Message-ID: <20130515143019.GA13916@laptop.home>
References: <20130503121122.931661809@chello.nl>
 <20130503121256.230745028@chello.nl>
 <CABPqkBTvcQAyXfeiJwpPsNtbs4ffsVguXE631dK_rbzHpwBdOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTvcQAyXfeiJwpPsNtbs4ffsVguXE631dK_rbzHpwBdOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 03:37:22PM +0200, Stephane Eranian wrote:
> On Fri, May 3, 2013 at 2:11 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > We should always have proper privileges when requesting kernel data.
> >
> > Cc: Andi Kleen <ak@linux.intel.com>
> > Cc: eranian@google.com
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Link: http://lkml.kernel.org/n/tip-v0x9ky3ahzr6nm3c6ilwrili@git.kernel.org
> > ---
> >  arch/x86/kernel/cpu/perf_event_intel_lbr.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> > @@ -318,8 +318,11 @@ static void intel_pmu_setup_sw_lbr_filte
> >         if (br_type & PERF_SAMPLE_BRANCH_USER)
> >                 mask |= X86_BR_USER;
> >
> > -       if (br_type & PERF_SAMPLE_BRANCH_KERNEL)
> > +       if (br_type & PERF_SAMPLE_BRANCH_KERNEL) {
> > +               if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
> > +                       return -EACCES;
> >                 mask |= X86_BR_KERNEL;
> > +       }
> >
> This will prevent regular users from capturing kernel -> kernel branches.
> But it won't prevent users from getting kernel -> user branches. Thus
> some kernel address will still be captured. I guess they could be eliminated
> by the sw_filter.
> 
> When using LBR priv level filtering, the filter applies to the branch target
> only.

Ah, indeed. I'll try and whip up a patch.
