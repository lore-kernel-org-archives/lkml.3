Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaEFQfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:35:18 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:46795 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbaEFQfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:35:15 -0400
Date: Tue, 6 May 2014 10:35:08 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-pci@vger.kernel.org,
        Marek Vasut <marex@denx.de>, balajitk@ti.com,
        Mohit Kumar <mohit.kumar@st.com>, Jingoo Han <jg1.han@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>, rogerq@ti.com
Subject: Re: [PATCH 05/17] pci: host: pcie-dra7xx: add support for
 pcie-dra7xx controller
Message-ID: <20140506163507.GA15542@obsidianresearch.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com>
 <1399383244-14556-6-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399383244-14556-6-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 07:03:51PM +0530, Kishon Vijay Abraham I wrote:
> +Example:
> +pcie@51000000 {
> +	compatible = "ti,dra7xx-pcie";
> +	reg = <0x51002000 0x14c>, <0x51000000 0x2000>;
> +	reg-names = "ti_conf", "rc_dbics";
> +	interrupts = <0 232 0x4>, <0 233 0x4>;
> +	#address-cells = <3>;
> +	#size-cells = <2>;
> +	device_type = "pci";
> +	ti,device_type = <3>;
> +	ranges = <0x00000800 0 0x20001000 0x20001000 0 0x00002000  /* Configuration Space */

Configuration space should not show up in the ranges, please don't
copy that mistake from other drivers, put it in reg.

> +	interrupt-map-mask = <0 0 0 0>;
> +	interrupt-map = <0x0 0 &gic 134>;

The HW cannot decode INTA/B/C/D?

> +#define	PCIECTRL_DRA7XX_CONF_IRQSTATUS_MSI		0x0034
> +#define	PCIECTRL_DRA7XX_CONF_IRQENABLE_SET_MSI		0x0038
> +#define	INTA						BIT(0)
> +#define	INTB						BIT(1)
> +#define	INTC						BIT(2)
> +#define	INTD						BIT(3)
> +#define	MSI						BIT(4)
> +#define	LEG_EP_INTERRUPTS (INTA | INTB | INTC | INTD)

Oh, it can, it would be wise to export this from the driver. Look at
the latest patches from Srikanth Thokala for the Xilinx PCI driver to
see how this should look

> +static int dra7xx_pcie_establish_link(struct pcie_port *pp)
> +{
> +	u32 reg;
> +	int retries = 1000;
> +	struct dra7xx_pcie *dra7xx = to_dra7xx_pcie(pp);
> +
> +	if (dw_pcie_link_up(pp)) {
> +		dev_err(pp->dev, "link is already up\n");
> +		return 0;
> +	}
> +
> +	reg = dra7xx_pcie_readl(dra7xx->base, PCIECTRL_DRA7XX_CONF_DEVICE_CMD);
> +	reg |= LTSSM_EN;
> +	dra7xx_pcie_writel(dra7xx->base, PCIECTRL_DRA7XX_CONF_DEVICE_CMD, reg);
> +
> +	while (--retries) {
> +		reg = dra7xx_pcie_readl(dra7xx->base,
> +					PCIECTRL_DRA7XX_CONF_PHY_CS);
> +		if (reg & LINK_UP)
> +			break;
> +		usleep_range(10, 20);
> +	}
> +
> +	if (retries <= 0) {
> +		dev_err(pp->dev, "link is not up\n");
> +		return -ETIMEDOUT;
> +	}
> +
> +	return 0;
> +}

It would be really nice to see the link bring up process live in the
PCI core, every driver seems to have its own take on this.

The PCI-E spec requires a 100ms delay after link bring up (aka hot
reset) before sending any configuration TLPs.

Jason
