Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab3IPLWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 07:22:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48027 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab3IPLV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 07:21:57 -0400
Date: Mon, 16 Sep 2013 13:21:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, acme@infradead.org, linux-kernel@vger.kernel.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/6] perf, x86: Add Haswell specific transaction flag
 reporting v4
Message-ID: <20130916112144.GA9326@twins.programming.kicks-ass.net>
References: <1379095716-4705-1-git-send-email-andi@firstfloor.org>
 <1379095716-4705-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379095716-4705-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 11:08:32AM -0700, Andi Kleen wrote:
> @@ -893,6 +895,16 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
>  	    (x86_pmu.intel_cap.pebs_format >= 2))
>  		data.weight = intel_hsw_weight(pebs);
>  
> +	if ((event->attr.sample_type & PERF_SAMPLE_TRANSACTION) &&
> +	    x86_pmu.intel_cap.pebs_format >= 2) {
> +		data.transaction =
> +			(pebs->tsx_tuning & PEBS_HSW_TSX_FLAGS) >> 32;
> +		/* For RTM XABORTs also log the abort code from AX */
> +		if ((data.transaction & PERF_SAMPLE_TXN_TRANSACTION) &&
> +		    (pebs->ax & 1))
> +			data.transaction |= pebs->ax & 0xff000000;
> +	}
> +
>  	if (has_branch_stack(event))
>  		data.br_stack = &cpuc->lbr_stack;
>  

Also, since we know now have 2 format >= 2 branches we can combine them;
something like so?

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index f364c13..862e59f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -206,6 +206,8 @@ union hsw_tsx_tuning {
 	u64	    value;
 };
 
+#define PEBS_HSW_TSX_FLAGS	0xff00000000
+
 void init_debug_store_on_cpu(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
@@ -880,18 +882,30 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	else
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 
-	if ((event->attr.sample_type & PERF_SAMPLE_ADDR) &&
-	    x86_pmu.intel_cap.pebs_format >= 1)
+	if (has_branch_stack(event))
+		data.br_stack = &cpuc->lbr_stack;
+
+	if (x86_pmu.intel_cap.pebs_format < 1)
+		goto done;
+
+	if (event->attr.sample_type & PERF_SAMPLE_ADDR)
 		data.addr = pebs->dla;
 
+	if (x86_pmu.intel_cap.pebs_format < 2)
+		goto done;
+
 	/* Only set the TSX weight when no memory weight was requested. */
-	if ((event->attr.sample_type & PERF_SAMPLE_WEIGHT) && !fll &&
-	    (x86_pmu.intel_cap.pebs_format >= 2))
+	if ((event->attr.sample_type & PERF_SAMPLE_WEIGHT) && !fll)
 		data.weight = intel_hsw_weight(pebs);
 
-	if (has_branch_stack(event))
-		data.br_stack = &cpuc->lbr_stack;
+	if ((event->attr.sample_type & PERF_SAMPLE_TRANSACTION)) {
+		data.txn = (pebs->tsx_tuning & PEBS_HSW_TSX_FLAGS) >> 32;
+		/* For RTM XABORTs also log the abort code from AX */
+		if ((data.txn & PERF_SAMPLE_TXN_TRANSACTION) && (pebs->ax & 1))
+			data.txn |= pebs->ax & 0xff000000;
+	}
 
+done:
 	if (perf_event_overflow(event, &data, &regs))
 		x86_pmu_stop(event, 0);
 }
