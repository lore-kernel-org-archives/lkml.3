Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbaGOJvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:51:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:46854 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758039AbaGOJvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:51:07 -0400
Date: Tue, 15 Jul 2014 11:51:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ley Foon Tan <lftan@altera.com>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH v2 12/29] nios2: Interrupt handling
In-Reply-To: <1405413956-2772-13-git-send-email-lftan@altera.com>
Message-ID: <alpine.DEB.2.10.1407151147540.24854@nanos>
References: <1405413956-2772-1-git-send-email-lftan@altera.com> <1405413956-2772-13-git-send-email-lftan@altera.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, Ley Foon Tan wrote:
> +#ifndef _ASM_NIOS2_IRQ_H
> +#define _ASM_NIOS2_IRQ_H
> +
> +#define NIOS2_CPU_NR_IRQS	32
> +/* Reserve 32 additional interrupts for GPIO IRQs */
> +#define NR_IRQS			(NIOS2_CPU_NR_IRQS + 32)

Please use sparse irqs. Hardcoded limits tend to work out really bad.

> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/of.h>
> +
> +asmlinkage void do_IRQ(int hwirq, struct pt_regs *regs)
> +{
> +	struct pt_regs *oldregs = set_irq_regs(regs);
> +	int irq;
> +
> +	irq_enter();
> +	irq = irq_find_mapping(NULL, hwirq);
> +	generic_handle_irq(irq);
> +	irq_exit();
> +
> +	set_irq_regs(oldregs);
> +}
> +
> +static void chip_unmask(struct irq_data *d)
> +{
> +	u32 ien;
> +	ien = RDCTL(CTL_IENABLE);
> +	ien |= (1 << d->hwirq);
> +	WRCTL(CTL_IENABLE, ien);

So this is UP only, right?

Also why don't you cache the register content so spare the extra read
from the hardware?

Thanks,

	tglx
