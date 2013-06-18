Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab3FRN51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:57:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51695 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab3FRN5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:57:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH V5 1/3] pci: Add PCIe driver for Samsung Exynos
Date: Tue, 18 Jun 2013 15:56:47 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
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
References: <000b01ce6839$0f0455d0$2d0d0170$@samsung.com> <7174350.I5qK0sQfHM@wuerfel> <000001ce6bd7$50146e60$f03d4b20$@samsung.com>
In-Reply-To: <000001ce6bd7$50146e60$f03d4b20$@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306181556.47656.arnd@arndb.de>
X-Provags-ID: V02:K0:KVt1xjvVCUR0vtxhPuYrEXDXUah8U3bF9x0bJbGRFMg
 55SnMGdWnjjnZKqiJKQGvVqbfeJgxzjf7m4K7TYS20YB90GSEw
 bltCXBomVYkth8sUKJJWHtt2T9G8xVO6OqBk7QgPor2frHrf3+
 pa3Wg3YrgfRn8/MCsSkiLQL/BM2vMoe7K2RyVwuJK3NzUrw8S5
 xAtZhouP9k6cLfjC1QKKhaRZMGYTj0w2MYiGoojLAWGMybArAC
 2fp0Nf1fv7jDNCWVeZ5w/DdhsQf69FNkYYvkrcNzlhsabDlAsq
 NL7nhwVIrYR6qgQGRPSfgxh8Dxdwpi+AiCGlIMd1ckKge/XMvN
 2L4/M0w7yz/GrfjGIIpk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 June 2013, Jingoo Han wrote:
> On Monday, June 17, 2013 9:45 PM, Arnd Bergmann wrote:
> > On Monday 17 June 2013 18:45:52 Jingoo Han wrote:
> > > On Friday, June 14, 2013 9:54 PM, Arnd Bergmann wrote:
> > > >
> > > > Please look up the documentation about inbound viewport and describe
> > > > in a code comment what it does. I /assume/ that this is how DMA accesses
> > > > from the bus get translated into AXI bus transactions. If so, you have
> > > > to let the window translate addresses from RAM. If it's something else,
> > > > then you should document what it is and how it needs to be set up.
> > >
> > > One of our hardware engineer confirmed it.
> > > He said that these inbound functions are unnecessary.
> > > Also, I checked that PCIe works properly without these functions.
> > > So, I will remove these inbound functions.
> > 
> > Ok, good. So DMA just gets translated 1:1 independent of the
> > inbound viewport? Have you tested this with PCI device using
> > DMA?
> 
> According to our hardware engineer,
> He said that
> "That's correct. We tested it by doing a memory write from the device.
> A device DMA is a series of memory r/w so I expect it to work same way."
> 
> Also, he thought that I already tested too, since it works after removing
> the functions.

It could be that the default setting just creates a 1:1 map so that would
work, but if you tested it, that should be good enough.

> I looked at the pci-mvebu driver,
> Then I fixed it as the pci-mvebu driver did.
> Also, I added 'global_io_offset'.
> 
> @@ -909,6 +909,12 @@ static int __init exynos_pcie_probe(struct platform_device *pdev)
>                 if (restype == IORESOURCE_IO) {
>                         of_pci_range_to_resource(&range, np, &pp->io);
>                         pp->io.name = "I/O";
> +                       pp->io.start = max_t(resource_size_t,
> +                                               PCIBIOS_MIN_IO,
> +                                               range.pci_addr + global_io_offset);
> +                       pp->io.end = min_t(resource_size_t,
> +                                               IO_SPACE_LIMIT,
> +                                               range.pci_addr + range.size + global_io_offset);
>                         pp->config.io_size = resource_size(&pp->io);
>                         pp->config.io_bus_addr = range.pci_addr;
> 
> In this case, boot message is as below:
> 
> PCI host bridge to bus 0000:00
> pci_bus 0000:00: root bus resource [io  0x1000-0x10000]
> pci_bus 0000:00: root bus resource [mem 0x40011000-0x5fffffff]
> [.....]
> PCI host bridge to bus 0001:00
> pci_bus 0001:00: root bus resource [io  0x10000-0x20000] (bus address [0x0000-0x10000])
> pci_bus 0001:00: root bus resource [mem 0x60011000-0x7fffffff]

Ok, very good.
> 
> I will remove a 'remove' callback. Is it OK?
> Or what should I do?

I think you should keep the remove function, but add a comment explaining that
you don't allow module unload and that in order to allow it, the remove function
will have to remove all pci buses and devices under the host bridge.

	Arnd
