Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaFWJxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:53:45 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:58668 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaFWJxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:53:43 -0400
MIME-Version: 1.0
In-Reply-To: <1403286472-6817-4-git-send-email-dianders@chromium.org>
References: <1403286472-6817-1-git-send-email-dianders@chromium.org> <1403286472-6817-4-git-send-email-dianders@chromium.org>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 23 Jun 2014 11:53:23 +0200
Message-ID: <CAKfTPtDKRsxxre-RGet6FeMBJY_8Mk_Vr3DJvcc_6APNGJC2Uw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] clocksource: exynos_mct: Only use 32-bits where possible
To: Doug Anderson <dianders@chromium.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Chirantan Ekbote <chirantan@chromium.org>,
        David Riley <davidriley@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        javier.martinez@collabora.co.uk, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

Acked-by Vincent Guittot <vincent.guittot@linaro.org>

Vincent

On 20 June 2014 19:47, Doug Anderson <dianders@chromium.org> wrote:
> The MCT has a nice 64-bit counter.  That means that we _can_ register
> as a 64-bit clocksource and sched_clock.  ...but that doesn't mean we
> should.
>
> The 64-bit counter is read by reading two 32-bit registers.  That
> means reading needs to be something like:
> - Read upper half
> - Read lower half
> - Read upper half and confirm that it hasn't changed.
>
> That wouldn't be terrible, but:
> - THe MCT isn't very fast to access (hundreds of nanoseconds).
> - The clocksource is queried _all the time_.
>
> In total system profiles of real workloads on ChromeOS, we've seen
> exynos_frc_read() taking 2% or more of CPU time even after optimizing
> the 3 reads above to 2 (see below).
>
> The MCT is clocked at ~24MHz on all known systems.  That means that
> the 32-bit half of the counter rolls over every ~178 seconds.  This
> inspired an optimization in ChromeOS to cache the upper half between
> calls, moving 3 reads to 2.  ...but we can do better!  Having a 32-bit
> timer that flips every 178 seconds is more than sufficient for Linux.
> Let's just use the lower half of the MCT.
>
> Times on 5420 to do 1000000 gettimeofday() calls from userspace:
> * Original code:                      1323852 us
> * ChromeOS cache upper half:          1173084 us
> * ChromeOS + ldmia to optimize:       1045674 us
> * Use lower 32-bit only (this code):  1014429 us
>
> As you can see, the time used doesn't increase linearly with the
> number of reads and we can make 64-bit work almost as fast as 32-bit
> with a bit of assembly code.  But since there's no real gain for
> 64-bit, let's go with the simplest and fastest implementation.
>
> Note: with this change roughly half the time for gettimeofday() is
> spent in exynos_frc_read().  The rest is timer / system call overhead.
>
> Also note: this patch disables the use of the MCT on ARM64 systems
> until we've sorted out how to make "cycles_t" always 32-bit.  Really
> ARM64 systems should be using arch timers anyway.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v3:
> - Now 32-bit version instead of ldmia version
>
> Changes in v2: None
>
>  drivers/clocksource/Kconfig      |  1 +
>  drivers/clocksource/exynos_mct.c | 39 ++++++++++++++++++++++++++++++++-------
>  2 files changed, 33 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index 065131c..a7aeee8 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -125,6 +125,7 @@ config CLKSRC_METAG_GENERIC
>
>  config CLKSRC_EXYNOS_MCT
>         def_bool y if ARCH_EXYNOS
> +       depends on !ARM64
>         help
>           Support for Multi Core Timer controller on Exynos SoCs.
>
> diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
> index 2df03e2..9403061 100644
> --- a/drivers/clocksource/exynos_mct.c
> +++ b/drivers/clocksource/exynos_mct.c
> @@ -162,7 +162,17 @@ static void exynos4_mct_frc_start(void)
>         exynos4_mct_write(reg, EXYNOS4_MCT_G_TCON);
>  }
>
> -static cycle_t notrace _exynos4_frc_read(void)
> +/**
> + * exynos4_read_count_64 - Read all 64-bits of the global counter
> + *
> + * This will read all 64-bits of the global counter taking care to make sure
> + * that the upper and lower half match.  Note that reading the MCT can be quite
> + * slow (hundreds of nanoseconds) so you should use the 32-bit (lower half
> + * only) version when possible.
> + *
> + * Returns the number of cycles in the global counter.
> + */
> +static u64 exynos4_read_count_64(void)
>  {
>         unsigned int lo, hi;
>         u32 hi2 = readl_relaxed(reg_base + EXYNOS4_MCT_G_CNT_U);
> @@ -176,9 +186,22 @@ static cycle_t notrace _exynos4_frc_read(void)
>         return ((cycle_t)hi << 32) | lo;
>  }
>
> +/**
> + * exynos4_read_count_32 - Read the lower 32-bits of the global counter
> + *
> + * This will read just the lower 32-bits of the global counter.  This is marked
> + * as notrace so it can be used by the scheduler clock.
> + *
> + * Returns the number of cycles in the global counter (lower 32 bits).
> + */
> +static u32 notrace exynos4_read_count_32(void)
> +{
> +       return readl_relaxed(reg_base + EXYNOS4_MCT_G_CNT_L);
> +}
> +
>  static cycle_t exynos4_frc_read(struct clocksource *cs)
>  {
> -       return _exynos4_frc_read();
> +       return exynos4_read_count_32();
>  }
>
>  static void exynos4_frc_resume(struct clocksource *cs)
> @@ -190,21 +213,23 @@ struct clocksource mct_frc = {
>         .name           = "mct-frc",
>         .rating         = 400,
>         .read           = exynos4_frc_read,
> -       .mask           = CLOCKSOURCE_MASK(64),
> +       .mask           = CLOCKSOURCE_MASK(32),
>         .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
>         .resume         = exynos4_frc_resume,
>  };
>
>  static u64 notrace exynos4_read_sched_clock(void)
>  {
> -       return _exynos4_frc_read();
> +       return exynos4_read_count_32();
>  }
>
>  static struct delay_timer exynos4_delay_timer;
>
>  static cycles_t exynos4_read_current_timer(void)
>  {
> -       return _exynos4_frc_read();
> +       BUILD_BUG_ON_MSG(sizeof(cycles_t) != sizeof(u32),
> +                        "cycles_t needs to move to 32-bit for ARM64 usage");
> +       return exynos4_read_count_32();
>  }
>
>  static void __init exynos4_clocksource_init(void)
> @@ -218,7 +243,7 @@ static void __init exynos4_clocksource_init(void)
>         if (clocksource_register_hz(&mct_frc, clk_rate))
>                 panic("%s: can't register clocksource\n", mct_frc.name);
>
> -       sched_clock_register(exynos4_read_sched_clock, 64, clk_rate);
> +       sched_clock_register(exynos4_read_sched_clock, 32, clk_rate);
>  }
>
>  static void exynos4_mct_comp0_stop(void)
> @@ -245,7 +270,7 @@ static void exynos4_mct_comp0_start(enum clock_event_mode mode,
>                 exynos4_mct_write(cycles, EXYNOS4_MCT_G_COMP0_ADD_INCR);
>         }
>
> -       comp_cycle = exynos4_frc_read(&mct_frc) + cycles;
> +       comp_cycle = exynos4_read_count_64() + cycles;
>         exynos4_mct_write((u32)comp_cycle, EXYNOS4_MCT_G_COMP0_L);
>         exynos4_mct_write((u32)(comp_cycle >> 32), EXYNOS4_MCT_G_COMP0_U);
>
> --
> 2.0.0.526.g5318336
>
