Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3EUNdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:33:49 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50993
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754305Ab3EUNds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:33:48 -0400
Date: Tue, 21 May 2013 13:05:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <rric@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Josh Boyer <jwboyer@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, gleb@redhat.com,
        Jacob Shin <jacob.shin@amd.com>
Subject: Re: Drop WARN on AMD lack of perfctrs
Message-ID: <20130521110537.GG26912@twins.programming.kicks-ass.net>
References: <20130516181018.GO19669@dyad.programming.kicks-ass.net>
 <20130516205558.GE8356@rric.localhost>
 <20130516213420.GB31393@pd.tnic>
 <20130517090451.GQ19669@dyad.programming.kicks-ass.net>
 <20130517091651.GB23035@pd.tnic>
 <20130517092741.GR19669@dyad.programming.kicks-ass.net>
 <20130517094551.GE23035@pd.tnic>
 <20130517103600.GG8356@rric.localhost>
 <20130517105730.GD5162@dyad.programming.kicks-ass.net>
 <20130521085630.GA1860@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521085630.GA1860@rric.localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 10:56:30AM +0200, Robert Richter wrote:
> On 17.05.13 12:57:30, Peter Zijlstra wrote:
> > 
> > So what about something like the below?
> 
> See my comments below, otherwise it looks fine to me.

I've been liberal and read an Ack there, holler if that needs be amended.

> There is the question about core performance counters and its
> constraints on fam16h. Not sure if there are any. Cc'ing Jacob.

Currently the code doesn't work for Fam16h afaict, so I didn't wreck
that did I?

> >  	/*
> >  	 * If core performance counter extensions exists, we must use
> >  	 * MSR_F15H_PERF_CTL/MSR_F15H_PERF_CTR msrs. See also
> 
> ... amd_pmu_addr_offset():
> 
>          * If core performance counter extensions exists, we must use
>          * MSR_F15H_PERF_CTL/MSR_F15H_PERF_CTR msrs. See also
>          * amd_pmu_addr_offset().
> 

Done.

> > @@ -675,8 +670,7 @@ static int setup_perfctr_core(void)
> >  	x86_pmu.perfctr		= MSR_F15H_PERF_CTR;
> >  	x86_pmu.num_counters	= AMD64_NUM_COUNTERS_CORE;
> >  
> > -	printk(KERN_INFO "perf: AMD core performance counters detected\n");
> > -
> > +	pr_cont("core perfctr, ");
> >  	return 0;
> >  }
> >  
> > @@ -688,8 +682,8 @@ __init int amd_pmu_init(void)
> >  
> >  	x86_pmu = amd_pmu;
> >  
> > -	setup_event_constraints();
> > -	setup_perfctr_core();
> > +	if (cpu_has_perfctr_core && amd_core_pmu_init())
> > +		return -ENODEV;
> 
> Better return result of amd_core_pmu_init().

Done.. that was admittedly a tad lazy of me :-)

---
Subject: perf, x86: Rework AMD PMU init code
From: Peter Zijlstra <peterz@infradead.org>
Date: Fri, 17 May 2013 12:57:30 +0200

Josh reported that his QEMU is a bad hardware emulator and trips a
WARN in the AMD PMU init code. He requested the WARN be turned into a
pr_err() or similar.

While there, rework the code a little.

Reported-by: Josh Boyer <jwboyer@redhat.com>
Acked-by: Robert Richter <rric@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/kernel/cpu/perf_event_amd.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -648,48 +648,48 @@ static __initconst const struct x86_pmu
 	.cpu_dead		= amd_pmu_cpu_dead,
 };
 
-static int setup_event_constraints(void)
+__init int amd_core_pmu_init(void)
 {
-	if (boot_cpu_data.x86 == 0x15)
+	if (!cpu_has_perfctr_core)
+		return 0;
+
+	switch (boot_cpu_data.x86) {
+	case 0x15:
+		pr_cont("Fam15h ");
 		x86_pmu.get_event_constraints = amd_get_event_constraints_f15h;
-	return 0;
-}
+		break;
 
-static int setup_perfctr_core(void)
-{
-	if (!cpu_has_perfctr_core) {
-		WARN(x86_pmu.get_event_constraints == amd_get_event_constraints_f15h,
-		     KERN_ERR "Odd, counter constraints enabled but no core perfctrs detected!");
+	default:
+		pr_err("core perfctr but no constraints; unknown hardware!\n");
 		return -ENODEV;
 	}
 
-	WARN(x86_pmu.get_event_constraints == amd_get_event_constraints,
-	     KERN_ERR "hw perf events core counters need constraints handler!");
-
 	/*
 	 * If core performance counter extensions exists, we must use
 	 * MSR_F15H_PERF_CTL/MSR_F15H_PERF_CTR msrs. See also
-	 * x86_pmu_addr_offset().
+	 * amd_pmu_addr_offset().
 	 */
 	x86_pmu.eventsel	= MSR_F15H_PERF_CTL;
 	x86_pmu.perfctr		= MSR_F15H_PERF_CTR;
 	x86_pmu.num_counters	= AMD64_NUM_COUNTERS_CORE;
 
-	printk(KERN_INFO "perf: AMD core performance counters detected\n");
-
+	pr_cont("core perfctr, ");
 	return 0;
 }
 
 __init int amd_pmu_init(void)
 {
+	int ret;
+
 	/* Performance-monitoring supported from K7 and later: */
 	if (boot_cpu_data.x86 < 6)
 		return -ENODEV;
 
 	x86_pmu = amd_pmu;
 
-	setup_event_constraints();
-	setup_perfctr_core();
+	ret = amd_core_pmu_init();
+	if (ret)
+		return ret;
 
 	/* Events are common for all AMDs */
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,

