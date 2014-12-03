Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaLCINI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 03:13:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34523 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaLCINH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 03:13:07 -0500
Date: Wed, 3 Dec 2014 09:12:45 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stefan Agner <stefan@agner.ch>
Cc: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        jason@lakedaemon.net, olof@lixom.net, arnd@arndb.de,
        daniel.lezcano@linaro.org, tglx@linutronix.de, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] irqchip: nvic: increase number of external
 interrupts to 112
Message-ID: <20141203081245.GH2129@pengutronix.de>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch>
 <1417565531-4507-6-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417565531-4507-6-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Stefan,

On Wed, Dec 03, 2014 at 01:12:04AM +0100, Stefan Agner wrote:
> So far only vectors for up to 48 external interrupts have been
> registred in the vector table. Increase the amount of registred
s/registred/registered/

> external vectors to 112. Also, add a warning in case NVIC reports
> support for more interrupts than 128.
s/interrupts than 128/than 128 interrupts/ (not sure about this one)

> Note: the vector table must align to the number of entires in the
s/entires/entries/

Maybe point out that "X external interrupts" corresponds to "X + 16
vectors".

> vector table, hence increase the alignment to 0x200.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  arch/arm/kernel/entry-v7m.S | 6 +++---
>  drivers/irqchip/irq-nvic.c  | 2 ++
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/kernel/entry-v7m.S b/arch/arm/kernel/entry-v7m.S
> index 2260f18..754a1fa 100644
> --- a/arch/arm/kernel/entry-v7m.S
> +++ b/arch/arm/kernel/entry-v7m.S
> @@ -115,7 +115,7 @@ ENTRY(__switch_to)
>  ENDPROC(__switch_to)
>  
>  	.data
> -	.align	8
> +	.align	9
>  /*
>   * Vector table (64 words => 256 bytes natural alignment)
This comment needs fixing

>   */
> @@ -136,6 +136,6 @@ ENTRY(vector_table)
>  	.long	__invalid_entry		@ 13 - Reserved
>  	.long	__pendsv_entry		@ 14 - PendSV
>  	.long	__invalid_entry		@ 15 - SysTick
> -	.rept	64 - 16
> -	.long	__irq_entry		@ 16..64 - External Interrupts
> +	.rept	128 - 16
> +	.long	__irq_entry		@ 16..128 - External Interrupts
>  	.endr
> diff --git a/drivers/irqchip/irq-nvic.c b/drivers/irqchip/irq-nvic.c
> index dbfb5be..40f62a9 100644
> --- a/drivers/irqchip/irq-nvic.c
> +++ b/drivers/irqchip/irq-nvic.c
> @@ -137,6 +137,8 @@ static int __init nvic_of_init(struct device_node *node,
>  	if (irqs > NVIC_MAX_IRQ)
>  		irqs = NVIC_MAX_IRQ;
>  
> +	WARN(irqs > 128, "vector table in entry-v7m.S configured for 128 irqs");
> +
That's pointless. Better do:

	if (WARN(irqs > 128, "vector table in entry-v7m.S configured for 128 irqs"))
		irqs = 128;

Hmm, I wonder if that is correct. The first 16 exceptions are the system
exception that will not be registered be drivers and so exception 16
(i.e. the first regular irq) is reported as hwirq 0. So I think we can
(in a separate patch) pass irqs - 16 to irq_domain_add_linear. Didn't
test that though.

>  	nvic_irq_domain =
>  		irq_domain_add_linear(node, irqs, &nvic_irq_domain_ops, NULL);
>  	if (!nvic_irq_domain) {

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
