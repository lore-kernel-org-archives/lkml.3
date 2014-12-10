Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238AbaLJXR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:17:56 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:62601 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519AbaLJXRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:17:51 -0500
Date: Wed, 10 Dec 2014 16:17:46 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: catalin.marinas@arm.com, will.deacon@arm.com, lorenzo.pieralisi@arm.com,
        wangyijing@huawei.com, arnd@arndb.de, hanjun.guo@linaro.org,
        Liviu.Dudau@arm.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rjw@rjwysocki.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 3/6] x86, acpi, pci: Move PCI config space accessors.
Message-ID: <20141210231746.GF6692@google.com>
References: <1416413091-13452-1-git-send-email-tomasz.nowicki@linaro.org>
 <1416413091-13452-4-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416413091-13452-4-git-send-email-tomasz.nowicki@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 05:04:48PM +0100, Tomasz Nowicki wrote:
> We are going to use mmio_config_{} name convention across all architectures.

mmio_config_*() are workarounds for an AMD Fam10h defect [1].  I would prefer
not to extend these names to other architectures, because they should be
able to use readb()/writeb()/etc. directly, as we did on x86 before
3320ad994afb ("x86: Work around mmio config space quirk on AMD Fam10h").

In fact, it would be nice if we could use readb()/writeb()/etc. on x86, and
only use mmio_config_*() when we're on AMD Fam10h.  Maybe there could be a
"struct pci_raw_ops pci_mmcfg_amd_fam10h" that used mmio_config_*(), and we
could set raw_pci_ext_ops to those ops instead of the default ones when
we're on AMD Fam10h.  Then x86 should be able to use the generic
readb()-based ops on most platforms.

Bjorn

[1] 3320ad994afb ("x86: Work around mmio config space quirk on AMD Fam10h")

Somewhere in this process, I'd like to update the AMD Fam10h comment to fix
the typos and reference the spec that talks about this, i.e., the "BIOS and
Kernel Developer's Guide (BKDG) For AMD Family 10h Processors," rev 3.48,
sec 2.11.1, "MMIO Configuration Coding Requirements."

That can be a separate patch since it's only cosmetic.

> Currently it belongs to asm/pci_x86.h header which should be included
> only for x86 specific files. From now on, those accessors are in asm/pci.h
> header which can be included in non-architecture code much easier.
> 
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> Tested-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/x86/include/asm/pci.h     | 42 +++++++++++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/pci_x86.h | 43 ------------------------------------------
>  2 files changed, 42 insertions(+), 43 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
> index 0892ea0..5ba3720 100644
> --- a/arch/x86/include/asm/pci.h
> +++ b/arch/x86/include/asm/pci.h
> @@ -71,6 +71,48 @@ void pcibios_set_master(struct pci_dev *dev);
>  struct irq_routing_table *pcibios_get_irq_routing_table(void);
>  int pcibios_set_irq_routing(struct pci_dev *dev, int pin, int irq);
>  
> +/*
> + * AMD Fam10h CPUs are buggy, and cannot access MMIO config space
> + * on their northbrige except through the * %eax register. As such, you MUST
> + * NOT use normal IOMEM accesses, you need to only use the magic mmio-config
> + * accessor functions.
> + * In fact just use pci_config_*, nothing else please.
> + */
> +static inline unsigned char mmio_config_readb(void __iomem *pos)
> +{
> +	u8 val;
> +	asm volatile("movb (%1),%%al" : "=a" (val) : "r" (pos));
> +	return val;
> +}
> +
> +static inline unsigned short mmio_config_readw(void __iomem *pos)
> +{
> +	u16 val;
> +	asm volatile("movw (%1),%%ax" : "=a" (val) : "r" (pos));
> +	return val;
> +}
> +
> +static inline unsigned int mmio_config_readl(void __iomem *pos)
> +{
> +	u32 val;
> +	asm volatile("movl (%1),%%eax" : "=a" (val) : "r" (pos));
> +	return val;
> +}
> +
> +static inline void mmio_config_writeb(void __iomem *pos, u8 val)
> +{
> +	asm volatile("movb %%al,(%1)" : : "a" (val), "r" (pos) : "memory");
> +}
> +
> +static inline void mmio_config_writew(void __iomem *pos, u16 val)
> +{
> +	asm volatile("movw %%ax,(%1)" : : "a" (val), "r" (pos) : "memory");
> +}
> +
> +static inline void mmio_config_writel(void __iomem *pos, u32 val)
> +{
> +	asm volatile("movl %%eax,(%1)" : : "a" (val), "r" (pos) : "memory");
> +}
>  
>  #define HAVE_PCI_MMAP
>  extern int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
> diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
> index caba141..42e7332 100644
> --- a/arch/x86/include/asm/pci_x86.h
> +++ b/arch/x86/include/asm/pci_x86.h
> @@ -121,49 +121,6 @@ extern int __init pcibios_init(void);
>  extern int pci_legacy_init(void);
>  extern void pcibios_fixup_irqs(void);
>  
> -/*
> - * AMD Fam10h CPUs are buggy, and cannot access MMIO config space
> - * on their northbrige except through the * %eax register. As such, you MUST
> - * NOT use normal IOMEM accesses, you need to only use the magic mmio-config
> - * accessor functions.
> - * In fact just use pci_config_*, nothing else please.
> - */
> -static inline unsigned char mmio_config_readb(void __iomem *pos)
> -{
> -	u8 val;
> -	asm volatile("movb (%1),%%al" : "=a" (val) : "r" (pos));
> -	return val;
> -}
> -
> -static inline unsigned short mmio_config_readw(void __iomem *pos)
> -{
> -	u16 val;
> -	asm volatile("movw (%1),%%ax" : "=a" (val) : "r" (pos));
> -	return val;
> -}
> -
> -static inline unsigned int mmio_config_readl(void __iomem *pos)
> -{
> -	u32 val;
> -	asm volatile("movl (%1),%%eax" : "=a" (val) : "r" (pos));
> -	return val;
> -}
> -
> -static inline void mmio_config_writeb(void __iomem *pos, u8 val)
> -{
> -	asm volatile("movb %%al,(%1)" : : "a" (val), "r" (pos) : "memory");
> -}
> -
> -static inline void mmio_config_writew(void __iomem *pos, u16 val)
> -{
> -	asm volatile("movw %%ax,(%1)" : : "a" (val), "r" (pos) : "memory");
> -}
> -
> -static inline void mmio_config_writel(void __iomem *pos, u32 val)
> -{
> -	asm volatile("movl %%eax,(%1)" : : "a" (val), "r" (pos) : "memory");
> -}
> -
>  #ifdef CONFIG_PCI
>  # ifdef CONFIG_ACPI
>  #  define x86_default_pci_init		pci_acpi_init
> -- 
> 1.9.1
> 
