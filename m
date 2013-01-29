Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3A2PtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:49:10 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:35436 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab3A2PtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:49:05 -0500
Date: Tue, 29 Jan 2013 16:48:57 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: davem@davemloft.net, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/5] net: mvmdio: allow Device Tree and platform device
 to coexist
Message-ID: <20130129164857.0ddcddf4@skate>
In-Reply-To: <1359473048-26551-5-git-send-email-florian@openwrt.org>
References: <1359473048-26551-1-git-send-email-florian@openwrt.org>
	<1359473048-26551-5-git-send-email-florian@openwrt.org>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Florian Fainelli,

On Tue, 29 Jan 2013 16:24:07 +0100, Florian Fainelli wrote:
> This patch changes the Marvell MDIO driver to be registered by using
> both Device Tree and platform device methods. The driver voluntarily
> does not use devm_ioremap() to share the same error path for Device Tree
> and non-Device Tree cases.

Not sure why you think devm_ioremap() can't be used here. Maybe I'm
missing something, but could you explain? If you use devm_ioremap(),
then basically you don't need to do anything in the error path
regarding to the I/O mapping... since it's the whole purpose of the
devm_*() stuff to automagically undo things in the error case, and in
the ->remove() code.

> -	dev->err_interrupt = irq_of_parse_and_map(pdev->dev.of_node, 0);
> +	if (pdev->dev.of_node) {
> +		dev->regs = of_iomap(pdev->dev.of_node, 0);
> +		if (!dev->regs) {
> +			dev_err(&pdev->dev, "No SMI register address given in DT\n");
> +			ret = -ENODEV;
> +			goto out_free;
> +		}
> +
> +		dev->err_interrupt = irq_of_parse_and_map(pdev->dev.of_node, 0);
> +	} else {
> +		r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +
> +		dev->regs = ioremap(r->start, resource_size(r));
> +		if (!dev->regs) {
> +			dev_err(&pdev->dev, "No SMI register address given\n");
> +			ret = -ENODEV;
> +			goto out_free;
> +		}
> +
> +		dev->err_interrupt = platform_get_irq(pdev, 0);
> +	}

I think you can do a devm_ioremap() and a platform_get_irq() in both
cases here, and therefore keep the code common between the DT case and
the !DT case.

Thanks,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
