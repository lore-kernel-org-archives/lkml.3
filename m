Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab3LSUeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:34:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab3LSUd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:33:58 -0500
Date: Thu, 19 Dec 2013 12:34:01 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Kim Phillips <kim.phillips@linaro.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, R65777@freescale.com, B08248@freescale.com,
        christoffer.dall@linaro.org, alex.williamson@redhat.com,
        a.motakis@virtualopensystems.com, agraf@suse.de, B16395@freescale.com
Subject: Re: [REPOST][PATCH 1/2] driver core: Add new device_driver flag to
 allow binding via sysfs only
Message-ID: <20131219203401.GA11290@kroah.com>
References: <20131203123446.42fbff34a8ebd7afd38159a5@linaro.org>
 <20131219010729.GC23055@kroah.com>
 <1387484531.3140.134.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387484531.3140.134.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 02:22:11PM -0600, Scott Wood wrote:
> On Wed, 2013-12-18 at 17:07 -0800, Greg Kroah-Hartman wrote:
> > On Tue, Dec 03, 2013 at 12:34:46PM +0000, Kim Phillips wrote:
> > > VFIO supports pass-through of devices to user space - for sake
> > > of illustration, say a PCI e1000 device:
> > > 
> > > - the e1000 is first unbound from the PCI e1000 driver via sysfs
> > > - the vfio-pci driver is told via new_id that it now handles e1000 devices
> > > - the e1000 is explicitly bound to vfio-pci through sysfs
> > > 
> > > However, now we have two drivers in the system that both handle e1000
> > > devices.  A hotplug event could then occur and it is ambiguous as to which
> > > driver will claim the device.  The desired semantics is that vfio-pci is
> > > only bound to devices by explicit request in sysfs.  This patch makes this
> > > possible by introducing a sysfs_bind_only flag in struct device_driver.
> > 
> > Why deal with this at all and not just deal with the "bind" sysfs file
> > instead?  That way no driver core logic needs to be changed at all, and
> > your userspace tools know _exactly_ which device is being bound to the
> > new device.
> > 
> > Don't mess with the "new_id" file for stuff like this, as you point out,
> > it's "tricky"...
> 
> As discussed before, "bind" does not bypass the ID checks, and thus it
> does not work without either "new_id" or a wildcard match.

Ah, forgot about that.

> Or are you proposing changing "bind" so that it does bypass the ID
> checks?  Or perhaps a new "force_bind" file that does?

No.  But you can use bind/unbind along with the existing new_id file to
get what you want today.  If you just happen to bind a device to a wrong
driver for a while, that's not really a problem, right?

I don't like this patch as we are adding lots of special and odd logic
to the core, for use by almost no one, which ensures that it will never
get tested, and will probably get broken in some subtle way in the
future.

Heck, I can't even ensure that you got it right now, with this tiny
patch, how do you know it works given that there are no users of this
flag anywhere (hint, you never showed me any...)

greg k-h
