Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbaJIJE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:04:58 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45130 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbaJIJE3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:04:29 -0400
Date: Thu, 9 Oct 2014 10:04:20 +0100
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
Message-ID: <20141009090420.GA16293@e102568-lin.cambridge.arm.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
 <3978481.XNAIA6gzAG@wuerfel>
 <20141008101942.GA7179@e102568-lin.cambridge.arm.com>
 <2323270.n17xqW47JB@wuerfel>
MIME-Version: 1.0
In-Reply-To: <2323270.n17xqW47JB@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 09 Oct 2014 09:04:23.0862 (UTC) FILETIME=[05344D60:01CFE3A0]
X-MC-Unique: 114100910042509001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 03:47:43PM +0100, Arnd Bergmann wrote:
> On Wednesday 08 October 2014 11:19:43 Lorenzo Pieralisi wrote:
> > 
> > Ok. So, unless I am missing something, on platform with mem_offset != 0
> > /proc and /sys interfaces for remapping PCI resources can't work (IIUC
> > the proc interface expects the user to pass in the resource address as
> > seen from /proc/bus/pci/devices - which are not BAR values. Even if the
> > user passed the BAR value to mmap, pci_mmap_fits() in proc_bus_pci_mmap()
> > would fail since it compares the pgoff to resource values, which are not
> > BAR values).
> 
> I think you are right for the sysfs interface, that one can't possibly
> work because of the incorrect address computation.
> 
> For the /procfs interface, I think it can work as long as the offsets
> used there are coming from the config space dump in /proc/bus/pci/*
> rather than from the /sys/bus/pci/devices/*/resource file.
>  
> > As things stand I think we can safely remove the mem_offset (and
> > pci_sys_data dependency) from pci_mmap_page_range(). I do not think
> > we can break userspace in any way, basically because it can't work at
> > the moment, again, happy to be corrected if I am wrong, please shout.
> 
> Please look at the procfs interface again. That one can be defined
> in two ways (either like sparc and arm, or like powerpc and microblaze)
> but either one should be able to work with user space that expects
> that interface and break with user space that expects the other one.

I agree as long as pci_mmap_page_range() is concerned, but I am
referring to the pci_mmap_fits() implementation here:

	start = vma->vm_pgoff;
	size = ((pci_resource_len(pdev, resno) - 1) >> PAGE_SHIFT) + 1;
	pci_start = (mmap_api == PCI_MMAP_PROCFS) ?
			pci_resource_start(pdev, resno) >> PAGE_SHIFT : 0;
	if (start >= pci_start && start < pci_start + size &&
			start + nr <= pci_start + size)
		return 1;
	return 0;

pci_mmap_fits(), when mapping from procfs always check the offset against
resources, which are fixed-up addresses. If we passed the values dumped
from the device config space (as pci_mmap_page_range() expects on arm) IMHO
the check above would fail (always referring to platforms where
mem_offset != 0).

Last changes where introduced by commit 8c05cd08a, whose commit log adds
to my confusion:

"[...] I think what we want here is for pci_start to be 0 when mmap_api ==
PCI_MMAP_PROCFS.[...]"

But that's not what the code does.

I will try to grab an integrator board to give it a go.

> > Or we can add mem_offset to the host bridge (after all architectures like
> > PowerPC and Microblaze have a pci_mem_offset variable in their host
> > controllers), but still, this removes pci_sys_data dependency but does
> > not solve the pci_mmap_page_range() issue.
> 
> The host bridge already stores the mem_offset in terms of the resource
> list, so we could readily use that, except that it might break the
> powerpc hack if that is still in use.

Well, yes, I am not saying it can't be done by using the resources list,
I am just trying to understand if that's really useful.

Thank you !
Lorenzo

