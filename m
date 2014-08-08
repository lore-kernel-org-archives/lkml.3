Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbaHHBae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 21:30:34 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:54301 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaHHBaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 21:30:30 -0400
MIME-Version: 1.0
In-Reply-To: <1407456941-16232-3-git-send-email-andi@firstfloor.org>
References: <1407456941-16232-1-git-send-email-andi@firstfloor.org>
	<1407456941-16232-3-git-send-email-andi@firstfloor.org>
Date: Fri, 8 Aug 2014 03:30:30 +0200
Message-ID: <CABPqkBTm7kPQszxPOGv5yUMzQ=PeW8BNgF6+jXMVDL-UjZQM-Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] perf, x86: Don't mark DataLA addresses as store
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 2:15 AM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Haswell supports reporting the data address for a range
> of PEBS events, including:
>
> UOPS_RETIRED.ALL
> MEM_UOPS_RETIRED.STLB_MISS_LOADS
> MEM_UOPS_RETIRED.STLB_MISS_STORES
> MEM_UOPS_RETIRED.LOCK_LOADS
> MEM_UOPS_RETIRED.SPLIT_LOADS
> MEM_UOPS_RETIRED.SPLIT_STORES
> MEM_UOPS_RETIRED.ALL_LOADS
> MEM_UOPS_RETIRED.ALL_STORES
> MEM_LOAD_UOPS_RETIRED.L1_HIT
> MEM_LOAD_UOPS_RETIRED.L2_HIT
> MEM_LOAD_UOPS_RETIRED.L3_HIT
> MEM_LOAD_UOPS_RETIRED.L1_MISS
> MEM_LOAD_UOPS_RETIRED.L2_MISS
> MEM_LOAD_UOPS_RETIRED.L3_MISS
> MEM_LOAD_UOPS_RETIRED.HIT_LFB
> MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_MISS
> MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_HIT
> MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_HITM
> MEM_LOAD_UOPS_L3_HIT_RETIRED.XSNP_NONE
> MEM_LOAD_UOPS_L3_MISS_RETIRED.LOCAL_DRAM
>
> This facility was already enabled earlier with the original Haswell
> perf changes.
>
> However these addresses were always reports as stores by perf, which is wrong,
> as they could be loads or NA too.
>
> This patch uses the load/store/na flags added earlier to report the correct
> operation based on the event type. For some events this is NA.
>
> v2: Supports load/stores/na again instead of marking everything NA
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_ds.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index aca77e9..855c19e 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -108,13 +108,19 @@ static u64 precise_store_data(u64 status)
>         return val;
>  }
>
> -static u64 precise_store_data_hsw(struct perf_event *event, u64 status)
> +static u64 precise_store_data_hsw(struct perf_event *event, u64 status,
> +                                 unsigned flags)
>  {
>         union perf_mem_data_src dse;
>         u64 cfg = event->hw.config & INTEL_ARCH_EVENT_MASK;
>
>         dse.val = 0;
No. This is not valid. You are not initializing all the field later on.
Needs to be:
          dse.val = PERF_MEM_NA
(which is defined in my patch).

> -       dse.mem_op = PERF_MEM_OP_STORE;
> +       if (flags & PERF_X86_EVENT_PEBS_LD_HSW)
> +               dse.mem_op = PERF_MEM_OP_LOAD;
> +       else if (flags & PERF_X86_EVENT_PEBS_ST_HSW)
> +               dse.mem_op = PERF_MEM_OP_STORE;
> +       else
> +               dse.mem_op = PERF_MEM_OP_NA;
>         dse.mem_lvl = PERF_MEM_LVL_NA;
>
But you have LOCK, SNOOP TLB, ....
So it is better to initialize globally dse.val once, and then patch
based on what you can gather.

I will repost the whole series with my fixes and cleanups.

>         /*
> @@ -868,7 +874,8 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
>                                          PERF_X86_EVENT_PEBS_LD_HSW|
>                                          PERF_X86_EVENT_PEBS_NA_HSW))
>                                 data.data_src.val =
> -                                       precise_store_data_hsw(event, pebs->dse);
> +                                       precise_store_data_hsw(event, pebs->dse,
> +                                                              event->hw.flags);
>                         else
>                                 data.data_src.val = precise_store_data(pebs->dse);
>                 }
> --
> 1.9.3
>
