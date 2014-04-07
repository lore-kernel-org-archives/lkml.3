Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbaDGXWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 19:22:16 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:45713 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbaDGXWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 19:22:12 -0400
MIME-Version: 1.0
In-Reply-To: <1394811272-1547-2-git-send-email-Liviu.Dudau@arm.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com> <1394811272-1547-2-git-send-email-Liviu.Dudau@arm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 7 Apr 2014 17:21:51 -0600
Message-ID: <CAErSpo6S49qNuJQB-XXEfJ1Nkz=4gZ5_hE93=gb_yGZesA1H9Q@mail.gmail.com>
Subject: Re: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper function.
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 9:34 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> Some architectures do not share x86 simple view of the PCI I/O space
> and instead use a range of addresses that map to bus addresses. For
> some architectures these ranges will be expressed by OF bindings
> in a device tree file.
>
> Introduce a pci_register_io_range() helper function that can be used
> by the architecture code to keep track of the I/O ranges described by the
> PCI bindings. If the PCI_IOBASE macro is not defined that signals
> lack of support for PCI and we return an error.
>
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
> +       return -EINVAL;
> +#else
> +       return 0;
> +#endif
> +}

This isn't PCI code, so I'm fine with it in that sense, but I'm not
sure the idea of a PCI_IOBASE #define is really what we need.  It's
not really determined by the processor architecture, it's determined
by the platform.  And a single address isn't enough in general,
either, because if there are multiple host bridges, there's no reason
the apertures that generate PCI I/O transactions need to be contiguous
on the CPU side.

That's just a long way of saying that if we ever came up with a more
generic way to handle I/O port spaces, PCI_IOBASE might go away.  And
I guess part of that rework could be changing this use of it along
with the others.

>  unsigned long __weak pci_address_to_pio(phys_addr_t address)
>  {
>         if (address > IO_SPACE_LIMIT)
> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> index 5f6ed6b..40c418d 100644
> --- a/include/linux/of_address.h
> +++ b/include/linux/of_address.h
> @@ -56,6 +56,7 @@ extern void __iomem *of_iomap(struct device_node *device, int index);
>  extern const __be32 *of_get_address(struct device_node *dev, int index,
>                            u64 *size, unsigned int *flags);
>
> +extern int pci_register_io_range(phys_addr_t addr, resource_size_t size);
>  extern unsigned long pci_address_to_pio(phys_addr_t addr);
>
>  extern int of_pci_range_parser_init(struct of_pci_range_parser *parser,
> --
> 1.9.0
>
