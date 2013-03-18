Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3CRQvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:51:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab3CRQvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:51:09 -0400
Message-ID: <1363625463.24132.367.camel@bling.home>
Subject: Re: [PATCH] udevadm-info: Don't access sysfs 'resource<N>' files
From: Alex Williamson <alex.williamson@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Myron Stowe <mstowe@redhat.com>,
        Myron Stowe <myron.stowe@redhat.com>, linux-hotplug@vger.kernel.org,
        linux-pci@vger.kernel.org, yuxiangl@marvell.com, yxlraid@gmail.com,
        linux-kernel@vger.kernel.org
Date: Mon, 18 Mar 2013 10:51:03 -0600
In-Reply-To: <20130318164126.GA20565@kroah.com>
References: <20130316213512.2974.17303.stgit@amt.stowe>
	 <20130316213519.2974.38954.stgit@amt.stowe>
	 <20130316221159.GA3702@kroah.com> <1363477853.2423.25.camel@zim.stowe>
	 <20130317010317.GB9641@kroah.com> <1363493482.16793.69.camel@ul30vt.home>
	 <20130317053611.GC948@kroah.com> <1363527503.16793.75.camel@ul30vt.home>
	 <CAPXgP12vmx9j_jJW3HXb2deRapFKAofTVzEbdyS=Z1VUBswE_Q@mail.gmail.com>
	 <1363623880.24132.351.camel@bling.home> <20130318164126.GA20565@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 09:41 -0700, Greg KH wrote:
> On Mon, Mar 18, 2013 at 10:24:40AM -0600, Alex Williamson wrote:
> > On Sun, 2013-03-17 at 15:00 +0100, Kay Sievers wrote:
> > > On Sun, Mar 17, 2013 at 2:38 PM, Alex Williamson
> > > <alex.williamson@redhat.com> wrote:
> > > > I'm assuming that the device only breaks because udevadm is dumping the
> > > > full I/O port register space of the device and that if an actual driver
> > > > was interacting with it through this interface that it would work.  Who
> > > > knows how many devices will have read side-effects by udevadm blindly
> > > > dumping these files.  Thanks,
> > > 
> > > Sysfs is a too public interface to export things there which make
> > > devices/driver choke on a simple read() of an attribute.
> > 
> > That's why the default permissions for the file do not allow users to
> > read it.  I wish we could do something as clever as the MMIO resource
> > files, but I/O port spaces don't allow mmap for the predominant
> > architecture.  Eventually VFIO is meant to replace this access and does
> > move device register access behind ioctls, but for now legacy KVM device
> > assignment relies on these files and so might some UIO drivers.
> > 
> > > This is nothing specific to udevadm, any tool can do that. Udevadm
> > > will never read any of the files during normal operation. The admin
> > > explicitly asked udevadm with a specific command to dump all the stuff
> > > the device offers.
> > 
> > Isn't it possible udevadm could drop privileges or filter out non-world
> > readable files? 
> 
> And you are going to do the same thing for bash?  All other shells?
> 
> Come on, the user specifically asked to read this file, as root, and
> udev did so.  Just like bash would.
> 
> Please fix the kernel if this is a real problem, you aren't going to be
> able to patch all userspace programs, that's not the proper solution
> here.

At least for KVM the kernel fix is the addition of the vfio driver which
gives us a non-sysfs way to do this.  If this problem was found a few
years later and we were ready to make the switch I'd support just
removing these resource files.  In the meantime we have userspace that
depends on this interface, so I'm open to suggestions how to fix it.

If we want to blacklist this specific device, that's fine, but as others
have pointed out it's really a class problem.  Perhaps we report 1 byte
extra for the file length where EOF-1 is an enable byte?  Is there
anything else in file ops that we could use to make it slightly more
complicated than open(), read() to access the device?  Thanks,

Alex

