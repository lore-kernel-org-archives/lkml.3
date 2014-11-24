Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbaKXSUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:20:24 -0500
Received: from www.linutronix.de ([62.245.132.108]:40517 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbaKXSUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:20:10 -0500
Date: Mon, 24 Nov 2014 19:20:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Thompson <daniel.thompson@linaro.org>
cc: Jason Cooper <jason@lakedaemon.net>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3.18-rc3 v8 1/4] irqchip: gic: Make gic_raise_softirq()
 FIQ-safe
In-Reply-To: <1415968543-29469-2-git-send-email-daniel.thompson@linaro.org>
Message-ID: <alpine.DEB.2.11.1411241918090.6439@nanos>
References: <1415183260-6389-1-git-send-email-daniel.thompson@linaro.org> <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1415968543-29469-2-git-send-email-daniel.thompson@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014, Daniel Thompson wrote:
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 38493ff28fa5..0db62a6f1ee3 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -73,6 +73,13 @@ struct gic_chip_data {
>  static DEFINE_RAW_SPINLOCK(irq_controller_lock);
>  
>  /*
> + * This lock may be locked for reading by FIQ handlers. Thus although
> + * read locking may be used liberally, write locking must only take
> + * place only when local FIQ handling is disabled.
> + */
> +static DEFINE_RWLOCK(fiq_safe_cpu_map_lock);
> +
> +/*
>   * The GIC mapping of CPU interfaces does not necessarily match
>   * the logical CPU numbering.  Let's use a mapping as returned
>   * by the GIC itself.
> @@ -624,7 +631,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
>  	int cpu;
>  	unsigned long flags, map = 0;
>  
> -	raw_spin_lock_irqsave(&irq_controller_lock, flags);
> +	read_lock_irqsave(&fiq_safe_cpu_map_lock, flags);

Just for the record:

You might have noticed that you replace a raw lock with a non raw
one. That's not an issue on mainline, but that pretty much renders
that code broken for RT.
  
Surely nothing I worry too much about given the current state of RT.

Thanks,

	tglx
