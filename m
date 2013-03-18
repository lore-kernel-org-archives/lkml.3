Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3CRRzC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 13:55:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308Ab3CRRzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 13:55:00 -0400
Message-ID: <1363629287.24132.380.camel@bling.home>
Subject: Re: [PATCH] udevadm-info: Don't access sysfs 'resource<N>' files
From: Alex Williamson <alex.williamson@redhat.com>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        Myron Stowe <mstowe@redhat.com>, Myron Stowe <myron.stowe@redhat.com>,
        linux-hotplug@vger.kernel.org, linux-pci@vger.kernel.org,
        yuxiangl@marvell.com, yxlraid@gmail.com, linux-kernel@vger.kernel.org
Date: Mon, 18 Mar 2013 11:54:47 -0600
In-Reply-To: <87obeg39qp.fsf@nemi.mork.no>
References: <20130316213512.2974.17303.stgit@amt.stowe>
	 <20130316213519.2974.38954.stgit@amt.stowe>
	 <20130316221159.GA3702@kroah.com> <1363477853.2423.25.camel@zim.stowe>
	 <20130317010317.GB9641@kroah.com> <1363493482.16793.69.camel@ul30vt.home>
	 <20130317053611.GC948@kroah.com> <1363527503.16793.75.camel@ul30vt.home>
	 <CAPXgP12vmx9j_jJW3HXb2deRapFKAofTVzEbdyS=Z1VUBswE_Q@mail.gmail.com>
	 <1363623880.24132.351.camel@bling.home> <20130318164126.GA20565@kroah.com>
	 <1363625463.24132.367.camel@bling.home> <87obeg39qp.fsf@nemi.mork.no>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 18:20 +0100, Bjørn Mork wrote:
> Alex Williamson <alex.williamson@redhat.com> writes:
> 
> > At least for KVM the kernel fix is the addition of the vfio driver which
> > gives us a non-sysfs way to do this.  If this problem was found a few
> > years later and we were ready to make the switch I'd support just
> > removing these resource files.  In the meantime we have userspace that
> > depends on this interface, so I'm open to suggestions how to fix it.
> 
> I am puzzled by a couple of things in this discussion:
> 
> 1) do you seriously mean that a userspace application (any, not just
>    udevadm or qemu or whatever) should be able to read and write these
>    registers while the device is owned by a driver?  How is that ever
>    going to work?

The expectation is that the user doesn't mess with the device through
pci-sysfs while it's running.  This is really no different than config
space or MMIO space in that respect.  You can use setpci to break your
PCI card while it's used by the driver today.  The difference is that
MMIO spaces side-step the issue by only allowing mmap and config space
is known not to have read side-effects.

> 2) is it really so that a device can be so fundamentally screwed up by
>    reading some registers, that a later driver probe cannot properly
>    reinitialize it?

Never underestimate how broken hardware can be, though in this case
reading a device register seems to be causing a system hang/reset.

> I would have thought that the solution to all this was to return -EINVAL
> on any attemt to read or write these files while a driver is bound to
> the device.  If userspace is going to use the API, then the application
> better unbind any driver first.
> 
> Or? Am I missing something here?

That doesn't really solve anything though.  Let's pretend the resource
files only work while the device is bound to pci-stub.  Now what happens
when you run this udevadm command as admin while it's in use by the
userspace driver?  All we've done is limit the scope of the problem.

> > If we want to blacklist this specific device, that's fine, but as others
> > have pointed out it's really a class problem.  Perhaps we report 1 byte
> > extra for the file length where EOF-1 is an enable byte?  Is there
> > anything else in file ops that we could use to make it slightly more
> > complicated than open(), read() to access the device?  Thanks,
> 
> If there really are devices which cannot handle reading at all, and
> cannot be reset to a sane state by later driver initialization, then a
> blacklist could be added for those devices.  This should not be a common
> problem.

Yes, if these are dead registers, let's blacklist and move along.  I
suspect though that these registers probably work fine if you access
them according to the device programming model, so blacklisting just
prevents full use through something like KVM device assignment.  Thanks,

Alex


