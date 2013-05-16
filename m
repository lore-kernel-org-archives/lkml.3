Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab3EPKPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 06:15:22 -0400
Received: from ozlabs.org ([203.10.76.45]:42168 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab3EPKPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 06:15:19 -0400
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>, michael@ellerman.id.au,
        benh@kernel.crashing.org, Linux PPC dev <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH 3/3] perf, x86, lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL
In-reply-to: <20130516090916.GF19669@dyad.programming.kicks-ass.net>
References: <20130503121122.931661809@chello.nl> <20130503121256.230745028@chello.nl> <CABPqkBTvcQAyXfeiJwpPsNtbs4ffsVguXE631dK_rbzHpwBdOg@mail.gmail.com> <20130516090916.GF19669@dyad.programming.kicks-ass.net>
Comments: In-reply-to Peter Zijlstra <peterz@infradead.org>
   message dated "Thu, 16 May 2013 11:09:16 +0200."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Thu, 16 May 2013 20:15:17 +1000
Message-ID: <8578.1368699317@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, May 15, 2013 at 03:37:22PM +0200, Stephane Eranian wrote:
> > On Fri, May 3, 2013 at 2:11 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > We should always have proper privileges when requesting kernel data.
> > >
> > > Cc: Andi Kleen <ak@linux.intel.com>
> > > Cc: eranian@google.com
> > > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Link: http://lkml.kernel.org/n/tip-v0x9ky3ahzr6nm3c6ilwrili@git.kernel.org
> > > ---
> > >  arch/x86/kernel/cpu/perf_event_intel_lbr.c |    5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >
> > > --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> > > +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> > > @@ -318,8 +318,11 @@ static void intel_pmu_setup_sw_lbr_filte
> > >         if (br_type & PERF_SAMPLE_BRANCH_USER)
> > >                 mask |= X86_BR_USER;
> > >
> > > -       if (br_type & PERF_SAMPLE_BRANCH_KERNEL)
> > > +       if (br_type & PERF_SAMPLE_BRANCH_KERNEL) {
> > > +               if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
> > > +                       return -EACCES;
> > >                 mask |= X86_BR_KERNEL;
> > > +       }
> > >
> > This will prevent regular users from capturing kernel -> kernel branches.
> > But it won't prevent users from getting kernel -> user branches. Thus
> > some kernel address will still be captured. I guess they could be eliminated
> > by the sw_filter.
> > 
> > When using LBR priv level filtering, the filter applies to the branch target
> > only.
> 
> How about something like the below? It also adds the branch flags
> Mikey wanted for PowerPC.

Peter,

BTW PowerPC also has the ability to filter on conditional branches.  Any
chance we could add something like the follow to perf also?

Mikey

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index fb104e5..891c769 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -157,8 +157,9 @@ enum perf_branch_sample_type {
 	PERF_SAMPLE_BRANCH_ANY_CALL	= 1U << 4, /* any call branch */
 	PERF_SAMPLE_BRANCH_ANY_RETURN	= 1U << 5, /* any return branch */
 	PERF_SAMPLE_BRANCH_IND_CALL	= 1U << 6, /* indirect calls */
+	PERF_SAMPLE_BRANCH_CONDITIONAL  = 1U << 7, /* conditional branches */
 
-	PERF_SAMPLE_BRANCH_MAX		= 1U << 7, /* non-ABI */
+	PERF_SAMPLE_BRANCH_MAX		= 1U << 8, /* non-ABI */
 };
 
 #define PERF_SAMPLE_BRANCH_PLM_ALL \
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index cdf58ec..5b0b89d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -676,6 +676,7 @@ static const struct branch_mode branch_modes[] = {
 	BRANCH_OPT("any_call", PERF_SAMPLE_BRANCH_ANY_CALL),
 	BRANCH_OPT("any_ret", PERF_SAMPLE_BRANCH_ANY_RETURN),
 	BRANCH_OPT("ind_call", PERF_SAMPLE_BRANCH_IND_CALL),
+	BRANCH_OPT("cnd", PERF_SAMPLE_BRANCH_CONDITIONAL),
 	BRANCH_END
 };
 
