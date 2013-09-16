Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab3IPLIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 07:08:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47776 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab3IPLIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 07:08:18 -0400
Date: Mon, 16 Sep 2013 13:08:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, acme@infradead.org, linux-kernel@vger.kernel.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/6] perf, x86: Add Haswell specific transaction flag
 reporting v4
Message-ID: <20130916110805.GE29018@twins.programming.kicks-ass.net>
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
> @@ -207,6 +207,8 @@ union hsw_tsx_tuning {
>  	u64	    value;
>  };
>  
> +#define PEBS_HSW_TSX_FLAGS	0xff00000000

That's a 64bit value and this needs ULL.

>  void init_debug_store_on_cpu(int cpu)
>  {
>  	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
> @@ -893,6 +895,16 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
>  	    (x86_pmu.intel_cap.pebs_format >= 2))
>  		data.weight = intel_hsw_weight(pebs);
>  
> +	if ((event->attr.sample_type & PERF_SAMPLE_TRANSACTION) &&
> +	    x86_pmu.intel_cap.pebs_format >= 2) {
> +		data.transaction =
> +			(pebs->tsx_tuning & PEBS_HSW_TSX_FLAGS) >> 32;

Screw checkpatch and make that an 81 char line or rename the thing
data.txn or so.

> +		/* For RTM XABORTs also log the abort code from AX */
> +		if ((data.transaction & PERF_SAMPLE_TXN_TRANSACTION) &&
> +		    (pebs->ax & 1))
> +			data.transaction |= pebs->ax & 0xff000000;

Yeah, do data.txn, that also allows the above line break to go away.

> +	}
> +
>  	if (has_branch_stack(event))
>  		data.br_stack = &cpuc->lbr_stack;
>  
> -- 
> 1.8.3.1
> 
