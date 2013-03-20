Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab3CTMnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:43:15 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3905 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab3CTMnN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:43:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Mar 2013 05:35:59 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Wed, 20 Mar 2013 18:13:07 +0530
Subject: RE: [PATCH 7/7] usb: phy: registering tegra USB PHY as platform
 driver
Thread-Topic: [PATCH 7/7] usb: phy: registering tegra USB PHY as platform
 driver
Thread-Index: Ac4k32CnMe31Pk9HQvOzLjUBLWzd+AAhqUgA
Message-ID: <D958900912E20642BCBC71664EFECE3E6E5092FFFA@BGMAIL02.nvidia.com>
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com>
 <1363609781-4045-8-git-send-email-vbyravarasu@nvidia.com>
 <5148C8B6.90303@wwwdotorg.org>
In-Reply-To: <5148C8B6.90303@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> Sent: Wednesday, March 20, 2013 1:51 AM
> To: Venu Byravarasu
> Cc: gregkh@linuxfoundation.org; stern@rowland.harvard.edu;
> balbi@ti.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-tegra@vger.kernel.org; devicetree-discuss@lists.ozlabs.org
> Subject: Re: [PATCH 7/7] usb: phy: registering tegra USB PHY as platform
> driver
> 
> On 03/18/2013 06:29 AM, Venu Byravarasu wrote:
> > Registered tegra USB PHY as a separate platform driver.
> >
> > diff --git a/drivers/usb/phy/tegra_usb_phy.c
> b/drivers/usb/phy/tegra_usb_phy.c
> 
> >  static void tegra_usb_phy_close(struct usb_phy *x)
> >  {
> >  	if (phy->is_ulpi_phy)
> >  		clk_put(phy->clk);
> 
> phy->clk is obtained using devm_clk_get(). This typically means you
> never need to clk_put() it, and if for some reason you really have to,
> you should use devm_clk_put() instead of plain clk_put().

Agree, will remove clk_put.
 
> 
> > @@ -774,23 +667,53 @@ struct tegra_usb_phy
> *tegra_usb_phy_open(struct device *dev, int instance,
> 
> > +		err = gpio_request(phy->reset_gpio, "ulpi_phy_reset_b");
> 
> I think you can use devm_gpio_request() here to simplify the error-handling.

Sure, will do. 

> 
> I wonder why in the ULPI case, all the code is inline here, whereas in
> the UTMI case, this simply calls a function. Wouldn't it be more
> consistent to have the following code here:
> 
> 	if (phy->is_ulpi_phy)
> 		err = ulpi_open();
> 	else
> 		err = utmip_open();
> 	if (err)
> 		goto fail;

Sure, will take care of this in next patch. 

> 
> > +static int tegra_usb_phy_probe(struct platform_device *pdev)
> 
> Hmmm. Note that in order to make deferred probe work correctly, all the
> gpio_request(), clk_get(), etc. calls that acquire resources from other
> drivers must happen here in probe() and not in tegra_usb_phy_open().
 
In present code tegra_usb_phy_open() is indirectly called via usb_phy_init() from ehci-tegra.c.
Between obtaining PHY handle (and hence getting into deferred probe, when it is not available)
and calling usb_phy_init, no other USB registers were accessed. Hence I was doing this way.

Do you still think it would be better to move gpio and clk APIs to probe?

> 
> > +	err = of_property_match_string(np, "dr_mode", "otg");
> > +	if (err < 0) {
> > +		err = of_property_match_string(np, "dr_mode", "gadget");
> 
> Again, use "peripheral", not "gadget".

Will do. 

> 
> > +struct usb_phy *tegra_usb_get_phy(struct device_node *dn)
> > +{
> > +	struct device *dev;
> > +	struct tegra_usb_phy *tegra_phy;
> > +
> > +	dev = driver_find_device(&tegra_usb_phy_driver.driver, NULL, dn,
> > +				 tegra_usb_phy_match);
> > +	if (!dev)
> > +		return ERR_PTR(-EPROBE_DEFER);
> > +
> > +	tegra_phy = dev_get_drvdata(dev);
> > +
> > +	return &tegra_phy->u_phy;
> > +}
> 
> I think you need a module_get() somewhere in there, and also need to add
> a tegra_usb_put_phy() function too, so you can call module_put() from it.

Am not clear on why to add module_get here. Can you plz provide more details?
 
Thanks Stephen, for the review.
