Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab3FLLW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 07:22:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56363 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3FLLW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 07:22:57 -0400
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
Subject: Re: [PATCH V4 1/3] pci: Add PCIe driver for Samsung Exynos
Date: Wed, 12 Jun 2013 13:23:03 +0200
Message-ID: <2061566.hRLrhtBK6z@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <003601ce6756$444e8cd0$cceba670$@samsung.com>
References: <003601ce6756$444e8cd0$cceba670$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bIWPO618vQ66CCS0Jovns2xHYMm3LrImcHYBwSnJ5RZ
 Gl8AAUKgijyYG9m27p0jwfqRmNo4H7xYIeyDVrUqUVgls3skyu
 08iYee4Zv5CHzKavGGpMHSTxq83ZSv1Chj1Iq10RXlvxSKMcss
 0BRB5magpSmJ+3+6m3UOhrJeyfv7bpip+4qDxmxbYvAdsXzqM1
 ZBNVOOohcoXWW4iR5DvevB8Ytc0T7r4NQA8uXmDmq/r6yWORgB
 Dv4JY0/G0sQdjNlIPn4UYGA48JKy5ABLrDaeg99z61CKsii9bd
 EmYyI+4wKdXFbEss+thmvAbATAJKAhUqR3W6DGe3/HeBaOBaEZ
 1Zw313ozu4WDZHm2MSfE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 June 2013 19:19:05 Jingoo Han wrote:

> +
> +struct pcie_port {
> +	struct device		*dev;
> +	u8			controller;
> +	u8			root_bus_nr;
> +	void __iomem		*dbi_base;
> +	void __iomem		*elbi_base;
> +	void __iomem		*phy_base;
> +	void __iomem		*purple_base;
> +	phys_addr_t		cfg0_base;
> +	void __iomem		*va_cfg0_base;
> +	phys_addr_t		cfg1_base;
> +	void __iomem		*va_cfg1_base;
> +	phys_addr_t		io_base;
> +	phys_addr_t		mem_base;
> +	spinlock_t		conf_lock;
> +	struct resource		cfg;
> +	struct resource		io;
> +	struct resource		mem;
> +	struct pcie_port_info	config;
> +	struct clk		*clk;
> +	struct clk		*bus_clk;
> +	int			irq;
> +	int			reset_gpio;
> +};

This looks much better now.

> +
> +/* synopsis specific PCIE configuration registers*/
> +#define PCIE_PORT_LINK_CONTROL		0x710
> +#define PORT_LINK_MODE_MASK		(0x3f << 16)
> +#define PORT_LINK_MODE_4_LANES		(0x7 << 16)

Do you mean this is a "Synopsys" designware part? In that case it
should really not be called "exynos-pcie" but "designware-pcie"
and you should make sure that the driver makes no assumptions about
the platform. A lot of other platforms also use designware
parts and should be able to reuse this driver.

> +static void exynos_pcie_prog_viewport_cfg0(struct pcie_port *pp, u32 busdev)
> +{
> +	u32 val;
> +	void __iomem *dbi_base = pp->dbi_base;
> +
> +	/* Program viewport 0 : OUTBOUND : CFG0 */
> +	val = PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX0;
> +	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
> +	writel_rc(pp, (u32)pp->cfg0_base, dbi_base + PCIE_ATU_LOWER_BASE);
> +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
> +	writel_rc(pp, (u32)pp->cfg0_base + pp->config.cfg0_size - 1,
> +			dbi_base + PCIE_ATU_LIMIT);
> +	writel_rc(pp, busdev, dbi_base + PCIE_ATU_LOWER_TARGET);
> +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
> +	writel_rc(pp, PCIE_ATU_TYPE_CFG0, dbi_base + PCIE_ATU_CR1);
> +	val = PCIE_ATU_ENABLE;
> +	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
> +}

I think you should not assume that the physical base address is a 32
bit value. The hardware clearly supports "lower" and "upper" halves
for the address window, so when resource_size_t is 64 bit, you should
set the upper half accordingly. Since the hardware is always 64 bit,
you can use a "u64" type rather than resource_size_t to simplify the
code here.

> +static void exynos_pcie_prog_viewport_mem_outbound(struct pcie_port *pp)
> +{
> +	u32 val;
> +	void __iomem *dbi_base = pp->dbi_base;
> +
> +	/* Program viewport 0 : OUTBOUND : MEM */
> +	val = PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX0;
> +	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
> +	writel_rc(pp, PCIE_ATU_TYPE_MEM, dbi_base + PCIE_ATU_CR1);
> +	val = PCIE_ATU_ENABLE;
> +	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
> +	writel_rc(pp, (u32)pp->mem_base, dbi_base + PCIE_ATU_LOWER_BASE);
> +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
> +	writel_rc(pp, (u32)(pp->mem_base + pp->config.mem_size - 1),
> +			dbi_base + PCIE_ATU_LIMIT);
> +	writel_rc(pp, (u32)pp->mem_base, dbi_base + PCIE_ATU_LOWER_TARGET);
> +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
> +}

