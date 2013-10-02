Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab3JBXj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 19:39:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab3JBXjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 19:39:55 -0400
Date: Wed, 2 Oct 2013 16:40:09 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kim Phillips <kim.phillips@linaro.org>,
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
Message-ID: <20131002234009.GA27714@kroah.com>
References: <20131002015355.GD63102@lvm>
 <1380681356.14271.57.camel@ul30vt.home>
 <20131002151413.GG63102@lvm>
 <9F6FE96B71CF29479FF1CDC8046E15036D405D@039-SN1MPN1-003.039d.mgd.msft.net>
 <1380738758.12932.43.camel@snotra.buserror.net>
 <20131002184330.GC5108@cbox>
 <20131002203735.GA10871@kroah.com>
 <1380748121.12932.89.camel@snotra.buserror.net>
 <20131002211631.GA11914@kroah.com>
 <1380749715.12932.109.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380749715.12932.109.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 04:35:15PM -0500, Scott Wood wrote:
> On Wed, 2013-10-02 at 14:16 -0700, gregkh@linuxfoundation.org wrote:
> > On Wed, Oct 02, 2013 at 04:08:41PM -0500, Scott Wood wrote:
> > > On Wed, 2013-10-02 at 13:37 -0700, gregkh@linuxfoundation.org wrote:
> > > > On Wed, Oct 02, 2013 at 11:43:30AM -0700, Christoffer Dall wrote:
> > > > > > What's wrong with a non-vfio-specific flag that a driver can set, that
> > > > > > indicates that the driver is willing to try to bind to any device on the
> > > > > > bus if explicitly requested via the existing sysfs bind mechanism?
> > > > > > 
> > > > > It sounds more hackish to me to invent some 'generic' flag to solve a
> > > > > very specific case.  What you're suggesting would let users specify that
> > > > > a serial driver should handle a NIC hardware, no?  That sounds much much
> > > > > worse to me.
> > > > 
> > > > You can do that today, with any PCI driver (or USB driver as well), just
> > > > use the bind/unbind files in sysfs and you had better "know" what you
> > > > are doing...
> > > 
> > > sysfs bind won't work if it driver_match_device() fails.  PCI has
> > > PCI_ANY_ID, so the missing piece for PCI is a way to say that the driver
> > > should not bind to a device except when explicitly requested via sysfs
> > > bind.
> > > 
> > > I don't see any equivalent functionality to PCI_ANY_ID for platform
> > > devices.
> > 
> > Nor should it.  If you are wanting to bind platform devices to different
> > things based on "ids" or "strings" or something else, then you had
> > better not be using a platform device because that is not what you have
> > anymore.
> 
> I don't see how anything could be considered a platform device under
> your definition.

Devices that you just "know" are at a specific memory location ahead of
time.

> Even before all the device tree stuff came along,
> platform devices were still bound based on strings.

Not all of them, there are lots that are not, look at ISA devices on a
PC platform for one example (your pc speaker, keyboard controller,
etc.)

> > Yes, I know the OF stuff uses platform devices, and again, it's one
> > reason why I don't like it at all.  So fix OF devices "properly",
> > creating your own bus and device type, and then you will not have these
> > issues.
> 
> That's what we used to have...  It was merged with platform bus because
> so many devices may be probed multiple different ways (device tree,
> platform data, ACPI, etc).

And I still say that was a mistake I should have never let happen.  I
think you should handle binding devices to multiple busses in the driver
code for the different drivers, like we already do today for lots of
different devices (USB host controllers being one example.)

> OF is not a bus.

It's a way to describe the device tree to the kernel, and as such, it's
a "bus" as far as the driver model is concerned.  Lots of things are
"busses" for the driver core that you wouldn't think of as a "bus".

A better way to think of busses in the driver core is as a "subsystem".
In fact, we want to change busses to "subsystem" one of these days, udev
has supported that for over 5 years now for when we eventually get
around to it...

> A platform device discovered from OF is still a platform device, just
> as an i2c device discovered from OF is still an i2c device.

Devices don't change what they are just because of what "subsystem" they
are created from.  Again, look at USB host controllers as an example of
that.

> If you don't like devices that don't sit on some formalized bus and can
> be described in more than one way, fine, but that won't make them go
> away.

Think of "subsystem" instead, that should make more sense.

> And even if we did still have a separate OF platform bus, my point about
> there not being a wildcard match applies to of_device_id as well.  It
> certainly is not the case that "this is already there, and has been for
> years with no problems".

That's an OF problem then, feel free to fix it there, but not in the
driver core with a crazy "ignore this bus type string" hack :)

> > greg "I should never have let platform devices be created" k-h
> 
> The alternative is what?  A bunch of duplicated code, with a different
> bus type for every SoC family, just so you can put a name on it?

The amount of duplicated code should be really small.  If it's too
large, let me know and I'll make driver core helpers for it.

thanks,

greg k-h
