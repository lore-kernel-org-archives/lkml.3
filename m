Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab3LQARl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 19:17:41 -0500
Received: from smtprelay0181.hostedemail.com ([216.40.44.181]:40090 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751665Ab3LQARk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 19:17:40 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2731:2828:2904:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3872:3874:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jump41_4274b7c8f3024
X-Filterd-Recvd-Size: 2773
Message-ID: <1387239455.18217.61.camel@joe-AO722>
Subject: Re: [PATCH 05/10] mfd: menelaus: Use for_each_set_bit()
From: Joe Perches <joe@perches.com>
To: Felipe Balbi <balbi@ti.com>
Cc: lee.jones@linaro.org, Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Date: Mon, 16 Dec 2013 16:17:35 -0800
In-Reply-To: <1387238904-7843-5-git-send-email-balbi@ti.com>
References: <20131216153936.GQ18769@lee--X1>
	 <1387238904-7843-1-git-send-email-balbi@ti.com>
	 <1387238904-7843-5-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-16 at 18:08 -0600, Felipe Balbi wrote:
> That macro just helps removing some extra line of code and hides ffs()
> calls.
> 
> While at that, also fix a variable shadowing bug where 'int irq' was
> being redeclared inside inner loop while it was also argument to
> interrupt handler.
> 
> Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/mfd/menelaus.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
> index 87d80a8..d3e3022 100644
> --- a/drivers/mfd/menelaus.c
> +++ b/drivers/mfd/menelaus.c
> @@ -795,24 +795,22 @@ static irqreturn_t menelaus_irq(int irq, void *_menelaus)
>  {
>  	struct menelaus_chip *menelaus = _menelaus;
>  	void (*handler)(struct menelaus_chip *menelaus);
> -	unsigned isr;
> +	unsigned long isr;
> +	unsigned long i;
>  
>  	isr = (menelaus_read_reg(MENELAUS_INT_STATUS2)
>  			& ~menelaus->mask2) << 8;
>  	isr |= menelaus_read_reg(MENELAUS_INT_STATUS1)
>  		& ~menelaus->mask1;
>  
> -	while (isr) {
> -		int irq = fls(isr) - 1;
> -		isr &= ~(1 << irq);
> -
> +	for_each_set_bit(i, &isr, 16) {
>  		mutex_lock(&menelaus->lock);
> -		menelaus_disable_irq(irq);
> -		menelaus_ack_irq(irq);
> -		handler = menelaus->handlers[irq];
> +		menelaus_disable_irq(i);
> +		menelaus_ack_irq(i);
> +		handler = menelaus->handlers[i];
>  		if (handler)
>  			handler(menelaus);
> -		menelaus_enable_irq(irq);
> +		menelaus_enable_irq(i);
>  		mutex_unlock(&menelaus->lock);
>  	}
>  

This could handle the irqs in reverse order.
Does that matter?

