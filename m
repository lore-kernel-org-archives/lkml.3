Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaANElO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 23:41:14 -0500
Received: from mail-qe0-f46.google.com ([209.85.128.46]:63770 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbaANElM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 23:41:12 -0500
Date: Mon, 13 Jan 2014 23:42:13 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Will Deacon <will.deacon@arm.com>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Chad Paradis <chad.paradis@umit.maine.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [patch/rfc] perf on raspberry-pi without overflow interrupt
In-Reply-To: <20140110100804.GB11045@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.10.1401132331290.20155@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1401081613370.4410@vincent-weaver-1.um.maine.edu> <20140108225315.GG31570@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1401082245120.22965@vincent-weaver-1.um.maine.edu> <20140109101921.GA26435@mudshark.cambridge.arm.com>
 <alpine.DEB.2.10.1401092304590.31813@vincent-weaver-1.um.maine.edu> <20140110100804.GB11045@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jan 2014, Will Deacon wrote:

> In the absence of a core change, I think I'd rather have something like your
> second patch, but without the extra no_overflow_irq field (you can check the
> platform device, as I mentioned previously).

Something like the following?  It works on my rasp-pi, still waiting for
the compile to finish on the pandaboard so I haven't verified that the
has-working-interrupt case still works.

---

Allow hardware perf_events to be enabled even if no overflow
interrupt is available.  Return EOPNOTSUPP if a sampling event
is attempted and the interrupt is not available.

This is necessary for access to hardware perf_events on
the Raspberry-Pi (bcm2835).

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index bc3f2ef..e2c4aa2 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -397,7 +397,7 @@ __hw_perf_event_init(struct perf_event *event)
 	 */
 	hwc->config_base	    |= (unsigned long)mapping;
 
-	if (!hwc->sample_period) {
+	if (!is_sampling_event(event)) {
 		/*
 		 * For non-sampling runs, limit the sample_period to half
 		 * of the counter width. That way, the new counter value
@@ -407,6 +407,14 @@ __hw_perf_event_init(struct perf_event *event)
 		hwc->sample_period  = armpmu->max_period >> 1;
 		hwc->last_period    = hwc->sample_period;
 		local64_set(&hwc->period_left, hwc->sample_period);
+	} else {
+
+		/*
+		 * If we have no PMU interrupt we cannot sample.
+		 */
+		if (platform_get_irq(armpmu->plat_device, 0) < 0)
+			return -EOPNOTSUPP;
+
 	}
 
 	if (event->group_leader != event) {
diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index d85055c..7a84738 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -97,8 +97,8 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
 
 	irqs = min(pmu_device->num_resources, num_possible_cpus());
 	if (irqs < 1) {
-		pr_err("no irqs for PMUs defined\n");
-		return -ENODEV;
+		printk_once("no irqs for PMUs defined, sampled events not supported\n");
+		return 0;
 	}
 
 	for (i = 0; i < irqs; ++i) {
