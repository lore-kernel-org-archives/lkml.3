Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab3CQBDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 21:03:25 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:39590 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab3CQBDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 21:03:20 -0400
Date: Sat, 16 Mar 2013 18:03:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Myron Stowe <mstowe@redhat.com>
Cc: Myron Stowe <myron.stowe@redhat.com>, kay@vrfy.org,
        linux-hotplug@vger.kernel.org, alex.williamson@redhat.com,
        linux-pci@vger.kernel.org, yuxiangl@marvell.com, yxlraid@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udevadm-info: Don't access sysfs 'resource<N>' files
Message-ID: <20130317010317.GB9641@kroah.com>
References: <20130316213512.2974.17303.stgit@amt.stowe>
 <20130316213519.2974.38954.stgit@amt.stowe>
 <20130316221159.GA3702@kroah.com>
 <1363477853.2423.25.camel@zim.stowe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363477853.2423.25.camel@zim.stowe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 05:50:53PM -0600, Myron Stowe wrote:
> On Sat, 2013-03-16 at 15:11 -0700, Greg KH wrote:
> > On Sat, Mar 16, 2013 at 03:35:19PM -0600, Myron Stowe wrote:
> > > Sysfs includes entries to memory that backs a PCI device's BARs, both I/O
> > > Port space and MMIO.  This memory regions correspond to the device's
> > > internal status and control registers used to drive the device.
> > > 
> > > Accessing these registers from userspace such as "udevadm info
> > > --attribute-walk --path=/sys/devices/..." does can not be allowed as
> > > such accesses outside of the driver, even just reading, can yield
> > > catastrophic consequences.
> > > 
> > > Udevadm-info skips parsing a specific set of sysfs entries including
> > > 'resource'.  This patch extends the set to include the additional
> > > 'resource<N>' entries that correspond to a PCI device's BARs.
> > 
> > Nice, are you also going to patch bash to prevent a user from reading
> > these sysfs files as well?  :)
> > 
> > And pciutils?
> > 
> > You get my point here, right?  The root user just asked to read all of
> > the data for this device, so why wouldn't you allow it?  Just like
> > 'lspci' does.  Or bash does.
> 
> Yes :P , you raise a very good point, there are a lot of way a user can
> poke around in those BARs.  However, there is a difference between
> shooting yourself in the foot and getting what you deserve versus
> unknowingly executing a common command such as udevadm and having the
> system hang.
> > 
> > If this hardware has a problem, then it needs to be fixed in the kernel,
> > not have random band-aids added to various userspace programs to paper
> > over the root problem here.  Please fix the kernel driver and all should
> > be fine.  No need to change udevadm.
> 
> Xiangliang initially proposed a patch within the PCI core.  Ignoring the
> specific issue with the proposal which I pointed out in the
> https://lkml.org/lkml/2013/3/7/242 thread, that just doesn't seem like
> the right place to effect a change either as PCI's core isn't concerned
> with the contents or access limitations of those regions, those are
> issues that the driver concerns itself with.
> 
> So things seem to be gravitating towards the driver.  I'm fairly
> ignorant of this area but as Robert succinctly pointed out in the
> originating thread - the AHCI driver only uses the device's MMIO region.
> The I/O related regions are for legacy SFF-compatible ATA ports and are
> not used to driver the device.  This, coupled with the observance that
> userspace accesses such as udevadm, and others like you additionally
> point out, do not filter through the device's driver for seems to
> suggest that changes to the driver will not help here either.

A PCI quirk should handle this properly, right?  Why not do that?  Worse
thing, the quirk could just not expose these sysfs files for this
device, which would solve all userspace program issues, right?

thanks,

greg k-h
