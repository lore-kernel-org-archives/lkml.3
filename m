Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab3F0LO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 07:14:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54273 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab3F0LO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 07:14:57 -0400
Date: Thu, 27 Jun 2013 13:14:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 2/8] perf,x86: drop event->flags and use
 hw.constraint->flags
Message-ID: <20130627111445.GR28407@twins.programming.kicks-ass.net>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
 <1371824448-7306-3-git-send-email-eranian@google.com>
 <20130624084510.GK28407@twins.programming.kicks-ass.net>
 <CABPqkBQRchnjhnEC05w-noizoeSRnNio7NDQ6_+vXym_7rkGaw@mail.gmail.com>
 <20130626103653.GC28407@twins.programming.kicks-ass.net>
 <CABPqkBQuYy3TeE81tTXVruMG4D84TQ2U5g69T2ResGgjPjK4Cg@mail.gmail.com>
 <20130627104833.GC27378@dyad.programming.kicks-ass.net>
 <CABPqkBSwrz_GSobSuXn+AvU1zp14nAccCer4o7DHmG2c90cxRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPqkBSwrz_GSobSuXn+AvU1zp14nAccCer4o7DHmG2c90cxRA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 01:01:02PM +0200, Stephane Eranian wrote:
> Ok, the chunks that do not apply can be ignored for perf_event_intel.c.

Just to verify; I did a force apply ignoring the 2 hunks in perf_event_intel.c.
The result is the below patch; which gives:

# nice make O=defconfig-build/ -j16 -s
/usr/src/linux-2.6/arch/x86/kernel/cpu/perf_event.c: In function ‘x86_schedule_events’:
/usr/src/linux-2.6/arch/x86/kernel/cpu/perf_event.c:780:9: error: ‘struct hw_perf_event’ has no member named ‘flags’
/usr/src/linux-2.6/arch/x86/kernel/cpu/perf_event.c:794:14: error: ‘struct hw_perf_event’ has no member named ‘flags’
/usr/src/linux-2.6/arch/x86/kernel/cpu/perf_event.c: In function ‘x86_pmu_del’:
/usr/src/linux-2.6/arch/x86/kernel/cpu/perf_event.c:1180:11: error: ‘struct hw_perf_event’ has no member named ‘flags’
make[4]: *** [arch/x86/kernel/cpu/perf_event.o] Error 1


Please resend one that builds.

---
Subject: perf,x86: Drop event->flags and use hw.constraint->flags
From: Stephane Eranian <eranian@google.com>
Date: Fri, 21 Jun 2013 16:20:42 +0200

Now that we use the constraints directly from the event, we
do not need the event->flags field so drop it.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1371824448-7306-3-git-send-email-eranian@google.com
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   19 ++++++++++---------
 include/linux/perf_event.h                |    1 -
 2 files changed, 10 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -623,7 +623,6 @@ struct event_constraint *intel_pebs_cons
 	if (x86_pmu.pebs_constraints) {
 		for_each_event_constraint(c, x86_pmu.pebs_constraints) {
 			if ((event->hw.config & c->cmask) == c->code) {
-				event->hw.flags |= c->flags;
 				return c;
 			}
 		}
@@ -636,14 +635,15 @@ void intel_pmu_pebs_enable(struct perf_e
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
+	int flags = event->hw.constraint->flags;
 
 	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
 
 	cpuc->pebs_enabled |= 1ULL << hwc->idx;
 
-	if (event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT)
+	if (flags & PERF_X86_EVENT_PEBS_LDLAT)
 		cpuc->pebs_enabled |= 1ULL << (hwc->idx + 32);
-	else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST)
+	else if (flags & PERF_X86_EVENT_PEBS_ST)
 		cpuc->pebs_enabled |= 1ULL << 63;
 }
 
@@ -651,12 +651,13 @@ void intel_pmu_pebs_disable(struct perf_
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
+	int flags = event->hw.constraint->flags;
 
 	cpuc->pebs_enabled &= ~(1ULL << hwc->idx);
 
-	if (event->hw.constraint->flags & PERF_X86_EVENT_PEBS_LDLAT)
+	if (flags & PERF_X86_EVENT_PEBS_LDLAT)
 		cpuc->pebs_enabled &= ~(1ULL << (hwc->idx + 32));
-	else if (event->hw.constraint->flags & PERF_X86_EVENT_PEBS_ST)
+	else if (flags & PERF_X86_EVENT_PEBS_ST)
 		cpuc->pebs_enabled &= ~(1ULL << 63);
 
 	if (cpuc->enabled)
@@ -772,14 +773,14 @@ static void __intel_pmu_pebs_event(struc
 	struct perf_sample_data data;
 	struct pt_regs regs;
 	u64 sample_type;
+	int flags = event->hw.constraint->flags;
 	int fll, fst;
 
 	if (!intel_pmu_save_and_restart(event))
 		return;
 
-	fll = event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT;
-	fst = event->hw.flags & (PERF_X86_EVENT_PEBS_ST |
-				 PERF_X86_EVENT_PEBS_ST_HSW);
+	fll = flags & PERF_X86_EVENT_PEBS_LDLAT;
+	fst = flags & (PERF_X86_EVENT_PEBS_ST | PERF_X86_EVENT_PEBS_ST_HSW);
 
 	perf_sample_data_init(&data, 0, event->hw.last_period);
 
@@ -802,7 +803,7 @@ static void __intel_pmu_pebs_event(struc
 		if (sample_type & PERF_SAMPLE_DATA_SRC) {
 			if (fll)
 				data.data_src.val = load_latency_data(pebs->dse);
-			else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST_HSW)
+			else if (flags & PERF_X86_EVENT_PEBS_ST_HSW)
 				data.data_src.val =
 					precise_store_data_hsw(pebs->dse);
 			else
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -134,7 +134,6 @@ struct hw_perf_event {
 			int		event_base_rdpmc;
 			int		idx;
 			int		last_cpu;
-			int		flags;
 
 			struct hw_perf_event_extra extra_reg;
 			struct hw_perf_event_extra branch_reg;

