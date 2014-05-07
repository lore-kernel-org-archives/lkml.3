Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858AbaEGMwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:52:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58495 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755585AbaEGMwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:52:43 -0400
Date: Wed, 7 May 2014 14:52:39 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 17/20] phy: Add support for USB cluster on the Armada
 375 SoC
Message-ID: <20140507145239.433acdf4@free-electrons.com>
In-Reply-To: <20140506135427.GG6503@lunn.ch>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
	<1399335255-589-18-git-send-email-gregory.clement@free-electrons.com>
	<20140506135427.GG6503@lunn.ch>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew Lunn,

On Tue, 6 May 2014 15:54:27 +0200, Andrew Lunn wrote:

> > +enum {
> > +	PHY_USB2 = 0,
> > +	PHY_USB3 = 1,
> > +};
> > +
> > +struct armada375_cluster_phy {
> > +	struct phy *phy;
> > +	void __iomem *reg;
> > +	bool enable;
> > +	bool use_usb3;
> 
> Hi Gregory
> 
> nit: How about using the enum you just defined?

Nope, I don't think it's a good idea, because they mean different
things. The enum is used to index the arrays of two PHYs: PHY_USB2 is
the first one, PHY_USB3 is the second one.

On the other hand, the 'use_usb3' field indicates in which mode is a
particular PHY. So it could apply on either of the PHYs, and is
therefore not related to the index of the PHYs in the array.


> > +	usb_cluster_base = of_iomap(np, 0);
> 
> devm_ API?
> 
> Check the return value for an error?

Indeed, I'll use devm_ioremap_resource() here.

> > +	BUG_ON(!usb_cluster_base);
> > +
> > +	for (i = 0; i < NB_PHY; i++) {
> > +		phy = devm_phy_create(dev, &armada375_usb_phy_ops, NULL);
> > +		if (IS_ERR(phy))
> > +			dev_err(dev, "failed to create PHY n%d\n", i);
> > +
> > +		usb_cluster_phy[i].phy = phy;
> > +		usb_cluster_phy[i].reg = usb_cluster_base;
> > +		usb_cluster_phy[i].enable = false;
> > +		phy_set_drvdata(phy, &usb_cluster_phy[i]);
> > +	}
> > +
> > +	usb_cluster_phy[PHY_USB2].use_usb3 = false;
> > +	usb_cluster_phy[PHY_USB3].use_usb3 = true;
> > +
> > +	/*
> > +	 * We can't use the first usb2 unit and usb3 at the same time
> > +	 * to manage a USB2 device, so let's disable usb2 if usb3 is
> > +	 * slelected. In this case USB2 device will be managed by the
> 
> selected

Fixed.

Thanks,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
