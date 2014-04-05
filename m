Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaDEAUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 20:20:00 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47291 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbaDEAT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 20:19:58 -0400
Date: Fri, 4 Apr 2014 18:19:53 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper
 function.
Message-ID: <20140405001953.GE15806@google.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <1394811272-1547-2-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394811272-1547-2-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 03:34:27PM +0000, Liviu Dudau wrote:
> Some architectures do not share x86 simple view of the PCI I/O space
> and instead use a range of addresses that map to bus addresses. For
> some architectures these ranges will be expressed by OF bindings
> in a device tree file.

It's true that the current Linux "x86 view of PCI I/O space" is pretty
simple and limited.  But I don't think that's a fundamental x86 limitation
(other than the fact that the actual INB/OUTB/etc. CPU instructions
themselves are limited to a single 64K I/O port space).

Host bridges on x86 could have MMIO apertures that turn CPU memory accesses
into PCI port accesses.  We could implement any number of I/O port spaces
this way, by making the kernel inb()/outb()/etc. interfaces smart enough to
use the memory-mapped space instead of (or in addition to) the
INB/OUTB/etc. instructions.

ia64 does this (see arch/ia64/include/asm/io.h for a little description)
and I think maybe one or two other arches have something similar.

> Introduce a pci_register_io_range() helper function that can be used
> by the architecture code to keep track of the I/O ranges described by the
> PCI bindings. If the PCI_IOBASE macro is not defined that signals
> lack of support for PCI and we return an error.

I don't quite see how you intend to use this, because this series doesn't
include any non-stub implementation of pci_register_io_range().

Is this anything like the ia64 strategy I mentioned above?  If so, it would
be really nice to unify some of this stuff.

> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> Acked-by: Grant Likely <grant.likely@linaro.org>
> Tested-by: Tanmay Inamdar <tinamdar@apm.com>
> ---
>  drivers/of/address.c       | 9 +++++++++
>  include/linux/of_address.h | 1 +
>  2 files changed, 10 insertions(+)
> 
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index 1a54f1f..be958ed 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -619,6 +619,15 @@ const __be32 *of_get_address(struct device_node *dev, int index, u64 *size,
>  }
>  EXPORT_SYMBOL(of_get_address);
>  
> +int __weak pci_register_io_range(phys_addr_t addr, resource_size_t size)
> +{
> +#ifndef PCI_IOBASE
> +	return -EINVAL;
> +#else
> +	return 0;
> +#endif
> +}
> +
>  unsigned long __weak pci_address_to_pio(phys_addr_t address)
>  {
>  	if (address > IO_SPACE_LIMIT)
> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> index 5f6ed6b..40c418d 100644
> --- a/include/linux/of_address.h
> +++ b/include/linux/of_address.h
> @@ -56,6 +56,7 @@ extern void __iomem *of_iomap(struct device_node *device, int index);
>  extern const __be32 *of_get_address(struct device_node *dev, int index,
>  			   u64 *size, unsigned int *flags);
>  
> +extern int pci_register_io_range(phys_addr_t addr, resource_size_t size);
>  extern unsigned long pci_address_to_pio(phys_addr_t addr);
>  
>  extern int of_pci_range_parser_init(struct of_pci_range_parser *parser,
> -- 
> 1.9.0
> 
