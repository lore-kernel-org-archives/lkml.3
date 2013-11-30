Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab3K3RYW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 12:24:22 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:45654 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab3K3RYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 12:24:21 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/so7GVxB+TncCp507Vwbfn
Date: Sat, 30 Nov 2013 09:24:19 -0800
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] pinctrl: single: fix pcs_disable with bits_per_mux
Message-ID: <20131130172418.GD23334@atomide.com>
References: <1385638160-30125-1-git-send-email-tomi.valkeinen@ti.com>
 <1385638160-30125-2-git-send-email-tomi.valkeinen@ti.com>
 <52973061.2070100@ti.com>
 <20131130170700.GB23334@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131130170700.GB23334@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [131130 09:08]:
> * Peter Ujfalusi <peter.ujfalusi@ti.com> [131128 04:01]:
> > On 11/28/2013 01:29 PM, Tomi Valkeinen wrote:
> > > pcs_enable() uses vals->mask instead of pcs->fmask when bits_per_mux is
> > > enabled. However, pcs_disable() always uses pcs->fmask.
> > > 
> > > Fix pcs_disable() to use vals->mask with bits_per_mux.
> > 
> > I wonder how did I missed this?
> 
> Probably because the disable can be a nop for some hardware.
> 
> > Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Linus W, might be worth also mentioning the regression causing commit
here. Commit 9e605cb68a21d5 (pinctrl: pinctrl-single: Add
pinctrl-single,bits type of mux) added support for multiple muxes
in a single register, but forgot to modify pcs_disable() function the
same way as pcs_enable() was modified.
 
> Acked-by: Tony Lindgren <tony@atomide.com>
>  
>  
> > > Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > > ---
> > >  drivers/pinctrl/pinctrl-single.c | 10 ++++++++--
> > >  1 file changed, 8 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
> > > index 829b98c5c66f..174f4c50cd77 100644
> > > --- a/drivers/pinctrl/pinctrl-single.c
> > > +++ b/drivers/pinctrl/pinctrl-single.c
> > > @@ -525,12 +525,18 @@ static void pcs_disable(struct pinctrl_dev *pctldev, unsigned fselector,
> > >  	for (i = 0; i < func->nvals; i++) {
> > >  		struct pcs_func_vals *vals;
> > >  		unsigned long flags;
> > > -		unsigned val;
> > > +		unsigned val, mask;
> > >  
> > >  		vals = &func->vals[i];
> > >  		raw_spin_lock_irqsave(&pcs->lock, flags);
> > >  		val = pcs->read(vals->reg);
> > > -		val &= ~pcs->fmask;
> > > +
> > > +		if (pcs->bits_per_mux)
> > > +			mask = vals->mask;
> > > +		else
> > > +			mask = pcs->fmask;
> > > +
> > > +		val &= ~mask;
> > >  		val |= pcs->foff << pcs->fshift;
> > >  		pcs->write(val, vals->reg);
> > >  		raw_spin_unlock_irqrestore(&pcs->lock, flags);
> > > 
> > 
> > 
> > -- 
> > Péter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
