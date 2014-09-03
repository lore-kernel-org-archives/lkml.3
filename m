Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688AbaICKKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:10:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44608 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932511AbaICKKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:10:18 -0400
Date: Wed, 3 Sep 2014 12:10:15 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: =?UTF-8?B?R2HDq2w=?= PORTAY <g.portay@overkiz.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCHv2 4/4] clocksource: tcb_clksrc: unprepare clock in case
 of failure
Message-ID: <20140903121015.2f756e4d@bbrezillon>
In-Reply-To: <1409329003-17252-5-git-send-email-g.portay@overkiz.com>
References: <1409329003-17252-1-git-send-email-g.portay@overkiz.com>
	<1409329003-17252-5-git-send-email-g.portay@overkiz.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2014 18:16:43 +0200
Gaël PORTAY <g.portay@overkiz.com> wrote:

> The clock is not unprepared in case of the request IRQ fails.
> 
> Also update to request_irq.

As you're doing 2 different things in this commit (first move to
request_irq and then disable the TC clk if the request fails) I would
have chosen another commit title, like
"clocksource: tcb_clksrc: sanitize IRQ request"

Otherwise, you have my

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> 
> Signed-off-by: Gaël PORTAY <g.portay@overkiz.com>
> ---
>  drivers/clocksource/tcb_clksrc.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
> index f922e81..8bdbc45 100644
> --- a/drivers/clocksource/tcb_clksrc.c
> +++ b/drivers/clocksource/tcb_clksrc.c
> @@ -178,12 +178,6 @@ static irqreturn_t ch2_irq(int irq, void *handle)
>  	return IRQ_NONE;
>  }
>  
> -static struct irqaction tc_irqaction = {
> -	.name		= "tc_clkevt",
> -	.flags		= IRQF_TIMER,
> -	.handler	= ch2_irq,
> -};
> -
>  static int __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
>  {
>  	int ret;
> @@ -198,15 +192,16 @@ static int __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
>  
>  	clkevt.regs = tc->regs;
>  	clkevt.clk = t2_clk;
> -	tc_irqaction.dev_id = &clkevt;
>  
>  	timer_clock = clk32k_divisor_idx;
>  
>  	clkevt.clkevt.cpumask = cpumask_of(0);
>  
> -	ret = setup_irq(irq, &tc_irqaction);
> -	if (ret)
> +	ret = request_irq(irq, ch2_irq, IRQF_TIMER, "tc_clkevt", &clkevt);
> +	if (ret) {
> +		clk_disable_unprepare(t2_clk);
>  		return ret;
> +	}
>  
>  	clockevents_config_and_register(&clkevt.clkevt, 32768, 1, 0xffff);
>  



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
