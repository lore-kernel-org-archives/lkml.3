Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaENOh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:37:26 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:35041 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaENOhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:37:24 -0400
Date: Wed, 14 May 2014 16:37:19 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/7] drivers/base: Add interface framework
Message-ID: <20140514143719.GH8790@phenom.ffwll.local>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Thierry Reding <thierry.reding@gmail.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
	David Herrmann <dh.herrmann@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sascha Hauer <s.hauer@pengutronix.de>, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1399995050-28435-1-git-send-email-thierry.reding@gmail.com>
 <1399995050-28435-5-git-send-email-thierry.reding@gmail.com>
 <20140513175713.GS3908@phenom.ffwll.local>
 <20140514003215.GA21520@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514003215.GA21520@kroah.com>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 05:32:15PM -0700, Greg Kroah-Hartman wrote:
> On Tue, May 13, 2014 at 07:57:13PM +0200, Daniel Vetter wrote:
> > On Tue, May 13, 2014 at 05:30:47PM +0200, Thierry Reding wrote:
> > > From: Thierry Reding <treding@nvidia.com>
> > > 
> > > Some drivers, such as graphics drivers in the DRM subsystem, do not have
> > > a real device that they can bind to. They are often composed of several
> > > devices, each having their own driver. The master/component framework
> > > can be used in these situations to collect the devices pertaining to one
> > > logical device, wait until all of them have registered and then bind
> > > them all at once.
> > > 
> > > For some situations this is only a partial solution. An implementation
> > > of a master still needs to be registered with the system somehow. Many
> > > drivers currently resort to creating a dummy device that a driver can
> > > bind to and register the master against. This is problematic since it
> > > requires (and presumes) knowledge about the system within drivers.
> > > 
> > > Furthermore there are setups where a suitable device already exists, but
> > > is already bound to a driver. For example, on Tegra the following device
> > > tree extract (simplified) represents the host1x device along with child
> > > devices:
> > > 
> > > 	host1x {
> > > 		display-controller {
> > > 			...
> > > 		};
> > > 
> > > 		display-controller {
> > > 			...
> > > 		};
> > > 
> > > 		hdmi {
> > > 			...
> > > 		};
> > > 
> > > 		dsi {
> > > 			...
> > > 		};
> > > 
> > > 		csi {
> > > 			...
> > > 		};
> > > 
> > > 		video-input {
> > > 			...
> > > 		};
> > > 	};
> > > 
> > > Each of the child devices is in turn a client of host1x, in that it can
> > > request resources (command stream DMA channels and syncpoints) from it.
> > > To implement the DMA channel and syncpoint infrastructure, host1x comes
> > > with its own driver. Children are implemented in separate drivers. In
> > > Linux this set of devices would be exposed by DRM and V4L2 drivers.
> > > 
> > > However, neither the DRM nor the V4L2 drivers have a single device that
> > > they can bind to. The DRM device is composed of the display controllers
> > > and the various output devices, whereas the V4L2 device is composed of
> > > one or more video input devices.
> > > 
> > > This patch introduces the concept of an interface and drivers that can
> > > bind to a given interface. An interface can be exposed by any device,
> > > and interface drivers can bind to these interfaces. Multiple drivers can
> > > bind against a single interface. When a device is removed, interfaces
> > > exposed by it will be removed as well, thereby removing the drivers that
> > > were bound to those interfaces.
> > > 
> > > In the example above, the host1x device would expose the "tegra-host1x"
> > > interface. DRM and V4L2 drivers can then bind to that interface and
> > > instantiate the respective subsystem objects from there.
> > > 
> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > ---
> > > Note that I'd like to merge this through the Tegra DRM tree so that the
> > > changes to the Tegra DRM driver later in this series can be merged at
> > > the same time and are not delayed for another release cycle.
> > > 
> > > In particular that means that I'm looking for an Acked-by from Greg.
> > > 
> > >  drivers/base/Makefile     |   2 +-
> > >  drivers/base/interface.c  | 186 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  include/linux/interface.h |  40 ++++++++++
> > >  3 files changed, 227 insertions(+), 1 deletion(-)
> > >  create mode 100644 drivers/base/interface.c
> > >  create mode 100644 include/linux/interface.h
> > 
> > Hm, this interface stuff smells like bus drivers light. Should we instead
> > have a pile of helpers to make creating new buses with match methods more
> > trivial? There's a fairly big pile of small use-cases where this might be
> > useful. In your case here all the host1x children would sit on a host1x
> > bus. Admittedly I didn't look into the details.
> 
> I have no problem adding such "bus-light" functions, to make it easier
> to create and implement a bus in the driver core, as I know it's really
> heavy.  That's been on my "todo" list for over a decade now...

Hm, I've victimized^Wvolunteered a few internal people to look into a
hdmi/dp sink bus type of thing so that we can move away from all those
ad-hoc hacks currently used to coordinate between drm display drivers and
the audio side of things. So I'm interested.

Do you have some ideas somewhere already about how you think this should
look like? Or is this more a "hey, this would be really cool, eventually"
kind of thing?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
