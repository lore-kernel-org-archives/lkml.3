Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaGVDQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 23:16:22 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:41123 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbaGVDQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 23:16:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140714163922.GH1112@arm.com>
References: <20140708005954.GC22939@google.com> <20140708104655.GC6501@e106497-lin.cambridge.arm.com>
 <CAErSpo75ovmGoeSHKJN0nckGDy-0gpn8kLPfHQ79CtcXxhPydw@mail.gmail.com>
 <20140708224847.GC4980@e106497-lin.cambridge.arm.com> <CAErSpo5rBt0iF2HGeDD-UH6_sPCoC647VCw0Q1v_0Rdpvcir-w@mail.gmail.com>
 <20140710094758.GA6501@e106497-lin.cambridge.arm.com> <CAErSpo5ZNCY31NztT0cLFbRVsBZqMsZ0LbTFNOTQCZUU3F7qJA@mail.gmail.com>
 <20140711141115.GB16321@arm.com> <CAErSpo7C8qzmdp+XgVi2ysXj_NcgvVY7RVfBZ2PHimLzrzANMQ@mail.gmail.com>
 <20140711180151.GH16321@arm.com> <20140714163922.GH1112@arm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 21 Jul 2014 21:15:58 -0600
Message-ID: <CAErSpo65RBeTgzrVefWBfjnZqTPzyz__HnC4bn8riGGDC0GkHg@mail.gmail.com>
Subject: Re: [PATCH v8 6/9] pci: Introduce a domain number for pci_host_bridge.
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 10:39 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> ...
> Some more thinking, so I guess we could get away without changing the
> API. On top of Liviu's tree here:
>
> http://linux-arm.org/git?p=linux-ld.git;a=shortlog;h=refs/heads/for-upstream/pci_v8
>
> I reverted "pci: Introduce a domain number for pci_host_bridge.":
>
> http://linux-arm.org/git?p=linux-ld.git;a=commitdiff;h=b44e1c7d6b01c436f6f55662a1414e925161c9ca
>
> and added this patch on top (if you agree with the idea, we can split it
> nicely in arm64, OF and PCI specific parts). What we get is the
> domain_nr in a generic structure and free the sysdata pointer for the
> host controller driver.
>
> ----------------8<----------------------------------------
> From b32606aa3997fc8a45014a64f99e921eef4872b0 Mon Sep 17 00:00:00 2001
> From: Catalin Marinas <catalin.marinas@arm.com>
> Date: Mon, 14 Jul 2014 17:20:01 +0100
> Subject: [PATCH] pci: Add support for generic domain_nr in pci_bus
>
> This patch adds domain_nr in struct pci_bus if
> CONFIG_PCI_DOMAINS_GENERIC is enabled. The default implementation for
> pci_domain_nr() simply returns bus->domain_nr. For the root bus, the
> core PCI code calls pci_set_domain_nr(bus, parent_device) while the
> child buses inherit the domain nr of the parent bus.
>
> This patch also adds an of_pci_set_domain_nr() implementation which
> parses the device tree for the "pci-domain" property or sets domain_nr
> to the next available value (this function could also be implemented
> entirely in arm64).
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

I like this.  It seems like a reasonable step forward.  I don't really
like the pci_set_domain_nr() interface because the domain conceptually
exists before the root bus in the domain, but we can deal with that
later.

Tiny nit: please remove the "extern" on the pci_set_domain_nr()
declaration in include/linux/pci.h; we recently removed all the rest
(f39d5b72913e).

I'd really like to see all this stuff in v3.17, but I'm going to be on
vacation for the next three weeks and won't be able to do much until
Aug 11, which is probably going to be in the middle of the merge
window.  But maybe the series can be integrated in -next via an ARM
tree or something.  If it helps, you can add my

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

for this piece.  I don't remember how many other PCI changes are
involved; maybe my ack on this will be enough?  Even if we can't get
it in for the merge window, I'm open to trying to merge it after
v3.17-rc1 if it's isolated enough.

Bjorn

