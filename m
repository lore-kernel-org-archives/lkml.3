Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbbAZVs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:48:29 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52419 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464AbbAZVsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:48:24 -0500
Date: Mon, 26 Jan 2015 22:48:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Laura Abbott <lauraa@codeaurora.org>
Subject: Re: N900 v3.19-rc5 arm atags_to_fdt.c is broken
Message-ID: <20150126214821.GA8884@amd>
References: <201501232239.55801@pali>
 <201501232336.36187@pali>
 <20150126161454.GE28663@atomide.com>
 <201501261723.10505@pali>
 <20150126170323.GF28663@atomide.com>
 <alpine.LFD.2.11.1501261318590.1322@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1501261318590.1322@knanqh.ubzr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > $ du -b arch/arm/boot/dts/omap3-n900.dtb 
> > > 70212   arch/arm/boot/dts/omap3-n900.dtb
> > > 
> > > $ echo $((0x10000))
> > > 65536
> > > 
> > > I would say, problem is because omap3-n900 binary DT is too large
> 
> I agree.
> 
> > OK if that's the case, then your patch makes sense to me. It also
> > seems we can have the temporary stack be larger than the initial
> > stack just for atags_to_fdt.
> 
> The stack size isn't the issue, but rather its location.  We need to 
> position it away from the DT data.  The DT size is known and we could 
> use that, plus some room for the insertion of new data coming from the
> ATAG conversion.
> 
> Something like the following would be a more robust solution:
> 
> diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> index 68be901759..89718de9dd 100644
> --- a/arch/arm/boot/compressed/head.S
> +++ b/arch/arm/boot/compressed/head.S
> @@ -263,16 +263,37 @@ restart:	adr	r0, LC0
>  		 * OK... Let's do some funky business here.
>  		 * If we do have a DTB appended to zImage, and we do have
>  		 * an ATAG list around, we want the later to be translated
> -		 * and folded into the former here.  To be on the safe side,
> -		 * let's temporarily move  the stack away into the malloc
> -		 * area.  No GOT fixup has occurred yet, but none of the
> -		 * code we're about to call uses any global variable.
> +		 * and folded into the former here. No GOT fixup has occurred
> +		 * yet, but none of the code we're about to call uses any
> +		 * global variable.
>  		*/
> -		add	sp, sp, #0x10000
> +
> +		/* Get the initial DTB size */
> +		ldr	r5, [r6, #4]
> +#ifndef __ARMEB__
> +		/* convert to little endian */
> +		eor	r1, r5, r5, ror #16
> +		bic	r1, r1, #0x00ff0000
> +		mov	r5, r5, ror #8
> +		eor	r5, r5, r1, lsr #8
> +#endif
> +		/* 50% DTB growth should be good enough */
> +		add	r5, r5, r5, lsr #1
> +		/* preserve 64-bit alignment */
> +		add	r5, r5, #7
> +		bic	r5, r5, #7
> +		/* clamp to 32KB min and 1MB max */
> +		movs	r1, r5, lsr #15
> +		moveq	r5, #(1 << 15)
> +		movs	r1, r5, lsr #20
> +		movne	r5, #(1 << 20)

Dunno. Would it be easier/simpler to just use 1MB, always? Do we
support machines with <16MB RAM?

Best regards,
								

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
