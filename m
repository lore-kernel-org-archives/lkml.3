Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaFWJ3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:29:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:46616 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaFWJ3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:29:20 -0400
Date: Mon, 23 Jun 2014 11:29:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kleen, Andi" <andi.kleen@intel.com>
Subject: Re: [PATCH 1/2] perf: ignore LBR and offcore_rsp.
Message-ID: <20140623092917.GQ19860@laptop.programming.kicks-ass.net>
References: <37D7C6CF3E00A74B8858931C1DB2F0770148F513@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F0770148F513@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 03:52:55PM +0000, Liang, Kan wrote:
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> index 3b2f9bd..f828ddd 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -555,8 +555,9 @@ static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
> {
>     u64 disable_mask = __this_cpu_read(cpu_hw_events.perf_ctr_virt_mask);
> -    if (hwc->extra_reg.reg)
> -          wrmsrl(hwc->extra_reg.reg, hwc->extra_reg.config);
> +    if (hwc->extra_reg.reg &&
> +          (wrmsrl_safe(hwc->extra_reg.reg, hwc->extra_reg.config) < 0))
> +          return;
>     wrmsrl(hwc->config_base, (hwc->config | enable_mask) & ~disable_mask);
> }
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> index d82d155..6f2d1e9 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -157,7 +157,8 @@ static void intel_pmu_lbr_reset_32(void)
>     int i;
>      for (i = 0; i < x86_pmu.lbr_nr; i++)
> -          wrmsrl(x86_pmu.lbr_from + i, 0);
> +          if (wrmsrl_safe(x86_pmu.lbr_from + i, 0ULL) < 0)
> +               return;
> }
>  static void intel_pmu_lbr_reset_64(void)
> @@ -165,8 +166,9 @@ static void intel_pmu_lbr_reset_64(void)
>     int i;
>      for (i = 0; i < x86_pmu.lbr_nr; i++) {
> -          wrmsrl(x86_pmu.lbr_from + i, 0);
> -          wrmsrl(x86_pmu.lbr_to   + i, 0);
> +          if (wrmsrl_safe(x86_pmu.lbr_from + i, 0ULL) < 0 ||
> +              wrmsrl_safe(x86_pmu.lbr_to   + i, 0ULL) < 0)
> +               return;
>     }
> }
> @@ -241,7 +243,7 @@ static inline u64 intel_pmu_lbr_tos(void)
> {
>     u64 tos;
> -    rdmsrl(x86_pmu.lbr_tos, tos);
> +    rdmsrl_safe(x86_pmu.lbr_tos, &tos);
>      return tos;
> }
> @@ -262,7 +264,9 @@ static void intel_pmu_lbr_read_32(struct cpu_hw_events *cpuc)
>                u64     lbr;
>           } msr_lastbranch;
> -          rdmsrl(x86_pmu.lbr_from + lbr_idx, msr_lastbranch.lbr);
> +          if (rdmsrl_safe(x86_pmu.lbr_from + lbr_idx,
> +                    &msr_lastbranch.lbr) < 0)
> +               break;
>            cpuc->lbr_entries[i].from  = msr_lastbranch.from;
>           cpuc->lbr_entries[i].to         = msr_lastbranch.to;
> @@ -292,8 +296,9 @@ static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
>           int skip = 0;
>           int lbr_flags = lbr_desc[lbr_format];
> -          rdmsrl(x86_pmu.lbr_from + lbr_idx, from);
> -          rdmsrl(x86_pmu.lbr_to   + lbr_idx, to);
> +          if (rdmsrl_safe(x86_pmu.lbr_from + lbr_idx, &from) < 0 ||
> +              rdmsrl_safe(x86_pmu.lbr_to   + lbr_idx, &to) < 0)
> +               break;
>            if (lbr_flags & LBR_EIP_FLAGS) {
>                mis = !!(from & LBR_FROM_FLAG_MISPRED);

So I really hate this patch, it makes the code hideous. Also, its a
death by a thousand cuts adding endless branches in this code.

Also, the offcore part is retarded, just make sure extra_reg isn't set.

As to the LBR, just make it so that we avoid calling the LBR code to
begin with; ideally without adding extra code to fast paths.
