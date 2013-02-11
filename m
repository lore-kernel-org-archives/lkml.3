Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643Ab3BKTnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:43:10 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:64341 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759739Ab3BKTnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:43:06 -0500
Message-ID: <511949C7.7070604@gmail.com>
Date: Mon, 11 Feb 2013 13:43:03 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Andrew Murray <andrew.murray@arm.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] of/pci: Provide support for parsing PCI DT ranges
 property
References: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de> <1360570940-17086-2-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1360570940-17086-2-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 02:22 AM, Thierry Reding wrote:
> From: Andrew Murray <andrew.murray@arm.com>
> 
> DT bindings for PCI host bridges often use the ranges property to describe
> memory and IO ranges - this binding tends to be the same across architectures
> yet several parsing implementations exist, e.g. arch/mips/pci/pci.c,
> arch/powerpc/kernel/pci-common.c, arch/sparc/kernel/pci.c and
> arch/microblaze/pci/pci-common.c (clone of PPC). Some of these duplicate
> functionality provided by drivers/of/address.c.
> 
> This patch provides a common iterator-based parser for the ranges property, it
> is hoped this will reduce DT representation differences between architectures
> and that architectures will migrate in part to this new parser.
> 
> It is also hoped (and the motativation for the patch) that this patch will
> reduce duplication of code when writing host bridge drivers that are supported
> by multiple architectures.
> 
> This patch provides struct resources from a device tree node, e.g.:
> 
> 	u32 *last = NULL;
> 	struct resource res;
> 	while ((last = of_pci_process_ranges(np, res, last))) {
> 		//do something with res
> 	}
> 
> Platforms with quirks can then do what they like with the resource or migrate
> common quirk handling to the parser. In an ideal world drivers can just request
> the obtained resources and pass them on (e.g. pci_add_resource_offset).
> 
> Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
>  drivers/of/address.c       | 63 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_address.h |  9 +++++++
>  2 files changed, 72 insertions(+)
> 
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index 04da786..f607008 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -13,6 +13,7 @@
>  #define OF_CHECK_COUNTS(na, ns)	(OF_CHECK_ADDR_COUNT(na) && (ns) > 0)
>  
>  static struct of_bus *of_match_bus(struct device_node *np);
> +static struct of_bus *of_find_bus(const char *name);

Can you move this function up to avoid the forward declaration.

>  static int __of_address_to_resource(struct device_node *dev,
>  		const __be32 *addrp, u64 size, unsigned int flags,
>  		const char *name, struct resource *r);
> @@ -227,6 +228,57 @@ int of_pci_address_to_resource(struct device_node *dev, int bar,
>  	return __of_address_to_resource(dev, addrp, size, flags, NULL, r);
>  }
>  EXPORT_SYMBOL_GPL(of_pci_address_to_resource);
> +
> +const __be32 *of_pci_process_ranges(struct device_node *node,
> +				    struct resource *res, const __be32 *from)
> +{
> +	const __be32 *start, *end;
> +	int na, ns, np, pna;
> +	int rlen;
> +	struct of_bus *bus;
> +
> +	WARN_ON(!res);
> +
> +	bus = of_find_bus("pci");
> +	bus->count_cells(node, &na, &ns);
> +	if (!OF_CHECK_COUNTS(na, ns)) {
> +		pr_err("Bad cell count for %s\n", node->full_name);
> +		return NULL;
> +	}
> +
> +	pna = of_n_addr_cells(node);
> +	np = pna + na + ns;
> +
> +	start = of_get_property(node, "ranges", &rlen);
> +	if (start == NULL)
> +		return NULL;
> +
> +	end = start + rlen / sizeof(__be32);
> +
> +	if (!from)
> +		from = start;
> +
> +	while (from + np <= end) {
> +		u64 cpu_addr, size;
> +
> +		cpu_addr = of_translate_address(node, from + na);
> +		size = of_read_number(from + na + pna, ns);
> +		res->flags = bus->get_flags(from);
> +		from += np;
> +
> +		if (cpu_addr == OF_BAD_ADDR || size == 0)
> +			continue;
> +
> +		res->name = node->full_name;
> +		res->start = cpu_addr;
> +		res->end = res->start + size - 1;
> +		res->parent = res->child = res->sibling = NULL;
> +		return from;
> +	}
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(of_pci_process_ranges);
>  #endif /* CONFIG_PCI */
>  
>  /*
> @@ -337,6 +389,17 @@ static struct of_bus *of_match_bus(struct device_node *np)
>  	return NULL;
>  }
>  
> +static struct of_bus *of_find_bus(const char *name)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(of_busses); i++)
> +		if (strcmp(name, of_busses[i].name) == 0)
                                              ^
space needed.

> +			return &of_busses[i];
> +
> +	return NULL;
> +}
> +
>  static int of_translate_one(struct device_node *parent, struct of_bus *bus,
>  			    struct of_bus *pbus, __be32 *addr,
>  			    int na, int ns, int pna, const char *rprop)
> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> index 0506eb5..751e889 100644
> --- a/include/linux/of_address.h
> +++ b/include/linux/of_address.h
> @@ -27,6 +27,8 @@ static inline unsigned long pci_address_to_pio(phys_addr_t addr) { return -1; }
>  #define pci_address_to_pio pci_address_to_pio
>  #endif
>  
> +const __be32 *of_pci_process_ranges(struct device_node *node,
> +				    struct resource *res, const __be32 *from);
>  #else /* CONFIG_OF_ADDRESS */
>  #ifndef of_address_to_resource
>  static inline int of_address_to_resource(struct device_node *dev, int index,
> @@ -53,6 +55,13 @@ static inline const __be32 *of_get_address(struct device_node *dev, int index,
>  {
>  	return NULL;
>  }
> +
> +static inline const __be32 *of_pci_process_ranges(struct device_node *node,
> +						  struct resource *res,
> +						  const __be32 *from)
> +{
> +	return NULL;
> +}
>  #endif /* CONFIG_OF_ADDRESS */
>  
>  
> 

