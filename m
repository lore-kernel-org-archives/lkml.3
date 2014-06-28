Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaF1PCY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 11:02:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47015 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751160AbaF1PCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 11:02:22 -0400
Date: Sat, 28 Jun 2014 17:02:16 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, linux-kernel@vger.kernel.org,
        Nadav Haklai <nadavh@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/5] ARM: smp_scu: Add the enable speculative linefills
 operation
Message-ID: <20140628170216.0c1965cf@free-electrons.com>
In-Reply-To: <1403822608-31158-3-git-send-email-gregory.clement@free-electrons.com>
References: <1403822608-31158-1-git-send-email-gregory.clement@free-electrons.com>
	<1403822608-31158-3-git-send-email-gregory.clement@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Gregory CLEMENT,

On Fri, 27 Jun 2014 00:43:25 +0200, Gregory CLEMENT wrote:
> Quotin the ARM datasheet "When set, coherent linefill requests are

Quotin -> Quoting

> sent speculatively to the L2C-310 in parallel with the tag look-up. If
> the tag look-up misses, the confirmed linefill is sent to the L2C-310
> and gets RDATA earlier because the data request was already initiated
> by the speculative request. "
> 
> Some SoC (such as the Armada 375/38x) can benefit of this feature. As

benefit of -> benefit from.

>  #if defined(CONFIG_SMP) && defined(CONFIG_HAVE_ARM_SCU)
> diff --git a/arch/arm/kernel/smp_scu.c b/arch/arm/kernel/smp_scu.c
> index cfea41b41ad0..3fd21a495028 100644
> --- a/arch/arm/kernel/smp_scu.c
> +++ b/arch/arm/kernel/smp_scu.c
> @@ -18,6 +18,7 @@
>  
>  #define SCU_CTRL		0x00
>  #define SCU_CTRL_ENABLE		    BIT(1)
> +#define SCU_CTRL_SPEC_LINEFILLS	    BIT(3)
>  #define SCU_CONFIG		0x04
>  #define SCU_CPU_STATUS		0x08
>  #define SCU_INVALIDATE		0x0c
> @@ -88,3 +89,24 @@ int scu_power_mode(void __iomem *scu_base, unsigned int mode)
>  
>  	return 0;
>  }
> +
> +/*
> + * When enabled, coherent linefill requests are sent speculatively to
> + * the L2C-310 in parallel with the tag look-up
> + *
> + */
> +void scu_spec_linefills_enable(void __iomem *scu_base, bool enable)
> +{
> +	u32 scu_ctrl;
> +
> +	scu_ctrl = readl_relaxed(scu_base + SCU_CTRL);
> +	/* already enabled? */

Comment not needed, since SCU_CTRL_ENABLE already documents what's
happening. Or a more useful comment would be: "We cannot change the SCU
configuration while it is enabled".

> +	if (scu_ctrl & SCU_CTRL_ENABLE)
> +		return;

Return an error in this case maybe?

> +	if (enable)
> +		scu_ctrl |= SCU_CTRL_SPEC_LINEFILLS;
> +	else
> +		scu_ctrl &= ~SCU_CTRL_SPEC_LINEFILLS;
> +
> +	writel_relaxed(scu_ctrl, scu_base + SCU_CTRL);
> +}

Instead of having a separate function to do this (and the standby
operation), what about doing that directly in scu_enable() ? Either
unconditionally if that is fine for all SCU users, or through a flags
argument?

Best regards,

Thomas Petazzoni
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
