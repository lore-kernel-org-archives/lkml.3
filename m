Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaJVP72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:59:28 -0400
Received: from service87.mimecast.com ([91.220.42.44]:59990 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbaJVP7T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:59:19 -0400
Date: Wed, 22 Oct 2014 16:59:14 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Message-ID: <20141022155914.GB25939@e102568-lin.cambridge.arm.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
 <2430078.s4snyh5OoF@wuerfel>
 <20141001084626.GZ841@e106497-lin.cambridge.arm.com>
 <3256560.C0cZnIlnAv@wuerfel>
MIME-Version: 1.0
In-Reply-To: <3256560.C0cZnIlnAv@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 22 Oct 2014 15:59:15.0681 (UTC) FILETIME=[21413510:01CFEE11]
X-MC-Unique: 114102216591700201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 10:38:45AM +0100, Arnd Bergmann wrote:

[...]

> The arm32 implementations of pci_domain_nr/pci_proc_domain can probably be
> removed if we change the arm32 pcibios_init_hw function to call the new
> interfaces that set the domain number.

I wished, but it is a bit more complicated than I thought unfortunately,
mostly because some drivers, eg cns3xxx set the domain numbers
statically in pci_sys_data and this sets a chain of dependency that is
not easy to untangle. I think cns3xxx is the only legacy driver that "uses"
the domain number (in pci_sys_data) in a way that clashes with the
generic domain_nr implementation, I need to give it more thought.

> pci_mmap_page_range could either get generalized some more in an attempt
> to have a __weak default implementation that works on ARM, or it could
> be changed to lose the dependency on pci_sys_data instead. In either
> case, the change would involve using the generic pci_host_bridge_window
> list.

I need to repost my series, but I *think* we can consider the dependency on
pci_sys_data gone in pci_mmap_page_range().

> pcibios_align_resource should probably be per host, and we could move
> that into a pointer in pci_host_bridge, something like this:

Yes, and that's likely to be true for add_bus too. I wonder what's the
best course of action. Putting together all the bits and pieces required
to remove PCI bios dependency from this patch can take a while, I wonder
whether we should aim for merging this driver (rebased on top of my port to the
new parse ranges API) with the ARM/ARM64 ifdeffery and clean it up later
or aim for the whole thing at once, I am just worried it can take us a while.

Lorenzo

> 
> diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
> index b7c3a5ea1fca..d9cb6c916d54 100644
> --- a/drivers/pci/setup-res.c
> +++ b/drivers/pci/setup-res.c
> @@ -200,11 +200,15 @@ static int pci_revert_fw_address(struct resource *res, struct pci_dev *dev,
>  static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
>  		int resno, resource_size_t size, resource_size_t align)
>  {
> +	struct pci_host_bridge *host = find_pci_host_bridge(bus);
> +	resource_size_t (*alignf)(void *, const struct resource *,
> +				  resource_size_t, resource_size_t),
>  	struct resource *res = dev->resource + resno;
>  	resource_size_t min;
>  	int ret;
>  
>  	min = (res->flags & IORESOURCE_IO) ? PCIBIOS_MIN_IO : PCIBIOS_MIN_MEM;
> +	alignf = host->align_resource ?: pcibios_align_resource;
>  
>  	/*
>  	 * First, try exact prefetching match.  Even if a 64-bit
> @@ -215,7 +219,7 @@ static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
>  	 */
>  	ret = pci_bus_alloc_resource(bus, res, size, align, min,
>  				     IORESOURCE_PREFETCH | IORESOURCE_MEM_64,
> -				     pcibios_align_resource, dev);
> +				     alignf, dev);
>  	if (ret == 0)
>  		return 0;
>  
> @@ -227,7 +231,7 @@ static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
>  	     (IORESOURCE_PREFETCH | IORESOURCE_MEM_64)) {
>  		ret = pci_bus_alloc_resource(bus, res, size, align, min,
>  					     IORESOURCE_PREFETCH,
> -					     pcibios_align_resource, dev);
> +					     alignf, dev);
>  		if (ret == 0)
>  			return 0;
>  	}
> @@ -240,7 +244,7 @@ static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
>  	 */
>  	if (res->flags & (IORESOURCE_PREFETCH | IORESOURCE_MEM_64))
>  		ret = pci_bus_alloc_resource(bus, res, size, align, min, 0,
> -					     pcibios_align_resource, dev);
> +					     alignf, dev);
>  
>  	return ret;
>  }
> 
> 
> If we decide constantly calling find_pci_host_bridge() is too expensive, we can
> be more clever about it.
> 
> 	Arnd
> 
> 

