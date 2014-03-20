Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbaCTSnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:43:37 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33104 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754030AbaCTSnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:43:35 -0400
Date: Thu, 20 Mar 2014 18:43:16 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from
	drivers/media/v4l2-core to drivers/of
Message-ID: <20140320184316.GB7528@n2100.arm.linux.org.uk>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> <20140226110114.CF2C7C40A89@trevor.secretlab.ca> <531D916C.2010903@ti.com> <5427810.BUKJ3iUXnO@avalon> <20140312102556.GC21483@n2100.arm.linux.org.uk> <20140320175432.0559CC4067A@trevor.secretlab.ca> <20140320153804.35d5b835@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140320153804.35d5b835@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 03:38:04PM -0300, Mauro Carvalho Chehab wrote:
> Em Thu, 20 Mar 2014 17:54:31 +0000
> Grant Likely <grant.likely@linaro.org> escreveu:
> 
> > On Wed, 12 Mar 2014 10:25:56 +0000, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > > On Mon, Mar 10, 2014 at 02:52:53PM +0100, Laurent Pinchart wrote:
> > > > In theory unidirectional links in DT are indeed enough. However, let's not 
> > > > forget the following.
> > > > 
> > > > - There's no such thing as single start points for graphs. Sure, in some 
> > > > simple cases the graph will have a single start point, but that's not a 
> > > > generic rule. For instance the camera graphs 
> > > > http://ideasonboard.org/media/omap3isp.ps and 
> > > > http://ideasonboard.org/media/eyecam.ps have two camera sensors, and thus two 
> > > > starting points from a data flow point of view.
> > > 
> > > I think we need to stop thinking of a graph linked in terms of data
> > > flow - that's really not useful.
> > > 
> > > Consider a display subsystem.  The CRTC is the primary interface for
> > > the CPU - this is the "most interesting" interface, it's the interface
> > > which provides access to the picture to be displayed for the CPU.  Other
> > > interfaces are secondary to that purpose - reading the I2C DDC bus for
> > > the display information is all secondary to the primary purpose of
> > > displaying a picture.
> > > 
> > > For a capture subsystem, the primary interface for the CPU is the frame
> > > grabber (whether it be an already encoded frame or not.)  The sensor
> > > devices are all secondary to that.
> > > 
> > > So, the primary software interface in each case is where the data for
> > > the primary purpose is transferred.  This is the point at which these
> > > graphs should commence since this is where we would normally start
> > > enumeration of the secondary interfaces.
> > > 
> > > V4L2 even provides interfaces for this: you open the capture device,
> > > which then allows you to enumerate the capture device's inputs, and
> > > this in turn allows you to enumerate their properties.  You don't open
> > > a particular sensor and work back up the tree.
> > > 
> > > I believe trying to do this according to the flow of data is just wrong.
> > > You should always describe things from the primary device for the CPU
> > > towards the peripheral devices and never the opposite direction.
> > 
> > Agreed.
> 
> I don't agree, as what's the primary device is relative. 
> 
> Actually, in the case of a media data flow, the CPU is generally not
> the primary device.
> 
> Even on general purpose computers, if the full data flow is taken into
> the account, the CPU is a mere device that will just be used to copy
> data either to GPU and speakers or to disk, eventually doing format
> conversions, when the hardware is cheap and don't provide format
> converters.
> 
> On more complex devices, like the ones we want to solve with the
> media controller, like an embedded hardware like a TV or a STB, the CPU
> is just an ancillary component that could even hang without stopping 
> TV reception, as the data flow can be fully done inside the chipset.

The CPU is the _controlling_ component - it's the component that has to
configure the peripherals so they all talk to each other in the right
way.  Therefore, the view of it needs to be CPU centric.

If we were providing a DT description for consumption by some other
device in the system, then the view should be as seen from that device
instead.

Think about this.  Would you describe a system starting at, say, the
system keyboard, and branching all the way through just becuase that's
how you interact with it, or would you describe it from the CPUs point
of view because that's what has to be in control of the system.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
