Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbbARSH6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 13:07:58 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:44930 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbbARSHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 13:07:54 -0500
Date: Sun, 18 Jan 2015 18:07:47 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: arm: mach-ux500: board-mop500-regulators.c: Remove
 unused function
Message-ID: <20150118180747.GK3574@x1>
References: <1420126805-28098-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <5939350.DKrZ01egfS@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5939350.DKrZ01egfS@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Jan 2015, Arnd Bergmann wrote:

> On Thursday 01 January 2015 16:40:05 Rickard Strandqvist wrote:
> > Remove the function mop500_regulator_init() that is not used anywhere.
> > 
> > This was partially found by using a static code analysis program called cppcheck.
> > 
> > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> 
> This looks wrong: For one thing, you failed to notice that now another function
> in the same file becomes unused, or that half of the file is not used
> anyway.
> 
> It also seems that the fact that this function is not called was an accident
> and it should in fact be called. Maybe Lee has some more insight in this,
> as he added the function in the first place.
> 
> Finally (unrelated to your patch, but triggered by looking at it), I suspect
> we should just move the ab8500_regulator_plat_data and everything it references
> to drivers/regulator/ab8500-ext.c, because we only have one instance of it
> and won't ever have more.

This is old code.  The development of this stuff was halted before it
could be finished.  Feel free to remove it and all other unused code
it uncovers.

> > ---
> >  arch/arm/mach-ux500/board-mop500-regulators.c |   41 -------------------------
> >  arch/arm/mach-ux500/board-mop500-regulators.h |    2 --
> >  2 files changed, 43 deletions(-)
> > 
> > diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
> > index 32d744e..156e83b 100644
> > --- a/arch/arm/mach-ux500/board-mop500-regulators.c
> > +++ b/arch/arm/mach-ux500/board-mop500-regulators.c
> > @@ -1022,44 +1022,3 @@ static void ab8500_modify_reg_init(int id, u8 mask, u8 value)
> >  
> >  	BUG_ON(1);
> >  }
> > -
> > -void mop500_regulator_init(void)
> > -{
> > -	struct regulator_init_data *regulator;
> > -
> > -	/*
> > -	 * Temporarily turn on Vaux2 on 8520 machine
> > -	 */
> > -	if (cpu_is_u8520()) {
> > -		/* Vaux2 initialized to be on */
> > -		ab8500_modify_reg_init(AB8505_VAUX12REGU, 0x0f, 0x05);
> > -	}
> > -
> > -	/*
> > -	 * Handle AB8500_EXT_SUPPLY2 on HREFP_V20_V50 boards (do it for
> > -	 * all HREFP_V20 boards)
> > -	 */
> > -	if (cpu_is_u8500v20()) {
> > -		/* VextSupply2RequestCtrl =  HP/OFF depending on VxRequest */
> > -		ab8500_modify_reg_init(AB8500_REGUREQUESTCTRL3, 0x01, 0x01);
> > -
> > -		/* VextSupply2SysClkReq1HPValid = SysClkReq1 controlled */
> > -		ab8500_modify_reg_init(AB8500_REGUSYSCLKREQ1HPVALID2,
> > -			0x20, 0x20);
> > -
> > -		/* VextSupply2 = force HP at initialization */
> > -		ab8500_modify_reg_init(AB8500_EXTSUPPLYREGU, 0x0c, 0x04);
> > -
> > -		/* enable VextSupply2 during platform active */
> > -		regulator = &ab8500_ext_regulators[AB8500_EXT_SUPPLY2];
> > -		regulator->constraints.always_on = 1;
> > -
> > -		/* disable VextSupply2 in suspend */
> > -		regulator = &ab8500_ext_regulators[AB8500_EXT_SUPPLY2];
> > -		regulator->constraints.state_mem.disabled = 1;
> > -		regulator->constraints.state_standby.disabled = 1;
> > -
> > -		/* enable VextSupply2 HW control (used in suspend) */
> > -		regulator->driver_data = (void *)&ab8500_ext_supply2;
> > -	}
> > -}
> > diff --git a/arch/arm/mach-ux500/board-mop500-regulators.h b/arch/arm/mach-ux500/board-mop500-regulators.h
> > index 9bece38..dc3ee77 100644
> > --- a/arch/arm/mach-ux500/board-mop500-regulators.h
> > +++ b/arch/arm/mach-ux500/board-mop500-regulators.h
> > @@ -19,6 +19,4 @@ extern struct ab8500_regulator_platform_data ab8505_regulator_plat_data;
> >  extern struct regulator_init_data tps61052_regulator;
> >  extern struct regulator_init_data gpio_en_3v3_regulator;
> >  
> > -void mop500_regulator_init(void);
> > -
> >  #endif
> > 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
