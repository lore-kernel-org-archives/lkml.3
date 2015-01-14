Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbbANODj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:03:39 -0500
Received: from down.free-electrons.com ([37.187.137.238]:44132 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753387AbbANODg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:03:36 -0500
Date: Wed, 14 Jan 2015 15:03:32 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Rob Herring" <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] irqchip: add dumb demultiplexer implementation
Message-ID: <20150114150332.09fecbea@bbrezillon>
In-Reply-To: <54B670EA.1010800@atmel.com>
References: <1421174781-4340-1-git-send-email-boris.brezillon@free-electrons.com>
	<1421174781-4340-2-git-send-email-boris.brezillon@free-electrons.com>
	<54B670EA.1010800@atmel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015 14:36:42 +0100
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> Le 13/01/2015 19:46, Boris Brezillon a écrit :
> > Some interrupt controllers are multiplexing several peripheral IRQs on
> > a single interrupt line.
> > While this is not a problem for most IRQs (as long as all peripherals
> > request the interrupt with IRQF_SHARED flag set), multiplexing timers and
> > other type of peripherals will generate a WARNING (mixing IRQF_NO_SUSPEND
> > and !IRQF_NO_SUSPEND is prohibited).
> > 
> > Create a dumb irq demultiplexer which simply forwards interrupts to all
> > peripherals (exactly what's happening with IRQ_SHARED) but keep a unique
> > irq number for each peripheral, thus preventing the IRQF_NO_SUSPEND
> > and !IRQF_NO_SUSPEND mix on a given interrupt.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > ---
> >  drivers/irqchip/Kconfig          |   4 ++
> >  drivers/irqchip/Makefile         |   1 +
> >  drivers/irqchip/irq-dumb-demux.c |  70 ++++++++++++++++++++
> >  include/linux/irq.h              |  49 ++++++++++++++
> >  include/linux/irqdomain.h        |   1 +
> >  kernel/irq/Kconfig               |   5 ++
> >  kernel/irq/Makefile              |   1 +
> >  kernel/irq/chip.c                |  41 ++++++++++++
> >  kernel/irq/dumb-demux-chip.c     | 140 +++++++++++++++++++++++++++++++++++++++
> >  kernel/irq/handle.c              |  31 ++++++++-
> >  kernel/irq/internals.h           |   3 +
> >  11 files changed, 344 insertions(+), 2 deletions(-)
> >  create mode 100644 drivers/irqchip/irq-dumb-demux.c
> >  create mode 100644 kernel/irq/dumb-demux-chip.c
> > 
> > diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> > index cc79d2a..8a9df88 100644
> > --- a/drivers/irqchip/Kconfig
> > +++ b/drivers/irqchip/Kconfig
> > @@ -70,6 +70,10 @@ config BRCMSTB_L2_IRQ
> >  	select GENERIC_IRQ_CHIP
> >  	select IRQ_DOMAIN
> >  
> > +config DUMB_DEMUX_IRQ
> > +	bool
> > +	select DUMB_IRQ_DEMUX_CHIP
> > +
> >  config DW_APB_ICTL
> >  	bool
> >  	select GENERIC_IRQ_CHIP
> > diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
> > index 9516a32..77f3c51 100644
> > --- a/drivers/irqchip/Makefile
> > +++ b/drivers/irqchip/Makefile
> > @@ -8,6 +8,7 @@ obj-$(CONFIG_ARCH_MVEBU)		+= irq-armada-370-xp.o
> >  obj-$(CONFIG_ARCH_MXS)			+= irq-mxs.o
> >  obj-$(CONFIG_ARCH_S3C24XX)		+= irq-s3c24xx.o
> >  obj-$(CONFIG_DW_APB_ICTL)		+= irq-dw-apb-ictl.o
> > +obj-$(CONFIG_DUMB_DEMUX_IRQ)		+= irq-dumb-demux.o
> >  obj-$(CONFIG_METAG)			+= irq-metag-ext.o
> >  obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
> >  obj-$(CONFIG_ARCH_MOXART)		+= irq-moxart.o
> > diff --git a/drivers/irqchip/irq-dumb-demux.c b/drivers/irqchip/irq-dumb-demux.c
> > new file mode 100644
> > index 0000000..dfa05ce
> > --- /dev/null
> > +++ b/drivers/irqchip/irq-dumb-demux.c
> > @@ -0,0 +1,70 @@
> 
> Maybe add a little file header here. It's always better.

Sure, I just forgot it.

> > +#ifdef CONFIG_DUMB_IRQ_DEMUX_CHIP
> > +/**
> > + *	handle_dumb_demux_irq - Dumb demuxer irq handle function.
> > + *	@irq:	the interrupt number
> > + *	@desc:	the interrupt description structure for this irq
> > + *
> > + *	Dumb demux interrupts are sent from a demultiplexing interrupt handler
> > + *	which is not able to decide which child interrupt interrupt handler
> 
> typo: "interrupt interrupt"

I'll fix that.

> 
> > + *	should be called.
> > + *
> > + *	Note: The caller is expected to handle the ack, clear, mask and
> > + *	unmask issues if necessary.
> > + */

[...]

> > +
> >  /*
> >   * Called unconditionally from handle_level_irq() and only for oneshot
> >   * interrupts from handle_fasteoi_irq()
> > diff --git a/kernel/irq/dumb-demux-chip.c b/kernel/irq/dumb-demux-chip.c
> > new file mode 100644
> > index 0000000..8e2de1d
> > --- /dev/null
> > +++ b/kernel/irq/dumb-demux-chip.c
> > @@ -0,0 +1,140 @@
> > +/*
> > + * Library implementing common dumb irq demux chip functions
> > + *
> > + * Copyright (C) 2015, Boris Brezillon
> 
> License here, please.

Yep, I'll add it.

> 
> > + */
> > +#include <linux/err.h>
> > +#include <linux/io.h>
> > +#include <linux/irq.h>
> > +#include <linux/slab.h>
> > +#include <linux/export.h>
> > +#include <linux/irq.h>
> > +#include <linux/irqdomain.h>
> > +#include <linux/irqchip/chained_irq.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/kernel_stat.h>
> > +#include <linux/syscore_ops.h>
> > +
> > +#include "internals.h"
> > +
> > +static void irq_dumb_demux_mask(struct irq_data *d)
> > +{
> > +	struct irq_chip_dumb_demux *demux = irq_data_get_irq_chip_data(d);
> > +
> > +	clear_bit(d->hwirq, &demux->unmasked);
> > +
> > +	if (!demux->unmasked)
> > +		disable_irq_nosync(demux->src_irq);
> > +}
> > +
> > +static void irq_dumb_demux_unmask(struct irq_data *d)
> > +{
> > +	struct irq_chip_dumb_demux *demux = irq_data_get_irq_chip_data(d);
> > +	bool enable_src_irq = !demux->unmasked;
> 
> Why this additional "bool" unlike the other function above?

Because set_bit will modify the unmasked status and we must check if it
is equal to 0 (in other terms, all irqs are masked) before modifying it
in order to know whether we should enable the src irq or not.

> 
> > +
> > +	set_bit(d->hwirq, &demux->unmasked);
> > +
> > +	if (enable_src_irq)
> > +		enable_irq(demux->src_irq);
> > +}
> > +

[...]

> > +
> > +/**
> > + * irq_alloc_dumb_demux_chip - Allocate a dumb demux chip
> > + * @src_irq:		irq feeding the dumb demux chip
> > + * @dd_flags:		irq_dumb_demux_flags flags
> > + * @valid_irqs:		Bitmask representing valid irqs
> > + * @clr_flags:		irq_flags to clear when mapping an interrupt
> > + * @set_flags:		irq_flags to set when mapping an interrupt
> 
> Nit. not same order as the function parameters...

I'll fix that.

Thanks,

Boris
-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
