Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab3JBU1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:27:44 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:34452 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab3JBU1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:27:42 -0400
Date: Wed, 2 Oct 2013 21:27:38 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Yoder Stuart-B08248 <B08248@freescale.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kim Phillips <kim.phillips@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        Bhushan Bharat-R65777 <R65777@freescale.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "santosh.shukla@linaro.org" <santosh.shukla@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
Message-ID: <20131002202738.GC3029@lvm>
References: <20131001133831.6e46e8e00e09d5d9079fde57@linaro.org>
 <20131001200054.GA27330@kroah.com>
 <20131001170244.ff4fb81d9a7a09598c4c6247@linaro.org>
 <20131002015355.GD63102@lvm>
 <1380681356.14271.57.camel@ul30vt.home>
 <20131002151413.GG63102@lvm>
 <9F6FE96B71CF29479FF1CDC8046E15036D405D@039-SN1MPN1-003.039d.mgd.msft.net>
 <1380738758.12932.43.camel@snotra.buserror.net>
 <20131002184330.GC5108@cbox>
 <1380744842.12932.77.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380744842.12932.77.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 03:14:02PM -0500, Scott Wood wrote:
> On Wed, 2013-10-02 at 11:43 -0700, Christoffer Dall wrote:
> > On Wed, Oct 02, 2013 at 01:32:38PM -0500, Scott Wood wrote:
> > > On Wed, 2013-10-02 at 13:25 -0500, Yoder Stuart-B08248 wrote:
> > > > 
> > > > > -----Original Message-----
> > > > > From: Christoffer Dall [mailto:christoffer.dall@linaro.org]
> > > > > Sent: Wednesday, October 02, 2013 10:14 AM
> > > > > To: Alex Williamson
> > > > > Cc: Kim Phillips; gregkh@linuxfoundation.org; linux-
> > > > > kernel@vger.kernel.org; a.motakis@virtualopensystems.com; agraf@suse.de;
> > > > > Yoder Stuart-B08248; Wood Scott-B07421; Sethi Varun-B16395; Bhushan
> > > > > Bharat-R65777; peter.maydell@linaro.org; santosh.shukla@linaro.org;
> > > > > kvm@vger.kernel.org
> > > > > Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform
> > > > > device
> > > > > 
> > > > > Wouldn't a sysfs file to add compatibility strings to the vfio-platform
> > > > > driver make driver_match_device return true and make everyone happy?
> > > > 
> > > > I had a similar thought.  Why can't we do something like:
> > > > 
> > > >   echo "fsl,i2c" > /sys/bus/platform/drivers/vfio-platform/new_compatible
> > > >   echo 12ce0000.i2c > /sys/bus/platform/drivers/vfio-platform/bind
> > > > 
> > > > The first steps tell vfio-platform to register itself to handle
> > > > "fsl,i2c" compatible devices.  The second step does the bind.
> > > 
> > > Needing to specify the compatible is hacky (we already know what device
> > > we want to bind; why do we need to scrounge up more information than
> > > that, and add a new sysfs interface for extending compatible matches,
> > > and a more flexible data structure to back that up?), and is racy on
> > > buses that can hotplug (which driver gets the new device?).
> > 
> > Why hacky?  It seems quite reasonable to me that the user has to tell a
> > subsystem that from a certain point it should be capable of handling
> > some device.
> 
> But the reason that driver can handle the device has nothing to do with
> the compatible -- it can handle any device on the bus (except for
> limitations checked for in the probe function), but it's a policy
> decision whether we want it to handle any particular device (as opposed
> to a particular type of device).
> 
> Now, if we end up requiring a device-aware kernel stub for VFIO platform
> devices (as was discussed for handling reset and such), we won't want a
> wildcard match, but we'd still want to say that devices only get bound
> to vfio upon explicit request.  We also would not want userspace adding
> to vfio's compatible list in that case.  So perhaps a flag for "only
> bind on explicit request" should be separate from the ability to supply
> a wildcard match.  VFIO PCI could still use the wildcard match.
> 

I don't disagree on your observations here, the question is only how it
fits with the existing driver/device/bus code.  I just don't think
having a series of flag and having to test all sorts of combination of
those flags to see if any driver can bind to some device sounds very
nice, if we always have the case that, either:

(1) There's one and only one driver for a device
(2) There's the driver itself, and now the user asked for VFIO to bind
    to a device as well.

If we need something more flexible overall for the binding, then yes,
some set of appropriate flags is probably a good idea, but if we're only
trying to solve (2), it seems better to me to keep changes as isolated
to VFIO as possible.

> > As for the data structure, isn't this a simple linked list?
> 
> It could be, but currently it's an array, which is what all the drivers
> are expecting to provide.  Adding a second parallel mechanism (like PCI
> dynid) seems excessive compared to adding a wildcard match (on PCI such
> a mechanism happened to already exist, which made it easy to use for
> this, even if it wasn't necessarily the best approach).  And then what
> happens on non-device-tree platform devices?
> 
> > The problem with the race seems to be a common problem that hasn't even
> > been solved for PCI yet, so I'm wondering if this is not an orthogonal
> > issue with a separate solution, such as a priority or something like
> > that.
> >
> > Yes, once you've added the new_compatible to the vfio-platform driver,
> > it's up for grabs from both the new and the old driver, but that could
> > be solved by always making sure that the vfio-platform driver is checked
> > first.
> 
> ...which is the opposite of what you want if a different device of the
> same type is plugged in after you add the device type ID to vfio.  A
> "bind only by request" flag would avoid that problem.

ok, then reverse the priority.

> 
> As for the possibility that the normal driver would claim it (maybe due
> to the bus being rescanned after a hotplug event?), that could be
> addressed with a mechanism to atomically unbind-and-rebind, or (perhaps
> easier) by making it so that once a device has been explicitly unbound,
> it can only be bound again by explicit request (which would also allow a
> user to say "I don't want to use this device at all" without it getting
> rebound later).
> 
> Better still would be an independent "don't bind by default" flag that
> the user can set in sysfs (this is different from the driver's "don't
> bind by default" flag that is set by the driver), so that the action is
> reversible, and so a user can set this policy regardless of whether a
> driver has been loaded yet.
> 

this does sound reasonable...

> > > What's wrong with a non-vfio-specific flag that a driver can set, that
> > > indicates that the driver is willing to try to bind to any device on the
> > > bus if explicitly requested via the existing sysfs bind mechanism?
> > > 
> > It sounds more hackish to me to invent some 'generic' flag to solve a
> > very specific case. 
> 
> new_compatible would be to solve an even more specific case, but both
> new_compatible and a don't-bind-by-default flag could have applications
> elsewhere.
> 

I'm not a fan of doing something because something "_could_ have
applications elsewhere".  I think we need concrete cases to back up the
choices for doing something in a specific way.  I think that VFIO is one
very specific deviant from how all other driver/device binding works,
and therefore doing something very specific to VFIO, as isolated as
possible to VFIO, is the right thing.

> > What you're suggesting would let users specify that
> > a serial driver should handle a NIC hardware, no?  That sounds much much
> > worse to me.
> 
> The flag (and wildcard match, if applicable) would be set by the driver,
> not by the user.  Whereas PCI's "new_id" and the "new_compatible" being
> suggested in this thread would allow exactly that, assuming the driver
> doesn't reject the device in the probe function.
> 
ok, fair enough, but still, I don't see the _generic_ need for having a
kernel feature that allows some random driver to bind to a device, but
then again, I'm not an authority in this area.

-Christoffer
