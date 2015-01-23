Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbbAWXCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 18:02:09 -0500
Received: from down.free-electrons.com ([37.187.137.238]:54425 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751673AbbAWXCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 18:02:06 -0500
Date: Sat, 24 Jan 2015 00:02:00 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sylvain Rochet <sylvain.rochet@finsecur.com>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, nicolas.ferre@atmel.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, peda@axentia.se,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/12] pm: at91: the standby mode uses the same sram
 function as the suspend to memory mode
Message-ID: <20150123230200.GI19922@piout.net>
References: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
 <1421741825-18226-8-git-send-email-wenyou.yang@atmel.com>
 <20150123173234.GA26382@gradator.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123173234.GA26382@gradator.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/2015 at 18:32:34 +0100, Sylvain Rochet wrote :
> Hello Wenyou,
> 
> On Tue, Jan 20, 2015 at 04:17:00PM +0800, Wenyou Yang wrote:
> > 
> > diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
> > index 691e6db..a1010f0 100644
> > --- a/arch/arm/mach-at91/pm.c
> > +++ b/arch/arm/mach-at91/pm.c
>   (...)
> >  static int at91_pm_enter(suspend_state_t state)
> >  {
> >  	at91_pinctrl_gpio_suspend();
> >  
> >  	switch (state) {
> > +	/*
> > +	 * Suspend-to-RAM is like STANDBY plus slow clock mode, so
> > +	 * drivers must suspend more deeply, the master clock switches
> > +	 * to the clk32k and turns off the main oscillator
> > +	 *
> > +	 * STANDBY mode has *all* drivers suspended; ignores irqs not
> > +	 * marked as 'wakeup' event sources; and reduces DRAM power.
> > +	 * But otherwise it's identical to PM_SUSPEND_ON:  cpu idle, and
> > +	 * nothing fancy done with main or cpu clocks.
> > +	 */
> > +	case PM_SUSPEND_MEM:
> > +	case PM_SUSPEND_STANDBY:
>    (...)
> > -		case PM_SUSPEND_MEM:
> > -			/*
> > -			 * Ensure that clocks are in a valid state.
> > -			 */
> > -			if (!at91_pm_verify_clocks())
> > -				goto error;
>    (...)
> > +		if (!at91_pm_verify_clocks())
> > +			goto error;
> >  
>    (...)
> > -		case PM_SUSPEND_STANDBY:
> > -			/*
> > -			 * NOTE: the Wait-for-Interrupt instruction needs to be
> 
> By doing that at91_pm_verify_clocks() is now called for both MEM and 
> STANDBY targets.
> 
> In my opinion this function is misnamed and should be called 
> at91_pm_verify_clocks_for_slow_clock_mode(). This function actually 
> checks if we can safely switch to slow clock mode, if some peripherals 
> are still using the master clock, we abort the suspend because we can't 
> suspend in good condition. Hard unclocking peripherals which ask for a 
> soft stop, like USB controllers, is something we should avoid doing.
> 
> This function checks if USB PLL and PLL B are stopped, if PCK0..PCK3 are 
> stopped too (or just using the 32k clock). If all drivers suspended 
> correctly this is the state we expect and we can suspend in a deep 
> state.
> 
> Not this is currently not the case in linux-next, suspend/resume support 
> to all Atmel USB drivers (ehci-atmel,ohci-at91,atmel_usba,at91_udc) are 
> in my series:
>  [PATCHv7 0/6] USB: host: Atmel OHCI and EHCI drivers improvements
>    <1421761144-11767-1-git-send-email-sylvain.rochet@finsecur.com>
>  [PATCHv6 0/5] USB: gadget: atmel_usba_udc: Driver improvements 
>    <1421945805-31129-1-git-send-email-sylvain.rochet@finsecur.com>
> 
> We are not going to change any clock for STANDBY target, there is no 
> clock to check, so we don't need to call at91_pm_verify_clocks() for 
> this target.
> 

I think we should actually stop checking those clocks. In the meantime,
you are right and at91_pm_verify_clocks must not be called
unconditionally.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
