Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab3BJKge (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 05:36:34 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:49284 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab3BJKgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 05:36:32 -0500
MIME-Version: 1.0
In-Reply-To: <20130131002344.1161E360095@xplor.waratah.dyndns.org>
References: <20130131002344.1161E360095@xplor.waratah.dyndns.org>
Date: Sun, 10 Feb 2013 11:36:31 +0100
X-Google-Sender-Auth: c5UffY64IobKLq4oHTXTGwES3Q4
Message-ID: <CAMuHMdUFuNpiZzTr=86Yi2yx73xh_qv8S6PnT0hp9U8x86vskw@mail.gmail.com>
Subject: Re: [PATCH 09/17] [m68k] IRQ: add handle_polled_irq() for timer based
 soft interrupts
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitzmic@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 1:23 AM, Michael Schmitz <schmitzmic@gmail.com> wrote:
> [PATCH 09/17] [m68k] IRQ: add handle_polled_irq() for timer based soft interrupts -
>         experimental hack to avoid unhandled interrupt timer to fire
>         on EtherNEC/NetUSBee cards that have no hardware interrupt
>         and need to be polled from a timer
>
> This patch adds a special 'polled interrupt' handler for timer based software interrupts.

Adding Thomas and lkml.

> handle_simple_irq() will respond to excessive unhandled interrupts (as are expected for a
> polling timer interrupt) by disabling the apparently unhandled interrupt source.
>
> handle_polled_irq() prevents this by setting the IRQS_POLL_INPROGRESS flag which will cause
> the unhandled interrupt events to be ignored.
>
> This is a temporary hack to allow timer based polling of the Atari ROM port network and USB
> cards only. Suggestions on how to properly handle this in the normal interrupt framework are
> most welcome.
>
> Signed-off-by: Michael Schmitz <schmitz@debian.org>
> ---
>  include/linux/irq.h |    1 +
>  kernel/irq/chip.c   |   36 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index fdf2c4a..39bfcff 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -407,6 +407,7 @@ extern void handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc);
>  extern void handle_edge_irq(unsigned int irq, struct irq_desc *desc);
>  extern void handle_edge_eoi_irq(unsigned int irq, struct irq_desc *desc);
>  extern void handle_simple_irq(unsigned int irq, struct irq_desc *desc);
> +extern void handle_polled_irq(unsigned int irq, struct irq_desc *desc);
>  extern void handle_percpu_irq(unsigned int irq, struct irq_desc *desc);
>  extern void handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc);
>  extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index 3aca9f2..ae7ef4d 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -339,6 +339,42 @@ out_unlock:
>  }
>  EXPORT_SYMBOL_GPL(handle_simple_irq);
>
> +/**
> + *     handle_polled_irq - Simple and software-decoded IRQs.
> + *     @irq:   the interrupt number
> + *     @desc:  the interrupt description structure for this irq
> + *
> + *     Polled interrupts are sent from a demultiplexing software interrupt
> + *     handler, where no interrupt hardware control is necessary.
> + */
> +void
> +handle_polled_irq(unsigned int irq, struct irq_desc *desc)
> +{
> +       raw_spin_lock(&desc->lock);
> +
> +       if (unlikely(irqd_irq_inprogress(&desc->irq_data)))
> +               if (!irq_check_poll(desc))
> +                       goto out_unlock;
> +
> +       desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
> +       kstat_incr_irqs_this_cpu(irq, desc);
> +
> +       if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data))) {
> +               desc->istate |= IRQS_PENDING;
> +               goto out_unlock;
> +       }
> +
> +       desc->istate |= IRQS_POLL_INPROGRESS;
> +
> +       handle_irq_event(desc);
> +
> +       desc->istate &= ~(IRQS_POLL_INPROGRESS);
> +
> +out_unlock:
> +       raw_spin_unlock(&desc->lock);
> +}
> +EXPORT_SYMBOL_GPL(handle_polled_irq);
> +
>  /*
>   * Called unconditionally from handle_level_irq() and only for oneshot
>   * interrupts from handle_fasteoi_irq()
> --
> 1.7.0.4

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
