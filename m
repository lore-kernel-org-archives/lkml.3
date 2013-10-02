Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab3JBUNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:13:14 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:45144 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab3JBUNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:13:12 -0400
Date: Wed, 2 Oct 2013 21:13:07 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Kim Phillips <kim.phillips@linaro.org>
Cc: scottwood@freescale.com, B08248@freescale.com, alex.williamson@redhat.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        a.motakis@virtualopensystems.com, agraf@suse.de, B07421@freescale.com,
        B16395@freescale.com, R65777@freescale.com, peter.maydell@linaro.org,
        santosh.shukla@linaro.org, kvm@vger.kernel.org
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
Message-ID: <20131002201307.GA3029@lvm>
References: <20131001133831.6e46e8e00e09d5d9079fde57@linaro.org>
 <20131001200054.GA27330@kroah.com>
 <20131001170244.ff4fb81d9a7a09598c4c6247@linaro.org>
 <20131002015355.GD63102@lvm>
 <1380681356.14271.57.camel@ul30vt.home>
 <20131002151413.GG63102@lvm>
 <9F6FE96B71CF29479FF1CDC8046E15036D405D@039-SN1MPN1-003.039d.mgd.msft.net>
 <1380738758.12932.43.camel@snotra.buserror.net>
 <20131002184330.GC5108@cbox>
 <20131002150415.458f40ac97cd6ea9de9c590d@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002150415.458f40ac97cd6ea9de9c590d@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 03:04:15PM -0500, Kim Phillips wrote:
> On Wed, 2 Oct 2013 11:43:30 -0700
> Christoffer Dall <christoffer.dall@linaro.org> wrote:
> 
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
> I think what Scott is saying is that the first echo above is somewhat
> redundant with the second: they're both talking to the vfio-platform
> driver about an i2c device.
> 

ok, fair enough, I didn't commit particularly to that interface, but
having a special hook for checking a flag kind of like the strcmp hack
you posted, just seems weird to me; it would be better if the vfio
driver can add the bind string to the list of compatible devices it can
bind to, and then use the generic bind mechanism in the kernel.  But I'm
honestly not familiar enough with the implementaiton specific bits of
the syfs interface to argue how the changes are for one method vs. the
other.

> > As for the data structure, isn't this a simple linked list?
> > 
> > The problem with the race seems to be a common problem that hasn't even
> > been solved for PCI yet, so I'm wondering if this is not an orthogonal
> > issue with a separate solution, such as a priority or something like
> > that.
> 
> I agree; adding 'direct'/'atomic' functionality to the existing bind
> sysfs file, i.e., bind_store() logic to perform device_release_driver()
> logic if dev->driver != NULL, all under the same device_lock() is an
> independent problem from binding the VFIO platform driver to a platform
> device.
> 
> > Yes, once you've added the new_compatible to the vfio-platform driver,
> > it's up for grabs from both the new and the old driver, but that could
> > be solved by always making sure that the vfio-platform driver is checked
> > first.
> 
> not sure I understand the priority problem here - haven't looked at PCI
> yet - but, given the above 'atomic bind' functionality described above,
> the new and old driver wouldn't be requesting to bind to the same
> device simultaneously, no?
> 

AFAIU, the problem occurs with hotplug.  If you add the compatibility
string to a new driver and then hotplug a device with the string, then
which driver gets the device?

> > (I'm not familiar with these data structures, but I would imagine
> > something like re-inserting the vfio-platform driver in the
> > list/tree/... whenever adding a new_compatible value might possibly be
> > one solution).
> > 
> > > What's wrong with a non-vfio-specific flag that a driver can set, that
> > > indicates that the driver is willing to try to bind to any device on the
> > > bus if explicitly requested via the existing sysfs bind mechanism?
> > > 
> > It sounds more hackish to me to invent some 'generic' flag to solve a
> > very specific case.  What you're suggesting would let users specify that
> > a serial driver should handle a NIC hardware, no?  That sounds much much
> > worse to me.
> 
> I thought that was the nature of VFIO drivers...it's a 'meta-' driver,
> used for enabling userspace drivers at large.
> 
Yes, vfio is a meta driver, therefore it needs to be able to do
something special, but the generic driver/device/bus matching framework
doesn't need an extra generic feature allowing you to bind driver X to
device Y for all combinations of X and Y depending on  some flag...
Someone please correct me if there are more use cases for this and this
is in fact worth a generic solution.

-Christoffer
