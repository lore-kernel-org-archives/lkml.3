Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbaIBTlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 15:41:19 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40952 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754581AbaIBTlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 15:41:18 -0400
Date: Tue, 2 Sep 2014 20:40:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Ryan Mallon <rmallon@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v11 11/19] irqchip: vic: Add support for FIQ management
Message-ID: <20140902194047.GY30401@n2100.arm.linux.org.uk>
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org> <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org> <1409662853-29313-12-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409662853-29313-12-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 02:00:45PM +0100, Daniel Thompson wrote:
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index bda5a91..8821160 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -502,13 +502,17 @@ static void __init gic_init_fiq(struct gic_chip_data *gic,
>  /*
>   * Fully acknowledge (both ack and eoi) a FIQ-based IPI
>   */
> -static int gic_handle_fiq_ipi(struct notifier_block *nb, unsigned long regs,
> -			   void *data)
> +void gic_handle_fiq_ipi(void)
>  {
>  	struct gic_chip_data *gic = &gic_data[0];
> -	void __iomem *cpu_base = gic_data_cpu_base(gic);
> +	void __iomem *cpu_base;
>  	unsigned long irqstat, irqnr;
>  
> +	if (!gic || !gic->fiq_enable)
> +		return;
> +
> +	cpu_base = gic_data_cpu_base(gic);
> +
>  	if (WARN_ON(!in_nmi()))
>  		return NOTIFY_BAD;
>  
> @@ -525,13 +529,6 @@ static int gic_handle_fiq_ipi(struct notifier_block *nb, unsigned long regs,
>  
>  	return NOTIFY_OK;
>  }
> -
> -/*
> - * Notifier to ensure IPI FIQ is acknowledged correctly.
> - */
> -static struct notifier_block gic_fiq_ipi_notifier = {
> -	.notifier_call = gic_handle_fiq_ipi,
> -};
>  #else /* CONFIG_FIQ */
>  static inline void gic_set_group_irq(void __iomem *base, unsigned int hwirq,
>  				     int group) {}
> @@ -1250,10 +1247,6 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>  #ifdef CONFIG_SMP
>  		set_smp_cross_call(gic_raise_softirq);
>  		register_cpu_notifier(&gic_cpu_notifier);
> -#ifdef CONFIG_FIQ
> -		if (gic_data_fiq_enable(gic))
> -			register_fiq_nmi_notifier(&gic_fiq_ipi_notifier);
> -#endif
>  #endif
>  		set_handle_irq(gic_handle_irq);
>  	}

Shouldn't this be merged into some other patch?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
