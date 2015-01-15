Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbbAOFzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 00:55:01 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:50252 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbbAOFzA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 00:55:00 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        Peter Rosin <peda@lysator.liu.se>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Peter Rosin <peda@axentia.se>, Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: RE: [PATCH RESEND] pm: at91: Workaround DDRSDRC self-refresh bug
 with LPDDR1 memories
Thread-Topic: [PATCH RESEND] pm: at91: Workaround DDRSDRC self-refresh bug
 with LPDDR1 memories
Thread-Index: AQHQL/1eFqmWYAIkMkq1H9gtduZJK5y/TYWAgAFhQ2A=
Date: Thu, 15 Jan 2015 05:54:05 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BFCDFE6C@penmbx01>
References: <1421241632-2991-1-git-send-email-peda@lysator.liu.se>
 <54B69DAB.8010303@atmel.com>
In-Reply-To: <54B69DAB.8010303@atmel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Ferre, Nicolas
> Sent: Thursday, January 15, 2015 12:48 AM
> To: Peter Rosin; linux-arm-kernel@lists.infradead.org; Yang, Wenyou
> Cc: Peter Rosin; Andrew Victor; Jean-Christophe Plagniol-Villard; Russell King;
> linux-kernel@vger.kernel.org; Alexandre Belloni; Boris BREZILLON
> Subject: Re: [PATCH RESEND] pm: at91: Workaround DDRSDRC self-refresh bug
> with LPDDR1 memories
> 
> Le 14/01/2015 14:20, Peter Rosin a écrit :
> > From: Peter Rosin <peda@axentia.se>
> >
> > The DDRSDR controller (on the ATSAMA5D31) fails miserably to put
> > LPDDR1 memories in self-refresh. Force the controller to think it has
> > DDR2 memories during the self-refresh period, as the DDR2 self-refresh
> > spec is equivalent to LPDDR1, and is correctly implemented in the controller.
> >
> > Assume that the second controller has the same fault, and that other
> > CPUs in the family has the same problem, but that is untested.
> >
> > Signed-off-by: Peter Rosin <peda@axentia.se>
> 
> I've just verified your code and the scope of this issue and your implementation
> makes perfect sense.
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Peter,
> Thanks for your patch. You will probably see it appearing in 3.20 or 3.21.
> 
> Wenyou,
> Can you please integrate the patch from Peter in your current rework of the PM
> routines (keeping his authorship of course)?
Of course, I will integrate.

