Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbaITAfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 20:35:01 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41321 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392AbaITAe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 20:34:58 -0400
Message-ID: <541CCBA8.8030406@gmail.com>
Date: Fri, 19 Sep 2014 19:34:48 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v11 10/10] PCI: Introduce pci_remap_iospace() for remapping
 PCI I/O bus resources into CPU space
References: <1411003825-21521-1-git-send-email-Liviu.Dudau@arm.com> <1411003825-21521-11-git-send-email-Liviu.Dudau@arm.com>
In-Reply-To: <1411003825-21521-11-git-send-email-Liviu.Dudau@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 08:30 PM, Liviu Dudau wrote:
> Introduce a default implementation for remapping PCI bus I/O resources
> onto the CPU address space. Architectures with special needs may
> provide their own version, but most should be able to use this one.
> 
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Rob Herring <robh+dt@kernel.org>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>

One nit below, otherwise:

Reviewed-by: Rob Herring <robh@kernel.org>

> ---
>  drivers/pci/pci.c             | 33 +++++++++++++++++++++++++++++++++
>  include/asm-generic/pgtable.h |  4 ++++
>  include/linux/pci.h           |  3 +++
>  3 files changed, 40 insertions(+)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 2c9ac70..654b44c 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2704,6 +2704,39 @@ int pci_request_regions_exclusive(struct pci_dev *pdev, const char *res_name)
>  }
>  EXPORT_SYMBOL(pci_request_regions_exclusive);
>  
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
> +				phys_addr, pgprot_device(PAGE_KERNEL));
> +#else
> +	/* this architecture does not have memory mapped I/O space,
> +	   so this function should never be called */
> +	WARN_ON(1);

Printing what the comment says in the warning would be better than
making the user look-up why they got a warning.

Rob

