Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761172Ab3BMXAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 18:00:00 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:51043 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3BMW77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 17:59:59 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 2/4] of/pci: Add of_pci_get_devfn() function
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1360570940-17086-3-git-send-email-thierry.reding@avionic-design.de>
References: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de> <1360570940-17086-3-git-send-email-thierry.reding@avionic-design.de>
Date: Wed, 13 Feb 2013 22:59:50 +0000
Message-Id: <20130213225950.155F93E3557@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2013 09:22:18 +0100, Thierry Reding <thierry.reding@avionic-design.de> wrote:
> This function can be used to parse the device and function number from a
> standard 5-cell PCI resource. PCI_SLOT() and PCI_FUNC() can be used on
> the returned value obtain the device and function numbers respectively.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
> Changes in v2:
> - rename devfn and err variables for clarity
> 
>  drivers/of/of_pci.c    | 34 +++++++++++++++++++++++++++++-----
>  include/linux/of_pci.h |  1 +

There isn't a whole lot of value in this patch without another user.
I'll need to see the other patches that make use of this.

g.

>  2 files changed, 30 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
> index 13e37e2..4dd7b9b 100644
> --- a/drivers/of/of_pci.c
> +++ b/drivers/of/of_pci.c
> @@ -5,14 +5,15 @@
>  #include <asm/prom.h>
>  
>  static inline int __of_pci_pci_compare(struct device_node *node,
> -				       unsigned int devfn)
> +				       unsigned int data)
>  {
> -	unsigned int size;
> -	const __be32 *reg = of_get_property(node, "reg", &size);
> +	int devfn;
>  
> -	if (!reg || size < 5 * sizeof(__be32))
> +	devfn = of_pci_get_devfn(node);
> +	if (devfn < 0)
>  		return 0;
> -	return ((be32_to_cpup(&reg[0]) >> 8) & 0xff) == devfn;
> +
> +	return devfn == data;
>  }
>  
>  struct device_node *of_pci_find_child_device(struct device_node *parent,
> @@ -40,3 +41,26 @@ struct device_node *of_pci_find_child_device(struct device_node *parent,
>  	return NULL;
>  }
>  EXPORT_SYMBOL_GPL(of_pci_find_child_device);
> +
> +/**
> + * of_pci_get_devfn() - Get device and function numbers for a device node
> + * @np: device node
> + *
> + * Parses a standard 5-cell PCI resource and returns an 8-bit value that can
> + * be passed to the PCI_SLOT() and PCI_FUNC() macros to extract the device
> + * and function numbers respectively. On error a negative error code is
> + * returned.
> + */
> +int of_pci_get_devfn(struct device_node *np)
> +{
> +	unsigned int size;
> +	const __be32 *reg;
> +
> +	reg = of_get_property(np, "reg", &size);
> +
> +	if (!reg || size < 5 * sizeof(__be32))
> +		return -EINVAL;
> +
> +	return (be32_to_cpup(reg) >> 8) & 0xff;
> +}
> +EXPORT_SYMBOL_GPL(of_pci_get_devfn);
> diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
> index bb115de..91ec484 100644
> --- a/include/linux/of_pci.h
> +++ b/include/linux/of_pci.h
> @@ -10,5 +10,6 @@ int of_irq_map_pci(const struct pci_dev *pdev, struct of_irq *out_irq);
>  struct device_node;
>  struct device_node *of_pci_find_child_device(struct device_node *parent,
>  					     unsigned int devfn);
> +int of_pci_get_devfn(struct device_node *np);
>  
>  #endif
> -- 
> 1.8.1.2
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
