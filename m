Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3AXRAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 12:00:52 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:41309 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3AXRAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:00:49 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: "Mohammed, Afzal" <afzal@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EA92ADF@DBDE01.ent.ti.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
References: <cover.1358937685.git.afzal@ti.com>
 <fa8dab522507e087d5a94bac13dda71544911707.1358937685.git.afzal@ti.com>
 <20130123202204.9205.66575@quantum>
 <C8443D0743D26F4388EA172BF4E2A7A93EA92ADF@DBDE01.ent.ti.com>
Message-ID: <20130124170044.10623.45314@quantum>
User-Agent: alot/0.3.3+
Subject: Re: RE: [PATCH v4 12/12] video: da8xx-fb: CCF clock divider handling
Date: Thu, 24 Jan 2013 09:00:44 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mohammed, Afzal (2013-01-24 03:36:02)
> Hi Mike,
> 
> On Thu, Jan 24, 2013 at 01:52:04, Mike Turquette wrote:
> > Quoting Afzal Mohammed (2013-01-23 03:48:56)
> 
> > > +static inline void da8xx_fb_clkc_enable(void)
> > > +{
> > >         if (lcd_revision == LCD_VERSION_2)
> > >                 lcdc_write(LCD_V2_DMA_CLK_EN | LCD_V2_LIDD_CLK_EN |
> > >                                 LCD_V2_CORE_CLK_EN, LCD_CLK_ENABLE_REG);
> 
> > > +static inline int da8xx_fb_calc_config_clk_divider(struct da8xx_fb_par *par,
> > > +                                                   struct fb_videomode *mode)
> > > +{
> 
> > > +       ret = clk_set_rate(par->child_clk, PICOS2KHZ(mode->pixclock) * 1000);
> > > +       if (IS_ERR_VALUE(ret)) {
> > > +               dev_err(par->dev, "unable to setup pixel clock of %u ps",
> > > +                       mode->pixclock);
> > > +               return ret;
> > > +       }
> > > +       da8xx_fb_clkc_enable();
> 
> > It looks like you are using the legacy method to enable/disable the
> > clock and using the CCF basic divider to set the rate.  This feels a bit
> > hacky to me.  If you want to model your clock in CCF then you should
> > probably model the whole clock, not just the rate-change aspects of it.
> 
> Initially I thought about it, but seeing requirement of 3 gate clocks
> (due to 3 bits meant for different purposes - DMA, LIDD and CORE
> functionalities), felt that having 4 clocks (3 gate + 1 divider) in
> driver would be an overdesign [leaving a branch instead of a leaf of
> the tree in driver ;)].
> 
> > Have you looked at the composite clock patches from Prashant?  Those
> > might give you the divider+gate properties that you are looking for:
> > http://article.gmane.org/gmane.linux.kernel/1416697
> 
> Thanks for the pointer,
> 
> Now with the composite clock in mind, it was tried to relate to what
> was required for the present scenario.
> 
> So there are 3 - LIDD is actually not for present use case, CORE could
> be clubbed with the divider to have a composite clock. And CORE is
> in functional clock path and logically it's perfectly alright to have
> the composite clock.
> 

Some of the clock names are a bit generic, so a question that I'm going
to repeat throughout my response: "is this clock only inside of your
video IP ?"

Regarding the CORE clock, is this only inside of your IP or are you
referring to the SoC CORE clock which is driven by a DPLL and clocks
DDR and many other peripherals (often MMC, UART, etc)?

Note that this is from my past experience with OMAP, and I'm making an
assumption that the clock scheme between OMAP and Da Vinci/AM335x parts
isn't very different.

Is there a public TRM I can look at?  It would help me understand this
without having to ask you so many annoying questions ;)

> And now we are left with DMA, this is actually in the interface clock
> path which driver in unaware. An option would be to have DMA clock
> as child of CORE plus divider composite clock, even though logically
> DMA can't be considered in the same path.
> 

Why is the driver unaware of the interface clk?  For instance OMAP3 had
separate fclk and iclk for IPs and drivers would call clk_enable on
both.  Or am I misunderstanding something?

In general I don't think the clock subtree should be modeled in a way
that is convenient for software, but instead model the actual hardware.
Trust me, if you don't model the actual hardware then you will be very
confused when you come back and revisit this code in 6 months and can't
remember why things are so weird looking.

Thanks,
Mike

> Also tried not enabling DMA clock, but driver is able to provide
> display without any issues, so was thinking whether to avoid
> instantiating DMA clock at all and hence to have a simple single
> composite clock. Trying to get information internally on whether
> not setting DMA clock bits would actually make a difference.
> 
> If you have any opinion on how to deal here, let me know.
> 
> Regards
> Afzal
