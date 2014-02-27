Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaB0NWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:22:24 -0500
Received: from mail-yk0-f171.google.com ([209.85.160.171]:63102 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaB0NWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:22:20 -0500
MIME-Version: 1.0
X-Originating-IP: [78.145.137.174]
In-Reply-To: <1393506402-11474-2-git-send-email-Liviu.Dudau@arm.com>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com>
	<1393506402-11474-2-git-send-email-Liviu.Dudau@arm.com>
Date: Thu, 27 Feb 2014 13:22:19 +0000
Message-ID: <CAPcvp5EqcKEWoH_--azp+sMykmEWtY5whHG=c9t3sZVXZyAPUg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] pci: OF: Fix the conversion of IO ranges into IO resources.
From: Andrew Murray <amurray@embedded-bits.co.uk>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 February 2014 13:06, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
>
> The ranges property for a host bridge controller in DT describes
> the mapping between the PCI bus address and the CPU physical address.
> The resources framework however expects that the IO resources start
> at a pseudo "port" address 0 (zero) and have a maximum size of 64kb.

Is this just in the case of ARM? (I've tried to keep up with the
conversation, but apologies if I've misunderstood).

> The conversion from pci ranges to resources failed to take that into
> account.
>
> In the process move the function into drivers/of/address.c as it
> now depends on pci_address_to_pio() code.
>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index 1a54f1f..7cf2b16 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -719,3 +719,34 @@ void __iomem *of_iomap(struct device_node *np, int index)
>         return ioremap(res.start, resource_size(&res));
>  }
>  EXPORT_SYMBOL(of_iomap);
> +
> +/**
> + * of_pci_range_to_resource - Create a resource from an of_pci_range
> + * @range:     the PCI range that describes the resource
> + * @np:                device node where the range belongs to
> + * @res:       pointer to a valid resource that will be updated to
> + *              reflect the values contained in the range.
> + * Note that if the range is an IO range, the resource will be converted
> + * using pci_address_to_pio() which can fail if it is called to early or
> + * if the range cannot be matched to any host bridge IO space.
> + */
> +void of_pci_range_to_resource(struct of_pci_range *range,
> +       struct device_node *np, struct resource *res)
> +{
> +       res->flags = range->flags;
> +       if (res->flags & IORESOURCE_IO) {
> +               unsigned long port;
> +               port = pci_address_to_pio(range->pci_addr);

Is this likely to break existing users of of_pci_range_to_resource?

For example arch/mips: IO_SPACE_LIMIT defaults to 0xffff and there is
no overridden implementation for pci_address_to_pio, therefore this
will set res->start to OF_BAD_ADDR whereas previously it would have
been the CPU address for I/O (assuming the cpu_addr was previously >
64K).

I have no idea if I/O previously worked for mips, but this patch seems
to change that behavior. It may be a similar story for microblaze and
powerpc.

Andrew Murray

> +               if (port == (unsigned long)-1) {
> +                       res->start = (resource_size_t)OF_BAD_ADDR;
> +                       res->end = (resource_size_t)OF_BAD_ADDR;
> +                       return;
> +               }
> +               res->start = port;
> +       } else {
> +               res->start = range->cpu_addr;
> +       }
> +       res->end = res->start + range->size - 1;
> +       res->parent = res->child = res->sibling = NULL;
> +       res->name = np->full_name;
> +}
> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> index 5f6ed6b..a667762 100644
> --- a/include/linux/of_address.h
> +++ b/include/linux/of_address.h
> @@ -23,17 +23,8 @@ struct of_pci_range {
>  #define for_each_of_pci_range(parser, range) \
>         for (; of_pci_range_parser_one(parser, range);)
>
> -static inline void of_pci_range_to_resource(struct of_pci_range *range,
> -                                           struct device_node *np,
> -                                           struct resource *res)
> -{
> -       res->flags = range->flags;
> -       res->start = range->cpu_addr;
> -       res->end = range->cpu_addr + range->size - 1;
> -       res->parent = res->child = res->sibling = NULL;
> -       res->name = np->full_name;
> -}
> -
> +extern void of_pci_range_to_resource(struct of_pci_range *range,
> +               struct device_node *np, struct resource *res);
>  /* Translate a DMA address from device space to CPU space */
>  extern u64 of_translate_dma_address(struct device_node *dev,
>                                     const __be32 *in_addr);
> --
> 1.9.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
