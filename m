Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbaBZKAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 05:00:11 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:50898 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaBZKAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 05:00:04 -0500
MIME-Version: 1.0
In-Reply-To: <20140223212737.312855906@linutronix.de>
References: <20140223212703.511977310@linutronix.de>
	<20140223212737.312855906@linutronix.de>
Date: Wed, 26 Feb 2014 18:00:03 +0800
Message-ID: <CAMk6uBmqJTjjEm116f8M4sPF2Skb1AJzzyZGDszxh-caDgXcwQ@mail.gmail.com>
Subject: Re: [patch 10/26] blackfin:Use generic /proc/interrupts implementation
From: Steven Miao <realmz6@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        bfin <adi-buildroot-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Mon, Feb 24, 2014 at 5:40 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> There is nothing special in that blackfin code. Use the core
> implementation.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Steven Miao <realmz6@gmail.com>
> Cc: bfin <adi-buildroot-devel@lists.sourceforge.net>
> ---
>  arch/blackfin/Kconfig          |    1 +
>  arch/blackfin/kernel/irqchip.c |   36 +++++++-----------------------------
>  2 files changed, 8 insertions(+), 29 deletions(-)
>
> Index: tip/arch/blackfin/Kconfig
> ===================================================================
> --- tip.orig/arch/blackfin/Kconfig
> +++ tip/arch/blackfin/Kconfig
> @@ -34,6 +34,7 @@ config BLACKFIN
>         select ARCH_WANT_IPC_PARSE_VERSION
>         select GENERIC_ATOMIC64
>         select GENERIC_IRQ_PROBE
> +       select GENERIC_IRQ_SHOW
>         select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
>         select GENERIC_SMP_IDLE_THREAD
>         select ARCH_USES_GETTIMEOFFSET if !GENERIC_CLOCKEVENTS
> Index: tip/arch/blackfin/kernel/irqchip.c
> ===================================================================
> --- tip.orig/arch/blackfin/kernel/irqchip.c
> +++ tip/arch/blackfin/kernel/irqchip.c
> @@ -33,37 +33,15 @@ static struct irq_desc bad_irq_desc = {
>  #endif
>
>  #ifdef CONFIG_PROC_FS
> -int show_interrupts(struct seq_file *p, void *v)
> +int arch_show_interrupts(struct seq_file *p, int prec)
>  {
> -       int i = *(loff_t *) v, j;
> -       struct irqaction *action;
> -       unsigned long flags;
> +       int j;
>
> -       if (i < NR_IRQS) {
> -               struct irq_desc *desc = irq_to_desc(i);
> -
> -               raw_spin_lock_irqsave(&desc->lock, flags);
> -               action = desc->action;
> -               if (!action)
> -                       goto skip;
> -               seq_printf(p, "%3d: ", i);
> -               for_each_online_cpu(j)
> -                       seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
> -               seq_printf(p, " %8s", irq_desc_get_chip(desc)->name);
> -               seq_printf(p, "  %s", action->name);
> -               for (action = action->next; action; action = action->next)
> -                       seq_printf(p, "  %s", action->name);
> -
> -               seq_putc(p, '\n');
> - skip:
> -               raw_spin_unlock_irqrestore(&desc->lock, flags);
> -       } else if (i == NR_IRQS) {
> -               seq_printf(p, "NMI: ");
> -               for_each_online_cpu(j)
> -                       seq_printf(p, "%10u ", cpu_pda[j].__nmi_count);
> -               seq_printf(p, "     CORE  Non Maskable Interrupt\n");
> -               seq_printf(p, "Err: %10u\n",  atomic_read(&irq_err_count));
> -       }
> +       seq_printf(p, "%*s: ", prec "NMI");
> +       for_each_online_cpu(j)
> +               seq_printf(p, "%10u ", cpu_pda[j].__nmi_count);
> +       seq_printf(p, "  CORE  Non Maskable Interrupt\n");
> +       seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read(&irq_err_count));
>         return 0;
>  }
>  #endif
>
>
Thanks. Applied.

-steven
