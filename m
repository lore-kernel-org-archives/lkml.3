Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab3EBSxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:53:43 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:41015 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760889Ab3EBSxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:53:41 -0400
Date: Thu, 2 May 2013 12:53:22 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
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
Message-ID: <20130502185322.GA29333@obsidianresearch.com>
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 08:25:04PM +0200, Sebastian Hesselbarth wrote:
> +
> +static void __iomem *orion_irq_base[ORION_MAX_IRQREG];
> +static unsigned int orion_irq_regs;
> +static struct irq_domain *orion_irq_domain;
> +
> +asmlinkage void __exception_irq_entry orion_handle_irq(struct
> pt_regs *regs)

This can be static?

> +static int __init orion_of_init(struct device_node *np,
> +				struct device_node *parent)
> +{
> +	int n;
> +
> +	for (n = 0; n < ORION_MAX_IRQREG; n++) {
> +		orion_irq_base[n] = of_iomap(np, n);

Is it possible to also reserve the resources for these registers at
this point in the boot sequence?

> +static struct of_device_id orion_irq_dt_ids[] __initconst = {
> +	{ .compatible = "marvell,orion-mpic", .data = orion_of_init },
> +	{ }

Is there a strong reason to change the compatible string? Looks to me
like either the new driver or the old driver will bind depending on
what is in the machine description. No need for a new string?

> +};
> +
> +void __init orion_init_irq(void)
> +{
> +	of_irq_init(orion_irq_dt_ids);
> +}

Shouldn't this use the new IRQCHIP_DECLARE mechanism?

> diff --git a/include/linux/irqchip/orion.h b/include/linux/irqchip/orion.h

> +extern void orion_init_irq(void);

.. which lets this go away, use the generic irqchip_init instead of
orion_init_irq.

Regards,
Jason
