Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab3KYWOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:14:45 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52617 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752813Ab3KYWOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:14:40 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Z8R2hg6OdG6R1X0G6tIV2
Date: Mon, 25 Nov 2013 14:14:38 -0800
From: Tony Lindgren <tony@atomide.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH 6/7] ARM: OMAP: Disable POSTED mode for errata i103 and
 i767
Message-ID: <20131125221437.GW10023@atomide.com>
References: <1385415876-12387-1-git-send-email-joelf@ti.com>
 <1385415876-12387-7-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385415876-12387-7-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joel Fernandes <joelf@ti.com> [131125 13:46]:
> Enabling of Posted mode is seen to cause problems on dmtimer modules on AM33xx
> (much like other OMAPs).  Reference discussions on forums [1] [2]. Earlier
> patch solving this on other OMAPs [3].
> 
> For OMAP SoCs with this errata, the fix has been to not enable Posted mode.
> However, on some SoCs (atleast AM33xx) which carry this errata, Posted mode
> is enabled on reset. So we not only need to ignore enabling of the POSTED bit
> when the timer is requested, but also disable Posted mode if errata is present.

This could explain some occasional lost timers I saw a while back when
testing things.. We most likely should merge for the -rc series with cc stable.

Does this depend on the other patches in this series?

Regards,

Tony
 
> [1] http://e2e.ti.com/support/arm/sitara_arm/f/791/t/285744.aspx
> [2] http://e2e.ti.com/support/arm/sitara_arm/f/791/t/270632.aspx
> [3] http://www.spinics.net/lists/linux-omap/msg81770.html
> 
> Reported-by: Russ Dill <russ.dill@ti.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>  arch/arm/plat-omap/include/plat/dmtimer.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/plat-omap/include/plat/dmtimer.h b/arch/arm/plat-omap/include/plat/dmtimer.h
> index fb92abb..2861b15 100644
> --- a/arch/arm/plat-omap/include/plat/dmtimer.h
> +++ b/arch/arm/plat-omap/include/plat/dmtimer.h
> @@ -336,8 +336,11 @@ static inline void __omap_dm_timer_enable_posted(struct omap_dm_timer *timer)
>  	if (timer->posted)
>  		return;
>  
> -	if (timer->errata & OMAP_TIMER_ERRATA_I103_I767)
> +	if (timer->errata & OMAP_TIMER_ERRATA_I103_I767) {
> +		timer->posted = OMAP_TIMER_NONPOSTED;
> +		__omap_dm_timer_write(timer, OMAP_TIMER_IF_CTRL_REG, 0, 0);
>  		return;
> +	}
>  
>  	__omap_dm_timer_write(timer, OMAP_TIMER_IF_CTRL_REG,
>  			      OMAP_TIMER_CTRL_POSTED, 0);
> -- 
> 1.8.1.2
> 
