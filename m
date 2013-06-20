Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965223Ab3FTKBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:01:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56351 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965153Ab3FTKBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:01:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH V6 1/3] pci: Add PCIe driver for Samsung Exynos
Date: Thu, 20 Jun 2013 12:00:57 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
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
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        Pratyush Anand <pratyush.anand@st.com>
References: <00c001ce6d85$4613e530$d23baf90$@samsung.com>
In-Reply-To: <00c001ce6d85$4613e530$d23baf90$@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306201200.58057.arnd@arndb.de>
X-Provags-ID: V02:K0:9GXbYwwZnBFYcT2xRCethqqRCYaky2dhuMCCfgFp9p/
 mZOyNnsUyRl9shaD95awoxK5hU9N2kqDrDRVDf4CbXuuJKGrYt
 HD1kmB0JumzFal1zyMvcYooDHN2r3AYwbER/su0pwjorXpo75V
 NYF9PUs3txsCiVTzJ8P7Bn/tD812ovzW60XOG9CU1hvjolYB6m
 tiztqLkGSY3DqfDh7uS5aS54vGgIxxpp7Pf+z+14A1dOh16r4r
 vDH2fk3vwgT54NTLFlsFps+9xROupLiAy/gBxwxGO2oEiCgfsT
 SnSc5e6lWeuxChjStggL17a3nWK975AVVnGcxCU2KU0AfsSYa6
 nUiQp7vnwiamevylXe40=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 June 2013, Jingoo Han wrote:
> Exynos5440 has a PCIe controller which can be used as Root Complex.
> This driver supports a PCIe controller as Root Complex mode.
> 
> Signed-off-by: Surendranath Gurivireddy Balla <suren.reddy@samsung.com>
> Signed-off-by: Siva Reddy Kallam <siva.kallam@samsung.com>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

The code looks good now.

Acked-by: Arnd Bergmann <arnd@arndb.de>

>  .../devicetree/bindings/pci/exynos-pcie.txt        |   71 ++
>  drivers/pci/host/Kconfig                           |    5 +
>  drivers/pci/host/Makefile                          |    1 +
>  drivers/pci/host/pci-exynos.c                      | 1057 ++++++++++++++++++++
>  4 files changed, 1134 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pci/exynos-pcie.txt
>  create mode 100644 drivers/pci/host/pci-exynos.c

But please change the identifier to designware or synopsys as I
asked you to.

Have a look at http://permalink.gmane.org/gmane.linux.kernel.pci/18400

This was an earlier submission for a PCIe host driver obviously
based on the same IP block. I don't know why that driver never
made it into the kernel, but if it gets submitted again, or another
platform uses the same block, it should share most of your driver.

Whatever is exynos specific then can be moved out to a separate
file.

> +Required properties:
> +-compatible: should be "samsung,exynos5440-pcie"

Please also add a generic string, e.g.

- compatible: should contain "snps,dwc-pcie" to identify the
  core, plus an identifier for the specific instance, such
  as "samsung,exynos5440-pcie".

> +
> +static unsigned long global_io_offset;
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
> +	if (global_io_offset < SZ_1M && pp->config.io_size > 0) {
> +		sys->io_offset = global_io_offset - pp->config.io_bus_addr;
> +		pci_ioremap_io(sys->io_offset, pp->io.start);
> +		global_io_offset += SZ_64K;
> +	}
> +
> +	sys->mem_offset = pp->mem.start - pp->config.mem_bus_addr;
> +
> +	pci_add_resource_offset(&sys->resources, &pp->io, sys->io_offset);
> +	pci_add_resource_offset(&sys->resources, &pp->mem, sys->mem_offset);
> +
> +	return 1;
> +}

Just noticed one detail here: the 'pci_add_resource_offset' for the
I/O window should be inside of the 'if' clause, we must not annouce
the I/O port range to the PCI core layer unless we have actually
mapped it.

	Arnd
