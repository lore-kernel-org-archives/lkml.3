Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbaKZIHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 03:07:30 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:23868 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752143AbaKZIH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 03:07:29 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ZAh2zJ8foWgi56cpGcrW4jdX1rbRLc/w=
X-DKIM: OpenDKIM Filter v2.0.1 titan 427AB62433C
Date: Wed, 26 Nov 2014 03:06:36 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Robert Richter <robert.richter@caviumnetworks.com>,
        "Yun Wu (Abel)" <wuyun.wu@huawei.com>
Subject: Re: [PATCH v3 00/13] arm64: PCI/MSI: GICv3 ITS support (stacked
 domain edition)
Message-ID: <20141126080636.GC22670@titan.lakedaemon.net>
References: <1416839720-18400-1-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416839720-18400-1-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc,

On Mon, Nov 24, 2014 at 02:35:07PM +0000, Marc Zyngier wrote:
> The GICv3 architecture provides a way to implement support for
> MSI/MSI-X using a specific block called the ITS (Interrupt Translation
> Service).
> 
> The ITS can be accurately described as "page tables for
> interrupts". If you think this sounds scary, you're spot on. It uses a
> set of opaque memory tables that are manipulated through commands
> (software almost never touches the tables directly). In order to make
> it slightly easier to digest, the code has been split into (mostly)
> logical units.
> 
> To make things more fun, this relies on Jiang Liu's stacked domain
> patch series as now merged in tip/irq/irqdomain:
> 
> - patch 1 imports the new asm-generic/msi.h file into arch/arm64
> - patches 2 to 13 are the bulk of the ITS driver.
> 
> This has been tested on arm64 with an FVP model, and is based on
> tip/irq/irqdomain. The whole thing is available at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git irq/gicv3-its
> 
> Unless someone screams murder, I consider this to be ready for merge.
> 
> 	M.
> 
> From v2 [2]:
> - rebased on top of the stable version of tip/irq/irqdomain
> - use irq_domain_reset_irq_data instead of
>   irq_domain_set_hwirq_and_chip on the free path
> - use pci_msi_mask_irq instead of mask_msi_irq
> - use host_data to pass the ITS structure around
> - top-level MSI domain is now indentified by the ITS of_node
> 
> From v1 [1]:
> - rebased on top of tip/irq/irqdomain
> - dropped the arm64-specific implementation of arch_setup_msi_irqs and co.
> - reworked the whole ITS/MSI setup to use the new MSI/PCI split
> 
> [1]: http://lwn.net/Articles/619788/
> [2]: https://lkml.org/lkml/2014/11/18/825
> 
> Marc Zyngier (13):
>   arm64: PCI/MSI: Use asm-generic/msi.h
>   irqchip: GICv3: Convert to domain hierarchy
>   irqchip: GICv3: rework redistributor structure
>   irqchip: GICv3: ITS command queue
>   irqchip: GICv3: ITS: irqchip implementation
>   irqchip: GICv3: ITS: LPI allocator
>   irqchip: GICv3: ITS: tables allocators
>   irqchip: GICv3: ITS: device allocation and configuration
>   irqchip: GICv3: ITS: MSI support
>   irqchip: GICv3: ITS: DT probing and initialization
>   irqchip: GICv3: ITS: plug ITS init into main GICv3 code
>   irqchip: GICv3: ITS: enable compilation of the ITS driver
>   irqchip: GICv3: Binding updates for ITS
> 
>  Documentation/devicetree/bindings/arm/gic-v3.txt |   39 +
>  arch/arm64/Kconfig                               |    1 +
>  arch/arm64/include/asm/Kbuild                    |    1 +
>  drivers/irqchip/Kconfig                          |    5 +
>  drivers/irqchip/Makefile                         |    1 +
>  drivers/irqchip/irq-gic-v3-its.c                 | 1402 ++++++++++++++++++++++
>  drivers/irqchip/irq-gic-v3.c                     |  156 ++-
>  include/linux/irqchip/arm-gic-v3.h               |  128 ++
>  8 files changed, 1693 insertions(+), 40 deletions(-)
>  create mode 100644 drivers/irqchip/irq-gic-v3-its.c

Applied to irqchip/core with a dependency on tip/irq/irqdomain

thx,

Jason.
