Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaBCS7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:59:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54215 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaBCS7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:59:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH] arm64: Add architecture support for PCI
Date: Mon, 03 Feb 2014 19:58:56 +0100
Message-ID: <21596846.kVTqp7roW4@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1391453028-23191-2-git-send-email-Liviu.Dudau@arm.com>
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com> <1391453028-23191-2-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:mRgkDm+K50l9cgHC33qd56YOtPAgHC3InVArw6D6C8B
 4UdP9nCYl+oLSBpDfGOKyoIiVHR7hojndUEeB3Mnge14EqABf0
 yYDJ6A9eYOjVypLbYYOsQROLkViPXwDehsRHAZIgnKqkDgLEW6
 ACLKl1up3SSNiuYkV8SHCAitAP1N3e1IsSye9KQ/pnKz/sqVTu
 depM5ObtAZFqZ3xydBGo/R/S3QtyJC1Qnjk/hvYz+s3+wQeRk5
 xHAy6XdpX6P3R7uwvojBboj3lH71hw/4W1u7w6g5ZQBqjLuqHc
 Hv9RXIyQ+riSIpr39s1NT8FPulh+XO2dKdSHpMSN5LmUZDpwWt
 uQpn/dEA8md25Wz/8FOY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 February 2014 18:43:48 Liviu Dudau wrote:
> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> index 4cc813e..ce5bad2 100644
> --- a/arch/arm64/include/asm/io.h
> +++ b/arch/arm64/include/asm/io.h
> @@ -120,9 +120,13 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
>  /*
>   *  I/O port access primitives.
>   */
> +#define arch_has_dev_port()	(0)

Why not?

>  #define IO_SPACE_LIMIT		0xffff

You probably want to increase this a bit, to allow multiple host bridges
to have their own I/O space.

>  #define PCI_IOBASE		((void __iomem *)(MODULES_VADDR - SZ_2M))

And modify this location: There is no particular reason to have the I/O space
mapped exactly 2MB below the loadable modules, as virtual address space is
essentially free.

> +#define ioport_map(port, nr)	(PCI_IOBASE + ((port) & IO_SPACE_LIMIT))
> +#define ioport_unmap(addr)

inline functions?

>  static inline u8 inb(unsigned long addr)
>  {
>  	return readb(addr + PCI_IOBASE);
> diff --git a/arch/arm64/include/asm/pci.h b/arch/arm64/include/asm/pci.h
> new file mode 100644
> index 0000000..dd084a3
> --- /dev/null
> +++ b/arch/arm64/include/asm/pci.h
> @@ -0,0 +1,35 @@
> +#ifndef __ASM_PCI_H
> +#define __ASM_PCI_H
> +#ifdef __KERNEL__
> +
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/dma-mapping.h>
> +
> +#include <asm/io.h>
> +#include <asm-generic/pci-bridge.h>
> +#include <asm-generic/pci-dma-compat.h>
> +
> +#define PCIBIOS_MIN_IO		0
> +#define PCIBIOS_MIN_MEM		0

PCIBIOS_MIN_IO is normally set to 0x1000, to stay out of the ISA range.

> diff --git a/arch/arm64/kernel/pci.c b/arch/arm64/kernel/pci.c
> new file mode 100644
> index 0000000..7b652cf
> --- /dev/null
> +++ b/arch/arm64/kernel/pci.c
> @@ -0,0 +1,112 @@

None of this looks really arm64 specific, nor should it be. I think
we should try a little harder to move this as a default implementation
into common code, even if we start out by having all architectures
override it.

> +int pci_ioremap_io(unsigned int offset, phys_addr_t phys_addr)
> +{
> +	BUG_ON(offset + SZ_64K - 1 > IO_SPACE_LIMIT);
> +
> +	return ioremap_page_range((unsigned long)PCI_IOBASE + offset,
> +				(unsigned long)PCI_IOBASE + offset + SZ_64K,
> +				phys_addr,
> +				__pgprot(PROT_DEVICE_nGnRE));
> +}

Not sure if we want to treat this one as architecture specific though.
It certainly won't be portable to x86, but it could be shared with
a couple of others. We may also want to redesign the interface.
I've been thinking we could make this function allocate space in the
Linux virtual I/O space aperture, and pass two resources into it
(physical I/O aperture and bus I/O range), and get the actual
io_offset as the return value, or a negative error number.

That way, you could have an arbitrary number of host bridges in the
system and each one gets a share of the virtual aperture until
it's full.

	Arnd
