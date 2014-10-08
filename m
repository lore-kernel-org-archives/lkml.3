Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbaJHLeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:34:18 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25072 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932278AbaJHLeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:34:12 -0400
Date: Wed, 8 Oct 2014 19:31:23 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] irqchip: dw-apb-ictl: add PM support
Message-ID: <20141008193123.11f42bb0@xhacker>
In-Reply-To: <alpine.DEB.2.11.1409302351500.4455@nanos>
References: <1411454100-6814-1-git-send-email-jszhang@marvell.com>
	<1411454100-6814-4-git-send-email-jszhang@marvell.com>
	<542AA336.6070206@gmail.com>
	<alpine.DEB.2.11.1409302351500.4455@nanos>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-08_06:2014-10-08,2014-10-08,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1410080106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas, Sebastian,

On Tue, 30 Sep 2014 14:52:54 -0700
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 30 Sep 2014, Sebastian Hesselbarth wrote:
> > On 09/23/2014 08:35 AM, Jisheng Zhang wrote:
> > > This patch adds in support for S2R for dw-apb-ictl irqchip driver.
> > > 
> > > Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> > > ---
> > >   drivers/irqchip/irq-dw-apb-ictl.c | 19 +++++++++++++++++++
> > >   1 file changed, 19 insertions(+)
> > > 
> > > diff --git a/drivers/irqchip/irq-dw-apb-ictl.c
> > > b/drivers/irqchip/irq-dw-apb-ictl.c
> > > index c136b67..53bb732 100644
> > > --- a/drivers/irqchip/irq-dw-apb-ictl.c
> > > +++ b/drivers/irqchip/irq-dw-apb-ictl.c
> > > @@ -50,6 +50,21 @@ static void dw_apb_ictl_handler(unsigned int irq,
> > > struct irq_desc *desc)
> > >   	chained_irq_exit(chip, desc);
> > >   }
> > > 
> > > +#ifdef CONFIG_PM
> > > +static void dw_apb_ictl_resume(struct irq_data *d)
> > > +{
> > > +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> > > +	struct irq_chip_type *ct = irq_data_get_chip_type(d);
> > > +
> > > +	irq_gc_lock(gc);
> > > +	writel_relaxed(~0, gc->reg_base + ct->regs.enable);
> > > +	writel_relaxed(*ct->mask_cache, gc->reg_base + ct->regs.mask);
> > > +	irq_gc_unlock(gc);
> > > +}
> > 
> > I agree with the overall change, but may this also be suited for a
> > generic irq_chip helper instead of being a driver specific one?
> > 
> > Maybe Thomas or Jason can comment on this.
> 
> If we have enough similar resume callbacks, yes. 
>  
> > Also, now that you are using writel_relaxed, I understand that both
> > writes above can happen in any order? Are there any implication we
> > have to consider, i.e. do we require any of the registers above to
> > be written first?

The registers sits at device type memory, the writes should happen in the same
order as before.

Thanks for reviewing,
Jisheng

> 
> Was about to ask that as well :)
> 
> Thanks,
> 
> 	tglx

