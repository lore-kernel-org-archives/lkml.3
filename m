Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbaDHRfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 13:35:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39054 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbaDHRfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 13:35:47 -0400
Date: Tue, 8 Apr 2014 19:35:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: [PATCH v6 4/5] edac: Add support for Krait CPU cache error
 detection
Message-ID: <20140408173541.GO30077@pd.tnic>
References: <1396641450-12854-1-git-send-email-sboyd@codeaurora.org>
 <1396641450-12854-5-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1396641450-12854-5-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 12:57:29PM -0700, Stephen Boyd wrote:
> Add support for the Krait CPU cache error detection. This is a
> simplified version of the code originally written by Stepan
> Moskovchenko[1] ported to the EDAC device framework.
> 
> [1] https://www.codeaurora.org/cgit/quic/la/kernel/msm/tree/arch/arm/mach-msm/cache_erp.c?h=msm-3.4
> 
> Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/edac/Kconfig      |   8 +
>  drivers/edac/Makefile     |   2 +
>  drivers/edac/krait_edac.c | 370 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 380 insertions(+)
>  create mode 100644 drivers/edac/krait_edac.c
> 
> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
> index 878f09005fad..4dae3d353ea9 100644
> --- a/drivers/edac/Kconfig
> +++ b/drivers/edac/Kconfig
> @@ -368,4 +368,12 @@ config EDAC_OCTEON_PCI
>  	  Support for error detection and correction on the
>  	  Cavium Octeon family of SOCs.
>  
> +config EDAC_KRAIT_CACHE
> +	tristate "Krait L1/L2 Cache"
> +	depends on EDAC_MM_EDAC && ARM && OF
> +	select KRAIT_L2_ACCESSORS
> +	help
> +	  Support for error detection and correction on the
> +	  Krait L1/L2 cache controller.
> +
>  endif # EDAC
> diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
> index 4154ed6a02c6..b6ea50564223 100644
> --- a/drivers/edac/Makefile
> +++ b/drivers/edac/Makefile
> @@ -64,3 +64,5 @@ obj-$(CONFIG_EDAC_OCTEON_PC)		+= octeon_edac-pc.o
>  obj-$(CONFIG_EDAC_OCTEON_L2C)		+= octeon_edac-l2c.o
>  obj-$(CONFIG_EDAC_OCTEON_LMC)		+= octeon_edac-lmc.o
>  obj-$(CONFIG_EDAC_OCTEON_PCI)		+= octeon_edac-pci.o
> +
> +obj-$(CONFIG_EDAC_KRAIT_CACHE)		+= krait_edac.o
> diff --git a/drivers/edac/krait_edac.c b/drivers/edac/krait_edac.c
> new file mode 100644
> index 000000000000..90ec0e982927
> --- /dev/null
> +++ b/drivers/edac/krait_edac.c
> @@ -0,0 +1,370 @@
> +/* Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/platform_device.h>
> +#include <linux/module.h>
> +#include <linux/err.h>
> +#include <linux/cpu.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_platform.h>
> +
> +#include <asm/krait-l2-accessors.h>
> +
> +#include "edac_core.h"
> +
> +#define CESR_DCTPE		BIT(0)
> +#define CESR_DCDPE		BIT(1)
> +#define CESR_ICTPE		BIT(2)
> +#define CESR_ICDPE		BIT(3)
> +#define CESR_DCTE		(BIT(4) | BIT(5))
> +#define CESR_ICTE		(BIT(6) | BIT(7))
> +#define CESR_TLBMH		BIT(16)
> +#define CESR_I_MASK		0x000000cc
> +/* Print a message for everything but TLB MH events */
> +#define CESR_PRINT_MASK		0x000000ff
> +
> +#define L2ESR			0x204
> +#define L2ESR_MPDCD		BIT(0)
> +#define L2ESR_MPSLV		BIT(1)
> +#define L2ESR_TSESB		BIT(2)
> +#define L2ESR_TSEDB		BIT(3)
> +#define L2ESR_DSESB		BIT(4)
> +#define L2ESR_DSEDB		BIT(5)
> +#define L2ESR_MSE		BIT(6)
> +#define L2ESR_MPLDREXNOK	BIT(8)
> +#define L2ESR_CPU_MASK		0xf
> +#define L2ESR_CPU_SHIFT		16
> +#define L2ESR_SP		BIT(20)
> +
> +#define L2ESYNR0		0x208
> +#define L2ESYNR1		0x209
> +#define L2EAR0			0x20c
> +#define L2EAR1			0x20d
> +
> +struct krait_edac {
> +	int l1_irq;
> +	struct edac_device_ctl_info * __percpu *edev;
> +	struct notifier_block notifier;
> +};
> +
> +struct krait_edac_error {
> +	const char * const msg;
> +	void (*func)(struct edac_device_ctl_info *edac_dev,
> +			int inst_nr, int block_nr, const char *msg);

arg alignment (please start new line at the opening brace).

> +};
> +
> +static unsigned int read_cesr(void)
> +{
> +	unsigned int cesr;
> +
> +	asm volatile ("mrc p15, 7, %0, c15, c0, 1 @ cesr" : "=r" (cesr));
> +	return cesr;
> +}
> +
> +static void write_cesr(unsigned int cesr)
> +{
> +	asm volatile ("mcr p15, 7, %0, c15, c0, 1 @ cesr" : : "r" (cesr));
> +}
> +
> +static unsigned int read_cesynr(void)
> +{
> +	unsigned int cesynr;
> +
> +	asm volatile ("mrc p15, 7, %0, c15, c0, 3 @ cesynr" : "=r" (cesynr));
> +	return cesynr;
> +}
> +
> +static irqreturn_t krait_l1_irq(int irq, void *dev_id)
> +{
> +	struct edac_device_ctl_info **edac_p = dev_id;
> +	struct edac_device_ctl_info *edac = *edac_p;
> +	unsigned int cesr = read_cesr();
> +	unsigned int i_cesynr, d_cesynr;
> +	unsigned int cpu = smp_processor_id();
> +	int print_regs = cesr & CESR_PRINT_MASK;
> +	int i;
> +	static const struct krait_edac_error errors[] = {
> +		{ "D-cache tag parity error", edac_device_handle_ue },
> +		{ "D-cache data parity error", edac_device_handle_ue },
> +		{ "I-cache tag parity error", edac_device_handle_ce },
> +		{ "I-cache data parity error", edac_device_handle_ce },
> +		{ "D-cache tag timing error", edac_device_handle_ue },
> +		{ "D-cache data timing error", edac_device_handle_ue },
> +		{ "I-cache tag timing error", edac_device_handle_ce },
> +		{ "I-cache data timing error", edac_device_handle_ce }
> +	};
> +
> +	if (print_regs) {

This variable is used only once here, you can simply do the binary and
test then and drop it:

	if (cesr & CESR_PRINT_MASK)

> +		pr_alert("L1 / TLB Error detected on CPU %d!\n", cpu);
> +		pr_alert("CESR      = 0x%08x\n", cesr);

You can use the edac_*_printk with KERN_ALERT as level which adds proper
prefixes.

> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(errors); i++)
> +		if (BIT(i) & cesr)
> +			errors[i].func(edac, cpu, 0, errors[i].msg);

Nice! Func ptr per error type :)

