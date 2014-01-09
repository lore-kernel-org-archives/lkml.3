Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbaAIDqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 22:46:23 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:64073 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaAIDqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 22:46:21 -0500
Date: Wed, 8 Jan 2014 22:47:19 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [patch/rfc] perf on raspberry-pi without overflow interrupt
In-Reply-To: <20140108225315.GG31570@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1401082245120.22965@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1401081613370.4410@vincent-weaver-1.um.maine.edu> <20140108225315.GG31570@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jan 2014, Peter Zijlstra wrote:

> On Wed, Jan 08, 2014 at 04:28:20PM -0500, Vince Weaver wrote:
> > Should the perf_event interface handle setups like this better and work 
> > fine in aggregate mode but return ENOTSUP if a sampled or overflow event 
> > is attempted?
> 
> Yeah that would be better, we do something similar for P6 class machines
> without lapic IIRC.

You're right.  Something like the following works for me on the rasp-pi,
although maybe if x86 is doing it too things should be moved up into 
generic code?

---

Return EOPNOTSUPP if we have no PMU overflow interrupt but a
sampled event is requested.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/arch/arm/include/asm/pmu.h b/arch/arm/include/asm/pmu.h
index f24edad..f1f27a3 100644
--- a/arch/arm/include/asm/pmu.h
+++ b/arch/arm/include/asm/pmu.h
@@ -87,6 +87,7 @@ struct arm_pmu {
 	u64		max_period;
 	struct platform_device	*plat_device;
 	struct pmu_hw_events	*(*get_hw_events)(void);
+	int		no_overflow_interrupt;
 };
 
 #define to_arm_pmu(p) (container_of(p, struct arm_pmu, pmu))
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index bc3f2ef..fa4ecc3 100644
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
@@ -407,6 +407,12 @@ __hw_perf_event_init(struct perf_event *event)
 		hwc->sample_period  = armpmu->max_period >> 1;
 		hwc->last_period    = hwc->sample_period;
 		local64_set(&hwc->period_left, hwc->sample_period);
+	} else {
+		/*
+		 * If we have no PMU interrupt we cannot sample
+		 */
+		if (armpmu->no_overflow_interrupt)
+			return -EOPNOTSUPP;
 	}
 
 	if (event->group_leader != event) {
diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index d85055c..a74e0cd 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -97,8 +97,9 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
 
 	irqs = min(pmu_device->num_resources, num_possible_cpus());
 	if (irqs < 1) {
-		pr_err("no irqs for PMUs defined\n");
-		return -ENODEV;
+		printk_once("no irqs for PMUs defined, emulating with hrtimer\n");
+		cpu_pmu->no_overflow_interrupt=1;
+		return 0;
 	}
 
 	for (i = 0; i < irqs; ++i) {
