Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaAOMkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 07:40:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:52195 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaAOMkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 07:40:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: [RFC PATCH V2 1/4] pci: APM X-Gene PCIe controller driver
Date: Wed, 15 Jan 2014 13:39:57 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@apm.com, jcm@redhat.com
References: <1389742458-7693-1-git-send-email-tinamdar@apm.com> <1389742458-7693-2-git-send-email-tinamdar@apm.com>
In-Reply-To: <1389742458-7693-2-git-send-email-tinamdar@apm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201401151339.58593.arnd@arndb.de>
X-Provags-ID: V02:K0:hH92BF91RVmka7TJnAOFrDWIli9n21umhuJFCn7nA4A
 lW9ftInJWzrSJC8s581pF3aySnZW2GTmUPY7px1LndC0y+3cpN
 GlbAXGmLnDJt5Ly5k7weDuTSn+CmG6UiD1ITctz1tNNTG4utUM
 ETRkrhwR6ylVdnKRYdgrsY0CWyttbKHMKelLLmZ2sbUFhA91Rv
 mZOhc/1cb53SkfUJeNNzgn/9OJQy8xNOAOE0yYVjus2rDE6bm2
 DunYOaaejFoDgDFi3pWP8xcooA7CTHXWEr1Y2VLagX8Tk2RNHS
 cGcPrk5fSBueO7AUi6eKwI8qz62BUXKRIl8wRT7hxo4Ix18MtO
 Edk3NBrQ7a7gmXgxitXU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 January 2014, Tanmay Inamdar wrote:
> This patch adds the AppliedMicro X-Gene SOC PCIe controller driver.
> X-Gene PCIe controller supports maxmum upto 8 lanes and GEN3 speed.
> X-Gene has maximum 5 PCIe ports supported.
>
> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>

This already looks much better than the first version, but I have a more
comments. Most importantly, it would help to know how the root ports
are structured. Is this a standard root complex and multiple ports,
multiple root complexes with one port each, or a nonstandard organization
that is a mix of those two models?

> +
> +/* When the address bit [17:16] is 2'b01, the Configuration access will be
> + * treated as Type 1 and it will be forwarded to external PCIe device.
> + */
> +static void __iomem *xgene_pcie_get_cfg_base(struct pci_bus *bus)
> +{
> +	struct xgene_pcie_port *port = xgene_pcie_bus_to_port(bus);
> +	u64 addr = (u64)port->cfg_base;
> +
> +	if (bus->number >= (port->first_busno + 1))
> +		addr |= AXI_EP_CFG_ACCESS;
> +
> +	return (void *)addr;
> +}

Wrong type, it should be 'void __iomem *'. Also you can't assume that
bit operations work on virtual __iomem addresses, so it should be better
to just add a constant integer to the pointer, which is a valid
operation.

I also wonder why you need to do this at all. If there isn't a global
config space for all ports, but rather a separate type0/type1 config
cycle based on the bus number, I see that as an indication that the
ports are in fact separate domains and should each start with bus 0.

> +static void xgene_pcie_setup_lanes(struct xgene_pcie_port *port)
> +{
> +	void *csr_base = port->csr_base;
> +	u32 val;
> +
> +	val = readl(csr_base + BRIDGE_8G_CFG_8);
> +	val = eq_pre_cursor_lane0_set(val, 0x7);
> +	val = eq_pre_cursor_lane1_set(val, 0x7);
> +	writel(val, csr_base + BRIDGE_8G_CFG_8);
> +
> +	val = readl(csr_base + BRIDGE_8G_CFG_9);
> +	val = eq_pre_cursor_lane0_set(val, 0x7);
> +	val = eq_pre_cursor_lane1_set(val, 0x7);
> +	writel(val, csr_base + BRIDGE_8G_CFG_9);
> +
> +	val = readl(csr_base + BRIDGE_8G_CFG_10);
> +	val = eq_pre_cursor_lane0_set(val, 0x7);
> +	val = eq_pre_cursor_lane1_set(val, 0x7);
> +	writel(val, csr_base + BRIDGE_8G_CFG_10);
> +
> +	val = readl(csr_base + BRIDGE_8G_CFG_11);
> +	val = eq_pre_cursor_lane0_set(val, 0x7);
> +	val = eq_pre_cursor_lane1_set(val, 0x7);
> +	writel(val, csr_base + BRIDGE_8G_CFG_11);
> +
> +	val = readl(csr_base + BRIDGE_8G_CFG_4);
> +	val = (val & ~0x30) | (1 << 4);
> +	writel(val, csr_base + BRIDGE_8G_CFG_4);
> +}

