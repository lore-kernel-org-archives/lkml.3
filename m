Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaJAIqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:46:35 -0400
Received: from service87.mimecast.com ([91.220.42.44]:51158 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaJAIqb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:46:31 -0400
Date: Wed, 1 Oct 2014 09:46:26 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
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
Message-ID: <20141001084626.GZ841@e106497-lin.cambridge.arm.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20140930174821.GX841@e106497-lin.cambridge.arm.com>
 <3079787.54pZijGjZM@wuerfel>
 <2430078.s4snyh5OoF@wuerfel>
MIME-Version: 1.0
In-Reply-To: <2430078.s4snyh5OoF@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 01 Oct 2014 08:46:27.0018 (UTC) FILETIME=[300CF2A0:01CFDD54]
X-MC-Unique: 114100109462815701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 09:01:14PM +0100, Arnd Bergmann wrote:
> On Tuesday 30 September 2014 20:54:41 Arnd Bergmann wrote:
> > On Tuesday 30 September 2014 18:48:21 Liviu Dudau wrote:
> > > > > > > These are the functions I found that refer to pci_sys_data on arm32:
> > > > > > > 
> > > > > > > pcibios_add_bus
> > > > > > > pcibios_remove_bus
> > > 
> > > These are only needed if you want to do per HB processing of the bus
> > > 
> > > > > > > pcibios_align_resource
> > > 
> > > mvebu is the only user of this function.
> > > 
> > > > > > > pci_mmap_page_range
> > > 
> > > This is only needed when mapping a PCI resource to userspace. Is that your case here?
> > > 
> > > > > > > pci_domain_nr
> > > > > > > pci_proc_domain
> > > 
> > > We have equivalent functionality in the generic patches for those.
> > > 
> > 
> > We clearly don't need those functions for the new drivers, but that's not
> > the point. The problem is that when you build a kernel that has both
> > a traditional host bridge driver and a new one in it, you always get those
> > functions and they get called from the PCI core, with incorrect arguments.
> 
> FWIW, the last time we discussed this, I think I had suggested that the
> functions that are currently architecture specific and have a generic
> __weak fallback could become function pointers in a per-host structure
> passed to pci_scan_root_bus, either a new structure or an extended
> struct pci_ops. Something along these lines:

Agree to the general idea. But have a look why host drivers need the add_bus ops:
to add MSI information into the bus!! If we take care of the MSI in the generic
code there is less of a need for this function at all.

Best regards,
Liviu

> 
> diff --git a/arch/arm/include/asm/mach/pci.h b/arch/arm/include/asm/mach/pci.h
> index 7fc42784becb..3da32fc631d0 100644
> --- a/arch/arm/include/asm/mach/pci.h
> +++ b/arch/arm/include/asm/mach/pci.h
> @@ -36,7 +36,6 @@ struct hw_pci {
>  					  resource_size_t start,
>  					  resource_size_t size,
>  					  resource_size_t align);
> -	void		(*add_bus)(struct pci_bus *bus);
>  	void		(*remove_bus)(struct pci_bus *bus);
>  };
>  
> @@ -65,7 +64,6 @@ struct pci_sys_data {
>  					  resource_size_t start,
>  					  resource_size_t size,
>  					  resource_size_t align);
> -	void		(*add_bus)(struct pci_bus *bus);
>  	void		(*remove_bus)(struct pci_bus *bus);
>  	void		*private_data;	/* platform controller private data	*/
>  };
> diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
> index 17a26c17f7f5..3cbcf8dc41e4 100644
> --- a/arch/arm/kernel/bios32.c
> +++ b/arch/arm/kernel/bios32.c
> @@ -360,13 +360,6 @@ void pcibios_fixup_bus(struct pci_bus *bus)
>  }
>  EXPORT_SYMBOL(pcibios_fixup_bus);
>  
> -void pcibios_add_bus(struct pci_bus *bus)
> -{
> -	struct pci_sys_data *sys = bus->sysdata;
> -	if (sys->add_bus)
> -		sys->add_bus(bus);
> -}
> -
>  void pcibios_remove_bus(struct pci_bus *bus)
>  {
>  	struct pci_sys_data *sys = bus->sysdata;
> @@ -475,7 +468,6 @@ static void pcibios_init_hw(struct device *parent, struct hw_pci *hw,
>  		sys->swizzle = hw->swizzle;
>  		sys->map_irq = hw->map_irq;
>  		sys->align_resource = hw->align_resource;
> -		sys->add_bus = hw->add_bus;
>  		sys->remove_bus = hw->remove_bus;
>  		INIT_LIST_HEAD(&sys->resources);
>  
> diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
> index b1315e197ffb..c9a0ee0429e8 100644
> --- a/drivers/pci/host/pci-mvebu.c
> +++ b/drivers/pci/host/pci-mvebu.c
> @@ -716,6 +716,7 @@ static int mvebu_pcie_rd_conf(struct pci_bus *bus, u32 devfn, int where,
>  static struct pci_ops mvebu_pcie_ops = {
>  	.read = mvebu_pcie_rd_conf,
>  	.write = mvebu_pcie_wr_conf,
> +	.add_bus = mvebu_pcie_add_bus,
>  };
>  
>  static int mvebu_pcie_setup(int nr, struct pci_sys_data *sys)
> @@ -823,7 +824,6 @@ static void mvebu_pcie_enable(struct mvebu_pcie *pcie)
>  	hw.map_irq        = of_irq_parse_and_map_pci;
>  	hw.ops            = &mvebu_pcie_ops;
>  	hw.align_resource = mvebu_pcie_align_resource;
> -	hw.add_bus        = mvebu_pcie_add_bus;
>  
>  	pci_common_init(&hw);
>  }
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index a63a47a70846..be6d56358320 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1885,6 +1885,8 @@ int __weak pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
>  
>  void __weak pcibios_add_bus(struct pci_bus *bus)
>  {
> +	if (bus->ops && bus->ops->add_bus)
> +		bus->ops->add_bus(bus);		
>  }
>  
>  void __weak pcibios_remove_bus(struct pci_bus *bus)
> 
> 	Arnd
> 
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

