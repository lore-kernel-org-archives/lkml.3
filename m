Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338AbaCQQFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 12:05:42 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:36331 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaCQQFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 12:05:39 -0400
MIME-Version: 1.0
In-Reply-To: <1394811258-1500-4-git-send-email-Liviu.Dudau@arm.com>
References: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com>
	<1394811258-1500-4-git-send-email-Liviu.Dudau@arm.com>
Date: Mon, 17 Mar 2014 11:05:38 -0500
Message-ID: <CAL_Jsq+9X-9VahsP79mtHN0RC64vRA_2R3ucjX0LefO6q2YN3Q@mail.gmail.com>
Subject: Re: [PATCH v7 3/3] arm64: Add architecture support for PCI
From: Rob Herring <robherring2@gmail.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 10:34 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> Use the generic host bridge functions to provide support for
> PCI Express on arm64. There is no support for ISA memory.
>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> Tested-by: Tanmay Inamdar <tinamdar@apm.com>
> ---
>  arch/arm64/Kconfig            |  19 +++-
>  arch/arm64/include/asm/Kbuild |   1 +
>  arch/arm64/include/asm/io.h   |   3 +-
>  arch/arm64/include/asm/pci.h  |  51 ++++++++++
>  arch/arm64/kernel/Makefile    |   1 +
>  arch/arm64/kernel/pci.c       | 173 ++++++++++++++++++++++++++++++++
>  6 files changed, 246 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm64/include/asm/pci.h
>  create mode 100644 arch/arm64/kernel/pci.c

[snip]

> +#endif
> +
> +extern unsigned long pci_ioremap_io(const struct resource *res, phys_addr_t phys_addr);

Can we at least align the function definition across architectures if
not the implementation.


> +int pci_register_io_range(phys_addr_t address, resource_size_t size)
> +{
> +       struct ioresource *res;
> +       resource_size_t allocated_size = 0;
> +
> +       /* find if the range has not been already allocated */
> +       list_for_each_entry(res, &io_list, list) {
> +               if (address >= res->start &&
> +                       address + size <= res->start + size)
> +                       return 0;
> +               allocated_size += res->size;
> +       }
> +
> +       /* range not already registered, check for space */
> +       if (allocated_size + size > IO_SPACE_LIMIT)

I believe this needs to be "allocated_size + size - 1".

> +               return -E2BIG;
> +
