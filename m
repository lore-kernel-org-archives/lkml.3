Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934005Ab3GWUIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:08:04 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:33913 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab3GWUIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:08:00 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@kernel.org>, Tomasz Figa <t.figa@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
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
Date: Tue, 23 Jul 2013 22:07:52 +0200
Message-ID: <1731726.KENstTPhkb@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130723194423.GA22984@kroah.com>
References: <Pine.LNX.4.44L0.1307231017290.1304-100000@iolanthe.rowland.org> <20130723193105.GP9858@sirena.org.uk> <20130723194423.GA22984@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 of July 2013 12:44:23 Greg KH wrote:
> On Tue, Jul 23, 2013 at 08:31:05PM +0100, Mark Brown wrote:
> > > You don't "know" the id of the device you are looking up, due to
> > > multiple devices being in the system (dynamic ids, look back earlier
> > > in
> > > this thread for details about that.)
> > 
> > I got copied in very late so don't have most of the thread I'm afraid,
> > I did try looking at web archives but didn't see a clear problem
> > statement.  In any case this is why the APIs doing lookups do the
> > lookups in the context of the requesting device - devices ask for
> > whatever name they use locally.
> 
> What do you mean by "locally"?
> 
> The problem with the api was that the phy core wanted a id and a name to
> create a phy, and then later other code was doing a "lookup" based on
> the name and id (mushed together), because it "knew" that this device
> was the one it wanted.
> 
> Just like the clock api, which, for multiple devices, has proven to
> cause problems.  I don't want to see us accept an api that we know has
> issues in it now, I'd rather us fix it up properly.
> 
> Subsystems should be able to create ids how ever they want to, and not
> rely on the code calling them to specify the names of the devices that
> way, otherwise the api is just too fragile.
> 
> I think, that if you create a device, then just carry around the pointer
> to that device (in this case a phy) and pass it to whatever other code
> needs it.  No need to do lookups on "known names" or anything else,
> just normal pointers, with no problems for multiple devices, busses, or
> naming issues.

PHY object is not a device, it is something that a device driver creates 
(one or more instances of) when it is being probed. You don't have a clean 
way to export this PHY object to other driver, other than keeping this PHY 
on a list inside PHY core with some well-known ID (e.g. device name + 
consumer port name/index, like in regulator core) and then to use this 
well-known ID inside consumer driver as a lookup key passed to phy_get();

Actually I think for PHY case, exactly the same way as used for regulators 
might be completely fine:

1. Each PHY would have some kind of platform, non-unique name, that is 
just used to print some messages (like the platform/board name of a 
regulator).
2. Each PHY would have an array of consumers. Consumer specifier would 
consist of consumer device name and consumer port name - just like in 
regulator subsystem.
3. PHY driver receives an array of, let's say, phy_init_data inside its 
platform data that it would use to register its PHYs.
4. Consumer drivers would have constant consumer port names and wouldn't 
receive any information about PHYs from platform code.

Code example:

[Board file]

static const struct phy_consumer_data usb_20_phy0_consumers[] = {
	{
		.devname = "foo-ehci",
		.port = "usbphy",
	},
};

static const struct phy_consumer_data usb_20_phy1_consumers[] = {
	{
		.devname = "foo-otg",
		.port = "otgphy",
	},
};

static const struct phy_init_data my_phys[] = {
	{
		.name = "USB 2.0 PHY 0",
		.consumers = usb_20_phy0_consumers,
		.num_consumers = ARRAY_SIZE(usb_20_phy0_consumers),
	},
	{
		.name = "USB 2.0 PHY 1",
		.consumers = usb_20_phy1_consumers,
		.num_consumers = ARRAY_SIZE(usb_20_phy1_consumers),
	},
	{ }
};

static const struct platform_device usb_phy_pdev = {
	.name = "foo-usbphy",
	.id = -1,
	.dev = {
		.platform_data = my_phys,
	},
};

[PHY driver]

static int foo_usbphy_probe(pdev)
{
	struct foo_usbphy *foo;
	struct phy_init_data *init_data = pdev->dev.platform_data;
	/* ... */
	// for each PHY in init_data {
		phy_register(&foo->phy[i], &init_data[i]);
	// }
	/* ... */
}

[EHCI driver]

static int foo_ehci_probe(pdev)
{
	struct phy *phy;
	/* ... */
	phy = phy_get(&pdev->dev, "usbphy");
	/* ... */
}

[OTG driver]

static int foo_otg_probe(pdev)
{
	struct phy *phy;
	/* ... */
	phy = phy_get(&pdev->dev, "otgphy");
	/* ... */
}

> > > > Having to write platform data for everything gets old fast and the
> > > > code
> > > > duplication is pretty tedious...
> > > 
> > > Adding a single pointer is "tedious"?  Where is the "name" that you
> > > are
> > > going to lookup going to come from?  That code doesn't write
> > > itself...
> > 
> > It's adding platform data in the first place that gets tedious - and
> > of
> > course there's also DT and ACPI to worry about, it's not just a case
> > of
> > platform data and then you're done.  Pushing the lookup into library
> > code means that drivers don't have to worry about any of this stuff.
> 
> I agree, so just pass around the pointer to the phy and all is good.  No
> need to worry about DT or ACPI or anything else.

With Device Tree we don't have board files anymore. How would you pass any 
pointers between provider and consumer drivers in this case?

> > For most of the APIs doing this there is a clear and unambiguous name
> > in the hardware that can be used (and for hardware process reasons is
> > unlikely to get changed).  The major exception to this is the clock
> > API since it is relatively rare to have clear, segregated IP level
> > information for IPs baked into larger chips.  The other APIs tend to
> > be establishing chip to chip links.
> 
> The clock api is having problems with multiple "names" due to dynamic
> devices from what I was told.  I want to prevent the PHY interface from
> having that same issue.

Yes, the clock API has a problem related to the clock namespace being 
global for all registered clock controllers. This is not a problem with 
lookup in general, but with wrong lookup key chosen.

Best regards,
Tomasz

