Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbaIETGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:06:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:33732 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbaIETGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:06:03 -0400
Date: Fri, 5 Sep 2014 21:05:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Bresticker <abrestic@chromium.org>
cc: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jason Cooper <jason@lakedaemon.net>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        linux-mips@linux-mips.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 14/16] irqchip: mips-gic: Support local interrupts
In-Reply-To: <1409938218-9026-15-git-send-email-abrestic@chromium.org>
Message-ID: <alpine.DEB.2.10.1409052056400.5472@nanos>
References: <1409938218-9026-1-git-send-email-abrestic@chromium.org> <1409938218-9026-15-git-send-email-abrestic@chromium.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2014, Andrew Bresticker wrote:
>  static void gic_mask_irq(struct irq_data *d)
>  {
> -	GIC_CLR_INTR_MASK(d->irq - gic_irq_base);
> +	unsigned int irq = d->irq - gic_irq_base;
> +
> +	if (gic_is_local_irq(irq)) {
> +		GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_RMASK),
> +			 1 << GIC_INTR_BIT(gic_hw_to_local_irq(irq)));
> +	} else {
> +		GIC_CLR_INTR_MASK(irq);
> +	}
>  }
>  
>  static void gic_unmask_irq(struct irq_data *d)
>  {
> -	GIC_SET_INTR_MASK(d->irq - gic_irq_base);
> +	unsigned int irq = d->irq - gic_irq_base;
> +
> +	if (gic_is_local_irq(irq)) {
> +		GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_SMASK),
> +			 1 << GIC_INTR_BIT(gic_hw_to_local_irq(irq)));
> +	} else {
> +		GIC_SET_INTR_MASK(irq);
> +	}

Why are you adding a conditional in all these functions instead of
having two interrupt chips with separate callbacks and irqdata?

And looking at GIC_SET_INTR_MASK(irq) makes me shudder even more. The
whole thing can be replaced with the generic interrupt chip functions.

If you set it up proper, then there is not a single conditional or
runtime calculation of bitmasks, address offsets etc.

Thanks,

	tglx
