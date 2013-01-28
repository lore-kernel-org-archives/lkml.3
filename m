Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3A1VrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 16:47:05 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:56187 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab3A1VrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 16:47:02 -0500
MIME-Version: 1.0
In-Reply-To: <1359151245-13179-6-git-send-email-andi@firstfloor.org>
References: <1359151245-13179-1-git-send-email-andi@firstfloor.org>
	<1359151245-13179-6-git-send-email-andi@firstfloor.org>
Date: Mon, 28 Jan 2013 22:47:01 +0100
Message-ID: <CABPqkBR=vZ-S0PTZDFk03f3vXah+Ozi8KHmDGH8Q01ROO+LYFg@mail.gmail.com>
Subject: Re: [PATCH 05/12] perf, x86: Support Haswell v4 LBR format
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 11:00 PM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Haswell has two additional LBR from flags for TSX: intx and abort, implemented
> as a new v4 version of the LBR format.
>
> Handle those in and adjust the sign extension code to still correctly extend.
> The flags are exported similarly in the LBR record to the existing misprediction
> flag
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |   18 +++++++++++++++---
>  include/linux/perf_event.h                 |    7 ++++++-
>  2 files changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> index da02e9c..2af6695b 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -12,6 +12,7 @@ enum {
>         LBR_FORMAT_LIP          = 0x01,
>         LBR_FORMAT_EIP          = 0x02,
>         LBR_FORMAT_EIP_FLAGS    = 0x03,
> +       LBR_FORMAT_EIP_FLAGS2   = 0x04,
>  };
>
>  /*
> @@ -56,6 +57,8 @@ enum {
>          LBR_FAR)
>
>  #define LBR_FROM_FLAG_MISPRED  (1ULL << 63)
> +#define LBR_FROM_FLAG_INTX     (1ULL << 62)
> +#define LBR_FROM_FLAG_ABORT    (1ULL << 61)
>
>  #define for_each_branch_sample_type(x) \
>         for ((x) = PERF_SAMPLE_BRANCH_USER; \
> @@ -270,21 +273,30 @@ static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
>
>         for (i = 0; i < x86_pmu.lbr_nr; i++) {
>                 unsigned long lbr_idx = (tos - i) & mask;
> -               u64 from, to, mis = 0, pred = 0;
> +               u64 from, to, mis = 0, pred = 0, intx = 0, abort = 0;
>
>                 rdmsrl(x86_pmu.lbr_from + lbr_idx, from);
>                 rdmsrl(x86_pmu.lbr_to   + lbr_idx, to);
>
> -               if (lbr_format == LBR_FORMAT_EIP_FLAGS) {
> +               if (lbr_format == LBR_FORMAT_EIP_FLAGS ||
> +                   lbr_format == LBR_FORMAT_EIP_FLAGS2) {
>                         mis = !!(from & LBR_FROM_FLAG_MISPRED);
>                         pred = !mis;
> -                       from = (u64)((((s64)from) << 1) >> 1);
> +                       if (lbr_format == LBR_FORMAT_EIP_FLAGS)
> +                               from = (u64)((((s64)from) << 1) >> 1);
> +                       else if (lbr_format == LBR_FORMAT_EIP_FLAGS2) {
> +                               intx = !!(from & LBR_FROM_FLAG_INTX);
> +                               abort = !!(from & LBR_FROM_FLAG_ABORT);
> +                               from = (u64)((((s64)from) << 3) >> 3);
> +                       }
>                 }
>
Wouldn't all that be more readable with a switch-case, especially given
that lbr_format could be extended.


>                 cpuc->lbr_entries[i].from       = from;
>                 cpuc->lbr_entries[i].to         = to;
>                 cpuc->lbr_entries[i].mispred    = mis;
>                 cpuc->lbr_entries[i].predicted  = pred;
> +               cpuc->lbr_entries[i].intx       = intx;
> +               cpuc->lbr_entries[i].abort      = abort;
>                 cpuc->lbr_entries[i].reserved   = 0;
>         }
>         cpuc->lbr_stack.nr = i;
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 6bfb2faa..91052e1 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -74,13 +74,18 @@ struct perf_raw_record {
>   *
>   * support for mispred, predicted is optional. In case it
>   * is not supported mispred = predicted = 0.
> + *
> + *     intx: running in a hardware transaction
> + *     abort: aborting a hardware transaction
>   */
>  struct perf_branch_entry {
>         __u64   from;
>         __u64   to;
>         __u64   mispred:1,  /* target mispredicted */
>                 predicted:1,/* target predicted */
> -               reserved:62;
> +               intx:1,     /* in transaction */
> +               abort:1,    /* transaction abort */
> +               reserved:60;
>  };
>
>  /*
> --
> 1.7.7.6
>
