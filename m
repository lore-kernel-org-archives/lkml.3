Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaKKP56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:57:58 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56277 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaKKP54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:57:56 -0500
Date: Tue, 11 Nov 2014 15:57:44 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <monstr@monstr.eu>,
        Martin Wilck <martin.wilck@ts.fujitsu.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH RFC v2 1/2] drivers: pci: fix pci_mmap_fits()
 implementation for procfs mmap
Message-ID: <20141111155744.GB4419@red-moon>
References: <1414168089-8130-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1414168089-8130-2-git-send-email-lorenzo.pieralisi@arm.com>
 <20141110230454.GA21470@google.com>
 <20141111114825.GA4135@red-moon>
 <CAErSpo4nWpN0xDb3h7FCpExM-Q5fmr5oyuOLf6Y_w55HEQZP4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4nWpN0xDb3h7FCpExM-Q5fmr5oyuOLf6Y_w55HEQZP4w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 02:20:31PM +0000, Bjorn Helgaas wrote:
> On Tue, Nov 11, 2014 at 4:48 AM, Lorenzo Pieralisi
> <lorenzo.pieralisi@arm.com> wrote:
> > On Mon, Nov 10, 2014 at 11:04:54PM +0000, Bjorn Helgaas wrote:
> >> ...
> >> Here's what I think I understand so far:
> >>
> >>   Applications can mmap PCI memory space via either sysfs or procfs (the
> >>   procfs method is deprecated but still supported):
> >>
> >>     - In sysfs, there's a separate /sys/devices/pci*/.../resource* file
> >>       for each device BAR, and the application opens the appropriate
> >>       file and supplies the offset from the beginning of the BAR as the
> >>       mmap(2) offset.
> >>
> >>     - In procfs, the application opens the single /proc/bus/pci/... file
> >>       for the device.  On most platforms, it supplies the CPU physical
> >>       address as the mmap(2) offset.  On a few platforms, such as SPARC,
> >>       it supplies the bus address, i.e., a BAR value, instead.
> >>
> >> But I'm not sure I have this right.  If the procfs offset is either the
> >> CPU physical address or the BAR value, then pci_resource_to_user()
> >> should be (depending on the arch) either a no-op or use
> >> pci_resource_to_bus().
> >
> > Exactly (pcibios_resource_to_bus() ?).
> >
> >> But that's not how it's implemented.  Maybe it *could* be?  If
> >> pci_resource_to_user() gives you something that's not a CPU physical
> >> address and not a bus address, what *does* it give you, and why would we
> >> need this third kind of thing?
> >
> > Well, you need a per arch function implementation where to define if
> > the conversion from CPU physical address to PCI bus should take place
> > or not right ? As you mentioned above, if that should be a per-arch
> > decision, there has to be a per-arch function to filter the resource
> > in question, I guess that's my understanding behind pci_resource_to_user(),
> > but I am not sure either, and understanding that was the primary reason
> > for this patchset so comments are welcome.
> 
> I agree that we need pci_resource_to_user() because arches do
> different things, so we can't just remove pci_resource_to_user() and
> replace it with pci_resource_to_bus().  My point is that we have a
> generic pci_resource_to_user() implementation that does nothing, and
> if an arch *does* implement its own pci_resource_to_user(), it seems
> like it should simply call pci_resource_to_user().

to_bus() you mean. Well, I agree, but I am not sure it would work on all
arches that deviate from the generic implementation, I can't speak for other
architectures since I do not have an in-depth knowledge of their PCI
internal implementations, in particular in relation to CPU <-> PCI
address map conversions/mappings.

I read your comment as an agreement on the approach I took in my patch,
except for the current pci_resource_to_user() implementation(s), which I did
not touch.

Thanks,
Lorenzo
