Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211Ab3DJS2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 14:28:39 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:45510 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964881Ab3DJS2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:28:37 -0400
Message-ID: <5165AF52.9000001@gmail.com>
Date: Wed, 10 Apr 2013 13:28:34 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andrew Murray <Andrew.Murray@arm.com>
CC: rob.herring@calxeda.com, siva.kallam@samsung.com,
        linux-pci@vger.kernel.org, Liviu.Dudau@arm.com, paulus@samba.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        jg1.han@samsung.com, jgunthorpe@obsidianresearch.com,
        devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
        bhelgaas@google.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, suren.reddy@samsung.com
Subject: Re: [PATCH v5 3/3] of/pci: mips: convert to common of_pci_range_parser
References: <1365578969-30966-1-git-send-email-Andrew.Murray@arm.com> <1365578969-30966-4-git-send-email-Andrew.Murray@arm.com>
In-Reply-To: <1365578969-30966-4-git-send-email-Andrew.Murray@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 02:29 AM, Andrew Murray wrote:
> This patch converts the pci_load_of_ranges function to use the new common
> of_pci_range_parser.
> 
> Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>

Reviewed-by: Rob Herring <rob.herring@calxeda.com>


> ---
>  arch/mips/pci/pci.c |   50 ++++++++++++++++----------------------------------
>  1 files changed, 16 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
> index 0872f12..bee49a4 100644
> --- a/arch/mips/pci/pci.c
> +++ b/arch/mips/pci/pci.c
> @@ -122,51 +122,33 @@ static void pcibios_scanbus(struct pci_controller *hose)
>  #ifdef CONFIG_OF
>  void pci_load_of_ranges(struct pci_controller *hose, struct device_node *node)
>  {
> -	const __be32 *ranges;
> -	int rlen;
> -	int pna = of_n_addr_cells(node);
> -	int np = pna + 5;
> +	struct of_pci_range_range range;
> +	struct of_pci_range_parser parser;
> +	u32 res_type;
>  
>  	pr_info("PCI host bridge %s ranges:\n", node->full_name);
> -	ranges = of_get_property(node, "ranges", &rlen);
> -	if (ranges == NULL)
> -		return;
>  	hose->of_node = node;
>  
> -	while ((rlen -= np * 4) >= 0) {
> -		u32 pci_space;
> +	if (of_pci_range_parser(&parser, node))
> +		return;
> +
> +	for_each_of_pci_range(&parser, &range) {
>  		struct resource *res = NULL;
> -		u64 addr, size;
> -
> -		pci_space = be32_to_cpup(&ranges[0]);
> -		addr = of_translate_address(node, ranges + 3);
> -		size = of_read_number(ranges + pna + 3, 2);
> -		ranges += np;
> -		switch ((pci_space >> 24) & 0x3) {
> -		case 1:		/* PCI IO space */
> +
> +		res_type = range.flags & IORESOURCE_TYPE_BITS;
> +		if (res_type == IORESOURCE_IO) {
>  			pr_info("  IO 0x%016llx..0x%016llx\n",
> -					addr, addr + size - 1);
> +				range.addr, range.addr + range.size - 1);
>  			hose->io_map_base =
> -				(unsigned long)ioremap(addr, size);
> +				(unsigned long)ioremap(range.addr, range.size);
>  			res = hose->io_resource;
> -			res->flags = IORESOURCE_IO;
> -			break;
> -		case 2:		/* PCI Memory space */
> -		case 3:		/* PCI 64 bits Memory space */
> +		} else if (res_type == IORESOURCE_MEM) {
>  			pr_info(" MEM 0x%016llx..0x%016llx\n",
> -					addr, addr + size - 1);
> +				range.addr, range.addr + range.size - 1);
>  			res = hose->mem_resource;
> -			res->flags = IORESOURCE_MEM;
> -			break;
> -		}
> -		if (res != NULL) {
> -			res->start = addr;
> -			res->name = node->full_name;
> -			res->end = res->start + size - 1;
> -			res->parent = NULL;
> -			res->sibling = NULL;
> -			res->child = NULL;
>  		}
> +		if (res != NULL)
> +			of_pci_range_to_resource(&range, node, res);
>  	}
>  }
>  #endif
> 

