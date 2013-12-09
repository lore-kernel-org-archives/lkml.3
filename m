Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab3LIB6x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 20:58:53 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:42734 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760192Ab3LIB6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 20:58:51 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.236.217
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19qlGZ9/revaA84PuGvx5Ry
Date: Sun, 8 Dec 2013 17:58:39 -0800
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: bcousson@baylibre.com, Roger Quadros <rogerq@ti.com>,
        tomi.valkeinen@ti.com, balbi@ti.com, sr@denx.de,
        David.Laight@ACULAB.COM, michael@amarulasolutions.com,
        bigeasy@linutronix.de, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: OMAP4+: hwmod data: Don't prevent RESET of USB
 Host module
Message-ID: <20131209015838.GA11433@atomide.com>
References: <1386080748-17005-1-git-send-email-rogerq@ti.com>
 <1386080748-17005-2-git-send-email-rogerq@ti.com>
 <alpine.DEB.2.02.1312090125170.32309@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.02.1312090125170.32309@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Walmsley <paul@pwsan.com> [131208 17:27]:
> Hi Benoît,
> 
> On Tue, 3 Dec 2013, Roger Quadros wrote:
> 
> > Without this, the USB devices are sometimes not detected on OMAP4 Panda
> > with u-boot v2013.10.
> > 
> > Unlike what the comment states, errata i660 does not state that we
> > can't RESET the USB host module. Instead it states that RESET is the
> > only way to recover from a deadlock situation.
> > 
> > RESET ensures that the module is in a known good state irrespective
> > of what bootloader does with the module, so it must be done at boot.
> > 
> > Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> Acked-by: Paul Walmsley <paul@pwsan.com>
> 
> Will you pick this up for the -rc series, or do you want me or Tony to?  
> Roger writes that this one's pretty important.

I suggest that you just queue this with your other fixes so we get
things working.

Regards,

Tony
 
 
> >  arch/arm/mach-omap2/omap_hwmod_44xx_data.c | 12 ++----------
> >  arch/arm/mach-omap2/omap_hwmod_54xx_data.c | 13 +++----------
> >  2 files changed, 5 insertions(+), 20 deletions(-)
> > 
> > diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> > index 1e5b12c..3318cae9 100644
> > --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> > +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> > @@ -2937,7 +2937,7 @@ static struct omap_hwmod_class_sysconfig omap44xx_usb_host_hs_sysc = {
> >  	.sysc_offs	= 0x0010,
> >  	.syss_offs	= 0x0014,
> >  	.sysc_flags	= (SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE |
> > -			   SYSC_HAS_SOFTRESET),
> > +			   SYSC_HAS_SOFTRESET | SYSC_HAS_RESET_STATUS),
> >  	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
> >  			   SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
> >  			   MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
> > @@ -3001,15 +3001,7 @@ static struct omap_hwmod omap44xx_usb_host_hs_hwmod = {
> >  	 * hence HWMOD_SWSUP_MSTANDBY
> >  	 */
> >  
> > -	/*
> > -	 * During system boot; If the hwmod framework resets the module
> > -	 * the module will have smart idle settings; which can lead to deadlock
> > -	 * (above Errata Id:i660); so, dont reset the module during boot;
> > -	 * Use HWMOD_INIT_NO_RESET.
> > -	 */
> > -
> > -	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY |
> > -			  HWMOD_INIT_NO_RESET,
> > +	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
> >  };
> >  
> >  /*
> > diff --git a/arch/arm/mach-omap2/omap_hwmod_54xx_data.c b/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
> > index 9e08d69..e297d62 100644
> > --- a/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
> > +++ b/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
> > @@ -1544,7 +1544,8 @@ static struct omap_hwmod_class_sysconfig omap54xx_usb_host_hs_sysc = {
> >  	.rev_offs	= 0x0000,
> >  	.sysc_offs	= 0x0010,
> >  	.sysc_flags	= (SYSC_HAS_MIDLEMODE | SYSC_HAS_RESET_STATUS |
> > -			   SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET),
> > +			   SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET |
> > +			   SYSC_HAS_RESET_STATUS),
> >  	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
> >  			   SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
> >  			   MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
> > @@ -1598,15 +1599,7 @@ static struct omap_hwmod omap54xx_usb_host_hs_hwmod = {
> >  	 * hence HWMOD_SWSUP_MSTANDBY
> >  	 */
> >  
> > -	/*
> > -	 * During system boot; If the hwmod framework resets the module
> > -	 * the module will have smart idle settings; which can lead to deadlock
> > -	 * (above Errata Id:i660); so, dont reset the module during boot;
> > -	 * Use HWMOD_INIT_NO_RESET.
> > -	 */
> > -
> > -	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY |
> > -			  HWMOD_INIT_NO_RESET,
> > +	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
> >  	.main_clk	= "l3init_60m_fclk",
> >  	.prcm = {
> >  		.omap4 = {
> > -- 
> > 1.8.3.2
> > 
> 
> 
> - Paul

