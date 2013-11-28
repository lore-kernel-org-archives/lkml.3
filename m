Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738Ab3K1MAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 07:00:36 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44944 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758604Ab3K1MAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 07:00:31 -0500
Message-ID: <52973061.2070100@ti.com>
Date: Thu, 28 Nov 2013 14:00:33 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, Tony Lindgren <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] pinctrl: single: fix pcs_disable with bits_per_mux
References: <1385638160-30125-1-git-send-email-tomi.valkeinen@ti.com> <1385638160-30125-2-git-send-email-tomi.valkeinen@ti.com>
In-Reply-To: <1385638160-30125-2-git-send-email-tomi.valkeinen@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2013 01:29 PM, Tomi Valkeinen wrote:
> pcs_enable() uses vals->mask instead of pcs->fmask when bits_per_mux is
> enabled. However, pcs_disable() always uses pcs->fmask.
> 
> Fix pcs_disable() to use vals->mask with bits_per_mux.

I wonder how did I missed this?

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> 
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> ---
>  drivers/pinctrl/pinctrl-single.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
> index 829b98c5c66f..174f4c50cd77 100644
> --- a/drivers/pinctrl/pinctrl-single.c
> +++ b/drivers/pinctrl/pinctrl-single.c
> @@ -525,12 +525,18 @@ static void pcs_disable(struct pinctrl_dev *pctldev, unsigned fselector,
>  	for (i = 0; i < func->nvals; i++) {
>  		struct pcs_func_vals *vals;
>  		unsigned long flags;
> -		unsigned val;
> +		unsigned val, mask;
>  
>  		vals = &func->vals[i];
>  		raw_spin_lock_irqsave(&pcs->lock, flags);
>  		val = pcs->read(vals->reg);
> -		val &= ~pcs->fmask;
> +
> +		if (pcs->bits_per_mux)
> +			mask = vals->mask;
> +		else
> +			mask = pcs->fmask;
> +
> +		val &= ~mask;
>  		val |= pcs->foff << pcs->fshift;
>  		pcs->write(val, vals->reg);
>  		raw_spin_unlock_irqrestore(&pcs->lock, flags);
> 


-- 
Péter
