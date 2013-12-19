Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3LSVng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 16:43:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab3LSVne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 16:43:34 -0500
Date: Thu, 19 Dec 2013 13:43:36 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stuart Yoder <stuart.yoder@freescale.com>
Cc: Scott Wood <scottwood@freescale.com>,
        Kim Phillips <kim.phillips@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [REPOST][PATCH 1/2] driver core: Add new device_driver flag to
 allow binding via sysfs only
Message-ID: <20131219214336.GA24629@kroah.com>
References: <20131203123446.42fbff34a8ebd7afd38159a5@linaro.org>
 <20131219010729.GC23055@kroah.com>
 <1387484531.3140.134.camel@snotra.buserror.net>
 <20131219203401.GA11290@kroah.com>
 <dd683e36cc334893b193f4d36a33238c@BY2PR03MB348.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd683e36cc334893b193f4d36a33238c@BY2PR03MB348.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 09:06:21PM +0000, Stuart Yoder wrote:
> 
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> > Sent: Thursday, December 19, 2013 2:34 PM
> > To: Wood Scott-B07421
> > Cc: Kim Phillips; linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
> > Bhushan Bharat-R65777; Yoder Stuart-B08248; christoffer.dall@linaro.org;
> > alex.williamson@redhat.com; a.motakis@virtualopensystems.com;
> > agraf@suse.de; Sethi Varun-B16395
> > Subject: Re: [REPOST][PATCH 1/2] driver core: Add new device_driver flag
> > to allow binding via sysfs only
> > 
> > On Thu, Dec 19, 2013 at 02:22:11PM -0600, Scott Wood wrote:
> > > On Wed, 2013-12-18 at 17:07 -0800, Greg Kroah-Hartman wrote:
> > > > On Tue, Dec 03, 2013 at 12:34:46PM +0000, Kim Phillips wrote:
> > > > > VFIO supports pass-through of devices to user space - for sake
> > > > > of illustration, say a PCI e1000 device:
> > > > >
> > > > > - the e1000 is first unbound from the PCI e1000 driver via sysfs
> > > > > - the vfio-pci driver is told via new_id that it now handles e1000
> > devices
> > > > > - the e1000 is explicitly bound to vfio-pci through sysfs
> > > > >
> > > > > However, now we have two drivers in the system that both handle
> > e1000
> > > > > devices.  A hotplug event could then occur and it is ambiguous as
> > to which
> > > > > driver will claim the device.  The desired semantics is that vfio-
> > pci is
> > > > > only bound to devices by explicit request in sysfs.  This patch
> > makes this
> > > > > possible by introducing a sysfs_bind_only flag in struct
> > device_driver.
> > > >
> > > > Why deal with this at all and not just deal with the "bind" sysfs
> > file
> > > > instead?  That way no driver core logic needs to be changed at all,
> > and
> > > > your userspace tools know _exactly_ which device is being bound to
> > the
> > > > new device.
> > > >
> > > > Don't mess with the "new_id" file for stuff like this, as you point
> > out,
> > > > it's "tricky"...
> > >
> > > As discussed before, "bind" does not bypass the ID checks, and thus it
> > > does not work without either "new_id" or a wildcard match.
> > 
> > Ah, forgot about that.
> > 
> > > Or are you proposing changing "bind" so that it does bypass the ID
> > > checks?  Or perhaps a new "force_bind" file that does?
> > 
> > No.  But you can use bind/unbind along with the existing new_id file to
> > get what you want today.
> 
> Yes, but that only works for PCI.

No, not only PCI.

> There is no such concept for platform drivers.

Then fix that.

Or make your device not be a platform device, odds are that's the better
solution in the end, right?

> > If you just happen to bind a device to a wrong
> > driver for a while, that's not really a problem, right?
> 
> It's annoying but not the end of the world.
> 
> > I don't like this patch as we are adding lots of special and odd logic
> > to the core, for use by almost no one, which ensures that it will never
> > get tested, and will probably get broken in some subtle way in the
> > future.
> 
> It certainly will be used by users of vfio-platform.
> 
> Here is the problem-- the new platform device "match_any_dev" mechanism
> in patch 2 of this series is not going to work without "sysfs_bind_only".
> A platform driver that just sets "match_any_dev" will grab any or all 
> platform devices during normal bus probing.

No it will not, it will fail in the probe function as it knows to not
grab the device, just like any driver for other busses that say it can
"handle all Intel PCI devices" and the like.

> > Heck, I can't even ensure that you got it right now, with this tiny
> > patch, how do you know it works given that there are no users of this
> > flag anywhere (hint, you never showed me any...)
> 
> It has been tested on both vfio-pci and vfio-platform in some limited
> experiments as far as I know, but that code is not ready for upstream
> yet.

Then I'll wait until you get something that actually is worth
upstreaming before worrying about this again.

greg k-h
