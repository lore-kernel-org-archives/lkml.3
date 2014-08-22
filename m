Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaHVEJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 00:09:12 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:52477 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaHVEJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 00:09:10 -0400
MIME-Version: 1.0
In-Reply-To: <1407860725-25202-5-git-send-email-Liviu.Dudau@arm.com>
References: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com> <1407860725-25202-5-git-send-email-Liviu.Dudau@arm.com>
From: Rob Herring <robherring2@gmail.com>
Date: Thu, 21 Aug 2014 23:08:48 -0500
Message-ID: <CAL_JsqJm6qWNdrJ2F8xddFUj46y42n6hQVu1nkTaA-5Tbg--XQ@mail.gmail.com>
Subject: Re: [PATCH v9 04/12] PCI: OF: Fix the conversion of IO ranges into IO resources.
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 11:25 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> The ranges property for a host bridge controller in DT describes
> the mapping between the PCI bus address and the CPU physical address.
> The resources framework however expects that the IO resources start
> at a pseudo "port" address 0 (zero) and have a maximum size of IO_SPACE_LIMIT.
> The conversion from pci ranges to resources failed to take that into account.
>
> In the process move the function into drivers/of/address.c as it now
> depends on pci_address_to_pio() code and make it return an error code.
>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>

Humm, this says I'm cc'ed, but I'm not which defeats the point of
recording the Cc's in the commit.

I still have the same concerns that this will break existing users.
Are you sure integrator is the only platform affected?

Rob

> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> ---
>  drivers/of/address.c       | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_address.h | 13 ++-----------
>  2 files changed, 48 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index 4dab700..3735ac7 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -906,3 +906,49 @@ bool of_dma_is_coherent(struct device_node *np)
>         return false;
>  }
>  EXPORT_SYMBOL_GPL(of_dma_is_coherent);
> +
> +/*
> + * of_pci_range_to_resource - Create a resource from an of_pci_range
> + * @range:     the PCI range that describes the resource
> + * @np:                device node where the range belongs to
> + * @res:       pointer to a valid resource that will be updated to
> + *              reflect the values contained in the range.
> + *
> + * Returns EINVAL if the range cannot be converted to resource.
> + *
> + * Note that if the range is an IO range, the resource will be converted
> + * using pci_address_to_pio() which can fail if it is called too early or
> + * if the range cannot be matched to any host bridge IO space (our case here).
> + * To guard against that we try to register the IO range first.
> + * If that fails we know that pci_address_to_pio() will do too.
> + */
> +int of_pci_range_to_resource(struct of_pci_range *range,
> +       struct device_node *np, struct resource *res)
> +{
> +       int err;
> +       res->flags = range->flags;
> +       res->parent = res->child = res->sibling = NULL;
> +       res->name = np->full_name;
> +
> +       if (res->flags & IORESOURCE_IO) {
> +               unsigned long port = -1;
> +               err = pci_register_io_range(range->cpu_addr, range->size);
> +               if (err)
> +                       goto invalid_range;
> +               port = pci_address_to_pio(range->cpu_addr);
> +               if (port == (unsigned long)-1) {
> +                       err = -EINVAL;
> +                       goto invalid_range;
> +               }
> +               res->start = port;
> +       } else {
> +               res->start = range->cpu_addr;
> +       }
> +       res->end = res->start + range->size - 1;
> +       return 0;
> +
> +invalid_range:
> +       res->start = (resource_size_t)OF_BAD_ADDR;
> +       res->end = (resource_size_t)OF_BAD_ADDR;
> +       return err;
> +}
> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> index 28e6836..6015f21 100644
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
> +extern int of_pci_range_to_resource(struct of_pci_range *range,
> +               struct device_node *np, struct resource *res);
>  /* Translate a DMA address from device space to CPU space */
>  extern u64 of_translate_dma_address(struct device_node *dev,
>                                     const __be32 *in_addr);
> --
> 2.0.4
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
