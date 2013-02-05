Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab3BEPP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:15:28 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:54325 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab3BEPP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:15:27 -0500
MIME-Version: 1.0
In-Reply-To: <1360028954-16946-5-git-send-email-andi@firstfloor.org>
References: <1360028954-16946-1-git-send-email-andi@firstfloor.org>
	<1360028954-16946-5-git-send-email-andi@firstfloor.org>
Date: Tue, 5 Feb 2013 16:15:26 +0100
Message-ID: <CABPqkBTyBJwaz+ON20nCM0jyQASoHXRDejtyNLJ1AoBSWS_tPA@mail.gmail.com>
Subject: Re: [PATCH 4/5] perf, x86: Support full width counting
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

On Tue, Feb 5, 2013 at 2:49 AM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Recent Intel CPUs have a new alternative MSR range for perfctrs that allows
> writing the full counter width. Enable this range if the hardware reports it
> using a new capability bit. This lowers overhead of perf stat slightly because
> it has to do less interrupts to accumulate the counter value. On Haswell it
> also avoids some problems with TSX aborting when the end of the counter
> range is reached.
>
I would add that this patch mitigates overhead in counting from
on SNB/IVB as well as HSW.

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/include/uapi/asm/msr-index.h  |    3 +++
>  arch/x86/kernel/cpu/perf_event.h       |    1 +
>  arch/x86/kernel/cpu/perf_event_intel.c |    6 ++++++
>  3 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
> index 433a59f..af41a77 100644
> --- a/arch/x86/include/uapi/asm/msr-index.h
> +++ b/arch/x86/include/uapi/asm/msr-index.h
> @@ -163,6 +163,9 @@
>  #define MSR_KNC_EVNTSEL0               0x00000028
>  #define MSR_KNC_EVNTSEL1               0x00000029
>
> +/* Alternative perfctr range with full access. */
> +#define MSR_IA32_PMC0                  0x000004c1
> +
>  /* AMD64 MSRs. Not complete. See the architecture manual for a more
>     complete list. */
>
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> index 1567b0d..ce2a863 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -278,6 +278,7 @@ union perf_capabilities {
>                 u64     pebs_arch_reg:1;
>                 u64     pebs_format:4;
>                 u64     smm_freeze:1;
> +               u64     fw_write:1;
>         };
>         u64     capabilities;
>  };
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index aa48048..d96010a 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -2228,5 +2228,11 @@ __init int intel_pmu_init(void)
>                 }
>         }
>
> +       /* Support full width counters using alternative MSR range */
> +       if (x86_pmu.intel_cap.fw_write) {
> +               x86_pmu.max_period = x86_pmu.cntval_mask;

Something is not clear to me: What happens to the fixed counters with
full writes? Were they already full-width? The SDM does not explain what
happens to them with this extension. Could you clarify?

> +               x86_pmu.perfctr = MSR_IA32_PMC0;

I would add here:
   pr_cont("full-width counters, ");

> +       }
> +
>         return 0;
>  }
> --
> 1.7.7.6
>
