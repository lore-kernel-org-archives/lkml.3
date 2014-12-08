Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbaLHWm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:42:27 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33124 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbaLHWmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:42:25 -0500
MIME-Version: 1.0
In-Reply-To: <1417623503-30261-2-git-send-email-marc.zyngier@arm.com>
References: <1417623503-30261-1-git-send-email-marc.zyngier@arm.com>
	<1417623503-30261-2-git-send-email-marc.zyngier@arm.com>
Date: Mon, 8 Dec 2014 14:42:23 -0800
Message-ID: <CAJAp7OijMW4_VMp29K1UxtURJT-WgwwsN-O1x3Lqi-gHrAj6Sw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] genirq: Allow the irqchip state of an IRQ to be save/restored
From: Bjorn Andersson <bjorn@kryo.se>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Phong Vo <pvo@apm.com>,
        Linus Walleij <linus.walleij@linaro.org>, Tin Huynh <tnhuynh@apm.com>,
        Y Vo <yvo@apm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Toan Le <toanle@apm.com>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 8:18 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> There is a number of cases where a kernel subsystem may want to
> introspect the state of an interrupt at the irqchip level:
>
> - When a peripheral is shared between virtual machines,
>   its interrupt state becomes part of the guest's state,
>   and must be switched accordingly. KVM on arm/arm64 requires
>   this for its guest-visible timer
> - Some GPIO controllers seem to require peeking into the
>   interrupt controller they are connected to to report
>   their internal state
>
> This seem to be a pattern that is common enough for the core code
> to try and support this without too many horrible hacks. Introduce
> a pair of accessors (irq_get_irqchip_state/irq_set_irqchip_state)
> to retrieve the bits that can be of interest to another subsystem:
> pending, active, and masked.
>
> - irq_get_irqchip_state returns the state of the interrupt according
>   to a parameter set to IRQCHIP_STATE_PENDING, IRQCHIP_STATE_ACTIVE,
>   IRQCHIP_STATE_MASKED or IRQCHIP_STATE_LINE_LEVEL.
> - irq_set_irqchip_state similarly sets the state of the interrupt.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

With the addition of actually assigning err to something useful in the
setter below:

Reviewed-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Tested-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c

[..]

> +/**
> + *     irq_set_irqchip_state - set the state of a forwarded interrupt.
> + *     @irq: Interrupt line that is forwarded to a VM
> + *     @which: State to be restored (one of IRQCHIP_STATE_*)
> + *     @val: Value corresponding to @which
> + *
> + *     This call sets the internal irqchip state of an interrupt,
> + *     depending on the value of @which.
> + *
> + *     This function should be called with preemption disabled if the
> + *     interrupt controller has per-cpu registers.
> + */
> +int irq_set_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
> +                         bool val)
> +{
> +       struct irq_desc *desc;
> +       struct irq_data *data;
> +       struct irq_chip *chip;
> +       unsigned long flags;
> +       int err = -EINVAL;
> +
> +       desc = irq_get_desc_buslock(irq, &flags, 0);
> +       if (!desc)
> +               return err;
> +
> +       data = irq_desc_get_irq_data(desc);
> +
> +       do {
> +               chip = irq_data_get_irq_chip(data);
> +               if (chip->irq_set_irqchip_state)
> +                       break;
> +#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
> +               data = data->parent_data;
> +#else
> +               data = NULL;
> +#endif
> +       } while (data);
> +
> +       if (data)
> +               chip->irq_set_irqchip_state(data, which, val);

err =

> +
> +       irq_put_desc_busunlock(desc, flags);
> +       return err;
> +}

Regards,
Bjorn
