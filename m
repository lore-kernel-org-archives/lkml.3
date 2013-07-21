Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab3GUKX0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 06:23:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41032 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab3GUKXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 06:23:22 -0400
Date: Sun, 21 Jul 2013 12:22:48 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, kyungmin.park@samsung.com,
        balbi@ti.com, jg1.han@samsung.com, s.nawrocki@samsung.com,
        kgene.kim@samsung.com, grant.likely@linaro.org, tony@atomide.com,
        arnd@arndb.de, swarren@nvidia.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
Message-ID: <20130721102248.GE29785@pengutronix.de>
References: <20130720220006.GA7977@kroah.com>
 <Pine.LNX.4.44L0.1307202223430.8250-100000@netrider.rowland.org>
 <20130721025910.GA23043@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130721025910.GA23043@kroah.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:12:47 up 37 days, 22:23, 20 users,  load average: 1.61, 1.06,
 0.54
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 07:59:10PM -0700, Greg KH wrote:
> On Sat, Jul 20, 2013 at 10:32:26PM -0400, Alan Stern wrote:
> > On Sat, 20 Jul 2013, Greg KH wrote:
> > 
> > > > >>That should be passed using platform data.
> > > > >
> > > > >Ick, don't pass strings around, pass pointers.  If you have platform
> > > > >data you can get to, then put the pointer there, don't use a "name".
> > > > 
> > > > I don't think I understood you here :-s We wont have phy pointer
> > > > when we create the device for the controller no?(it'll be done in
> > > > board file). Probably I'm missing something.
> > > 
> > > Why will you not have that pointer?  You can't rely on the "name" as the
> > > device id will not match up, so you should be able to rely on the
> > > pointer being in the structure that the board sets up, right?
> > > 
> > > Don't use names, especially as ids can, and will, change, that is going
> > > to cause big problems.  Use pointers, this is C, we are supposed to be
> > > doing that :)
> > 
> > Kishon, I think what Greg means is this:  The name you are using must
> > be stored somewhere in a data structure constructed by the board file,
> > right?  Or at least, associated with some data structure somehow.  
> > Otherwise the platform code wouldn't know which PHY hardware
> > corresponded to a particular name.
> > 
> > Greg's suggestion is that you store the address of that data structure 
> > in the platform data instead of storing the name string.  Have the 
> > consumer pass the data structure's address when it calls phy_create, 
> > instead of passing the name.  Then you don't have to worry about two 
> > PHYs accidentally ending up with the same name or any other similar 
> > problems.
> 
> Close, but the issue is that whatever returns from phy_create() should
> then be used, no need to call any "find" functions, as you can just use
> the pointer that phy_create() returns.  Much like all other class api
> functions in the kernel work.

I think the problem here is to connect two from the bus structure
completely independent devices. Several frameworks (ASoC, soc-camera)
had this problem and this wasn't solved until the advent of devicetrees
and their phandles.
phy_create might be called from the probe function of some i2c device
(the phy device) and the resulting pointer is then needed in some other
platform devices (the user of the phy) probe function.
The best solution we have right now is implemented in the clk framework
which uses a string matching of the device names in clk_get() (at least
in the non-dt case).

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
