Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab3EWKTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:19:00 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55831 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719Ab3EWKS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:18:58 -0400
Date: Thu, 23 May 2013 11:18:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: at91: move at91 aic driver to drivers/irqchip
Message-ID: <20130523101825.GL18614@n2100.arm.linux.org.uk>
References: <1369299909-10078-1-git-send-email-b.brezillon@overkiz.com> <1369299909-10078-2-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369299909-10078-2-git-send-email-b.brezillon@overkiz.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 11:05:07AM +0200, Boris BREZILLON wrote:
> Move arch/arm/mach-at91/irq.c to drivers/irqchip/irq-at91.c.
> Move arch/arm/mach-at91/at91_aic.h to
> arch/arm/mach-at91/include/mach/at91_aic.h to avoid ugly reference
> to header file :
> #include "../../arch/arm/mach-at91/at91_aic.h"

The right way to do this is to move the definitions which should only
be used by arch/arm/mach-at91/irq.c to that file or a header file along
side that file, and find a place in include/linux for the remainder.

I notice arch/arm/mach-at91/pm.c makes use of some of the register
definitions:

        at91_irq_suspend();

        pr_debug("AT91: PM - wake mask %08x, pm state %d\n",
                        /* remember all the always-wake irqs */
                        (at91_pmc_read(AT91_PMC_PCSR)
                                        | (1 << AT91_ID_FIQ)
                                        | (1 << AT91_ID_SYS)
                                        | (at91_extern_irq))
                                & at91_aic_read(AT91_AIC_IMR),
                        state);

at91_irq_suspend() is in arch/arm/mach-at91/irq.c already, so there's no
reason that fragment can't be moved there.

That leaves: at91_aic_handle_irq, at91_aic5_handle_irq, NR_AIC_IRQS and
NR_AIC5_IRQS, which if you did patch 3 first, would leave you with just
the NR_.*_IRQS definitions to find a home for.
