Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbaISWdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 18:33:08 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:64824 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758084AbaISWdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 18:33:05 -0400
Date: Fri, 19 Sep 2014 16:32:58 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, Liviu Dudau <liviu.dudau@arm.com>,
        linux-pci@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@apm.com, jcm@redhat.com
Subject: Re: [PATCH v9 1/4] pci:host: APM X-Gene PCIe host controller driver
Message-ID: <20140919223258.GA32208@google.com>
References: <1410906824-9321-1-git-send-email-tinamdar@apm.com>
 <1410906824-9321-2-git-send-email-tinamdar@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410906824-9321-2-git-send-email-tinamdar@apm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 03:33:41PM -0700, Tanmay Inamdar wrote:
> This patch adds the AppliedMicro X-Gene SOC PCIe host controller driver.
> X-Gene PCIe controller supports maximum up to 8 lanes and GEN3 speed.
> X-Gene SOC supports maximum 5 PCIe ports.
> 
> Reviewed-by: Liviu Dudau <Liviu.Dudau@arm.com>
> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
> ---
>  drivers/pci/host/Kconfig     |  10 +
>  drivers/pci/host/Makefile    |   1 +
>  drivers/pci/host/pci-xgene.c | 646 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 657 insertions(+)
>  create mode 100644 drivers/pci/host/pci-xgene.c
> ...

> +static inline void
> +xgene_pcie_cfg_in16(void __iomem *addr, int offset, u32 *val)

Whitespace - can fit on one line.  Also others below.

> +{
> +	*val = readl(addr + (offset & ~0x3));
> +
> +	switch (offset & 0x3) {
> +	case 2:
> +		*val >>= 16;
> +		break;
> +	}
> +
> +	*val &= 0xFFFF;
> +}
> +
> +static inline void
> +xgene_pcie_cfg_in8(void __iomem *addr, int offset, u32 *val)
> +{
> +	*val = readl(addr + (offset & ~0x3));
> +
> +	switch (offset & 0x3) {
> +	case 3:
> +		*val = *val >> 24;
> +		break;
> +	case 2:
> +		*val = *val >> 16;
> +		break;
> +	case 1:
> +		*val = *val >> 8;
> +		break;
> +	}
> +	*val &= 0xFF;
> +}
> +
> +/* When the address bit [17:16] is 2'b01, the Configuration access will be
> + * treated as Type 1 and it will be forwarded to external PCIe device.
> + */

Follow usual block comment style:

    /*
     * text
     */

> ...
> +static void xgene_pcie_fixup_bridge(struct pci_dev *dev)
> +{
> +	int i;
> +
> +	/* Hide the PCI host BARs from the kernel as their content doesn't
> +	 * fit well in the resource management
> +	 */

This needs a better explanation than "doesn't fit well."

I *think* you're probably talking about something similar to the MVEBU
devices mentioned here:
http://lkml.kernel.org/r/CAErSpo56jB1Bf2JtYCGKXZBZqRF1jXFxGmeewPX_e6vSXueGyA@mail.gmail.com

where the device can be configured as either an endpoint or a root port,
and the endpoint BARs are still visible when configured as a root port.

In any event, I'd like a description of exactly what these BARs are and wha
the problem is.  Presumably the BARs exist and were sized by the PCI core
in __pci_read_base().  That will generate some log messages and possibly
some warnings, depending on how the host bridge windows are set up.

We might eventually need a way to skip BARs like that altogether so we
don't even try to size them.

> +	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
> +		dev->resource[i].start = dev->resource[i].end = 0;
> +		dev->resource[i].flags = 0;
> +	}
> +	dev_info(&dev->dev, "Hiding X-Gene pci host bridge resources %s\n",
> +		 pci_name(dev));
> +}
> +DECLARE_PCI_FIXUP_HEADER(XGENE_PCIE_VENDORID, XGENE_PCIE_DEVICEID,
> +			 xgene_pcie_fixup_bridge);
> +
> ...

> +static void xgene_pcie_setup_ob_reg(struct xgene_pcie_port *port,
> +				    struct resource *res, u32 offset,
> +				    u64 cpu_addr, u64 pci_addr)
> +{
> +	void __iomem *base = port->csr_base + offset;
> +	resource_size_t size = resource_size(res);
> +	u64 restype = resource_type(res);
> +	u64 mask = 0;
> +	u32 min_size;
> +	u32 flag = EN_REG;
> +
> +	if (restype == IORESOURCE_MEM) {
> +		min_size = SZ_128M;
> +	} else {
> +		min_size = 128;
> +		flag |= OB_LO_IO;
> +	}
> +
> +	if (size >= min_size)
> +		mask = ~(size - 1) | flag;
> +	else
> +		dev_warn(port->dev, "res size 0x%llx less than minimum 0x%x\n",
> +			 (u64)size, min_size);

I'd include a %pR here to help identify the offending resource.

> +static int xgene_pcie_map_ranges(struct xgene_pcie_port *port,
> +				 struct list_head *res,
> +				 resource_size_t io_base)
> +{
> +	struct pci_host_bridge_window *window;
> +	struct device *dev = port->dev;
> +	int ret;
> +
> +	list_for_each_entry(window, res, list) {
> +		struct resource *res = window->res;
> +		u64 restype = resource_type(res);
> +
> +		dev_dbg(port->dev, "0x%08lx 0x%016llx...0x%016llx\n",
> +			res->flags, res->start, res->end);

Use %pR here.

> +
> +		switch (restype) {
> +		case IORESOURCE_IO:
> +			xgene_pcie_setup_ob_reg(port, res, OMR3BARL, io_base,
> +						res->start - window->offset);
> +			ret = pci_remap_iospace(res, io_base);
> +			if (ret < 0)
> +				return ret;
> +			break;
> +		case IORESOURCE_MEM:
> +			xgene_pcie_setup_ob_reg(port, res, OMR1BARL, res->start,
> +						res->start - window->offset);
> +			break;
> +		case IORESOURCE_BUS:
> +			break;
> +		default:
> +			dev_err(dev, "invalid io resource!");

If you're going to print something here, you might as well include the type
that seems invalid.  If you use %pR, I think it will do that automatically.

> +			return -EINVAL;
> +		}
> +	}
> +	xgene_pcie_setup_cfg_reg(port->csr_base, port->cfg_addr);
> +
> +	return 0;
> +}

Bjorn
