Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab3K3RVy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 12:21:54 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:19947 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751336Ab3K3RVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 12:21:50 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18hLEMRurGErhDPAUcGyAxw
Date: Sat, 30 Nov 2013 09:21:48 -0800
From: Tony Lindgren <tony@atomide.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH 3/3] pinctrl: single: fix infinite loop caused by bad
 mask
Message-ID: <20131130172147.GC23334@atomide.com>
References: <1385638160-30125-1-git-send-email-tomi.valkeinen@ti.com>
 <1385638160-30125-3-git-send-email-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385638160-30125-3-git-send-email-tomi.valkeinen@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tomi Valkeinen <tomi.valkeinen@ti.com> [131128 03:30]:
> If the masks in DT data are not quite right,
> pcs_parse_bits_in_pinctrl_entry() can end up in an infinite loop,
> trashing memory at the same time.
> 
> Add a check to verify that each loop actually removes bits from the
> 'mask', so that the loop can eventually end.

Linus W, might be worth updating the change log with the regression
causing commit. Something like commit 4e7e8017a80e1 (pinctrl: pinctrl-single:
enhance to configure multiple pins of different modules) improved
support for pinctrl-single,bits option, but also caused a regression
in parsing badly configured mask data.

Acked-by: Tony Lindgren <tony@atomide.com>
 
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> ---
>  drivers/pinctrl/pinctrl-single.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
> index 174f4c50cd77..de6459628b4f 100644
> --- a/drivers/pinctrl/pinctrl-single.c
> +++ b/drivers/pinctrl/pinctrl-single.c
> @@ -1318,6 +1318,14 @@ static int pcs_parse_bits_in_pinctrl_entry(struct pcs_device *pcs,
>  			mask_pos = ((pcs->fmask) << (bit_pos - 1));
>  			val_pos = val & mask_pos;
>  			submask = mask & mask_pos;
> +
> +			if ((mask & mask_pos) == 0) {
> +				dev_err(pcs->dev,
> +					"Invalid mask for %s at 0x%x\n",
> +					np->name, offset);
> +				break;
> +			}
> +
>  			mask &= ~mask_pos;
>  
>  			if (submask != mask_pos) {
> -- 
> 1.8.3.2
> 
