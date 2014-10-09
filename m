Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbaJIKwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:52:05 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:49563 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaJIKvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:51:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
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
Date: Thu, 09 Oct 2014 12:51:43 +0200
Message-ID: <1831157.eN0OxS7i7m@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141009090420.GA16293@e102568-lin.cambridge.arm.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com> <2323270.n17xqW47JB@wuerfel> <20141009090420.GA16293@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:q6OZoK7AWMFidScdDuBiEplvnLb2fFFRPxOaFa9yhQr
 oatVMDBvrAAJHjKgEKXvXv/3mOg0J1CW2shdDn9uDnOfX9uutJ
 c8BSC0KtMllfof8JLCxfUA1b6Mc1CchevoP0vVT94azZXFKirg
 5z5PYU79OVY7qwfdeXHXXo1Mguq2QG2PQn1B3JF/dkhOQ3N4tk
 PaYTnxxZga2p9kVBsV02z7Zpch3l4rOu+IukzCZGaW3JRxPow0
 9CGwVl2plUfFKE+LPRBFdE1MipHZLt5wdihzbmsHpc98RaDytT
 HesKIc56jfjfBN1eVAtB0ZaqfkkftTguwIx7ZGyBhnI0YG/CqS
 Vie9ALcj0bRHlG5xvV+E=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 October 2014 10:04:20 Lorenzo Pieralisi wrote:
> On Wed, Oct 08, 2014 at 03:47:43PM +0100, Arnd Bergmann wrote:
> > On Wednesday 08 October 2014 11:19:43 Lorenzo Pieralisi wrote:

> > Please look at the procfs interface again. That one can be defined
> > in two ways (either like sparc and arm, or like powerpc and microblaze)
> > but either one should be able to work with user space that expects
> > that interface and break with user space that expects the other one.
> 
> I agree as long as pci_mmap_page_range() is concerned, but I am
> referring to the pci_mmap_fits() implementation here:
> 
>         start = vma->vm_pgoff;
>         size = ((pci_resource_len(pdev, resno) - 1) >> PAGE_SHIFT) + 1;
>         pci_start = (mmap_api == PCI_MMAP_PROCFS) ?
>                         pci_resource_start(pdev, resno) >> PAGE_SHIFT : 0;
>         if (start >= pci_start && start < pci_start + size &&
>                         start + nr <= pci_start + size)
>                 return 1;
>         return 0;
> 
> pci_mmap_fits(), when mapping from procfs always check the offset against
> resources, which are fixed-up addresses. If we passed the values dumped
> from the device config space (as pci_mmap_page_range() expects on arm) IMHO
> the check above would fail (always referring to platforms where
> mem_offset != 0).

Ah, I see it now too.

> Last changes where introduced by commit 8c05cd08a, whose commit log adds
> to my confusion:
> 
> "[...] I think what we want here is for pci_start to be 0 when mmap_api ==
> PCI_MMAP_PROCFS.[...]"
> 
> But that's not what the code does.

My best guess is that this is a typo and that Darrick meant PCI_MMAP_SYSFS
in the changelog, which is the same thing that the code does. It's also
the sensible thing to do.

This probably means that the procfs interface is now also broken on
sparc.

> I will try to grab an integrator board to give it a go.

Ok, good idea.

> > > Or we can add mem_offset to the host bridge (after all architectures like
> > > PowerPC and Microblaze have a pci_mem_offset variable in their host
> > > controllers), but still, this removes pci_sys_data dependency but does
> > > not solve the pci_mmap_page_range() issue.
> > 
> > The host bridge already stores the mem_offset in terms of the resource
> > list, so we could readily use that, except that it might break the
> > powerpc hack if that is still in use.
> 
> Well, yes, I am not saying it can't be done by using the resources list,
> I am just trying to understand if that's really useful.

The PCI core tries to be ready for PCI host bridges that have multiple
discontiguous memory spaces with different offsets, although I don't know
of anybody has that. However if we decide to implement a generic 
pci_mmap_page_range that tries to take the offset into account, we should
use the resource list in the host bridge because it can tell us the correct
offsets.

However, given what you found, the procfs interface being broken since
2010 on both architectures (arm32 and sparc) that try to honor the offset,
we should probably go back to your previous suggestion of removing
the offset handling, which would make it possible to use the procfs
interface and the sysfs interface on all architectures.

Would you be able to prepare a patch that does this and circulate that
with the sparc, powerpc and microblaze maintainers as well as Darrick
and Martin who were involved with the pci_mmap_fits change?

	Arnd
