Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab3FYVPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:15:22 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:50113 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab3FYVPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:15:19 -0400
Date: Tue, 25 Jun 2013 15:15:16 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/7] PCI: Use pci_walk_bus to detect unassigned
 resources
Message-ID: <20130625211516.GA8494@google.com>
References: <1370066593-22736-1-git-send-email-yinghai@kernel.org>
 <1370066593-22736-3-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370066593-22736-3-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 11:03:08PM -0700, Yinghai Lu wrote:
> Per Bjorn, use pci_walk_bus instead of for_each_pci_dev or
> calling pci_realloc_detect() recursively, that will make code more readable.
> 
> Per Bjorn, separate it from big patch that handing assign_unssigned per root bus.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/setup-bus.c |   46 +++++++++++++++++++++++++++++++---------------
>  1 file changed, 31 insertions(+), 15 deletions(-)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -1427,30 +1427,46 @@ static bool __init pci_realloc_enabled(v
>  	return pci_realloc_enable >= user_enabled;
>  }
>  
> -static void __init pci_realloc_detect(void)
> -{
>  #if defined(CONFIG_PCI_IOV) && defined(CONFIG_PCI_REALLOC_ENABLE_AUTO)
> -	struct pci_dev *dev = NULL;
> +static int __init check_unassigned_resources(struct pci_dev *dev, void *data)

I'm not going to add a function named "check_*()" because the name gives no
clue about what the return value means.  If it's a boolean function, the
name should be something like a question that has a yes/no answer.

> +{
> +	int i;
> +	int *unassigned = data;
>  
> -	if (pci_realloc_enable != undefined)
> -		return;
> +	for (i = PCI_IOV_RESOURCES; i <= PCI_IOV_RESOURCE_END; i++) {
> +		struct resource *r = &dev->resource[i];
>  
> -	for_each_pci_dev(dev) {
> -		int i;
> +		/* Not assigned, or rejected by kernel ? */
> +		if (r->flags && !r->start) {
> +			(*unassigned)++;
> +			return 1; /* return early from pci_walk_bus */
> +		}
> +	}
>  
> -		for (i = PCI_IOV_RESOURCES; i <= PCI_IOV_RESOURCE_END; i++) {
> -			struct resource *r = &dev->resource[i];
> +	return 0;
> +}
>  
> -			/* Not assigned, or rejected by kernel ? */
> -			if (r->flags && !r->start) {
> -				pci_realloc_enable = auto_enabled;
> +static void  __init pci_realloc_detect(void)
> +{
> +	int unassigned = 0;
> +	struct pci_bus *bus;
>  
> -				return;
> -			}
> +	if (pci_realloc_enable != undefined)
> +		return;
> +
> +	list_for_each_entry(bus, &pci_root_buses, node) {
> +		pci_walk_bus(bus, check_unassigned_resources, &unassigned);
> +		if (unassigned) {
> +			pci_realloc_enable = auto_enabled;
> +			return;
>  		}
>  	}
> -#endif
>  }
> +#else
> +static void __init pci_realloc_detect(void)
> +{
> +}
> +#endif
>  
>  /*
>   * first try will not touch pci bridge res
