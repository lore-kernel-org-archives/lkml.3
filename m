Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaIESwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:52:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:33566 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaIESwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:52:18 -0400
Date: Fri, 5 Sep 2014 20:51:59 +0200 (CEST)
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
Subject: Re: [PATCH v2 01/16] MIPS: Provide a generic plat_irq_dispatch
In-Reply-To: <1409938218-9026-2-git-send-email-abrestic@chromium.org>
Message-ID: <alpine.DEB.2.10.1409052051240.5472@nanos>
References: <1409938218-9026-1-git-send-email-abrestic@chromium.org> <1409938218-9026-2-git-send-email-abrestic@chromium.org>
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
> For platforms which boot with device-tree and use the MIPS CPU interrupt
> controller binding, a generic plat_irq_dispatch() can be used since all
> CPU interrupts should be mapped through the CPU IRQ domain.  Implement a
> plat_irq_dispatch() which simply handles the highest pending interrupt.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> Tested-by: Jonas Gorski <jogo@openwrt.org>
> ---
> No changes from v1.
> ---
>  arch/mips/kernel/irq_cpu.c | 28 +++++++++++++++++++++++-----
>  1 file changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/mips/kernel/irq_cpu.c b/arch/mips/kernel/irq_cpu.c
> index e498f2b..9cf8459 100644
> --- a/arch/mips/kernel/irq_cpu.c
> +++ b/arch/mips/kernel/irq_cpu.c
> @@ -116,6 +116,24 @@ void __init mips_cpu_irq_init(void)
>  }
>  
>  #ifdef CONFIG_IRQ_DOMAIN
> +static struct irq_domain *mips_intc_domain;
> +
> +asmlinkage void __weak plat_irq_dispatch(void)
> +{
> +	unsigned int pending = read_c0_cause() & read_c0_status() & ST0_IM;
> +	unsigned int hw;
> +	int irq;
> +
> +	if (!pending) {
> +		spurious_interrupt();
> +		return;
> +	}
> +
> +	hw = fls(pending) - CAUSEB_IP - 1;
> +	irq = irq_linear_revmap(mips_intc_domain, hw);
> +	do_IRQ(irq);

Why are you not handling all pending interrupts in a loop?

Thanks,

	tglx
