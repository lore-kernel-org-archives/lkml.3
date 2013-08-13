Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab3HMLXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:23:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51126 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448Ab3HMLXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:23:20 -0400
Date: Tue, 13 Aug 2013 13:23:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, acme@infradead.org,
        jolsa@redhat.com, eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/4] perf, x86: Report TSX transaction abort cost as
 weight
Message-ID: <20130813112301.GV27162@twins.programming.kicks-ass.net>
References: <1376010946-28666-1-git-send-email-andi@firstfloor.org>
 <1376010946-28666-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376010946-28666-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 06:15:44PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Use the existing weight reporting facility to report the transaction
> abort cost, that is the number of cycles wasted in aborts.
> Haswell reports this in the PEBS record.
> 
> This was in fact the original user for weight.
> 
> This is a very useful sort key to concentrate on the most
> costly aborts and a good metric for TSX tuning.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_ds.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index 3065c57..8959cc7 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -838,6 +838,12 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
>  		x86_pmu.intel_cap.pebs_format >= 1)
>  		data.addr = pebs->dla;
>  
> +	if ((event->attr.sample_type & PERF_SAMPLE_WEIGHT) &&
> +	    !fll &&
> +	    (x86_pmu.intel_cap.pebs_format >= 2) &&
> +	    pebs_hsw->tsx_tuning)
> +		data.weight = pebs_hsw->tsx_tuning & 0xffffffff;
> +
>  	if (has_branch_stack(event))
>  		data.br_stack = &cpuc->lbr_stack;


How about something like the below instead? I didn't copy the !fll test
because I couldn't find why that was. Section 18.10.5.1 (Aug 2012)
doesn't mention anything like that and I figure the reason bits would be
0 when the thing isn't appropriate.

---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 63 +++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 3065c57..52cb1fa 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -178,20 +178,15 @@ struct pebs_record_nhm {
 	u64 status, dla, dse, lat;
 };
 
-/*
- * Same as pebs_record_nhm, with two additional fields.
- */
 struct pebs_record_hsw {
-	struct pebs_record_nhm nhm;
-	/*
-	 * Real IP of the event. In the Intel documentation this
-	 * is called eventingrip.
-	 */
-	u64 real_ip;
-	/*
-	 * TSX tuning information field: abort cycles and abort flags.
-	 */
-	u64 tsx_tuning;
+	u64 flags, ip;
+	u64 ax, bx, cx, dx;
+	u64 si, di, bp, sp;
+	u64 r8,  r9,  r10, r11;
+	u64 r12, r13, r14, r15;
+	u64 status, dla, dse, lat;
+	u64 real_ip; /* the actual eventing ip */
+	u64 tsx_tuning; /* TSX abort cycles and flags */
 };
 
 void init_debug_store_on_cpu(int cpu)
@@ -759,16 +754,41 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 	return 0;
 }
 
+union hsw_tsx_tuning {
+	struct {
+		u64 cycles_last_block : 32,
+		    hle_abort         : 1,
+		    rtm_abort         : 1,
+		    ins_abort         : 1,
+		    non_ins_abort     : 1,
+		    retry             : 1,
+		    mem_data_conflict : 1,
+		    capacity          : 1;
+	} bits;
+	u64 value;
+};
+
+static inline u64 intel_hsw_weight(struct pebs_record_hsw *pebs)
+{
+	u64 weight = 0;
+
+	if (pebs->tsx_tuning) {
+		union hsw_tsx_tuning tsx = { .value = pebs->tsx_tuning };
+		weight = tsx.bits.cycles_last_block;
+	}
+
+	return weight;
+}
+
 static void __intel_pmu_pebs_event(struct perf_event *event,
 				   struct pt_regs *iregs, void *__pebs)
 {
 	/*
-	 * We cast to pebs_record_nhm to get the load latency data
-	 * if extra_reg MSR_PEBS_LD_LAT_THRESHOLD used
+	 * We cast to the biggest PEBS record and are careful not
+	 * to access out-of-bounds members.
 	 */
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct pebs_record_nhm *pebs = __pebs;
-	struct pebs_record_hsw *pebs_hsw = __pebs;
+	struct pebs_record_hsw *pebs = __pebs;
 	struct perf_sample_data data;
 	struct pt_regs regs;
 	u64 sample_type;
@@ -826,8 +846,9 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	regs.bp = pebs->bp;
 	regs.sp = pebs->sp;
 
+
 	if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format >= 2) {
-		regs.ip = pebs_hsw->real_ip;
+		regs.ip = pebs->real_ip;
 		regs.flags |= PERF_EFLAGS_EXACT;
 	} else if (event->attr.precise_ip > 1 && intel_pmu_pebs_fixup_ip(&regs))
 		regs.flags |= PERF_EFLAGS_EXACT;
@@ -835,9 +856,13 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 
 	if ((event->attr.sample_type & PERF_SAMPLE_ADDR) &&
-		x86_pmu.intel_cap.pebs_format >= 1)
+	    x86_pmu.intel_cap.pebs_format >= 1)
 		data.addr = pebs->dla;
 
+	if ((event->attr.sample_type & PERF_SAMPLE_WEIGHT) &&
+	    x86_pmu.intel_cap.pebs_format >= 2)
+		data.weight = intel_hsw_weight(pebs);
+
 	if (has_branch_stack(event))
 		data.br_stack = &cpuc->lbr_stack;
 
