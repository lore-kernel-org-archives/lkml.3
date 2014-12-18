Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaLRAJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 19:09:30 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:53007 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaLRAJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 19:09:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Murali Karicheri <m-karicheri2@ti.com>, vinod.koul@intel.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-pci@vger.kernel.org,
        bhelgaas@google.com, will.deacon@arm.com,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC PATCH 1/2] common: dma-mapping: introduce dma_get_parent_cfg() helper
Date: Thu, 18 Dec 2014 01:09:17 +0100
Message-ID: <2935351.ba8Au9y4fE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <549210BB.9080603@ti.com>
References: <1418839344-14393-1-git-send-email-m-karicheri2@ti.com> <1949667.gMcOLHe7Sk@wuerfel> <549210BB.9080603@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:Yk2CkOKOuzWM0WfH6zyO3l80UYWbjMBm4iuvKP46q5Ft2lSivL1
 PLkm3MlDTn9FdG6ThwY6D/6ctGky+mQGqNF8+D0B17EcBbDnK9QXcMiSFze59aHQfsheaSX
 60Gl37k/REzeo1ptVYwUeSwjQeKVzJPzqoW0aOjg92cv8hOwtKQIlLfLIdDsCOSHOpMZ/WC
 +ohdiBZ6OUW4SVRt2kOBw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 December 2014 18:24:43 Murali Karicheri wrote:
> On 12/17/2014 04:56 PM, Arnd Bergmann wrote:
> > On Wednesday 17 December 2014 13:02:23 Murali Karicheri wrote:
> >
> > What's wrong with using arch_setup_dma_ops() from PCI as suggested
> > previously?
> >

+Will Deacon

> I had originally written a code based on that line as below. But 
> dma-ranges property is also used by ppc and other architectures in the 
> pci device DT node. So I wasn't sure how this code impact PCI driver 
> functionality on those platforms. Hence used a simpler change as all 
> that is needed for keystone is to get the dma_pfn_offset rightly set in 
> the pci slave device.

But in your patch, you don't call arch_setup_dma_ops() at all.

> Initially I had a function implemented as below for this in of_pci.c.
> 
> + * of_pci_dma_configure - Setup DMA configuration for a pci device
> + * @dev:       pci device to apply DMA configuration
> + *
> + * Try to get devices's DMA configuration from DT and update it
> + * accordingly. This is a similar to of_dma_configure() for platform
> + * devices.
> + *
> + */
> +void of_pci_dma_configure(struct pci_dev *dev)
> +{
> +       struct device *host_bridge, *parent;
> +       struct pci_bus *bus = dev->bus;
> +       u64 dma_addr, paddr, size;
> +       int ret;
> +
> +       while (!pci_is_root_bus(bus))
> +               bus = bus->parent;
> +       host_bridge = bus->bridge;
> +
> +       parent = host_bridge->parent;
> +       if (parent->of_node) {

so far it looks good, although we may want to introduce
a helper function to get the of_node.

> +               /*
> +                * if dma-coherent property exist, call arch hook to setup
> +                * dma coherent operations.
> +                */
> +               if (of_dma_is_coherent(parent->of_node)) {
> +                       set_arch_dma_coherent_ops(&dev->dev);
> +                       dev_info(&dev->dev, "device is dma coherent\n");
> +               }

set_arch_dma_coherent_ops no longer exists. Just keep the flag in a
local variable

> +               /*
> +                * if dma-ranges property doesn't exist - just return else
> +                * setup the dma offset
> +                */
> +               ret = of_dma_get_range(parent->of_node, &dma_addr, 
> &paddr, &size);
> +               if (ret < 0) {
> +                       dev_info(&dev->dev, "no dma range information to 
> setup\n");
> +                       printk("no dma range information to setup\n");
> +                       return;
> +               }
> +
> +               /* DMA ranges found. Calculate and set dma_pfn_offset */
> +               dev->dev.dma_pfn_offset = PFN_DOWN(paddr - dma_addr);
> +               dev_info(&dev->dev, "dma_pfn_offset(%#08lx)\n", 
> dev->dev.dma_pfn_offset);

Same for the offset and size here, then pass all of the above into
arch_setup_dma_ops. This is also where we need to hook up the iommu
support once we decide how to make that work with the ARM SMMU.

Will, I think we may have a problem on ARM64 now, since we only replaced
set_arch_dma_coherent_ops on ARM32 but not ARM64. Can you send a fix for
this? Without that, we don't have any coherent operations on ARM64 any
more, unless I'm missing something.

	Arnd
