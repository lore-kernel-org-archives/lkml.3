Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaHSMGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:06:36 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62507 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721AbaHSMGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:06:34 -0400
Date: Tue, 19 Aug 2014 13:05:54 +0100
From: Will Deacon <will.deacon@arm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] drivers: pci: convert generic host controller to DT host
 bridge creation API
Message-ID: <20140819120553.GA23128@arm.com>
References: <1407861695-25549-1-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407861695-25549-1-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

On Tue, Aug 12, 2014 at 05:41:35PM +0100, Liviu Dudau wrote:
> From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> 
> In order to consolidate DT configuration for PCI host controllers in the
> kernel, a new API was introduced that allows creating a host bridge
> and its PCI bus from DT, removing duplicated code present in the
> majority of pci host driver implementations.
> 
> This patch converts the existing PCI generic host controller driver to
> the new API. Most of the code parsing ranges and creating resources is
> now delegated to of_create_pci_host_bridge() API which also triggers
> a scan of the root bus.
> 
> The setup hook passed by the host controller code to the generic DT
> layer completes the initialization by performing resource filtering
> (ie it checks that at least one non-prefetchable memory resource is
> present), remapping IO and configuration regions and initializing
> the required PCI flags.

[...]

> -static void gen_pci_release_of_pci_ranges(struct gen_pci *pci)
> -{
> -	struct pci_host_bridge_window *win;
> -
> -	list_for_each_entry(win, &pci->resources, list)
> -		release_resource(win->res);
> -
> -	pci_free_resource_list(&pci->resources);
> -}

I take it Liviu's core patches take care of this clean-up now if we fail mid
way through requesting the resources?

> -static int gen_pci_setup(int nr, struct pci_sys_data *sys)
> +static int gen_pci_setup(struct pci_host_bridge *host,
> +			 resource_size_t io_cpuaddr)
>  {
> -	struct gen_pci *pci = sys->private_data;
> -	list_splice_init(&pci->resources, &sys->resources);
> -	return 1;
> +	int err;
> +	struct pci_host_bridge_window *window;
> +	u32 restype, prefetchable;
> +	struct device *dev = host->dev.parent;
> +	struct resource *iores = NULL;
> +	bool res_valid = false;
> +
> +	list_for_each_entry(window, &host->windows, list) {
> +		restype = window->res->flags & IORESOURCE_TYPE_BITS;
> +		prefetchable = window->res->flags & IORESOURCE_PREFETCH;
> +
> +		/*
> +		 * Require at least one non-prefetchable MEM resource
> +		 */
> +		if ((restype == IORESOURCE_MEM) && !prefetchable)
> +			res_valid = true;
> +
> +		if (restype == IORESOURCE_IO)
> +			iores = window->res;
> +	}
> +
> +	if (!res_valid) {
> +		dev_err(dev, "non-prefetchable memory resource required\n");
> +		return -EINVAL;
> +	}
> +
> +	if (iores) {
> +		if (!PAGE_ALIGNED(io_cpuaddr))
> +			return -EINVAL;

Why is this alignment check not in the core code? Probably a question for
somebody like Arnd, but do we need to deal with multiple IO resources?
Currently we'll just silently take the last one that we found, which doesn't
sound ideal.

> +		if (err)
> +			return err;
> +	}
> +
> +	/* Parse and map our Configuration Space windows */
> +	err = gen_pci_parse_map_cfg_windows(host);
> +	if (err)
> +		return err;
> +
> +	pci_add_flags(PCI_ENABLE_PROC_DOMAINS);
> +	pci_add_flags(PCI_REASSIGN_ALL_BUS | PCI_REASSIGN_ALL_RSRC);

Why does this belong in the host controller driver and how does it interact
with the probe-only property?

Will
