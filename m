Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbbA1U0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:26:41 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52094 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750AbbA1U0i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:26:38 -0500
Date: Wed, 28 Jan 2015 11:25:52 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: "nicolas.ferre@atmel.com" <nicolas.ferre@atmel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "sylvain.rochet@finsecur.com" <sylvain.rochet@finsecur.com>,
        "peda@axentia.se" <peda@axentia.se>,
        "Patrice.VILCHEZ@atmel.com" <Patrice.VILCHEZ@atmel.com>
Subject: Re: [PATCH 2/7] pm: at91: pm_suspend: add the WFI support for ARMv7
Message-ID: <20150128112551.GA13253@e102568-lin.cambridge.arm.com>
References: <1422266617-24381-1-git-send-email-wenyou.yang@atmel.com>
 <1422266761-24487-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
In-Reply-To: <1422266761-24487-1-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 28 Jan 2015 11:25:53.0932 (UTC) FILETIME=[2D886CC0:01D03AED]
X-MC-Unique: 115012811255605801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 10:06:01AM +0000, Wenyou Yang wrote:

Commit log please.

> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> ---
>  arch/arm/mach-at91/pm_suspend.S |   54 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 53 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
> index 122a3f1..e796722 100644
> --- a/arch/arm/mach-at91/pm_suspend.S
> +++ b/arch/arm/mach-at91/pm_suspend.S
> @@ -53,6 +53,58 @@ mode	.req	r6
>  	beq	1b
>  	.endm
>  
> +/*
> + * Put the processor to enter the WFI state
> + */
> +	.macro _do_wfi

You will have to explain why you need this, really.

> +
> +#if defined(CONFIG_CPU_V7)
> +	/*
> +	 * Execute an ISB instruction to flush the pipeline to ensure
> +	 * that all of operations have beem completed.

s/beem/been

> +	 */
> +	isb
> +
> +	/*
> +	 * Execute an ISB instruction to ensure that all of the
> +	 * CP15 register changes have been committed.
> +	 */
> +	dsb

This is a dsb not an isb.

> +	dmb

You have to explain why you need every single one of these barriers,
otherwise I am NAKing this patch.

> +
> +	/* Disable the processor's clock */
> +	mov	tmp1, #AT91_PMC_PCK
> +	str	tmp1, [pmc, #AT91_PMC_SCDR]
> +
> +	/* Execute a WFI instruction */
> +	wfi	@ Wait For Interrupt

This one looks ok :)

> +
> +	/*
> +	 * CPU can specualatively prefetch the instructions
> +	 * so add NOPs after WFI. Sixteen NOPs as Cortex-A5 pipeline.

So what ? I suspect your issue is related to wfi completion on pending
IRQ. I would like to know the details that describe the issue you are
trying to solve here please.

> +	 */
> +	nop
> +	nop
> +	nop
> +	nop
> +	nop
> +	nop
> +	nop
> +	nop
> +	nop
> +	nop
> +	nop
> +	nop
> +	nop
> +	nop
> +	nop
> +	nop
> +#else
> +	mcr	p15, 0, tmp1, c7, c0, 4
> +#endif

Tell us what's the problem you have to solve, first, then we will see how
to fix it.

Thanks,
Lorenzo

> +
> +	.endm
> +
>  	.text
>  
>  /*
> @@ -181,7 +233,7 @@ sdr_sr_done:
>  
>  skip_disable_main_clock:
>  	/* Wait for interrupt */
> -	mcr	p15, 0, tmp1, c7, c0, 4
> +	_do_wfi
>  
>  	tst	mode, #AT91_PM_SLOW_CLOCK
>  	beq	skip_enable_main_clock
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