You probably should not assume that there is a 1:1 mapping between 
bus addresses and host physical addresses, but rather read both
values from the DT individually. With the ranges defined as

       0x82000000 0 0x40210000 0x40210000 0 0x10000000>; /* non-prefetchable memory */

the second and third cell should go into
PCIE_ATU_UPPER_TARGET/PCIE_ATU_LOWER_TARGET, while the translated address
(from the third cell) should go into PCIE_ATU_LOWER_BASE/PCIE_ATU_UPPER_BASE

The PCIE_ATU_LIMIT seems to correctly get translated from the last
cell.

> +static void exynos_pcie_prog_viewport_io_outbound(struct pcie_port *pp)
> +{
> +	u32 val;
> +	void __iomem *dbi_base = pp->dbi_base;
> +
> +	/* Program viewport 1 : OUTBOUND : IO */
> +	val = PCIE_ATU_REGION_OUTBOUND | PCIE_ATU_REGION_INDEX1;
> +	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
> +	writel_rc(pp, PCIE_ATU_TYPE_IO, dbi_base + PCIE_ATU_CR1);
> +	val = PCIE_ATU_ENABLE;
> +	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
> +	writel_rc(pp, (u32)pp->io_base, dbi_base + PCIE_ATU_LOWER_BASE);
> +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
> +	writel_rc(pp, (u32)(pp->io_base + pp->config.io_size - 1),
> +			dbi_base + PCIE_ATU_LIMIT);
> +	writel_rc(pp, (u32)pp->io_base, dbi_base + PCIE_ATU_LOWER_TARGET);
> +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
> +}

You don't actually map the I/O space anywhere into virtual memory.
I think you need to call pci_ioremap_io with the pp->io_base at
boot time.

I think you mixed up the PCIE_ATU_LOWER_TARGET, it should really be 0,
since all I/O port numbers have to be smaller than IO_SPACE_LIMIT.

The first argument to pci_ioremap_io needs to be unique for each
domain and you need to use it to calculate the io_offset you
set in pci_sys_data->io_offset.

> +static void exynos_pcie_prog_viewport_mem_inbound(struct pcie_port *pp)
> +{
> +	u32 val;
> +	void __iomem *dbi_base = pp->dbi_base;
> +	struct pcie_port_info *config = &pp->config;
> +
> +	/* Program viewport 0 : INBOUND : MEMORY */
> +	val = PCIE_ATU_REGION_INBOUND | PCIE_ATU_REGION_INDEX0;
> +	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
> +	writel_rc(pp, PCIE_ATU_TYPE_MEM, dbi_base + PCIE_ATU_CR1);
> +	val = PCIE_ATU_ENABLE | PCIE_ATU_BAR_MODE_ENABLE;
> +	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
> +	writel_rc(pp, 0, dbi_base + PCIE_ATU_LOWER_BASE);
> +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
> +	writel_rc(pp, config->in_mem_size - 1, dbi_base + PCIE_ATU_LIMIT);
> +	writel_rc(pp, 0, dbi_base + PCIE_ATU_LOWER_TARGET);
> +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
> +}

You hardcode the in_mem_size to 256 MB. Does that mean you only allow
PCI bus master DMA on the first part of RAM? Shouldn't it get
computed from the actual location and size of RAM?

> +static void exynos_pcie_prog_viewport_io_inbound(struct pcie_port *pp)
> +{
> +	u32 val;
> +	void __iomem *dbi_base = pp->dbi_base;
> +	struct pcie_port_info *config = &pp->config;
> +
> +	/* Program viewport 1 : INBOUND : IO */
> +	val = PCIE_ATU_REGION_INBOUND | PCIE_ATU_REGION_INDEX1;
> +	writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT);
> +	writel_rc(pp, PCIE_ATU_TYPE_IO, dbi_base + PCIE_ATU_CR1);
> +	val = PCIE_ATU_ENABLE | PCIE_ATU_BAR_MODE_ENABLE;
> +	writel_rc(pp, val, dbi_base + PCIE_ATU_CR2);
> +	writel_rc(pp, 0, dbi_base + PCIE_ATU_LOWER_BASE);
> +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE);
> +	writel_rc(pp, config->in_mem_size - 1, dbi_base + PCIE_ATU_LIMIT);
> +	writel_rc(pp, 0, dbi_base + PCIE_ATU_LOWER_TARGET);
> +	writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET);
> +}

I don't understand what in inbound I/O access actually means. What
does this do, is it for PCI target emulation?

> +
> +static int exynos_pcie_setup(int nr, struct pci_sys_data *sys)
> +{
> +	struct pcie_port *pp;
> +
> +	pp = sys_to_pcie(sys);
> +
> +	if (!pp)
> +		return 0;
> +
> +	pci_add_resource_offset(&sys->resources, &pp->io, sys->io_offset);
> +	pci_add_resource_offset(&sys->resources, &pp->mem, sys->mem_offset);
> +
> +	return 1;
> +}

You don't actually set up io_offset and mem_offset, right?

	Arnd
