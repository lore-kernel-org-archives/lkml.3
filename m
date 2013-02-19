Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab3BSKih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:38:37 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:48251 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518Ab3BSKie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:38:34 -0500
MIME-Version: 1.0
In-Reply-To: <87d2vxf71h.wl%kuninori.morimoto.gx@renesas.com>
References: <20130218142834.28739.39417.sendpatchset@w520>
	<87d2vxf71h.wl%kuninori.morimoto.gx@renesas.com>
Date: Tue, 19 Feb 2013 19:38:33 +0900
Message-ID: <CANqRtoQYLPe5c7PYnMonz852NED6AeVB9-6kweR=M51TDPb-iw@mail.gmail.com>
Subject: Re: [PATCH] irqchip: Renesas INTC External IRQ pin driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        benh@kernel.crashing.org, grant.likely@secretlab.ca,
        horms@verge.net.au, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Morimoto-san,

On Tue, Feb 19, 2013 at 10:04 AM, Kuninori Morimoto
<kuninori.morimoto.gx@renesas.com> wrote:
>
> Hi Magnus
>
> Thank you for this patch.
> Small comment from me :)

Sure, thanks!

>> +struct intc_irqpin_priv {
>> +     struct intc_irqpin_iomem iomem[INTC_IRQPIN_REG_NR];
>> +     struct intc_irqpin_irq irq[INTC_IRQPIN_MAX];
>> +     struct renesas_intc_irqpin_config config;
>> +     unsigned int number_of_irqs;
>> +     struct platform_device *pdev;
>> +     struct irq_chip irq_chip;
>> +     struct irq_domain *irq_domain;
>> +};
>
> (snip)
>
>> +static DEFINE_RAW_SPINLOCK(intc_irqpin_lock); /* only used by slow path */
>> +
>> +static void intc_irqpin_read_modify_write(struct intc_irqpin_priv *p,
>> +                                       int reg, int shift,
>> +                                       int width, int value)
>> +{
>> +     unsigned long flags;
>> +     unsigned long tmp;
>> +
>> +     raw_spin_lock_irqsave(&intc_irqpin_lock, flags);
>> +
>> +     tmp = intc_irqpin_read(p, reg);
>> +     tmp &= ~(((1 << width) - 1) << shift);
>> +     tmp |= value << shift;
>> +     intc_irqpin_write(p, reg, tmp);
>> +
>> +     raw_spin_unlock_irqrestore(&intc_irqpin_lock, flags);
>> +}
>
> It is possible to include this spin lock into priv ?
> This local static spin lock seems not wrong, but looks strange ?

Please see this comment (that you snipped out above):

+/* INTC external IRQ PIN hardware register access:
+ *
+ * SENSE is read-write 32-bit with 2-bits or 4-bits per IRQ (*)
+ * PRIO is read-write 32-bit with 4-bits per IRQ (**)
+ * SOURCE is read-only 32-bit or 8-bit with 1-bit per IRQ (***)
+ * MASK is write-only 32-bit or 8-bit with 1-bit per IRQ (***)
+ * CLEAR is write-only 32-bit or 8-bit with 1-bit per IRQ (***)
+ *
+ * (*) May be accessed by more than one driver instance - lock needed
+ * (**) Read-modify-write access by one driver instance - lock needed
+ * (***) Accessed by one driver instance only - no locking needed
+ */

Basically, the lock is used for SENSE and PRIO. SENSE may be shared
between multiple driver instances, so a lock in ->priv won't be
enough. PRIO may be locked using ->priv but both SENSE and PRIV are in
the slow path so I decided to handle both using a global lock.

>> +static int intc_irqpin_probe(struct platform_device *pdev)
>> +{
>> +     struct renesas_intc_irqpin_config *pdata = pdev->dev.platform_data;
>> +     struct intc_irqpin_priv *p;
>> +     struct intc_irqpin_iomem *i;
>> +     struct resource *io[INTC_IRQPIN_REG_NR];
>> +     struct resource *irq;
>> +     struct irq_chip *irq_chip;
>> +     void (*enable_fn)(struct irq_data *d);
>> +     void (*disable_fn)(struct irq_data *d);
>> +     const char *name = dev_name(&pdev->dev);
>> +     int ret;
>> +     int k;
>> +
>> +     p = kzalloc(sizeof(*p), GFP_KERNEL);
>
> can you use devm_kzalloc() ?
> devm_ioremap_nocache() or devm_request_and_ioremap()
> Can you use devm_request_irq()
> if you used devm_xxxx, you can remove kfree() / free_irq() / iounmap() here

I somehow knew that this would come up. Will give devm a go in V2 -
unless someone tells me such a change is going to make the driver more
painful to back port to LTSI-3.4.

>> --- /dev/null
>> +++ work/include/linux/platform_data/irq-renesas-intc-irqpin.h        2013-02-18 18:28:24.000000000 +0900
>> @@ -0,0 +1,10 @@
>> +#ifndef __IRQ_RENESAS_INTC_IRQPIN_H__
>> +#define __IRQ_RENESAS_INTC_IRQPIN_H__
>
> GPL license signage ?

Let me check how other files in include/linux/platform_data/ handles
this. I will follow the majority.

Thanks,

/ magnus
