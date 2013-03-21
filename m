Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab3CUR6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 13:58:11 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:44102 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab3CUR6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 13:58:09 -0400
MIME-Version: 1.0
In-Reply-To: <1363820051-24428-3-git-send-email-robherring2@gmail.com>
References: <1363820051-24428-1-git-send-email-robherring2@gmail.com>
	<1363820051-24428-3-git-send-email-robherring2@gmail.com>
Date: Thu, 21 Mar 2013 18:58:08 +0100
Message-ID: <CACRpkdZLn=KjJisPTN2eHn64UuaZvpBDDhmeqQXF-TVS8VZ7pA@mail.gmail.com>
Subject: Re: [PATCH 02/11] ARM: remove extra timer-sp control register clearing
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>, haojian.zhuang@linaro.org,
        pawel.moll@arm.com, john.stultz@linaro.org, tglx@linutronix.de,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:54 PM, Rob Herring <robherring2@gmail.com> wrote:

> From: Rob Herring <rob.herring@calxeda.com>
>
> The timer-sp initialization code clears the control register before
> initializing the timers, so every platform doing this is redundant.
>
> For unused timers, we should not care what state they are in.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
(...)
> diff --git a/arch/arm/mach-integrator/integrator_ap.c b/arch/arm/mach-integrator/integrator_ap.c
> index ea96144..4cb322d 100644
> --- a/arch/arm/mach-integrator/integrator_ap.c
> +++ b/arch/arm/mach-integrator/integrator_ap.c
> @@ -643,10 +643,6 @@ static void __init ap_timer_init(void)
>         clk_prepare_enable(clk);
>         rate = clk_get_rate(clk);
>
> -       writel(0, TIMER0_VA_BASE + TIMER_CTRL);
> -       writel(0, TIMER1_VA_BASE + TIMER_CTRL);
> -       writel(0, TIMER2_VA_BASE + TIMER_CTRL);
> -

As noted this is not an init function for timer-sp.c so please drop this
hunk of the patch. Maybe this zeroing is pointless but that would
be a separate patch that I can test.

> diff --git a/arch/arm/mach-integrator/integrator_cp.c b/arch/arm/mach-integrator/integrator_cp.c
> index 2b0db82..c68e7d8 100644
> --- a/arch/arm/mach-integrator/integrator_cp.c
> +++ b/arch/arm/mach-integrator/integrator_cp.c
> @@ -33,7 +33,6 @@
>  #include <mach/platform.h>
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
> -#include <asm/hardware/arm_timer.h>

What doe this change has to do with $SUBJECT?

>  #include <asm/hardware/icst.h>
>
>  #include <mach/cm.h>
> @@ -267,7 +266,6 @@ static void __init cp_of_timer_init(void)
>         base = of_iomap(node, 0);
>         if (WARN_ON(!base))
>                 return;
> -       writel(0, base + TIMER_CTRL);
>         sp804_clocksource_init(base, node->name);
>
>         err = of_property_read_string(of_aliases,
> @@ -279,7 +277,6 @@ static void __init cp_of_timer_init(void)
>         if (WARN_ON(!base))
>                 return;
>         irq = irq_of_parse_and_map(node, 0);
> -       writel(0, base + TIMER_CTRL);
>         sp804_clockevents_init(base, irq, node->name);
>  }
>
> @@ -510,10 +507,6 @@ static void __init intcp_init_irq(void)
>
>  static void __init cp_timer_init(void)
>  {
> -       writel(0, TIMER0_VA_BASE + TIMER_CTRL);
> -       writel(0, TIMER1_VA_BASE + TIMER_CTRL);
> -       writel(0, TIMER2_VA_BASE + TIMER_CTRL);
> -
>         sp804_clocksource_init(TIMER2_VA_BASE, "timer2");
>         sp804_clockevents_init(TIMER1_VA_BASE, IRQ_TIMERINT1, "timer1");
>  }

The rest of the changes to integrator_cp.c looks OK...

Yours,
Linus Walleij
