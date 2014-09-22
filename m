Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaIVXIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 19:08:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:42924 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbaIVXIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 19:08:38 -0400
Date: Tue, 23 Sep 2014 01:08:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
cc: marc.zyngier@arm.com, Mark Rutland <mark.rutland@arm.com>,
        jason@lakedaemon.net, pawel.moll@arm.com, Catalin.Marinas@arm.com,
        Will.Deacon@arm.com, liviu.dudau@arm.com,
        Harish.Kasiviswanathan@amd.com, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [V8 1/2] irqchip: gic: Add support for multiple MSI for ARM64
In-Reply-To: <1411230698-8081-2-git-send-email-suravee.suthikulpanit@amd.com>
Message-ID: <alpine.DEB.2.10.1409222349560.4604@nanos>
References: <1411230698-8081-1-git-send-email-suravee.suthikulpanit@amd.com> <1411230698-8081-2-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2014, suravee.suthikulpanit@amd.com wrote:

> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> This patch implelments the ARM64 version of arch_setup_msi_irqs(),
> which does not return 1 for when PCI_CAP_ID_MSI and nvec > 1.

I can see that myself. What your changelog is missing is the reason
WHY you think that copying that code from drivers/pci/msi.c and
removing the "PCI_CAP_ID_MSI and nvec > 1" has any value.
 
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Acked-by: Marc Zyngier <Marc.Zyngier@arm.com>

....

>  arch/arm64/kernel/Makefile |  1 +
>  arch/arm64/kernel/msi.c    | 41 +++++++++++++++++++++++++++++++++++++++++

And that new function "arm64_setup_msi_irqs" is declared in which
header file exactly?

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
> + *
> + * Copyright (C) 2014 Advanced Micro Devices, Inc.
> + * Authors: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Copying stuff from A to B makes a real case for copyright, i.e. I'm
impressed by your ability to copy right.

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

This is not based on. This is a verbatim copy with the omission of two
lines. Very creative that ...

> + *
> + * Note:
> + * Current implementation assumes that all interrupt controller used in
> + * ARM64 architecture _MUST_ supports multi-MSI.

Great assumption....

> + */
> +int arm64_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)

What the heck is calling that code? The follow up patch does not and
due to lack of a declaration this patch is completely pointless.

So you add a new file with a pointless changelog and a boasting
copyright notice which adds completely useless functionality?

Well done.

At least you are consistent on the useless side of affairs:

> +{
> +	struct msi_desc *entry;
> +	int ret;
> +
> +	list_for_each_entry(entry, &dev->msi_list, list) {
> +		ret = arch_setup_msi_irq(dev, entry);

Anyone who has the slightest idea how multi-MSI works will know that
this CANNOT work at all, but that's none of my business.

What's part of my business is to state that in my role as the
maintainer of all things related to interrupts this is the worst patch
I've seen in the last 10 years. Along with the saddening fact that it
carries the Acked-by of someone who should have known better.

At least if confirms my suspicion that ARM64 is a dignified successor
of the already infamous ARM32 universe.

I really can't bear the suspension to see the first 1500+ vendor patch
series of dubious quality supporting a real ARM64.

Thanks,

	tglx
