Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab3C0QOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:14:06 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:42275 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab3C0QOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:14:04 -0400
Date: Wed, 27 Mar 2013 10:13:54 -0600
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
Message-ID: <20130327161354.GB13830@obsidianresearch.com>
References: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
 <00c501ce277c$30e49dc0$92add940$%han@samsung.com>
 <20130325170448.GB16690@obsidianresearch.com>
 <020e01ce2ac6$14fd7850$3ef868f0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <020e01ce2ac6$14fd7850$3ef868f0$%han@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 05:35:48PM +0900, Jingoo Han wrote:

> Here is the lspci -vv output.
> I tested Exynos PCIe with e1000e lan card.
> 
> 00:00.0 PCI bridge: Samsung Electronics Co Ltd Device a549 (rev 01) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>         I/O behind bridge: 00000000-00000fff
>         Memory behind bridge: 40300000-403fffff
>         Prefetchable memory behind bridge: 40400000-404fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity+ SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>         Capabilities: <access denied>
>         Kernel driver in use: pcieport

This is very similar to tegra, you should try to follow the same path
as Thierry did.

Basically, have only one PCI host from Linux's perspective. This means
the driver only calls pci_create_root_bus once. The driver makes all
the ports available under that single root_bus. It does this by
routing the config access to the four different MMIO config regions
depending on the bus number and device number.

When done, lspci should look something like this:

 00:01.0 PCI bridge: Samsung Electronics Co Ltd Device a549 (rev 01) (prog-if 00 [Normal decode])
 00:02.0 PCI bridge: Samsung Electronics Co Ltd Device a549 (rev 01) (prog-if 00 [Normal decode])

Notice the bus number of both root port bridges is 0. This is now
compliant with the PCI-E specification for root complex behavior. Bus
0 is the root complex bus.

The driver can then use this information in the bridges:
>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
To route config transactions for bus != 0 to the proper port and
correctly generate type 0 or type 1 config TLPs.

I hope this makes sense. Tegra's implementation is very close to this,
but the bus != 0 case will be more like Marvell. (If I read your
driver right)

> 10:00.0 PCI bridge: Samsung Electronics Co Ltd Device a549 (rev 01)
> (prog-if 00 [Normal decode])

There is something funny here, this is bus 0x10, but your bindings had
bus-range 0 -> 0xf on both nodes.

> > However, based on your driver this HW looks similar to tegra, did you
> > review how tegra is setup? Merging all the ports into a single domain
> > is certainly preferred.
> 
> In Tegra case, the address of IO control register is same.
> +	pcie-controller {
> +		compatible = "nvidia,tegra20-pcie";
> +		reg = <0x80003000 0x00000800   /* PADS registers */
> +		       0x80003800 0x00000200   /* AFI registers */
> +		       0x81000000 0x01000000   /* configuration space */
> +		       0x90000000 0x10000000>; /* extended configuration space */
>
> But, in Exynos case, address of IP control register is different
> between PCIe0 and PCIe1.

tegra has both shared registers and per-port registers. The ones above
are shared.

This message has the final DT bindings for the Marvell and tegra
cases:

http://permalink.gmane.org/gmane.linux.kernel.pci/21209

The per-port registers are being passed to the driver here:

   	     pci@1,0 {
 	     	      device_type = "pci";
 		      assigned-addresses = <0x82000800 0 0x80000000 0 0x1000>;
                      reg = <0x000800 0 0 0 0>;

via assigned-addresses.

Marvell has no shared registers, you can see in its binding they are
all passed through assigned-addresses.

Also, the above DT nodes is representing the root port bridge PCI
device. In your case it would be this:

 00:01.0 PCI bridge: Samsung Electronics Co Ltd Device a549 (rev 01) (prog-if 00 [Normal decode])

0x800 is the DT encoding of 00:01.0

> > > +		ranges = <0x00000800 0 0x60000000 0x60000000 0 0x00200000   /* configuration space */
> > 
> > Do not include configuration space in ranges
> 
> How can I include configuration space?
> Please let me know kindly :)

There is no need to specify configuration space at all. If you copied
this from an older tegra binding it was an early way to try and define
per-port registers. After discussion the use of assigned-addresses was
choosen instead.
 
> > It is usual to have an interrupt-map - have you tested that interrupts
> > resolve properly?
>
> There is no problem about interrupts.

I see, you have exynos_pcie_map_irq in code. interrupt-map replaces
that functionality in a standard way, and is more capable for edge
cases.

> However, I will consider an interrupt-map.

You can copy the interrupt-map style from the Marvell driver, which
seems like it matches your case..

Jason
