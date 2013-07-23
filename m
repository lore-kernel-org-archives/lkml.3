Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620Ab3GWQSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:18:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104Ab3GWQSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:18:47 -0400
Date: Tue, 23 Jul 2013 09:18:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        broonie@kernel.org, Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, kyungmin.park@samsung.com,
        balbi@ti.com, jg1.han@samsung.com, s.nawrocki@samsung.com,
        kgene.kim@samsung.com, grant.likely@linaro.org, tony@atomide.com,
        arnd@arndb.de, swarren@nvidia.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com, olof@lixom.net,
        Stephen Warren <swarren@wwwdotorg.org>, b.zolnierkie@samsung.com,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
Message-ID: <20130723161846.GD2486@kroah.com>
References: <Pine.LNX.4.44L0.1307231017290.1304-100000@iolanthe.rowland.org>
 <51EE9EC0.6060905@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EE9EC0.6060905@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 08:48:24PM +0530, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Tuesday 23 July 2013 08:07 PM, Alan Stern wrote:
> > On Tue, 23 Jul 2013, Tomasz Figa wrote:
> > 
> >> On Tuesday 23 of July 2013 09:29:32 Tomasz Figa wrote:
> >>> Hi Alan,
> > 
> > Thanks for helping to clarify the issues here.
> > 
> >>>> Okay.  Are PHYs _always_ platform devices?
> >>>
> >>> They can be i2c, spi or any other device types as well.
> > 
> > In those other cases, presumably there is no platform data associated
> > with the PHY since it isn't a platform device.  Then how does the
> > kernel know which controller is attached to the PHY?  Is this spelled
> > out in platform data associated with the PHY's i2c/spi/whatever parent?
> 
> Yes. I think we could use i2c_board_info for passing platform data.
> > 
> >>>>>> 	PHY.  Currently this information is represented by name or 
> >> ID
> >>>>>> 	strings embedded in platform data.
> >>>>>
> >>>>> right. It's embedded in the platform data of the controller.
> >>>>
> >>>> It must also be embedded in the PHY's platform data somehow.
> >>>> Otherwise, how would the kernel know which PHY to use?
> >>>
> >>> By using a PHY lookup as Stephen and I suggested in our previous
> >>> replies. Without any extra data in platform data. (I have even posted a
> >>> code example.)
> > 
> > I don't understand, because I don't know what "a PHY lookup" does.
> 
> It is how the PHY framework finds a PHY, when the controller (say USB)requests
> a PHY from the PHY framework.
> > 
> >>>> In this case, it doesn't matter where the platform_device structures
> >>>> are created or where the driver source code is.  Let's take a simple
> >>>> example.  Suppose the system design includes a PHY named "foo".  Then
> >>>> the board file could contain:
> >>>>
> >>>> struct phy_info { ... } phy_foo;
> >>>> EXPORT_SYMBOL_GPL(phy_foo);
> >>>>
> >>>> and a header file would contain:
> >>>>
> >>>> extern struct phy_info phy_foo;
> >>>>
> >>>> The PHY supplier could then call phy_create(&phy_foo), and the PHY
> >>>> client could call phy_find(&phy_foo).  Or something like that; make up
> >>>> your own structure tags and function names.
> >>>>
> >>>> It's still possible to have conflicts, but now two PHYs with the same
> >>>> name (or a misspelled name somewhere) will cause an error at link
> >>>> time.
> >>>
> >>> This is incorrect, sorry. First of all it's a layering violation - you
> >>> export random driver-specific symbols from one driver to another. Then
> > 
> > No, that's not what I said.  Neither the PHY driver nor the controller
> > driver exports anything to the other.  Instead, both drivers use data
> > exported by the board file.
> 
> I think instead we can use the same data while creating the platform data of
> the controller and the PHY.
> The PHY driver while creating the PHY (using PHY framework) will also pass the
> *data* it actually got from the platform data to the framework.
> The PHY user driver (USB), while requesting for the PHY (from the PHY
> framework) will pass the *data* it got from its platform data.
> The PHY framework can do a comparison of the *data* pointers it has and return
> the appropriate PHY to the controller.
> > 
> >>> imagine 4 SoCs - A, B, C, D. There are two PHY types PHY1 and PHY2 and
> >>> there are two types of consumer drivers (e.g. USB host controllers). Now
> >>> consider following mapping:
> >>>
> >>> SoC	PHY	consumer
> >>> A	PHY1	HOST1
> >>> B	PHY1	HOST2
> >>> C	PHY2	HOST1
> >>> D	PHY2	HOST2
> >>>
> >>> So we have to be able to use any of the PHYs with any of the host
> >>> drivers. This means you would have to export symbol with the same name
> >>> from both PHY drivers, which obviously would not work in this case,
> >>> because having both drivers enabled (in a multiplatform aware
> >>> configuration) would lead to linking conflict.
> > 
> > You're right; the scheme was too simple.  Instead, the board file must
> > export two types of data structures, one for PHYs and one for
> > controllers.  Like this:
> > 
> > struct phy_info {
> > 	/* Info for the controller attached to this PHY */
> > 	struct controller_info	*hinfo;
> > };
> > 
> > struct controller_info {
> > 	/* Info for the PHY which this controller is attached to */
> > 	struct phy_info		*pinfo;
> > };
> > 
> > The board file for SoC A would contain:
> > 
> > struct phy_info phy1 = {&host1);
> > EXPORT_SYMBOL(phy1);
> > struct controller_info host1 = {&phy1};
> > EXPORT_SYMBOL(host1);
> > 
> > The board file for SoC B would contain:
> > 
> > struct phy_info phy1 = {&host2);
> > EXPORT_SYMBOL(phy1);
> > struct controller_info host2 = {&phy1};
> > EXPORT_SYMBOL(host2);
> 
> I meant something like this
> struct phy_info {
> 	const char *name;
> };
> 
> struct phy_platform_data {
> 	.
> 	.
> 	struct phy_info *info;
> };
> 
> struct usb_controller_platform_data {
> 	.
> 	.
> 	struct phy_info *info;
> };
> 
> struct phy_info phy_info;
> 
> While creating the phy device
> 	struct phy_platform_data phy_data;
> 	phy_data.info = &info;
> 	platform_device_add_data(pdev, &phy_data, sizeof(*phy_data))
> 	platform_device_add();
> 
> While creating the controller device
> 	struct usb_controller_platform_data controller_data;
> 	controller_data.info = &info;
> 	platform_device_add_data(pdev, &controller_data, sizeof(*controller_data))
> 	platform_device_add();
> 
> Then modify PHY framework API phy create
> 	phy_create((struct device *dev, const struct phy_ops *ops,
>         void *priv)  {//API changed to take void pointer instead of label
> 		. //existing implementation
> 		.
> 		phy->priv = priv;
> 	}
> 
> 	struct phy *phy_get(struct device *dev, const char *string, void *priv) {
> //API changed to take an additional pointer
> 		phy_lookup(priv)
> 	}
> 
> 	static struct phy *phy_lookup(void *priv) {
> 		.
> 		.
> 		if (phy->priv==priv) //instead of string comparison, we'll use pointer
> 			return phy;
> 	}
> 
> PHY driver should be like
> 	phy_create((dev, ops, pdata->info);
> 
> The controller driver would do
> 	phy_get(dev, NULL, pdata->info);
> 
> Now the PHY framework will check for a match of *priv* pointer and return the PHY.
> 
> I think this should be possible?

Ick, no.  Why can't you just pass the pointer to the phy itself?  If you
had a "priv" pointer to search from, then you could have just passed the
original phy pointer in the first place, right?

The issue is that a string "name" is not going to scale at all, as it
requires hard-coded information that will change over time (as the
existing clock interface is already showing.)

Please just pass the real "phy" pointer around, that's what it is there
for.  Your "board binding" logic/code should be able to handle this, as
it somehow was going to do the same thing with a "name".

thanks,

greg k-h
