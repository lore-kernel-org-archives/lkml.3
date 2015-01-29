Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbbA2MWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:22:25 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45880 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbbA2MWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:22:24 -0500
Date: Thu, 29 Jan 2015 12:22:23 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
Cc: "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "sylvain.rochet@finsecur.com" <sylvain.rochet@finsecur.com>,
        "peda@axentia.se" <peda@axentia.se>,
        "Vilchez, Patrice" <Patrice.VILCHEZ@atmel.com>
Subject: Re: [PATCH 2/7] pm: at91: pm_suspend: add the WFI support for ARMv7
Message-ID: <20150129122223.GA3937@red-moon>
References: <1422266617-24381-1-git-send-email-wenyou.yang@atmel.com>
 <1422266761-24487-1-git-send-email-wenyou.yang@atmel.com>
 <20150128112551.GA13253@e102568-lin.cambridge.arm.com>
 <B256D81BAE5131468A838E5D7A243641BFD38E3C@penmbx01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B256D81BAE5131468A838E5D7A243641BFD38E3C@penmbx01>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2015 at 02:36:01AM +0000, Yang, Wenyou wrote:
> Hi Lorenzo,
> 
> Thank you for your review.
> 
> > -----Original Message-----
> > From: Lorenzo Pieralisi [mailto:lorenzo.pieralisi@arm.com]
> > Sent: Wednesday, January 28, 2015 7:26 PM
> > To: Yang, Wenyou
> > Cc: Ferre, Nicolas; linux@arm.linux.org.uk; linux-arm-kernel@lists.infradead.org;
> > linux-kernel@vger.kernel.org; alexandre.belloni@free-electrons.com;
> > sylvain.rochet@finsecur.com; peda@axentia.se; Vilchez, Patrice
> > Subject: Re: [PATCH 2/7] pm: at91: pm_suspend: add the WFI support for ARMv7
> > 
> > On Mon, Jan 26, 2015 at 10:06:01AM +0000, Wenyou Yang wrote:
> > 
> > Commit log please.
> Added in the v2.0
> 
> > 
> > > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > > ---
> > >  arch/arm/mach-at91/pm_suspend.S |   54
> > ++++++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 53 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm/mach-at91/pm_suspend.S
> > > b/arch/arm/mach-at91/pm_suspend.S index 122a3f1..e796722 100644
> > > --- a/arch/arm/mach-at91/pm_suspend.S
> > > +++ b/arch/arm/mach-at91/pm_suspend.S
> > > @@ -53,6 +53,58 @@ mode	.req	r6
> > >  	beq	1b
> > >  	.endm
> > >
> > > +/*
> > > + * Put the processor to enter the WFI state  */
> > > +	.macro _do_wfi
> > 
> > You will have to explain why you need this, really.
> I don't understand your meaning.

I want to understand why this assembly snippet (that can be rewritten
in C BTW):

/* Disable the processor's clock */
mov	tmp1, #AT91_PMC_PCK
str	tmp1, [pmc, #AT91_PMC_SCDR]

+

cpu_do_idle()

is not sufficient for you, or put it differently, why do you need
this macro.

> 
> > 
> > > +
> > > +#if defined(CONFIG_CPU_V7)
> > > +	/*
> > > +	 * Execute an ISB instruction to flush the pipeline to ensure
> > > +	 * that all of operations have beem completed.
> > 
> > s/beem/been
> Thanks.
> 
> > 
> > > +	 */
> > > +	isb

This isb should not be there, unless you know a reason why it should
and you explain it to me.

> > > +
> > > +	/*
> > > +	 * Execute an ISB instruction to ensure that all of the
> > > +	 * CP15 register changes have been committed.
> > > +	 */
> > > +	dsb
> > 
> > This is a dsb not an isb.
> Changed in the v2.0

Yes, but I still do not understand why you want to execute it before
disabling the clocks (I really hope that by "disabling the clocks" you
mean "set the power controller to a state when, on wfi execution, the
clocks are gated").

> 
> > 
> > > +	dmb
> > 
> > You have to explain why you need every single one of these barriers, otherwise I
> > am NAKing this patch.
> No need this one?

No, remove it.

> 
> > 
> > > +
> > > +	/* Disable the processor's clock */
> > > +	mov	tmp1, #AT91_PMC_PCK
> > > +	str	tmp1, [pmc, #AT91_PMC_SCDR]
> > > +
> > > +	/* Execute a WFI instruction */
> > > +	wfi	@ Wait For Interrupt
> > 
> > This one looks ok :)
> > 
> > > +
> > > +	/*
> > > +	 * CPU can specualatively prefetch the instructions
> > > +	 * so add NOPs after WFI. Sixteen NOPs as Cortex-A5 pipeline.
> > 
> > So what ? I suspect your issue is related to wfi completion on pending IRQ. I
> > would like to know the details that describe the issue you are trying to solve here
> > please.
> Honestly, I referred to others, I will dig more, and test it.

You should not copy and paste code, because:

1) it might be broken
2) and/or unoptimized
3) and/or does not apply to your platform

See my suggestion above, if it does not work for you, you will report the
issue and we will take it from there.

Thanks,
Lorenzo

> 
> > 
> > > +	 */
> > > +	nop
> > > +	nop
> > > +	nop
> > > +	nop
> > > +	nop
> > > +	nop
> > > +	nop
> > > +	nop
> > > +	nop
> > > +	nop
> > > +	nop
> > > +	nop
> > > +	nop
> > > +	nop
> > > +	nop
> > > +	nop
> > > +#else
> > > +	mcr	p15, 0, tmp1, c7, c0, 4
> > > +#endif
> > 
> > Tell us what's the problem you have to solve, first, then we will see how to fix it.
> > 
> > Thanks,
> > Lorenzo
> > 
> > > +
> > > +	.endm
> > > +
> > >  	.text
> > >
> > >  /*
> > > @@ -181,7 +233,7 @@ sdr_sr_done:
> > >
> > >  skip_disable_main_clock:
> > >  	/* Wait for interrupt */
> > > -	mcr	p15, 0, tmp1, c7, c0, 4
> > > +	_do_wfi
> > >
> > >  	tst	mode, #AT91_PM_SLOW_CLOCK
> > >  	beq	skip_enable_main_clock
> > > --
> > > 1.7.9.5
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe
> > > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > >
> 
> Best Regards,
> Wenyou Yang
> 
