Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065Ab3CSQ6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:58:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880Ab3CSQ6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:58:01 -0400
Subject: Re: [PATCH] udevadm-info: Don't access sysfs 'resource<N>' files
From: Myron Stowe <mstowe@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        Myron Stowe <myron.stowe@redhat.com>, linux-hotplug@vger.kernel.org,
        linux-pci@vger.kernel.org, yuxiangl@marvell.com, yxlraid@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1363633176.24132.401.camel@bling.home>
References: <20130316213512.2974.17303.stgit@amt.stowe>
	 <20130316213519.2974.38954.stgit@amt.stowe>
	 <20130316221159.GA3702@kroah.com> <1363477853.2423.25.camel@zim.stowe>
	 <20130317010317.GB9641@kroah.com> <1363493482.16793.69.camel@ul30vt.home>
	 <20130317053611.GC948@kroah.com> <1363527503.16793.75.camel@ul30vt.home>
	 <CAPXgP12vmx9j_jJW3HXb2deRapFKAofTVzEbdyS=Z1VUBswE_Q@mail.gmail.com>
	 <1363623880.24132.351.camel@bling.home> <20130318164126.GA20565@kroah.com>
	 <1363625463.24132.367.camel@bling.home> <87obeg39qp.fsf@nemi.mork.no>
	 <1363629287.24132.380.camel@bling.home>
	 <f153b1ed-69e2-4576-a474-e770b90c87a5@email.android.com>
	 <1363633176.24132.401.camel@bling.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Mar 2013 10:57:49 -0600
Message-ID: <1363712270.2399.62.camel@zim.stowe>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 12:59 -0600, Alex Williamson wrote:
> On Mon, 2013-03-18 at 19:25 +0100, Bjørn Mork wrote:
> > Alex Williamson <alex.williamson@redhat.com> wrote:
> > 
> > >On Mon, 2013-03-18 at 18:20 +0100, Bjørn Mork wrote:
> > >> Alex Williamson <alex.williamson@redhat.com> writes:
> > >> 
> > >> > At least for KVM the kernel fix is the addition of the vfio driver
> > >which
> > >> > gives us a non-sysfs way to do this.  If this problem was found a
> > >few
> > >> > years later and we were ready to make the switch I'd support just
> > >> > removing these resource files.  In the meantime we have userspace
> > >that
> > >> > depends on this interface, so I'm open to suggestions how to fix
> > >it.
> > >> 
> > >> I am puzzled by a couple of things in this discussion:
> > >> 
> > >> 1) do you seriously mean that a userspace application (any, not just
> > >>    udevadm or qemu or whatever) should be able to read and write
> > >these
> > >>    registers while the device is owned by a driver?  How is that ever
> > >>    going to work?
> > >
> > >The expectation is that the user doesn't mess with the device through
> > >pci-sysfs while it's running.  This is really no different than config
> > >space or MMIO space in that respect. 
> > 
> > But it is.  That's the problem. As a user I expect to be able to run
> > e.g "grep . /sys/devices/whatever/*" with no ill effects. This holds
> > for config space or MMIO space. It does not for any reset-on-read
> > register.
> 
> As a non-admin user you can
> 
> > > You can use setpci to break your
> > >PCI card while it's used by the driver today.  The difference is that
> > >MMIO spaces side-step the issue by only allowing mmap and config space
> > >is known not to have read side-effects.
> > 
> > Yes. And that is why there is no problem exporting those. This
> > difference is fundamental. 
> 
> So how do we side-step the problem with I/O port registers?  If we
> remove them then KVM needs to run with iopl which is a pretty serious
> security hole should QEMU be exploited.  We could activate the resource
> files only when the device is bound to pci-assign, but that only limits
> the scope and might break UIO drivers.  We could modify the file to have
> an enable sequence, but we can't do this without breaking current
> userspace.  As I mentioned, the VFIO driver is intended to replace KVM's
> use of these files, but we're not ready to rip it out, perhaps not even
> ready to declare it deprecated.
> 
> > >> 2) is it really so that a device can be so fundamentally screwed up
> > >by
> > >>    reading some registers, that a later driver probe cannot properly
> > >>    reinitialize it?
> > >
> > >Never underestimate how broken hardware can be, 
> > 
> > True :)
> > 
> > > though in this case
> > >reading a device register seems to be causing a system hang/reset.
> > 
> > I understand that it does so if the ahci driver is bound to the device
> > while reading the registers, but does it also hang the system with no
> > bound driver? How does it do that? By killing the bus?
> 
> I don't know, Myron?

Yes - the system hangs when BAR1's (and likely BAR3's) I/O port space is
read.

Here are the details that I've been able to put together from the two
linux-pci threads and various online sources -


>From Robert Hancock - "... BAR5 is the MMIO region used by the AHCI
driver. BARs 0-4 are the legacy SFF-compatible ATA ports.  Nothing
should be messing with those IO ports while AHCI is enabled. ..."  This
likely explains why the system boots and runs fine as long as the
'udevadm ...' command is *not* ran (i.e. the driver never accesses the
I/O port BARs).

