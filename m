Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646Ab3EBTFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:05:45 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:44553 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761236Ab3EBTFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:05:44 -0400
Message-ID: <5182B902.7040908@gmail.com>
Date: Thu, 02 May 2013 21:05:38 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irqchip: add support for Marvell Orion SoCs
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130502185322.GA29333@obsidianresearch.com>
In-Reply-To: <20130502185322.GA29333@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/13 20:53, Jason Gunthorpe wrote:
> On Thu, May 02, 2013 at 08:25:04PM +0200, Sebastian Hesselbarth wrote:
>> +
>> +static void __iomem *orion_irq_base[ORION_MAX_IRQREG];
>> +static unsigned int orion_irq_regs;
>> +static struct irq_domain *orion_irq_domain;
>> +
>> +asmlinkage void __exception_irq_entry orion_handle_irq(struct
>> pt_regs *regs)
>
> This can be static?

True, corresponds with the left-over #include in linux/irqchip/orion.h.

>> +static int __init orion_of_init(struct device_node *np,
>> +				struct device_node *parent)
>> +{
>> +	int n;
>> +
>> +	for (n = 0; n < ORION_MAX_IRQREG; n++) {
>> +		orion_irq_base[n] = of_iomap(np, n);
>
> Is it possible to also reserve the resources for these registers at
> this point in the boot sequence?

I see what I can do.

>> +static struct of_device_id orion_irq_dt_ids[] __initconst = {
>> +	{ .compatible = "marvell,orion-mpic", .data = orion_of_init },
>> +	{ }
>
> Is there a strong reason to change the compatible string? Looks to me
> like either the new driver or the old driver will bind depending on
> what is in the machine description. No need for a new string?

The reason for a new compatible string is, that we will also need an
secondary irq controller for bridge irqs. That could be called
marvell,orion-spic. Dove is again a little bit different than the
others and this will require timer and especially rtc not to share
bridge irqs here. RTC irq is located in PMU regs on Dove instead of
bridge regs.

But I don't have a strong opinion here and we can also reuse
marvell,orion-intc for the irqchip driver.

>> +};
>> +
>> +void __init orion_init_irq(void)
>> +{
>> +	of_irq_init(orion_irq_dt_ids);
>> +}
>
> Shouldn't this use the new IRQCHIP_DECLARE mechanism?

I didn't follow irqchip discussion lately, but will catch up.

>
>> diff --git a/include/linux/irqchip/orion.h b/include/linux/irqchip/orion.h
>
>> +extern void orion_init_irq(void);
>
> .. which lets this go away, use the generic irqchip_init instead of
> orion_init_irq.

Same as above.

Thanks for the review,
   Sebastian

