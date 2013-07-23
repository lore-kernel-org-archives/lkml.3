Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917Ab3GWOhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 10:37:11 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56464 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757638Ab3GWOhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 10:37:06 -0400
Date: Tue, 23 Jul 2013 10:37:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tomasz Figa <tomasz.figa@gmail.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>, <broonie@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
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
In-Reply-To: <3419798.aorxYv8pdo@flatron>
Message-ID: <Pine.LNX.4.44L0.1307231017290.1304-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jul 2013, Tomasz Figa wrote:

> On Tuesday 23 of July 2013 09:29:32 Tomasz Figa wrote:
> > Hi Alan,

Thanks for helping to clarify the issues here.

> > > Okay.  Are PHYs _always_ platform devices?
> > 
> > They can be i2c, spi or any other device types as well.

In those other cases, presumably there is no platform data associated
with the PHY since it isn't a platform device.  Then how does the
kernel know which controller is attached to the PHY?  Is this spelled
out in platform data associated with the PHY's i2c/spi/whatever parent?

> > > > > 	PHY.  Currently this information is represented by name or 
> ID
> > > > > 	strings embedded in platform data.
> > > > 
> > > > right. It's embedded in the platform data of the controller.
> > > 
> > > It must also be embedded in the PHY's platform data somehow.
> > > Otherwise, how would the kernel know which PHY to use?
> > 
> > By using a PHY lookup as Stephen and I suggested in our previous
> > replies. Without any extra data in platform data. (I have even posted a
> > code example.)

I don't understand, because I don't know what "a PHY lookup" does.

> > > In this case, it doesn't matter where the platform_device structures
> > > are created or where the driver source code is.  Let's take a simple
> > > example.  Suppose the system design includes a PHY named "foo".  Then
> > > the board file could contain:
> > > 
> > > struct phy_info { ... } phy_foo;
> > > EXPORT_SYMBOL_GPL(phy_foo);
> > > 
> > > and a header file would contain:
> > > 
> > > extern struct phy_info phy_foo;
> > > 
> > > The PHY supplier could then call phy_create(&phy_foo), and the PHY
> > > client could call phy_find(&phy_foo).  Or something like that; make up
> > > your own structure tags and function names.
> > > 
> > > It's still possible to have conflicts, but now two PHYs with the same
> > > name (or a misspelled name somewhere) will cause an error at link
> > > time.
> > 
> > This is incorrect, sorry. First of all it's a layering violation - you
> > export random driver-specific symbols from one driver to another. Then

No, that's not what I said.  Neither the PHY driver nor the controller
driver exports anything to the other.  Instead, both drivers use data
exported by the board file.

> > imagine 4 SoCs - A, B, C, D. There are two PHY types PHY1 and PHY2 and
> > there are two types of consumer drivers (e.g. USB host controllers). Now
> > consider following mapping:
> > 
> > SoC	PHY	consumer
> > A	PHY1	HOST1
> > B	PHY1	HOST2
> > C	PHY2	HOST1
> > D	PHY2	HOST2
> > 
> > So we have to be able to use any of the PHYs with any of the host
> > drivers. This means you would have to export symbol with the same name
> > from both PHY drivers, which obviously would not work in this case,
> > because having both drivers enabled (in a multiplatform aware
> > configuration) would lead to linking conflict.

You're right; the scheme was too simple.  Instead, the board file must
export two types of data structures, one for PHYs and one for
controllers.  Like this:

struct phy_info {
	/* Info for the controller attached to this PHY */
	struct controller_info	*hinfo;
};

struct controller_info {
	/* Info for the PHY which this controller is attached to */
	struct phy_info		*pinfo;
};

The board file for SoC A would contain:

struct phy_info phy1 = {&host1);
EXPORT_SYMBOL(phy1);
struct controller_info host1 = {&phy1};
EXPORT_SYMBOL(host1);

The board file for SoC B would contain:

struct phy_info phy1 = {&host2);
EXPORT_SYMBOL(phy1);
struct controller_info host2 = {&phy1};
EXPORT_SYMBOL(host2);

And so on.  This explicitly gives the connection between PHYs and
controllers.  The PHY providers would use &phy1 or &phy2, and the PHY
consumers would use &host1 or &host2.

Alan Stern

