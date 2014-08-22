Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbaHVIXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 04:23:42 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:42212 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755270AbaHVIXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 04:23:40 -0400
Message-ID: <53F6FE03.80409@arm.com>
Date: Fri, 22 Aug 2014 09:23:31 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Feng Kan <fkan@apm.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dann.frazier@canonical.com" <dann.frazier@canonical.com>
Subject: Re: [PATCH] irqchip: gic: correct gic_set_type trigger acceptance
 criteria
References: <1408640183-8804-1-git-send-email-fkan@apm.com>
In-Reply-To: <1408640183-8804-1-git-send-email-fkan@apm.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fen,

On 21/08/14 17:56, Feng Kan wrote:
> GIC is designed to support two types of trigger mechanism. Either active level
> high or edge rising.
> 
> static int gic_set_type(struct irq_data *d, unsigned int type)
> {
> 	...
>         if (type != IRQ_TYPE_LEVEL_HIGH && type != IRQ_TYPE_EDGE_RISING)
>                 return -EINVAL;
> 
> However, this cause problem with requesting driver uses combo selections to tie
> down trigger mechanism. In below case gpio_keys_setup_key tries to use either
> rising or falling edge trigger, but accidently cause a false positive in the
> gic code.
> 
> static int gpio_keys_setup_key(struct platform_device *pdev,
> {
>                 irqflags = IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING;
> 
> This patch fixes this problem by filter the selection type first.

I think this is the wrong thing to do. The semantic of the driver is to
receive an interrupt on both key-press and key-release. It needs both
events to function correctly.

While your patch enables the driver, it also only give it one of the two
expected events, and things will break. You should fix the gpio-keys
driver to only request one of the possible events (possibly detect when
it is failing to configure the interrupt).

Thanks,

	M.

> 
> Signed-off-by: Feng Kan <fkan@apm.com>
> ---
>  drivers/irqchip/irq-gic.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index c31eea4..bea167e 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -194,6 +194,7 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
>  	if (gicirq < 16)
>  		return -EINVAL;
>  
> +	type &= IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_EDGE_RISING;
>  	if (type != IRQ_TYPE_LEVEL_HIGH && type != IRQ_TYPE_EDGE_RISING)
>  		return -EINVAL;
>  
> 


-- 
Jazz is not dead. It just smells funny...
