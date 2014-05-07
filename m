Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbaEGPZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:25:27 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:34974 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaEGPZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:25:26 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19IBSsTAIgc1xYnfXhrkFyL
Date: Wed, 7 May 2014 08:25:22 -0700
From: Tony Lindgren <tony@atomide.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/26] ARM: OMAP: dmtimer: Add function to check if timer
 is running
Message-ID: <20140507152521.GE9502@atomide.com>
References: <1398375849-6017-1-git-send-email-joelf@ti.com>
 <1398375849-6017-5-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398375849-6017-5-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joel Fernandes <joelf@ti.com> [140424 14:44]:
> Inorder to move non-DM timer specific code that modifies the "idlect"
> mask on OMAP1, from dmtimer code, to OMAP1 specific timer initialization code,
> we introduce a new function that can possibly be reused for other purposes in
> the future. The function just checks if a timer is running based on the timer ID
> which should be same as pdev->id. This allows us to cleanly separate the timer vs
> non-timer bits and keep the timer bits in the dmtimer code.
> 
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>  arch/arm/plat-omap/dmtimer.c              |   29 +++++++++++++++++++++++++++++
>  arch/arm/plat-omap/include/plat/dmtimer.h |    2 ++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
> index 4debb3d..86b2641 100644
> --- a/arch/arm/plat-omap/dmtimer.c
> +++ b/arch/arm/plat-omap/dmtimer.c
> @@ -187,6 +187,35 @@ int omap_dm_timer_reserve_systimer(int id)
>  	return 0;
>  }
>  
> +/*
> + * Check if a timer is running based on timer_id, used for OMAP1 currently.
> + */
> +int omap_dm_timer_is_running(int timer_id)
> +{
> +	int i = 1, ret = 0;
> +	struct omap_dm_timer *timer = NULL;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dm_timer_lock, flags);
> +	list_for_each_entry(timer, &omap_timer_list, node) {
> +		if (i == timer_id) {
> +			u32 l;
> +			l = omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
> +			if (l & OMAP_TIMER_CTRL_ST) {
> +				ret = 1;
> +				goto done;
> +			} else {
> +				goto done;
> +			}
> +		}
> +		i++;
> +	}
> +done:
> +	spin_unlock_irqrestore(&dm_timer_lock, flags);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(omap_dm_timer_is_running);

Let's not add new exported custom functions, let's instead try to get
rid of them. What needs to use this one?

Regards,


Tony
