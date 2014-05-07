Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbaEGJkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:40:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57619 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932085AbaEGJkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:40:09 -0400
Date: Wed, 7 May 2014 11:40:06 +0200
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
Subject: Re: [PATCH v3 02/20] usb: ehci-orion: Add the optional PHY support
Message-ID: <20140507114006.466347a0@free-electrons.com>
In-Reply-To: <20140506133341.GE6503@lunn.ch>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
	<1399335255-589-3-git-send-email-gregory.clement@free-electrons.com>
	<20140506133341.GE6503@lunn.ch>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew Lunn,

On Tue, 6 May 2014 15:33:41 +0200, Andrew Lunn wrote:

> > +	priv->phy = devm_phy_get(&pdev->dev, "usb");
> > +	if (!IS_ERR(priv->phy)) {
> > +		err = phy_init(priv->phy);
> > +		if (err)
> > +			goto err2;
> > +
> > +		err = phy_power_on(priv->phy);
> > +		if (err)
> > +			goto err3;
> > +	}
> 
> Hi Gregory
> 
> What about EPROBE_DEFERRED?

In v4 (to be submitted soon), I've changed this to:

	priv->phy = devm_phy_optional_get(&pdev->dev, "usb");
	if (IS_ERR(priv->phy)) {
		err = PTR_ERR(priv->phy);
		goto err_phy_get;
	} else {
		err = phy_init(priv->phy);
		if (err)
			goto err_phy_init;

		err = phy_power_on(priv->phy);
		if (err)
			goto err_phy_power_on;
	}

Thanks to devm_phy_optional_get(), the fact of not having a PHY in the
DT is not considered an error. So on any error from
devm_phy_optional_get() (including -EPROBE_DEFER), we simply bail out.
Does this looks good?

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
