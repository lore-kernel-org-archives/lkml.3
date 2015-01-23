Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbbAWXRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 18:17:43 -0500
Received: from down.free-electrons.com ([37.187.137.238]:54595 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750820AbbAWXRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 18:17:41 -0500
Date: Sat, 24 Jan 2015 00:17:38 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sylvain Rochet <sylvain.rochet@finsecur.com>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, nicolas.ferre@atmel.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, peda@axentia.se,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 08/12] pm: at91: rename file name: pm_slowclock.S
 -->pm_suspend.S
Message-ID: <20150123231738.GB32318@piout.net>
References: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
 <1421741825-18226-9-git-send-email-wenyou.yang@atmel.com>
 <20150123191719.GA29601@gradator.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123191719.GA29601@gradator.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 23/01/2015 at 20:17:19 +0100, Sylvain Rochet wrote :
> Hello Wenyou,
> 
> On Tue, Jan 20, 2015 at 04:17:01PM +0800, Wenyou Yang wrote:
> > 
> > diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
> > new file mode 100644
> > index 0000000..420e730
> > --- /dev/null
> 
> 
> > +	/* Turn off the main oscillator */
> > +	ldr	tmp1, [pmc, #AT91_CKGR_MOR]
> > +	bic	tmp1, tmp1, #AT91_PMC_MOSCEN
> 
> at91sam9x5 and probably others need a key here:
> 	orr     tmp1, tmp1, #AT91_PMC_KEY
> 
> > +	str	tmp1, [pmc, #AT91_CKGR_MOR]
> 
> 
> 
> > +	/* Wait for interrupt */
> > +	mcr	p15, 0, tmp1, c7, c0, 4
> 
> The linux-3.10-at91 branch uses a different approach which seem 
> necessary for newer board, you probably forget to merge the following:
> 
> /*
>  * Put the processor to enter into Standby mode, wait for interrupt to wakeup
>  */
> 	.macro _do_wfi
> 
> #if defined(CONFIG_CPU_V7)
> 	dsb
> 
> 	/* Disable the processor clock */
> 	mov	tmp1, #AT91_PMC_PCK
> 	str	tmp1, [pmc, #AT91_PMC_SCDR]
> 
> 	wfi		@ Wait For Interrupt
> #else
> 	mcr	p15, 0, tmp1, c7, c0, 4
> #endif
> 
> 	.endm
> 
> 	.text
> 
> ENTRY(at91_slow_clock)
> (...)
> 	/* Wait for interrupt */
> 	_do_wfi
> (...)
> 
> 
> 
> 
> > +	/* Turn on the main oscillator */
> > +	ldr	tmp1, [pmc, #AT91_CKGR_MOR]
> > +	orr	tmp1, tmp1, #AT91_PMC_MOSCEN
> 
> at91sam9x5 and probably others need a key here:
>         orr     tmp1, tmp1, #AT91_PMC_KEY
> 
> > +	str	tmp1, [pmc, #AT91_CKGR_MOR]
> 
> 
> 
> What about the following parts which are also in linux-3.10-at91 branch 
> but not in this rework, are they necessary ?
> 
> sdr_sr_done:
> 	/* Disable MPDDRC Clock*/
> 	cmp	ddrcid, #0
> 	beq	2f
> 	bic	tmp2, ddrcid, #0xe0 /* fetch lowest 5 bits */
> 	mov	tmp1, #0x01
> 	mov	tmp1, tmp1, lsl tmp2
> 
> 	tst	ddrcid, #0x20	/* > 32 ? */
> 	beq	1f
> 	str	tmp1, [pmc, #AT91_PMC_PCDR1]
> 	b	2f
> 1:
> 	str	tmp1, [pmc, #AT91_PMC_PCDR]
> 2:
> 
> 	/* Disable DDR Clock */
> 	mov 	tmp1, #AT91_PMC_SYS_DDR
> 	str	tmp1, [pmc, #AT91_PMC_SCDR]
> 
> 
> 
> 
> 	/* Enable MPDDRC Clock*/
> 	cmp	ddrcid, #0
> 	beq	4f
> 	bic	tmp2, ddrcid, #0xe0 /* fetch lowest 5 bits */
> 	mov	tmp1, #0x01
> 	mov	tmp1, tmp1, lsl tmp2
> 
> 	tst	ddrcid, #0x20	/* > 32 ? */
> 	beq	3f
> 	str	tmp1, [pmc, #AT91_PMC_PCER1]
> 	b	4f
> 3:
> 	str	tmp1, [pmc, #AT91_PMC_PCER]
> 4:
> 
> 	/* Enable DDR clock */
> 	mov 	tmp1, #AT91_PMC_SYS_DDR
> 	str	tmp1, [pmc, #AT91_PMC_SCER]
> 
> 

This is a rework, what is part of linux-3.10-at91 and not yet present in
mainline should be part of a following series. I would prefer not mixing
reworks and "new" functionalities (they have been present in the atmel
tree for a while but never mainlined). I would say that PM on 9x5, n12
and sama5 in mainline is clearly not well tested and is lagging behind
the atmel tree.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
