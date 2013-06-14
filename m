Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab3FNMxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 08:53:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61915 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3FNMxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 08:53:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
Subject: Re: [PATCH V5 1/3] pci: Add PCIe driver for Samsung Exynos
Date: Fri, 14 Jun 2013 14:53:38 +0200
Message-ID: <3539874.V7zkhbMg0b@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <000001ce68d7$ca762200$5f626600$@samsung.com>
References: <000b01ce6839$0f0455d0$2d0d0170$@samsung.com> <13685067.uPzcc2y1CU@wuerfel> <000001ce68d7$ca762200$5f626600$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:frIUGtsKY5VemrEZKnGOyZBgLMlaVfEDxnp3JHgckd7
 lou52NwUB7d9/CiInmKsc3PUduedBWaSKkwKMYrz5OdJey0ygr
 mCzwccCyVcfk+r3Alpg6yG/QW9Vn2FNnJ2G0P9K/JqlrCYX6jM
 A3iWgxJwxB3zamf5K86yE0IX89r76Mt+UQPH2UldMpMwdNQ0lr
 9hMlnQA65u/l5jSXosyt+zAJ2L/HbJfDuky4A8B17w8qD6kq+z
 IGXx1hloFgUG5hyZA11fJ8nbyDvpegd0AQzAWvgbC2B2Ainn/f
 3CYqjNryJjriVSz1ZUyZK4JszSw5zO+KoG9ab+CdUYNTeyRR15
 +WkkwgtPxaq4Py+G/c9g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 June 2013 17:18:46 Jingoo Han wrote:
> On Thursday, June 13, 2013 11:14 PM, Arnd Bergmann wrote:
> > On Thursday 13 June 2013 22:22:31 Jingoo Han wrote:

> > > +struct pcie_port {
> > > +	struct device		*dev;
> > > +	u8			controller;
> > > +	u8			root_bus_nr;
> > > +	void __iomem		*dbi_base;
> > > +	void __iomem		*elbi_base;
> > > +	void __iomem		*phy_base;
> > > +	void __iomem		*purple_base;
> > > +	phys_addr_t		cfg0_base;
> > > +	void __iomem		*va_cfg0_base;
> > > +	phys_addr_t		cfg1_base;
> > > +	void __iomem		*va_cfg1_base;
> > > +	phys_addr_t		io_base;
> > > +	phys_addr_t		mem_base;
> > > +	spinlock_t		conf_lock;
> > > +	struct resource		cfg;
> > > +	struct resource		io;
> > > +	struct resource		mem;
> > > +	struct pcie_port_info	config;
> > > +	struct clk		*clk;
> > > +	struct clk		*bus_clk;
> > > +	int			irq;
> > > +	int			reset_gpio;
> > > +};
> > 
> > You mentioned that you'd use u64 for the resources here but did not.
> 
> Do you mean the following?
> 
> +	u64		cfg0_base;
> +	u64		cfg1_base;
> +	u64		io_base;
> +	u64		mem_base;

Yes, anything you need to program into a 64 bit hardware register.

> > > +static void exynos_pcie_prog_viewport_cfg1(struct pcie_port *pp, u32 busdev)
> > > +{
> > > +	u32 val;
> > > +	void __iomem *dbi_base = pp->dbi_base;
> > > +
> > > +	/* Program viewport 1 : OUTBOUND : CFG1 */
> > > +	val = PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX1;
> > > +	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
> > > +	writel_rc(pp, PCIE_ATU_TYPE_CFG1, dbi_base + PCIE_ATU_CR1);
> > > +	val = PCIE_ATU_ENABLE;
> > > +	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
> > > +	writel_rc(pp, (u64)pp->cfg1_base, dbi_base + PCIE_ATU_LOWER_BASE);
> > > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
> > > +	writel_rc(pp, (u64)pp->cfg1_base + pp->config.cfg1_size - 1,
> > > +			dbi_base + PCIE_ATU_LIMIT);
> > > +	writel_rc(pp, busdev, dbi_base + PCIE_ATU_LOWER_TARGET);
> > > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
> > > +}
> > 
> > And you still don't set up the UPPER halves, which was really the point
> > of my comment. Same thing for all the other ones.
> 
> Do you mean the following?
> 
> +	writel_rc(pp, pp->cfg1_base, dbi_base + PCIE_ATU_LOWER_BASE);
> +	writel_rc(pp, (pp->cfg1_base >> 32), dbi_base + PCIE_ATU_UPPER_BASE);

Right. Note that you could achieve the same using phys_addr_t instead of
u64, but it's more complicated to get that to work for both 32 and 64 bit
phys_addr_t types, since you cannot shift a 32 bit value by 32 bits in C.

