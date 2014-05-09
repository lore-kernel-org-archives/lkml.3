Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaEIEnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 00:43:08 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:33230 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaEIEnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 00:43:06 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1405082058130.980@knanqh.ubzr>
References: <1399504982-31181-1-git-send-email-dianders@chromium.org>
	<CAOh2x=kwaoSdj8JO0Vo08Y0dX2UfKFiF3pBV-qtp-YTyN=8H8Q@mail.gmail.com>
	<CAD=FV=UEGJGHrdcXgs3EZ_wFXT8GnNeCOMt7CgdiiUzBzZ5Y0A@mail.gmail.com>
	<alpine.LFD.2.11.1405081149190.980@knanqh.ubzr>
	<CAD=FV=VtcLOh51LCmafzRMdqtDrwKXCqK6gE6V7OOOUe4gjwbA@mail.gmail.com>
	<alpine.LFD.2.11.1405081329010.980@knanqh.ubzr>
	<20140508192209.GH3693@n2100.arm.linux.org.uk>
	<alpine.LFD.2.11.1405081600260.980@knanqh.ubzr>
	<20140508205223.GI3693@n2100.arm.linux.org.uk>
	<alpine.LFD.2.11.1405082058130.980@knanqh.ubzr>
Date: Thu, 8 May 2014 21:43:04 -0700
X-Google-Sender-Auth: uokWhswbfwrQNf9PUgvzLo2e9s4
Message-ID: <CAD=FV=XmcGETtRbFDVseLZnyfjrG6q5+2nEFq6oYVucEhFrPjA@mail.gmail.com>
Subject: Re: [PATCH] ARM: Don't ever downscale loops_per_jiffy in SMP systems
From: Doug Anderson <dianders@chromium.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        David Riley <davidriley@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shawn Guo <shawn.guo@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas,

On Thu, May 8, 2014 at 6:37 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Thu, 8 May 2014, Russell King - ARM Linux wrote:
>
>> If you're in a preempt or SMP environment, provide a timer for udelay().
>> IF you're in an environment with IRQs which can take a long time, use
>> a timer for udelay().  If you're in an environment where the CPU clock
>> can change unexpectedly, use a timer for udelay().
>
> Longer delays are normally not a problem.  If they are, then simply
> disabling IRQs may solve it if absolutely required.  With much shorter
> delays than expected this is another story.
>
> What about the following:
>
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index 7c4fada440..10030cc5a0 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -682,6 +682,15 @@ static int cpufreq_callback(struct notifier_block *nb,
>                         cpufreq_scale(per_cpu(l_p_j_ref, cpu),
>                                         per_cpu(l_p_j_ref_freq, cpu),
>                                         freq->new);
> +               /*
> +                * Another CPU might have called udelay() just before LPJ
> +                * and a shared CPU clock is increased.  That other CPU still
> +                * looping on the old LPJ value would return significantly
> +                * sooner than expected.  The actual fix is to provide a
> +                * timer based udelay() implementation instead.
> +                */
> +               if (freq->old < freq->new)
> +                       pr_warn_once("*** udelay() on SMP is racy and may be much shorter than expected ***\n");

I would be OK with that.  At least someone would have a clue what to do.

-Doug
