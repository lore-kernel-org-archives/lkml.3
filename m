Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbaI3VxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:53:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:33675 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbaI3Vw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:52:59 -0400
Date: Tue, 30 Sep 2014 23:52:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
cc: Jisheng Zhang <jszhang@marvell.com>, jason@lakedaemon.net,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] irqchip: dw-apb-ictl: add PM support
In-Reply-To: <542AA336.6070206@gmail.com>
Message-ID: <alpine.DEB.2.11.1409302351500.4455@nanos>
References: <1411454100-6814-1-git-send-email-jszhang@marvell.com> <1411454100-6814-4-git-send-email-jszhang@marvell.com> <542AA336.6070206@gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Sebastian Hesselbarth wrote:
> On 09/23/2014 08:35 AM, Jisheng Zhang wrote:
> > This patch adds in support for S2R for dw-apb-ictl irqchip driver.
> > 
> > Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> > ---
> >   drivers/irqchip/irq-dw-apb-ictl.c | 19 +++++++++++++++++++
> >   1 file changed, 19 insertions(+)
> > 
> > diff --git a/drivers/irqchip/irq-dw-apb-ictl.c
> > b/drivers/irqchip/irq-dw-apb-ictl.c
> > index c136b67..53bb732 100644
> > --- a/drivers/irqchip/irq-dw-apb-ictl.c
> > +++ b/drivers/irqchip/irq-dw-apb-ictl.c
> > @@ -50,6 +50,21 @@ static void dw_apb_ictl_handler(unsigned int irq,
> > struct irq_desc *desc)
> >   	chained_irq_exit(chip, desc);
> >   }
> > 
> > +#ifdef CONFIG_PM
> > +static void dw_apb_ictl_resume(struct irq_data *d)
> > +{
> > +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> > +	struct irq_chip_type *ct = irq_data_get_chip_type(d);
> > +
> > +	irq_gc_lock(gc);
> > +	writel_relaxed(~0, gc->reg_base + ct->regs.enable);
> > +	writel_relaxed(*ct->mask_cache, gc->reg_base + ct->regs.mask);
> > +	irq_gc_unlock(gc);
> > +}
> 
> I agree with the overall change, but may this also be suited for a
> generic irq_chip helper instead of being a driver specific one?
> 
> Maybe Thomas or Jason can comment on this.

If we have enough similar resume callbacks, yes. 
 
> Also, now that you are using writel_relaxed, I understand that both
> writes above can happen in any order? Are there any implication we
> have to consider, i.e. do we require any of the registers above to
> be written first?

Was about to ask that as well :)

Thanks,

	tglx
