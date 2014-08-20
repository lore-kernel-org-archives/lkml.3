Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaHTPvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:51:11 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:40727 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaHTPvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:51:09 -0400
MIME-Version: 1.0
In-Reply-To: <1404918119-3676-1-git-send-email-geert+renesas@glider.be>
References: <1404918119-3676-1-git-send-email-geert+renesas@glider.be>
Date: Wed, 20 Aug 2014 17:51:08 +0200
X-Google-Sender-Auth: Qiu8erORmBW9243Te9fQf7wBy4M
Message-ID: <CAMuHMdXp0ruZjjJLXmWyCdfAXs9_9xFHDcmJ08M9_SbZqqq04g@mail.gmail.com>
Subject: Re: [PATCH v3] arm/smp: Absorb boot_secondary()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On Wed, Jul 9, 2014 at 5:01 PM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> After becoming a mandatory function, boot_secondary() is no longer used
> outside arch/arm/kernel/smp.c. Hence remove its public prototype, and,
> as suggested by Arnd, let it be absorbed by its single caller.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v3:
>   - Add Acked-by
>
> v2:
>   - This is v2 of "arm/smp: Make boot_secondary() static"
>   - Absorb boot_secondary() instead of making it static.
> ---
>  arch/arm/include/asm/smp.h |  6 ------
>  arch/arm/kernel/smp.c      | 12 ++++--------
>  2 files changed, 4 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
> index 2ec765c39ab4..18f5a554134f 100644
> --- a/arch/arm/include/asm/smp.h
> +++ b/arch/arm/include/asm/smp.h
> @@ -49,12 +49,6 @@ extern void smp_init_cpus(void);
>  extern void set_smp_cross_call(void (*)(const struct cpumask *, unsigned int));
>
>  /*
> - * Boot a secondary CPU, and assign it the specified idle task.
> - * This also gives us the initial stack to use for this CPU.
> - */
> -extern int boot_secondary(unsigned int cpu, struct task_struct *);
> -
> -/*
>   * Called from platform specific assembly code, this is the
>   * secondary CPU entry point.
>   */
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index 7c4fada440f0..2cf681bccd6f 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -92,6 +92,9 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
>  {
>         int ret;
>
> +       if (!smp_ops.smp_boot_secondary)
> +               return -ENOSYS;
> +
>         /*
>          * We need to tell the secondary core where to find
>          * its stack and the page tables.
> @@ -110,7 +113,7 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
>         /*
>          * Now bring the CPU into our world.
>          */
> -       ret = boot_secondary(cpu, idle);
> +       ret = smp_ops.smp_boot_secondary(cpu, idle);
>         if (ret == 0) {
>                 /*
>                  * CPU was successfully started, wait for it
> @@ -139,13 +142,6 @@ void __init smp_init_cpus(void)
>                 smp_ops.smp_init_cpus();
>  }
>
> -int boot_secondary(unsigned int cpu, struct task_struct *idle)
> -{
> -       if (smp_ops.smp_boot_secondary)
> -               return smp_ops.smp_boot_secondary(cpu, idle);
> -       return -ENOSYS;
> -}
> -
>  int platform_can_cpu_hotplug(void)
>  {
>  #ifdef CONFIG_HOTPLUG_CPU
> --
> 1.9.1

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