Using a SATA controller I have access to as an example for the details
(Note: I do not have access to a system with the Marvell 9125 device):
  00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 6 port  SATA AHCI Controller (rev 06) (prog-if 01 [AHCI 1.0])
  Subsystem: Lenovo Device 2168
  Region 0: I/O ports at 1860 [size=8]
  Region 1: I/O ports at 1814 [size=4]
  Region 2: I/O ports at 1818 [size=8]
  Region 3: I/O ports at 1810 [size=4]
  Region 4: I/O ports at 1840 [size=32]
  Region 5: Memory at f2827000 (32-bit, non-prefetchable) [size=2K]

I/O port registers [1][2]:
  Primary IDE controller  [0x1860-0x1867; 0x1814-0x1817]
  BAR0  Base address for the command block registers for ATA Channel X
    0x1860  (Read/Write): Data Register
    0x1861  (Read): Error Register
    0x1861  (Write): Features Register
    0x1862  (Read/Write): Sector Count Register
    0x1863  (Read/Write): LBA Low Register
    0x1864  (Read/Write): LBA Mid Register
    0x1865  (Read/Write): LBA High Register
    0x1866  (Read/Write): Drive/Head Register
    0x1867  (Read): Status Register
    0x1867  (Write): Command Register
  BAR1* Base address for the control register for ATA Channel X
    0x1814  Reserved
    0x1815  Reserved
    0x1816  (Read): Alternate Status Register
    0x1816  (Write): Device Control Register
    0x1817  Reserved

* The base must be Dword aligned; a PCI requirement.  The Device Control
  and Alternate Status Registers are at ofset 0x2 from this base.

[1] www.t13.org/documents/UploadedDocuments/project/d1510r1-Host-Adapter.pdf
[2] lateblt.tripod.com/atapi.htm

>From Xiangliang - executing 'udevadm ...' causes a 32-bit I/O port read
to BAR1's region.  This is shown by the BE (Byte Enable) value of
0x1111.  So apparently reads to this region that include any of reserved
Bytes causes "the chip will go bad."

So, only a Byte access at offset 2 is successful.  I have not been able
to get any more details as to the exact cause of the hang.  I would have
thought that the PCI transaction would have just timed out, or errored
out, or something but apparently the platform ends up hanging.

It appears that this device did not implement the reserved registers
such that they would return 0 on reads or something more similarly sane.

Since BARs 2 and 3 are not 0, indicating the device only supports one
channel, I expect the same issue will occur when accessing BAR3.  Again,
I do not have access to a system with this device to test with.

> 
> > >> I would have thought that the solution to all this was to return
> > >-EINVAL
> > >> on any attemt to read or write these files while a driver is bound to
> > >> the device.  If userspace is going to use the API, then the
> > >application
> > >> better unbind any driver first.
> > >> 
> > >> Or? Am I missing something here?
> > >
> > >That doesn't really solve anything though.  Let's pretend the resource
> > >files only work while the device is bound to pci-stub.  Now what
> > >happens
> > >when you run this udevadm command as admin while it's in use by the
> > >userspace driver?  All we've done is limit the scope of the problem.
> > 
> > Assuming that the system hangs without driver help and that this
> > brokenness is widespread. I don't think any of those assumptions hold.
> > Do they?
> 
> I thought it was true that for this device a system hang happened
> regardless of the host driver, but haven't seen the original bug report.
> As for widespread, this is the first I've heard of problems in the 2.5+
> years that we've supported these I/O port resource files.  The rest is
> probably just FUD about random userspace apps trolling through device
> registers.
> 
> > >> > If we want to blacklist this specific device, that's fine, but as
> > >others
> > >> > have pointed out it's really a class problem.  Perhaps we report 1
> > >byte
> > >> > extra for the file length where EOF-1 is an enable byte?  Is there
> > >> > anything else in file ops that we could use to make it slightly
> > >more
> > >> > complicated than open(), read() to access the device?  Thanks,
> > >> 
> > >> If there really are devices which cannot handle reading at all, and
> > >> cannot be reset to a sane state by later driver initialization, then
> > >a
> > >> blacklist could be added for those devices.  This should not be a
> > >common
> > >> problem.
> > >
> > >Yes, if these are dead registers, let's blacklist and move along.  I
> > >suspect though that these registers probably work fine if you access
> > >them according to the device programming model, so blacklisting just
> > >prevents full use through something like KVM device assignment. 
> > 
> > Well, if the device is that broken then I think it will require the
> > kernel to police the device programming. I don't see how you can leave
> > a bomb like that because it might be useful in a rare and very
> > theoretical case.
> > 
> > Easier to just blacklist it...
> 
> Easier, yes.  But it likely just kicks the problem down the road until
> the next device.  Thanks,
> 
> Alex
> 
> 


