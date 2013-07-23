Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934017Ab3GWTnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:43:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933964Ab3GWTnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:43:12 -0400
Date: Tue, 23 Jul 2013 12:44:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Tomasz Figa <t.figa@samsung.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Tomasz Figa <tomasz.figa@gmail.com>,
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
Message-ID: <20130723194423.GA22984@kroah.com>
References: <Pine.LNX.4.44L0.1307231017290.1304-100000@iolanthe.rowland.org>
 <51EE9EC0.6060905@ti.com>
 <20130723161846.GD2486@kroah.com>
 <1446965.6APW5ZgLBW@amdc1227>
 <20130723173710.GB28284@kroah.com>
 <20130723174456.GM9858@sirena.org.uk>
 <20130723180110.GA8688@kroah.com>
 <20130723193105.GP9858@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723193105.GP9858@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 08:31:05PM +0100, Mark Brown wrote:
> > You don't "know" the id of the device you are looking up, due to
> > multiple devices being in the system (dynamic ids, look back earlier in
> > this thread for details about that.)
> 
> I got copied in very late so don't have most of the thread I'm afraid, 
> I did try looking at web archives but didn't see a clear problem
> statement.  In any case this is why the APIs doing lookups do the
> lookups in the context of the requesting device - devices ask for
> whatever name they use locally.

What do you mean by "locally"?

The problem with the api was that the phy core wanted a id and a name to
create a phy, and then later other code was doing a "lookup" based on
the name and id (mushed together), because it "knew" that this device
was the one it wanted.

Just like the clock api, which, for multiple devices, has proven to
cause problems.  I don't want to see us accept an api that we know has
issues in it now, I'd rather us fix it up properly.

Subsystems should be able to create ids how ever they want to, and not
rely on the code calling them to specify the names of the devices that
way, otherwise the api is just too fragile.

I think, that if you create a device, then just carry around the pointer
to that device (in this case a phy) and pass it to whatever other code
needs it.  No need to do lookups on "known names" or anything else, just
normal pointers, with no problems for multiple devices, busses, or
naming issues.

> > > Having to write platform data for everything gets old fast and the code
> > > duplication is pretty tedious...
> 
> > Adding a single pointer is "tedious"?  Where is the "name" that you are
> > going to lookup going to come from?  That code doesn't write itself...
> 
> It's adding platform data in the first place that gets tedious - and of
> course there's also DT and ACPI to worry about, it's not just a case of
> platform data and then you're done.  Pushing the lookup into library
> code means that drivers don't have to worry about any of this stuff.

I agree, so just pass around the pointer to the phy and all is good.  No
need to worry about DT or ACPI or anything else.

> For most of the APIs doing this there is a clear and unambiguous name in
> the hardware that can be used (and for hardware process reasons is
> unlikely to get changed).  The major exception to this is the clock API
> since it is relatively rare to have clear, segregated IP level
> information for IPs baked into larger chips.  The other APIs tend to be
> establishing chip to chip links.

The clock api is having problems with multiple "names" due to dynamic
devices from what I was told.  I want to prevent the PHY interface from
having that same issue.

thanks,

greg k-h
