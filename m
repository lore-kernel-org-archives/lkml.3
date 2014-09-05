Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaIETJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:09:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:33782 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaIETJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:09:07 -0400
Date: Fri, 5 Sep 2014 21:08:57 +0200 (CEST)
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
Subject: Re: [PATCH v2 15/16] MIPS: GIC: Use local interrupts for timer
In-Reply-To: <1409938218-9026-16-git-send-email-abrestic@chromium.org>
Message-ID: <alpine.DEB.2.10.1409052108090.5472@nanos>
References: <1409938218-9026-1-git-send-email-abrestic@chromium.org> <1409938218-9026-16-git-send-email-abrestic@chromium.org>
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

> Instead of using GIC interrupt 0 for the timer (which was not even
> handled correctly by the GIC irqchip code and could conflict with an
> actual external interrupt), use the designated local interrupt for
> the GIC timer.
> 
> Also, since the timer is a per-CPU interrupt, initialize it with
> setup_percpu_irq() and enable it with enable_percpu_irq() instead
> of using direct register writes.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
> No changes from v1.
> ---
>  arch/mips/kernel/cevt-gic.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/mips/kernel/cevt-gic.c b/arch/mips/kernel/cevt-gic.c
> index 6093716..cae72a4 100644
> --- a/arch/mips/kernel/cevt-gic.c
> +++ b/arch/mips/kernel/cevt-gic.c
> @@ -68,7 +68,7 @@ int gic_clockevent_init(void)
>  	if (!cpu_has_counter || !gic_frequency)
>  		return -ENXIO;
>  
> -	irq = MIPS_GIC_IRQ_BASE;
> +	irq = MIPS_GIC_LOCAL_IRQ_BASE + GIC_LOCAL_INTR_COMPARE;
>  
>  	cd = &per_cpu(gic_clockevent_device, cpu);
>  
> @@ -91,15 +91,13 @@ int gic_clockevent_init(void)
>  
>  	clockevents_register_device(cd);
>  
> -	GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_COMPARE_MAP), 0x80000002);
> -	GICWRITE(GIC_REG(VPE_LOCAL, GIC_VPE_SMASK), GIC_VPE_SMASK_CMP_MSK);
> +	if (!gic_timer_irq_installed) {
> +		setup_percpu_irq(irq, &gic_compare_irqaction);
> +		irq_set_handler(irq, handle_percpu_irq);
> +		gic_timer_irq_installed = 1;
> +	}
>  
> -	if (gic_timer_irq_installed)
> -		return 0;
> +	enable_percpu_irq(irq, 0);

Please use a proper IRQ_TYPE constant instead of 0

Thanks,

	tglx
