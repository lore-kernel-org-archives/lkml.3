Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab3FQMoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:44:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64502 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab3FQMoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:44:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Jingoo Han <jg1.han@samsung.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        linux-pci@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Andrew Murray'" <andrew.murray@arm.com>
Subject: Re: [PATCH V5 1/3] pci: Add PCIe driver for Samsung Exynos
Date: Mon, 17 Jun 2013 14:44:40 +0200
Message-ID: <7174350.I5qK0sQfHM@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <005e01ce6b3f$74e3c940$5eab5bc0$@samsung.com>
References: <000b01ce6839$0f0455d0$2d0d0170$@samsung.com> <3539874.V7zkhbMg0b@wuerfel> <005e01ce6b3f$74e3c940$5eab5bc0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:xMRrsXnxPzY3SDDxzso6Kw1BmKsSHWDRlNStIQRtKhf
 BM1BmF3yU1dv6pLzZEs2N++NAvXIw/iOEON65tvQVPljxkVCg/
 QVbuOR1nTox/1ieF1kPCpyJkwPK2EKvq+VMgndi1BX1LwfVXJj
 KxgkeAEUdB8ep9L4pDgzlond71wPHnjlbxUWPJrI9YAABTm2a/
 fOCWd2Y8eIf856EZfb/Up5GKG0qxegRvwSPpDw6R5zqlAl8vIO
 CvtzIxVLSigUCXxEJ9HdxIIhUdk5fPwQr0fXJG4lcJ75X4j0bS
 +9IQlbFXcpv2oRokY+DjDYbXPLxrZIHWoGO/I7yL6HJBNPtrhz
 yEeyvLX5lJbZL3cYUUAU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 June 2013 18:45:52 Jingoo Han wrote:
> On Friday, June 14, 2013 9:54 PM, Arnd Bergmann wrote:
> > 
> > Please look up the documentation about inbound viewport and describe
> > in a code comment what it does. I /assume/ that this is how DMA accesses
> > from the bus get translated into AXI bus transactions. If so, you have
> > to let the window translate addresses from RAM. If it's something else,
> > then you should document what it is and how it needs to be set up.
> 
> One of our hardware engineer confirmed it.
> He said that these inbound functions are unnecessary.
> Also, I checked that PCIe works properly without these functions.
> So, I will remove these inbound functions.

Ok, good. So DMA just gets translated 1:1 independent of the
inbound viewport? Have you tested this with PCI device using
DMA?

> static int exynos_pcie_setup(int nr, struct pci_sys_data *sys)
> {
> 	struct pcie_port *pp;
> 
> 	pp = sys_to_pcie(sys);
> 
> 	if (!pp)
> 		return 0;
> 
> 	if (global_io_offset < SZ_1M && pp->config.io_size > 0) {
> 		sys->io_offset = global_io_offset - pp->config.io_bus_addr; /* normally 0 */
> 		pci_ioremap_io(sys->io_offset, pp->io.start);
> 		global_io_offset += SZ_64K;
> 	}
> 
> 	sys->mem_offset = pp->mem.start - pp->config.mem_bus_addr; /* normally 0 */
> 
> 	pci_add_resource_offset(&sys->resources, &pp->io, sys->io_offset);
> 	pci_add_resource_offset(&sys->resources, &pp->mem, sys->mem_offset);
> 
>         return 1;
> }

This is what I meant, yes.

> In this case, boot message is as below:
> 
> PCI host bridge to bus 0000:00
> pci_bus 0000:00: root bus resource [io  0x40001000-0x40010fff]
> pci_bus 0000:00: root bus resource [mem 0x40011000-0x5fffffff]
> pci_bus 0000:00: No busn resource found for root bus, will use [bus 00-ff]
> pci 0000:00:00.0: [144d:a549] type 01 class 0x060400
> [.....]
> PCI host bridge to bus 0001:00
> pci_bus 0001:00: root bus resource [io  0x60001000-0x60010fff] (bus address [0x5fff1000-0x6000
> 0fff])
> pci_bus 0001:00: root bus resource [mem 0x60011000-0x7fffffff]
> pci_bus 0001:00: No busn resource found for root bus, will use [bus 00-ff]
> pci 0001:00:00.0: [144d:a549] type 01 class 0x060400

The io resources here look wrong. I would have expected

pci_bus 0000:00: root bus resource [io  0x001000-0x00ffff]
pci_bus 0001:00: root bus resource [io  0x010000-0x01ffff] (bus address [0x000000-0x00ffff])

Please have a look at the pci-mvebu driver and how it calculates its
'realio' resource.

> > > > > +static int __exit exynos_pcie_remove(struct platform_device *pdev)
> > > > > +{
> > > > > +	struct pcie_port *pp = platform_get_drvdata(pdev);
> > > > > +
> > > > > +	clk_disable_unprepare(pp->bus_clk);
> > > > > +	clk_disable_unprepare(pp->clk);
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > >
> > > > You also don't remove the PCI devices here, as mentioned in an earlier
> > > > review.
> > >
> > > I reviewed Marvell PCIe driver and Tegra PCIe driver; however,
> > > I cannot know what you mean.
> > >
> > > Could let me know which additional functions are needed?
> > 
> > The mvebu driver does not allow module unload. I haven't looked at the
> > tegra driver. If you allow unloading the driver and provide a 'remove'
> > callback, that callback needs to clean up the entire bus and remove
> > all child devices that were added as well as undo everything the
> > probe function did. I think it would be great if you can do that, although
> > it might not be easy. The simplest solution would be to not support
> > unloading though.
> 
> As the mvebu driver uses platform_driver_probe(), the Exynos driver uses
> platform_driver_probe(). Thus, I will not provide a 'remove' callback.

Well, the important part is not to provide a module_exit() function, which
will ensure the driver cannot be unloaded.

	Arnd
