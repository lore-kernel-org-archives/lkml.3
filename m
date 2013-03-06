Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab3CFAYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 19:24:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab3CFAYV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 19:24:21 -0500
Date: Tue, 5 Mar 2013 21:23:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 6/9] [media] ir-rx51: fix clock API related build issues
Message-ID: <20130305212351.4993d8c6@redhat.com>
In-Reply-To: <1362521809-22989-7-git-send-email-arnd@arndb.de>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de>
	<1362521809-22989-7-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue,  5 Mar 2013 23:16:46 +0100
Arnd Bergmann <arnd@arndb.de> escreveu:

> OMAP1 no longer provides its own clock interfaces since patch
> a135eaae52 "ARM: OMAP: remove plat/clock.h". This is great, but
> we now have to convert the ir-rx51 driver to use the generic
> interface from linux/clk.h.
> 
> The driver also uses the omap_dm_timer_get_fclk() function,
> which is not exported for OMAP1, so we have to move the
> definition out of the OMAP2 specific section.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>

>From my side:
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-media@vger.kernel.org
> ---
>  arch/arm/plat-omap/dmtimer.c | 16 ++++++++--------
>  drivers/media/rc/ir-rx51.c   |  4 ++--
>  2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
> index a0daa2f..ea133e5 100644
> --- a/arch/arm/plat-omap/dmtimer.c
> +++ b/arch/arm/plat-omap/dmtimer.c
> @@ -333,6 +333,14 @@ int omap_dm_timer_get_irq(struct omap_dm_timer *timer)
>  }
>  EXPORT_SYMBOL_GPL(omap_dm_timer_get_irq);
>  
> +struct clk *omap_dm_timer_get_fclk(struct omap_dm_timer *timer)
> +{
> +	if (timer)
> +		return timer->fclk;
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(omap_dm_timer_get_fclk);
> +
>  #if defined(CONFIG_ARCH_OMAP1)
>  #include <mach/hardware.h>
>  /**
> @@ -371,14 +379,6 @@ EXPORT_SYMBOL_GPL(omap_dm_timer_modify_idlect_mask);
>  
>  #else
>  
> -struct clk *omap_dm_timer_get_fclk(struct omap_dm_timer *timer)
> -{
> -	if (timer)
> -		return timer->fclk;
> -	return NULL;
> -}
> -EXPORT_SYMBOL_GPL(omap_dm_timer_get_fclk);
> -
>  __u32 omap_dm_timer_modify_idlect_mask(__u32 inputmask)
>  {
>  	BUG();
> diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
> index 8ead492..d1364a1 100644
> --- a/drivers/media/rc/ir-rx51.c
> +++ b/drivers/media/rc/ir-rx51.c
> @@ -25,9 +25,9 @@
>  #include <linux/platform_device.h>
>  #include <linux/sched.h>
>  #include <linux/wait.h>
> +#include <linux/clk.h>
>  
>  #include <plat/dmtimer.h>
> -#include <plat/clock.h>
>  
>  #include <media/lirc.h>
>  #include <media/lirc_dev.h>
> @@ -209,7 +209,7 @@ static int lirc_rx51_init_port(struct lirc_rx51 *lirc_rx51)
>  	}
>  
>  	clk_fclk = omap_dm_timer_get_fclk(lirc_rx51->pwm_timer);
> -	lirc_rx51->fclk_khz = clk_fclk->rate / 1000;
> +	lirc_rx51->fclk_khz = clk_get_rate(clk_fclk) / 1000;
>  
>  	return 0;
>  


-- 

Cheers,
Mauro
