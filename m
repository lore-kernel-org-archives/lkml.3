Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab3FQSg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:36:56 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:50785 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3FQSgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:36:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        johnstul@us.ibm.com, horms@verge.net.au,
        shinya.kuribayashi.px@renesas.com, tglx@linutronix.de
Subject: Re: [PATCH] clocksource: sh_cmt: 32-bit control register support
Date: Mon, 17 Jun 2013 20:37:07 +0200
Message-ID: <1597172.lxipa1bjlr@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <20130617064052.3573.68839.sendpatchset@w520>
References: <20130617064052.3573.68839.sendpatchset@w520>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

Thanks for the patch.

On Monday 17 June 2013 15:40:52 Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Add support for CMT hardware with 32-bit control and counter
> registers, as found on r8a73a4 and r8a7790. To use the CMT
> with 32-bit hardware a second I/O memory resource needs to
> point out the CMSTR register and it needs to be 32 bit wide.

Is a memory second resource required ? Can't we use a single resource that 
will contain all the registers ?

(and one more comment below)

> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  Tested on r8a73a4 used on APE6EVM.
> 
>  drivers/clocksource/sh_cmt.c |   50 +++++++++++++++++++++++++++------------
>  1 file changed, 36 insertions(+), 14 deletions(-)
> 
> --- 0001/drivers/clocksource/sh_cmt.c
> +++ work/drivers/clocksource/sh_cmt.c	2013-06-17 13:47:34.000000000 +0900
> @@ -37,6 +37,7 @@
> 
>  struct sh_cmt_priv {
>  	void __iomem *mapbase;
> +	void __iomem *mapbase_str;
>  	struct clk *clk;
>  	unsigned long width; /* 16 or 32 bit version of hardware block */
>  	unsigned long overflow_bit;
> @@ -79,6 +80,12 @@ struct sh_cmt_priv {
>   * CMCSR 0xffca0060 16-bit
>   * CMCNT 0xffca0064 32-bit
>   * CMCOR 0xffca0068 32-bit
> + *
> + * "32-bit counter and 32-bit control" as found on r8a73a4 and r8a7790:
> + * CMSTR 0xffca0500 32-bit
> + * CMCSR 0xffca0510 32-bit
> + * CMCNT 0xffca0514 32-bit
> + * CMCOR 0xffca0518 32-bit
>   */
> 
>  static unsigned long sh_cmt_read16(void __iomem *base, unsigned long offs)
> @@ -109,9 +116,7 @@ static void sh_cmt_write32(void __iomem
> 
>  static inline unsigned long sh_cmt_read_cmstr(struct sh_cmt_priv *p)
>  {
> -	struct sh_timer_config *cfg = p->pdev->dev.platform_data;
> -
> -	return p->read_control(p->mapbase - cfg->channel_offset, 0);
> +	return p->read_control(p->mapbase_str, 0);
>  }
> 
>  static inline unsigned long sh_cmt_read_cmcsr(struct sh_cmt_priv *p)
> @@ -127,9 +132,7 @@ static inline unsigned long sh_cmt_read_
>  static inline void sh_cmt_write_cmstr(struct sh_cmt_priv *p,
>  				      unsigned long value)
>  {
> -	struct sh_timer_config *cfg = p->pdev->dev.platform_data;
> -
> -	p->write_control(p->mapbase - cfg->channel_offset, 0, value);
> +	p->write_control(p->mapbase_str, 0, value);
>  }
> 
>  static inline void sh_cmt_write_cmcsr(struct sh_cmt_priv *p,
> @@ -676,7 +679,7 @@ static int sh_cmt_register(struct sh_cmt
>  static int sh_cmt_setup(struct sh_cmt_priv *p, struct platform_device
> *pdev) {
>  	struct sh_timer_config *cfg = pdev->dev.platform_data;
> -	struct resource *res;
> +	struct resource *res, *res2;
>  	int irq, ret;
>  	ret = -ENXIO;
> 
> @@ -694,6 +697,9 @@ static int sh_cmt_setup(struct sh_cmt_pr
>  		goto err0;
>  	}
> 
> +	/* optional resource for the shared timer start/stop register */
> +	res2 = platform_get_resource(p->pdev, IORESOURCE_MEM, 1);
> +
>  	irq = platform_get_irq(p->pdev, 0);
>  	if (irq < 0) {
>  		dev_err(&p->pdev->dev, "failed to get irq\n");
> @@ -707,6 +713,15 @@ static int sh_cmt_setup(struct sh_cmt_pr
>  		goto err0;
>  	}
> 
> +	/* map second resource for CMSTR */
> +	p->mapbase_str = ioremap_nocache(res2 ? res2->start :
> +					 res->start - cfg->channel_offset,
> +					 res2 ? resource_size(res2) : 2);
> +	if (p->mapbase_str == NULL) {
> +		dev_err(&p->pdev->dev, "failed to remap I/O second memory\n");
> +		goto err1;
> +	}
> +
>  	/* request irq using setup_irq() (too early for request_irq()) */
>  	p->irqaction.name = dev_name(&p->pdev->dev);
>  	p->irqaction.handler = sh_cmt_interrupt;
> @@ -719,11 +734,17 @@ static int sh_cmt_setup(struct sh_cmt_pr
>  	if (IS_ERR(p->clk)) {
>  		dev_err(&p->pdev->dev, "cannot get clock\n");
>  		ret = PTR_ERR(p->clk);
> -		goto err1;
> +		goto err2;
>  	}
> 
> -	p->read_control = sh_cmt_read16;
> -	p->write_control = sh_cmt_write16;
> +	if (res2 && (resource_size(res2) == 4)) {
> +		/* assume both CMSTR and CMCSR to be 32-bit */
> +		p->read_control = sh_cmt_read32;
> +		p->write_control = sh_cmt_write32;
> +	} else {
> +		p->read_control = sh_cmt_read16;
> +		p->write_control = sh_cmt_write16;
> +	}
> 
>  	if (resource_size(res) == 6) {
>  		p->width = 16;
> @@ -752,22 +773,23 @@ static int sh_cmt_setup(struct sh_cmt_pr
>  			      cfg->clocksource_rating);
>  	if (ret) {
>  		dev_err(&p->pdev->dev, "registration failed\n");
> -		goto err2;
> +		goto err3;
>  	}
>  	p->cs_enabled = false;
> 
>  	ret = setup_irq(irq, &p->irqaction);
>  	if (ret) {
>  		dev_err(&p->pdev->dev, "failed to request irq %d\n", irq);
> -		goto err2;
> +		goto err3;
>  	}
> 
>  	platform_set_drvdata(pdev, p);
> 
>  	return 0;
> -err2:
> +err3:
>  	clk_put(p->clk);
> -
> +err2:
> +	iounmap(p->mapbase_str);
>  err1:
>  	iounmap(p->mapbase);

Time to switch to devm_* managed functions ? :-)

>  err0:

-- 
Regards,

Laurent Pinchart

