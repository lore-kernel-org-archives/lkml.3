Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab3CRQem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:34:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906Ab3CRQei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:34:38 -0400
Message-ID: <1363624472.24132.358.camel@bling.home>
Subject: Re: [PATCH] udevadm-info: Don't access sysfs 'resource<N>' files
From: Alex Williamson <alex.williamson@redhat.com>
To: Don Dutile <ddutile@redhat.com>
Cc: Myron Stowe <mstowe@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Myron Stowe <myron.stowe@redhat.com>, kay@vrfy.org,
        linux-hotplug@vger.kernel.org, linux-pci@vger.kernel.org,
        yuxiangl@marvell.com, yxlraid@gmail.com, linux-kernel@vger.kernel.org
Date: Mon, 18 Mar 2013 10:34:32 -0600
In-Reply-To: <514729C2.3080308@redhat.com>
References: <20130316213512.2974.17303.stgit@amt.stowe>
	  <20130316213519.2974.38954.stgit@amt.stowe>
	  <20130316221159.GA3702@kroah.com> <1363477853.2423.25.camel@zim.stowe>
	  <20130317010317.GB9641@kroah.com> <1363493482.16793.69.camel@ul30vt.home>
	  <20130317053611.GC948@kroah.com>  <1363527503.16793.75.camel@ul30vt.home>
	  <1363530785.2423.47.camel@zim.stowe>
	 <1363559328.16793.82.camel@ul30vt.home> <514729C2.3080308@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 10:50 -0400, Don Dutile wrote:
