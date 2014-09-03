Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250AbaICK5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:57:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:43430 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbaICK5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:57:41 -0400
Date: Wed, 3 Sep 2014 12:57:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
cc: daniel.lezcano@linaro.org, dongsheng.wang@freescale.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] Clocksource: Flextimer: Fix counter clock prescaler
 calculation.
In-Reply-To: <1409031951-39021-5-git-send-email-Li.Xiubo@freescale.com>
Message-ID: <alpine.DEB.2.10.1409031241310.3333@nanos>
References: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com> <1409031951-39021-5-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Xiubo Li wrote:

> We should minus one after calculating the counter input clock's
> prescaler.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
> ---
>  drivers/clocksource/fsl_ftm_timer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clocksource/fsl_ftm_timer.c b/drivers/clocksource/fsl_ftm_timer.c
> index f70fcf2..974890e 100644
> --- a/drivers/clocksource/fsl_ftm_timer.c
> +++ b/drivers/clocksource/fsl_ftm_timer.c
> @@ -311,7 +311,7 @@ static int __init ftm_calc_closest_round_cyc(unsigned long freq)
>  						HZ * (1 << priv->ps++));
>  	} while (priv->periodic_cyc > 0xFFFF);
>  
> -	if (priv->ps > FTM_PS_MAX) {
> +	if (--priv->ps > FTM_PS_MAX) {

Looking at this makes me run away screaming. Just because you
increment priv->ps unconditionally in the loop above, you decrement it
again here. Why not fix the calculation proper in the first place?

      for (cyc = ~0UL, ps = 0, div = HZ; cyc > 0xffff; ps++, div *= 2)
      	       cyc = DIV_ROUND_CLOSEST(freq, div);

Hmm?

	tglx

