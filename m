Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934448Ab3GWXt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 19:49:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56800 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933940Ab3GWXtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 19:49:25 -0400
Date: Wed, 24 Jul 2013 00:48:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
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
Message-ID: <20130723234830.GU9858@sirena.org.uk>
References: <Pine.LNX.4.44L0.1307231017290.1304-100000@iolanthe.rowland.org>
 <51EE9EC0.6060905@ti.com>
 <20130723161846.GD2486@kroah.com>
 <1446965.6APW5ZgLBW@amdc1227>
 <20130723173710.GB28284@kroah.com>
 <20130723174456.GM9858@sirena.org.uk>
 <20130723180110.GA8688@kroah.com>
 <20130723193105.GP9858@sirena.org.uk>
 <20130723194423.GA22984@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o5IUS5lKtXsbsxXW"
Content-Disposition: inline
In-Reply-To: <20130723194423.GA22984@kroah.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o5IUS5lKtXsbsxXW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 12:44:23PM -0700, Greg KH wrote:
> On Tue, Jul 23, 2013 at 08:31:05PM +0100, Mark Brown wrote:

> > statement.  In any case this is why the APIs doing lookups do the
> > lookups in the context of the requesting device - devices ask for
> > whatever name they use locally.

> What do you mean by "locally"?

Within themselves - for example a regulator consumer asks for a given
supply on the device in terms of the supply names the device has.

> The problem with the api was that the phy core wanted a id and a name to
> create a phy, and then later other code was doing a "lookup" based on
> the name and id (mushed together), because it "knew" that this device
> was the one it wanted.

Ah, that sounds like the API is missing a component to link things
together.  But I could be wrong.  What I would expect to see is that the
consumer says "I want the PHY called X" and the PHY driver says "I
provide this set of PHYs" with a layer in between that plugs those
together.  This would normally involve talking about the parent device
rather than the PHY itself.

> I think, that if you create a device, then just carry around the pointer
> to that device (in this case a phy) and pass it to whatever other code
> needs it.  No need to do lookups on "known names" or anything else, just
> normal pointers, with no problems for multiple devices, busses, or
> naming issues.

I think you're not really talking about the lookup API at all here but
rather about one way in which the matching code can be written.  What
everything *really* wants to do is work in terms of resources namespaced
within struct devices since every bit of hardware in the system should
have one of those it can use and if you have a struct device you can do
useful things like call dev_printk() and find the device tree data to do
device tree based lookups.

Unfortunately for a number of buses even when statically registering the
struct device doesn't get allocated until the device is probed so what
everyone fell back on doing was using dev_name() in cases where the
struct device wasn't there yet, or just always using it for consistency
since for most of the affected buses dev_name() is fixed for human
interface reasons.  I think this is the issue you're concerned about
here since if the dev_name() is dynamically allocated this breaks down.
This only affects board files, DT and ACPI can both use their own data
structures to do the mapping.

I had thought you were talking about picking the names that the
consumers use (which isn't actually that big a deal, it's just a bit
annoying for the clock API).

> > It's adding platform data in the first place that gets tedious - and of
> > course there's also DT and ACPI to worry about, it's not just a case of
> > platform data and then you're done.  Pushing the lookup into library
> > code means that drivers don't have to worry about any of this stuff.

> I agree, so just pass around the pointer to the phy and all is good.  No
> need to worry about DT or ACPI or anything else.

No, in practice passing around the pointer gets tricky if you're using
something other than board files (or even are doing any kind of dynamic
stuff with board files) since the two devices need to find each other
and if you're using platform data then the code doing the matching has
to know about the platform data for every device it might need to match
which is just miserable.

Something would need to do something like allocate the PHY objects and
then arrange for them to be passed to both provider and consumer devices
prior to those being registered, knowing where to place the pointers in
the platform data for each device.  This is straightforward with board
files but not otherwise, people have tried this before.

> > For most of the APIs doing this there is a clear and unambiguous name in
> > the hardware that can be used (and for hardware process reasons is
> > unlikely to get changed).  The major exception to this is the clock API
> > since it is relatively rare to have clear, segregated IP level
> > information for IPs baked into larger chips.  The other APIs tend to be
> > establishing chip to chip links.

> The clock api is having problems with multiple "names" due to dynamic
> devices from what I was told.  I want to prevent the PHY interface from
> having that same issue.

I think the underlying issue here is that we don't have a good enough
general way for board files (or other C code but mostly them) to talk
about devices prior to their being registered - rather than have the
pointer you're talking about be the PHY object itself have the pointer
be something which allows us to match the struct device when it's
created.  This should be transparent to drivers and would be usable by
all the existing APIs.

--o5IUS5lKtXsbsxXW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7xZLAAoJELSic+t+oim9zYAP/10+cEyFG33vhrYLrxwLiybd
ITqquVdT2fFPNMgzQH8Sch9V/mOCQxbHnKKswhHY7JP3EviKvPKOCItW+j7cKynU
YsQDaZrU52iyKEWCImCn7FJQNSuHpMPnLxCGHyvslue5XM6qNHoYH64/WHV/jjZ4
f4CqNgO9SVXBedllaz4OqCe5JkBGMlqJ60yCe2p7uUD49YTSGxI2vjfcIXOTjcUo
RD4ysvKYG8ZxWhgzUU6V7OdZvjH3eekRMSHskKNs4E/YPcsozsX1e84ieu2aqYjb
YoX2FbaXfqROAWPqOztrCjiKFhxhzbPeXIjgb82WDJWa8KfKlhaXO+Mr0k+TE2wv
zAklKqwSI7bQ6R3KnokC6pmH2VnSAdIPX3sZ3O5zQGo+UdfJUCnxqOu6W3muQ4ho
ZNlnCQxSHCrC1U+QYe+9uDC4oBfXcF+bPWxJg/EK9msla453ZQeIYeOsv+5zHHLP
ZvEZl3siaPCt1OaG2UjS+UVfscMbAvOxxuKYIpB+k9oU6oWN+ryH8AeTcEWvh5IH
ymHZbjUVTFPnPq5XlOfjDkHsVqMpKB2Lx6CfxnLglxLeNpKLNcfw40/4UpD+A7R1
Irb5EgFvD9sklxUDLOJR55qe1YcR9AuRuTrQSlMGQL15j0I+91x9fCrSreNwaUQG
ReKjJKCMramWgtUxgS9P
=op8T
-----END PGP SIGNATURE-----

--o5IUS5lKtXsbsxXW--