> On 03/17/2013 06:28 PM, Alex Williamson wrote:
> > On Sun, 2013-03-17 at 08:33 -0600, Myron Stowe wrote:
> >> On Sun, 2013-03-17 at 07:38 -0600, Alex Williamson wrote:
> >>> On Sat, 2013-03-16 at 22:36 -0700, Greg KH wrote:
> >>>> On Sat, Mar 16, 2013 at 10:11:22PM -0600, Alex Williamson wrote:
> >>>>> On Sat, 2013-03-16 at 18:03 -0700, Greg KH wrote:
> >>>>>> On Sat, Mar 16, 2013 at 05:50:53PM -0600, Myron Stowe wrote:
> >>>>>>> On Sat, 2013-03-16 at 15:11 -0700, Greg KH wrote:
> >>>>>>>> On Sat, Mar 16, 2013 at 03:35:19PM -0600, Myron Stowe wrote:
> >>>>>>>>> Sysfs includes entries to memory that backs a PCI device's BARs, both I/O
> >>>>>>>>> Port space and MMIO.  This memory regions correspond to the device's
> >>>>>>>>> internal status and control registers used to drive the device.
> >>>>>>>>>
> >>>>>>>>> Accessing these registers from userspace such as "udevadm info
> >>>>>>>>> --attribute-walk --path=/sys/devices/..." does can not be allowed as
> >>>>>>>>> such accesses outside of the driver, even just reading, can yield
> >>>>>>>>> catastrophic consequences.
> >>>>>>>>>
> >>>>>>>>> Udevadm-info skips parsing a specific set of sysfs entries including
> >>>>>>>>> 'resource'.  This patch extends the set to include the additional
> >>>>>>>>> 'resource<N>' entries that correspond to a PCI device's BARs.
> >>>>>>>>
> >>>>>>>> Nice, are you also going to patch bash to prevent a user from reading
> >>>>>>>> these sysfs files as well?  :)
> >>>>>>>>
> >>>>>>>> And pciutils?
> >>>>>>>>
> >>>>>>>> You get my point here, right?  The root user just asked to read all of
> >>>>>>>> the data for this device, so why wouldn't you allow it?  Just like
> >>>>>>>> 'lspci' does.  Or bash does.
> >>>>>>>
> >>>>>>> Yes :P , you raise a very good point, there are a lot of way a user can
> >>>>>>> poke around in those BARs.  However, there is a difference between
> >>>>>>> shooting yourself in the foot and getting what you deserve versus
> >>>>>>> unknowingly executing a common command such as udevadm and having the
> >>>>>>> system hang.
> >>>>>>>>
> >>>>>>>> If this hardware has a problem, then it needs to be fixed in the kernel,
> >>>>>>>> not have random band-aids added to various userspace programs to paper
> >>>>>>>> over the root problem here.  Please fix the kernel driver and all should
> >>>>>>>> be fine.  No need to change udevadm.
> >>>>>>>
> >>>>>>> Xiangliang initially proposed a patch within the PCI core.  Ignoring the
> >>>>>>> specific issue with the proposal which I pointed out in the
> >>>>>>> https://lkml.org/lkml/2013/3/7/242 thread, that just doesn't seem like
> >>>>>>> the right place to effect a change either as PCI's core isn't concerned
> >>>>>>> with the contents or access limitations of those regions, those are
> >>>>>>> issues that the driver concerns itself with.
> >>>>>>>
> >>>>>>> So things seem to be gravitating towards the driver.  I'm fairly
> >>>>>>> ignorant of this area but as Robert succinctly pointed out in the
> >>>>>>> originating thread - the AHCI driver only uses the device's MMIO region.
> >>>>>>> The I/O related regions are for legacy SFF-compatible ATA ports and are
> >>>>>>> not used to driver the device.  This, coupled with the observance that
> >>>>>>> userspace accesses such as udevadm, and others like you additionally
> >>>>>>> point out, do not filter through the device's driver for seems to
> >>>>>>> suggest that changes to the driver will not help here either.
> >>>>>>
> >>>>>> A PCI quirk should handle this properly, right?  Why not do that?  Worse
> >>>>>> thing, the quirk could just not expose these sysfs files for this
> >>>>>> device, which would solve all userspace program issues, right?
> >>>>>
> >>>>> Not exactly.  I/O port access through pci-sysfs was added for userspace
> >>>>> programs, specifically qemu-kvm device assignment.  We use the I/O port
> >>>>> resource# files to access device owned I/O port registers using file
> >>>>> permissions rather than global permissions such as iopl/ioperm.  File
> >>>>> permissions also prevent random users from accessing device registers
> >>>>> through these files, but of course can't stop a privileged app that
> >>>>> chooses to ignore the purpose of these files.  A quirk would therefore
> >>>>> remove a file that actually has a useful purpose for one app just so
> >>>>> another app that has no particular reason for dumping the contents can
> >>>>> run unabated.  Thanks,
> >>>>
> >>>> The quirk would only be for this one specific device, which obviously
> >>>> can't handle this type of access, so why would you want the sysfs files
> >>>> even present for it at all?
> >>>
> >>> I'm assuming that the device only breaks because udevadm is dumping the
> >>> full I/O port register space of the device and that if an actual driver
> >>> was interacting with it through this interface that it would work.
> >>
> >> Correct:
> >>          the AHCI driver only uses the device's MMIO region.  The I/O
> >>          related regions are for legacy SFF-compatible ATA ports and are
> >>          not used to driver the device.  This, coupled with the
> >>          observance that userspace accesses such as udevadm, and others
> >>          like Greg additionally pointed out, do not filter through the
> >>          device's driver seems to suggest that changes to the driver will
> >>          not help here either.
> >
> > That may be true of our AHCI driver, but when it's assigned to a guest
> > we're potentially using a completely different stack and cannot make
> > that assumption.  A guest running in compatibility mode or the option
> > ROM for the device may still use I/O port regions.  Thanks,
> >
> > Alex
> >
> >
> 
> In quick summary:
> (1)reading a device's registers may have side effects
>      on the device operation, e.g., a register maps to a device's FIFO register.
> (2) Having two threads read such device registers can cause unknown results,
>       i.e., driver & user-app.
> (3) It may be valid for a user-app to read device regs, e.g.,
>      qemu-kvm assigned device
> 
> So, can't it be solved by:
> (a) if no driver is configured for the device, than it's valid for a user-app
>      to read the device regs ?
>       -- although diff. user apps doing so still exposes the problem, and
>          can't be distinguished, e.g.,  	qemu-kvm + udevadm
> 		-- or can file permissions (set by libvirt driving qemu-kvm
> 		   device assignment) block multiple user-app reading ?
> 		   i.e., basically, a user-level version of a driver allocating
> 			 the device, which in the case of qemu-kvm device-assignment,
> 			 is what is actually happening! :)
> (b) if driver is configured, need a quirk-registration, or generic, optional,
> 	driver function to check for user-app reading approval.
> 
> ok, bash away...


I think concurrency is a secondary issue.  The primary issue is whether
read() is somehow so special in sysfs that all files need to be regarded
as o+r.  If that's true, then indeed there are concurrency issues.
Thanks,

Alex

