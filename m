Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbaGNQzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:55:13 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:45727 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755920AbaGNQzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:55:09 -0400
Date: Mon, 14 Jul 2014 17:54:43 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 9/9] pci: Remap I/O bus resources into CPU space with
 pci_remap_iospace()
Message-ID: <20140714165443.GI1112@arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-10-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404240214-9804-10-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 07:43:34PM +0100, Liviu Dudau wrote:
> Introduce a default implementation for remapping PCI bus I/O resources
> onto the CPU address space. Architectures with special needs may
> provide their own version, but most should be able to use this one.
[...]
> +/**
> + *	pci_remap_iospace - Remap the memory mapped I/O space
> + *	@res: Resource describing the I/O space
> + *	@phys_addr: physical address where the range will be mapped.
> + *
> + *	Remap the memory mapped I/O space described by the @res
> + *	into the CPU physical address space. Only architectures
> + *	that have memory mapped IO defined (and hence PCI_IOBASE)
> + *	should call this function.
> + */
> +int __weak pci_remap_iospace(const struct resource *res, phys_addr_t phys_addr)
> +{
> +	int err = -ENODEV;
> +
> +#ifdef PCI_IOBASE
> +	if (!(res->flags & IORESOURCE_IO))
> +		return -EINVAL;
> +
> +	if (res->end > IO_SPACE_LIMIT)
> +		return -EINVAL;
> +
> +	err = ioremap_page_range(res->start + (unsigned long)PCI_IOBASE,
> +				res->end + 1 + (unsigned long)PCI_IOBASE,
> +				phys_addr, __pgprot(PROT_DEVICE_nGnRE));

Except that PROT_DEVICE_nGnRE is arm64 only. I think that's a function
that should remain arch specific.

-- 
Catalin
