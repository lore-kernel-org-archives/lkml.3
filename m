Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934141Ab3GWTgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:36:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56843 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933970Ab3GWTgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:36:01 -0400
Date: Tue, 23 Jul 2013 15:36:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tomasz Figa <t.figa@samsung.com>
cc: Greg KH <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <broonie@kernel.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, <kyungmin.park@samsung.com>,
        <balbi@ti.com>, <jg1.han@samsung.com>, <s.nawrocki@samsung.com>,
        <kgene.kim@samsung.com>, <grant.likely@linaro.org>, <tony@atomide.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
In-Reply-To: <1446965.6APW5ZgLBW@amdc1227>
Message-ID: <Pine.LNX.4.44L0.1307231518310.1304-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jul 2013, Tomasz Figa wrote:

> IMHO it would be better if you provided some code example, but let's try to 
> check if I understood you correctly.
> 
> 8><------------------------------------------------------------------------
> 
> [Board file]
> 
> static struct phy my_phy;
> 
> static struct platform_device phy_pdev = {
> 	/* ... */
> 	.platform_data = &my_phy;
> 	/* ... */
> };
> 
> static struct platform_device phy_pdev = {

This should be controller_pdev, not phy_pdev, yes?

> 	/* ... */
> 	.platform_data = &my_phy;
> 	/* ... */
> };
> 
> [Provider driver]
> 
> struct phy *phy = pdev->dev.platform_data;
> 
> ret = phy_create(phy);
> 
> [Consumer driver]
> 
> struct phy *phy = pdev->dev.platform_data;
> 
> ret = phy_get(&pdev->dev, phy);

Or even just phy_get(&pdev->dev), because phy_get() could be smart 
enough to to set phy = dev->platform_data.

> ------------------------------------------------------------------------><8
> 
> Is this what you mean?

That's what I was going to suggest too.  The struct phy is defined in
the board file, which already knows about all the PHYs that exist in
the system.  (Or perhaps it is allocated dynamically, so that when many
board files are present in the same kernel, only the entries listed in
the board file for the current system get created.)  Then the
structure's address is stored in the platform data and made available
to both the provider and the consumer.

Even though the struct phy is defined (or allocated) in the board file,
its contents don't get filled in until the PHY driver provides the
details.

> It's technically correct, but quality of this solution isn't really nice, 
> because it's a layering violation (at least if I understood what you mean). 
> This is because you need to have full definition of struct phy in board file 
> and a structure that is used as private data in PHY core comes from 
> platform code.

You don't have to have a full definition in the board file.  Just a 
partial definition -- most of the contents can be filled in later, when 
the PHY driver is ready to store the private data.

It's not a layering violation for one region of the kernel to store 
private data in a structure defined by another part of the kernel.  
This happens all the time (e.g., dev_set_drvdata).

Alan Stern

