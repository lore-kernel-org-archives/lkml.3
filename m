Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaAQFoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 00:44:01 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:51081 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaAQFn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 00:43:59 -0500
Date: Fri, 17 Jan 2014 00:45:04 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Will Deacon <will.deacon@arm.com>,
        Chad Paradis <chad.paradis@umit.maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [patch/rfc] perf on raspberry-pi without overflow interrupt
In-Reply-To: <20140116173110.GA9655@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1401170041350.4747@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1401081613370.4410@vincent-weaver-1.um.maine.edu> <20140108225315.GG31570@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1401082245120.22965@vincent-weaver-1.um.maine.edu> <20140109101921.GA26435@mudshark.cambridge.arm.com>
 <alpine.DEB.2.10.1401092304590.31813@vincent-weaver-1.um.maine.edu> <20140110094056.GK31570@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1401132344570.20155@vincent-weaver-1.um.maine.edu> <20140114105721.GU7572@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1401161209280.1996@vincent-weaver-1.um.maine.edu> <20140116173110.GA9655@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014, Peter Zijlstra wrote:

> Yeah I suppose we could do something like that. Maybe something like:
> 
> # cat /sys/bus/event_source/devices/cpu/flags
> int precise filter

wouldn't that violate the "one value per file" rule?

I guess we could also stick it in the mmap page somewhere, as tools like 
PAPI already have to check there for things like rdpmc support.


Anyway, here's a first pass at a generic fix for this issue.  I'm sure the 
code is pretty horrible, I don't usually mess with the perf code at this 
level.  I haven't tested yet as it touched enough files that the rasp-pi 
is going to take a few hours to finish compiling.

Am I on the right track, or totally off here?

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index bc3f2ef..6782379 100644
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
diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index 20d553c..afb3fc8 100644
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
@@ -150,6 +150,10 @@ static void cpu_pmu_init(struct arm_pmu *cpu_pmu)
 	/* Ensure the PMU has sane values out of reset. */
 	if (cpu_pmu->reset)
 		on_each_cpu(cpu_pmu->reset, cpu_pmu, 1);
+
+	if (platform_get_irq(cpu_pmu->plat_device, 0) <= 0)
+		cpu_pmu->pmu.capabilities |= PERF_PMU_NO_INTERRUPT;
+
 }
 
 /*
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2e069d1..f5e7f0c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -251,9 +251,19 @@ struct pmu {
 	 * flush branch stack on context-switches (needed in cpu-wide mode)
 	 */
 	void (*flush_branch_stack)	(void);
+
+	/*
+	 * various common per-pmu feature flags
+	 */
+	int capabilities;
 };
 
 /**
+ * struct pmu->capabilites flags
+ */
+#define PERF_PMU_NO_INTERRUPT		1
+
+/**
  * enum perf_event_active_state - the states of a event
  */
 enum perf_event_active_state {
diff --git a/kernel/events/core.c b/kernel/events/core.c
index f574401..f65c6c6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7056,6 +7056,14 @@ SYSCALL_DEFINE5(perf_event_open,
 	 */
 	pmu = event->pmu;
 
+	if (is_sampling_event(event)) {
+		if (pmu->capabilities & PERF_PMU_NO_INTERRUPT)
+			err = -ENOTSUPP;
+			goto err_alloc;
+	}
+
+
+
 	if (group_leader &&
 	    (is_software_event(event) != is_software_event(group_leader))) {
 		if (is_software_event(event)) {
