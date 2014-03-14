Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbaCNMTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 08:19:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64122 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaCNMTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 08:19:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: [PATCH v4 1/4] pci: APM X-Gene PCIe controller driver
Date: Fri, 14 Mar 2014 13:18:26 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, Liviu Dudau <liviu.dudau@arm.com>,
        linux-pci@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@apm.com, jcm@redhat.com
References: <1394085963-27553-1-git-send-email-tinamdar@apm.com> <1394085963-27553-2-git-send-email-tinamdar@apm.com>
In-Reply-To: <1394085963-27553-2-git-send-email-tinamdar@apm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201403141318.27183.arnd@arndb.de>
X-Provags-ID: V02:K0:7VNP6T5fJzijWj0TtuQB6tF+/OTJdBD7pwpCN1iNe4i
 xYFE+CbfV0FtkDF6ezhsvlXF+uUnyXX/F5POdLQ9XpoA5GFxiD
 dt1/0LNuHgO/Q0ewkYLEgTM3PFsqOtc37WXh6pCmUMkXYDpL2Y
 qMvl7RTJ0okw4B1bjl0tj+aglxXvW1fQM8h2OgTjCqxwa+Rndx
 XJ0bv4Jgeb5zW7hxbnGzwYcc3jbEVpTkXTbyhzAcuBWmJbITCF
 aTiEaNg+91esJMUyZzRC4m61MVtGTFG4wbSenP1CX9oc0lcJqu
 wpxLOBrIkn3+Z3l95bHg2F2X3wcL0vSuIiDmuZedtpsePvfilp
 i7IZOjWk1iGGA60iiJQpGL61odhHHLAQYO7BPqc+h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2014, Tanmay Inamdar wrote:

> +static inline void xgene_pcie_cfg_out16(void __iomem *addr, u16 val)
> +{
> +	u64 temp_addr = (u64)addr & ~0x3;

Please use 'unsigned long' as the type for calculations like this one,
to make the code more portable. You mentioned before that the same PCI
host controller is used on some ppc4xx, and we may want to share the
code later.

> +static int xgene_pcie_read_config(struct pci_bus *bus, unsigned int devfn,
> +				  int offset, int len, u32 *val)
> +{
> +	struct xgene_pcie_port *port = bus->sysdata;
> +	void __iomem *addr;
> +	u8 val8;
> +	u16 val16;
> +
> +	if ((pci_is_root_bus(bus) && devfn != 0) || !port->link_up)
> +		return PCIBIOS_DEVICE_NOT_FOUND;
> +
> +	xgene_pcie_set_rtdid_reg(bus, devfn);
> +	addr = xgene_pcie_get_cfg_base(bus);
> +	switch (len) {
> +	case 1:
> +		xgene_pcie_cfg_in8(addr + offset, &val8);
> +		*val = val8;
> +		break;

Actually it would be better to just pass both addr and offset
down into the low-level accessors and then do the calculation
on 'offset', which is already a scalar.

> +static void xgene_pcie_poll_linkup(struct xgene_pcie_port *port,
> +				   u32 *lanes, u32 *speed)
> +{
> +	void __iomem *csr_base = port->csr_base;
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
> +			*speed = PIPE_PHY_RATE_RD(val32);
> +			val32 = readl(csr_base + BRIDGE_STATUS_0);
> +			*lanes = val32 >> 26;
> +			break;
> +		}
> +		msleep(1);
> +		time = jiffies_to_msecs(jiffies - start_time);
> +	} while (time <= XGENE_LTSSM_L0_WAIT);
> +}

This can be written ina simpler way using 'time_before()'.

> +/* Return 0 on success */
> +static int xgene_pcie_init_ecc(struct xgene_pcie_port *port)
> +{
> +	void __iomem *csr_base = port->csr_base;
> +	u64 start_time, time = 0;
> +	u32 val;
> +
> +	val = readl(csr_base + MEM_RAM_SHUTDOWN);
> +	if (!val)
> +		return 0;
> +	writel(0x0, csr_base + MEM_RAM_SHUTDOWN);
> +	start_time = jiffies;
> +	do {
> +		val = readl(csr_base + BLOCK_MEM_RDY);
> +		if (val == BLOCK_MEM_RDY_VAL)
> +			break;
> +		msleep(1);
> +		time = jiffies_to_msecs(jiffies - start_time);
> +	} while (time < XGENE_PCIE_ECC_TIMEOUT);

Same here.

> +static int xgene_pcie_init_port(struct xgene_pcie_port *port)
> +{
> +	int rc;
> +
> +	port->clk = clk_get(port->dev, NULL);
> +	if (IS_ERR_OR_NULL(port->clk)) {
> +		dev_err(port->dev, "clock not available\n");
> +		return -ENODEV;
> +	}

Practically every use of IS_ERR_OR_NULL() is a bug, don't do that.
NULL is a valid return code from clk_get(), and should not be
treated as an error.


> +static int xgene_pcie_map_ranges(struct xgene_pcie_port *port,
> +				 struct pci_host_bridge *bridge,
> +				 u64 cfg_addr)
> +{
> +	struct device *dev = port->dev;
> +	struct pci_host_bridge_window *window;
> +
> +	list_for_each_entry(window, &bridge->windows, list) {
> +		struct resource *res = window->res;
> +		u64 restype = resource_type(res);
> +		dev_dbg(port->dev, "0x%08lx 0x%016llx...0x%016llx\n",
> +			res->flags, res->start, res->end);
> +
> +		switch (restype) {
> +		case IORESOURCE_IO:
> +			xgene_pcie_setup_ob_reg(port, res, OMR2BARL,
> +						bridge->io_base);
> +			BUG_ON(pci_ioremap_io(res, bridge->io_base) < 0);
> +			break;

No need to BUG_ON() here, this is not a fatal condition, just
don't register the I/O space resource if this fails.

I think as the PCI base support patch series evolves, you will actually
not have to do this at all.

	Arnd
