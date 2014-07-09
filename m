Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbaGIOMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:12:21 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17589 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbaGIOMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:12:20 -0400
Date: Wed, 9 Jul 2014 10:12:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: konrad@kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/7] xen/pciback: Implement PCI reset slot or bus with
 'do_flr' SysFS attribute
Message-ID: <20140709141211.GF21837@laptop.dumpdata.com>
References: <1404845909-13563-1-git-send-email-konrad@kernel.org>
 <1404845909-13563-5-git-send-email-konrad@kernel.org>
 <53BC324B.5090600@citrix.com>
 <20140708184626.GA15548@laptop.dumpdata.com>
 <53BD364A.5020703@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD364A.5020703@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 01:32:10PM +0100, David Vrabel wrote:
> On 08/07/14 19:46, Konrad Rzeszutek Wilk wrote:
> > On Tue, Jul 08, 2014 at 07:02:51PM +0100, David Vrabel wrote:
> >> On 08/07/14 19:58, konrad@kernel.org wrote:
> >>> --- a/Documentation/ABI/testing/sysfs-driver-pciback
> >>> +++ b/Documentation/ABI/testing/sysfs-driver-pciback
> >>> @@ -82,3 +82,14 @@ Description:
> >>>                  device is shared, enabled, or on a level interrupt line.
> >>>                  Writing a string of DDDD:BB:DD.F will toggle the state.
> >>>                  This is Domain:Bus:Device.Function where domain is optional.
> >>> +
> >>> +What:           /sys/bus/pci/drivers/pciback/do_flr
> >>> +Date:           July 2014
> >>> +KernelVersion:  3.16
> >>> +Contact:        xen-devel@lists.xenproject.org
> >>> +Description:
> >>> +                An option to slot or bus reset an PCI device owned by
> >>> +                Xen PCI backend. Writing a string of DDDD:BB:DD.F will cause
> >>> +                the driver to perform an slot or bus reset if the device
> >>> +                supports. It also checks to make sure that all of the devices
> >>> +                under the bridge are owned by Xen PCI backend.
> >>
> >> Not sure I like this new interface.  I solved this by adding a new reset
> >> file that looked like the regular one the pci would have if it supported
> >> FLR.  I'm fairly sure I posted a series for this.  Was there a reason
> >> you didn't do this?
> > 
> > It did not work.
> > 
> > During bootup kobject would complain about a secondary 'reset' SysFS
> > on the PCI device.
> 
> I think this because of pciback registering a driver too early, before
> the device is fully initialized.  You can see in the trace that it is
> the common pci code that is trying to add the "reset" file so it must be
> doing this /after/ pciback's probe has been called.
> 
> I would consider:
> 
> 1. Removing the "hide" module parameter -- it doesn't work if pciback is
> a module anyway.

I find it incredibly useful and so do a lot of other people.

> 
> 2. Making pciback initialize like a regular driver module (no
> fs_initcall() shenanigans).

The point is to take the PCI device before the drivers touch it.

We want it to be in a pristine state so that the device driver
domains can use it.
> 
> 3. Require userspace to sort out binding the device to pciback (e.g.,
> libxl already does the unbind if requested).

How would you do the bus/slot reset? Or are you thinking that at
that point the 'reset' functionality would be over-written to point
to Xen pciback and it would do the job?

> 
> 4. Finally, I would consider generic driver core functionality for
> prioritizing drivers so they get probed first.

Not sure I understand why you want the drivers to use the device
first? The point is that we can 'hide' them from the generic
drivers and present them to the backend domains.

Regardless of these - I am curious to why you don't like do_flr
as it is even implemented in the the toolstack (but buggy) and
it does a good job of allowing us to do slot/bus reset?

> 
> David
