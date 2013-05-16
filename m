Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab3EPJLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 05:11:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48693 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3EPJLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 05:11:02 -0400
Date: Thu, 16 May 2013 11:09:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH 3/3] perf, x86, lbr: Demand proper privileges for
 PERF_SAMPLE_BRANCH_KERNEL
Message-ID: <20130516090916.GF19669@dyad.programming.kicks-ass.net>
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

How about something like the below? It also adds the branch flags Mikey wanted
for PowerPC.

---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 12 +++++++++---
 include/linux/perf_event.h                 | 10 +++++++---
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index d978353..f44d635 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -585,17 +585,23 @@ intel_pmu_lbr_filter(struct cpu_hw_events *cpuc)
 
 		/* if type does not correspond, then discard */
 		if (type == X86_BR_NONE || (br_sel & type) != type) {
-			cpuc->lbr_entries[i].from = 0;
+			cpuc->lbr_entries[i].__delete = 1;
 			compress = true;
 		}
+
+		/* hide kernel addresses if we're not privileged  */
+		if (!(br_sel & X86_BR_KERNEL) && kernel_ip(from)) {
+			cpuc->lbr_entries[i].from = -1L;
+			cpuc->lbr_entries[i].invalid_from = 1;
+		}
 	}
 
 	if (!compress)
 		return;
 
-	/* remove all entries with from=0 */
+	/* remove all entries with __delete */
 	for (i = 0; i < cpuc->lbr_stack.nr; ) {
-		if (!cpuc->lbr_entries[i].from) {
+		if (cpuc->lbr_entries[i].__delete) {
 			j = i;
 			while (++j < cpuc->lbr_stack.nr)
 				cpuc->lbr_entries[j-1] = cpuc->lbr_entries[j];
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f463a46..7acf1c9 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -77,9 +77,13 @@ struct perf_raw_record {
 struct perf_branch_entry {
 	__u64	from;
 	__u64	to;
-	__u64	mispred:1,  /* target mispredicted */
-		predicted:1,/* target predicted */
-		reserved:62;
+	__u64	mispred:1,	/* target mispredicted		*/
+		predicted:1,	/* target predicted		*/
+		invalid_to:1,	/* @to isn't to be trusted	*/
+		invalid_from:1, /* @from isn't to be trusted	*/
+		reserved:59,
+		__delete:1;	/* Implementation; userspace should
+				   always see a 0 		*/
 };
 
 /*

