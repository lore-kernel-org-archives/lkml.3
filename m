Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaDEAAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 20:00:14 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:57673 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbaDEAAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 20:00:12 -0400
Date: Fri, 4 Apr 2014 18:00:07 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
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
Subject: Re: [PATCH v7 4/6] pci: Introduce a domain number for
 pci_host_bridge.
Message-ID: <20140405000007.GD15806@google.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <1394811272-1547-5-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394811272-1547-5-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 03:34:30PM +0000, Liviu Dudau wrote:
> Make it easier to discover the domain number of a bus by storing
> the number in pci_host_bridge for the root bus. Several architectures
> have their own way of storing this information, so it makes sense
> to try to unify the code. 

I like the idea of unifying the way we handle the domain number.  But 
I'd like to see more of the strategy before committing to this approach.

This patch adds struct pci_host_bridge.domain_nr, but of course
pci_domain_nr() doesn't use it.  It can't today, because
pci_create_root_bus() relies on pci_domain_nr() to fill in
pci_host_bridge.domain_nr.

But I suppose the intent is that someday we can make pci_domain_nr()
arch-independent somehow.  I'd just like to see more of the path to
that happening.

> While at this, add a new function that
> creates a root bus in a given domain and make pci_create_root_bus()
> a wrapper around this function.

I'm a little concerned about adding a new "create root bus" interface,
partly because we have quite a few already, and I'd like to reduce the
number of them instead of adding more.  And I think there might be other
similar opportunities for unification, so I could easily see us adding new
functions in the future to unify NUMA node info, ECAM info, etc.

I wonder if we need some sort of descriptor structure that the arch could
fill in and pass to the PCI core.  Then we could add new members without
having to create new interfaces each time.

> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> Tested-by: Tanmay Inamdar <tinamdar@apm.com>
> ---
>  drivers/pci/probe.c | 41 +++++++++++++++++++++++++++++++++--------
>  include/linux/pci.h |  4 ++++
>  2 files changed, 37 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index fd11c12..172c615 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1714,8 +1714,9 @@ void __weak pcibios_remove_bus(struct pci_bus *bus)
>  {
>  }
>  
> -struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
> -		struct pci_ops *ops, void *sysdata, struct list_head *resources)
> +struct pci_bus *pci_create_root_bus_in_domain(struct device *parent,
> +		int domain, int bus, struct pci_ops *ops, void *sysdata,
> +		struct list_head *resources)
>  {
>  	int error;
>  	struct pci_host_bridge *bridge;
> @@ -1728,30 +1729,34 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>  
>  	bridge = pci_alloc_host_bridge();
>  	if (!bridge)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  
>  	bridge->dev.parent = parent;
>  	bridge->dev.release = pci_release_host_bridge_dev;
> +	bridge->domain_nr = domain;
>  	error = pcibios_root_bridge_prepare(bridge);
>  	if (error)
>  		goto err_out;
>  
>  	b = pci_alloc_bus();
> -	if (!b)
> +	if (!b) {
> +		error = -ENOMEM;
>  		goto err_out;
> +	}
>  
>  	b->sysdata = sysdata;
>  	b->ops = ops;
>  	b->number = b->busn_res.start = bus;
> -	b2 = pci_find_bus(pci_domain_nr(b), bus);
> +	b2 = pci_find_bus(bridge->domain_nr, bus);
>  	if (b2) {
>  		/* If we already got to this bus through a different bridge, ignore it */
>  		dev_dbg(&b2->dev, "bus already known\n");
> +		error = -EEXIST;
>  		goto err_bus_out;
>  	}
>  
>  	bridge->bus = b;
> -	dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(b), bus);
> +	dev_set_name(&bridge->dev, "pci%04x:%02x", bridge->domain_nr, bus);
>  	error = device_register(&bridge->dev);
>  	if (error) {
>  		put_device(&bridge->dev);
> @@ -1766,7 +1771,7 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>  
>  	b->dev.class = &pcibus_class;
>  	b->dev.parent = b->bridge;
> -	dev_set_name(&b->dev, "%04x:%02x", pci_domain_nr(b), bus);
> +	dev_set_name(&b->dev, "%04x:%02x", bridge->domain_nr, bus);
>  	error = device_register(&b->dev);
>  	if (error)
>  		goto class_dev_reg_err;
> @@ -1816,7 +1821,27 @@ err_bus_out:
>  	kfree(b);
>  err_out:
>  	kfree(bridge);
> -	return NULL;
> +	return ERR_PTR(error);
> +}
> +
> +struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
> +		struct pci_ops *ops, void *sysdata, struct list_head *resources)
> +{
> +	int domain_nr;
> +	struct pci_bus *b = pci_alloc_bus();
> +	if (!b)
> +		return NULL;
> +
> +	b->sysdata = sysdata;
> +	domain_nr = pci_domain_nr(b);
> +	kfree(b);
> +
> +	b = pci_create_root_bus_in_domain(parent, domain_nr, bus,
> +				ops, sysdata, resources);
> +	if (IS_ERR(b))
> +		return NULL;
> +
> +	return b;
>  }
>  
>  int pci_bus_insert_busn_res(struct pci_bus *b, int bus, int bus_max)
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 33aa2ca..1eed009 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -394,6 +394,7 @@ struct pci_host_bridge_window {
>  struct pci_host_bridge {
>  	struct device dev;
>  	struct pci_bus *bus;		/* root bus */
> +	int domain_nr;
>  	struct list_head windows;	/* pci_host_bridge_windows */
>  	void (*release_fn)(struct pci_host_bridge *);
>  	void *release_data;
> @@ -747,6 +748,9 @@ struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops, void *sysdata);
>  struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>  				    struct pci_ops *ops, void *sysdata,
>  				    struct list_head *resources);
> +struct pci_bus *pci_create_root_bus_in_domain(struct device *parent,
> +			int domain, int bus, struct pci_ops *ops,
> +			void *sysdata, struct list_head *resources);
>  int pci_bus_insert_busn_res(struct pci_bus *b, int bus, int busmax);
>  int pci_bus_update_busn_res_end(struct pci_bus *b, int busmax);
>  void pci_bus_release_busn_res(struct pci_bus *b);
> -- 
> 1.9.0
> 
