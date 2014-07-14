Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbaGNSRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:17:05 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:52383 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaGNSQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:16:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 9/9] pci: Remap I/O bus resources into CPU space with pci_remap_iospace()
Date: Mon, 14 Jul 2014 20:15:48 +0200
Message-ID: <7345495.UDsgOtKzyQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140714165443.GI1112@arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com> <1404240214-9804-10-git-send-email-Liviu.Dudau@arm.com> <20140714165443.GI1112@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:CVju6OEjRIeNVVSfvAFB7WZMXitou9/+DEgsVyWsFKS
 7xxZ2KWHakEwSe7OYTClRh6ER8aXAvzMwpI4FyQCDXWGRjNJ4l
 0eBsIT4QXjbuf3TM5bPORH+DmN17jaGPnnVDGC/MYT0obtZAwa
 pXFyFHTZFMcsVv3eh/P66MTFdagtDC0iv19NB6QI0dBnWA1GxX
 NX1JGVUd0V3zzvXl3Q4VmabULFYUuyNyyyqp45IdG2oC4ngjau
 yTLKEAdPAbO2yz+dKg8BypA7ifVgu6SVgtj0VMDo8HClbTbGfn
 acaq894UGR+lpy/zWiIOR8Yh7wPdIMPnYXTykSdDI+sMlRq8Om
 DTaVcF7cdfpdcEEeQsxI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 July 2014 17:54:43 Catalin Marinas wrote:
> On Tue, Jul 01, 2014 at 07:43:34PM +0100, Liviu Dudau wrote:
> > Introduce a default implementation for remapping PCI bus I/O resources
> > onto the CPU address space. Architectures with special needs may
> > provide their own version, but most should be able to use this one.
> [...]
> > +/**
> > + *   pci_remap_iospace - Remap the memory mapped I/O space
> > + *   @res: Resource describing the I/O space
> > + *   @phys_addr: physical address where the range will be mapped.
> > + *
> > + *   Remap the memory mapped I/O space described by the @res
> > + *   into the CPU physical address space. Only architectures
> > + *   that have memory mapped IO defined (and hence PCI_IOBASE)
> > + *   should call this function.
> > + */
> > +int __weak pci_remap_iospace(const struct resource *res, phys_addr_t phys_addr)
> > +{
> > +     int err = -ENODEV;
> > +
> > +#ifdef PCI_IOBASE
> > +     if (!(res->flags & IORESOURCE_IO))
> > +             return -EINVAL;
> > +
> > +     if (res->end > IO_SPACE_LIMIT)
> > +             return -EINVAL;
> > +
> > +     err = ioremap_page_range(res->start + (unsigned long)PCI_IOBASE,
> > +                             res->end + 1 + (unsigned long)PCI_IOBASE,
> > +                             phys_addr, __pgprot(PROT_DEVICE_nGnRE));
> 
> Except that PROT_DEVICE_nGnRE is arm64 only. I think that's a function
> that should remain arch specific.
> 

How about #defining a macro with the correct pgprot value in asm/pci.h
or asm/pgtable.h?
We can provide a default for that in another architecture independent
location.

	Arnd
