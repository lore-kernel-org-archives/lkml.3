Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab3JBSnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 14:43:12 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:43896 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab3JBSnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 14:43:10 -0400
Date: Wed, 2 Oct 2013 11:43:30 -0700
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
Message-ID: <20131002184330.GC5108@cbox>
References: <20131001133831.6e46e8e00e09d5d9079fde57@linaro.org>
 <20131001200054.GA27330@kroah.com>
 <20131001170244.ff4fb81d9a7a09598c4c6247@linaro.org>
 <20131002015355.GD63102@lvm>
 <1380681356.14271.57.camel@ul30vt.home>
 <20131002151413.GG63102@lvm>
 <9F6FE96B71CF29479FF1CDC8046E15036D405D@039-SN1MPN1-003.039d.mgd.msft.net>
 <1380738758.12932.43.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380738758.12932.43.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 01:32:38PM -0500, Scott Wood wrote:
> On Wed, 2013-10-02 at 13:25 -0500, Yoder Stuart-B08248 wrote:
> > 
> > > -----Original Message-----
> > > From: Christoffer Dall [mailto:christoffer.dall@linaro.org]
> > > Sent: Wednesday, October 02, 2013 10:14 AM
> > > To: Alex Williamson
> > > Cc: Kim Phillips; gregkh@linuxfoundation.org; linux-
> > > kernel@vger.kernel.org; a.motakis@virtualopensystems.com; agraf@suse.de;
> > > Yoder Stuart-B08248; Wood Scott-B07421; Sethi Varun-B16395; Bhushan
> > > Bharat-R65777; peter.maydell@linaro.org; santosh.shukla@linaro.org;
> > > kvm@vger.kernel.org
> > > Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform
> > > device
> > > 
> > > Wouldn't a sysfs file to add compatibility strings to the vfio-platform
> > > driver make driver_match_device return true and make everyone happy?
> > 
> > I had a similar thought.  Why can't we do something like:
> > 
> >   echo "fsl,i2c" > /sys/bus/platform/drivers/vfio-platform/new_compatible
> >   echo 12ce0000.i2c > /sys/bus/platform/drivers/vfio-platform/bind
> > 
> > The first steps tell vfio-platform to register itself to handle
> > "fsl,i2c" compatible devices.  The second step does the bind.
> 
> Needing to specify the compatible is hacky (we already know what device
> we want to bind; why do we need to scrounge up more information than
> that, and add a new sysfs interface for extending compatible matches,
> and a more flexible data structure to back that up?), and is racy on
> buses that can hotplug (which driver gets the new device?).

Why hacky?  It seems quite reasonable to me that the user has to tell a
subsystem that from a certain point it should be capable of handling
some device.

As for the data structure, isn't this a simple linked list?

The problem with the race seems to be a common problem that hasn't even
been solved for PCI yet, so I'm wondering if this is not an orthogonal
issue with a separate solution, such as a priority or something like
that.

Yes, once you've added the new_compatible to the vfio-platform driver,
it's up for grabs from both the new and the old driver, but that could
be solved by always making sure that the vfio-platform driver is checked
first.

(I'm not familiar with these data structures, but I would imagine
something like re-inserting the vfio-platform driver in the
list/tree/... whenever adding a new_compatible value might possibly be
one solution).

> 
> What's wrong with a non-vfio-specific flag that a driver can set, that
> indicates that the driver is willing to try to bind to any device on the
> bus if explicitly requested via the existing sysfs bind mechanism?
> 
It sounds more hackish to me to invent some 'generic' flag to solve a
very specific case.  What you're suggesting would let users specify that
a serial driver should handle a NIC hardware, no?  That sounds much much
worse to me.

-Christoffer
