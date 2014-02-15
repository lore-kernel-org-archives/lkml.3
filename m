Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaBOMm4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 07:42:56 -0500
Received: from www.linutronix.de ([62.245.132.108]:46913 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaBOMmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 07:42:54 -0500
Date: Sat, 15 Feb 2014 13:42:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tarek Dakhran <t.dakhran@samsung.com>
cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Tarek Dakhran <t.dakhran@gmail.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v1 1/2] clocksource: mct: remove request_irq from
 exynos4_local_timer_setup
In-Reply-To: <1392260923-31659-2-git-send-email-t.dakhran@samsung.com>
Message-ID: <alpine.DEB.2.02.1402151321120.21991@ionos.tec.linutronix.de>
References: <1392260923-31659-1-git-send-email-t.dakhran@samsung.com> <1392260923-31659-2-git-send-email-t.dakhran@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014, Tarek Dakhran wrote:

> exynos4_local_timer_setup called on the secondary cpu before
> irqs are enabled. request_irq can sleep, which produces next warning:
> 
> 	BUG: sleeping function called from invalid context at mm/slub.c:965
> 	in_atomic(): 1, irqs_disabled(): 128, pid: 0, name: swapper/3
> 
> Call setup_irq for each local timer in exynos4_timer_resources,
> and only call enable_irq during percpu timer setup.
> 
> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
> ---
>  drivers/clocksource/exynos_mct.c |   38 ++++++++++++++++++++++++++++++--------
>  1 file changed, 30 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
> index 48f76bc..1cde3de 100644
> --- a/drivers/clocksource/exynos_mct.c
> +++ b/drivers/clocksource/exynos_mct.c
> @@ -82,6 +82,7 @@ static void __iomem *reg_base;
>  static unsigned long clk_rate;
>  static unsigned int mct_int_type;
>  static int mct_irqs[MCT_NR_IRQS];
> +static struct irqaction __percpu *mct_LX_irqaction;
>  
>  struct mct_clock_event_device {
>  	struct clock_event_device evt;
> @@ -402,6 +403,25 @@ static irqreturn_t exynos4_mct_tick_isr(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> +static void exynos4_setup_irqaction_spi(unsigned int cpu)
> +{
> +	struct irqaction *pcpu_irqaction = per_cpu_ptr(mct_LX_irqaction, cpu);
> +	unsigned int irq = mct_irqs[MCT_L0_IRQ + cpu];
> +	int err;
> +
> +	pcpu_irqaction->name = per_cpu(percpu_mct_tick, cpu).name;
> +	pcpu_irqaction->flags  = IRQF_TIMER | IRQF_NOBALANCING;
> +	pcpu_irqaction->handler = exynos4_mct_tick_isr;
> +	pcpu_irqaction->dev_id = &per_cpu(percpu_mct_tick, cpu);
> +
> +	err = setup_irq(irq, pcpu_irqaction);

This is just crap. Why don't you use request_irq()?

> +	if (err) {
> +		pr_err("MCT: can't setup IRQ %d (%d)\n", irq, err);
> +		return;
> +	}
> +	disable_irq(irq);

This is completely backwards. We have flags which tell the core not to
enable an interrupt at setup time. Also what's wrong with enabling the
interrupt in the first place? When the timer is stopped then no
interrupts happen and it does not matter a bit whether the irq line is
enabled or not.

Thanks,

	tglx