Please document what you are actually setting here. If the configuration
of the lanes is always the same, why do you have to set it here. If not,
why do you set constant values?

> +static void xgene_pcie_setup_link(struct xgene_pcie_port *port)
> +{
> +	void *csr_base = port->csr_base;
> +	u32 val;
> +
> +	val = readl(csr_base + BRIDGE_CFG_14);
> +	val |= DIRECT_TO_8GTS_MASK;
> +	val |= SUPPORT_5GTS_MASK;
> +	val |= SUPPORT_8GTS_MASK;
> +	val |= DIRECT_TO_5GTS_MASK;
> +	writel(val, csr_base + BRIDGE_CFG_14);
> +
> +	val = readl(csr_base + BRIDGE_CFG_14);
> +	val &= ~ADVT_INFINITE_CREDITS;
> +	writel(val, csr_base + BRIDGE_CFG_14);
> +
> +	val = readl(csr_base + BRIDGE_8G_CFG_0);
> +	val |= (val & ~0xf) | 7;
> +	val |= (val & ~0xf00) | ((7 << 8) & 0xf00);
> +	writel(val, csr_base + BRIDGE_8G_CFG_0);
> +
> +	val = readl(csr_base + BRIDGE_8G_CFG_0);
> +	val |= DWNSTRM_EQ_SKP_PHS_2_3;
> +	writel(val, csr_base + BRIDGE_8G_CFG_0);
> +}

Same here.

> +static void xgene_pcie_program_core(void *csr_base)
> +{
> +	u32 val;
> +
> +	val = readl(csr_base + BRIDGE_CFG_0);
> +	val |= AER_OPTIONAL_ERROR_EN;
> +	writel(val, csr_base + BRIDGE_CFG_0);
> +	writel(0x0, csr_base + INTXSTATUSMASK);
> +	val = readl(csr_base + BRIDGE_CTRL_1);
> +	val = (val & ~0xffff) | XGENE_PCIE_DEV_CTRL;
> +	writel(val, csr_base + BRIDGE_CTRL_1);
> +}

'program_core'?

> +static void xgene_pcie_poll_linkup(struct xgene_pcie_port *port, u32 *lanes)
> +{
> +	void *csr_base = port->csr_base;
> +	u32 val32;
> +	u64 start_time, time;
> +
> +	/*
> +	 * A component enters the LTSSM Detect state within
> +	 * 20ms of the end of fundamental core reset.
> +	 */
> +	msleep(XGENE_LTSSM_DETECT_WAIT);
> +	port->link_up = 0;
> +	start_time = jiffies;
> +	do {
> +		val32 = readl(csr_base + PCIECORE_CTLANDSTATUS);
> +		if (val32 & LINK_UP_MASK) {
> +			port->link_up = 1;
> +			port->link_speed = PIPE_PHY_RATE_RD(val32);
> +			val32 = readl(csr_base + BRIDGE_STATUS_0);
> +			*lanes = val32 >> 26;
> +		}
> +		time = jiffies_to_msecs(jiffies - start_time);
> +	} while ((!port->link_up) || (time <= XGENE_LTSSM_L0_WAIT));
> +}

Maybe another msleep() in the loop? It seems weird to first do an
unconditional sleep but then busy-wait for the result.

> +static void xgene_pcie_setup_primary_bus(struct xgene_pcie_port *port,
> +					 u32 first_busno, u32 last_busno)
> +{
> +	u32 val;
> +	void *cfg_addr = port->cfg_base;
> +
> +	val = readl(cfg_addr + PCI_PRIMARY_BUS);
> +	val &= ~PCI_PRIMARY_BUS_MASK;
> +	val |= (last_busno << 16) | ((first_busno + 1) << 8) | (first_busno);
> +	writel(val, cfg_addr + PCI_PRIMARY_BUS);
> +}

Please explain what you are doing here. As mentioned above, I would expect
that each domain has visibility of all 255 buses. You shouldn't need any hacks
where you try to artificially squeeze the ports into a single domain when
they are separate in hardware.

