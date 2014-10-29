Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbaJ2KMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:12:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:55392 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaJ2KMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:12:49 -0400
Date: Wed, 29 Oct 2014 11:12:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kevin Cernekee <cernekee@gmail.com>
cc: f.fainelli@gmail.com, jason@lakedaemon.net, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: Re: [PATCH 01/11] irqchip: Allow irq_reg_{readl,writel} to use
 __raw_{readl_writel}
In-Reply-To: <1414555138-6500-1-git-send-email-cernekee@gmail.com>
Message-ID: <alpine.DEB.2.11.1410291112120.5308@nanos>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014, Kevin Cernekee wrote:

> On big-endian systems readl/writel may perform an unwanted endian swap,
> breaking generic-chip.c.  Let the platform code opt to use the __raw_
> variants by selecting RAW_IRQ_ACCESSORS.
> 
> This is required in order for bcm3384 to use GENERIC_IRQ_CHIP.  Several
> existing irqchip drivers also use the __raw_ accessors directly, so it
> is a reasonably common requirement.

How does that work with multi arch kernels?

Thanks,

	tglx
 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> ---
>  drivers/irqchip/Kconfig |  3 +++
>  include/linux/irq.h     | 13 +++++++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> index b21f12f..6f0e80b 100644
> --- a/drivers/irqchip/Kconfig
> +++ b/drivers/irqchip/Kconfig
> @@ -2,6 +2,9 @@ config IRQCHIP
>  	def_bool y
>  	depends on OF_IRQ
>  
> +config RAW_IRQ_ACCESSORS
> +	bool
> +
>  config ARM_GIC
>  	bool
>  	select IRQ_DOMAIN
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index 03f48d9..ed1ea8a 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -639,6 +639,17 @@ void arch_teardown_hwirq(unsigned int irq);
>  void irq_init_desc(unsigned int irq);
>  #endif
>  
> +#ifdef CONFIG_RAW_IRQ_ACCESSORS
> +
> +#ifndef irq_reg_writel
> +# define irq_reg_writel(val, addr)	__raw_writel(val, addr)
> +#endif
> +#ifndef irq_reg_readl
> +# define irq_reg_readl(addr)		__raw_readl(addr)
> +#endif
> +
> +#else
> +
>  #ifndef irq_reg_writel
>  # define irq_reg_writel(val, addr)	writel(val, addr)
>  #endif
> @@ -646,6 +657,8 @@ void irq_init_desc(unsigned int irq);
>  # define irq_reg_readl(addr)		readl(addr)
>  #endif
>  
> +#endif
> +
>  /**
>   * struct irq_chip_regs - register offsets for struct irq_gci
>   * @enable:	Enable register offset to reg_base
> -- 
> 2.1.1
> 
> 
