Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab3BFK5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:57:15 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:45239 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131Ab3BFK5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:57:01 -0500
MIME-Version: 1.0
In-Reply-To: <20130206002704.GA11047@tassilo.jf.intel.com>
References: <1360028954-16946-1-git-send-email-andi@firstfloor.org>
	<1360028954-16946-5-git-send-email-andi@firstfloor.org>
	<CABPqkBTyBJwaz+ON20nCM0jyQASoHXRDejtyNLJ1AoBSWS_tPA@mail.gmail.com>
	<20130206002704.GA11047@tassilo.jf.intel.com>
Date: Wed, 6 Feb 2013 11:57:00 +0100
Message-ID: <CABPqkBSpYVyA0ZtLc12TWOS1AU1=4Kwo_Zx1FndB5XONonoavQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] perf, x86: Support full width counting
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 1:27 AM, Andi Kleen <ak@linux.intel.com> wrote:
> Here's an updated patch. I'm not reposting the full series.
> Also cut down on cc to spare the innocents.
>
> ---
>
>  perf, x86: Support full width counting v2
>
> Recent Intel CPUs like Haswell and IvyBridge have a new alternative MSR
> range for perfctrs that allows writing the full counter width. Enable this
> range if the hardware reports it using a new capability bit.
>
> This lowers the overhead of perf stat slightly because it has to do less
> interrupts to accumulate the counter value. On Haswell it also avoids some
> problems with TSX aborting when the end of the counter range is reached.
>
> v2: Print the feature at boot

Tested okay for me.
Reviewed-by: Stephane Eranian <eranian@google.com>

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
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
> index aa48048..06dcc0c 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -2228,5 +2228,12 @@ __init int intel_pmu_init(void)
>                 }
>         }
>
> +       /* Support full width counters using alternative MSR range */
> +       if (x86_pmu.intel_cap.fw_write) {
> +               x86_pmu.max_period = x86_pmu.cntval_mask;
> +               x86_pmu.perfctr = MSR_IA32_PMC0;
> +               pr_cont("full-width counters, ");
> +       }
> +
>         return 0;
>  }
>
> --
> ak@linux.intel.com -- Speaking for myself only
