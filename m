Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbbALRvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:51:32 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:60244 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbbALRvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:51:31 -0500
Date: Mon, 12 Jan 2015 17:51:25 +0000
From: Will Deacon <will.deacon@arm.com>
To: Rob Herring <robh@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 12/16] pci/host: generic: convert to use generic config
 accesses
Message-ID: <20150112175125.GM13360@arm.com>
References: <1420857290-8373-1-git-send-email-robh@kernel.org>
 <1420857290-8373-13-git-send-email-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420857290-8373-13-git-send-email-robh@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 02:34:46AM +0000, Rob Herring wrote:
> Convert the generic host PCI driver to use the generic config access
> functions.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  drivers/pci/host/pci-host-generic.c | 51 +++----------------------------------
>  1 file changed, 3 insertions(+), 48 deletions(-)

Looks like a fairly straightforward conversion for this driver!

  Acked-by: Will Deacon <will.deacon@arm.com>

Will

> diff --git a/drivers/pci/host/pci-host-generic.c b/drivers/pci/host/pci-host-generic.c
> index 6eb1aa7..925e29e 100644
> --- a/drivers/pci/host/pci-host-generic.c
> +++ b/drivers/pci/host/pci-host-generic.c
> @@ -76,55 +76,9 @@ static struct gen_pci_cfg_bus_ops gen_pci_cfg_ecam_bus_ops = {
>  	.map_bus	= gen_pci_map_cfg_bus_ecam,
>  };
>  
> -static int gen_pci_config_read(struct pci_bus *bus, unsigned int devfn,
> -				int where, int size, u32 *val)
> -{
> -	void __iomem *addr;
> -	struct pci_sys_data *sys = bus->sysdata;
> -	struct gen_pci *pci = sys->private_data;
> -
> -	addr = pci->cfg.ops->map_bus(bus, devfn, where);
> -
> -	switch (size) {
> -	case 1:
> -		*val = readb(addr);
> -		break;
> -	case 2:
> -		*val = readw(addr);
> -		break;
> -	default:
> -		*val = readl(addr);
> -	}
> -
> -	return PCIBIOS_SUCCESSFUL;
> -}
> -
> -static int gen_pci_config_write(struct pci_bus *bus, unsigned int devfn,
> -				 int where, int size, u32 val)
> -{
> -	void __iomem *addr;
> -	struct pci_sys_data *sys = bus->sysdata;
> -	struct gen_pci *pci = sys->private_data;
> -
> -	addr = pci->cfg.ops->map_bus(bus, devfn, where);
> -
> -	switch (size) {
> -	case 1:
> -		writeb(val, addr);
> -		break;
> -	case 2:
> -		writew(val, addr);
> -		break;
> -	default:
> -		writel(val, addr);
> -	}
> -
> -	return PCIBIOS_SUCCESSFUL;
> -}
> -
>  static struct pci_ops gen_pci_ops = {
> -	.read	= gen_pci_config_read,
> -	.write	= gen_pci_config_write,
> +	.read	= pci_generic_config_read,
> +	.write	= pci_generic_config_write,
>  };
>  
>  static const struct of_device_id gen_pci_of_match[] = {
> @@ -287,6 +241,7 @@ static int gen_pci_probe(struct platform_device *pdev)
>  
>  	of_id = of_match_node(gen_pci_of_match, np);
>  	pci->cfg.ops = of_id->data;
> +	gen_pci_ops.map_bus = pci->cfg.ops->map_bus;
>  	pci->host.dev.parent = dev;
>  	INIT_LIST_HEAD(&pci->host.windows);
>  	INIT_LIST_HEAD(&pci->resources);
> -- 
> 2.1.0
> 
> 
