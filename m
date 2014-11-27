Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163AbaK0QUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:20:34 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:59306
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082AbaK0QUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:20:33 -0500
X-IronPort-AV: E=Sophos;i="5.07,470,1413237600"; 
   d="scan'208";a="90779218"
Date: Thu, 27 Nov 2014 17:20:09 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Nicolas Ferre <nicolas.ferre@atmel.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: Re: [PATCH 10/11] ARM: at91: remove legacy IRQ driver and related
 code
In-Reply-To: <bbb4e9bc7102a77dfb3d407f036a4a4ed39b9da3.1417103399.git.nicolas.ferre@atmel.com>
Message-ID: <alpine.DEB.2.10.1411271713201.2534@hadrien>
References: <cover.1417103399.git.nicolas.ferre@atmel.com> <bbb4e9bc7102a77dfb3d407f036a4a4ed39b9da3.1417103399.git.nicolas.ferre@atmel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014, Nicolas Ferre wrote:

> Remove irc.c and associated header file. The related code was idendified by
> the CONFIG_OLD_IRQ_AT91 option that was removed previously. It has been spotted
> by following coccinelle semantic match:
>
> @rule1@
> expression E;
> statement S;
> @@
> (
> - if (IS_ENABLED(CONFIG_OLD_IRQ_AT91)) S
> |
> - if (IS_ENABLED(CONFIG_OLD_IRQ_AT91) && E) S
> )

I would have done:

@@
statement S1,S2;
@@

*if (IS_ENABLED(CONFIG_OLD_IRQ_AT91) && ...)
S1 else S2

There are a lot of things going on here:

1.  The * in column 0 means just search for something.  It will seem to be
-'d in the result, but having * in the specification seems a bit nicer.

2.  To be exhausitve, maybe some relevant code has an else.  When an if
pattern has an else pattern that is just a metavariable that is not used
elsewhere, it also considers the possibility that the else is empty, and
thus missing completely.  This is called an isomorphism.  The available
isomorphisms are described in the file standard.iso.

3.  xxx && ... matches 0 or more occurrences of && with xxx at top level.
So it subsumes the two patterns you provided.

4.  Another isomorphism will flip the branches of the if and negate the
condition.  Here that should match a || pattern.  On the other hand, in
your case that will not be quite good enough, because it will be an ||
pattern with !IS_ENABLED, not IS_ENABLED.  So to be really complete you
should put another rule with || rather than &&.

Thanks for trying Coccinelle!

julia

