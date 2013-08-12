Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab3HLLrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 07:47:51 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:58050 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755478Ab3HLLrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 07:47:48 -0400
Date: Mon, 12 Aug 2013 17:17:22 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        Siva Reddy Kallam <siva.kallam@samsung.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] PCI: exynos: add support for MSI
Message-ID: <20130812114722.GA14050@pratyush-vbox>
References: <000401ce9739$e0a65410$a1f2fc30$@samsung.com>
 <20130812105638.GA12042@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130812105638.GA12042@ulmo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 06:56:40PM +0800, Thierry Reding wrote:
> On Mon, Aug 12, 2013 at 05:56:47PM +0900, Jingoo Han wrote:
> [...]
> > diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
> > index 855d4a7..9ef1c95 100644
> > --- a/arch/arm/mach-exynos/Kconfig
> > +++ b/arch/arm/mach-exynos/Kconfig
> > @@ -93,6 +93,7 @@ config SOC_EXYNOS5440
> >  	default y
> >  	depends on ARCH_EXYNOS5
> >  	select ARCH_HAS_OPP
> > +	select ARCH_SUPPORTS_MSI
> 
> This symbol goes away in Thomas Petazzoni's MSI patch series which is
> targetted at 3.12, so I don't think you should add that here.
> 
> > +#ifdef CONFIG_PCI_MSI
> > +static void exynos_pcie_clear_irq_level(struct pcie_port *pp)
> > +{
> > +	u32 val;
> > +	struct exynos_pcie *exynos_pcie = to_exynos_pcie(pp);
> > +	void __iomem *elbi_base = exynos_pcie->elbi_base;
> > +
> > +	val = readl(elbi_base + PCIE_IRQ_LEVEL);
> > +	writel(val, elbi_base + PCIE_IRQ_LEVEL);
> > +	return;
> > +}
> 
> I'm a little confused by this: the above code seems to access the PCIe
> controller registers to clear an interrupt, but you pass in a PCIe
> port...
> 

One struct pcie_port is associated with one controller and it has been
assumed that there is only one root port per controller. 

[...]

> > +void dw_pcie_msi_init(struct pcie_port *pp)
> > +{
> > +	/* program the msi_data */
> > +	dw_pcie_wr_own_conf(pp, PCIE_MSI_ADDR_LO, 4,
> > +			__virt_to_phys((u32)(&msi_data)));
> 
> That's slightly odd. You convert the virtual address of a local variable
> (local to the file) to a physical address and program that into a
> register. I assume that it works since you've probably tested this, but
> I wonder if it's safe to do this. Perhaps a better way would be to
> allocate a single free page (__get_free_pages(GFP_KERNEL, 0)) and write
> the physical address of that into the register instead.
> 

also msi_data must be different for different controller. Something
like &msi_data[pp->port].

[...]

> > +void arch_teardown_msi_irq(unsigned int irq)
> > +{
> > +	clear_irq(irq);
> > +}
> 
> And we've reworked this largely so that drivers no longer provide arch_*
> functions because that prevents multi-platform support. So I think you
> need to port this to the new msi_chip infrastructure that's being
> introduced in 3.12.

Yes, its needed.

Regards
Pratyush

> 
> Thierry


