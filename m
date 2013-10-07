Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3JGJdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 05:33:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58455 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab3JGJdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 05:33:32 -0400
Date: Mon, 7 Oct 2013 11:33:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86: Clean up cap_user_time* setting
Message-ID: <20131007093322.GA3081@twins.programming.kicks-ass.net>
References: <tip-nmgn0j0muo1r4c94vlfh23xy@git.kernel.org>
 <524F097A.9010506@intel.com>
 <20131004185539.GT15690@laptop.programming.kicks-ass.net>
 <20131006091054.GA4342@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131006091054.GA4342@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 11:10:54AM +0200, Ingo Molnar wrote:
> I'm fully with you, please zap the 'notsc' boot option - it's an ancient 
> relic, if any box is still broken with the TSC on we want to hear about it 
> and fix it!

something like so?

---
Subject: x86: Remove 'notsc' option for X86_TSC=y kernels

The 'notsc' thing is an ancient relic, if there's still any hardware
that needs this we need to hear about it.

This only removes the option for X86_TSC=y kernels; X86_TSC=n kernels
can still use it to force remove the TSC capability flag.

Since this removes the tsc_disabled=1 assignment, also remove all
tsc_disabled>0 tests as those will never be true.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/kernel/tsc.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 930e5d48f560..693c0226b014 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -89,20 +89,7 @@ int check_tsc_unstable(void)
 }
 EXPORT_SYMBOL_GPL(check_tsc_unstable);
 
-int check_tsc_disabled(void)
-{
-	return tsc_disabled;
-}
-EXPORT_SYMBOL_GPL(check_tsc_disabled);
-
-#ifdef CONFIG_X86_TSC
-int __init notsc_setup(char *str)
-{
-	pr_warn("Kernel compiled with CONFIG_X86_TSC, cannot disable TSC completely\n");
-	tsc_disabled = 1;
-	return 1;
-}
-#else
+#ifndef CONFIG_X86_TSC
 /*
  * disable flag for tsc. Takes effect by clearing the TSC cpu flag
  * in cpu/common.c
@@ -112,9 +99,9 @@ int __init notsc_setup(char *str)
 	setup_clear_cpu_cap(X86_FEATURE_TSC);
 	return 1;
 }
-#endif
 
 __setup("notsc", notsc_setup);
+#endif
 
 static int no_sched_irq_time;
 
@@ -935,7 +922,7 @@ static void tsc_refine_calibration_work(struct work_struct *work)
 
 static int __init init_tsc_clocksource(void)
 {
-	if (!cpu_has_tsc || tsc_disabled > 0 || !tsc_khz)
+	if (!cpu_has_tsc || !tsc_khz)
 		return 0;
 
 	if (tsc_clocksource_reliable)
@@ -998,9 +985,6 @@ void __init tsc_init(void)
 	for_each_possible_cpu(cpu)
 		set_cyc2ns_scale(cpu_khz, cpu);
 
-	if (tsc_disabled > 0)
-		return;
-
 	/* now allow native_sched_clock() to use rdtsc */
 	tsc_disabled = 0;
 
