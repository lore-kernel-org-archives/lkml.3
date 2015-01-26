Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbbAZB0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 20:26:36 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:41218 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbbAZB0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 20:26:32 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Sylvain Rochet <sylvain.rochet@finsecur.com>
CC: "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "peda@axentia.se" <peda@axentia.se>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 08/12] pm: at91: rename file name: pm_slowclock.S
 -->pm_suspend.S
Thread-Topic: [PATCH 08/12] pm: at91: rename file name: pm_slowclock.S
 -->pm_suspend.S
Thread-Index: AQHQNIogORwOSblS/UuzMmu/IjbmM5zNkziAgAQPrLA=
Date: Mon, 26 Jan 2015 01:25:13 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BFD32766@penmbx01>
References: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
 <1421741825-18226-9-git-send-email-wenyou.yang@atmel.com>
 <20150123191719.GA29601@gradator.net>
In-Reply-To: <20150123191719.GA29601@gradator.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0Q1Qppd014084

Hi Sylvain,

Thank you for your review.

> -----Original Message-----
> From: Sylvain Rochet [mailto:sylvain.rochet@finsecur.com]
> Sent: Saturday, January 24, 2015 3:17 AM
> To: Yang, Wenyou
> Cc: Ferre, Nicolas; linux@arm.linux.org.uk; linux-kernel@vger.kernel.org;
> alexandre.belloni@free-electrons.com; peda@axentia.se; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH 08/12] pm: at91: rename file name: pm_slowclock.S --
> >pm_suspend.S
> 
> Hello Wenyou,
> 
> On Tue, Jan 20, 2015 at 04:17:01PM +0800, Wenyou Yang wrote:
> >
> > diff --git a/arch/arm/mach-at91/pm_suspend.S
> > b/arch/arm/mach-at91/pm_suspend.S new file mode 100644 index
> > 0000000..420e730
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
Yes, I am preparing the patches to support other SoCs.

> > +	str	tmp1, [pmc, #AT91_CKGR_MOR]
> 
> 
> 
> > +	/* Wait for interrupt */
> > +	mcr	p15, 0, tmp1, c7, c0, 4
> 
> The linux-3.10-at91 branch uses a different approach which seem necessary for
> newer board, you probably forget to merge the following:
> 
> /*
>  * Put the processor to enter into Standby mode, wait for interrupt to wakeup  */
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
I will send the new patch serials to support it in this week. Thanks.

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
> What about the following parts which are also in linux-3.10-at91 branch but not in
> this rework, are they necessary ?
Yes, they are necessary, I will send the next patch serial in this week.

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
> 
> Sylvain

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