>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Julia Lawall <Julia.Lawall@lip6.fr>
> ---
> Julia,
>
> This is my very first try of coccinelle so forgive my naivety. But I would like
> to know how you would have done that.
> Note as well that the 3 little chunks concerned by the use of coccinelle would
> have perfectly been removed by hand, but I wanted to have a try ;-)
>
> Thanks, best regards.
>  Nicolas
>
>
>  arch/arm/mach-at91/Makefile          |   1 -
>  arch/arm/mach-at91/at91_aic.h        |  99 ------------
>  arch/arm/mach-at91/board-dt-rm9200.c |   1 -
>  arch/arm/mach-at91/board-dt-sam9.c   |   1 -
>  arch/arm/mach-at91/board-dt-sama5.c  |   1 -
>  arch/arm/mach-at91/generic.h         |   2 -
>  arch/arm/mach-at91/irq.c             | 296 -----------------------------------
>  arch/arm/mach-at91/pm.c              |  22 ---
>  arch/arm/mach-at91/setup.c           |   4 -
>  9 files changed, 427 deletions(-)
>  delete mode 100644 arch/arm/mach-at91/at91_aic.h
>  delete mode 100644 arch/arm/mach-at91/irq.c
>
> diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
> index b486c7760ac4..2371b8845bf5 100644
> --- a/arch/arm/mach-at91/Makefile
> +++ b/arch/arm/mach-at91/Makefile
> @@ -4,7 +4,6 @@
>
>  obj-y		:= gpio.o setup.o sysirq_mask.o
>
> -obj-$(CONFIG_OLD_IRQ_AT91)	+= irq.o
>  obj-$(CONFIG_SOC_AT91SAM9)	+= sam9_smc.o
>
>  # CPU-specific support
> diff --git a/arch/arm/mach-at91/at91_aic.h b/arch/arm/mach-at91/at91_aic.h
> deleted file mode 100644
> index eaea66197fa1..000000000000
> --- a/arch/arm/mach-at91/at91_aic.h
> +++ /dev/null
> @@ -1,99 +0,0 @@
> -/*
> - * arch/arm/mach-at91/include/mach/at91_aic.h
> - *
> - * Copyright (C) 2005 Ivan Kokshaysky
> - * Copyright (C) SAN People
> - *
> - * Advanced Interrupt Controller (AIC) - System peripherals registers.
> - * Based on AT91RM9200 datasheet revision E.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - */
> -
> -#ifndef AT91_AIC_H
> -#define AT91_AIC_H
> -
> -#ifndef __ASSEMBLY__
> -extern void __iomem *at91_aic_base;
> -
> -#define at91_aic_read(field) \
> -	__raw_readl(at91_aic_base + field)
> -
> -#define at91_aic_write(field, value) \
> -	__raw_writel(value, at91_aic_base + field)
> -#else
> -.extern at91_aic_base
> -#endif
> -
> -/* Number of irq lines managed by AIC */
> -#define NR_AIC_IRQS	32
> -#define NR_AIC5_IRQS	128
> -
> -#define AT91_AIC5_SSR		0x0			/* Source Select Register [AIC5] */
> -#define 	AT91_AIC5_INTSEL_MSK	(0x7f << 0)		/* Interrupt Line Selection Mask */
> -
> -#define AT91_AIC_IRQ_MIN_PRIORITY	0
> -#define AT91_AIC_IRQ_MAX_PRIORITY	7
> -
> -#define AT91_AIC_SMR(n)		((n) * 4)		/* Source Mode Registers 0-31 */
> -#define AT91_AIC5_SMR		0x4			/* Source Mode Register [AIC5] */
> -#define		AT91_AIC_PRIOR		(7 << 0)		/* Priority Level */
> -#define		AT91_AIC_SRCTYPE	(3 << 5)		/* Interrupt Source Type */
> -#define			AT91_AIC_SRCTYPE_LOW		(0 << 5)
> -#define			AT91_AIC_SRCTYPE_FALLING	(1 << 5)
> -#define			AT91_AIC_SRCTYPE_HIGH		(2 << 5)
> -#define			AT91_AIC_SRCTYPE_RISING		(3 << 5)
> -
> -#define AT91_AIC_SVR(n)		(0x80 + ((n) * 4))	/* Source Vector Registers 0-31 */
> -#define AT91_AIC5_SVR		0x8			/* Source Vector Register [AIC5] */
> -#define AT91_AIC_IVR		0x100			/* Interrupt Vector Register */
> -#define AT91_AIC5_IVR		0x10			/* Interrupt Vector Register [AIC5] */
> -#define AT91_AIC_FVR		0x104			/* Fast Interrupt Vector Register */
> -#define AT91_AIC5_FVR		0x14			/* Fast Interrupt Vector Register [AIC5] */
> -#define AT91_AIC_ISR		0x108			/* Interrupt Status Register */
> -#define AT91_AIC5_ISR		0x18			/* Interrupt Status Register [AIC5] */
> -#define		AT91_AIC_IRQID		(0x1f << 0)		/* Current Interrupt Identifier */
> -
> -#define AT91_AIC_IPR		0x10c			/* Interrupt Pending Register */
> -#define AT91_AIC5_IPR0		0x20			/* Interrupt Pending Register 0 [AIC5] */
> -#define AT91_AIC5_IPR1		0x24			/* Interrupt Pending Register 1 [AIC5] */
> -#define AT91_AIC5_IPR2		0x28			/* Interrupt Pending Register 2 [AIC5] */
> -#define AT91_AIC5_IPR3		0x2c			/* Interrupt Pending Register 3 [AIC5] */
> -#define AT91_AIC_IMR		0x110			/* Interrupt Mask Register */
> -#define AT91_AIC5_IMR		0x30			/* Interrupt Mask Register [AIC5] */
> -#define AT91_AIC_CISR		0x114			/* Core Interrupt Status Register */
> -#define AT91_AIC5_CISR		0x34			/* Core Interrupt Status Register [AIC5] */
> -#define		AT91_AIC_NFIQ		(1 << 0)		/* nFIQ Status */
> -#define		AT91_AIC_NIRQ		(1 << 1)		/* nIRQ Status */
> -
> -#define AT91_AIC_IECR		0x120			/* Interrupt Enable Command Register */
> -#define AT91_AIC5_IECR		0x40			/* Interrupt Enable Command Register [AIC5] */
> -#define AT91_AIC_IDCR		0x124			/* Interrupt Disable Command Register */
> -#define AT91_AIC5_IDCR		0x44			/* Interrupt Disable Command Register [AIC5] */
> -#define AT91_AIC_ICCR		0x128			/* Interrupt Clear Command Register */
> -#define AT91_AIC5_ICCR		0x48			/* Interrupt Clear Command Register [AIC5] */
> -#define AT91_AIC_ISCR		0x12c			/* Interrupt Set Command Register */
> -#define AT91_AIC5_ISCR		0x4c			/* Interrupt Set Command Register [AIC5] */
> -#define AT91_AIC_EOICR		0x130			/* End of Interrupt Command Register */
> -#define AT91_AIC5_EOICR		0x38			/* End of Interrupt Command Register [AIC5] */
> -#define AT91_AIC_SPU		0x134			/* Spurious Interrupt Vector Register */
> -#define AT91_AIC5_SPU		0x3c			/* Spurious Interrupt Vector Register [AIC5] */
> -#define AT91_AIC_DCR		0x138			/* Debug Control Register */
> -#define AT91_AIC5_DCR		0x6c			/* Debug Control Register [AIC5] */
> -#define		AT91_AIC_DCR_PROT	(1 << 0)		/* Protection Mode */
> -#define		AT91_AIC_DCR_GMSK	(1 << 1)		/* General Mask */
> -
> -#define AT91_AIC_FFER		0x140			/* Fast Forcing Enable Register [SAM9 only] */
> -#define AT91_AIC5_FFER		0x50			/* Fast Forcing Enable Register [AIC5] */
> -#define AT91_AIC_FFDR		0x144			/* Fast Forcing Disable Register [SAM9 only] */
> -#define AT91_AIC5_FFDR		0x54			/* Fast Forcing Disable Register [AIC5] */
> -#define AT91_AIC_FFSR		0x148			/* Fast Forcing Status Register [SAM9 only] */
> -#define AT91_AIC5_FFSR		0x58			/* Fast Forcing Status Register [AIC5] */
> -
> -void at91_aic_handle_irq(struct pt_regs *regs);
> -void at91_aic5_handle_irq(struct pt_regs *regs);
> -
> -#endif
> diff --git a/arch/arm/mach-at91/board-dt-rm9200.c b/arch/arm/mach-at91/board-dt-rm9200.c
> index 226563f850b8..feeb1a0f258e 100644
> --- a/arch/arm/mach-at91/board-dt-rm9200.c
> +++ b/arch/arm/mach-at91/board-dt-rm9200.c
> @@ -22,7 +22,6 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>
> -#include "at91_aic.h"
>  #include "generic.h"
>
>  static void __init at91rm9200_dt_timer_init(void)
> diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
> index d3048ccdc41f..67c1bcbf0ed9 100644
> --- a/arch/arm/mach-at91/board-dt-sam9.c
> +++ b/arch/arm/mach-at91/board-dt-sam9.c
> @@ -21,7 +21,6 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>
> -#include "at91_aic.h"
>  #include "board.h"
>  #include "generic.h"
>
> diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
> index 129e2917506b..8fb9ef5333f1 100644
> --- a/arch/arm/mach-at91/board-dt-sama5.c
> +++ b/arch/arm/mach-at91/board-dt-sama5.c
> @@ -24,7 +24,6 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>
> -#include "at91_aic.h"
>  #include "generic.h"
>
>  static void __init sama5_dt_device_init(void)
> diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
> index 1ec9b011b6a9..713d1d9e50a1 100644
> --- a/arch/arm/mach-at91/generic.h
> +++ b/arch/arm/mach-at91/generic.h
> @@ -29,8 +29,6 @@ extern void __init at91_dt_initialize(void);
>   /* Interrupts */
>  extern void __init at91_init_irq_default(void);
>  extern void __init at91_init_interrupts(unsigned int priority[]);
> -extern void __init at91_aic_init(unsigned int priority[],
> -				 unsigned int ext_irq_mask);
>  extern int  __init at91_aic_of_init(struct device_node *node,
>  				    struct device_node *parent);
>  extern int  __init at91_aic5_of_init(struct device_node *node,
> diff --git a/arch/arm/mach-at91/irq.c b/arch/arm/mach-at91/irq.c
> deleted file mode 100644
> index cdb3ec9efd2b..000000000000
> --- a/arch/arm/mach-at91/irq.c
> +++ /dev/null
> @@ -1,296 +0,0 @@
> -/*
> - * linux/arch/arm/mach-at91/irq.c
> - *
> - *  Copyright (C) 2004 SAN People
> - *  Copyright (C) 2004 ATMEL
> - *  Copyright (C) Rick Bronson
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> - */
> -
> -#include <linux/init.h>
> -#include <linux/module.h>
> -#include <linux/mm.h>
> -#include <linux/bitmap.h>
> -#include <linux/types.h>
> -#include <linux/irq.h>
> -#include <linux/of.h>
> -#include <linux/of_address.h>
> -#include <linux/of_irq.h>
> -#include <linux/irqdomain.h>
> -#include <linux/err.h>
> -#include <linux/slab.h>
> -
> -#include <mach/hardware.h>
> -#include <asm/irq.h>
> -#include <asm/setup.h>
> -
> -#include <asm/exception.h>
> -#include <asm/mach/arch.h>
> -#include <asm/mach/irq.h>
> -#include <asm/mach/map.h>
> -
> -#include "at91_aic.h"
> -
> -void __iomem *at91_aic_base;
> -static struct irq_domain *at91_aic_domain;
> -static struct device_node *at91_aic_np;
> -static unsigned int n_irqs = NR_AIC_IRQS;
> -
> -#ifdef CONFIG_PM
> -
> -static unsigned long *wakeups;
> -static unsigned long *backups;
> -
> -#define set_backup(bit) set_bit(bit, backups)
> -#define clear_backup(bit) clear_bit(bit, backups)
> -
> -static int at91_aic_pm_init(void)
> -{
> -	backups = kzalloc(BITS_TO_LONGS(n_irqs) * sizeof(*backups), GFP_KERNEL);
> -	if (!backups)
> -		return -ENOMEM;
> -
> -	wakeups = kzalloc(BITS_TO_LONGS(n_irqs) * sizeof(*backups), GFP_KERNEL);
> -	if (!wakeups) {
> -		kfree(backups);
> -		return -ENOMEM;
> -	}
> -
> -	return 0;
> -}
> -
> -static int at91_aic_set_wake(struct irq_data *d, unsigned value)
> -{
> -	if (unlikely(d->hwirq >= n_irqs))
> -		return -EINVAL;
> -
> -	if (value)
> -		set_bit(d->hwirq, wakeups);
> -	else
> -		clear_bit(d->hwirq, wakeups);
> -
> -	return 0;
> -}
> -
> -void at91_irq_suspend(void)
> -{
> -	at91_aic_write(AT91_AIC_IDCR, *backups);
> -	at91_aic_write(AT91_AIC_IECR, *wakeups);
> -}
> -
> -void at91_irq_resume(void)
> -{
> -	at91_aic_write(AT91_AIC_IDCR, *wakeups);
> -	at91_aic_write(AT91_AIC_IECR, *backups);
> -}
> -
> -#else
> -static inline int at91_aic_pm_init(void)
> -{
> -	return 0;
> -}
> -
> -#define set_backup(bit)
> -#define clear_backup(bit)
> -#define at91_aic_set_wake	NULL
> -
> -#endif /* CONFIG_PM */
> -
> -asmlinkage void __exception_irq_entry
> -at91_aic_handle_irq(struct pt_regs *regs)
> -{
> -	u32 irqnr;
> -	u32 irqstat;
> -
> -	irqnr = at91_aic_read(AT91_AIC_IVR);
> -	irqstat = at91_aic_read(AT91_AIC_ISR);
> -
> -	/*
> -	 * ISR value is 0 when there is no current interrupt or when there is
> -	 * a spurious interrupt
> -	 */
> -	if (!irqstat)
> -		at91_aic_write(AT91_AIC_EOICR, 0);
> -	else
> -		handle_IRQ(irqnr, regs);
> -}
> -
> -static void at91_aic_mask_irq(struct irq_data *d)
> -{
> -	/* Disable interrupt on AIC */
> -	at91_aic_write(AT91_AIC_IDCR, 1 << d->hwirq);
> -	/* Update ISR cache */
> -	clear_backup(d->hwirq);
> -}
> -
> -static void at91_aic_unmask_irq(struct irq_data *d)
> -{
> -	/* Enable interrupt on AIC */
> -	at91_aic_write(AT91_AIC_IECR, 1 << d->hwirq);
> -	/* Update ISR cache */
> -	set_backup(d->hwirq);
> -}
> -
> -static void at91_aic_eoi(struct irq_data *d)
> -{
> -	/*
> -	 * Mark end-of-interrupt on AIC, the controller doesn't care about
> -	 * the value written. Moreover it's a write-only register.
> -	 */
> -	at91_aic_write(AT91_AIC_EOICR, 0);
> -}
> -
> -static unsigned long *at91_extern_irq;
> -
> -u32 at91_get_extern_irq(void)
> -{
> -	if (!at91_extern_irq)
> -		return 0;
> -	return *at91_extern_irq;
> -}
> -
> -#define is_extern_irq(hwirq) test_bit(hwirq, at91_extern_irq)
> -
> -static int at91_aic_compute_srctype(struct irq_data *d, unsigned type)
> -{
> -	int srctype;
> -
> -	switch (type) {
> -	case IRQ_TYPE_LEVEL_HIGH:
> -		srctype = AT91_AIC_SRCTYPE_HIGH;
> -		break;
> -	case IRQ_TYPE_EDGE_RISING:
> -		srctype = AT91_AIC_SRCTYPE_RISING;
> -		break;
> -	case IRQ_TYPE_LEVEL_LOW:
> -		if ((d->hwirq == AT91_ID_FIQ) || is_extern_irq(d->hwirq))		/* only supported on external interrupts */
> -			srctype = AT91_AIC_SRCTYPE_LOW;
> -		else
> -			srctype = -EINVAL;
> -		break;
> -	case IRQ_TYPE_EDGE_FALLING:
> -		if ((d->hwirq == AT91_ID_FIQ) || is_extern_irq(d->hwirq))		/* only supported on external interrupts */
> -			srctype = AT91_AIC_SRCTYPE_FALLING;
> -		else
> -			srctype = -EINVAL;
> -		break;
> -	default:
> -		srctype = -EINVAL;
> -	}
> -
> -	return srctype;
> -}
> -
> -static int at91_aic_set_type(struct irq_data *d, unsigned type)
> -{
> -	unsigned int smr;
> -	int srctype;
> -
> -	srctype = at91_aic_compute_srctype(d, type);
> -	if (srctype < 0)
> -		return srctype;
> -
> -	smr = at91_aic_read(AT91_AIC_SMR(d->hwirq)) & ~AT91_AIC_SRCTYPE;
> -	at91_aic_write(AT91_AIC_SMR(d->hwirq), smr | srctype);
> -
> -	return 0;
> -}
> -
> -static struct irq_chip at91_aic_chip = {
> -	.name		= "AIC",
> -	.irq_mask	= at91_aic_mask_irq,
> -	.irq_unmask	= at91_aic_unmask_irq,
> -	.irq_set_type	= at91_aic_set_type,
> -	.irq_set_wake	= at91_aic_set_wake,
> -	.irq_eoi	= at91_aic_eoi,
> -};
> -
> -static void __init at91_aic_hw_init(unsigned int spu_vector)
> -{
> -	int i;
> -
> -	/*
> -	 * Perform 8 End Of Interrupt Command to make sure AIC
> -	 * will not Lock out nIRQ
> -	 */
> -	for (i = 0; i < 8; i++)
> -		at91_aic_write(AT91_AIC_EOICR, 0);
> -
> -	/*
> -	 * Spurious Interrupt ID in Spurious Vector Register.
> -	 * When there is no current interrupt, the IRQ Vector Register
> -	 * reads the value stored in AIC_SPU
> -	 */
> -	at91_aic_write(AT91_AIC_SPU, spu_vector);
> -
> -	/* No debugging in AIC: Debug (Protect) Control Register */
> -	at91_aic_write(AT91_AIC_DCR, 0);
> -
> -	/* Disable and clear all interrupts initially */
> -	at91_aic_write(AT91_AIC_IDCR, 0xFFFFFFFF);
> -	at91_aic_write(AT91_AIC_ICCR, 0xFFFFFFFF);
> -}
> -
> -/*
> - * Initialize the AIC interrupt controller.
> - */
> -void __init at91_aic_init(unsigned int *priority, unsigned int ext_irq_mask)
> -{
> -	unsigned int i;
> -	int irq_base;
> -
> -	at91_extern_irq = kzalloc(BITS_TO_LONGS(n_irqs)
> -				  * sizeof(*at91_extern_irq), GFP_KERNEL);
> -
> -	if (at91_aic_pm_init() || at91_extern_irq == NULL)
> -		panic("Unable to allocate bit maps\n");
> -
> -	*at91_extern_irq = ext_irq_mask;
> -
> -	at91_aic_base = ioremap(AT91_AIC, 512);
> -	if (!at91_aic_base)
> -		panic("Unable to ioremap AIC registers\n");
> -
> -	/* Add irq domain for AIC */
> -	irq_base = irq_alloc_descs(-1, 0, n_irqs, 0);
> -	if (irq_base < 0) {
> -		WARN(1, "Cannot allocate irq_descs, assuming pre-allocated\n");
> -		irq_base = 0;
> -	}
> -	at91_aic_domain = irq_domain_add_legacy(at91_aic_np, n_irqs,
> -						irq_base, 0,
> -						&irq_domain_simple_ops, NULL);
> -
> -	if (!at91_aic_domain)
> -		panic("Unable to add AIC irq domain\n");
> -
> -	irq_set_default_host(at91_aic_domain);
> -
> -	/*
> -	 * The IVR is used by macro get_irqnr_and_base to read and verify.
> -	 * The irq number is NR_AIC_IRQS when a spurious interrupt has occurred.
> -	 */
> -	for (i = 0; i < n_irqs; i++) {
> -		/* Put hardware irq number in Source Vector Register: */
> -		at91_aic_write(AT91_AIC_SVR(i), NR_IRQS_LEGACY + i);
> -		/* Active Low interrupt, with the specified priority */
> -		at91_aic_write(AT91_AIC_SMR(i), AT91_AIC_SRCTYPE_LOW | priority[i]);
> -		irq_set_chip_and_handler(NR_IRQS_LEGACY + i, &at91_aic_chip, handle_fasteoi_irq);
> -		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
> -	}
> -
> -	at91_aic_hw_init(n_irqs);
> -}
> diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
> index 4073ab7f38f3..a42360f69127 100644
> --- a/arch/arm/mach-at91/pm.c
> +++ b/arch/arm/mach-at91/pm.c
> @@ -29,7 +29,6 @@
>  #include <mach/cpu.h>
>  #include <mach/hardware.h>
>
> -#include "at91_aic.h"
>  #include "generic.h"
>  #include "pm.h"
>  #include "gpio.h"
> @@ -136,19 +135,6 @@ static int at91_pm_enter(suspend_state_t state)
>  	else
>  		at91_gpio_suspend();
>
> -	if (IS_ENABLED(CONFIG_OLD_IRQ_AT91) && at91_aic_base) {
> -		at91_irq_suspend();
> -
> -		pr_debug("AT91: PM - wake mask %08x, pm state %d\n",
> -				/* remember all the always-wake irqs */
> -				(at91_pmc_read(AT91_PMC_PCSR)
> -						| (1 << AT91_ID_FIQ)
> -						| (1 << AT91_ID_SYS)
> -						| (at91_get_extern_irq()))
> -					& at91_aic_read(AT91_AIC_IMR),
> -				state);
> -	}
> -
>  	switch (state) {
>  		/*
>  		 * Suspend-to-RAM is like STANDBY plus slow clock mode, so
> @@ -212,17 +198,9 @@ static int at91_pm_enter(suspend_state_t state)
>  			goto error;
>  	}
>
> -	if (IS_ENABLED(CONFIG_OLD_IRQ_AT91) && at91_aic_base)
> -		pr_debug("AT91: PM - wakeup %08x\n",
> -			 at91_aic_read(AT91_AIC_IPR) &
> -			 at91_aic_read(AT91_AIC_IMR));
> -
>  error:
>  	target_state = PM_SUSPEND_ON;
>
> -	if (IS_ENABLED(CONFIG_OLD_IRQ_AT91) && at91_aic_base)
> -		at91_irq_resume();
> -
>  	if (of_have_populated_dt())
>  		at91_pinctrl_gpio_resume();
>  	else
> diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
> index 98b0c1a62899..6c3013e3309b 100644
> --- a/arch/arm/mach-at91/setup.c
> +++ b/arch/arm/mach-at91/setup.c
> @@ -49,10 +49,6 @@ void __init at91_init_irq_default(void)
>
>  void __init at91_init_interrupts(unsigned int *priority)
>  {
> -	/* Initialize the AIC interrupt controller */
> -	if (IS_ENABLED(CONFIG_OLD_IRQ_AT91))
> -		at91_aic_init(priority, at91_boot_soc.extern_irq);
> -
>  	/* Enable GPIO interrupts */
>  	at91_gpio_irq_setup();
>  }
> --
> 2.1.3
>
>
