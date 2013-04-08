Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935413Ab3DHQ4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:56:39 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:41331 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760109Ab3DHQ4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:56:37 -0400
Date: Mon, 8 Apr 2013 10:56:26 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
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
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
Subject: Re: [PATCH 6/6] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Message-ID: <20130408165626.GA30824@obsidianresearch.com>
References: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
 <00c501ce277c$30e49dc0$92add940$%han@samsung.com>
 <000001ce3438$b136e1e0$13a4a5a0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001ce3438$b136e1e0$13a4a5a0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 06:08:53PM +0900, Jingoo Han wrote:

> I have a question.  Now, I am reviewing the Tegra PCIe, Marvell PCIe
> patchset.  However, in the case of Exynos PCIe, 'downstream I/O' and
> 'non-prefetchable memory' are different between PCIe0 and PCIe1.
> These regions are not shared.
> 
> PCIe0:
> 	ranges = <0x00000800 0 0x40000000 0x40000000 0 0x00200000   /* configuration space */
> 		  0x81000000 0 0	  0x40200000 0 0x00004000   /* downstream I/O */
> 		  0x82000000 0 0	  0x40204000 0 0x10000000>; /* non-prefetchable memory */
> 
> PCIe1:
> 	ranges = <0x00000800 0 0x40000000 0x40000000 0 0x00200000   /* configuration space */
> 		  0x81000000 0 0	  0x40200000 0 0x00004000   /* downstream I/O */
> 		  0x82000000 0 0	  0x40204000 0 0x10000000>; /* non-prefetchable memory */
> 
> PCIe0 uses 0x40000000~0x5fffffff, PCI1 uses 0x60000000~0x7fffffff.
> 
> How can I handle this? :)

You need to dig into where this range restriction comes from, and how
it interacts with the PCI-E root bridge's window registers. Is there
another set of registers that control this? Is it hardwired into the
silicon? Do the root port window registers control this? 

I'm looking at functions like exynos_pcie_prog_viewport_mem_outbound
and wondering if the driver already controls this window.. But it
looks like there may be some restrictions.

Marvell also has unshared regions, but the driver arranges for those
ranges to be setup dynamically based on writes to the bridge's window
registers from the Linux PCI core, so the region is always in sync
with what the Linux PCI core is trying to do.

The desired perfect outcome is to have a single logical 'shared'
region for memory and I/O - give that region to the PCI core via
struct resources, then the PCI core tells the driver and HW what
portion of that region belongs to each root port via a write to the
root port bridge's window registers. The net result is still
non-overlapping regions, but the allocation of space between port 0
and port 1 is performed at run time.

I don't really know enough about your hardware to give you better
advice, sorry. The general guidance to try and follow the PCI-E spec
for a root complex is good, but if the HW can't do it, or it would
make the driver too complex, then one PCI domain per port will always
work (this is similar to your original driver, but with domains).

The main advantage to following the PCI-E specs and allowing for
dynamic allocation of address space is that it lets you reserve less
address space for PCI-E, and this in turn gives you more low mem
address space to use for DRAM.

> The following is right?
 
> +       pcie-controller {
> 		.....
> +               ranges = <0x82000000 0 0x40000000 0x40000000 0 0x00200000   /* port 0 registers */
> +                         0x82000000 0 0x60000000 0x60000000 0 0x00200000   /* port 1 registers */
> +                         0x81000000 0 0          0x40200000 0 0x00004000   /* port 0 downstream I/O */
> +                         0x81000000 0 0          0x60200000 0 0x00004000   /* port 1 downstream I/O */
> +                         0x82000000 0 0x40204000 0x40204000 0 0x10000000>; /* port 0 non-prefetchable memory */
> +                         0x82000000 0 0x40204000 0x60204000 0 0x10000000>; /* port 1 non-prefetchable memory */


> +
> +               pci@1,0 {
> +                       device_type = "pci";
> +                       assigned-addresses = <0x82000800 0 0x40000000 0 0x00200000
> +                                                 0x81000800 0 0x40200000 0 0x00004000
> +                                                 0x81000800 0 0x40204000 0 0x10000000>;

Would be:

                       ranges = <0x81000800 0 0x40200000  0x81000800 0 0x40200000  0 0x00004000
                                 0x81000800 0 0x40204000  0x81000800 0 0x40204000  0 0x10000000>;
                       assigned-addresses = <0x82000800 0 0x40000000  0 0x00200000>;

Jason
