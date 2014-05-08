Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaEHKlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:41:05 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:53270 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbaEHKlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:41:01 -0400
MIME-Version: 1.0
In-Reply-To: <1399504982-31181-1-git-send-email-dianders@chromium.org>
References: <1399504982-31181-1-git-send-email-dianders@chromium.org>
Date: Thu, 8 May 2014 16:11:00 +0530
X-Google-Sender-Auth: -qwfBe7p_MNCyDE5xs6siRfbwtA
Message-ID: <CAOh2x=kwaoSdj8JO0Vo08Y0dX2UfKFiF3pBV-qtp-YTyN=8H8Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: Don't ever downscale loops_per_jiffy in SMP systems
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Doug Anderson <dianders@chromium.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        David Riley <davidriley@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing Rafael's id.

On Thu, May 8, 2014 at 4:53 AM, Doug Anderson <dianders@chromium.org> wrote:
> Downscaling loops_per_jiffy on SMP ARM systems really doesn't work.
> You could really only do this if:
>
> * Each CPU is has independent frequency changes (changing one CPU
>   doesn't affect another).
> * We change the generic ARM udelay() code to actually look at percpu
>   loops_per_jiffy.

There is one more case I believe:
All CPUs share a single clock line and generic udelay() uses global
loops_per_jiffy, as it would never happen that some other CPU is running
faster and udelay would complete early

> I don't know of any ARM CPUs that are totally independent that don't
> just use a timer-based delay anyway.  For those that don't have a
> timer-based delay, we should be conservative and overestimate
> loops_per_jiffy.
>
> Note that on some systems you might sometimes see (in the extreme case
> when we're all the way downclocked) a udelay(100) become a
> udelay(1000) now.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index 7c4fada..9d944f6 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -649,39 +649,50 @@ int setup_profiling_timer(unsigned int multiplier)
>
>  #ifdef CONFIG_CPU_FREQ
>
> -static DEFINE_PER_CPU(unsigned long, l_p_j_ref);
> -static DEFINE_PER_CPU(unsigned long, l_p_j_ref_freq);
>  static unsigned long global_l_p_j_ref;
>  static unsigned long global_l_p_j_ref_freq;
> +static unsigned long global_l_p_j_max_freq;
> +
> +/**
> + * cpufreq_callback - Adjust loops_per_jiffies when frequency changes
> + *
> + * When the CPU frequency changes we need to adjust loops_per_jiffies, which
> + * we assume scales linearly with frequency.
> + *
> + * This function is fairly castrated and only ever adjust loops_per_jiffies
> + * upward.  It also doesn't adjust the PER_CPU loops_per_jiffies.  Here's why:
> + * 1. The ARM udelay only ever looks at the global loops_per_jiffy not the
> + *    percpu one.  If your CPUs _are not_ changed in lockstep you could run
> + *    into problems by decreasing loops_per_jiffies since one of the other
> + *    processors might still be running slower.
> + * 2. The ARM udelay reads the loops_per_jiffy at the beginning of its loop and
> + *    no other times.  If your CPUs _are_ changed in lockstep you could run
> + *    into a race where one CPU has started its loop with old (slower)
> + *    loops_per_jiffy and then suddenly is running faster.
> + *
> + * Anyone who wants a good udelay() should be using a timer-based solution
> + * anyway.  If you don't have a timer solution, you just gotta be conservative.
> + */
>
>  static int cpufreq_callback(struct notifier_block *nb,
>                                         unsigned long val, void *data)
>  {
>         struct cpufreq_freqs *freq = data;
> -       int cpu = freq->cpu;
>
>         if (freq->flags & CPUFREQ_CONST_LOOPS)
>                 return NOTIFY_OK;
>
> -       if (!per_cpu(l_p_j_ref, cpu)) {
> -               per_cpu(l_p_j_ref, cpu) =
> -                       per_cpu(cpu_data, cpu).loops_per_jiffy;
> -               per_cpu(l_p_j_ref_freq, cpu) = freq->old;
> -               if (!global_l_p_j_ref) {
> -                       global_l_p_j_ref = loops_per_jiffy;
> -                       global_l_p_j_ref_freq = freq->old;
> -               }
> +       if (!global_l_p_j_ref) {
> +               global_l_p_j_ref = loops_per_jiffy;
> +               global_l_p_j_ref_freq = freq->old;
> +               global_l_p_j_max_freq = freq->old;
>         }
>
> -       if ((val == CPUFREQ_PRECHANGE  && freq->old < freq->new) ||
> -           (val == CPUFREQ_POSTCHANGE && freq->old > freq->new)) {
> +       if (freq->new > global_l_p_j_max_freq) {
>                 loops_per_jiffy = cpufreq_scale(global_l_p_j_ref,
>                                                 global_l_p_j_ref_freq,
>                                                 freq->new);
> -               per_cpu(cpu_data, cpu).loops_per_jiffy =
> -                       cpufreq_scale(per_cpu(l_p_j_ref, cpu),
> -                                       per_cpu(l_p_j_ref_freq, cpu),
> -                                       freq->new);
> +               global_l_p_j_max_freq = freq->new;
>         }
>         return NOTIFY_OK;
>  }

So, the end of this will happen when a CPU is set to its highest frequency
for the first time. After that this routine will simply be noise and nothing
more. Isn't it?

And if that's the case, why don't we get rid of it completely and set
global-loop-per-jiffy for the max freq at boot ?

--
viresh
