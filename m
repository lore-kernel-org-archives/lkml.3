Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbaJJN6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 09:58:13 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46641 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbaJJN6L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 09:58:11 -0400
Date: Fri, 10 Oct 2014 14:58:04 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Message-ID: <20141010135804.GA26646@e102568-lin.cambridge.arm.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
 <2323270.n17xqW47JB@wuerfel>
 <20141009090420.GA16293@e102568-lin.cambridge.arm.com>
 <1831157.eN0OxS7i7m@wuerfel>
MIME-Version: 1.0
In-Reply-To: <1831157.eN0OxS7i7m@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 10 Oct 2014 13:58:08.0337 (UTC) FILETIME=[389F8410:01CFE492]
X-MC-Unique: 114101014580820101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 11:51:43AM +0100, Arnd Bergmann wrote:

[...]

> > Last changes where introduced by commit 8c05cd08a, whose commit log adds
> > to my confusion:
> > 
> > "[...] I think what we want here is for pci_start to be 0 when mmap_api ==
> > PCI_MMAP_PROCFS.[...]"
> > 
> > But that's not what the code does.
> 
> My best guess is that this is a typo and that Darrick meant PCI_MMAP_SYSFS
> in the changelog, which is the same thing that the code does. It's also
> the sensible thing to do.
> 
> This probably means that the procfs interface is now also broken on
> sparc.
> 
> > I will try to grab an integrator board to give it a go.
> 
> Ok, good idea.

Grabbed, tested it, my theory was correct, I can't map PCI resources
to userspace. Actually, if I pass resource offset as a fixed-up address, mmap
succeeds through proc, but it does not mmap the resource, it maps
the resource + mem_offset that happens to be RAM :D for the PCI slot I am
using.

I am testing on an oldish (3.16) kernel since I am having trouble with
mainline PCI and my network adapter on integrator, but I do not see why this
is a problem, this bug has been there forever.

By removing mem_offset from pci_mmap_page_range() everything works fine,
both proc and sys mappings are ok.

> > > > Or we can add mem_offset to the host bridge (after all architectures like
> > > > PowerPC and Microblaze have a pci_mem_offset variable in their host
> > > > controllers), but still, this removes pci_sys_data dependency but does
> > > > not solve the pci_mmap_page_range() issue.
> > > 
> > > The host bridge already stores the mem_offset in terms of the resource
> > > list, so we could readily use that, except that it might break the
> > > powerpc hack if that is still in use.
> > 
> > Well, yes, I am not saying it can't be done by using the resources list,
> > I am just trying to understand if that's really useful.
> 
> The PCI core tries to be ready for PCI host bridges that have multiple
> discontiguous memory spaces with different offsets, although I don't know
> of anybody has that. However if we decide to implement a generic 
> pci_mmap_page_range that tries to take the offset into account, we should
> use the resource list in the host bridge because it can tell us the correct
> offsets.
> 
> However, given what you found, the procfs interface being broken since
> 2010 on both architectures (arm32 and sparc) that try to honor the offset,
> we should probably go back to your previous suggestion of removing
> the offset handling, which would make it possible to use the procfs
> interface and the sysfs interface on all architectures.
> 
> Would you be able to prepare a patch that does this and circulate that
> with the sparc, powerpc and microblaze maintainers as well as Darrick
> and Martin who were involved with the pci_mmap_fits change?

Yes, but let's step back a second. I think that the proc interface
should expect an offset as passed to the user in /proc/bus/pci/devices,
and there the resource is exposed through pci_resource_to_user().

Hence, the pci_mmap_fits() should check the offset against the
resource filtered through pci_resource_to_user(), job done, patch
is trivial, and does what pci_resource_to_user() was meant for IMHO.

Then we have to decide what to do with arm32 code:

1) we remove mem_offset from pci_mmap_page_range() (and rely on default
   pci_resource_to_user())

or

2) we provide pci_resource_to_user() for arm32 which does the CPU->bus
   conversion for us (and leave mem_offset as-is in pci_mmap_range())

Thoughts ?

Thanks,
Lorenzo

