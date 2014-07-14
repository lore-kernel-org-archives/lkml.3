Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbaGNSEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:04:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54683 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaGNSEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:04:13 -0400
MIME-Version: 1.0
In-Reply-To: <1405123285-23544-2-git-send-email-andi@firstfloor.org>
References: <1405123285-23544-1-git-send-email-andi@firstfloor.org>
	<1405123285-23544-2-git-send-email-andi@firstfloor.org>
Date: Mon, 14 Jul 2014 20:04:13 +0200
Message-ID: <CABPqkBScNfoK4a9BZkZxB-gAj3Ew2f7Ox3351YKWVt7cN-1EEw@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf, x86: Don't mark DataLA addresses as store
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 2:01 AM, Andi Kleen <andi@firstfloor.org> wrote:
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
> as they could be loads too.  The hardware does not distinguish loads and stores
> for these instructions, so there's no (cheap) way for the profiler
> to find out.
>
> Change the type to PERF_MEM_OP_NA instead.
>
You could do better if you tagged the event during setup as load vs. store.
And then you could simply propagate the flag to the data source struct.

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_ds.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index 64b4be9..13baa7c 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -114,7 +114,7 @@ static u64 precise_store_data_hsw(struct perf_event *event, u64 status)
>         u64 cfg = event->hw.config & INTEL_ARCH_EVENT_MASK;
>
>         dse.val = 0;
> -       dse.mem_op = PERF_MEM_OP_STORE;
> +       dse.mem_op = PERF_MEM_OP_NA;
>         dse.mem_lvl = PERF_MEM_LVL_NA;
>
>         /*
> --
> 1.9.3
>
