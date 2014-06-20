Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934798AbaFTIFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:05:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:57344 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933971AbaFTIFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:05:20 -0400
Date: Fri, 20 Jun 2014 10:05:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [patch 13/13] irqchip: spear_shirq: Simplify register access
 code
In-Reply-To: <CAOh2x==7awAgx0idqjauYJZk9-aoBEvDWneMksbyYH38c6+OSg@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1406201000441.5170@nanos>
References: <20140619212606.431750473@linutronix.de> <20140619212713.923306179@linutronix.de> <CAOh2x==7awAgx0idqjauYJZk9-aoBEvDWneMksbyYH38c6+OSg@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014, Viresh Kumar wrote:
> On Fri, Jun 20, 2014 at 3:04 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Index: linux/drivers/irqchip/spear-shirq.c
> > -struct shirq_regs {
> > -       u32 enb_reg;
> > -       u32 reset_to_enb;
> 
> I don't see something similar to 'reset_to_enb' is added again.
> AFAICT, this field is being used by two blocks:
> 
> spear300_shirq_ras1: writes 0 to this. i.e. we need to write 0 to
> mask the interrupt
> 
> and
> 
> spear320_shirq_ras3: writes 1 to this. i.e. we need to write 1 to
> mask the interrupt.

AGAIN: spear320_shirq_ras3 is never instantiated as a chained irq. So
the chip for these interrupts is never set.

And if it ever is, you need a separate irq chip for it and not some
conditional hackery.

> And so the new code you have added breaks it for SPEAr300 ?

+static void shirq_irq_mask(struct irq_data *d)
+{
+	struct spear_shirq *shirq = irq_data_get_irq_chip_data(d);
+	u32 val, shift = d->irq - shirq->virq_base + shirq->offset;
+	u32 __iomem *reg = shirq->base + shirq->regs.enb_reg;
+
+	raw_spin_lock(&shirq_lock);
+	val = readl(reg) & ~(0x1 << shift);
+	writel(val, reg);
+	raw_spin_unlock(&shirq_lock);
+}

That's the mask function for 300 and it clears the bit, right?

Thanks,

	tglx
