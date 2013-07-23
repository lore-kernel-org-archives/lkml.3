Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933876Ab3GWVDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:03:09 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:55874 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab3GWVDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:03:05 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tomasz Figa <t.figa@samsung.com>, Greg KH <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
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
Date: Tue, 23 Jul 2013 23:02:57 +0200
Message-ID: <1388978.Qc6sFy33oS@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1307231632580.1304-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1307231632580.1304-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 of July 2013 16:53:55 Alan Stern wrote:
> On Tue, 23 Jul 2013, Tomasz Figa wrote:
> > > That's what I was going to suggest too.  The struct phy is defined
> > > in
> > > the board file, which already knows about all the PHYs that exist in
> > > the system.  (Or perhaps it is allocated dynamically, so that when
> > > many
> > > board files are present in the same kernel, only the entries listed
> > > in
> > > the board file for the current system get created.)
> > 
> > Well, such dynamic allocation is a must. We don't accept
> > non-multiplatform aware code anymore, not even saying about
> > multiboard.
> > 
> > > Then the
> > > structure's address is stored in the platform data and made
> > > available
> > > to both the provider and the consumer.
> > 
> > Yes, technically this can work. You would still have to perform some
> > kind of synchronization to make sure that the PHY bound to this
> > structure is actually present. This is again technically doable (e.g.
> > a list of registered struct phys inside PHY core).
> 
> The synchronization takes place inside phy_get.  If phy_create hasn't
> been called for this structure by the time phy_get runs, phy_get will
> return an error.

Yes, this is the solution that I had in mind when saying that this is 
doable.

> > > Even though the struct phy is defined (or allocated) in the board
> > > file,
> > > its contents don't get filled in until the PHY driver provides the
> > > details.
> > 
> > You can't assure this. Board file is free to do whatever it wants with
> > this struct. A clean solution would prevent this.
> 
> I'm not sure what you mean here.  Of course I can't prevent a board
> file from messing up a data structure.  I can't prevent it from causing
> memory access violations either; in fact, I can't prevent any bugs in
> other people's code.
> 
> Besides, why do you say the board file is free to do whatever it wants
> with the struct phy?  Currently the struct phy is created by the PHY
> provider and the PHY core, right?  It's not even mentioned in the board
> file.

I mean, if you have a struct type of which full declaration is available 
for some code, this code can access any memeber of it without any hacks, 
which is not something that we want to have in board files. The phy struct 
should be opaque for them.

> > > > It's technically correct, but quality of this solution isn't
> > > > really
> > > > nice, because it's a layering violation (at least if I understood
> > > > what you mean). This is because you need to have full definition
> > > > of
> > > > struct phy in board file and a structure that is used as private
> > > > data
> > > > in PHY core comes from platform code.
> > > 
> > > You don't have to have a full definition in the board file.  Just a
> > > partial definition -- most of the contents can be filled in later,
> > > when
> > > the PHY driver is ready to store the private data.
> > > 
> > > It's not a layering violation for one region of the kernel to store
> > > private data in a structure defined by another part of the kernel.
> > > This happens all the time (e.g., dev_set_drvdata).
> > 
> > Not really. The phy struct is something that _is_ private data of PHY
> > subsystem, not something that can store private data of PHY subsystem
> > (sure it can store private data of particular PHY driver, but that's
> > another story) and only PHY subsystem should have access to its
> > contents.
> If you want to keep the phy struct completely separate from the board
> file, there's an easy way to do it.  Let's say the board file knows
> about N different PHYs in the system.  Then you define an array of N
> pointers to phys:
> 
> struct phy *(phy_address[N]);
> 
> In the platform data for both PHY j and its controller, store
> &phy_address[j].  The PHY provider passes this cookie to phy_create:
> 
> 	cookie = pdev->dev.platform_data;
> 	ret = phy_create(phy, cookie);
> 
> and phy_create simply stores: *cookie = phy.  The PHY consumer does
> much the same the same thing:
> 
> 	cookie = pdev->dev.platform_data;
> 	phy = phy_get(cookie);
> 
> phy_get returns *cookie if it isn't NULL, or an ERR_PTR otherwise.

OK, this can work. Again, just technically, because it's rather ugly.

> > By the way, we need to consider other cases here as well, for example
> > it would be nice to have a single phy_get() function that works for
> > both non- DT and DT cases to make the consumer driver not have to
> > worry whether it's being probed from DT or not.
> 
> You ought to be able to adapt this scheme to work with DT.  Maybe by
> having multiple "phy_address" arrays.

Where would you want to have those phy_address arrays stored? There are no 
board files when booting with DT. Not even saying that you don't need to 
use any hacky schemes like this when you have DT that nicely specifies 
relations between devices.

Anyway, board file should not be considered as a method to exchange data 
between drivers. It should be used only to pass data from it to drivers, 
not the other way. Ideally all data in a board file should be marked as 
const and __init and dropped after system initialization.

Best regards,
Tomasz

