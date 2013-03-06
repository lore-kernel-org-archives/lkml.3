Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab3CFGWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 01:22:30 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:58899 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab3CFGW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 01:22:28 -0500
Date: Wed, 6 Mar 2013 08:22:18 +0200
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
To: Tony Lindgren <tony@atomide.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 6/9] [media] ir-rx51: fix clock API related build issues
Message-ID: <20130306062218.GA1638@itanic.dhcp.inet.fi>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de>
 <1362521809-22989-7-git-send-email-arnd@arndb.de>
 <20130305212351.4993d8c6@redhat.com>
 <20130306010952.GJ11806@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130306010952.GJ11806@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.05 2013 17:09:53, Tony Lindgren wrote:
> * Mauro Carvalho Chehab <mchehab@redhat.com> [130305 16:28]:
> > Em Tue,  5 Mar 2013 23:16:46 +0100
> > Arnd Bergmann <arnd@arndb.de> escreveu:
> > 
> > > OMAP1 no longer provides its own clock interfaces since patch
> > > a135eaae52 "ARM: OMAP: remove plat/clock.h". This is great, but
> > > we now have to convert the ir-rx51 driver to use the generic
> > > interface from linux/clk.h.
> > > 
> > > The driver also uses the omap_dm_timer_get_fclk() function,
> > > which is not exported for OMAP1, so we have to move the
> > > definition out of the OMAP2 specific section.
> > > 
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> > 
> > From my side:
> > Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> There's just one issue, this driver most likely only needed on
> rx51 board.. So I suggest we just mark the driver depends on
> ARCH_OMAP2PLUS and let's drop this patch.
> 
> This driver is already disabled for ARCH_MULTIPLATFORM
> as we need to move dmtimer.c to drivers and have some minimal
> include/linux/timer-omap.h for it.
>  

I've also had this cunning plan that if or when the PWM subsystem
starts supporting the PWM output in OMAP3, I could convert this driver
to generate the IR carrier wave through the PWM subsystem and then use
HR timers to generate the pulses. I think that's much better approach
than trying to depend on interfaces that are not easily
available. Should be possible, but I haven't proven yet that it will
work :)

Unfortunately I haven't got into executing on that plan yet. In
addition to the challenge of scheduling some of my free time for doing
this, my RX51 device is not enumerating the USB with the latest kernel
and I haven't figured out that yet. And because of that, I haven't
been able to get my user space running over nfsroot setup I've been
using..

-Timo

> > > --- a/arch/arm/plat-omap/dmtimer.c
> > > +++ b/arch/arm/plat-omap/dmtimer.c
> > > @@ -333,6 +333,14 @@ int omap_dm_timer_get_irq(struct omap_dm_timer *timer)
> > >  }
> > >  EXPORT_SYMBOL_GPL(omap_dm_timer_get_irq);
> > >  
> > > +struct clk *omap_dm_timer_get_fclk(struct omap_dm_timer *timer)
> > > +{
> > > +	if (timer)
> > > +		return timer->fclk;
> > > +	return NULL;
> > > +}
> > > +EXPORT_SYMBOL_GPL(omap_dm_timer_get_fclk);
> > > +
> > >  #if defined(CONFIG_ARCH_OMAP1)
> > >  #include <mach/hardware.h>
> > >  /**
> > > @@ -371,14 +379,6 @@ EXPORT_SYMBOL_GPL(omap_dm_timer_modify_idlect_mask);
> > >  
> > >  #else
> > >  
> > > -struct clk *omap_dm_timer_get_fclk(struct omap_dm_timer *timer)
> > > -{
> > > -	if (timer)
> > > -		return timer->fclk;
> > > -	return NULL;
> > > -}
> > > -EXPORT_SYMBOL_GPL(omap_dm_timer_get_fclk);
> > > -
> > >  __u32 omap_dm_timer_modify_idlect_mask(__u32 inputmask)
> > >  {
> > >  	BUG();
> 
> Then omap_dm_timer_get_fclk() won't work on omap1 as there's no
> separate functional clock. We probably should not even export
> this function eventually when things are fixed up.
> 
> Regards,
> 
> Tony
