Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbaKGTmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:42:51 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57999 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaKGTms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:42:48 -0500
MIME-Version: 1.0
In-Reply-To: <1415388855-35074-1-git-send-email-anatol.pomozov@gmail.com>
References: <1415388855-35074-1-git-send-email-anatol.pomozov@gmail.com>
Date: Fri, 7 Nov 2014 11:42:44 -0800
Message-ID: <CAOMFOmVWuQbumGN05xLhAYzyAQaAs_nCEoooOYHE8wSPpfExcg@mail.gmail.com>
Subject: Re: [PATCH] timekeeping: Move persistent clock registration code from
 ARM to kernel
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: swarren@wwwdotorg.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux@arm.linux.org.uk, "tglx@linutronix.de" <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        tony@atomide.com, thierry.reding@gmail.com,
        Mark Rutland <mark.rutland@arm.com>,
        Anatol Pomozov <anatol.pomozov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patch opens possibility for further timekeeping cleanup:
read_persistent_clock() is defined as a weak and expected that
architecture implement it. The users of this function need to check
return value. If it is equal zero then persistent clock is not
provided. It looks hacky. It makes code nicer if architecture called

register_persistent_clock(&my_persistent_clock);

and then users check if persistent_clock variable is non-NULL.

On Fri, Nov 7, 2014 at 11:34 AM, Anatol Pomozov
<anatol.pomozov@gmail.com> wrote:
> ARM timekeeping functionality allows to register persistent/boot clock dynamically.
> This code is arch-independent and can be useful on other plaforms as well.
>
> As a byproduct of this change, tegra20_timer becomes ARM64 compatible.
>
> Tested: backported the change to chromeos-3.14 kernel ran on tegra 64bit
> board, made sure high-resolution clock works.
>
> Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
> ---
>  arch/arm/include/asm/mach/time.h    |  5 -----
>  arch/arm/kernel/time.c              | 36 -------------------------------
>  arch/arm/plat-omap/counter_32k.c    |  9 +++++---
>  drivers/clocksource/tegra20_timer.c | 10 +++++----
>  include/linux/timekeeping.h         | 11 ++++++++++
>  kernel/time/timekeeping.c           | 43 +++++++++++++++++++++++++++++++++----
>  6 files changed, 62 insertions(+), 52 deletions(-)
>
> diff --git a/arch/arm/include/asm/mach/time.h b/arch/arm/include/asm/mach/time.h
> index 90c12e1..3cbcafc 100644
> --- a/arch/arm/include/asm/mach/time.h
> +++ b/arch/arm/include/asm/mach/time.h
> @@ -12,9 +12,4 @@
>
>  extern void timer_tick(void);
>
> -struct timespec;
> -typedef void (*clock_access_fn)(struct timespec *);
> -extern int register_persistent_clock(clock_access_fn read_boot,
> -                                    clock_access_fn read_persistent);
> -
>  #endif
> diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
> index 0cc7e58..0aa1dcd 100644
> --- a/arch/arm/kernel/time.c
> +++ b/arch/arm/kernel/time.c
> @@ -76,42 +76,6 @@ void timer_tick(void)
>  }
>  #endif
>
> -static void dummy_clock_access(struct timespec *ts)
> -{
> -       ts->tv_sec = 0;
> -       ts->tv_nsec = 0;
> -}
> -
> -static clock_access_fn __read_persistent_clock = dummy_clock_access;
> -static clock_access_fn __read_boot_clock = dummy_clock_access;;
> -
> -void read_persistent_clock(struct timespec *ts)
> -{
> -       __read_persistent_clock(ts);
> -}
> -
> -void read_boot_clock(struct timespec *ts)
> -{
> -       __read_boot_clock(ts);
> -}
> -
> -int __init register_persistent_clock(clock_access_fn read_boot,
> -                                    clock_access_fn read_persistent)
> -{
> -       /* Only allow the clockaccess functions to be registered once */
> -       if (__read_persistent_clock == dummy_clock_access &&
> -           __read_boot_clock == dummy_clock_access) {
> -               if (read_boot)
> -                       __read_boot_clock = read_boot;
> -               if (read_persistent)
> -                       __read_persistent_clock = read_persistent;
> -
> -               return 0;
> -       }
> -
> -       return -EINVAL;
> -}
> -
>  void __init time_init(void)
>  {
>         if (machine_desc->init_time) {
> diff --git a/arch/arm/plat-omap/counter_32k.c b/arch/arm/plat-omap/counter_32k.c
> index 61b4d70..0dbfffd 100644
> --- a/arch/arm/plat-omap/counter_32k.c
> +++ b/arch/arm/plat-omap/counter_32k.c
> @@ -18,10 +18,9 @@
>  #include <linux/err.h>
>  #include <linux/io.h>
>  #include <linux/clocksource.h>
> +#include <linux/time.h>
>  #include <linux/sched_clock.h>
>
> -#include <asm/mach/time.h>
> -
>  #include <plat/counter-32k.h>
>
>  /* OMAP2_32KSYNCNT_CR_OFF: offset of 32ksync counter register */
> @@ -76,6 +75,10 @@ static void omap_read_persistent_clock(struct timespec *ts)
>         spin_unlock_irqrestore(&read_persistent_clock_lock, flags);
>  }
>
> +static const struct persistent_clock_ops omap_persistent_clock = {
> +       .read = omap_read_persistent_clock
> +};
> +
>  /**
>   * omap_init_clocksource_32k - setup and register counter 32k as a
>   * kernel clocksource
> @@ -116,7 +119,7 @@ int __init omap_init_clocksource_32k(void __iomem *vbase)
>         }
>
>         sched_clock_register(omap_32k_read_sched_clock, 32, 32768);
> -       register_persistent_clock(NULL, omap_read_persistent_clock);
> +       register_persistent_clock(&omap_persistent_clock);
>         pr_info("OMAP clocksource: 32k_counter at 32768 Hz\n");
>
>         return 0;
> diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c
> index d2616ef..210130e 100644
> --- a/drivers/clocksource/tegra20_timer.c
> +++ b/drivers/clocksource/tegra20_timer.c
> @@ -28,9 +28,7 @@
>  #include <linux/of_irq.h>
>  #include <linux/sched_clock.h>
>  #include <linux/delay.h>
> -
> -#include <asm/mach/time.h>
> -#include <asm/smp_twd.h>
> +#include <linux/timekeeping.h>
>
>  #define RTC_SECONDS            0x08
>  #define RTC_SHADOW_SECONDS     0x0c
> @@ -142,6 +140,10 @@ static void tegra_read_persistent_clock(struct timespec *ts)
>         *ts = *tsp;
>  }
>
> +static const struct persistent_clock_ops tegra_persistent_clock = {
> +       .read = tegra_read_persistent_clock
> +};
> +
>  static unsigned long tegra_delay_timer_read_counter_long(void)
>  {
>         return readl(timer_reg_base + TIMERUS_CNTR_1US);
> @@ -252,7 +254,7 @@ static void __init tegra20_init_rtc(struct device_node *np)
>         else
>                 clk_prepare_enable(clk);
>
> -       register_persistent_clock(NULL, tegra_read_persistent_clock);
> +       register_persistent_clock(&tegra_persistent_clock);
>  }
>  CLOCKSOURCE_OF_DECLARE(tegra20_rtc, "nvidia,tegra20-rtc", tegra20_init_rtc);
>
> diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
> index 1caa6b0..02023f7 100644
> --- a/include/linux/timekeeping.h
> +++ b/include/linux/timekeeping.h
> @@ -201,6 +201,17 @@ static inline bool has_persistent_clock(void)
>         return persistent_clock_exist;
>  }
>
> +struct persistent_clock_ops {
> +       void (*read)(struct timespec *ts);
> +       int (*update)(const struct timespec ts);
> +};
> +
> +struct boot_clock_ops {
> +       void (*read)(struct timespec *ts);
> +};
> +
> +extern void register_persistent_clock(const struct persistent_clock_ops *clock);
> +extern void register_boot_clock(const struct boot_clock_ops *clock);
>  extern void read_persistent_clock(struct timespec *ts);
>  extern void read_boot_clock(struct timespec *ts);
>  extern int update_persistent_clock(struct timespec now);
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index fb4a9c2..414c172 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -66,6 +66,9 @@ int __read_mostly timekeeping_suspended;
>  /* Flag for if there is a persistent clock on this platform */
>  bool __read_mostly persistent_clock_exist = false;
>
> +const struct persistent_clock_ops __read_mostly *persistent_clock = NULL;
> +const struct boot_clock_ops __read_mostly *boot_clock = NULL;
> +
>  static inline void tk_normalize_xtime(struct timekeeper *tk)
>  {
>         while (tk->tkr.xtime_nsec >= ((u64)NSEC_PER_SEC << tk->tkr.shift)) {
> @@ -956,6 +959,30 @@ u64 timekeeping_max_deferment(void)
>         return ret;
>  }
>
> +extern void register_persistent_clock(const struct persistent_clock_ops *clock)
> +{
> +       BUG_ON(!clock);
> +       BUG_ON(!clock->read);
> +
> +       if (persistent_clock) {
> +               pr_warn("Ignore extra persistent clock registration");
> +               return;
> +       }
> +       persistent_clock = clock;
> +}
> +
> +extern void register_boot_clock(const struct boot_clock_ops *clock)
> +{
> +       BUG_ON(!clock);
> +       BUG_ON(!clock->read);
> +
> +       if (boot_clock) {
> +               pr_warn("Ignore extra boot clock registration");
> +               return;
> +       }
> +       boot_clock = clock;
> +}
> +
>  /**
>   * read_persistent_clock -  Return time from the persistent clock.
>   *
> @@ -967,8 +994,12 @@ u64 timekeeping_max_deferment(void)
>   */
>  void __weak read_persistent_clock(struct timespec *ts)
>  {
> -       ts->tv_sec = 0;
> -       ts->tv_nsec = 0;
> +       if (persistent_clock) {
> +               persistent_clock->read(ts);
> +       } else {
> +               ts->tv_sec = 0;
> +               ts->tv_nsec = 0;
> +       }
>  }
>
>  /**
> @@ -982,8 +1013,12 @@ void __weak read_persistent_clock(struct timespec *ts)
>   */
>  void __weak read_boot_clock(struct timespec *ts)
>  {
> -       ts->tv_sec = 0;
> -       ts->tv_nsec = 0;
> +       if (boot_clock) {
> +               boot_clock->read(ts);
> +       } else {
> +               ts->tv_sec = 0;
> +               ts->tv_nsec = 0;
> +       }
>  }
>
>  /*
> --
> 2.1.0.rc2.206.gedb03e5
>
