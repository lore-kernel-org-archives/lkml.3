Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab3IQUAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 16:00:07 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42903 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab3IQUAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 16:00:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130917183628.534494408@linutronix.de>
References: <20130917082838.218329307@infradead.org>
	<20130917182350.449685712@linutronix.de>
	<20130917183628.534494408@linutronix.de>
Date: Tue, 17 Sep 2013 22:00:03 +0200
X-Google-Sender-Auth: Su7KtMqx_BI8GYOrWQqxKIUhpXg
Message-ID: <CAMuHMdWgrQf+ULDrZyY5R+vT3GtiWEgpsWxmfk0b5pivN7wBmg@mail.gmail.com>
Subject: Re: [patch 1/6] hardirq: Make hardirq bits generic
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Linux-Arch <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 8:53 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> --- linux-2.6.orig/arch/m68k/include/asm/hardirq.h
> +++ linux-2.6/arch/m68k/include/asm/hardirq.h
> @@ -5,17 +5,6 @@
>  #include <linux/cache.h>
>  #include <asm/irq.h>
>
> -#define HARDIRQ_BITS   8

> --- linux-2.6.orig/include/linux/preempt_mask.h
> +++ linux-2.6/include/linux/preempt_mask.h
> @@ -11,36 +11,22 @@
>   * - bits 0-7 are the preemption count (max preemption depth: 256)
>   * - bits 8-15 are the softirq count (max # of softirqs: 256)
>   *
> - * The hardirq count can in theory reach the same as NR_IRQS.
> - * In reality, the number of nested IRQS is limited to the stack
> - * size as well. For archs with over 1000 IRQS it is not practical
> - * to expect that they will all nest. We give a max of 10 bits for
> - * hardirq nesting. An arch may choose to give less than 10 bits.
> - * m68k expects it to be 8.

m68k needs some changes in arch/m68k/kernel/entry.S, cfr. this check
in arch/m68k/kernel/ints.c:

        /* assembly irq entry code relies on this... */
        if (HARDIRQ_MASK != 0x00ff0000) {
                extern void hardirq_mask_is_broken(void);
                hardirq_mask_is_broken();
        }

Haven't looked into the details yet...

> - * - bits 16-25 are the hardirq count (max # of nested hardirqs: 1024)
> - * - bit 26 is the NMI_MASK
> - * - bit 27 is the PREEMPT_ACTIVE flag
> + * The hardirq count could in theory be the same as the number of
> + * interrupts in the system, but we run all interrupt handlers with
> + * interrupts disabled, so we cannot have nesting interrupts. Though
> + * there are a few palaeontologic drivers which reenable interrupts in
> + * the handler, so we need more than one bit here.
>   *
>   * PREEMPT_MASK: 0x000000ff
>   * SOFTIRQ_MASK: 0x0000ff00
> - * HARDIRQ_MASK: 0x03ff0000
> - *     NMI_MASK: 0x04000000
> + * HARDIRQ_MASK: 0x000f0000
> + *     NMI_MASK: 0x00100000
>   */
>  #define PREEMPT_BITS   8
>  #define SOFTIRQ_BITS   8
> +#define HARDIRQ_BITS   4
>  #define NMI_BITS       1

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
