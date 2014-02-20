Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaBTKIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:08:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55559 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaBTKIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:08:42 -0500
Date: Thu, 20 Feb 2014 11:08:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: x86_pmu_start WARN_ON.
Message-ID: <20140220100830.GN6835@laptop.programming.kicks-ass.net>
References: <20140211132956.GY9987@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402121559350.20738@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu>
 <20140217152859.GF15586@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu>
 <20140219101949.GG15586@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402191727420.23543@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1402191727420.23543@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 05:34:49PM -0500, Vince Weaver wrote:
> So where would the NMI counter event get disabled?  Would it never get 
> disabled, just because it's always running and always gets the same fixed 
> slot?  Why isn't this a problem all the time, not just with corner cases?

Well it could get another counter assignment I suppose; there's no
guarantee it always ends up in the fixed counter although that's rather
likely.

> Is somehow n_added getting confused?

I'd expect worse than a warning if that happened, but who knows.

You could try with the below; make sure you've got CONFIG_FUNCTION_TRACER=y.

Then (assuming debugfs is mounted in /debug ; most modern distros have
it at /sys/kernel/debug but they're wrong!):

# echo 0 > /debug/tracing/tracing_on
# echo function > /debug/tracing/current_tracer
# echo nop > /debug/tracing/current_tracer
# echo 0 > /debug/tracing/trace
# echo 1 > /debug/tracing/tracing_on

And make it go *BOOM*, then:

# cat /debug/tracing/trace | bzip2 -9 > ~/trace.bz2

And send that (and look at it of course).

@rostedt: WTF is disable_trace_on_warning a boot option only?

---
 arch/x86/kernel/cpu/perf_event.c | 65 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 64 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 895604f2e916..d3edf301deb8 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -509,6 +509,42 @@ void x86_pmu_disable_all(void)
 	}
 }
 
+static void x86_pmu_state(struct pmu *pmu)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int i;
+
+	trace_printk("Events: {\n");
+	for (i = 0; i < X86_PMC_IDX_MAX; i++) {
+		struct perf_event *event = cpuc->events[i];
+		int active = test_bit(i, cpuc->active_mask);
+		int running = test_bit(i, cpuc->running);
+
+		if (active || running) {
+			trace_printk("  %d: state: %c%c config: %lx (%p)\n",
+					i, active ? 'A' : '.',
+					running ? 'R' : '.',
+					event ? event->attr.config : -1L,
+					event);
+		}
+	}
+	trace_printk("}\n");
+
+
+	trace_printk("n_events: %d, n_added: %d, n_txn: %d\n",
+			cpuc->n_events, cpuc->n_added, cpuc->n_txn);
+	trace_printk("Assignment: {\n");
+	for (i = 0; i < cpuc->n_events; i++) {
+		struct perf_event *event = cpuc->event_list[i];
+
+		trace_printk("  %d->%d tag: %lx config: %lx (%p)\n",
+				i, cpuc->assign[i], cpuc->tags[i],
+				event ? event->attr.config : -1L,
+				event);
+	}
+	trace_printk("}\n");
+}
+
 static void x86_pmu_disable(struct pmu *pmu)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -524,6 +560,9 @@ static void x86_pmu_disable(struct pmu *pmu)
 	barrier();
 
 	x86_pmu.disable_all();
+
+	trace_printk("x86_pmu_disable\n");
+	x86_pmu_state(pmu);
 }
 
 void x86_pmu_enable_all(int added)
@@ -820,6 +859,7 @@ static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader,
 			return -EINVAL;
 		cpuc->event_list[n] = leader;
 		n++;
+		trace_printk("Adding event: %lx (%p)\n", leader->attr.config, leader);
 	}
 	if (!dogrp)
 		return n;
@@ -834,6 +874,7 @@ static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader,
 
 		cpuc->event_list[n] = event;
 		n++;
+		trace_printk("Adding event: %lx (%p)\n", event->attr.config, event);
 	}
 	return n;
 }
@@ -885,6 +926,9 @@ static void x86_pmu_enable(struct pmu *pmu)
 	if (cpuc->enabled)
 		return;
 
+	trace_printk("x86_pmu_enable\n");
+	x86_pmu_state(pmu);
+
 	if (cpuc->n_added) {
 		int n_running = cpuc->n_events - cpuc->n_added;
 		/*
@@ -898,6 +942,11 @@ static void x86_pmu_enable(struct pmu *pmu)
 			event = cpuc->event_list[i];
 			hwc = &event->hw;
 
+			trace_printk("K%d: hwc->idx: %d, hwc->last_cpu: %d,"
+				     " hwc->last_tag: %lx hwc->state: %x\n",
+				     i, hwc->idx, hwc->last_cpu,
+				     hwc->last_tag, hwc->state);
+
 			/*
 			 * we can avoid reprogramming counter if:
 			 * - assigned same counter as last time
@@ -915,6 +964,8 @@ static void x86_pmu_enable(struct pmu *pmu)
 			if (hwc->state & PERF_HES_STOPPED)
 				hwc->state |= PERF_HES_ARCH;
 
+			trace_printk("stopping: %d\n", i);
+
 			x86_pmu_stop(event, PERF_EF_UPDATE);
 		}
 
@@ -922,6 +973,11 @@ static void x86_pmu_enable(struct pmu *pmu)
 			event = cpuc->event_list[i];
 			hwc = &event->hw;
 
+			trace_printk("S%d: hwc->idx: %d, hwc->last_cpu: %d,"
+				     " hwc->last_tag: %lx hwc->state: %x\n",
+				     i, hwc->idx, hwc->last_cpu,
+				     hwc->last_tag, hwc->state);
+
 			if (!match_prev_assignment(hwc, cpuc, i))
 				x86_assign_hw_event(event, cpuc, i);
 			else if (i < n_running)
@@ -930,12 +986,17 @@ static void x86_pmu_enable(struct pmu *pmu)
 			if (hwc->state & PERF_HES_ARCH)
 				continue;
 
+			trace_printk("starting: %d\n", i);
+
 			x86_pmu_start(event, PERF_EF_RELOAD);
 		}
 		cpuc->n_added = 0;
 		perf_events_lapic_init();
 	}
 
+	x86_pmu_state(pmu);
+	trace_printk("x86_pmu_enabled\n");
+
 	cpuc->enabled = 1;
 	barrier();
 
@@ -1073,8 +1134,10 @@ static void x86_pmu_start(struct perf_event *event, int flags)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx = event->hw.idx;
 
-	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
+	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED))) {
+		tracing_off();
 		return;
+	}
 
 	if (WARN_ON_ONCE(idx == -1))
 		return;