> > > +static void exynos_pcie_prog_viewport_mem_inbound(struct pcie_port *pp)
> > > +{
> > > +	u32 val;
> > > +	void __iomem *dbi_base = pp->dbi_base;
> > > +
> > > +	/* Program viewport 0 : INBOUND : MEM */
> > > +	val = PCIE_ATU_REGION_INBOUND | PCIE_ATU_REGION_INDEX0;
> > > +	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
> > > +	writel_rc(pp, PCIE_ATU_TYPE_MEM, dbi_base + PCIE_ATU_CR1);
> > > +	val = PCIE_ATU_ENABLE | PCIE_ATU_BAR_MODE_ENABLE;
> > > +	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
> > > +	writel_rc(pp, (u64)pp->config.mem_bus_addr,
> > > +			dbi_base + PCIE_ATU_LOWER_BASE);
> > > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
> > > +	writel_rc(pp, (u64)pp->config.mem_bus_addr + pp->config.mem_size - 1,
> > > +			dbi_base + PCIE_ATU_LIMIT);
> > > +	writel_rc(pp, (u64)pp->mem_base, dbi_base + PCIE_ATU_LOWER_TARGET);
> > > +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
> > > +}
> > 
> > This makes even less sense than before, it seems like now you only
> > allow DMA between PCI devices but not to main memory.
> 
> Sorry, I cannot understand it.
> Could you give me more details?
> Also, pseudo-code will be very helpful.

Please look up the documentation about inbound viewport and describe
in a code comment what it does. I /assume/ that this is how DMA accesses
from the bus get translated into AXI bus transactions. If so, you have
to let the window translate addresses from RAM. If it's something else,
then you should document what it is and how it needs to be set up.
 
> > > +static int exynos_pcie_setup(int nr, struct pci_sys_data *sys)
> > > +{
> > > +	struct pcie_port *pp;
> > > +
> > > +	pp = sys_to_pcie(sys);
> > > +
> > > +	if (!pp)
> > > +		return 0;
> > > +
> > > +	pci_add_resource(&sys->resources, &pp->io);
> > > +	pci_add_resource(&sys->resources, &pp->mem);
> > 
> > Now you are missing the offsets. You have to at least pass an offset for one
> > of the I/O spaces, since they are using the same bus address. The offset must
> > match the value you pass to pci_ioremap_io.
> > 
> > For the memory space, you should pass the difference between the physical
> > base address and the bus address. That address happens to be zero with
> > you DT setup, but I would advise to also try out some other values in DT,
> > just to ensure it still works.
> 
> Um, I cannot understand it, too.
> Could you give me Psuedo-code?
> Or, let me know which pcie driver can be the good reference.

I think most hardware is not as flexible as yours, so they can just hardcode
a lot of this.

What you need here is

static unsigned long global_io_offset = 0;
if (global_io_offset < SZ_1M && pp->config.io_size > 0) {
	sys->io_offset = global_io_offset - pp->config.io_bus_addr; /* normally 0 */
	pci_ioremap_io(sys->io_offset, pp->io.start);
	global_io_offset += SZ_64K;
}
sys->mem_offset = pp->mem.start - pp->config.mem_bus_addr; /* normally 0 */

sys->io_offset normally increases by 64K for each bus but should always
be between 0 and 1MB, it is the index into the registers mapped at
(void __iomem*)PCI_IO_VIRT_BASE.

It is best practice to map 64KB of I/O space at bus address 0 for each
domain into PCI_IO_VIRT_BASE, and set up a 1:1 translation between
memory space bus addresses and CPU physical addresses, as you do
in your 'ranges' property.

However, you should be able to use any other bus addresses with the code
above, except for broken device drivers.

> > > +static int __exit exynos_pcie_remove(struct platform_device *pdev)
> > > +{
> > > +	struct pcie_port *pp = platform_get_drvdata(pdev);
> > > +
> > > +	clk_disable_unprepare(pp->bus_clk);
> > > +	clk_disable_unprepare(pp->clk);
> > > +
> > > +	return 0;
> > > +}
> > 
> > You also don't remove the PCI devices here, as mentioned in an earlier
> > review.
> 
> I reviewed Marvell PCIe driver and Tegra PCIe driver; however,
> I cannot know what you mean.
> 
> Could let me know which additional functions are needed?

The mvebu driver does not allow module unload. I haven't looked at the
tegra driver. If you allow unloading the driver and provide a 'remove'
callback, that callback needs to clean up the entire bus and remove
all child devices that were added as well as undo everything the
probe function did. I think it would be great if you can do that, although
it might not be easy. The simplest solution would be to not support
unloading though.

	Arnd