> Please tell me if I can help with this.
> 
> Best regards,
> 
> 
> > ---
> >  arch/arm/mach-at91/pm_slowclock.S  |   43
> +++++++++++++++++++++++++++++++-----
> >  include/soc/at91/at91sam9_ddrsdr.h |    2 +-
> >  2 files changed, 39 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/arm/mach-at91/pm_slowclock.S
> > b/arch/arm/mach-at91/pm_slowclock.S
> > index 20018779bae7..63a9e0b0a17d 100644
> > --- a/arch/arm/mach-at91/pm_slowclock.S
> > +++ b/arch/arm/mach-at91/pm_slowclock.S
> > @@ -143,6 +143,16 @@ ddr_sr_enable:
> >  	cmp	memctrl, #AT91_MEMCTRL_DDRSDR
> >  	bne	sdr_sr_enable
> >
> > +	/* LPDDR1 --> force DDR2 mode during self-refresh */
> > +	ldr	tmp1, [sdramc, #AT91_DDRSDRC_MDR]
> > +	str	tmp1, .saved_sam9_mdr
> > +	bic	tmp1, tmp1, #~AT91_DDRSDRC_MD
> > +	cmp	tmp1, #AT91_DDRSDRC_MD_LOW_POWER_DDR
> > +	ldreq	tmp1, [sdramc, #AT91_DDRSDRC_MDR]
> > +	biceq	tmp1, tmp1, #AT91_DDRSDRC_MD
> > +	orreq	tmp1, tmp1, #AT91_DDRSDRC_MD_DDR2
> > +	streq	tmp1, [sdramc, #AT91_DDRSDRC_MDR]
> > +
> >  	/* prepare for DDRAM self-refresh mode */
> >  	ldr	tmp1, [sdramc, #AT91_DDRSDRC_LPR]
> >  	str	tmp1, .saved_sam9_lpr
> > @@ -151,14 +161,26 @@ ddr_sr_enable:
> >
> >  	/* figure out if we use the second ram controller */
> >  	cmp	ramc1, #0
> > -	ldrne	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
> > -	strne	tmp2, .saved_sam9_lpr1
> > -	bicne	tmp2, #AT91_DDRSDRC_LPCB
> > -	orrne	tmp2, #AT91_DDRSDRC_LPCB_SELF_REFRESH
> > +	beq	ddr_no_2nd_ctrl
> > +
> > +	ldr	tmp2, [ramc1, #AT91_DDRSDRC_MDR]
> > +	str	tmp2, .saved_sam9_mdr1
> > +	bic	tmp2, tmp2, #~AT91_DDRSDRC_MD
> > +	cmp	tmp2, #AT91_DDRSDRC_MD_LOW_POWER_DDR
> > +	ldreq	tmp2, [ramc1, #AT91_DDRSDRC_MDR]
> > +	biceq	tmp2, tmp2, #AT91_DDRSDRC_MD
> > +	orreq	tmp2, tmp2, #AT91_DDRSDRC_MD_DDR2
> > +	streq	tmp2, [ramc1, #AT91_DDRSDRC_MDR]
> > +
> > +	ldr	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
> > +	str	tmp2, .saved_sam9_lpr1
> > +	bic	tmp2, #AT91_DDRSDRC_LPCB
> > +	orr	tmp2, #AT91_DDRSDRC_LPCB_SELF_REFRESH
> >
> >  	/* Enable DDRAM self-refresh mode */
> > +	str	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
> > +ddr_no_2nd_ctrl:
> >  	str	tmp1, [sdramc, #AT91_DDRSDRC_LPR]
> > -	strne	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
> >
> >  	b	sdr_sr_done
> >
> > @@ -289,12 +311,17 @@ sdr_sr_done:
> >  	 */
> >  	cmp	memctrl, #AT91_MEMCTRL_DDRSDR
> >  	bne	sdr_en_restore
> > +	/* Restore MDR in case of LPDDR1 */
> > +	ldr	tmp1, .saved_sam9_mdr
> > +	str	tmp1, [sdramc, #AT91_DDRSDRC_MDR]
> >  	/* Restore LPR on AT91 with DDRAM */
> >  	ldr	tmp1, .saved_sam9_lpr
> >  	str	tmp1, [sdramc, #AT91_DDRSDRC_LPR]
> >
> >  	/* if we use the second ram controller */
> >  	cmp	ramc1, #0
> > +	ldrne	tmp2, .saved_sam9_mdr1
> > +	strne	tmp2, [ramc1, #AT91_DDRSDRC_MDR]
> >  	ldrne	tmp2, .saved_sam9_lpr1
> >  	strne	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
> >
> > @@ -328,5 +355,11 @@ ram_restored:
> >  .saved_sam9_lpr1:
> >  	.word 0
> >
> > +.saved_sam9_mdr:
> > +	.word 0
> > +
> > +.saved_sam9_mdr1:
> > +	.word 0
> > +
> >  ENTRY(at91_slow_clock_sz)
> >  	.word .-at91_slow_clock
> > diff --git a/include/soc/at91/at91sam9_ddrsdr.h
> > b/include/soc/at91/at91sam9_ddrsdr.h
> > index 0210797abf2e..cd2c18787833 100644
> > --- a/include/soc/at91/at91sam9_ddrsdr.h
> > +++ b/include/soc/at91/at91sam9_ddrsdr.h
> > @@ -92,7 +92,7 @@
> >  #define		AT91_DDRSDRC_UPD_MR	(3 << 20)	 /* Update
> load mode register and extended mode register */
> >
> >  #define AT91_DDRSDRC_MDR	0x20	/* Memory Device Register */
> > -#define		AT91_DDRSDRC_MD		(3 << 0)		/* Memory
> Device Type */
> > +#define		AT91_DDRSDRC_MD		(7 << 0)		/* Memory
> Device Type */
> >  #define			AT91_DDRSDRC_MD_SDR		0
> >  #define			AT91_DDRSDRC_MD_LOW_POWER_SDR	1
> >  #define			AT91_DDRSDRC_MD_LOW_POWER_DDR	3
> >
> 
> 
> --
> Nicolas Ferre

Best Regards,
Wenyou Yang