> +/*
> + * read configuration values from DTS
> + */
> +static int xgene_pcie_read_dts_config(struct xgene_pcie_port *port)

The comment and function name don't seem to match what the function
does. The main purpose of this function seems to be to ioremap
the resources, which have nothing to with configuration.

> +{
> +	struct device_node *np = port->node;
> +	struct resource csr_res;
> +	struct resource cfg_res;
> +
> +	/* Get CSR space registers address */
> +	if (of_address_to_resource(np, 0, &csr_res))
> +		return -EINVAL;
> +
> +	port->csr_base = devm_ioremap_nocache(port->dev, csr_res.start,
> +					      resource_size(&csr_res));

You can also use platform_get_resource() to access the resource
that is already there, rather than creating another one.

> +static void xgene_pcie_setup_ob_reg(struct xgene_pcie_port *port,
> +				    u32 addr, u32 restype)
> +{
> +	struct resource *res = NULL;
> +	void *base = port->csr_base + addr;
> +	resource_size_t size;
> +	u64 cpu_addr = 0;
> +	u64 pci_addr = 0;
> +	u64 mask = 0;
> +	u32 min_size = 0;

A general note: don't initialize local variables to a bogus valus (e.g. 0)
in their declaration. It prevents the compiler from warning about
incorrect uses.

> +	u32 flag = EN_REG;

This one on the other hand is ok, because you are actually going to
use that value.

> +	switch (restype) {
> +	case IORESOURCE_MEM:
> +		res = &port->mem.res;
> +		pci_addr = port->mem.pci_addr;
> +		min_size = SZ_128M;
> +		break;
> +	case IORESOURCE_IO:
> +		res = &port->io.res;
> +		pci_addr = port->io.pci_addr;
> +		min_size = 128;
> +		flag |= OB_LO_IO;
> +		break;
> +	}

I assume this works ok, but seems wrong in one detail: If the resource
is marked IORESOURCE_IO, res->start is supposed to be in I/O space, not
in memory space, which would make it the wrong number to program
into the hardware registers.

> +static int xgene_pcie_parse_map_ranges(struct xgene_pcie_port *port)
> +{
> +	struct device_node *np = port->node;
> +	struct of_pci_range range;
> +	struct of_pci_range_parser parser;
> +	struct device *dev = port->dev;
> +
> +	if (of_pci_range_parser_init(&parser, np)) {
> +		dev_err(dev, "missing ranges property\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Get the I/O, memory, config ranges from DT */

The comment needs updating now that you don't read config space here any more.

> +/* X-Gene PCIe support maximum 3 inbound memory regions
> + * This function helps to select a region based on size of region
> + */
> +static int xgene_pcie_select_ib_reg(u64 size)
> +{
> +	static u8 ib_reg_mask;
> +
> +	if ((size > 4) && (size < SZ_16M) && !(ib_reg_mask & (1 << 1))) {
> +		ib_reg_mask |= (1 << 1);
> +		return 1;
> +	}
> +
> +	if ((size > SZ_1K) && (size < SZ_1T) && !(ib_reg_mask & (1 << 0))) {
> +		ib_reg_mask |= (1 << 0);
> +		return 0;
> +	}
> +
> +	if ((size > SZ_1M) && (size < SZ_1T) && !(ib_reg_mask & (1 << 2))) {
> +		ib_reg_mask |= (1 << 2);
> +		return 2;
> +	}
> +	return -EINVAL;
> +}

Shouldn't the ib_reg_mask variable be per host bridge? Static variables
are dangerous if you ever get multiple instances of the hardware in one
system.

> +static int xgene_pcie_parse_map_dma_ranges(struct xgene_pcie_port *port)
> +{
> +	struct device_node *np = port->node;
> +	struct of_pci_range range;
> +	struct of_pci_range_parser parser;
> +	struct device *dev = port->dev;
> +	int region;
> +
> +	if (pci_dma_range_parser_init(&parser, np)) {
> +		dev_err(dev, "missing dma-ranges property\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Get the dma-ranges from DT */
> +	for_each_of_pci_range(&parser, &range) {
> +		u64 restype = range.flags & IORESOURCE_TYPE_BITS;
> +		u64 end = range.cpu_addr + range.size - 1;
> +		dev_dbg(port->dev, "0x%08x 0x%016llx..0x%016llx -> 0x%016llx\n",
> +			range.flags, range.cpu_addr, end, range.pci_addr);
> +		region = xgene_pcie_select_ib_reg(range.size);
> +		if (region == -EINVAL) {
> +			dev_warn(port->dev, "invalid pcie dma-range config\n");
> +			continue;
> +		}
> +		xgene_pcie_setup_ib_reg(port, &range, restype, region);
> +	}
> +	return 0;
> +}

I guess is could even be a local variable in this function, which you pass
by reference.

> +
> +static int xgene_pcie_setup(int nr, struct pci_sys_data *sys)
> +{
> +	struct xgene_pcie_port *pp = xgene_pcie_sys_to_port(sys);
> +
> +	if (pp == NULL)
> +		return 0;
> +
> +	sys->mem_offset = pp->mem.res.start - pp->mem.pci_addr;
> +	pci_add_resource_offset(&sys->resources, &pp->mem.res,
> +				sys->mem_offset);
> +	return 1;
> +}

Please follow the regular error handling conventions, which are to
pass a negative errno value on error and zero on success.

Also, what would be a reason for the port to be zero here? If
it's something that can't happen in practice, don't try to handle
it gracefully. You can use BUG_ON() for fatal conditions that
are supposed to be impossible to reach.

> +static struct pci_bus __init *xgene_pcie_scan_bus(int nr,
> +						  struct pci_sys_data *sys)
> +{
> +	struct xgene_pcie_port *pp = xgene_pcie_sys_to_port(sys);
> +
> +	pp->first_busno = sys->busnr;
> +	xgene_pcie_setup_primary_bus(pp, sys->busnr, 0xff);
> +	return pci_scan_root_bus(NULL, sys->busnr, &xgene_pcie_ops,
> +				 sys, &sys->resources);
> +}

You have a number of helper functions that don't seem to gain
much at all. Just move the call to pci_scan_root_bus() into
xgene_pcie_setup_primary_bus() here, and use that as the .scan
callback.


> +	if (!port->link_up)
> +		dev_info(port->dev, "(rc) link down\n");
> +	else
> +		dev_info(port->dev, "(rc) x%d gen-%d link up\n",
> +				lanes, port->link_speed + 1);
> +#ifdef CONFIG_PCI_DOMAINS
> +	xgene_pcie_hw.domain++;
> +#endif
> +	xgene_pcie_hw.private_data[index++] = port;
> +	platform_set_drvdata(pdev, port);
> +	return 0;
> +}

Do you have multiple domains or not? I don't see how it can work if you
make the domain setup conditional on a kernel configuration option.
If you in fact have multiple domains, make sure in Kconfig that 
CONFIG_PCI_DOMAINS is enabled. Otherwise don't mess with the domain
number...

> +static const struct of_device_id xgene_pcie_match_table[] __initconst = {
> +	{.compatible = "apm,xgene-pcie",},
> +	{},
> +};

Another general note: Your "compatible" strings are rather unspecific.
Do you have a version number for this IP block? I suppose that it's related
to one that has been used in other chips before, or will be used in future
chips, if it's not actually licensed from some other company.

> +static int __init xgene_pcie_init(void)
> +{
> +	void *private;
> +	int ret;
> +
> +	pr_info("X-Gene: PCIe driver\n");
> +
> +	/* allocate private data to keep xgene_pcie_port information */
> +	private = kzalloc((XGENE_PCIE_MAX_PORTS * sizeof(void *)), GFP_KERNEL);

This should not be done unconditionally: There is no point in printing
a message or allocating memory if you don't actually run on a system
with this device.

> +	if (private == NULL)
> +		return -ENOMEM;

Style: if you are testing for an object, just write 'if (private)' or
'if (!private)', but don't compare against NULL.

> +	xgene_pcie_hw.private_data = private;
> +	ret = platform_driver_probe(&xgene_pcie_driver,
> +				    xgene_pcie_probe_bridge);
> +	if (ret)
> +		return ret;
> +	pci_common_init(&xgene_pcie_hw);
> +	return 0;

This seems wrong: You should not use platform_driver_probe() because
that has issues with deferred probing.

	Arnd