> +
> +	if (cesr & CESR_TLBMH) {
> +		asm ("mcr p15, 0, r0, c8, c7, 0");
> +		edac_device_handle_ce(edac, cpu, 0, "TLB Multi-Hit error");
> +	}
> +
> +	if (cesr & (CESR_ICTPE | CESR_ICDPE | CESR_ICTE)) {
> +		i_cesynr = read_cesynr();
> +		pr_alert("I-side CESYNR = 0x%08x\n", i_cesynr);

edac_printk

and also, this message looks a bit cryptic for issuing it at ALERT
level. I'm ssuming people won't come to you and ask you what it
means...? :)

> +		write_cesr(CESR_I_MASK);
> +
> +		/*
> +		 * Clear the I-side bits from the captured CESR value so that we
> +		 * don't accidentally clear any new I-side errors when we do
> +		 * the CESR write-clear operation.
> +		 */
> +		cesr &= ~CESR_I_MASK;
> +	}
> +
> +	if (cesr & (CESR_DCTPE | CESR_DCDPE | CESR_DCTE)) {
> +		d_cesynr = read_cesynr();
> +		pr_alert("D-side CESYNR = 0x%08x\n", d_cesynr);

Ditto.

> +	}
> +
> +	/* Clear the interrupt bits we processed */
> +	write_cesr(cesr);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t krait_l2_irq(int irq, void *dev_id)
> +{
> +	struct edac_device_ctl_info *edac = dev_id;
> +	unsigned int l2esr;
> +	unsigned int l2esynr0;
> +	unsigned int l2esynr1;
> +	unsigned int l2ear0;
> +	unsigned int l2ear1;
> +	unsigned long cpu;
> +	int i;
> +	static const struct krait_edac_error errors[] = {
> +		{ "master port decode error", edac_device_handle_ce },
> +		{ "master port slave error", edac_device_handle_ce },
> +		{ "tag soft error, single-bit", edac_device_handle_ce },
> +		{ "tag soft error, double-bit", edac_device_handle_ue },
> +		{ "data soft error, single-bit", edac_device_handle_ce },
> +		{ "data soft error, double-bit", edac_device_handle_ue },
> +		{ "modified soft error", edac_device_handle_ce },
> +		{ "slave port exclusive monitor not available",
> +			edac_device_handle_ue},
> +		{ "master port LDREX received Normal OK response",
> +			edac_device_handle_ce },
> +	};
> +
> +	l2esr = krait_get_l2_indirect_reg(L2ESR);
> +	pr_alert("Error detected!\n");

Why print this not very telling message here if errors[i].func() will
get the proper .msg later?

> +	pr_alert("L2ESR    = 0x%08x\n", l2esr);
> +
> +	if (l2esr & (L2ESR_TSESB | L2ESR_TSEDB | L2ESR_MSE | L2ESR_SP)) {
> +		l2esynr0 = krait_get_l2_indirect_reg(L2ESYNR0);
> +		l2esynr1 = krait_get_l2_indirect_reg(L2ESYNR1);
> +		l2ear0 = krait_get_l2_indirect_reg(L2EAR0);
> +		l2ear1 = krait_get_l2_indirect_reg(L2EAR1);
> +
> +		pr_alert("L2ESYNR0 = 0x%08x\n", l2esynr0);
> +		pr_alert("L2ESYNR1 = 0x%08x\n", l2esynr1);
> +		pr_alert("L2EAR0   = 0x%08x\n", l2ear0);
> +		pr_alert("L2EAR1   = 0x%08x\n", l2ear1);

Also, please use edac_printk and consider making those messages
human-readable, otherwise it only confuses users.

> +	}
> +
> +	cpu = (l2esr >> L2ESR_CPU_SHIFT) & L2ESR_CPU_MASK;
> +	cpu = __ffs(cpu);
> +	if (cpu)
> +		cpu--;

...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
