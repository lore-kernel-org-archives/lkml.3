Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaIVJPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:15:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55306 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960AbaIVJPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:15:35 -0400
Date: Mon, 22 Sep 2014 10:15:36 +0100
From: Will Deacon <will.deacon@arm.com>
To: "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Harish.Kasiviswanathan@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [V8 1/2] irqchip: gic: Add support for multiple MSI for ARM64
Message-ID: <20140922091536.GB25809@arm.com>
References: <1411230698-8081-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1411230698-8081-2-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411230698-8081-2-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suravee,

Just a few minor comments.

On Sat, Sep 20, 2014 at 05:31:37PM +0100, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> This patch implelments the ARM64 version of arch_setup_msi_irqs(),
> which does not return 1 for when PCI_CAP_ID_MSI and nvec > 1.

s/implelments/implements/

> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Acked-by: Marc Zyngier <Marc.Zyngier@arm.com>
> Cc: Mark Rutland <Mark.Rutland@arm.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Catalin Marinas <Catalin.Marinas@arm.com>
> Cc: Will Deacon <Will.Deacon@arm.com>
> ---
>  arch/arm64/kernel/Makefile |  1 +
>  arch/arm64/kernel/msi.c    | 41 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+)
>  create mode 100644 arch/arm64/kernel/msi.c
> 
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index df7ef87..a921c42 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -29,6 +29,7 @@ arm64-obj-$(CONFIG_ARM64_CPU_SUSPEND)	+= sleep.o suspend.o
>  arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
>  arm64-obj-$(CONFIG_KGDB)		+= kgdb.o
>  arm64-obj-$(CONFIG_EFI)			+= efi.o efi-stub.o efi-entry.o
> +arm64-obj-$(CONFIG_PCI_MSI)		+= msi.o
>  
>  obj-y					+= $(arm64-obj-y) vdso/
>  obj-m					+= $(arm64-obj-m)
> diff --git a/arch/arm64/kernel/msi.c b/arch/arm64/kernel/msi.c
> new file mode 100644
> index 0000000..a295862
> --- /dev/null
> +++ b/arch/arm64/kernel/msi.c
> @@ -0,0 +1,41 @@
> +/*
> + * ARM64 architectural MSI implemention
> + *
> + * Support for Message Signalelled Interrupts for systems that
> + * implement ARM Generic Interrupt Controller: GICv2m.

You can drop the GICv2M reference here, as there's not really anything
GIC-specific in this file.

> + * Copyright (C) 2014 Advanced Micro Devices, Inc.
> + * Authors: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + */
> +
> +#include <linux/irq.h>
> +#include <linux/msi.h>
> +#include <linux/pci.h>
> +
> +/*
> + * ARM64 function for seting up MSI irqs.
> + * Based on driver/pci/msi.c: arch_setup_msi_irqs().
> + *
> + * Note:
> + * Current implementation assumes that all interrupt controller used in
> + * ARM64 architecture _MUST_ supports multi-MSI.

I think you can remove this comment, to be honest.

> + */
> +int arm64_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> +{

Shouldn't this be called arch_setup_msi_irqs, since the intention is that
you override the weak symbol?

> +	struct msi_desc *entry;
> +	int ret;
> +
> +	list_for_each_entry(entry, &dev->msi_list, list) {
> +		ret = arch_setup_msi_irq(dev, entry);
> +		if (ret < 0)
> +			return ret;
> +		if (ret > 0)
> +			return -ENOSPC;

When does this function ever return a value > 0?

Will