> ---
>  arch/arm64/Kconfig           |  3 +++
>  arch/arm64/include/asm/pci.h | 10 ----------
>  arch/arm64/kernel/pci.c      |  5 +++++
>  drivers/of/of_pci.c          | 20 +++++++++++++-------
>  drivers/pci/probe.c          | 11 ++++++++---
>  include/linux/of_pci.h       |  5 +++++
>  include/linux/pci.h          | 15 +++++++++++++++
>  7 files changed, 49 insertions(+), 20 deletions(-)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 48ed631adde2..2c884f7453ba 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -160,6 +160,9 @@ config PCI
>  config PCI_DOMAINS
>         def_bool PCI
>
> +config PCI_DOMAINS_GENERIC
> +       def_bool PCI
> +
>  config PCI_SYSCALL
>         def_bool PCI
>
> diff --git a/arch/arm64/include/asm/pci.h b/arch/arm64/include/asm/pci.h
> index 3f7856e92d66..4f091a5135b7 100644
> --- a/arch/arm64/include/asm/pci.h
> +++ b/arch/arm64/include/asm/pci.h
> @@ -29,16 +29,6 @@ struct pci_host_bridge *find_pci_host_bridge(struct pci_bus *bus);
>  extern int isa_dma_bridge_buggy;
>
>  #ifdef CONFIG_PCI
> -static inline int pci_domain_nr(struct pci_bus *bus)
> -{
> -       struct pci_host_bridge *bridge = find_pci_host_bridge(bus);
> -
> -       if (bridge)
> -               return bridge->domain_nr;
> -
> -       return 0;
> -}
> -
>  static inline int pci_proc_domain(struct pci_bus *bus)
>  {
>         return 1;
> diff --git a/arch/arm64/kernel/pci.c b/arch/arm64/kernel/pci.c
> index 955d6d1cb011..d5ed1afb0d88 100644
> --- a/arch/arm64/kernel/pci.c
> +++ b/arch/arm64/kernel/pci.c
> @@ -36,3 +36,8 @@ resource_size_t pcibios_align_resource(void *data, const struct resource *res,
>  {
>         return res->start;
>  }
> +
> +void pci_set_domain_nr(struct pci_bus *bus, struct device *parent)
> +{
> +       of_pci_set_domain_nr(bus, parent);
> +}
> diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
> index e81402af5cde..54f06b748bf1 100644
> --- a/drivers/of/of_pci.c
> +++ b/drivers/of/of_pci.c
> @@ -175,7 +175,7 @@ static atomic_t domain_nr = ATOMIC_INIT(-1);
>  struct pci_host_bridge *
>  of_create_pci_host_bridge(struct device *parent, struct pci_ops *ops, void *host_data)
>  {
> -       int err, domain, busno;
> +       int err, busno;
>         struct resource *bus_range;
>         struct pci_bus *root_bus;
>         struct pci_host_bridge *bridge;
> @@ -186,10 +186,6 @@ of_create_pci_host_bridge(struct device *parent, struct pci_ops *ops, void *host
>         if (!bus_range)
>                 return ERR_PTR(-ENOMEM);
>
> -       domain = of_alias_get_id(parent->of_node, "pci-domain");
> -       if (domain == -ENODEV)
> -               domain = atomic_inc_return(&domain_nr);
> -
>         err = of_pci_parse_bus_range(parent->of_node, bus_range);
>         if (err) {
>                 dev_info(parent, "No bus range for %s, using default [0-255]\n",
> @@ -207,8 +203,7 @@ of_create_pci_host_bridge(struct device *parent, struct pci_ops *ops, void *host
>                 goto err_create;
>
>         /* then create the root bus */
> -       root_bus = pci_create_root_bus_in_domain(parent, domain, busno,
> -                                               ops, host_data, &res);
> +       root_bus = pci_create_root_bus(parent, busno, ops, host_data, &res);
>         if (IS_ERR(root_bus)) {
>                 err = PTR_ERR(root_bus);
>                 goto err_create;
> @@ -225,6 +220,17 @@ err_create:
>  }
>  EXPORT_SYMBOL_GPL(of_create_pci_host_bridge);
>
> +void of_pci_set_domain_nr(struct pci_bus *bus, struct device *parent)
> +{
> +       int domain;
> +
> +       domain = of_alias_get_id(parent->of_node, "pci-domain");
> +       if (domain == -ENODEV)
> +               domain = atomic_inc_return(&domain_nr);
> +
> +       bus->domain_nr = domain;
> +}
> +
>  #ifdef CONFIG_PCI_MSI
>
>  static LIST_HEAD(of_pci_msi_chip_list);
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 2c9266237edc..aa30a9e8915d 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -485,7 +485,7 @@ void pci_read_bridge_bases(struct pci_bus *child)
>         }
>  }
>
> -static struct pci_bus *pci_alloc_bus(void)
> +static struct pci_bus *pci_alloc_bus(struct pci_bus *parent)
>  {
>         struct pci_bus *b;
>
> @@ -500,6 +500,10 @@ static struct pci_bus *pci_alloc_bus(void)
>         INIT_LIST_HEAD(&b->resources);
>         b->max_bus_speed = PCI_SPEED_UNKNOWN;
>         b->cur_bus_speed = PCI_SPEED_UNKNOWN;
> +#ifdef CONFIG_PCI_DOMAINS_GENERIC
> +       if (parent)
> +               b->domain_nr = parent->domain_nr;
> +#endif
>         return b;
>  }
>
> @@ -670,7 +674,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
>         /*
>          * Allocate a new bus, and inherit stuff from the parent..
>          */
> -       child = pci_alloc_bus();
> +       child = pci_alloc_bus(parent);
>         if (!child)
>                 return NULL;
>
> @@ -1767,13 +1771,14 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>         bridge->dev.parent = parent;
>         bridge->dev.release = pci_release_host_bridge_dev;
>
> -       b = pci_alloc_bus();
> +       b = pci_alloc_bus(NULL);
>         if (!b)
>                 goto err_out;
>
>         b->sysdata = sysdata;
>         b->ops = ops;
>         b->number = b->busn_res.start = bus;
> +       pci_set_domain_nr(b, parent);
>         b2 = pci_find_bus(pci_domain_nr(b), bus);
>         if (b2) {
>                 /* If we already got to this bus through a different bridge, ignore it */
> diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
> index 71e36d091db2..af16ac40c7a2 100644
> --- a/include/linux/of_pci.h
> +++ b/include/linux/of_pci.h
> @@ -17,6 +17,7 @@ int of_irq_parse_and_map_pci(const struct pci_dev *dev, u8 slot, u8 pin);
>  int of_pci_parse_bus_range(struct device_node *node, struct resource *res);
>  struct pci_host_bridge *of_create_pci_host_bridge(struct device *parent,
>                                         struct pci_ops *ops, void *host_data);
> +void of_pci_set_domain_nr(struct pci_bus *bus, struct device *parent);
>
>  #else
>  static inline int of_irq_parse_pci(const struct pci_dev *pdev, struct of_phandle_args *out_irq)
> @@ -53,6 +54,10 @@ of_create_pci_host_bridge(struct device *parent, struct pci_ops *ops,
>  {
>         return NULL;
>  }
> +
> +static inline void of_pci_set_domain_nr(struct pci_bus *bus, struct device *parent)
> +{
> +}
>  #endif
>
>  #if defined(CONFIG_OF) && defined(CONFIG_PCI_MSI)
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index d32b4ed1f411..9113f62c5038 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -457,6 +457,9 @@ struct pci_bus {
>         unsigned char   primary;        /* number of primary bridge */
>         unsigned char   max_bus_speed;  /* enum pci_bus_speed */
>         unsigned char   cur_bus_speed;  /* enum pci_bus_speed */
> +#ifdef CONFIG_PCI_DOMAINS_GENERIC
> +       int             domain_nr;
> +#endif
>
>         char            name[48];
>
> @@ -1292,6 +1295,18 @@ static inline int pci_domain_nr(struct pci_bus *bus) { return 0; }
>  static inline int pci_proc_domain(struct pci_bus *bus) { return 0; }
>  #endif /* CONFIG_PCI_DOMAINS */
>
> +#ifdef CONFIG_PCI_DOMAINS_GENERIC
> +static inline int pci_domain_nr(struct pci_bus *bus)
> +{
> +       return bus->domain_nr;
> +}
> +extern void pci_set_domain_nr(struct pci_bus *bus, struct device *parent);
> +#else
> +static inline void pci_set_domain_nr(struct pci_bus *bus, struct device *parent)
> +{
> +}
> +#endif
> +
>  /* some architectures require additional setup to direct VGA traffic */
>  typedef int (*arch_set_vga_state_t)(struct pci_dev *pdev, bool decode,
>                       unsigned int command_bits, u32 flags);
