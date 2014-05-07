Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbaEGPTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:19:15 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:20539 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbaEGPTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:19:13 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18b9b2UFvzEMTf3EG+Co1iy
Date: Wed, 7 May 2014 08:19:08 -0700
From: Tony Lindgren <tony@atomide.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/26] ARM: OMAP: dmtimer: Remove setting of clk parent
 indirectly through platform hook
Message-ID: <20140507151907.GB9502@atomide.com>
References: <1398375849-6017-1-git-send-email-joelf@ti.com>
 <1398375849-6017-2-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398375849-6017-2-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joel Fernandes <joelf@ti.com> [140424 14:44]:
> There is a platform specific hook just for OMAP1 to set its clk parent.  Remove
> this hook and have OMAP1 set its parent in omap1_dm_timer_init.  If OMAP1 is
> ever migrated to clock framework, the correct way to do this would be through
> clk_set_parent like other platforms.
> 
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>  arch/arm/mach-omap1/timer.c                |    8 +++++++-
>  arch/arm/plat-omap/dmtimer.c               |    8 +++-----
>  include/linux/platform_data/dmtimer-omap.h |    2 --
>  3 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/mach-omap1/timer.c b/arch/arm/mach-omap1/timer.c
> index bde7a35..4b9c604 100644
> --- a/arch/arm/mach-omap1/timer.c
> +++ b/arch/arm/mach-omap1/timer.c
> @@ -140,7 +140,13 @@ static int __init omap1_dm_timer_init(void)
>  			goto err_free_pdata;
>  		}
>  
> -		pdata->set_timer_src = omap1_dm_timer_set_src;
> +		/*
> +		 * Since OMAP1 doesn't support clock framework, set timer clock
> +		 * source to 32KHz here instead of expecting it to be set by
> +		 * dmtimer code.
> +		 */
> +		omap1_dm_timer_set_src(pdev, 0x01);
> +
>  		pdata->timer_capability = OMAP_TIMER_ALWON |
>  				OMAP_TIMER_NEEDS_RESET | OMAP_TIMER_HAS_DSP_IRQ;
>  

This does not sound right, omap1 does support clock framework just fine.
It is not using the common clock framework though.

This breaks omap_dm_timer_set_source() for sure. Setting the source
during init is not a right solution here. Probably best to keep the
pdata hook around, drivers can support pdata and DT data together
just fine.

Regards,

Tony
