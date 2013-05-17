Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab3EQK7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 06:59:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60297 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab3EQK7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 06:59:20 -0400
Date: Fri, 17 May 2013 12:57:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <rric@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Josh Boyer <jwboyer@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, gleb@redhat.com
Subject: Re: Drop WARN on AMD lack of perfctrs
Message-ID: <20130517105730.GD5162@dyad.programming.kicks-ass.net>
References: <20130516175117.GK19669@dyad.programming.kicks-ass.net>
 <20130516175557.GC18325@hansolo.jdub.homelinux.org>
 <20130516181018.GO19669@dyad.programming.kicks-ass.net>
 <20130516205558.GE8356@rric.localhost>
 <20130516213420.GB31393@pd.tnic>
 <20130517090451.GQ19669@dyad.programming.kicks-ass.net>
 <20130517091651.GB23035@pd.tnic>
 <20130517092741.GR19669@dyad.programming.kicks-ass.net>
 <20130517094551.GE23035@pd.tnic>
 <20130517103600.GG8356@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130517103600.GG8356@rric.localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So what about something like the below?

---
 arch/x86/kernel/cpu/perf_event_amd.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 7e28d94..87e8a7e 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -648,24 +648,19 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.cpu_dead		= amd_pmu_cpu_dead,
 };
 
-static int setup_event_constraints(void)
+__init int amd_core_pmu_init(void)
 {
-	if (boot_cpu_data.x86 == 0x15)
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
@@ -675,8 +670,7 @@ static int setup_perfctr_core(void)
 	x86_pmu.perfctr		= MSR_F15H_PERF_CTR;
 	x86_pmu.num_counters	= AMD64_NUM_COUNTERS_CORE;
 
-	printk(KERN_INFO "perf: AMD core performance counters detected\n");
-
+	pr_cont("core perfctr, ");
 	return 0;
 }
 
@@ -688,8 +682,8 @@ __init int amd_pmu_init(void)
 
 	x86_pmu = amd_pmu;
 
-	setup_event_constraints();
-	setup_perfctr_core();
+	if (cpu_has_perfctr_core && amd_core_pmu_init())
+		return -ENODEV;
 
 	/* Events are common for all AMDs */
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,

