Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbaBFUiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 15:38:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58308 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaBFUiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 15:38:11 -0500
Date: Thu, 6 Feb 2014 21:38:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Davies <junk@eslaf.co.uk>
Cc: Vince Weaver <vince@deater.net>, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf,x86,p6: Add userspace RDPMC quirk for P6
Message-ID: <20140206203803.GL5002@laptop.programming.kicks-ass.net>
References: <20140205102718.GF3229@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1402051415190.16225@pianoman.cluster.toy>
 <20140205192012.GL2936@laptop.programming.kicks-ass.net>
 <20140205194851.GE5126@laptop.programming.kicks-ass.net>
 <871tzgxc3y.fsf@gw.eslaf.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871tzgxc3y.fsf@gw.eslaf.co.uk>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 07:41:37PM +0000, Mark Davies wrote:
> Peter
> 
> As I reported the problem I thought I better contribute by testing the
> fix.
> 
> I took the patch below and managed to change the 3.4.78 code to match
> and tried to boot my Pentium Pro system but it hung as before. After
> some investigation I discovered the quirk is not being run, in fact no
> quirks were being run in init_hw_perf_events as x86_pmu.quirks was NULL.
> 
> The problem as far as I can see is that the quirk is added to x86_pmu in
> p6_pmu_init but then x86_pmu is reassigned at the end of that function
> (x86_pmu = p6_pmu) resetting x86_pmu.quirks to NULL.

Right so far.

> x86_pmu looks like
> it is reassigned again in intel_pmu_init to either core_pmu or intel_pmu
> after the call to p6_pmu_init so I am not sure which x86_pmu.quirks
> init_hw_perf_events tries to use.

Note how intel_pmu_init() does: return p6_pmu_init(), so it will never
get to the x86_pmu assignment for the ARCH_PERFMON drivers.

Yep, thanks for testing and you're (mostly) quite right.

We can do the copy early though, if we return -ENODEV nothing will end
up using the x86_pmu anyway, so it doesn't matter what lives in there.

---
Subject: perf,x86,p6: Add userspace RDPMC quirk for PPro
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 5 Feb 2014 20:48:51 +0100

PPro machines can die hard when PCE gets enabled due to a CPU erratum.
The safe way it so disable it by default and keep it disabled.

See erratum 26 in:

http://download.intel.com/design/archives/processors/pro/docs/24268935.pdf

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Vince Weaver <vince@deater.net>
Reported-by: Mark Davies <junk@eslaf.co.uk>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/kernel/cpu/perf_event.c    |    6 +++-
 arch/x86/kernel/cpu/perf_event.h    |    1 
 arch/x86/kernel/cpu/perf_event_p6.c |   48 ++++++++++++++++++++++++------------
 3 files changed, 39 insertions(+), 16 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1521,6 +1521,8 @@ static int __init init_hw_perf_events(vo
 
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
+	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
+
 	for (quirk = x86_pmu.quirks; quirk; quirk = quirk->next)
 		quirk->func();
 
@@ -1534,7 +1536,6 @@ static int __init init_hw_perf_events(vo
 		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_counters) - 1,
 				   0, x86_pmu.num_counters, 0, 0);
 
-	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
 	x86_pmu_format_group.attrs = x86_pmu.format_attrs;
 
 	if (x86_pmu.event_attrs)
@@ -1820,6 +1821,9 @@ static ssize_t set_attr_rdpmc(struct dev
 	if (ret)
 		return ret;
 
+	if (x86_pmu.attr_rdpmc_broken)
+		return -ENOTSUPP;
+
 	if (!!val != !!x86_pmu.attr_rdpmc) {
 		x86_pmu.attr_rdpmc = !!val;
 		smp_call_function(change_rdpmc, (void *)val, 1);
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -409,6 +409,7 @@ struct x86_pmu {
 	/*
 	 * sysfs attrs
 	 */
+	int		attr_rdpmc_broken;
 	int		attr_rdpmc;
 	struct attribute **format_attrs;
 	struct attribute **event_attrs;
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -231,31 +231,49 @@ static __initconst const struct x86_pmu
 
 };
 
+static __init void p6_pmu_rdpmc_quirk(void)
+{
+	if (boot_cpu_data.x86_mask < 9) {
+		/*
+		 * PPro erratum 26; fixed in stepping 9 and above.
+		 */
+		pr_warn("Userspace RDPMC support disabled due to a CPU erratum\n");
+		x86_pmu.attr_rdpmc_broken = 1;
+		x86_pmu.attr_rdpmc = 0;
+	}
+}
+
 __init int p6_pmu_init(void)
 {
+	x86_pmu = p6_pmu;
+
 	switch (boot_cpu_data.x86_model) {
-	case 1:
-	case 3:  /* Pentium Pro */
-	case 5:
-	case 6:  /* Pentium II */
-	case 7:
-	case 8:
-	case 11: /* Pentium III */
-	case 9:
-	case 13:
-		/* Pentium M */
+	case  1: /* Pentium Pro */
+		x86_add_quirk(p6_pmu_rdpmc_quirk);
+		break;
+
+	case  3: /* Pentium II - Klamath */
+	case  5: /* Pentium II - Deschutes */
+	case  6: /* Pentium II - Mendocino */
 		break;
+
+	case  7: /* Pentium III - Katmai */
+	case  8: /* Pentium III - Coppermine */
+	case 10: /* Pentium III Xeon */
+	case 11: /* Pentium III - Tualatin */
+		break;
+
+	case  9: /* Pentium M - Banias */
+	case 13: /* Pentium M - Dothan */
+		break;
+
 	default:
-		pr_cont("unsupported p6 CPU model %d ",
-			boot_cpu_data.x86_model);
+		pr_cont("unsupported p6 CPU model %d ", boot_cpu_data.x86_model);
 		return -ENODEV;
 	}
 
-	x86_pmu = p6_pmu;
-
 	memcpy(hw_cache_event_ids, p6_hw_cache_event_ids,
 		sizeof(hw_cache_event_ids));
 
-
 	return 0;
 }


