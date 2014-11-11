Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaKKQLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:11:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:12720 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbaKKQLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:11:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,362,1413270000"; 
   d="scan'208";a="635125271"
Message-ID: <546234FA.3060501@linux.intel.com>
Date: Wed, 12 Nov 2014 00:10:34 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 00/15] arm64: PCI/MSI: GICv3 ITS support (stacked domain
 edition)
References: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
In-Reply-To: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,
	Sorry for the late notification. I have heavily reworked the
interfaces for MSI irqdomain support based on review comments.
Please refer to https://lkml.org/lkml/2014/11/9/88, please give your
comments on the new interfaces:)
Regards!
Gerry

On 2014/11/11 23:47, Marc Zyngier wrote:
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
> patch series [1]. In order to make this work, the first three patches
> introduce support for stacked MSI domain on arm64 (the first patch is
> just a version of a existing patch by Yingjoe Chen, and is only
> included here for reference; the following two are the actual
> implementation).
> 
> I'd welcome some guidance of this stacked domain support, as this goes
> into a slightly different direction compared to what we've had on
> 32bit ARM so far (using the setup_irq/teardown_irq methods).
> 
> This has been tested on arm64 with an FVP model, and is based on
> 3.18-rc4 + Jiang's p2v5 series + a number of arm64-specific PCI
> patches. The whole thing is available at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git irq/stacked-its
> 
> 	M.
> 
> [1]: http://lwn.net/Articles/619388/
> 
> Marc Zyngier (15):
>   genirq: Add a few more helper funtions to support stacked irq_chip
>   PCI/MSI: genirq: allow architecture-specific override of flow handler
>   arm64: MSI: Add support for stacked MSI domain
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
>  arch/arm64/include/asm/msi.h                     |   26 +
>  arch/arm64/kernel/Makefile                       |    1 +
>  arch/arm64/kernel/msi.c                          |   80 ++
>  drivers/irqchip/Kconfig                          |    5 +
>  drivers/irqchip/Makefile                         |    1 +
>  drivers/irqchip/irq-gic-v3-its.c                 | 1343 ++++++++++++++++++++++
>  drivers/irqchip/irq-gic-v3.c                     |  163 ++-
>  drivers/pci/msi.c                                |    7 +-
>  include/linux/irq.h                              |    6 +
>  include/linux/irqchip/arm-gic-v3.h               |  128 +++
>  kernel/irq/chip.c                                |   31 +
>  13 files changed, 1790 insertions(+), 41 deletions(-)
>  create mode 100644 arch/arm64/include/asm/msi.h
>  create mode 100644 arch/arm64/kernel/msi.c
>  create mode 100644 drivers/irqchip/irq-gic-v3-its.c
> 
