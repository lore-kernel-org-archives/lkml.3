Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab3FGKxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 06:53:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51555 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab3FGKxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 06:53:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: devicetree-discuss@lists.ozlabs.org
Cc: Jingoo Han <jg1.han@samsung.com>, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        linux-pci@vger.kernel.org,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 1/3] Add PCIe driver for Samsung Exynos
Date: Fri, 07 Jun 2013 12:53:02 +0200
Message-ID: <36071399.7aY6jgGn2d@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <000d01ce6360$9504e7e0$bf0eb7a0$@samsung.com>
References: <000d01ce6360$9504e7e0$bf0eb7a0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:77hLjRePgCzGBD6srNn1qnNSn58Az6tPhebsOcQ04yl
 Xbp95k3plDD68ubSwuH+G3yioNjFH9/yTaQxKwoACFHKZcoWrO
 uEmzhENcTRlypmafF6J1nFS/fSa+OrBJtEkEJOLazNdQENrivb
 CM5TVYFb8HdDP+joreCdznJtsESz08uS8Wl6Kn0M3JoC+Fbzbp
 oBwe4wY/90ZtAJBzF2cUJootTmbrDd9RcON2D6c28mrDcBlm94
 aDMgprr4ytSuXaaEyvmMkmGqPXClnGJaSVXezMTllcLzW98ErB
 EDH/GOCg4vvCO/L7G6Rhk3/4j7qHvURRiXxfttZ+7S/4+e4otG
 PChgkWqu8/GR+ukgJR+w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 June 2013 18:22:50 Jingoo Han wrote:

> diff --git a/Documentation/devicetree/bindings/pci/exynos-pcie.txt b/Documentation/devicetree/bindings/pci/exynos-pcie.txt
> new file mode 100644
> index 0000000..3eb4a2d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pci/exynos-pcie.txt
> @@ -0,0 +1,56 @@
> +* Samsung Exynos PCIe interface
> +
> +Required properties:
> +-compatible: should be "samsung,exynos5440-pcie"
> +-reg: base addresses and lengths of the pcie conteroller,
> +	additional register for the pcie controller,
> +	the phy controller,
> +	additional register for the phy controller.
> +- interrupts: interrupt values for level interrupt,
> +	pulse interrupt, special interrupt.
> +- device_type, set to "pci"
> +- bus-range: PCI bus numbers covered

Why is it that only a subset of bus numbers are used? Can't you address
the entire range?

> +- ranges: ranges for the PCI memory and I/O regions
> +- reset-gpio: gpio pin number of power good signal

The 'reset-gpio' property seems incorrect. I think this should either
use the gpio binding or the reset-controller binding. Specifying 
bare numbers to use as gpio pins does not work, since the number
space for Linux internal gpio numbers is not necessarily the same
as used by the hardware.

I think you also need an interrupt-map property as mandated by
the PCI binding, in order to use legacy interrupts, as well as
#address-cells and #size-cells.

> +       pcie0@40000000 {
> +               compatible = "samsung,exynos5440-pcie";
> +               reg = <0x40000000 0x4000
> +                       0x290000 0x1000
> +                       0x270000 0x1000
> +                       0x271000 0x40>;
> +               interrupts = <0 20 0>, <0 21 0>, <0 22 0>;
> +               device_type = "pci";
> +               bus-range = <0x0 0xf>;
> +               ranges = <0x00000800 0 0x40000000 0x40000000 0 0x00200000   /* configuration space */
> +                         0x81000000 0 0          0x40200000 0 0x00004000   /* downstream I/O */
> +                         0x82000000 0 0          0x40204000 0 0x10000000>; /* non-prefetchable memory */
> +       };
> +
> +       pcie1@60000000 {
> +               compatible = "samsung,exynos5440-pcie";
> +               reg = <0x60000000 0x4000
> +                       0x2a0000 0x1000
> +                       0x272000 0x1000
> +                       0x271040 0x40>;
> +               interrupts = <0 23 0>, <0 24 0>, <0 25 0>;
> +               device_type = "pci";
> +               bus-range = <0x0 0xf>;
> +               ranges = <0x00000800 0 0x60000000 0x60000000 0 0x00200000   /* configuration space */
> +                         0x81000000 0 0          0x60200000 0 0x00004000   /* downstream I/O */
> +                         0x82000000 0 0          0x60204000 0 0x10000000>; /* non-prefetchable memory */
> +       };

Is it intentional that in this example you set up both buses to
have both memory and I/O space start at address 0 in bus space?

I think it would be more logical to have non-overlapping addresses.
You can also choose to have an identity mapping for memory
space where a PCI bus address maps directly to the physical address
used to access it, although that will prevent you from using legacy
VGA cards that require the use of the low 16 MB.

Using a 16kb I/O space rather than a 64KB I/O space per port will
lead to pci_ioremap_io() map the start of your memory space into
PCI_IO_VIRT_BASE, which you probably didn't intend.

If your hardware cannot handle a full 64KB window, I would recommend
to at least leave a hole before the start of the memory window.

> +struct pcie_port {
> +	struct device		*dev;
> +	u8			controller;
> +	u8			root_bus_nr;
> +	void __iomem		*dbi_base;
> +	void __iomem		*va_dbi_base;
> +	void __iomem		*elbi_base;
> +	void __iomem		*va_elbi_base;
> +	void __iomem		*base;
> +	void __iomem		*phy_base;
> +	void __iomem		*va_phy_base;
> +	void __iomem		*purple_base;
> +	void __iomem		*va_purple_base;
> +	void __iomem		*cfg0_base;
> +	void __iomem		*va_cfg0_base;
> +	void __iomem		*cfg1_base;
> +	void __iomem		*va_cfg1_base;
> +	void __iomem		*io_base;
> +	void __iomem		*mem_base;
> +	spinlock_t		conf_lock;
> +	struct resource		io;
> +	struct resource		mem;
> +	struct resource		busn;

A lot of the fields above appear to be duplicated. If you
pass a physical address, that needs to be a phys_addr_t,
not void __iomem*. I think most of the physical addresses
can be removed there, and you just keep the virtual addresses
but drop the va_ prefix.

> +static int add_pcie_port(struct pcie_port *pp, struct platform_device *pdev)
> +{
> +	struct resource *dbi_base;
> +	struct resource *elbi_base;
> +	struct resource *phy_base;
> +	struct resource *purple_base;
> +	int ret;
> +
> +	dbi_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!dbi_base) {
> +		dev_err(&pdev->dev, "couldn't get dbi base resource\n");
> +		return -EINVAL;
> +	}
> +	if (!devm_request_mem_region(&pdev->dev, dbi_base->start,
> +				resource_size(dbi_base), pdev->name)) {
> +		dev_err(&pdev->dev, "dbi base resource is busy\n");
> +		return -EBUSY;
> +	}
> +	pp->dbi_base = (void __iomem *) (unsigned long)dbi_base->start;

That will also let you get rid of the casts here.


> +static int __exit exynos_pcie_remove(struct platform_device *pdev)
> +{
> +	return 0;
> +}
> +

an empty 'remove' function seems incorrect. I don't know what a
removable PCI should be doing here, but at least you need to undo
everything you set up in the probe function.


	Arnd
