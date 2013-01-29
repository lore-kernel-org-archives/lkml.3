Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab3A2Ulx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 15:41:53 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49648 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3A2Ulu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 15:41:50 -0500
From: Florian Fainelli <florian@openwrt.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 4/5] net: mvmdio: allow Device Tree and platform device to coexist
Date: Tue, 29 Jan 2013 21:41:45 +0100
User-Agent: KMail/1.13.7 (Linux/3.7-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: davem@davemloft.net,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, linux-doc@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, netdev@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org,
        Lennert Buytenhek <buytenh@wantstofly.org>
References: <1359473048-26551-1-git-send-email-florian@openwrt.org> <1359473048-26551-5-git-send-email-florian@openwrt.org> <20130129175912.GE25646@obsidianresearch.com>
In-Reply-To: <20130129175912.GE25646@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301292141.45931.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 29 janvier 2013 18:59:12, Jason Gunthorpe a écrit :
> On Tue, Jan 29, 2013 at 04:24:07PM +0100, Florian Fainelli wrote:
> > -	dev->err_interrupt = irq_of_parse_and_map(pdev->dev.of_node, 0);
> > +	if (pdev->dev.of_node) {
> > +		dev->regs = of_iomap(pdev->dev.of_node, 0);
> > +		if (!dev->regs) {
> > +			dev_err(&pdev->dev, "No SMI register address given in 
DT\n");
> > +			ret = -ENODEV;
> > +			goto out_free;
> > +		}
> > +
> > +		dev->err_interrupt = irq_of_parse_and_map(pdev->dev.of_node, 0);
> > +	} else {
> > +		r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +
> > +		dev->regs = ioremap(r->start, resource_size(r));
> > +		if (!dev->regs) {
> > +			dev_err(&pdev->dev, "No SMI register address given\n");
> > +			ret = -ENODEV;
> > +			goto out_free;
> > +		}
> > +
> > +		dev->err_interrupt = platform_get_irq(pdev, 0);
> > +	}
> 
> Why do you have these different paths for OF and platform? AFAIK these
> days when a OF device is automatically converted into a platform
> device all the struct resources are created too, so you can't you just
> use platform_get_resource and devm_request_and_ioremap for both flows?
> 
> Ditto for the interrupt - platform_get_irq should work in both cases?

There was no particular reason and I updated the patchset to do that precisely 
in version 2.
-- 
Florian
