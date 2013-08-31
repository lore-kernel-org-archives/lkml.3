Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab3HaPIJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 11:08:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57859 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3HaPIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 11:08:07 -0400
Date: Sat, 31 Aug 2013 17:07:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org, acme@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] perf, x86: Avoid checkpointed counters causing
 excessive TSX aborts v4
Message-ID: <20130831150755.GY31370@twins.programming.kicks-ass.net>
References: <1377128846-977-1-git-send-email-andi@firstfloor.org>
 <1377128846-977-2-git-send-email-andi@firstfloor.org>
 <20130830160215.GU31370@twins.programming.kicks-ass.net>
 <20130830204445.GF16724@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130830204445.GF16724@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 01:44:45PM -0700, Andi Kleen wrote:
> On Fri, Aug 30, 2013 at 06:02:15PM +0200, Peter Zijlstra wrote:
> > On Wed, Aug 21, 2013 at 04:47:23PM -0700, Andi Kleen wrote:
> > > @@ -1224,6 +1240,15 @@ again:
> > >  		x86_pmu.drain_pebs(regs);
> > >  	}
> > >  
> > > +	/*
> > > +	 * To avoid spurious interrupts with perf stat always reset checkpointed
> > > +	 * counters.
> > > +	 *
> > > +	 * XXX move somewhere else.
> > > +	 */
> > > +	if (cpuc->events[2] && event_is_checkpointed(cpuc->events[2]))
> > > +		status |= (1ULL << 2);
> > > +
> > >  	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
> > >  		struct perf_event *event = cpuc->events[bit];
> > >  

> So can just drop the XXX comment. Ok?

How about hiding the entire thing in a hsw function. I'm fairly sure
that eventually we'll need to check all counters for this nonsense.

Something like so perhaps?

---
 arch/x86/kernel/cpu/perf_event_intel.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index a45d8d4..2a400b7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1170,6 +1170,20 @@ static void intel_pmu_reset(void)
 	local_irq_restore(flags);
 }
 
+static void intel_pmu_hsw_tsx_status(struct cpu_hw_event *cpuc, u64 *status)
+{
+	const int idx = 2; /* only cnt2 supports TSX for now */
+	struct perf_event *event = cpuc->event[idx];
+
+	if (event_is_checkpoint(event)) {
+		/*
+		 * In order to avoid spurious interrupts always reset
+		 * checkpointed counters.
+		 */
+		*status |= (1ULL << idx);
+	}
+}
+
 /*
  * This handler is triggered by the local APIC, so the APIC IRQ handling
  * rules apply:
@@ -1224,6 +1238,8 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 		x86_pmu.drain_pebs(regs);
 	}
 
+	intel_pmu_hsw_tsx_status(cpuc, &status);
+
 	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
 		struct perf_event *event = cpuc->events[bit];
 
