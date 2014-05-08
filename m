Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaEHMRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 08:17:19 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:44478 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaEHMRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 08:17:17 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [patch 00/32] genirq: Another round of tree wide cleanups
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20140507153622.703412101@linutronix.de>
References: <20140507153622.703412101@linutronix.de>
Date: Thu, 08 May 2014 13:17:06 +0100
Message-Id: <20140508121706.E0591C40D85@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2014 15:44:03 -0000, Thomas Gleixner <tglx@linutronix.de> wrote:
> This cleanup series addresses a few histerical leftovers:
> 
> 1) irq_reserve_irq()
> 
>    The remaining callsites are pointless except s390, but we have a
>    better way to protect the lower interrupt space there.
> 
>    It's gone for good and it will never come back. Use irq domains, if
>    you want hot pluggable irq chips.
> 
> 2) create/destroy_irq and their variants
> 
>    Designed in different circles of hell we have an incompatible zoo
>    of those.
> 
>    Three different implementations with different semantics vs. the
>    return values. Two use cases which are just reusing the global
>    namespace. And they come along with four different flavours of
>    dynamic irq allocation.
> 
>    I created a core implementation for that and put it under
>    GENERIC_IRQ_LEGACY_ALLOC_HWIRQ to make clear that this is not for
>    new code. That implementation is used by x86 and tile. I gave up on
>    converting ia64 over, so I moved the create/destroy_irq prototypes
>    into ia64 headers and provided a wrapper for the shared dmar driver.
> 
>    The core implementation is a very basic allocator and that's
>    deliberately so. I don't want more users and every more complex
>    than that wants to use irq domains.
> 
> 3) dynamic_irq_init/cleanup
> 
>    Another leftover from the past. By moving tile and iop13xx to
>    sparse irq there is only ia64 left. I simplified the code and made
>    this available only under a legacy config option to avoid that more
>    people think they need this.
> 
> Full diffstat below.

For the whole series:

Reviewed-by: Grant Likely <grant.likely@linaro.org>

It all looks sane and a good cleanup. I've not done any testing though.

g.

> 
> Thanks,
> 
> 	tglx
> ---
>  arch/arm/Kconfig                          |    1 
>  arch/arm/mach-iop13xx/include/mach/irqs.h |    2 
>  arch/arm/mach-iop13xx/include/mach/time.h |    3 
>  arch/arm/mach-iop13xx/iq81340mc.c         |    1 
>  arch/arm/mach-iop13xx/iq81340sc.c         |    1 
>  arch/arm/mach-iop13xx/msi.c               |   51 ++---------
>  arch/arm/mach-iop13xx/setup.c             |    1 
>  arch/arm/mach-iop13xx/tpmi.c              |    1 
>  arch/ia64/Kconfig                         |    1 
>  arch/ia64/include/asm/hw_irq.h            |    1 
>  arch/ia64/include/asm/irq.h               |    3 
>  arch/ia64/include/asm/irq_remapping.h     |    2 
>  arch/ia64/kernel/iosapic.c                |    2 
>  arch/ia64/kernel/irq_ia64.c               |   15 ---
>  arch/mips/pci/msi-xlp.c                   |   10 --
>  arch/mips/pci/pci-xlr.c                   |   10 --
>  arch/s390/kernel/irq.c                    |    5 -
>  arch/s390/pci/pci.c                       |    6 -
>  arch/tile/Kconfig                         |    2 
>  arch/tile/include/asm/irq.h               |    6 -
>  arch/tile/kernel/irq.c                    |   40 ---------
>  arch/tile/kernel/pci_gx.c                 |   17 +--
>  arch/x86/Kconfig                          |    1 
>  arch/x86/include/asm/io_apic.h            |    2 
>  arch/x86/include/asm/irq_remapping.h      |    3 
>  arch/x86/kernel/apic/io_apic.c            |  130 +++++-------------------------
>  arch/x86/kernel/hpet.c                    |    5 -
>  arch/x86/platform/uv/uv_irq.c             |   10 --
>  drivers/iommu/dmar.c                      |    8 -
>  drivers/iommu/irq_remapping.c             |   12 +-
>  drivers/net/ethernet/tile/tilegx.c        |    6 -
>  drivers/pci/htirq.c                       |   13 ---
>  drivers/sh/intc/core.c                    |    6 -
>  drivers/tty/hvc/hvc_tile.c                |    8 -
>  drivers/tty/serial/tilegx.c               |    8 -
>  drivers/usb/host/ehci-tilegx.c            |    8 -
>  drivers/usb/host/ohci-tilegx.c            |    8 -
>  drivers/xen/events/events_base.c          |   17 ---
>  include/linux/irq.h                       |   38 +++-----
>  kernel/irq/Kconfig                        |    9 ++
>  kernel/irq/chip.c                         |    5 -
>  kernel/irq/internals.h                    |    6 +
>  kernel/irq/irqdesc.c                      |   95 ++++++++++++++-------
>  43 files changed, 216 insertions(+), 363 deletions(-)
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

